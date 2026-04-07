require('./preinit')

-- [[ Install `lazy.nvim` plugin manager ]]
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath })
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

---@diagnostic disable-next-line: missing-fields
require('lazy').setup({
  ---------------------
  --- NAVIGATION
  ---------------------
  -- Seamless navigation between tmux panes and nvim splits
  { 'alexghergh/nvim-tmux-navigation', config = require('config.tmux-navigation') },

  ---------------------
  --- DETECTION
  ---------------------
  -- Auto-detect tabstop and shiftwidth from file content
  'tpope/vim-sleuth',

  ---------------------
  --- SESSION
  ---------------------
  -- Save and restore sessions automatically
  { 'folke/persistence.nvim',          config = require('config.persistence') },

  ---------------------
  --- LINTING
  ---------------------
  -- ESLint diagnostics and code actions via LSP
  {
    'esmuellert/nvim-eslint',
    config = function()
      require('nvim-eslint').setup({})
    end,
  },

  ---------------------
  --- AI
  ---------------------
  -- AI inline code completion
  { 'supermaven-inc/supermaven-nvim',              config = require('config.supermaven') },
  -- Claude AI chat sidebar integrated with tmux
  {
    'folke/sidekick.nvim',
    opts = require('config.sidekick').opts,
    keys = require('config.sidekick').keys,
  },

  ---------------------
  --- COMPLETION
  ---------------------
  -- Fast autocompletion engine with LSP, snippets and buffer sources
  {
    'saghen/blink.cmp',
    version = '*',
    opts = require('config.blink-cmp'),
    opts_extend = { 'sources.default' },
  },

  ---------------------
  --- DIAGNOSTICS
  ---------------------
  -- Pretty diagnostics list and document symbols panel
  {
    'folke/trouble.nvim',
    cmd = 'Trouble',
    opts = require('config.trouble').opts,
    keys = require('config.trouble').keys,
  },

  ---------------------
  --- EDITING
  ---------------------
  -- Treesitter-aware commentstring for JSX/TSX/Vue etc.
  { 'JoosepAlviste/nvim-ts-context-commentstring', config = require('config.ts-context-commentstring') },
  -- Auto close and rename HTML/JSX tags
  {
    'windwp/nvim-ts-autotag',
    config = function()
      ---@diagnostic disable-next-line: missing-parameter
      require('nvim-ts-autotag').setup()
    end,
  },
  -- Multiple cursors support
  'mg979/vim-visual-multi',
  -- Make . repeat work with plugin mappings
  'tpope/vim-repeat',

  ---------------------
  --- FORMATTING
  ---------------------
  -- Format on save via stylua, prettierd, buf, etc.
  { 'stevearc/conform.nvim',    lazy = false,                     opts = require('config.conform') },

  ---------------------
  --- FILE SYSTEM
  ---------------------
  -- File tree explorer with nerdfont icons
  {
    'lambdalisue/fern.vim',
    branch = 'main',
    dependencies = { 'lambdalisue/nerdfont.vim', 'lambdalisue/fern-renderer-nerdfont.vim', 'lambdalisue/fern-hijack.vim' },
    lazy = false,
    config = require('config.fern').config,
    keys = require('config.fern').keys,
  },

  ---------------------
  --- GIT
  ---------------------
  -- Magit-like interactive git UI
  {
    'NeogitOrg/neogit',
    dependencies = { 'nvim-lua/plenary.nvim', 'ibhagwan/fzf-lua' },
    config = require('config.neogit').config,
    keys = require('config.neogit').keys,
  },
  -- Side-by-side git diff and file history viewer
  {
    'sindrets/diffview.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    keys = require('config.diffview'),
  },
  -- Toggle inline git blame annotations
  {
    'FabijanZulj/blame.nvim',
    config = require('config.blame').config,
    keys = require('config.blame').keys,
  },
  -- Git gutter signs, hunk staging/reset, and inline blame
  { 'lewis6991/gitsigns.nvim',  opts = require('config.gitsigns') },

  ---------------------
  --- HIGHLIGHTING
  ---------------------
  -- Highlight TODO/FIXME/HACK comments in the codebase
  { 'folke/todo-comments.nvim', event = 'VimEnter',               dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },
  -- Highlight other occurrences of the word under cursor via LSP
  {
    'rrethy/vim-illuminate',
    config = function()
      require('illuminate').configure({
        providers = {
          'lsp',
        },
      })
    end,
  },

  ---------------------
  --- TREESITTER
  ---------------------
  -- Show sticky function/class header at top of buffer
  {
    'nvim-treesitter/nvim-treesitter-context',
    config = function()
      require('treesitter-context').setup({
        enable = true,
        max_lines = 10,
      })
    end,
  },
  -- Treesitter-based syntax highlighting and incremental selection
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    config = require('config.treesitter'),
  },

  ---------------------
  --- LSP
  ---------------------
  -- LSP server configs for Go, TS, Lua, Elixir, etc.
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'j-hui/fidget.nvim', opts = {} },
    },
    config = require('config.lspconfig'),
  },

  ---------------------
  --- LUA DEV
  ---------------------
  -- Neovim Lua API completions and type annotations for plugin dev
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = 'luvit-meta/library', words = { 'vim%.uv' } },
      },
    },
  },
  -- Type definitions for vim.uv (libuv bindings)
  { 'Bilal2453/luvit-meta',      lazy = true },

  ---------------------
  --- TEST
  ---------------------
  -- Run tests inline for Go, Vitest, Elixir, Dart, RSpec
  {
    'quolpr/quicktest.nvim',
    branch = 'main',
    dependencies = { 'nvim-lua/plenary.nvim', 'MunifTanjim/nui.nvim' },
    config = require('config.quicktest').config,
    keys = require('config.quicktest').keys,
  },

  ---------------------
  --- THEME
  ---------------------
  -- Rose Pine Moon colorscheme
  {
    'rose-pine/neovim',
    name = 'rose-pine',
    config = function()
      require('rose-pine')
      vim.cmd.colorscheme('rose-pine-moon')
    end,
  },

  ---------------------
  --- UI
  ---------------------
  -- Flash cursor line on jump so you don't lose it
  { 'danilamihailov/beacon.nvim' },
  -- Statusline with mode colors, diagnostics, branch, and harpoon tabline
  {
    'nvim-lualine/lualine.nvim',
    config = require('config.lualine'),
  },
  -- Better quickfix window with preview
  { 'kevinhwang91/nvim-bqf' },
  -- Show pending keybind hints in a popup
  {
    'folke/which-key.nvim',
    event = 'VimEnter',
    config = require('config.which-key'),
  },

  ---------------------
  --- SNACKS
  ---------------------
  -- All-in-one UI: picker, dashboard, indent guides, notifier, git browse, scratch buffers
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    opts = require('config.snacks').opts,
    keys = require('config.snacks').keys,
  },

  ---------------------
  --- SEARCH / REPLACE
  ---------------------
  -- Global search and replace across project files
  { 'MagicDuck/grug-far.nvim', opts = {}, keys = require('config.grug-far') },

  ---------------------
  --- UNDO
  ---------------------
  -- Persistent undo history saved to disk across sessions
  {
    'kevinhwang91/nvim-fundo',
    dependencies = { 'kevinhwang91/promise-async' },
    lazy = false,
    build = require('config.fundo').build,
    init = require('config.fundo').init,
    config = require('config.fundo').config,
  },

  ---------------------
  --- FILE PICKER
  ---------------------
  -- Frecency-based fuzzy file finder with native binary
  {
    'dmtrKovalenko/fff.nvim',
    dependencies = { 'folke/snacks.nvim' },
    lazy = true,
    build = require('config.fff').build,
    opts = require('config.fff').opts,
    config = require('config.fff').config,
  },
})
