return function()
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
