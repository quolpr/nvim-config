local a = require 'plenary.async'
local u = require 'plenary.async.util'
local sender, receiver = a.control.channel.mpsc()

-- Get paths for both history and count logs
local function get_log_paths(cwd)
  local safe_filename = cwd:gsub('[/\\]', '_'):gsub(':', '_')
  local dir = vim.fn.stdpath 'data' .. '/history/'
  if vim.fn.isdirectory(dir) == 0 then
    vim.fn.mkdir(dir, 'p')
  end
  return {
    history = dir .. safe_filename .. '.log',
    counts = dir .. safe_filename .. '.counts',
  }
end

local _log_fd = nil
local _count_fd = nil
local _opened_cwd = nil

-- Open both file descriptors
local function open_fds(cwd)
  if _log_fd and _opened_cwd == cwd then
    return _log_fd, _count_fd
  end

  if _log_fd then
    a.uv.fs_close(_log_fd)
  end
  if _count_fd then
    a.uv.fs_close(_count_fd)
  end

  local paths = get_log_paths(cwd)

  local err, log_fd = a.uv.fs_open(paths.history, 'a+', 438)
  assert(not err, err)

  local err, count_fd = a.uv.fs_open(paths.counts, 'a+', 438)
  assert(not err, err)

  _log_fd = log_fd
  _count_fd = count_fd
  _opened_cwd = cwd

  return log_fd, count_fd
end

local function file_exists(path)
  local err, fd = a.uv.fs_open(path, 'r', 438)
  if not err then
    local err = a.uv.fs_close(fd)
    assert(not err, err)
    return true
  end
  return not string.find(err, 'ENOENT')
end

local function is_cwd_in_file_path(cwd, file_path)
  cwd = cwd .. (cwd:sub(-1) == '/' and '' or '/')
  file_path = file_path .. (file_path:sub(-1) == '/' and '' or '/')
  return file_path:sub(1, #cwd) == cwd
end

-- Read the count file and return a table of path -> count
local function read_counts(count_fd)
  local counts = {}
  local err, stat = a.uv.fs_fstat(count_fd)
  assert(not err, err)

  if stat.size > 0 then
    local err, data = a.uv.fs_read(count_fd, stat.size, 0)
    assert(not err, err)
    for _, line in ipairs(vim.split(data, '\n', { plain = true, trimempty = true })) do
      local path, count = line:match '(.+),(%d+)'
      if path and count then
        counts[path] = tonumber(count)
      end
    end
  end
  return counts
end

-- Write counts back to file
local function write_counts(count_fd, counts)
  local lines = {}
  for path, count in pairs(counts) do
    table.insert(lines, string.format('%s,%d', path, count))
  end
  local err = a.uv.fs_ftruncate(count_fd, 0)
  assert(not err, err)
  if #lines > 0 then
    local err = a.uv.fs_write(count_fd, table.concat(lines, '\n') .. '\n')
    assert(not err, err)
  end
end

-- Update count for a path
local function increment_count(count_fd, path)
  local counts = read_counts(count_fd)
  counts[path] = (counts[path] or 0) + 1
  write_counts(count_fd, counts)
end

-- Background process for handling file opens
a.void(function()
  while true do
    ::loop::
    local current_path = receiver.recv()
    u.scheduler()
    local cwd = vim.fn.getcwd()
    local log_fd, count_fd = open_fds(cwd)

    if not (file_exists(current_path) and is_cwd_in_file_path(cwd, vim.fn.fnamemodify(current_path, ':p'))) then
      goto loop
    end

    -- Update the count first
    increment_count(count_fd, current_path)

    -- Then update the history log as before
    local err, stat = a.uv.fs_fstat(log_fd)
    assert(not err, err)

    local max_lines = 50
    local lines_to_keep = max_lines - 1
    local new_lines = { current_path }

    if stat.size > 0 then
      local err, data = a.uv.fs_read(log_fd, stat.size, 0)
      assert(not err, err)
      local lines = vim.split(data, '\n', { plain = true, trimempty = true })
      for _, line in ipairs(lines) do
        if line ~= current_path and vim.trim(line):len() ~= 0 then
          new_lines[#new_lines + 1] = line
        end
      end
      new_lines = vim.list_slice(new_lines, 1, lines_to_keep + 1)
      local err = a.uv.fs_ftruncate(log_fd, 0)
      assert(not err, err)
      local err = a.uv.fs_write(log_fd, table.concat(new_lines, '\n'))
      assert(not err, err)
    else
      local err = a.uv.fs_write(log_fd, current_path .. '\n')
      assert(not err, err)
    end
  end
end)()

local function write_path_async()
  local current_path = vim.api.nvim_buf_get_name(0)
  if current_path == '' then
    return
  end
  sender.send(current_path)
end

vim.api.nvim_create_autocmd('BufEnter', {
  pattern = '*',
  callback = write_path_async,
})

local builtin = require 'fzf-lua.previewer.builtin'
local HistoryPreviewer = builtin.base:extend()

function HistoryPreviewer:new(o, opts, fzf_win)
  HistoryPreviewer.super.new(self, o, opts, fzf_win)
  setmetatable(self, HistoryPreviewer)
  return self
end

function HistoryPreviewer:populate_preview_buf(entry_str)
  local filepath = entry_str:match '%]%s+(.+)$'
  if filepath then
    local full_path = vim.fn.getcwd() .. '/' .. filepath
    local tmpbuf = self:get_tmp_buffer()

    if vim.fn.filereadable(full_path) == 1 then
      -- read file content
      local lines = vim.fn.readfile(full_path)
      vim.api.nvim_buf_set_lines(tmpbuf, 0, -1, false, lines)

      -- detect and set filetype for syntax highlighting
      local filetype = vim.filetype.match { filename = full_path }
      if filetype then
        vim.api.nvim_buf_set_option(tmpbuf, 'filetype', filetype)
      end
    else
      vim.api.nvim_buf_set_lines(tmpbuf, 0, -1, false, { 'File not found:', full_path })
    end

    self:set_preview_buf(tmpbuf)
    self.win:update_scrollbar()
  end
end

-- Disable line numbering and word wrap
function HistoryPreviewer:gen_winopts()
  local new_winopts = {
    wrap = false,
    number = false,
  }
  return vim.tbl_extend('force', self.winopts, new_winopts)
end

-- Modified history function
local function history()
  local cwd = vim.fn.getcwd()

  local current_buffer = vim.api.nvim_buf_get_name(0)
  -- Get current buffer's path relative to cwd
  if current_buffer ~= '' then
    current_buffer = vim.fn.fnamemodify(current_buffer, ':.')
  end
  a.void(function()
    local log_fd, count_fd = open_fds(cwd)

    -- Read counts
    local counts = read_counts(count_fd)

    -- Read history
    local err, stat = a.uv.fs_fstat(log_fd)
    assert(not err, err)
    local err, data = a.uv.fs_read(log_fd, stat.size, 0)
    assert(not err, err)
    local lines = vim.split(data, '\n', { plain = true, trimempty = true })

    -- Create entries, excluding current buffer
    local entries = {}
    for i, line in ipairs(lines) do
      local pattern = '^' .. vim.pesc(cwd) .. '/'
      local relative_path = line:gsub(pattern, '')

      -- Skip if this is the current buffer
      if relative_path ~= current_buffer then
        local count = counts[line] or 0
        table.insert(entries, {
          path = relative_path,
          count = count,
        })
      end
    end

    -- Create display strings
    local display_entries = {}
    for _, entry in ipairs(entries) do
      table.insert(display_entries, string.format('[%03d] %s', entry.count, entry.path))
    end

    -- Only proceed if we have entries to show
    if #display_entries > 0 then
      u.scheduler()

      local fzf_lua = require 'fzf-lua'
      fzf_lua.fzf_exec(display_entries, {
        previewer = HistoryPreviewer,
        prompt = 'History> ',
        actions = {
          ['default'] = function(selected)
            if selected and selected[1] then
              local path = selected[1]:match '%]%s+(.+)$'
              if path then
                vim.cmd('edit ' .. path)
              end
            end
          end,
        },
        fzf_opts = {
          ['--tiebreak'] = 'index',
          ['--no-separator'] = '',
        },
      })
    else
      print 'No history entries available'
    end
  end)()
end

return history
