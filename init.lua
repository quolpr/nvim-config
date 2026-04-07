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
  {
    'alexghergh/nvim-tmux-navigation',
    config = function()
      local nvim_tmux_nav = require('nvim-tmux-navigation')

      nvim_tmux_nav.setup({
        disable_when_zoomed = true,
      })

      vim.keymap.set('n', '<C-h>', nvim_tmux_nav.NvimTmuxNavigateLeft)
      vim.keymap.set('n', '<C-j>', nvim_tmux_nav.NvimTmuxNavigateDown)
      vim.keymap.set('n', '<C-k>', nvim_tmux_nav.NvimTmuxNavigateUp)
      vim.keymap.set('n', '<C-l>', nvim_tmux_nav.NvimTmuxNavigateRight)
    end,
  },

  ---------------------
  --- DETECTION
  ---------------------
  -- Auto-detect tabstop and shiftwidth from file content
  'tpope/vim-sleuth',

  ---------------------
  --- SESSION
  ---------------------
  -- Save and restore sessions automatically
  {
    'folke/persistence.nvim',
    config = function()
      require('persistence').setup({})
      vim.api.nvim_set_keymap(
        'n',
        '<leader>qr',
        [[<cmd>lua require("persistence").load({ last = true })<cr>]],
        { desc = 'Restore persistance' }
      )
    end,
  },

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
  {
    'supermaven-inc/supermaven-nvim',
    config = function()
      require('supermaven-nvim').setup({
        ignore_filetypes = { markdown = true },
        keymaps = {
          accept_suggestion = '<c-u>',
        },
      })
    end,
  },
  -- Claude AI chat sidebar integrated with tmux
  {
    'folke/sidekick.nvim',
    opts = {
      cli = {
        mux = {
          backend = 'tmux',
          enabled = true,
        },
      },
    },
    keys = {
      {
        '<c-.>',
        function()
          require('sidekick.cli').focus()
        end,
        mode = { 'n', 'x', 'i', 't' },
        desc = 'Sidekick Switch Focus',
      },
      {
        '<leader>aa',
        function()
          require('sidekick.cli').toggle({ focus = true })
        end,
        desc = 'Sidekick Toggle CLI',
        mode = { 'n', 'v' },
      },
      {
        '<leader>ap',
        function()
          require('sidekick.cli').prompt()
        end,
        desc = 'Sidekick Ask Prompt',
        mode = { 'n', 'v' },
      },
    },
  },

  ---------------------
  --- COMPLETION
  ---------------------
  -- Fast autocompletion engine with LSP, snippets and buffer sources
  {
    'saghen/blink.cmp',
    version = '*',
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = { preset = 'super-tab' },
      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = 'mono',
      },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
      },
      completion = {
        documentation = {
          auto_show = true,
        },
      },
      signature = {
        enabled = false,
      },
    },
    opts_extend = { 'sources.default' },
  },

  ---------------------
  --- DIAGNOSTICS
  ---------------------
  -- Pretty diagnostics list and document symbols panel
  {
    'folke/trouble.nvim',
    opts = {
      modes = {
        symbols = {
          desc = 'document symbols',
          mode = 'lsp_document_symbols',
          win = {
            type = 'float',
            relative = 'cursor',
            border = 'rounded',
            title = 'Symbols',
            title_pos = 'center',
            position = { 0, 0 },
            size = { width = 0.8, height = 0.4 },
            zindex = 200,
            focusable = true,
          },
          filter = {
            ['not'] = { ft = 'lua', kind = 'Package' },
            any = {
              ft = { 'help', 'markdown' },
              kind = {
                'Class',
                'Constructor',
                'Enum',
                'Field',
                'Function',
                'Interface',
                'Method',
                'Module',
                'Namespace',
                'Package',
                'Property',
                'Struct',
                'Trait',
              },
            },
          },
        },
      },
    },
    cmd = 'Trouble',
    keys = {
      {
        '<leader>cD',
        '<cmd>Trouble diagnostics toggle filter.severity=vim.diagnostic.severity.ERROR<cr>',
        desc = 'Code Diagnostics',
      },
      {
        '<leader>cd',
        '<cmd>Trouble diagnostics toggle filter.buf=0 filter.severity=vim.diagnostic.severity.ERROR<cr>',
        desc = 'Code diagnostics of current buffer',
      },
    },
  },

  ---------------------
  --- EDITING
  ---------------------
  -- Treesitter-aware commentstring for JSX/TSX/Vue etc.
  {
    'JoosepAlviste/nvim-ts-context-commentstring',
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('ts_context_commentstring').setup({
        enable_autocmd = false,
      })

      local get_option = vim.filetype.get_option
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.filetype.get_option = function(filetype, option)
        return option == 'commentstring' and require('ts_context_commentstring.internal').calculate_commentstring()
            or get_option(filetype, option)
      end
    end,
  },
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
  {
    'stevearc/conform.nvim',
    lazy = false,
    opts = {
      notify_on_error = false,
      format_after_save = {
        lsp_fallback = true,
        timeout_ms = 5000,
      },
      formatters_by_ft = {
        lua = { 'stylua' },
        javascript = { 'prettierd' },
        typescript = { 'prettierd' },
        json = { 'prettierd' },
        typescriptreact = { 'prettierd' },
        go = {},
        proto = { 'buf' },
      },
    },
  },

  ---------------------
  --- FILE SYSTEM
  ---------------------
  -- File tree explorer with nerdfont icons
  {
    'lambdalisue/fern.vim',
    branch = 'main',
    dependencies = {
      'lambdalisue/nerdfont.vim',
      'lambdalisue/fern-renderer-nerdfont.vim',
      'lambdalisue/fern-hijack.vim',
    },
    lazy = false,
    config = require('config.fern'),
    keys = {
      {
        '-',
        function()
          vim.cmd([[Fern . -reveal=% -wait <CR>]])
        end,
      },
      {
        '_',
        function()
          vim.cmd([[Fern %:h -wait <CR>]])
        end,
      },
    },
  },

  ---------------------
  --- GIT
  ---------------------
  -- Magit-like interactive git UI
  {
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'ibhagwan/fzf-lua',
    },
    config = function()
      local neogit = require('neogit')
      neogit.setup({})
    end,
    keys = {
      {
        '<leader>go',
        function()
          local neogit = require('neogit')
          neogit.open({ kind = 'split_above_all' })
        end,
        desc = 'Git Open',
      },
    },
  },
  -- Side-by-side git diff and file history viewer
  {
    'sindrets/diffview.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    keys = {
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
    },
  },
  -- Toggle inline git blame annotations
  {
    'FabijanZulj/blame.nvim',
    config = function()
      require('blame').setup()
    end,
    keys = {
      {
        '<leader>gb',
        function()
          vim.cmd('BlameToggle')
        end,
        desc = 'Git Blame',
      },
    },
  },
  -- Git gutter signs, hunk staging/reset, and inline blame
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '│' },
        change = { text = '│' },
        delete = { text = '󰍵' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
        untracked = { text = '│' },
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map({ 'n', 'v' }, ']h', function()
          if vim.wo.diff then
            return ']h'
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return '<Ignore>'
        end, { expr = true, desc = 'Jump to next hunk' })

        map({ 'n', 'v' }, '[h', function()
          if vim.wo.diff then
            return '[h'
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return '<Ignore>'
        end, { expr = true, desc = 'Jump to previous hunk' })

        -- Actions
        -- visual mode
        map('v', '<leader>hs', function()
          gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end, { desc = 'stage git hunk' })
        map('v', '<leader>hr', function()
          gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end, { desc = 'reset git hunk' })

        map('n', '<leader>hs', gs.stage_hunk, { desc = 'git stage hunk' })
        map('n', '<leader>hr', gs.reset_hunk, { desc = 'git reset hunk' })
        map('n', '<leader>hS', gs.stage_buffer, { desc = 'git Stage buffer' })
        map('n', '<leader>hu', gs.undo_stage_hunk, { desc = 'undo stage hunk' })
        map('n', '<leader>hR', gs.reset_buffer, { desc = 'git Reset buffer' })
        map('n', '<leader>hp', gs.preview_hunk, { desc = 'preview git hunk' })
        map('n', '<leader>hb', function()
          gs.blame_line({ full = false })
        end, { desc = 'git blame line' })
        map('n', '<leader>hd', gs.diffthis, { desc = 'git diff against index' })
        map('n', '<leader>hD', function()
          gs.diffthis('~')
        end, { desc = 'git diff against last commit' })

        -- Toggles
        map('n', '<leader>gB', gs.toggle_current_line_blame, { desc = 'Git Sign Blame' })

        -- Text object
        map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'select git hunk' })
      end,
    },
  },

  ---------------------
  --- HIGHLIGHTING
  ---------------------
  -- Highlight TODO/FIXME/HACK comments in the codebase
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },
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
  { 'Bilal2453/luvit-meta',     lazy = true },

  ---------------------
  --- TEST
  ---------------------
  -- Run tests inline for Go, Vitest, Elixir, Dart, RSpec
  {
    'quolpr/quicktest.nvim',
    branch = 'main',
    config = require('config.quicktest'),
    dependencies = {
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
    },
    keys = {
      {
        '<leader>tl',
        function()
          local qt = require('quicktest')
          qt.run_line()
        end,
        desc = 'Test Run Line',
      },
      {
        '<leader>tf',
        function()
          local qt = require('quicktest')
          qt.run_file()
        end,
        desc = 'Test Run File',
      },
      {
        '<leader>ta',
        function()
          local qt = require('quicktest')
          qt.run_all()
        end,
        desc = 'Test Run All',
      },
      {
        '<leader>tp',
        function()
          local qt = require('quicktest')
          qt.run_previous()
        end,
        desc = 'Test Run Previous',
      },
      {
        '<leader>tt',
        function()
          local qt = require('quicktest')
          qt.toggle_win('split')
        end,
        desc = 'Test Toggle Window',
      },
      {
        '<leader>tc',
        function()
          local qt = require('quicktest')
          qt.cancel_current_run()
        end,
        desc = 'Test Cancel run',
      },
    },
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
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true },
      dashboard = { enabled = true },
      indent = {
        enabled = true,
        char = '▎',
        animate = {
          enabled = false,
        },
      },
      input = { enabled = true },
      picker = {
        enabled = true,
        layouts = {
          default = {
            layout = {
              box = 'horizontal',
              width = 0.95,
              height = 0.95,
              {
                box = 'vertical',
                border = 'rounded',
                title = '{source} {live}',
                title_pos = 'center',
                { win = 'input', height = 1,     border = 'bottom' },
                { win = 'list',  border = 'none' },
              },
              { win = 'preview', border = 'rounded', width = 0.5 },
            },
          },
        },
      },
      notifier = { enabled = true },
      quickfile = { enabled = true },
      statuscolumn = {
        left = { 'mark', 'sign', 'fold', 'git' },
        right = {},
        enabled = true,
      },
      words = { enabled = true },
      scratch = {
        ft = function()
          return 'markdown'
        end,
        win = { style = 'split' },
        filekey = {
          cwd = true,
          branch = true,
          count = false,
        },
      },
    },
    keys = {
      {
        '<leader>\\',
        function()
          Snacks.scratch()
        end,
        desc = 'Toggle Scratch Buffer',
      },
      {
        '<leader>gl',
        function()
          Snacks.gitbrowse()
        end,
        desc = 'Git link',
      },
      {
        '<leader>,',
        function()
          Snacks.picker.buffers()
        end,
        desc = 'Buffers',
      },
      {
        '<leader>/',
        function()
          Snacks.picker.grep()
        end,
        desc = 'Grep',
      },
      {
        '<leader><space>',
        function()
          Snacks.picker.files()
        end,
        desc = 'Find Files',
      },
      {
        '<leader>u',
        function()
          Snacks.picker.undo()
        end,
        desc = 'Undo Tree',
      },
      {
        '<leader>.',
        function()
          Snacks.picker.git_status()
        end,
        desc = 'Git find Status',
      },
      {
        '<leader>fw',
        function()
          Snacks.picker.grep_word()
        end,
        desc = 'Visual selection or word',
        mode = { 'n', 'x' },
      },
      {
        '<leader>f\\',
        function()
          Snacks.scratch.select()
        end,
        desc = 'Find Scratchpad',
        mode = { 'n', 'x' },
      },
      {
        '<leader>fr',
        function()
          Snacks.picker.resume()
        end,
        desc = 'Resume',
      },
      {
        'gd',
        function()
          Snacks.picker.lsp_definitions({ jump = { tagstack = true, reuse_win = false } })
        end,
        desc = 'Goto Definition',
      },
      {
        'gr',
        function()
          Snacks.picker.lsp_references({ jump = { tagstack = true, reuse_win = false } })
        end,
        nowait = true,
        desc = 'References',
      },
      {
        'gi',
        function()
          Snacks.picker.lsp_implementations({ jump = { tagstack = true, reuse_win = false } })
        end,
        desc = 'Goto Implementation',
      },
      {
        '<leader>fs',
        function()
          Snacks.picker.lsp_symbols()
        end,
        desc = 'LSP Symbols',
      },
      {
        '<leader>fS',
        function()
          Snacks.picker.lsp_workspace_symbols()
        end,
        desc = 'LSP Symbols',
      },
    },
  },

  ---------------------
  --- SEARCH / REPLACE
  ---------------------
  -- Global search and replace across project files
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

  ---------------------
  --- UNDO
  ---------------------
  -- Persistent undo history saved to disk across sessions
  {
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
  },

  ---------------------
  --- FILE PICKER
  ---------------------
  -- Frecency-based fuzzy file finder with native binary
  {
    'dmtrKovalenko/fff.nvim',
    build = function()
      require('fff.download').download_or_build_binary()
    end,
    dependencies = { 'folke/snacks.nvim' },
    opts = {
      debug = {
        enabled = true,
        show_scores = true,
      },
    },
    config = function(_, opts)
      require('fff').setup(opts)
    end,
    lazy = true,
  },
})

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
