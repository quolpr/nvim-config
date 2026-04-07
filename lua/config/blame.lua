local M = {}

M.config = function()
  require('blame').setup()
end

M.keys = {
  {
    '<leader>gb',
    function()
      vim.cmd('BlameToggle')
    end,
    desc = 'Git Blame',
  },
}

return M
