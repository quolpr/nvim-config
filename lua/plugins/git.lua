return {
  {
    -- 'NeogitOrg/neogit',
    'quolpr/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim', -- required
      -- Only one of these is needed, not both.
      -- 'nvim-telescope/telescope.nvim', -- optional
      'ibhagwan/fzf-lua', -- optional
    },
    config = function()
      local neogit = require 'neogit'
      neogit.setup {}
    end,
    keys = {
      {
        '<leader>go',
        function()
          local neogit = require 'neogit'
          neogit.open { kind = 'split_above_all' }
        end,
        desc = 'Git Open',
      },
    },
  },
  {
    'sindrets/diffview.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    keys = {
      {
        '<leader>gh',
        function()
          vim.cmd 'DiffviewFileHistory %'
        end,
        desc = 'Git file history',
      },
      {
        '<leader>gH',
        function()
          vim.cmd 'DiffviewFileHistory'
        end,
        desc = 'Git history',
      },
    },
  },
  {
    'FabijanZulj/blame.nvim',
    config = function()
      require('blame').setup()
    end,
    keys = {
      {
        '<leader>gb',
        function()
          vim.cmd 'BlameToggle'
        end,
        desc = 'Git Blame',
      },
    },
  },
  -- Here is a more advanced example where we pass configuration
  -- options to `gitsigns.nvim`. This is equivalent to the following lua:
  --    require('gitsigns').setup({ ... })
  --
  -- See `:help gitsigns` to understand what the configuration keys do
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '│' },
        change = { text = '│' },
        delete = { text = '󰍵' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
        untracked = { text = '│' },
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        -- gs.toggle_current_line_blame()

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map({ 'n', 'v' }, ']h', function()
          if vim.wo.diff then
            return ']h'
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return '<Ignore>'
        end, { expr = true, desc = 'Jump to next hunk' })

        map({ 'n', 'v' }, '[h', function()
          if vim.wo.diff then
            return '[h'
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return '<Ignore>'
        end, { expr = true, desc = 'Jump to previous hunk' })

        -- Actions
        -- visual mode
        map('v', '<leader>hs', function()
          gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'stage git hunk' })
        map('v', '<leader>hr', function()
          gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'reset git hunk' })

        map('n', '<leader>hs', gs.stage_hunk, { desc = 'git stage hunk' })
        map('n', '<leader>hr', gs.reset_hunk, { desc = 'git reset hunk' })
        map('n', '<leader>hS', gs.stage_buffer, { desc = 'git Stage buffer' })
        map('n', '<leader>hu', gs.undo_stage_hunk, { desc = 'undo stage hunk' })
        map('n', '<leader>hR', gs.reset_buffer, { desc = 'git Reset buffer' })
        map('n', '<leader>hp', gs.preview_hunk, { desc = 'preview git hunk' })
        map('n', '<leader>hb', function()
          gs.blame_line { full = false }
        end, { desc = 'git blame line' })
        map('n', '<leader>hd', gs.diffthis, { desc = 'git diff against index' })
        map('n', '<leader>hD', function()
          gs.diffthis '~'
        end, { desc = 'git diff against last commit' })

        -- Toggles
        map('n', '<leader>tb', gs.toggle_current_line_blame, { desc = 'toggle git blame line' })
        -- map('n', '<leader>td', gs.toggle_deleted, { desc = 'toggle git show deleted' })

        -- Text object
        map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'select git hunk' })
      end,
    },
  },

  -- {
  -- 'tpope/vim-fugitive',
  -- {
  --   'ruifm/gitlinker.nvim',
  --   dependencies = {
  --     'nvim-lua/plenary.nvim',
  --   },
  --   config = function()
  --     require('gitlinker').setup()
  --     -- gy = git yank
  --   end,
  -- },

  -- {
  --   'zbirenbaum/copilot.lua',
  --   config = function()
  --     vim.g.copilot_proxy = 'http://91.108.241.124:56382'
  --
  --     require('copilot').setup {
  --       suggestion = {
  --         auto_trigger = true,
  --         keymap = {
  --           accept = '<C-u>',
  --           accept_word = false,
  --           accept_line = false,
  --           next = '<C-j>',
  --           prev = '<C-k>',
  --           dismiss = '<C-d>',
  --         },
  --       },
  --       filetypes = {
  --         yaml = true,
  --       },
  --     }
  --   end,
  --   dependencies = {
  --     'AndreM222/copilot-lualine',
  --   },
  -- },

  -- {
  --   'kdheepak/lazygit.nvim',
  --   cmd = {
  --     'LazyGit',
  --     'LazyGitConfig',
  --     'LazyGitCurrentFile',
  --     'LazyGitFilter',
  --     'LazyGitFilterCurrentFile',
  --   },
  --   -- optional for floating window border decoration
  --   dependencies = {
  --     'nvim-lua/plenary.nvim',
  --   },
  --   -- setting the keybinding for LazyGit with 'keys' is recommended in
  --   -- order to load the plugin when the command is run for the first time
  --   keys = {
  --     { '<leader>go', '<cmd>LazyGit<cr>', desc = 'Git Open' },
  --   },
  -- },
}
