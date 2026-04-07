local M = {}

M.config = function()
  require('neogit').setup({})
end

M.keys = {
  {
    '<leader>go',
    function()
      require('neogit').open({ kind = 'split_above_all' })
    end,
    desc = 'Git Open',
  },
}

return M
