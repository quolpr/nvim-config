return {
  -- {
  --   'kndndrj/nvim-dbee',
  --   dependencies = {
  --     'MunifTanjim/nui.nvim',
  --   },
  --   build = function()
  --     -- Install tries to automatically detect the install method.
  --     -- if it fails, try calling it with one of these parameters:
  --     --    "curl", "wget", "bitsadmin", "go"
  --     require('dbee').install()
  --   end,
  --   config = function()
  --     require('dbee').setup(--[[optional config]])
  --   end,
  --   keys = {
  --     {
  --       '<leader>d',
  --       function()
  --         require('dbee').toggle()
  --       end,
  --       desc = 'Db viwer',
  --     },
  --   },
  -- },

  -- {
  --   'vim-test/vim-test',
  --   config = function()
  --     vim.keymap.set('n', '<leader>tr', ':TestNearest -strategy=neovim_sticky<CR>', { desc = 'Test Run' })
  --     vim.keymap.set('n', '<leader>tR', ':TestFile -strategy=neovim_sticky<CR>', { desc = 'Test All' })
  --     vim.keymap.set('n', '<leader>tl', ':TestLast -strategy=neovim_sticky<CR>', { desc = 'Test Last' })
  --   end,
  -- },

  -- {
  --   'quolpr/neotest',
  --   branch = 'master',
  --   dependencies = {
  --     'fredrikaverpil/neotest-golang',
  --     'nvim-neotest/nvim-nio',
  --     'nvim-lua/plenary.nvim',
  --     'nvim-treesitter/nvim-treesitter',
  --     {
  --       'fredrikaverpil/neotest-golang',
  --       branch = 'main',
  --     },
  --   },
  --   config = function()
  --     -- get neotest namespace (api call creates or returns namespace)
  --     local neotest_ns = vim.api.nvim_create_namespace 'neotest'
  --     vim.diagnostic.config({
  --       virtual_text = {
  --         format = function(diagnostic)
  --           local message = diagnostic.message:gsub('\n', ' '):gsub('\t', ' '):gsub('%s+', ' '):gsub('^%s+', '')
  --           return message
  --         end,
  --       },
  --     }, neotest_ns)
  --
  --     local neotest = require 'neotest'
  --
  --     local config = { -- Specify configuration
  --       go_test_args = {
  --         '-v',
  --         '-race',
  --         '-timeout=60s',
  --       },
  --
  --       dap_go_enabled = true,
  --     }
  --
  --     ---@diagnostic disable-next-line: missing-fields
  --     neotest.setup {
  --       status = {
  --         enabled = true,
  --         signs = true,
  --         virtual_text = false,
  --       },
  --       output = {
  --         enabled = true,
  --         open_on_run = true,
  --       },
  --       -- your neotest config here
  --       adapters = {
  --         require 'neotest-golang'(config), -- Registration
  --       },
  --     }
  --
  --     vim.api.nvim_create_autocmd('FileType', {
  --       pattern = 'neotest-output-panel',
  --       callback = function()
  --         vim.cmd 'norm G'
  --       end,
  --     })
  --   end,
  --   keys = function()
  --     local keys = {
  --       {
  --         '<leader>tt',
  --         function()
  --           require('neotest').summary.toggle()
  --         end,
  --         desc = 'Test Toggle',
  --       },
  --       {
  --         '<leader>tr',
  --         function()
  --           require('neotest').run.run()
  --         end,
  --         desc = 'Test Run',
  --       },
  --       {
  --         '<leader>tR',
  --         function()
  --           require('neotest').run.run(vim.fn.expand '%')
  --         end,
  --         desc = 'Test Run file',
  --       },
  --       {
  --         '<leader>ts',
  --         function()
  --           require('neotest').output.open { enter = true }
  --         end,
  --         desc = 'Test Show result',
  --       },
  --       {
  --         '<leader>tS',
  --         function()
  --           require('neotest').output_panel.open()
  --         end,
  --         desc = 'Test Show all results',
  --       },
  --       {
  --         '<leader>tl',
  --         function()
  --           require('neotest').run.run_last()
  --         end,
  --         desc = 'Test Last',
  --       },
  --       {
  --         '<leader>tp',
  --         function()
  --           require('neotest').output.open { enter = true, last_run = true }
  --         end,
  --         desc = 'Test Previous run preview',
  --       },
  --     }
  --
  --     return keys
  --   end,
  -- },
}
