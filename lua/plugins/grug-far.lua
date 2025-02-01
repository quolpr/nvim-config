return {
  {
    'MagicDuck/grug-far.nvim',
    opts = {},
    keys = {
      {
        '<leader>fp',
        function()
          require('grug-far').open()
        end,
        desc = 'Find and Replace in Project',
      },
      {
        '<leader>fp',
        function()
          require('grug-far').with_visual_selection()
        end,
        desc = 'Find and Replace in Project',
        mode = 'v',
      },
    },
  },
}
