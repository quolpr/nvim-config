return {
  {
    'quolpr/quicktest.nvim',
    -- dir = '~/projects/quolpr/quicktest.nvim',
    config = function()
      local qt = require 'quicktest'

      qt.setup {
        adapters = {
          require 'quicktest.adapters.golang' {
            args = function(bufnt, args)
              vim.list_extend(args, { '-count=1' })
              return args
            end,
          },
          require 'quicktest.adapters.vitest',
          --   -- bin = function(path)
          --   --   print(path)
          --   --   return 'vitest'
          --   -- end,
          -- },
          require 'quicktest.adapters.elixir',
          require 'quicktest.adapters.dart',
          -- require 'quicktest.adapters.playwright',
        },
        default_win_mode = 'split',
        use_experimental_colorizer = true,
      }
    end,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      'm00qek/baleia.nvim',
    },
    keys = {
      {
        '<leader>tl',
        function()
          local qt = require 'quicktest'

          qt.run_line('auto', 'auto', { additional_args = { '-count=5' } })
        end,
        desc = 'Test Run Line',
      },
      {
        '<leader>tf',
        function()
          local qt = require 'quicktest'

          qt.run_file()
        end,
        desc = 'Test Run File',
      },
      {
        '<leader>td',
        function()
          local qt = require 'quicktest'

          qt.run_dir()
        end,
        desc = 'Test Run Dir',
      },
      {
        '<leader>ta',
        function()
          local qt = require 'quicktest'

          qt.run_all()
        end,
        desc = 'Test Run All',
      },
      {
        '<leader>tp',
        function()
          local qt = require 'quicktest'

          qt.run_previous()
        end,
        desc = 'Test Run Previous',
      },
      {
        '<leader>tt',
        function()
          local qt = require 'quicktest'

          qt.toggle_win 'split'
        end,
        desc = 'Test Toggle Window',
      },
      {
        '<leader>tc',
        function()
          local qt = require 'quicktest'

          qt.cancel_current_run()
        end,
        desc = 'Test Cancel run',
      },
    },
  },
}