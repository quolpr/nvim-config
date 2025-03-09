return {
  -- persistent undo
  'kevinhwang91/nvim-fundo',
  dependencies = {
    'kevinhwang91/promise-async',
  },
  build = function()
    require('fundo').install()
  end,
  lazy = false,
  init = function()
    vim.opt.undofile = true
    vim.opt.undodir = os.getenv('HOME') .. '/.vim/undodir'
  end,
  config = function()
    require('fundo').setup()
  end,
}
