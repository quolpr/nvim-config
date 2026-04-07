return function()
  require('persistence').setup({})
  vim.api.nvim_set_keymap(
    'n',
    '<leader>qr',
    [[<cmd>lua require("persistence").load({ last = true })<cr>]],
    { desc = 'Restore persistance' }
  )
end
