local Popup = require 'nui.popup'
local Split = require 'nui.split'
local api = vim.api
local ts = require 'gotest.ts'
local notify = require 'gotest.notify'
local cmd = require 'gotest.cmd'
local event = require('nui.utils.autocmd').event
local a = require 'plenary.async'
local u = require 'plenary.async.util'

local M = {}
---@diagnostic disable-next-line: unused-local
function M.setup(args) end

local split_buf = api.nvim_create_buf(false, true)
local popup_buf = api.nvim_create_buf(false, true)
local buffers = { split_buf, popup_buf }

local is_split_opened = false
local is_popup_opened = false
local is_running = false

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
  end)

  -- popup:on(event.BufLeave, function()
  --   is_popup_opened = false
  --   popup:unmount()
  -- end)

  popup:mount()

  is_popup_opened = true

  return popup
end

local function open_split()
  local split = Split {
    relative = 'editor',
    position = 'bottom',
    size = '30%',
    bufnr = split_buf,
    enter = false,
  }

  split:on(event.WinClosed, function()
    is_split_opened = false
  end)

  -- mount/open the component
  split:mount()

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

---@param mode win_mode
local function try_open(mode)
  if mode == 'popup' then
    try_open_popup()
  else
    try_open_split()
  end
end

local ns = vim.api.nvim_create_namespace 'gotests'
local previous_run = nil

--- @param current_buffer number
--- @param func_names string[]
--- @param sub_func_names string?
--- @param cwd string
--- @param module string
function M.run(current_buffer, func_names, sub_func_names, cwd, module)
  if is_running then
    return notify.warn 'Already running'
  end

  is_running = true
  previous_run = { func_names, sub_func_names, cwd, module }

  for _, buf in ipairs(buffers) do
    api.nvim_buf_set_lines(buf, 0, -1, false, {})
  end

  local args = cmd.build_args(module, func_names, sub_func_names)

  ---@diagnostic disable-next-line: missing-parameter
  a.run(function()
    local current_time = vim.loop.now()

    local cloned_args = { unpack(args, 2, 2 + #args) }

    for _, buf in ipairs(buffers) do
      vim.api.nvim_buf_set_lines(buf, 0, 1, false, {
        'Running test: ' .. table.concat(cloned_args, ' '),
      })
    end

    ---@diagnostic disable-next-line: missing-parameter
    a.run(function()
      while is_running do
        local passedTime = vim.loop.now() - current_time
        -- todo: add spinner
        for _, buf in ipairs(buffers) do
          vim.api.nvim_buf_set_lines(buf, 1, 2, false, {
            'Time elapsed: ' .. string.format('%.2f', passedTime / 1000) .. 's',
          })
        end
        u.sleep(100)
      end
    end)
    for _, buf in ipairs(buffers) do
      vim.api.nvim_buf_set_lines(buf, 2, 4, false, { 'Status: running', '' })
      vim.api.nvim_buf_add_highlight(buf, -1, 'DiagnosticInfo', 2, 0, -1)
    end

    local receiver = cmd.run(cwd, args)

    local results = {}
    while is_running do
      local result = receiver.recv()

      u.scheduler()

      if result.type == 'exit' then
        for _, buf in ipairs(buffers) do
          if result.code ~= 0 then
            vim.api.nvim_buf_set_lines(buf, 2, 4, false, { 'Status: failed', '' })
            vim.api.nvim_buf_add_highlight(buf, -1, 'DiagnosticError', 2, 0, -1)
          else
            vim.api.nvim_buf_set_lines(buf, 2, 4, false, { 'Status: passed', '' })
            vim.api.nvim_buf_add_highlight(buf, -1, 'DiagnosticOk', 2, 0, -1)
          end
        end

        print('show_diagnostics', vim.inspect(results))
        show_diagnostics(current_buffer, ns, results)
        is_running = false
      end

      if result.type == 'stdout' then
        for _, buf in ipairs(buffers) do
          if result.data.Output then
            local line_count = vim.api.nvim_buf_line_count(buf)

            local lines = vim.split(result.data.Output, '\n')
            vim.api.nvim_buf_set_lines(buf, line_count, -1, false, lines)
          end
        end

        table.insert(results, result.data)
      end

      if result.type == 'stderr' then
        local lines = vim.split(result.error, '\n')
        for _, buf in ipairs(buffers) do
          if #lines > 0 then
            vim.api.nvim_buf_set_lines(buf, 4, -1, false, lines)

            for i = 0, #lines - 1 do
              vim.api.nvim_buf_add_highlight(buf, -1, 'DiagnosticError', 4 + i, 0, -1)
            end
          end
        end
      end
    end

    -- u.scheduler()
    --
    --
    -- is_done = true
    --
    -- for _, buf in ipairs(buffers) do
    --   if #errors > 0 then
    --     vim.api.nvim_buf_set_lines(buf, 4, -1, false, errors)
    --
    --     for i = 0, #errors - 1 do
    --       vim.api.nvim_buf_add_highlight(buf, -1, 'DiagnosticError', 4 + i, 0, -1)
    --     end
    --
    --     return
    --   end
    -- end
    --
    -- u.scheduler()
    --
    -- local lines_to_show = {}
    --
    -- for _, result in ipairs(results) do
    --   local line = result.Output
    --   if line then
    --     local stripedNewLine = string.gsub(line, '\n', '')
    --     table.insert(lines_to_show, stripedNewLine)
    --   end
    -- end
    --
    -- -- vim.api.nvim_buf_set_text(popup.bufnr, 1, 0, -1, -1, vim.split(vim.inspect(results), '\n'))
    -- for _, buf in ipairs(buffers) do
    --   vim.api.nvim_buf_set_lines(buf, 4, -1, false, lines_to_show)
    -- end
    --
    --
    -- is_running = false
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

-- M.open 'popup'
-- M.run(api.nvim_get_current_buf(), { 'TestSum' }, nil, '/Users/quolpr/.config/nvim/go_test', './abc')
-- require('plenary.reload').reload_module('gotest', false)

return M
