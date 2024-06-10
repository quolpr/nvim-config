local M = {}

local ts = require 'gotest.ts'
local a = require 'plenary.async'
local Job = require 'plenary.job'

---@class LogEntry
---@field Action '"start"' | '"run"' | '"pause"' | '"cont"' | '"pass"' | '"bench"' | '"fail"' | '"output"' | '"skip"'
---@field Package string
---@field Time string
---@field Test? string
---@field Output? string
---@field Elapsed? number

--- @params module string
--- @params func_names string[]
--- @params sub_func_names string?
--- @return string[]
function M.build_args(module, func_names, sub_func_names)
  local args = {
    'test',
  }

  if module and module ~= '.' then
    table.insert(args, module)
  end

  local sub_testcase_name = nil

  if #func_names == 1 then
    sub_testcase_name = ts.get_tbl_testcase_name()

    if not sub_testcase_name then
      sub_testcase_name = ts.get_sub_testcase_name()
    end
  end

  local run_arg = nil

  if #func_names > 0 then
    func_names = vim.tbl_map(function(v)
      return string.format([[^\Q%s\E$]], v)
    end, func_names)

    run_arg = string.format([[%s]], vim.fn.join(func_names, '|'))
  end

  if #func_names == 1 and sub_func_names then
    local subtest_name = string.match(sub_func_names, [["(.+)"]])

    if subtest_name then
      run_arg = vim.fn.join({ run_arg, string.format([[^\Q%s\E$]], subtest_name) }, '/')
    end
  end

  if run_arg then
    table.insert(args, string.format('-run=%s', run_arg))
  end
  table.insert(args, '-v')
  table.insert(args, '-json')
  table.insert(args, '-race')
  table.insert(args, '-count=1')

  return args
end

--- @param cwd string
--- @param args string[]
--- @return  {recv: fun(): {type: 'stdout', data: LogEntry} | {type: 'stderr', error: string} | {type: 'exit', code: number}}
function M.run(cwd, args)
  local sender, receiver = a.control.channel.mpsc()

  Job:new({
    command = 'go',
    args = args,
    cwd = cwd,
    on_stdout = function(_, data)
      --- @type LogEntry
      local res = vim.json.decode(data)

      if res.Output and res.Output ~= '' then
        res.Output = res.Output:gsub('\n', ' '):gsub('\t', ' '):gsub('%s+', ' '):gsub('^%s+', '')
      end

      sender.send { type = 'stdout', data = res }
    end,
    on_stderr = function(_, data)
      sender.send { type = 'stderr', error = data }
    end,
    on_exit = function(_, return_val)
      sender.send { type = 'exit', code = return_val }
    end,
  }):start()

  return receiver

  -- print 'process done'
  -- local proc = nio.process.run {
  --   cmd = 'go',
  --   args = args,
  --   cwd = cwd,
  -- }
  --
  -- if not proc then
  --   return {}, { 'Failed to spawn go test' }, 1
  -- end
  --
  -- --
  -- -- local tests_failed = exit_code ~= 0
  --
  -- -- print 'porcess is running!'
  --
  -- -- local err_output = proc.stderr.read()
  -- -- print 'reading err'jk
  -- --
  -- -- print(vim.inspect(err_output))
  -- -- if err_output ~= '' then
  -- --   local lines = vim.split(err_output, '\n')
  -- --   return {}, lines
  -- -- end
  --
  -- local output = proc.stdout.read()
  -- proc.stdout:
  -- -- print 'reading output'
  -- if not output then
  --   return {}, { 'Failed to read go test output' }, 1
  -- end
  -- -- print(vim.inspect(output))
  --
  -- local filtered = vim.tbl_filter(function(line)
  --   return line ~= ''
  -- end, vim.split(output, '\n'))
  --
  -- --- @type LogEntry[]
  -- local results = vim.tbl_map(function(line)
  --   --- @type LogEntry
  --   local res = vim.json.decode(line)
  --
  --   if res.Output and res.Output ~= '' then
  --     res.Output = res.Output:gsub('\n', ' '):gsub('\t', ' '):gsub('%s+', ' '):gsub('^%s+', '')
  --   end
  --
  --   return res
  -- end, filtered)
  --
  -- local exit_code = proc.result(false)
  -- return results, {}, exit_code
  -- return {}, {}, 0
end

return M
