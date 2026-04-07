local M = {}

M.build = function()
  require('fundo').install()
end

M.init = function()
  vim.opt.undofile = true
  vim.opt.undodir = os.getenv('HOME') .. '/.vim/undodir'
end

M.config = function()
  require('fundo').setup()
end

return M
