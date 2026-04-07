return function()
  require('supermaven-nvim').setup({
    ignore_filetypes = { markdown = true },
    keymaps = {
      accept_suggestion = '<c-u>',
    },
  })
end
