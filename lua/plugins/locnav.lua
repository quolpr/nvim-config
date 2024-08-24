return {
  {
    'stevearc/aerial.nvim',
    opts = {},
    -- Optional dependencies
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require('aerial').setup {
        float = {
          relative = 'win',
          min_height = { 20, 0.5 },
          override = function(conf, source_winid)
            conf.width = 80
            conf.col = conf.col - (80 - 25) / 2
            -- This is the config that will be passed to nvim_open_win.
            -- Change values here to customize the layout
            return conf
          end,
        },
      }
    end,
    keys = {
      {
        '<leader>A',
        '<cmd>AerialToggle float<CR>',
        desc = 'Aerial',
      },
    },
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    config = function()
      require('treesitter-context').setup {
        enable = true,
        max_lines = 10,
      }
    end,
  },
  {
    'andymass/vim-matchup',
    setup = function()
      vim.cmd [[
        let g:matchup_matchparen_enabled = 0
      ]]
    end,
  },
  -- Show labels on f/F jumps
  -- {
  --   'unblevable/quick-scope',
  --   config = function()
  --     vim.cmd [[
  --       let g:qs_second_highlight=0
  --       let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
  --
  --       " augroup qs_colors
  --       "   autocmd!
  --       "   autocmd ColorScheme * highlight QuickScopePrimary gui=underline ctermfg=155 cterm=underline
  --       "   autocmd ColorScheme * highlight QuickScopeSecondary gui=underline ctermfg=81 cterm=underline
  --       " augroup END
  --       " highlight QuickScopePrimary guifg='#000' gui=underline cterm=underline
  --     ]]
  --   end,
  -- },
}
