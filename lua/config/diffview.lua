return {
  {
    '<leader>gh',
    function()
      vim.cmd('DiffviewFileHistory %')
    end,
    desc = 'Git file history',
  },
  {
    '<leader>gH',
    function()
      vim.cmd('DiffviewFileHistory')
    end,
    desc = 'Git history',
  },
}
