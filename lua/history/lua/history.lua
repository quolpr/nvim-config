local a = require 'plenary.async'
local u = require 'plenary.async.util'

local sender, receiver = a.control.channel.mpsc()

-- TODO: use uv.cwd instead of getcwd

local function get_log_path(cwd)
  local safe_filename = cwd:gsub('[/\\]', '_'):gsub(':', '_')

  local dir = vim.fn.stdpath 'data' .. '/history/'

  if vim.fn.isdirectory(dir) == 0 then
    vim.fn.mkdir(dir, 'p')
  end

  return dir .. safe_filename .. '.log'
end

local _log_fd = nil
local _opened_cwd = nil
local function open_fd(cwd)
  if _log_fd and _opened_cwd == cwd then
    return _log_fd
  end

  if _log_fd then
    a.uv.fs_close(_log_fd)
  end

  local file_path = get_log_path(cwd)
  local err, fd = a.uv.fs_open(file_path, 'a+', 438)
  assert(not err, err)

  _log_fd = fd
  _opened_cwd = cwd

  return fd
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
  -- Ensure both paths end with a slash for consistent comparison
  cwd = cwd .. (cwd:sub(-1) == '/' and '' or '/')
  file_path = file_path .. (file_path:sub(-1) == '/' and '' or '/')
  -- Check if the cwd is a prefix of the file path
  return file_path:sub(1, #cwd) == cwd
end

a.void(function()
  while true do
    ::loop::
    local current_path = receiver.recv()

    u.scheduler()
    local cwd = vim.fn.getcwd()
    local log_fd = open_fd(cwd)

    if not (file_exists(current_path) and is_cwd_in_file_path(cwd, vim.fn.fnamemodify(current_path, ':p'))) then
      goto loop
    end

    local err, stat = a.uv.fs_fstat(log_fd)
    assert(not err, err)

    -- Ограничение файла 50 строками
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

local function history()
  local cwd = vim.fn.getcwd()
  local log_fd = open_fd(cwd)
  a.void(function()
    local err, stat = a.uv.fs_fstat(log_fd)
    assert(not err, err)

    local err, data = a.uv.fs_read(log_fd, stat.size, 0)
    assert(not err, err)

    local lines = vim.split(data, '\n', { plain = true, trimempty = true })

    -- Remove the cwd from each line
    local relative_lines = {}
    for i, line in ipairs(lines) do
      -- Ensure to add a '/' to the end of cwd to avoid partial match removals
      local pattern = '^' .. vim.pesc(cwd) .. '/'
      local res = line:gsub(pattern, '')

      table.insert(relative_lines, res)
    end

    u.scheduler()

    require('fzf-lua').fzf_exec(relative_lines, {
      actions = require('fzf-lua').defaults.actions.files,
      previewer = 'builtin',
    })
  end)()
end

return history
