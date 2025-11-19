return {
  {
    'quolpr/quicktest.nvim',
    branch = 'main',
    config = function()
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
          --   -- bin = function(path)
          --   --   print(path)
          --   --   return 'vitest'
          --   -- end,
          -- },
          require('quicktest.adapters.elixir'),
          require('quicktest.adapters.dart'),
          require('quicktest.adapters.rspec'),
          -- require('quicktest.adapters.pytest')({}),
          -- require 'quicktest.adapters.playwright',
        },
        default_win_mode = 'split',
        use_builtin_colorizer = true,
      })
    end,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
    },
    keys = {
      {
        '<leader>tl',
        function()
          local qt = require('quicktest')

          qt.run_line()
        end,
        desc = 'Test Run Line',
      },
      {
        '<leader>tf',
        function()
          local qt = require('quicktest')

          qt.run_file()
        end,
        desc = 'Test Run File',
      },
      -- {
      --   '<leader>td',
      --   function()
      --     local qt = require 'quicktest'
      --
      --     qt.run_dir()
      --   end,
      --   desc = 'Test Run Dir',
      -- },
      {
        '<leader>ta',
        function()
          local qt = require('quicktest')

          qt.run_all()
        end,
        desc = 'Test Run All',
      },
      {
        '<leader>tp',
        function()
          local qt = require('quicktest')

          qt.run_previous()
        end,
        desc = 'Test Run Previous',
      },
      {
        '<leader>tt',
        function()
          local qt = require('quicktest')

          qt.toggle_win('split')
        end,
        desc = 'Test Toggle Window',
      },
      {
        '<leader>tc',
        function()
          local qt = require('quicktest')

          qt.cancel_current_run()
        end,
        desc = 'Test Cancel run',
      },
    },
  },
}
