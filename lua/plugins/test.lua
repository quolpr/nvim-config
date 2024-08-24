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
        desc = '[T]est Run [L]ine',
      },
      {
        '<leader>tf',
        function()
          local qt = require 'quicktest'

          qt.run_file()
        end,
        desc = '[T]est Run [F]ile',
      },
      {
        '<leader>td',
        function()
          local qt = require 'quicktest'

          qt.run_dir()
        end,
        desc = '[T]est Run [D]ir',
      },
      {
        '<leader>ta',
        function()
          local qt = require 'quicktest'

          qt.run_all()
        end,
        desc = '[T]est Run [A]ll',
      },
      {
        '<leader>tp',
        function()
          local qt = require 'quicktest'

          qt.run_previous()
        end,
        desc = '[T]est Run [P]revious',
      },
      {
        '<leader>tt',
        function()
          local qt = require 'quicktest'

          qt.toggle_win 'split'
        end,
        desc = '[T]est [T]oggle Window',
      },
      {
        '<leader>tc',
        function()
          local qt = require 'quicktest'

          qt.cancel_current_run()
        end,
        desc = '[T]est [C]ancel run',
      },
    },
  },
}
