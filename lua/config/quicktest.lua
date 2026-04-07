local M = {}

M.config = function()
  local qt = require('quicktest')

  qt.setup({
    adapters = {
      require('quicktest.adapters.golang')({
        args = function(bufnt, args)
          vim.list_extend(args, { '-count=1' })
          return args
        end,
        env = function(bufnt, env)
          env['TEST_USE_LOCAL_DB'] = 'true'
          return env
        end,
      }),
      require('quicktest.adapters.vitest'),
      require('quicktest.adapters.elixir'),
      require('quicktest.adapters.dart'),
      require('quicktest.adapters.rspec'),
    },
    default_win_mode = 'split',
    use_builtin_colorizer = true,
  })
end

M.keys = {
  { '<leader>tl', function() require('quicktest').run_line() end, desc = 'Test Run Line' },
  { '<leader>tf', function() require('quicktest').run_file() end, desc = 'Test Run File' },
  { '<leader>ta', function() require('quicktest').run_all() end, desc = 'Test Run All' },
  { '<leader>tp', function() require('quicktest').run_previous() end, desc = 'Test Run Previous' },
  { '<leader>tt', function() require('quicktest').toggle_win('split') end, desc = 'Test Toggle Window' },
  { '<leader>tc', function() require('quicktest').cancel_current_run() end, desc = 'Test Cancel run' },
}

return M
