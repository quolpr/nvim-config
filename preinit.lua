vim.opt.termguicolors = true
vim.opt.termsync = false
vim.opt.colorcolumn = '80'
vim.opt.swapfile = false

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- [[ Setting options ]]
-- See `:help vim.opt`
--
-- Make line numbers default
vim.opt.number = true
vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in status line
vim.opt.showmode = false

-- Neovim controls whether wrapped lines will be visually indented to match the indentation of the first line
vim.o.breakindent = true
-- This will make long lines wrap onto the next line visually.
vim.o.wrap = true
-- The linebreak option ensures that lines break at word boundaries instead of in the middle of words.
vim.o.linebreak = true

vim.cmd([[
autocmd FileType go setlocal tabstop=2
]])

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
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 5

-- [[ Basic Keymaps ]]
vim.keymap.set('n', 'vv', '<C-w>v', { desc = 'Split window vertically' })
vim.keymap.set('n', '<leader>s', '<cmd> update <CR>', { desc = 'Save file' })

-- copy/paste from computer buffer
vim.keymap.set({ 'n', 'v' }, '<leader>y', [["+y]], { desc = 'Yank from computer' })
vim.keymap.set('n', '<leader>p', [["+p]], { desc = 'Paste from computer' })

-- When you delete/paste don't rewrite last register
vim.keymap.set('x', '<leader>p', [["_dP]], { desc = 'Paste without register overwriting' })

vim.keymap.set('n', 'T', ':tabnext <CR>', { desc = 'Tab Next' })

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '[e', function()
  vim.diagnostic.goto_prev({ severity = { min = vim.diagnostic.severity.ERROR } })
end, { desc = 'Go to previous diagnostic Error message' })
vim.keymap.set('n', ']e', function()
  vim.diagnostic.goto_next({ severity = { min = vim.diagnostic.severity.ERROR } })
end, { desc = 'Go to next diagnostic Error message' })

vim.keymap.set('n', '[w', function()
  vim.diagnostic.goto_prev({ severity = { min = vim.diagnostic.severity.WARN } })
end, { desc = 'Go to previous diagnostic Warn message' })
vim.keymap.set('n', ']w', function()
  vim.diagnostic.goto_next({ severity = { min = vim.diagnostic.severity.WARN } })
end, { desc = 'Go to next diagnostic Warn message' })
vim.keymap.set('n', ']i', function()
  vim.diagnostic.goto_next({ severity = { min = vim.diagnostic.severity.INFO } })
end, { desc = 'Go to next diagnostic Iinfo message' })

vim.diagnostic.config({
  update_in_insert = false,
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = { min = vim.diagnostic.severity.WARN } },
  virtual_text = { source = 'if_many' },
  virtual_lines = false,
  jump = { float = true },
})

-- Keybinds to make split navigation easier.
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

local getVisualSelection = function()
  vim.cmd('noau normal! "vy"')
  local text = vim.fn.getreg('v')
  vim.fn.setreg('v', {})

  text = string.gsub(text, '\n', '')
  if #text > 0 then
    return text
  else
    return ''
  end
end

local function escape(str)
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
  local word = vim.fn.expand('<cword>')
  vim.cmd('call feedkeys(":%s/' .. escape(word) .. '/")')
end, { noremap = true, silent = true, desc = 'Replace' })

vim.filetype.add({
  pattern = {
    ['openapi.*%.ya?ml'] = 'yaml.openapi',
    ['openapi.*%.json'] = 'json.openapi',
    ['swagger.ya?ml'] = 'yaml.openapi',
  },
})

vim.opt.langmap =
'ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz'

vim.filetype.add({
  extension = {
    gotmpl = 'gotmpl',
  },
  pattern = {
    ['.*/templates/.*%.tpl'] = 'helm',
    ['.*/templates/.*%.ya?ml'] = 'helm',
    ['helmfile.*%.ya?ml'] = 'helm',
  },
})

-- [[ Top-level side-effect code from plugin files ]]

-- Go imports on save (from format.lua)
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*.go',
  callback = function()
    local params = vim.lsp.util.make_range_params()
    params.context = { only = { 'source.organizeImports' } }
    local result = vim.lsp.buf_request_sync(0, 'textDocument/codeAction', params)
    for cid, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or 'utf-16'
          vim.lsp.util.apply_workspace_edit(r.edit, enc)
        end
      end
    end
  end,
})

-- Code action keymap with filter (from lsp.lua)
vim.keymap.set('n', '<leader>ca', function()
  vim.lsp.buf.code_action({
    filter = function(action)
      if string.find(action.title, 'to user settings') then
        return false
      end

      return true
    end,
  })
end)

-- Diagnostic signs config (from ui.lua)
vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '󰅙',
      [vim.diagnostic.severity.INFO] = '󰋼',
      [vim.diagnostic.severity.HINT] = '󰌵',
      [vim.diagnostic.severity.WARN] = '',
    },
  },
})

-- Highlight when yanking (copying) text (from ui.lua)
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Harpoon highlights (from ui.lua)
vim.cmd([[
  hi default HarpoonNumberActive guifg=#89b4fa gui=bold
  hi default HarpoonActive guifg=#89b4fa gui=bold
  hi default HarpoonNumberInactive guifg=#6c7086
  hi default HarpoonInactive guifg=#6c7086
]])


vim.g.neovide_position_animation_length = 0
vim.g.neovide_cursor_animation_length = 0.00
vim.g.neovide_cursor_trail_size = 0
vim.g.neovide_cursor_animate_in_insert_mode = false
vim.g.neovide_cursor_animate_command_line = false
vim.g.neovide_scroll_animation_far_lines = 0
vim.g.neovide_scroll_animation_length = 0.00

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'go',
  callback = function()
    vim.opt_local.shiftwidth = 2
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'typescript',
  callback = function()
    vim.opt_local.shiftwidth = 2
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'typescriptreact',
  callback = function()
    vim.opt_local.shiftwidth = 2
  end,
})
