return {
  {
    'JoosepAlviste/nvim-ts-context-commentstring',
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('ts_context_commentstring').setup {
        enable_autocmd = false,
      }

      local get_option = vim.filetype.get_option
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.filetype.get_option = function(filetype, option)
        return option == 'commentstring' and require('ts_context_commentstring.internal').calculate_commentstring() or get_option(filetype, option)
      end
    end,
  },
  -- Auto close/rename html tags
  {
    'windwp/nvim-ts-autotag',
    config = function()
      ---@diagnostic disable-next-line: missing-parameter
      require('nvim-ts-autotag').setup()
    end,
  },
  -- Multi cursor
  'mg979/vim-visual-multi',
  -- Improved . repeat
  'tpope/vim-repeat',
}
