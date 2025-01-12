return {
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    config = function()
      -- [[ Configure Treesitter ]] See `:help nvim-treesitter`

      ---@diagnostic disable-next-line: missing-fields
      require('nvim-treesitter.configs').setup {
        ensure_installed = { 'bash', 'c', 'html', 'lua', 'markdown', 'vim', 'vimdoc', 'diff', 'helm', 'gotmpl' },
        -- Autoinstall languages that are not installed
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = '<c-space>',
            node_incremental = '<c-space>',

            node_decremental = '<bs>',
            -- -- scope_incremental = '<c-S>',
          },
        },
        -- Slow downs vim https://github.com/nvim-treesitter/nvim-treesitter/issues/5868
        -- textobjects = {
        --   select = {
        --     enable = true,
        --     lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
        --     keymaps = {
        --       -- You can use the capture groups defined in textobjects.scm
        --       -- a = means argument
        --       ['ia'] = '@parameter.inner',
        --       ['aa'] = '@parameter.outer',
        --       ['af'] = '@function.outer',
        --       ['if'] = '@function.inner',
        --       ['ac'] = '@class.outer',
        --       ['ic'] = '@class.inner',
        --       ['ii'] = '@conditional.inner',
        --       ['ai'] = '@conditional.outer',
        --       ['il'] = '@loop.inner',
        --       ['al'] = '@loop.outer',
        --       ['at'] = '@comment.outer',
        --     },
        --   },
        --   move = {
        --     enable = true,
        --     set_jumps = true, -- whether to set jumps in the jumplist
        --     goto_next_start = {
        --       [']f'] = '@function.outer',
        --       [']]'] = '@class.outer',
        --     },
        --     goto_next_end = {
        --       [']F'] = '@function.outer',
        --       [']['] = '@class.outer',
        --     },
        --     goto_previous_start = {
        --       ['[f'] = '@function.outer',
        --       ['[['] = '@class.outer',
        --     },
        --     goto_previous_end = {
        --       ['[F'] = '@function.outer',
        --       ['[]'] = '@class.outer',
        --     },
        --   },
        --   -- swap = {
        --   --   enable = true,
        --   --   swap_next = {
        --   --     ['<leader>a'] = '@parameter.inner',
        --   --   },
        --   --   swap_previous = {
        --   --     ['<leader>A'] = '@parameter.inner',
        --   --   },
        --   -- },
        -- },
      }

      -- There are additional nvim-treesitter modules that you can use to interact
      -- with nvim-treesitter. You should go explore a few and see what interests you:
      --
      --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
      --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
      --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
    end,
  },
}
