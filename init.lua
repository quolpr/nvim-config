--Last commit review: 5aeddfdd5d0308506ec63b0e4f8de33e2a39355fer

-- vim.lsp.set_log_level 'debug'

-- vim.opt.spell = true
-- vim.opt.spelllang = 'en_us,ru'
--

vim.opt.termguicolors = true
vim.opt.termsync = false
vim.opt.colorcolumn = '80'

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`
--
-- Make line numbers default
vim.opt.number = true
-- You can also add relative line numbers, for help with jumping.
--  Experiment for yourself to see if you like it!
vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
-- vim.opt.clipboard = 'unnamedplus'

-- Neovim controls whether wrapped lines will be visually indented to match the indentation of the first line
vim.o.breakindent = true
-- This will make long lines wrap onto the next line visually.
vim.o.wrap = true
-- The linebreak option ensures that lines break at word boundaries instead of in the middle of words. This can make the wrapped text more readable.
vim.o.linebreak = true

vim.cmd [[
autocmd FileType go setlocal tabstop=2
]]

-- Save undo history
vim.opt.undofile = true
vim.opt.undodir = os.getenv 'HOME' .. '/.vim/undodir'

-- Case-insensitive searching UNLESS \C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 5

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- BEGIN MY KEYMAPS
vim.keymap.set('n', 'vv', '<C-w>v', { desc = 'Split window vertically' })
vim.keymap.set('n', '<leader>s', '<cmd> update <CR>', { desc = 'Save file' })

-- -- Delete all buffers except current
-- vim.keymap.set('n', '<leader>bd', '<cmd>%bd|e#<cr>', { desc = 'Close all buffers but the current one' }) -- https://stackoverflow.com/a/42071865/516188

-- copy/paste from computer buffer
vim.keymap.set({ 'n', 'v' }, '<leader>y', [["+y]], { desc = 'Yank from computer' })
vim.keymap.set('n', '<leader>p', [["+p]], { desc = 'Paste from computer' })

-- Disable macro cause I don't use it + breaks cmp
-- vim.keymap.set('n', 'q', '<Nop>')

-- When you delete/paste don't rewrite last register
vim.keymap.set('x', '<leader>p', [["_dP]], { desc = 'Paste without register overwriting' })
vim.keymap.set({ 'n', 'v' }, '<leader>d', [["_d]], { desc = 'Delete without register overwriting' })

vim.keymap.set('n', 'T', ':tabnext <CR>', { desc = 'Tab Next' })
-- vim.keymap.set('n', 'Tc', ':tabclose <CR>', { desc = 'Tab Close' })

-- vim.keymap.set('n', '<leader>fm', function()
--   require('conform').format()
-- end, { desc = 'Format file' })

-- vim.keymap.set('n', '<leader>cf', function()
--   vim.cmd 'EslintFixAll'
-- end, { desc = 'Fix file' })
--
-- Keep cursor in center
-- vim.keymap.set('n', '<C-d>', '<C-d>zz')
-- vim.keymap.set('n', '<C-u>', '<C-u>zz')

-- Keep cursor in center
-- vim.keymap.set('n', 'n', 'nzzzv')
-- vim.keymap.set('n', 'N', 'Nzzzv')
-- END MY KEYMAPS

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '[e', function()
  vim.diagnostic.goto_prev { severity = { min = vim.diagnostic.severity.ERROR } }
end, { desc = 'Go to previous diagnostic Error message' })
vim.keymap.set('n', ']e', function()
  vim.diagnostic.goto_next { severity = { min = vim.diagnostic.severity.ERROR } }
end, { desc = 'Go to next diagnostic Error message' })

vim.keymap.set('n', '[w', function()
  vim.diagnostic.goto_prev { severity = { min = vim.diagnostic.severity.WARN } }
end, { desc = 'Go to previous diagnostic Warn message' })
vim.keymap.set('n', ']w', function()
  vim.diagnostic.goto_next { severity = { min = vim.diagnostic.severity.WARN } }
end, { desc = 'Go to next diagnostic Warn message' })
vim.keymap.set('n', ']i', function()
  vim.diagnostic.goto_next { severity = { min = vim.diagnostic.severity.INFO } }
end, { desc = 'Go to next diagnostic Iinfo message' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
-- vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

local getVisualSelection = function()
  vim.cmd 'noau normal! "vy"'
  local text = vim.fn.getreg 'v'
  vim.fn.setreg('v', {})

  text = string.gsub(text, '\n', '')
  if #text > 0 then
    return text
  else
    return ''
  end
end

local function escape(str)
  -- You need to escape these characters to work correctly
  local escape_chars = [[;,."|\/]]
  return vim.fn.escape(str, escape_chars)
end

-- Map the function to a key combination in visual mode
vim.keymap.set('v', '<leader>r', function()
  local selection = getVisualSelection()
  vim.cmd('call feedkeys(":%s/' .. escape(selection) .. '/")')
end, { noremap = true, silent = true, desc = 'Replace' })

-- Map the function to a key combination in visual mode
vim.keymap.set('n', '<leader>r', function()
  local word = vim.fn.expand '<cword>'
  vim.cmd('call feedkeys(":%s/' .. escape(word) .. '/")')
end, { noremap = true, silent = true, desc = 'Replace' })

vim.filetype.add {
  pattern = {
    ['openapi.*%.ya?ml'] = 'yaml.openapi',
    ['openapi.*%.json'] = 'json.openapi',
    ['swagger.ya?ml'] = 'yaml.openapi',
  },
}

vim.opt.langmap =
  'ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz'

-- vim.g.loaded_matchparen = 1
-- vim.g.loaded_matchit = 1

-- vim.o.clipboard = "unnamedplus"

-- local function paste()
--   return {
--     vim.fn.split(vim.fn.getreg '', '\n'),
--     vim.fn.getregtype '',
--   }
-- end
--
-- vim.g.clipboard = {
--   name = 'OSC 52',
--   copy = {
--     ['+'] = require('vim.ui.clipboard.osc52').copy '+',
--     ['*'] = require('vim.ui.clipboard.osc52').copy '*',
--   },
--   paste = {
--     ['+'] = paste,
--     ['*'] = paste,
--   },
-- }

vim.filetype.add {
  extension = {
    gotmpl = 'gotmpl',
  },
  pattern = {
    ['.*/templates/.*%.tpl'] = 'helm',
    ['.*/templates/.*%.ya?ml'] = 'helm',
    ['helmfile.*%.ya?ml'] = 'helm',
  },
}

-- NOTE: Here is where you install your plugins.
require('lazy').setup {
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
  'christoomey/vim-tmux-navigator',
  -- Restore closed buffers and windows
  {
    'folke/persistence.nvim',
    opts = {
      -- add any custom options here
    },
    config = function()
      require('persistence').setup {}
      vim.api.nvim_set_keymap('n', '<leader>qr', [[<cmd>lua require("persistence").load({ last = true })<cr>]], { desc = 'Restore persistance' })
    end,
  },
  { 'meznaric/key-analyzer.nvim', opts = {} },

  require 'plugins.ai',
  require 'plugins.complete',
  -- require 'plugins.dap',
  require 'plugins.db',
  require 'plugins.diagnostics',
  require 'plugins.edit',
  require 'plugins.format',
  require 'plugins.fs',
  require 'plugins.git',
  require 'plugins.highlight',
  require 'plugins.locnav',
  require 'plugins.lsp',
  require 'plugins.lua-dev',
  require 'plugins.notes',
  -- require 'plugins.profile',
  require 'plugins.search',
  require 'plugins.test',
  require 'plugins.theme',
  require 'plugins.treesitter',
  require 'plugins.ui',
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
