local Popup = require 'nui.popup'
local Split = require 'nui.split'
local api = vim.api
local ts = require 'gotest.ts'
local notify = require 'gotest.notify'
local cmd = require 'gotest.cmd'
local event = require('nui.utils.autocmd').event
local a = require 'plenary.async'
local u = require 'plenary.async.util'
--- @type Baleia
local baleia = nil

local M = {}

---@diagnostic disable-next-line: unused-local
function M.setup(args)
  baleia = require('baleia').setup {
    async = false,
  }
end

local split_buf = api.nvim_create_buf(false, true)
local popup_buf = api.nvim_create_buf(false, true)

local buffers = { split_buf, popup_buf }

local is_split_opened = false
local is_popup_opened = false

--- @type {id: number, pid: number?} | nil
local current_job = nil

---@alias win_mode 'popup' | 'split'

local function get_current_module_path()
  local path = vim.fn.expand '%:p:h'
  local relative_path = vim.fn.fnamemodify(path, ':.')

  if path == relative_path then
    return '.'
  end

  return './' .. relative_path
end

local function show_diagnostics(bufnr, ns, results)
  local diagnostics = {}

  for _, result in ipairs(results) do
    if result.Action == 'fail' then
      local line_no = ts.get_func_def_line_no(bufnr, result.Test)

      if line_no then
        table.insert(diagnostics, {
          lnum = line_no,
          col = 0,
          severity = vim.diagnostic.severity.ERROR,
          message = 'FAILED',
          source = 'Test',
          user_data = 'test',
        })
      end
    end
  end

  vim.diagnostic.set(ns, bufnr, diagnostics, {})
end

local function open_popup()
  local popupid = nil
  local popup = Popup {
    enter = true,
    bufnr = popup_buf,
    focusable = true,
    border = {
      style = 'rounded',
    },
    position = '50%',
    size = {
      width = '80%',
      height = '60%',
    },
  }

  popup:on(event.WinClosed, function()
    is_popup_opened = false
    if popupid then
      vim.api.nvim_win_close(popupid, false)
    end
  end, { once = true })

  popup:mount()

  is_popup_opened = true

  return popup
end

local function open_split()
  local popupid = nil

  local split = Split {
    relative = 'editor',
    position = 'bottom',
    size = '30%',
    bufnr = split_buf,
    enter = false,
  }

  split:on(event.WinClosed, function()
    is_split_opened = false
    if popupid then
      vim.api.nvim_win_close(popupid, false)
    end
  end, { once = true })

  -- mount/open the component
  split:mount()

  vim.api.nvim_win_set_option(split.winid, 'statusline', '')
  vim.api.nvim_win_set_option(split.winid, 'laststatus', 0)

  is_split_opened = true
end

local function try_open_split()
  if not is_split_opened then
    open_split()
  end
end

local function try_open_popup()
  if not is_popup_opened then
    open_popup()
  end
end

----@param mode win_mode
local function try_open(mode)
  if mode == 'popup' then
    try_open_popup()
  else
    try_open_split()
  end
end

local ns = vim.api.nvim_create_namespace 'gotests'
local previous_run = nil

--- @param buf number
local function scroll_down(buf)
  local windows = vim.api.nvim_list_wins()
  for _, win in ipairs(windows) do
    local win_bufnr = vim.api.nvim_win_get_buf(win)
    if win_bufnr == buf then
      local line_count = vim.api.nvim_buf_line_count(buf)

      if line_count < 3 then
        return
      end

      vim.api.nvim_win_set_cursor(win, { line_count - 2, 0 })
    end
  end
end

local function should_continue_scroll(buf)
  local windows = vim.api.nvim_list_wins()
  for _, win in ipairs(windows) do
    local win_bufnr = vim.api.nvim_win_get_buf(win)
    if win_bufnr == buf then
      local current_pos = vim.api.nvim_win_get_cursor(win)
      local line_count = vim.api.nvim_buf_line_count(buf)

      return current_pos[1] >= line_count - 2
    end
  end
end

--- @param current_buffer number
--- @param func_names string[]
--- @param sub_func_names string?
--- @param cwd string
--- @param module string
function M.run(current_buffer, func_names, sub_func_names, cwd, module)
  if current_job then
    if current_job.pid then
      vim.system({ 'kill', tostring(current_job.pid) }):wait()
      current_job = nil
    else
      -- Can't gracefully handle this case for now
      return notify.warn 'Already running'
    end
  end

  --- @type {id: number, pid: number?, exit_code: number?}
  local job = { id = math.random(10000000000000000) }
  current_job = job
  previous_run = { func_names, sub_func_names, cwd, module }
  local current_time = vim.loop.now()

  local is_running = function()
    return current_job and job.id == current_job.id
  end

  local print_status = function()
    for _, buf in ipairs(buffers) do
      local line_count = vim.api.nvim_buf_line_count(buf)

      local passedTime = vim.loop.now() - current_time
      local time_display = string.format('%.2f', passedTime / 1000) .. 's'

      if job.exit_code == nil then
        baleia.buf_set_lines(buf, line_count - 1, line_count, false, {
          'Running ' .. time_display,
        })
        vim.api.nvim_buf_add_highlight(buf, -1, 'DiagnosticInfo', line_count - 1, 0, -1)
      else
        if job.exit_code ~= 0 then
          baleia.buf_set_lines(buf, line_count - 1, line_count, false, { 'Failed ' .. time_display })

          vim.api.nvim_buf_add_highlight(buf, -1, 'DiagnosticError', line_count - 1, 0, -1)
        else
          baleia.buf_set_lines(buf, line_count - 1, line_count, false, { 'Passed ' .. time_display })

          vim.api.nvim_buf_add_highlight(buf, -1, 'DiagnosticOk', line_count - 1, 0, -1)
        end
      end
    end
  end

  for _, buf in ipairs(buffers) do
    baleia.buf_set_lines(buf, 0, -1, false, {})

    scroll_down(buf)
  end

  local args = cmd.build_args(module, func_names, sub_func_names)

  ---@diagnostic disable-next-line: missing-parameter
  a.run(function()
    local cloned_args = { unpack(args, 2, 2 + #args) }

    for _, buf in ipairs(buffers) do
      baleia.buf_set_lines(buf, 0, -1, false, {
        'Running test: ' .. table.concat(cloned_args, ' '),
        '',
        '',
        '',
      })
      scroll_down(buf)
    end

    ---@diagnostic disable-next-line: missing-parameter
    a.run(function()
      while is_running() do
        print_status()
        u.sleep(100)
      end
    end)

    local pid, receiver = cmd.run(cwd, args)

    job.pid = pid

    local results = {}
    while is_running() do
      local result = receiver.recv()

      u.scheduler()

      if not is_running() then
        return
      end

      for _, buf in ipairs(buffers) do
        local should_scroll = should_continue_scroll(buf)
        if result.type == 'exit' then
          job.exit_code = result.code

          print_status()
          show_diagnostics(current_buffer, ns, results)
          current_job = nil
        end

        if result.type == 'stdout' then
          if result.data.Output then
            local line_count = vim.api.nvim_buf_line_count(buf)
            local lines = vim.split(result.data.Output, '\n')

            table.insert(lines, '')
            table.insert(lines, '')

            baleia.buf_set_lines(buf, line_count - 2, -1, false, lines)

            print_status()
          end

          table.insert(results, result.data)
        end

        if result.type == 'stderr' then
          local line_count = vim.api.nvim_buf_line_count(buf)
          local lines = vim.split(result.error, '\n')

          table.insert(lines, '')
          table.insert(lines, '')
          if #lines > 0 then
            baleia.buf_set_lines(buf, line_count - 2, -1, false, lines)

            for i = 0, #lines - 1 do
              vim.api.nvim_buf_add_highlight(buf, -1, 'DiagnosticError', line_count - 2 + i, 0, -1)
            end

            print_status()
          end
        end

        if should_scroll then
          scroll_down(buf)
        end
      end
    end
  end)
end

--- @param mode win_mode
function M.run_current(mode)
  mode = mode or 'popup'

  if not vim.endswith(vim.fn.expand '%', '_test.go') then
    return notify.warn 'No go test file'
  end

  local current_buffer = api.nvim_get_current_buf()
  local func_names = ts.get_nearest_func_names()
  local sub_func_names = ts.get_sub_testcase_name()
  local module = get_current_module_path()
  local cwd = vim.fn.getcwd()

  if not func_names or #func_names == 0 then
    return notify.warn 'No tests to run'
  end

  try_open(mode)

  M.run(current_buffer, func_names, sub_func_names, cwd, module)
end

--- @param mode win_mode
function M.run_file(mode)
  mode = mode or 'popup'

  if not vim.endswith(vim.fn.expand '%', '_test.go') then
    return notify.warn 'No go test file'
  end

  local current_buffer = api.nvim_get_current_buf()
  local func_names = ts.get_func_names()
  local module = get_current_module_path()
  local cwd = vim.fn.getcwd()

  if not func_names or #func_names == 0 then
    return notify.warn 'No tests to run'
  end

  try_open(mode)

  M.run(current_buffer, func_names, nil, cwd, module)
end

--- @param mode win_mode
function M.run_previous(mode)
  mode = mode or 'popup'

  if not previous_run then
    return notify.warn 'No previous run'
  end

  local current_buffer = api.nvim_get_current_buf()
  local func_names, sub_func_names, cwd, module = unpack(previous_run)

  try_open(mode)

  M.run(current_buffer, func_names, sub_func_names, cwd, module)
end

--- @param mode win_mode
function M.open(mode)
  try_open(mode)
end

function M.current_win_mode()
  if is_split_opened then
    return 'split'
  elseif is_popup_opened then
    return 'popup'
  else
    return 'popup'
  end
end

-- if baleia == nil then
--   baleia = require('baleia').setup {
--     async = false,
--   }
-- end
-- M.open 'split'
--
-- M.run(api.nvim_get_current_buf(), { 'TestSum' }, nil, '/Users/quolpr/.config/nvim/go_test', './abc')
-- require('plenary.reload').reload_module('gotest', false)

return M
