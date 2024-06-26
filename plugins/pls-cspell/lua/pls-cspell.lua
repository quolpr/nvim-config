local M = {}

-- local uv = vim.loop
--
-- local Job = require 'plenary.job'
-- local stdin = uv.new_pipe(false)
--
-- local was_closed = false
-- local function on_lines(_, buf, _, firstline, lastline, new_lastline, _)
--   local lines = vim.api.nvim_buf_get_lines(buf, firstline, new_lastline, false)
--   local text = table.concat(lines, '\n')
--
--   stdin:write(text)
--
--   if not was_closed then
--     was_closed = true
--
--     stdin:close()
--   end
--
--   print 'wrote to stdin'
-- end

function M.setup()
  -- local job = Job:new {
  --   command = 'cspell',
  --   args = { 'lint', '-c', '~/.config/nvim/cspell.json', '--show-suggestions', '--no-progress', 'stdin' },
  --
  --   on_stdout = function(_, data)
  --     print('cspell', data)
  --   end,
  --   on_stderr = function(_, data)
  --     print('cspell', data)
  --   end,
  --
  --   on_exit = function(j, return_val)
  --     print 'cspell exit!'
  --   end,
  --   writer = stdin,
  -- }
  --
  -- job:start()
  --
  -- print('started pid', job.pid)
  --
  -- -- vim.api.nvim_create_autocmd('BufEnter', {
  -- --   callback = function(ev1)
  -- vim.api.nvim_create_autocmd({ 'TextChanged', 'TextChangedI' }, {
  --   callback = function(ev2)
  --     on_lines(nil, ev2.buf, nil, 0, -1, vim.api.nvim_buf_line_count(ev2.buf), 0)
  --   end,
  -- })
  -- --   end,
  -- -- })
end

return M
