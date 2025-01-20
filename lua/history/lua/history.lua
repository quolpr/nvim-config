local a = require 'plenary.async'
local u = require 'plenary.async.util'
local sender, receiver = a.control.channel.mpsc()

-- Get current git branch name or pwd if no git
local function get_git_branch()
  -- Try to get git branch first
  local handle = io.popen 'git rev-parse --abbrev-ref HEAD 2>/dev/null'
  if handle then
    local branch = handle:read '*a'
    handle:close()
    if branch and branch ~= '' then
      return branch:gsub('\n', '')
    end
  end

  -- If no git branch found, use last directory name from pwd
  local cwd = vim.fn.getcwd()
  return vim.fn.fnamemodify(cwd, ':t')
end

local function get_log_paths(cwd)
  local branch = get_git_branch()
  local safe_filename = cwd:gsub('[/\\]', '_'):gsub(':', '_')
  local safe_branch = branch:gsub('[/\\]', '_'):gsub(':', '_')
  local dir = vim.fn.stdpath 'data' .. '/history/'
  if vim.fn.isdirectory(dir) == 0 then
    vim.fn.mkdir(dir, 'p')
  end
  return {
    history = dir .. safe_filename .. '_' .. safe_branch .. '.log',
    counts = dir .. safe_filename .. '_' .. safe_branch .. '.counts',
  }
end

local _log_fd = nil
local _count_fd = nil
local _opened_cwd = nil
local _opened_branch = nil
local _count_cache = nil

-- Open both file descriptors
local function open_fds(cwd)
  local current_branch = get_git_branch()
  if _log_fd and _opened_cwd == cwd and _opened_branch == current_branch then
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
  _opened_branch = current_branch
  _count_cache = nil

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
  _count_cache = counts

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

vim.api.nvim_create_autocmd('BufEnter', {
  pattern = '*',
  callback = function()
    local current_path = vim.api.nvim_buf_get_name(0)
    local new_branch = get_git_branch()
    if _opened_branch and new_branch ~= _opened_branch then
      a.void(function()
        -- Close files in async context
        if _log_fd then
          a.uv.fs_close(_log_fd)
          _log_fd = nil
        end
        if _count_fd then
          a.uv.fs_close(_count_fd)
          _count_fd = nil
        end
        _opened_branch = nil
        _count_cache = nil

        if current_path == '' then
          return
        end
        sender.send(current_path)
      end)()
    else
      if current_path == '' then
        return
      end
      sender.send(current_path)
    end
  end,
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
        vim.bo[tmpbuf].filetype = filetype
      end
    else
      vim.api.nvim_buf_set_lines(tmpbuf, 0, -1, false, { 'File not found:', full_path })
    end

    self:set_preview_buf(tmpbuf)
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

local M = {}

-- Modified history function
function M.history()
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

-- Function to get recent files for status line
function M.recent_files()
  -- Function to truncate the last directory and filename using Neovim's API
  local function truncate_last_dir_and_filename(file_path)
    -- Get the directory containing the file
    local dir = vim.fn.fnamemodify(file_path, ':h')
    -- Extract the last directory name
    local last_dir = vim.fn.fnamemodify(dir, ':t')
    -- Get the filename
    local filename = vim.fn.fnamemodify(file_path, ':t')

    -- Handle files with and without extensions
    local truncated_path
    if string.find(filename, '%.') then
      local base, ext = string.match(filename, '(.-)%.([^%.]+)$')
      if last_dir == '.' then
        truncated_path = base .. '.' .. ext
      else
        truncated_path = last_dir .. '/' .. base .. '.' .. ext
      end
    else
      -- No extension case
      if last_dir == '.' then
        truncated_path = filename
      else
        truncated_path = last_dir .. '/' .. filename
      end
    end

    return truncated_path
  end

  -- Get current working directory and paths
  local cwd = vim.fn.getcwd()
  local paths = get_log_paths(cwd)
  local max_files = 7 -- Show top 5 recent files

  -- Get current file for highlighting
  local current_file = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':.')

  -- Read the counts file first
  local counts = {}

  if _count_cache ~= nil then
    for path, count in pairs(_count_cache) do
      local relative_path = vim.fn.fnamemodify(path, ':.')
      counts[relative_path] = count
    end
  else
    local count_file = io.open(paths.counts, 'r')
    if count_file then
      for line in count_file:lines() do
        local path, count = line:match '(.+),(%d+)'
        if path and count then
          -- Convert to relative path for comparison
          local relative_path = vim.fn.fnamemodify(path, ':.')
          counts[relative_path] = tonumber(count)
        end
      end
      count_file:close()
    end
  end

  -- Read the history file and create entries table
  local entries = {}
  local file = io.open(paths.history, 'r')
  if file then
    for line in file:lines() do
      local relative_path = vim.fn.fnamemodify(line, ':.')
      local count = counts[relative_path] or 0
      table.insert(entries, {
        path = relative_path,
        count = count,
        truncated = truncate_last_dir_and_filename(relative_path),
      })
    end
    file:close()
  end

  -- Sort entries by count (highest first)
  table.sort(entries, function(a, b)
    return a.count > b.count
  end)

  for i = max_files + 1, #entries do
    if entries[i] then
      entries[i] = nil
    end
  end

  -- Check if current file is in the list
  local current_file_in_list = false
  for _, entry in ipairs(entries) do
    if entry.path == current_file then
      current_file_in_list = true
      break
    end
  end

  -- Add current file if not in list
  if not current_file_in_list and current_file ~= '' then
    table.insert(entries, {
      path = current_file,
      count = counts[current_file] or 0,
      truncated = truncate_last_dir_and_filename(current_file),
    })
  end

  -- Format the output
  local contents = {}
  for i = 1, #entries do
    local entry = entries[i]
    if entry.path == current_file then
      contents[i] = string.format('%%#HarpoonCurrentNumber# %s. %%#HarpoonCurrent#%s %%#HarpoonCount#[%d] ', i, entry.truncated, entry.count)
    else
      contents[i] = string.format('%%#HarpoonNumberInactive# %s. %%#HarpoonInactive#%s %%#HarpoonCount#[%d] ', i, entry.truncated, entry.count)
    end
  end

  return table.concat(contents)
end
-- Create a file selection function
local function select_recent_file(index)
  local cwd = vim.fn.getcwd()
  local paths = get_log_paths(cwd)

  -- Read the counts file first
  local counts = {}
  local count_file = io.open(paths.counts, 'r')
  if count_file then
    for line in count_file:lines() do
      local path, count = line:match '(.+),(%d+)'
      if path and count then
        local relative_path = vim.fn.fnamemodify(path, ':.')
        counts[relative_path] = tonumber(count)
      end
    end
    count_file:close()
  end

  -- Read and sort entries
  local entries = {}
  local file = io.open(paths.history, 'r')
  if file then
    for line in file:lines() do
      local relative_path = vim.fn.fnamemodify(line, ':.')
      local count = counts[relative_path] or 0
      table.insert(entries, {
        path = relative_path,
        count = count,
      })
    end
    file:close()
  end

  -- Sort entries by count
  table.sort(entries, function(a, b)
    return a.count > b.count
  end)

  -- Select the file if index is valid
  if entries[index] then
    local target_path = entries[index].path
    -- Get full path for buffer matching
    local full_path = vim.fn.fnamemodify(target_path, ':p')

    -- Try to find existing buffer
    local target_buf = nil
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      local buf_path = vim.api.nvim_buf_get_name(buf)
      if buf_path == full_path then
        target_buf = buf
        break
      end
    end

    if target_buf then
      -- If buffer exists, switch to it
      vim.api.nvim_win_set_buf(0, target_buf)
    else
      -- If buffer doesn't exist, create it
      vim.cmd('edit ' .. target_path)
    end
  end
end

-- Set up keymaps
for i = 1, 7 do
  vim.keymap.set('n', '<leader>' .. i, function()
    select_recent_file(i)
  end, { desc = 'Go to Recent File ' .. i })
end

vim.cmd [[
  hi default HarpoonNumberInactive guifg=#6c7086
  hi default HarpoonInactive guifg=#6c7086
  hi default HarpoonCurrentNumber guifg=#f9e2af gui=bold
  hi default HarpoonCurrent guifg=#f9e2af gui=bold
  hi default HarpoonCount guifg=#45475a  " Darker color for counts
]]

return M
