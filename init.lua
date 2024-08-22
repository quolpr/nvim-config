--Last commit review: 5aeddfdd5d0308506ec63b0e4f8de33e2a39355fer

-- vim.lsp.set_log_level 'debug'

-- vim.opt.spell = true
-- vim.opt.spelllang = 'en_us,ru'
--

vim.opt.termguicolors = true
vim.opt.termsync = false

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
vim.keymap.set('n', '<leader>s', '<cmd> update <CR>', { desc = '[S]ave file' })

-- -- Delete all buffers except current
-- vim.keymap.set('n', '<leader>bd', '<cmd>%bd|e#<cr>', { desc = 'Close all buffers but the current one' }) -- https://stackoverflow.com/a/42071865/516188

-- copy/paste from computer buffer
vim.keymap.set({ 'n', 'v' }, '<leader>y', [["+y]], { desc = '[Y]ank from computer' })
vim.keymap.set('n', '<leader>p', [["+p]], { desc = '[P]aste from computer' })

-- Disable macro cause I don't use it + breaks cmp
vim.keymap.set('n', 'q', '<Nop>')

vim.keymap.set('n', '<leader>ps', function()
  vim.cmd [[
    profile start profile.log
    profile func *
    profile file *
  ]]
  vim.notify('Profile started', 'info')
end, { desc = '[P]rofile [S]tart' })
vim.keymap.set('n', '<leader>pe', function()
  vim.cmd [[
    profile pause
    noautocmd qall!
  ]]
end, { desc = '[P]rofile [S]tart' })

-- When you delete/paste don't rewrite last register
vim.keymap.set('x', '<leader>p', [["_dP]], { desc = '[P]aste without register overwriting' })
vim.keymap.set({ 'n', 'v' }, '<leader>d', [["_d]], { desc = '[D]elete without register overwriting' })

vim.keymap.set('n', 'T', ':tabnext <CR>', { desc = '[T]ab [N]ext' })
-- vim.keymap.set('n', 'Tc', ':tabclose <CR>', { desc = '[T]ab [C]lose' })

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
end, { desc = 'Go to previous diagnostic [E]rror message' })
vim.keymap.set('n', ']e', function()
  vim.diagnostic.goto_next { severity = { min = vim.diagnostic.severity.ERROR } }
end, { desc = 'Go to next diagnostic [E]rror message' })

vim.keymap.set('n', '[w', function()
  vim.diagnostic.goto_prev { severity = { min = vim.diagnostic.severity.WARN } }
end, { desc = 'Go to previous diagnostic [W]arn message' })
vim.keymap.set('n', ']w', function()
  vim.diagnostic.goto_next { severity = { min = vim.diagnostic.severity.WARN } }
end, { desc = 'Go to next diagnostic [W]arn message' })
vim.keymap.set('n', ']i', function()
  vim.diagnostic.goto_next { severity = { min = vim.diagnostic.severity.INFO } }
end, { desc = 'Go to next diagnostic [I]info message' })

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

local function lspSymbol(name, icon)
  local hl = 'DiagnosticSign' .. name
  vim.fn.sign_define(hl, { text = icon, numhl = hl, texthl = hl })
end

lspSymbol('Error', '󰅙')
lspSymbol('Info', '󰋼')
lspSymbol('Hint', '󰌵')
lspSymbol('Warn', '')

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

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
end, { noremap = true, silent = true, desc = '[R]eplace' })

-- Map the function to a key combination in visual mode
vim.keymap.set('n', '<leader>r', function()
  local word = vim.fn.expand '<cword>'
  vim.cmd('call feedkeys(":%s/' .. escape(word) .. '/")')
end, { noremap = true, silent = true, desc = '[R]eplace' })

vim.filetype.add {
  pattern = {
    ['openapi.*%.ya?ml'] = 'yaml.openapi',
    ['openapi.*%.json'] = 'json.openapi',
    ['swagger.ya?ml'] = 'yaml.openapi',
  },
}

vim.opt.langmap =
  'ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz'

vim.g.loaded_matchparen = 1
-- vim.g.loaded_matchit = 1

-- NOTE: Here is where you install your plugins.
require('lazy').setup {
  {
    'stevearc/aerial.nvim',
    opts = {},
    -- Optional dependencies
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require('aerial').setup {
        float = {
          relative = 'win',
          min_height = { 20, 0.5 },
          override = function(conf, source_winid)
            conf.width = 80
            conf.col = conf.col - (80 - 25) / 2
            -- This is the config that will be passed to nvim_open_win.
            -- Change values here to customize the layout
            return conf
          end,
        },
      }
    end,
    keys = {
      {
        '<leader>A',
        '<cmd>AerialToggle float<CR>',
        desc = '[A]erial',
      },
    },
  },
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
  -- {
  --   'Wansmer/langmapper.nvim',
  --   lazy = false,
  --   priority = 1, -- High priority is needed if you will use `autoremap()`
  --   config = function()
  --     require('langmapper').setup {}
  --   end,
  -- },

  -- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
  -- 'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
  -- NOTE: Plugins can also be added by using a table,
  -- with the first argument being the link and the following
  -- keys can be used to configure plugin behavior/loading/etc.
  --
  -- Use `opts = {}` to force a plugin to be loaded.
  --
  --  This is equivalent to:
  --    require('Comment').setup({})

  {
    'JoosepAlviste/nvim-ts-context-commentstring',
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('ts_context_commentstring').setup {
        enable_autocmd = false,
      }

      local get_option = vim.filetype.get_option
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.filetype.get_option = function(filetype, option)
        return option == 'commentstring' and require('ts_context_commentstring.internal').calculate_commentstring() or get_option(filetype, option)
      end
    end,
  },

  -- Here is a more advanced example where we pass configuration
  -- options to `gitsigns.nvim`. This is equivalent to the following lua:
  --    require('gitsigns').setup({ ... })
  --
  -- See `:help gitsigns` to understand what the configuration keys do
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
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

        -- gs.toggle_current_line_blame()

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
          gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'stage git hunk' })
        map('v', '<leader>hr', function()
          gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'reset git hunk' })

        map('n', '<leader>hs', gs.stage_hunk, { desc = 'git stage hunk' })
        map('n', '<leader>hr', gs.reset_hunk, { desc = 'git reset hunk' })
        map('n', '<leader>hS', gs.stage_buffer, { desc = 'git Stage buffer' })
        map('n', '<leader>hu', gs.undo_stage_hunk, { desc = 'undo stage hunk' })
        map('n', '<leader>hR', gs.reset_buffer, { desc = 'git Reset buffer' })
        map('n', '<leader>hp', gs.preview_hunk, { desc = 'preview git hunk' })
        map('n', '<leader>hb', function()
          gs.blame_line { full = false }
        end, { desc = 'git blame line' })
        map('n', '<leader>hd', gs.diffthis, { desc = 'git diff against index' })
        map('n', '<leader>hD', function()
          gs.diffthis '~'
        end, { desc = 'git diff against last commit' })

        -- Toggles
        map('n', '<leader>tb', gs.toggle_current_line_blame, { desc = 'toggle git blame line' })
        -- map('n', '<leader>td', gs.toggle_deleted, { desc = 'toggle git show deleted' })

        -- Text object
        map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'select git hunk' })
      end,
    },
  },

  -- NOTE: Plugins can also be configured to run lua code when they are loaded.
  --
  -- This is often very useful to both group configuration, as well as handle
  -- lazy loading plugins that don't need to be loaded immediately at startup.
  --
  -- For example, in the following configuration, we use:
  --  event = 'VimEnter'
  --
  -- which loads which-key before all the UI elements are loaded. Events can be
  -- normal autocommands events (`:help autocmd-events`).
  --
  -- Then, because we use the `config` key, the configuration only runs
  -- after the plugin has been loaded:
  --  config = function() ... end

  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    config = function() -- This is the function that runs, AFTER loading
      require('which-key').setup()

      -- Document existing key chains
      require('which-key').register {
        ['<leader>q'] = { name = '[Q]uit Persistence', _ = 'which_key_ignore' },
        ['<leader>t'] = { name = '[T]est', _ = 'which_key_ignore' },
        ['<leader>g'] = { name = '[G]it', _ = 'which_key_ignore' },
        ['<leader>n'] = { name = '[N]otes', _ = 'which_key_ignore' },
        ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
        ['<leader>h'] = { name = 'Git [H]unk', _ = 'which_key_ignore' },
        ['<leader>f'] = { name = '[F]ind', _ = 'which_key_ignore' },
        ['<leader>a'] = { name = 'Ch[a]tGPT', _ = 'which_key_ignore' },
      }
    end,
  },

  -- NOTE: Plugins can specify dependencies.
  --
  -- The dependencies are proper plugin specifications as well - anything
  -- you do for a plugin at the top level, you can do for a dependency.
  --
  -- Use the `dependencies` key to specify the dependencies of a particular plugin

  {
    'ibhagwan/fzf-lua',
    -- optional for icon support
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      -- calling `setup` is optional for customization
      require('fzf-lua').setup {
        nvim_freeze_workaround = 1,
        lsp = {
          symbols = {
            symbol_style = 2,
          },
        },
        -- files = {
        --   formatter = 'path.filename_first',
        -- },
        git = {
          files = {
            cmd = 'git ls-files --others --exclude-standard --cached',
          },
        },
        winopts = {
          preview = {
            horizontal = 'right:50%',
          },
          width = 0.90,
          height = 0.95,
        },
      }

      local fzf = require 'fzf-lua'

      vim.keymap.set('n', '<leader>ff', function()
        -- fzf.files { formatter = 'path.filename_first' }
        fzf.files()
      end, { desc = '[F]ind [F]iles' })

      vim.keymap.set('n', '<leader>fw', function()
        -- fzf.grep_cword { formatter = 'path.filename_first' }
        fzf.grep_cword()
      end, { desc = '[F]ind current [W]ord' })
      vim.keymap.set('v', '<leader>fw', function()
        -- fzf.grep_visual { formatter = 'path.filename_first' }
        fzf.grep_visual()
      end, { desc = '[F]ind current [W]ord' })

      vim.keymap.set('n', '<leader>fg', function()
        -- fzf.live_grep { formatter = 'path.filename_first' }
        fzf.live_grep()
      end, { desc = '[F]ind by [G]rep' })

      vim.keymap.set('n', '<leader>fr', fzf.resume, { desc = '[F]ind [R]esume' })

      -- In current buffer
      -- Use code -> diagnostics
      -- vim.keymap.set('n', '<leader>fd', function()
      --   fzf.diagnostics_document { formatter = 'path.filename_first' }
      -- end, { desc = '[F]ind [D]iagnostic' })
      --
      -- -- In all buffers
      -- vim.keymap.set('n', '<leader>fD', function()
      --   fzf.diagnostics_workspace { formatter = 'path.filename_first' }
      -- end, { desc = '[F]ind [D]iagnostic' })

      vim.keymap.set('n', '<leader>fo', function()
        -- fzf.git_status { formatter = 'path.filename_first' }
        fzf.git_status()
      end, { desc = '[F]ind by git status' })

      vim.keymap.set('n', '<leader><leader>', function()
        -- fzf.lsp_live_workspace_symbols { formatter = 'path.filename_first' }
        fzf.lsp_live_workspace_symbols()
      end, { desc = 'Find workspace symbols' })
    end,
  },

  -- { -- Fuzzy Finder (files, lsp, etc)
  --   'nvim-telescope/telescope.nvim',
  --   event = 'VimEnter',
  --   branch = 'master',
  --   dependencies = {
  --     'nvim-telescope/telescope-smart-history.nvim',
  --     'kkharji/sqlite.lua',
  --     'nvim-lua/plenary.nvim',
  --     -- 'nvim-telescope/telescope-frecency.nvim',
  --     { -- If encountering errors, see telescope-fz-native README for install instructions
  --       'nvim-telescope/telescope-fzf-native.nvim',
  --
  --       -- `build` is used to run some command when the plugin is installed/updated.
  --       -- This is only run then, not every time Neovim starts up.
  --       build = 'make',
  --
  --       -- `cond` is a condition used to determine whether this plugin should be
  --       -- installed and loaded.
  --       cond = function()
  --         return vim.fn.executable 'make' == 1
  --       end,
  --     },
  --     { 'nvim-telescope/telescope-ui-select.nvim' },
  --     {
  --
  --       'danielfalk/smart-open.nvim',
  --       branch = '0.2.x',
  --       dependencies = {
  --         'kkharji/sqlite.lua',
  --       },
  --     },
  --
  --     -- Useful for getting pretty icons, but requires special font.
  --     --  If you already have a Nerd Font, or terminal set up with fallback fonts
  --     --  you can enable this
  --     { 'nvim-tree/nvim-web-devicons' },
  --   },
  --   config = function()
  --     local data = assert(vim.fn.stdpath 'data') --[[@as string]]
  --
  --     local fzf_opts = {
  --       fuzzy = true, -- false will only do exact matching
  --       override_generic_sorter = true, -- override the generic sorter
  --       override_file_sorter = true, -- override the file sorter
  --       case_mode = 'smart_case', -- or "ignore_case" or "respect_case"
  --       -- the default case_mode is "smart_case"
  --     }
  --
  --     -- Telescope is a fuzzy finder that comes with a lot of different things that
  --     -- it can fuzzy find! It's more than just a "file finder", it can search
  --     -- many different aspects of Neovim, your workspace, LSP, and more!
  --     --
  --     -- The easiest way to use telescope, is to start by doing something like:
  --     --  :Telescope help_tags
  --     --
  --     -- After running this command, a window will open up and you're able to
  --     -- type in the prompt window. You'll see a list of help_tags options and
  --     -- a corresponding preview of the help.
  --     --
  --     -- Two important keymaps to use while in telescope are:
  --     --  - Insert mode: <c-/>
  --     --  - Normal mode: ?
  --     --
  --     -- This opens a window that shows you all of the keymaps for the current
  --     -- telescope picker. This is really useful to discover what Telescope can
  --     -- do as well as how to actually do it!
  --
  --     -- [[ Configure Telescope ]]
  --     -- See `:help telescope` and `:help telescope.setup()`
  --     require('telescope').setup {
  --       defaults = {
  --         path_display = { 'filename_first' },
  --         mappings = {
  --           i = {
  --             -- Cycle in history of search!
  --             ['<C-l>'] = require('telescope.actions').cycle_history_next,
  --             ['<C-h>'] = require('telescope.actions').cycle_history_prev,
  --           },
  --         },
  --       },
  --       -- You can put your default mappings / updates / etc. in here
  --       --  All the info you're looking for is in `:help telescope.setup()`
  --       --
  --       -- defaults = {
  --       --   mappings = {
  --       --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
  --       --   },
  --       -- },
  --       -- pickers = {}
  --       extensions = {
  --         wrap_results = true,
  --         fzf = fzf_opts,
  --         ['ui-select'] = {
  --           require('telescope.themes').get_dropdown(),
  --         },
  --
  --         history = {
  --           path = vim.fs.joinpath(data, 'telescope_history.sqlite3'),
  --           limit = 100,
  --         },
  --         -- frecency = {
  --         --   workspace = 'CWD',
  --         --   ignore_patterns = { '*.git/*', '*/tmp/*' },
  --         --   show_scores = true,
  --         --   show_unindexed = false,
  --         --   disable_devicons = false,
  --         --   db_safe_mode = false,
  --         --   path_display = { 'truncate' },
  --         -- },
  --
  --         smart_open = {
  --           match_algorithm = 'fzf',
  --           show_scores = true,
  --           result_limit = 25,
  --         },
  --       },
  --       pickers = {
  --         colorscheme = {
  --           enable_preview = true,
  --         },
  --         lsp_dynamic_workspace_symbols = {
  --           sorter = require('telescope').extensions.fzf.native_fzf_sorter(fzf_opts),
  --         },
  --       },
  --     }
  --
  --     -- Enable telescope extensions, if they are installed
  --     pcall(require('telescope').load_extension, 'fzf')
  --     pcall(require('telescope').load_extension, 'ui-select')
  --     -- To cycle back is search history
  --     pcall(require('telescope').load_extension, 'smart_history')
  --     -- require('telescope').load_extension 'frecency'
  --     require('telescope').load_extension 'smart_open'
  --     -- require('telescope').load_extension 'harpoon'
  --
  --     -- local harpoon = require 'harpoon'
  --     -- local conf = require('telescope.config').values
  --     -- local function toggle_telescope(harpoon_files)
  --     --   local file_paths = {}
  --     --   for _, item in ipairs(harpoon_files.items) do
  --     --     table.insert(file_paths, item.value)
  --     --   end
  --     --
  --     --   require('telescope.pickers')
  --     --     .new({}, {
  --     --       prompt_title = 'Harpoon',
  --     --       finder = require('telescope.finders').new_table {
  --     --         results = file_paths,
  --     --       },
  --     --       previewer = conf.file_previewer {},
  --     --       sorter = conf.generic_sorter {},
  --     --     })
  --     --     :find()
  --     -- end
  --     --
  --     -- vim.keymap.set('n', '<leader>fh', function()
  --     --   toggle_telescope(harpoon:list())
  --     -- end, { desc = 'Open harpoon window' })
  --
  --     -- vim.keymap.set('n', '<C-e>', function()
  --     --   toggle_telescope(harpoon:list())
  --     -- end, { desc = 'Open harpoon window' })
  --
  --     -- See `:help telescope.builtin`
  --     local builtin = require 'telescope.builtin'
  --
  --     -- vim.keymap.set('n', '<leader>ff', function()
  --     --   builtin.git_files { show_untracked = true }
  --     -- end, { desc = '[F]ind [F]iles' })
  --
  --     vim.keymap.set('v', '<leader>fw', function()
  --       local text = getVisualSelection()
  --       builtin.grep_string { search = text }
  --     end, { desc = '[F]ind current [W]ord' })
  --
  --     vim.keymap.set('n', '<leader>fw', builtin.grep_string, { desc = '[F]ind current [W]ord' })
  --     vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = '[F]ind by [G]rep' })
  --     vim.keymap.set('n', '<leader>fr', builtin.resume, { desc = '[F]ind [R]esume' })
  --
  --     -- In current buffer
  --     vim.keymap.set('n', '<leader>fd', function()
  --       builtin.diagnostics { bufnr = 0 }
  --     end, { desc = '[F]ind [D]iagnostic' })
  --     -- In all buffers
  --     vim.keymap.set('n', '<leader>fD', function()
  --       builtin.diagnostics { bufnr = nil }
  --     end, { desc = '[F]ind [D]iagnostic' })
  --
  --     vim.keymap.set('n', '<leader>fs', function()
  --       builtin.lsp_document_symbols { fname_width = 60, symbol_width = 60 }
  --     end, { desc = '[F]ind [S]ymbols' })
  --     vim.keymap.set('n', '<leader>fS', builtin.lsp_dynamic_workspace_symbols, { desc = '[F]ind [S]ymbols' })
  --     -- vim.keymap.set('n', '<leader>fh', builtin.search_history, { desc = '[F]ind [H]istory' })
  --     -- vim.keymap.set('n', '<leader><leader>', builtin.git_status, { desc = '[F]ind by git [S]tatus' })
  --
  --     vim.keymap.set('n', '<leader>ff', function()
  --       require('telescope').extensions.smart_open.smart_open {
  --         cwd_only = true,
  --       }
  --       -- require('telescope').extensions.frecency.frecency {
  --       --   workspace = 'CWD',
  --       -- }
  --     end, { desc = '[F]ind [F]iles' })
  --
  --     vim.keymap.set('n', '<leader>fo', function()
  --       builtin.git_status()
  --     end, { desc = '[F]ind by git status' })
  --
  --     vim.keymap.set('n', '<leader><leader>', function()
  --       builtin.lsp_dynamic_workspace_symbols()
  --     end, { desc = '[F]ind by git [S]tatus' })
  --
  --     -- vim.keymap.set('n', '<leader>fm', function()
  --     --   builtin.marks { mark_type = 'local' }
  --     -- end, { desc = '[F]ind [M]arks' })
  --     -- vim.keymap.set('n', '<leader>fm', function()
  --     --   require('telescope').extensions.harpoon.marks()
  --     -- end, { desc = '[F]ind [M]arks' })
  --
  --     -- Shortcut for searching your neovim configuration files
  --     -- vim.keymap.set('n', '<leader>fn', function()
  --     --   builtin.find_files { cwd = vim.fn.stdpath 'config' }
  --     -- end, { desc = '[S]earch [N]eovim files' })
  --   end,
  -- },

  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      'fzf-lua',
      -- 'luckasRanarison/clear-action.nvim',

      -- Useful status updates for LSP.
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', opts = {} },
    },
    config = function()
      -- For autoformat conform.nvim is used
      -- local format_is_enabled = true

      -- Create an augroup that is used for managing our formatting autocmds.
      --      We need one augroup per client to make sure that multiple clients
      --      can attach to the same buffer without interfering with each other.
      -- local _augroups = {}
      -- local get_augroup = function(client)
      --   if not _augroups[client.id] then
      --     local group_name = 'kickstart-lsp-format-' .. client.name
      --     local id = vim.api.nvim_create_augroup(group_name, { clear = true })
      --     _augroups[client.id] = id
      --   end
      --
      --   return _augroups[client.id]
      -- end

      -- vim.api.nvim_create_autocmd('LspAttach', {
      --   group = vim.api.nvim_create_augroup('kickstart-lsp-attach-format', { clear = true }),
      --   callback = function(args)
      --     local client_id = args.data.client_id
      --     local client = vim.lsp.get_client_by_id(client_id)
      --     local bufnr = args.buf
      --
      --     -- Only attach to clients that support document formatting
      --     if not client.server_capabilities.documentFormattingProvider then
      --       return
      --     end
      --
      --     -- Tsserver usually works poorly. Sorry you work with bad languages
      --     -- You can remove this line if you know what you're doing :)
      --     if client.name == 'tsserver' or client.name == 'typescript-tools' then
      --       return
      --     end
      --
      --     -- Create an autocmd that will run *before* we save the buffer.
      --     --  Run the formatting command for the LSP that has just attached.
      --     vim.api.nvim_create_autocmd('BufWritePre', {
      --       group = get_augroup(client),
      --       buffer = bufnr,
      --       callback = function()
      --         if not format_is_enabled then
      --           return
      --         end
      --
      --         vim.lsp.buf.format {
      --           async = false,
      --           filter = function(c)
      --             return c.id == client.id
      --           end,
      --         }
      --       end,
      --     })
      --   end,
      -- })

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local client = vim.lsp.get_client_by_id(event.data.client_id)

          -- client.handlers['textDocument/publishDiagnostics'] = function(err, result, ctx, config)
          --   print(vim.inspect(err), vim.inspect(result), vim.inspect(ctx), vim.inspect(config))
          -- end

          -- NOTE: Remember that lua is a real programming language, and as such it is possible
          -- to define small helper and utility functions so you don't have to repeat yourself
          -- many times.
          --
          -- In this case, we create a function that lets us more easily define mappings specific
          -- for LSP related items. It sets the mode, buffer and description for us each time.
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          local vmap = function(keys, func, desc)
            vim.keymap.set('v', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-T>.
          map('gd', function()
            require('fzf-lua').lsp_definitions { formatter = 'path.filename_first' }
          end, '[G]oto [D]efinition')

          -- Find references for the word under your cursor.
          map('gr', function()
            require('fzf-lua').lsp_references { formatter = 'path.filename_first' }
          end, '[G]oto [R]eferences')

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          map('gi', function()
            require('fzf-lua').lsp_implementations { formatter = 'path.filename_first' }
          end, '[G]oto [I]mplementation')

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          map('gD', function()
            require('fzf-lua').lsp_typedefs { formatter = 'path.filename_first' }
          end, 'Type [D]efinition')

          map('gc', function()
            require('fzf-lua').lsp_outgoing_calls { formatter = 'path.filename_first' }
          end, '[G]oto outgoing [C]alls')
          map('gC', function()
            require('fzf-lua').lsp_incoming_calls { formatter = 'path.filename_first' }
          end, '[G]oto incoming [C]alls')

          map('ds', vim.diagnostic.open_float, '[D]iagnost [S]how')

          -- -- Jump to the definition of the word under your cursor.
          -- --  This is where a variable was first declared, or where a function is defined, etc.
          -- --  To jump back, press <C-T>.
          -- map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
          --
          -- map('ds', vim.diagnostic.open_float, '[D]iagnost [S]how')
          --
          -- -- Find references for the word under your cursor.
          -- map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
          --
          -- -- Jump to the implementation of the word under your cursor.
          -- --  Useful when your language has ways of declaring types without an actual implementation.
          -- map('gi', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
          --
          -- -- Jump to the type of the word under your cursor.
          -- --  Useful when you're not sure what type a variable is and you want to see
          -- --  the definition of its *type*, not where it was *defined*.
          -- map('gD', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
          --
          -- -- Fuzzy find all the symbols in your current document.
          -- --  Symbols are things like variables, functions, types, etc.
          -- map('<leader>cs', require('telescope.builtin').lsp_document_symbols, '[C]ode [S]ymbols')
          --
          -- -- Fuzzy find all the symbols in your current workspace
          -- --  Similar to document symbols, except searches over your whole project.
          -- map('<leader>cS', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[C]ode workspace [S]ymbols')

          -- Rename the variable under your cursor
          --  Most Language Servers support renaming across files, etc.
          map('<leader>cc', vim.lsp.buf.rename, '[C]ode [C]hange')

          -- https://github.com/neovim/neovim/issues/29500
          local function get_diagnostic_at_cursor()
            local cur_buf = vim.api.nvim_get_current_buf()
            local line, col = unpack(vim.api.nvim_win_get_cursor(0))
            local entries = vim.diagnostic.get(cur_buf, { lnum = line - 1 })
            local res = {}
            for _, v in pairs(entries) do
              if v.col <= col and v.end_col >= col then
                table.insert(res, {
                  code = v.code,
                  message = v.message,
                  range = {
                    ['start'] = {
                      character = vim.lsp.util.character_offset(cur_buf, v.lnum, v.col, 'utf-16'),
                      line = v.lnum,
                    },
                    ['end'] = {
                      character = vim.lsp.util.character_offset(cur_buf, v.end_lnum, v.end_col, 'utf-16'),
                      line = v.end_lnum,
                    },
                  },
                  severity = v.severity,
                  source = v.source or nil,
                })
              end
            end
            return res
          end
          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map('<leader>ca', function()
            require('fzf-lua').lsp_code_actions {
              -- vim.lsp.buf.code_action {
              -- once = get_diagnostic_at_cursor(),
              context = {
                diagnostics = get_diagnostic_at_cursor(),
              },
              filter = function(action)
                if string.find(action.title, 'to user settings') then
                  return false
                end

                return true
              end,
              -- query='!tousersettings '
            }
          end, '[C]ode [A]ction')

          -- vmap('<leader>ca', function()
          --   require('fzf-lua').lsp_code_actions {}
          -- end, '[C]ode [A]ction')

          -- Opens a popup that displays documentation about the word under your cursor
          --  See `:help K` for why this keymap
          map('K', vim.lsp.buf.hover, 'Hover Documentation')

          if client and client.name ~= 'elixirls' then
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
          end

          if client and client.name == 'gopls' then
            if not client.server_capabilities.semanticTokensProvider then
              local semantic = client.config.capabilities.textDocument.semanticTokens

              if semantic then
                client.server_capabilities.semanticTokensProvider = {
                  full = true,
                  legend = {
                    tokenTypes = semantic.tokenTypes,
                    tokenModifiers = semantic.tokenModifiers,
                  },
                  range = true,
                }
              end
            end
          end

          -- -- The following two autocommands are used to highlight references of the
          -- -- word under your cursor when your cursor rests there for a little while.
          -- --    See `:help CursorHold` for information about when this is executed
          -- --
          -- -- When you move your cursor, the highlights will be cleared (the second autocommand).
          -- if client and client.server_capabilities.documentHighlightProvider then
          --   local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
          --   vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
          --     buffer = event.buf,
          --     group = highlight_augroup,
          --     callback = vim.lsp.buf.document_highlight,
          --   })
          --
          --   vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
          --     buffer = event.buf,
          --     group = highlight_augroup,
          --     callback = vim.lsp.buf.clear_references,
          --   })
          --
          --   vim.api.nvim_create_autocmd('LspDetach', {
          --     group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
          --     callback = function(event2)
          --       vim.lsp.buf.clear_references()
          --       vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
          --     end,
          --   })
          -- end

          -- The following autocommand is used to enable inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
            -- vim.lsp.inlay_hint.enable(true)

            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled {})
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP Specification.
      --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      -- Enable the following language servers
      --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
      --
      --  Add any additional override configuration in the following tables. Available keys are:
      --  - cmd (table): Override the default command used to start the server
      --  - filetypes (table): Override the default list of associated filetypes for the server
      --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
      --  - settings (table): Override the default settings passed when initializing the server.
      --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
      local servers = {
        -- clangd = {},
        gopls = {
          settings = {
            gopls = {
              gofumpt = true,
              codelenses = {
                gc_details = false,
                generate = true,
                regenerate_cgo = true,
                run_govulncheck = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
                vendor = true,
              },
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
              analyses = {
                fieldalignment = false,
                nilness = true,
                unusedparams = true,
                unusedwrite = true,
                useany = true,
              },
              usePlaceholders = false,
              completeUnimported = true,
              staticcheck = true,
              directoryFilters = { '-.git', '-.vscode', '-.idea', '-.vscode-test', '-node_modules' },
              semanticTokens = true,
            },
          },
        },
        golangci_lint_ls = {},
        -- pyright = {},
        -- rust_analyzer = {},
        -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
        --
        -- Some languages (like typescript) have entire language plugins that can be useful:
        --    https://github.com/pmizio/typescript-tools.nvim
        --
        -- But for many setups, the LSP (`tsserver`) will work just fine
        -- tsserver = {},
        --

        elixirls = {},
        tsserver = {
          init_options = {
            -- This is the default which would be overwritten otherwise
            hostInfo = 'neovim',
            -- 16 gb
            maxTsServerMemory = 16384,
            -- Never use LSP for syntax anyway
            tsserver = { useSyntaxServer = 'never' },
          },
        },
        sqlls = {},
        eslint = {},
        biome = {},
        bufls = {},
        -- yamlls = {},
        --
        vacuum = {},
        lua_ls = {
          -- cmd = {...},
          -- filetypes { ...},
          -- capabilities = {},
          settings = {
            Lua = {
              hint = {
                enable = true,
              },
              completion = {
                callSnippet = 'Replace',
              },
              -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              -- diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
      }

      -- Ensure the servers and tools above are installed
      --  To check the current status of installed tools and/or manually install
      --  other tools, you can run
      --    :Mason
      --
      --  You can press `g?` for help in this menu
      require('mason').setup()

      -- You can add other tools here that you want Mason to install
      -- for you, so that they are available from within Neovim.
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua',
        'prettierd',
        'stylua',
        'delve',
        -- 'yaml-language-server',
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      local configs = require 'lspconfig.configs'
      configs['cSpell'] = require 'cspell-lsp'
      local lspServer = {}
      lspServer.capabilities = vim.tbl_deep_extend('force', {}, capabilities)
      require('lspconfig')['cSpell'].setup(lspServer)

      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for tsserver)
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },
  { -- Autoformat
    dir = '~/.config/nvim/plugins/history',
    config = function()
      local history = require 'history'

      vim.keymap.set('n', '<leader>fh', function()
        history()
      end, { desc = '[F]ind [H]istory' })
    end,
  },
  { -- Autoformat
    'stevearc/conform.nvim',
    lazy = false,
    opts = {
      notify_on_error = false,
      format_after_save = {
        lsp_fallback = true,
        timeout_ms = 5000,
      },
      -- format_on_save = {
      --   timeout_ms = 2000,
      --   lsp_fallback = true,
      --   async = true,
      -- },
      formatters_by_ft = {
        lua = { 'stylua' },
        -- Conform can also run multiple formatters sequentially
        -- python = { "isort", "black" },
        --
        -- You can use a sub-list to tell conform to run *until* a formatter
        -- is found.
        javascript = { { 'biome' } },
        typescript = { { 'biome' } },
        -- json = { { 'biome' } },
        typescriptreact = { { 'biome' } },
        go = { 'gofmt', 'goimports' },
        proto = { 'buf' },
      },
    },
  },
  {
    'folke/lazydev.nvim',
    ft = 'lua', -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = 'luvit-meta/library', words = { 'vim%.uv' } },
      },
    },
  },
  { 'Bilal2453/luvit-meta', lazy = true }, -- optional `vim.uv` typings
  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      -- {
      --   'L3MON4D3/LuaSnip',
      --   build = (function()
      --     -- Build Step is needed for regex support in snippets
      --     -- This step is not supported in many windows environments
      --     -- Remove the below condition to re-enable on windows
      --     if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
      --       return
      --     end
      --     return 'make install_jsregexp'
      --   end)(),
      --   dependencies = {
      --     -- `friendly-snippets` contains a variety of premade snippets.
      --     --    See the README about individual language/framework/plugin snippets:
      --     --    https://github.com/rafamadriz/friendly-snippets
      --     {
      --       'rafamadriz/friendly-snippets',
      --       config = function()
      --         require('luasnip.loaders.from_vscode').lazy_load()
      --       end,
      --     },
      --   },
      -- },
      -- 'saadparwaiz1/cmp_luasnip',

      -- Adds other completion capabilities.
      --  nvim-cmp does not ship with all sources by default. They are split
      --  into multiple repos for maintenance purposes.
      'hrsh7th/cmp-nvim-lsp',

      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'onsails/lspkind.nvim',

      -- nvim-cmp source for neovim Lua API
      -- so that things like vim.keymap.set, etc. are autocompleted
      'hrsh7th/cmp-nvim-lua',
      -- {
      --   'MattiasMTS/cmp-dbee',
      --   ft = 'sql', -- optional but good to have
      --   opts = {}, -- needed
      -- },
    },
    -- luasnip has horrible performance :(
    config = function()
      -- See `:help cmp`
      local cmp = require 'cmp'
      -- local luasnip = require 'luasnip'
      -- luasnip.config.setup {}

      cmp.setup {
        preselect = cmp.PreselectMode.None,
        -- snippet = {
        --   expand = function(args)
        --     luasnip.lsp_expand(args.body)
        --   end,
        -- },
        completion = { completeopt = 'menu,menuone,noinsert' },

        -- For an understanding of why these mappings were
        -- chosen, you will need to read `:help ins-completion`
        --
        -- No, but seriously. Please read `:help ins-completion`, it is really good!
        mapping = cmp.mapping.preset.insert {
          -- Select the [n]ext item
          ['<C-n>'] = cmp.mapping.select_next_item(),
          -- Select the [p]revious item
          ['<C-p>'] = cmp.mapping.select_prev_item(),

          -- Accept ([y]es) the completion.
          --  This will auto-import if your LSP supports it.
          --  This will expand snippets if the LSP sent a snippet.
          ['<Tab>'] = cmp.mapping.confirm { select = false },

          -- Manually trigger a completion from nvim-cmp.
          --  Generally you don't need this, because nvim-cmp will display
          --  completions whenever it has completion options available.
          ['<C-Space>'] = cmp.mapping.complete {},

          -- Think of <c-l> as moving to the right of your snippet expansion.
          --  So if you have a snippet that's like:
          --  function $name($args)
          --    $body
          --  end
          --
          -- <c-l> will move you to the right of each of the expansion locations.
          -- <c-h> is similar, except moving you backwards.

          -- TODO: fix
          -- ['<C-l>'] = cmp.mapping(function()
          --   -- if luasnip.expand_or_locally_jumpable() then
          --   --   luasnip.expand_or_jump()
          --   -- end
          -- end, { 'i', 's' }),
          -- ['<C-h>'] = cmp.mapping(function()
          --   -- if luasnip.locally_jumpable(-1) then
          --   --   luasnip.jump(-1)
          --   -- end
          -- end, { 'i', 's' }),
        },
        sources = {
          {
            name = 'lazydev',
            group_index = 0, -- set group index to 0 to skip loading LuaLS completions
          },
          { name = 'nvim_lsp' },
          { name = 'nvim_lua' },
          { name = 'buffer' },
          { name = 'path' },
          -- { name = 'cmp-dbee' },
          -- { name = 'luasnip' },
        },
        ---@diagnostic disable-next-line: missing-fields
        formatting = {
          format = require('lspkind').cmp_format {
            mode = 'symbol_text', -- show only symbol annotations
            maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
            ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
          },
        },
      }
    end,
  },
  {
    'rose-pine/neovim',
    name = 'rose-pine',
    config = function()
      require 'rose-pine'

      vim.cmd.colorscheme 'rose-pine-moon'
    end,
  },
  -- Highlight todo, notes, etc in comments
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },

  -- { -- Collection of various small independent plugins/modules
  --   'echasnovski/mini.nvim',
  --   config = function()
  --     -- Better Around/Inside textobjects
  --     --
  --     -- Examples:
  --     --  - va)  - [V]isually select [A]round [)]paren
  --     --  - yinq - [Y]ank [I]nside [N]ext [']quote
  --     --  - ci'  - [C]hange [I]nside [']quote
  --     -- require('mini.ai').setup { n_lines = 500 }
  --
  --     -- require('mini.hues').setup { background = '#002734', foreground = '#c0c8cc' }
  --     -- Add/delete/replace surroundings (brackets, quotes, etc.)
  --     --
  --     -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
  --     -- - sd'   - [S]urround [D]elete [']quotes
  --     -- - sr)'  - [S]urround [R]eplace [)] [']
  --     -- require('mini.surround').setup()
  --
  --     -- ... and there is more!
  --     --  Check out: https://github.com/echasnovski/mini.nvim
  --   end,
  -- },

  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    config = function()
      -- [[ Configure Treesitter ]] See `:help nvim-treesitter`

      ---@diagnostic disable-next-line: missing-fields
      require('nvim-treesitter.configs').setup {
        ensure_installed = { 'bash', 'c', 'html', 'lua', 'markdown', 'vim', 'vimdoc', 'diff' },
        -- Autoinstall languages that are not installed
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = '<c-space>',
            node_incremental = '<c-space>',

            node_decremental = '<bs>',
            -- -- scope_incremental = '<c-S>',
          },
        },
        -- Slow downs vim https://github.com/nvim-treesitter/nvim-treesitter/issues/5868
        -- textobjects = {
        --   select = {
        --     enable = true,
        --     lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
        --     keymaps = {
        --       -- You can use the capture groups defined in textobjects.scm
        --       -- a = means argument
        --       ['ia'] = '@parameter.inner',
        --       ['aa'] = '@parameter.outer',
        --       ['af'] = '@function.outer',
        --       ['if'] = '@function.inner',
        --       ['ac'] = '@class.outer',
        --       ['ic'] = '@class.inner',
        --       ['ii'] = '@conditional.inner',
        --       ['ai'] = '@conditional.outer',
        --       ['il'] = '@loop.inner',
        --       ['al'] = '@loop.outer',
        --       ['at'] = '@comment.outer',
        --     },
        --   },
        --   move = {
        --     enable = true,
        --     set_jumps = true, -- whether to set jumps in the jumplist
        --     goto_next_start = {
        --       [']f'] = '@function.outer',
        --       [']]'] = '@class.outer',
        --     },
        --     goto_next_end = {
        --       [']F'] = '@function.outer',
        --       [']['] = '@class.outer',
        --     },
        --     goto_previous_start = {
        --       ['[f'] = '@function.outer',
        --       ['[['] = '@class.outer',
        --     },
        --     goto_previous_end = {
        --       ['[F'] = '@function.outer',
        --       ['[]'] = '@class.outer',
        --     },
        --   },
        --   -- swap = {
        --   --   enable = true,
        --   --   swap_next = {
        --   --     ['<leader>a'] = '@parameter.inner',
        --   --   },
        --   --   swap_previous = {
        --   --     ['<leader>A'] = '@parameter.inner',
        --   --   },
        --   -- },
        -- },
      }

      -- There are additional nvim-treesitter modules that you can use to interact
      -- with nvim-treesitter. You should go explore a few and see what interests you:
      --
      --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
      --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
      --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
    end,
  },

  -- The following two comments only work if you have downloaded the kickstart repo, not just copy pasted the
  -- init.lua. If you want these files, they are in the repository, so you can just download them and
  -- put them in the right spots if you want.

  -- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for kickstart
  --
  --  Here are some example plugins that I've included in the kickstart repository.
  --  Uncomment any of the lines below to enable them (you will need to restart nvim).
  --
  -- require 'kickstart.plugins.debug',
  -- require 'kickstart.plugins.indent_line',

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    This is the easiest way to modularize your config.
  --
  --  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  --    For additional information, see `:help lazy.nvim-lazy.nvim-structuring-your-plugins`
  -- { import = 'custom.plugins' },

  -- My additional plugins:

  'mg979/vim-visual-multi',
  -- 'tpope/vim-fugitive',
  {
    -- 'NeogitOrg/neogit',
    dir = '~/projects/quolpr/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim', -- required
      -- Only one of these is needed, not both.
      'nvim-telescope/telescope.nvim', -- optional
      'ibhagwan/fzf-lua', -- optional
    },
    config = function()
      local neogit = require 'neogit'
      neogit.setup {}
    end,
    keys = {
      {
        '<leader>go',
        function()
          local neogit = require 'neogit'
          neogit.open { kind = 'split_above_all' }
        end,
        desc = '[G]it [O]pen',
      },
    },
  },
  {
    'sindrets/diffview.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    keys = {
      {
        '<leader>gh',
        function()
          vim.cmd 'DiffviewFileHistory %'
        end,
        desc = '[G]it file [h]istory',
      },
      {
        '<leader>gH',
        function()
          vim.cmd 'DiffviewFileHistory'
        end,
        desc = '[G]it [H]istory',
      },
    },
  },
  {
    'FabijanZulj/blame.nvim',
    config = function()
      require('blame').setup()
    end,
    keys = {
      {
        '<leader>gb',
        function()
          vim.cmd 'BlameToggle'
        end,
        desc = '[G]it [B]lame',
      },
    },
  },
  -- {
  --   'ruifm/gitlinker.nvim',
  --   dependencies = {
  --     'nvim-lua/plenary.nvim',
  --   },
  --   config = function()
  --     require('gitlinker').setup()
  --     -- gy = [g]it [y]ank
  --   end,
  -- },

  -- {
  --   'zbirenbaum/copilot.lua',
  --   config = function()
  --     vim.g.copilot_proxy = 'http://91.108.241.124:56382'
  --
  --     require('copilot').setup {
  --       suggestion = {
  --         auto_trigger = true,
  --         keymap = {
  --           accept = '<C-u>',
  --           accept_word = false,
  --           accept_line = false,
  --           next = '<C-j>',
  --           prev = '<C-k>',
  --           dismiss = '<C-d>',
  --         },
  --       },
  --       filetypes = {
  --         yaml = true,
  --       },
  --     }
  --   end,
  --   dependencies = {
  --     'AndreM222/copilot-lualine',
  --   },
  -- },

  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    config = function()
      -- Eviline config for lualine
      -- Author: shadmansaleh
      -- Credit: glepnir
      local lualine = require 'lualine'

      -- Color table for highlights
      -- stylua: ignore
      local colors = {
        bg       = '#202328',
        fg       = '#bbc2cf',
        yellow   = '#ECBE7B',
        cyan     = '#008080',
        darkblue = '#081633',
        green    = '#98be65',
        orange   = '#FF8800',
        violet   = '#a9a1e1',
        magenta  = '#c678dd',
        blue     = '#51afef',
        red      = '#ec5f67',
      }

      vim.cmd 'highlight! HarpoonInactive guibg=NONE guifg=#63698c'
      vim.cmd 'highlight! HarpoonActive guibg=NONE guifg=white'
      vim.cmd 'highlight! HarpoonNumberActive guibg=NONE guifg=#7aa2f7'
      vim.cmd 'highlight! HarpoonNumberInactive guibg=NONE guifg=#7aa2f7'
      vim.cmd 'highlight! TabLineFill guibg=NONE guifg=white'

      local conditions = {
        buffer_not_empty = function()
          return vim.fn.empty(vim.fn.expand '%:t') ~= 1
        end,
        hide_in_width = function()
          return vim.fn.winwidth(0) > 80
        end,
        check_git_workspace = function()
          local filepath = vim.fn.expand '%:p:h'
          local gitdir = vim.fn.finddir('.git', filepath .. ';')
          return gitdir and #gitdir > 0 and #gitdir < #filepath
        end,
      }

      function Harpoon_files()
        -- Function to truncate the last directory and filename using Neovim's API
        local function truncate_last_dir_and_filename(file_path)
          -- Get the directory containing the file
          local dir = vim.fn.fnamemodify(file_path, ':h')
          -- Extract the last directory name
          local last_dir = vim.fn.fnamemodify(dir, ':t')
          -- Get the filename
          local filename = vim.fn.fnamemodify(file_path, ':t')
          -- Extract the extension from the filename
          local base, ext = string.match(filename, '(.-)%.([^%.]+)$')

          -- Truncate the last directory name and the base of the filename to the first 4 characters
          if #last_dir > 4 then
            last_dir = string.sub(last_dir, 1, 4)
          end
          if #base > 4 then
            base = string.sub(base, 1, 4)
          end

          if last_dir == '.' then
            local truncated_path = base .. '.' .. ext
            return truncated_path
          else
            local truncated_path = last_dir .. '/' .. base .. '.' .. ext
            return truncated_path
          end
        end

        -- Function to get the last directory and filename using Vim's API
        local function get_last_dir_and_filename(file_path)
          -- Get the directory containing the file
          local dir = vim.fn.fnamemodify(file_path, ':h')
          -- Get the last part of the directory (last directory name)
          local last_dir = vim.fn.fnamemodify(dir, ':t')
          -- Get the file name
          local filename = vim.fn.fnamemodify(file_path, ':t')

          if last_dir == '.' then
            return filename
          else
            return last_dir .. '/' .. filename
          end
        end

        local harpoon = require 'harpoon'
        local contents = {}
        local marks_length = harpoon:list():length()
        local current_file_path = vim.fn.fnamemodify(vim.fn.expand '%:p', ':.')
        for index = 1, marks_length do
          local harpoon_file_path = harpoon:list():get(index).value
          local file_name = harpoon_file_path == '' and '(empty)' or truncate_last_dir_and_filename(harpoon_file_path)

          if current_file_path == harpoon_file_path then
            contents[index] = string.format('%%#HarpoonNumberActive# %s. %%#HarpoonActive#%s ', index, file_name)
          else
            contents[index] = string.format('%%#HarpoonNumberInactive# %s. %%#HarpoonInactive#%s ', index, file_name)
          end
        end

        return table.concat(contents)
      end

      -- Config
      local config = {
        options = {
          -- Disable sections and component separators
          component_separators = '',
          section_separators = '',
          -- theme = {
          --   -- We are going to use lualine_c an lualine_x as left and
          --   -- right section. Both are highlighted by c theme .  So we
          --   -- are just setting default looks o statusline
          --   -- normal = { c = { fg = colors.fg, bg = colors.bg } },
          --   -- inactive = { c = { fg = colors.fg, bg = colors.bg } },
          -- },
        },
        sections = {
          -- these are to remove the defaults
          lualine_a = {},
          lualine_b = {},
          lualine_y = {},
          lualine_z = {},
          -- These will be filled later
          lualine_c = {},
          lualine_x = {},
        },
        inactive_sections = {
          -- these are to remove the defaults
          lualine_a = {},
          lualine_b = {},
          lualine_y = {},
          lualine_z = {},
          lualine_c = { 'filename' },
          lualine_x = {},
        },
        tabline = {
          lualine_a = {
            { Harpoon_files },
          },
        },
      }

      -- Inserts a component in lualine_c at left section
      local function ins_left(component)
        table.insert(config.sections.lualine_c, component)
      end

      -- Inserts a component in lualine_x at right section
      local function ins_right(component)
        table.insert(config.sections.lualine_x, component)
      end

      ins_left {
        -- mode component
        function()
          return ' '
        end,
        color = function()
          -- auto change color according to neovims mode
          local mode_color = {
            n = colors.fg,
            i = colors.green,
            v = colors.blue,
            [''] = colors.blue,
            V = colors.blue,
            c = colors.magenta,
            no = colors.red,
            s = colors.orange,
            S = colors.orange,
            [''] = colors.orange,
            ic = colors.yellow,
            R = colors.violet,
            Rv = colors.violet,
            cv = colors.red,
            ce = colors.red,
            r = colors.cyan,
            rm = colors.cyan,
            ['r?'] = colors.cyan,
            ['!'] = colors.red,
            t = colors.red,
          }
          return { fg = mode_color[vim.fn.mode()] }
        end,
        padding = { right = 1 },
      }

      ins_left {
        'filename',
        cond = conditions.buffer_not_empty,
      }

      ins_left {
        'diagnostics',
        sources = { 'nvim_diagnostic' },
        symbols = { error = ' ', warn = ' ', info = ' ' },
        diagnostics_color = {
          color_error = { fg = colors.red },
          color_warn = { fg = colors.yellow },
          color_info = { fg = colors.cyan },
        },
      }

      -- Insert mid section. You can make any number of sections in neovim :)
      -- for lualine it's any number greater then 2
      ins_left {
        function()
          return '%='
        end,
      }

      ins_right { 'progress', color = { fg = colors.fg } }
      ins_right { 'copilot', show_colors = true }
      ins_right {
        'branch',
        icon = '',
        color = { fg = colors.violet },
      }

      ins_right {
        'diff',
        -- Is it me or the symbol for modified us really weird
        symbols = { added = ' ', modified = '󰝤 ', removed = ' ' },
        diff_color = {
          added = { fg = colors.green },
          modified = { fg = colors.orange },
          removed = { fg = colors.red },
        },
        cond = conditions.hide_in_width,
      }

      -- Now don't forget to initialize lualine
      lualine.setup(config)
    end,
  },
  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help indent_blankline.txt`
    main = 'ibl',
    opts = {
      scope = { enabled = false },
      -- indent = { char = '┊' },
    },
  },
  { 'tpope/vim-repeat' },
  { 'christoomey/vim-tmux-navigator' },
  {
    'nvim-pack/nvim-spectre',
    keys = {
      {
        '<leader>fp',
        function()
          require('spectre').open()
        end,
        desc = '[F]ind and Replace in [P]roject',
      },
    },
  },
  {
    'lambdalisue/fern.vim',
    branch = 'main',
    dependencies = {
      'lambdalisue/nerdfont.vim',
      'lambdalisue/fern-renderer-nerdfont.vim',
      'lambdalisue/fern-hijack.vim',
    },
    lazy = false,

    config = function()
      vim.g['fern#renderer'] = 'nerdfont'

      -- TODO: port it to lua
      vim.cmd [[
        nmap <silent> - :Fern . -reveal=% -wait <CR>
        nmap <silent> _ :Fern %:p:h -wait -reveal=% <CR>
        

        function! s:init_fern() abort
          nmap <buffer> <C-J> <C-W><C-J>
          nmap <buffer> <C-K> <C-W><C-K>
          nmap <buffer> <C-L> <C-W><C-L>
          nmap <buffer> <C-H> <C-W><C-H>
          nmap <buffer> <CR> <Plug>(fern-action-open-or-expand)
        endfunction

        augroup fern-custom
          autocmd! *
          autocmd FileType fern call s:init_fern()
        augroup END
      ]]
    end,
    keys = {
      {
        '-',
        function()
          vim.cmd [[Fern . -reveal=% -wait <CR>]]
        end,
      },
      {
        '_',
        function()
          vim.cmd [[Fern %:h -wait <CR>]]
        end,
      },
    },
  },

  -- Better quick fix
  { 'kevinhwang91/nvim-bqf' },

  -- Highlight #hexhex colors
  -- Slow at lua profiling
  -- {
  --   'norcalli/nvim-colorizer.lua',
  --   config = function()
  --     require('colorizer').setup {}
  --   end,
  -- },

  -- Auto close/rename html tags
  {
    'windwp/nvim-ts-autotag',
    config = function()
      ---@diagnostic disable-next-line: missing-parameter
      require('nvim-ts-autotag').setup()
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    config = function()
      require('treesitter-context').setup {
        enable = true,
        max_lines = 10,
      }
    end,
  },

  -- Db viewer
  -- {
  --   'kndndrj/nvim-dbee',
  --   dependencies = {
  --     'MunifTanjim/nui.nvim',
  --   },
  --   build = function()
  --     -- Install tries to automatically detect the install method.
  --     -- if it fails, try calling it with one of these parameters:
  --     --    "curl", "wget", "bitsadmin", "go"
  --     require('dbee').install()
  --   end,
  --   config = function()
  --     require('dbee').setup(--[[optional config]])
  --   end,
  --   keys = {
  --     {
  --       '<leader>d',
  --       function()
  --         require('dbee').toggle()
  --       end,
  --       desc = '[D]b viwer',
  --     },
  --   },
  -- },

  -- {
  --   'vim-test/vim-test',
  --   config = function()
  --     vim.keymap.set('n', '<leader>tr', ':TestNearest -strategy=neovim_sticky<CR>', { desc = '[T]est [R]un' })
  --     vim.keymap.set('n', '<leader>tR', ':TestFile -strategy=neovim_sticky<CR>', { desc = '[T]est [A]ll' })
  --     vim.keymap.set('n', '<leader>tl', ':TestLast -strategy=neovim_sticky<CR>', { desc = '[T]est [L]ast' })
  --   end,
  -- },

  -- {
  --   'quolpr/neotest',
  --   branch = 'master',
  --   dependencies = {
  --     'fredrikaverpil/neotest-golang',
  --     'nvim-neotest/nvim-nio',
  --     'nvim-lua/plenary.nvim',
  --     'nvim-treesitter/nvim-treesitter',
  --     {
  --       'fredrikaverpil/neotest-golang',
  --       branch = 'main',
  --     },
  --   },
  --   config = function()
  --     -- get neotest namespace (api call creates or returns namespace)
  --     local neotest_ns = vim.api.nvim_create_namespace 'neotest'
  --     vim.diagnostic.config({
  --       virtual_text = {
  --         format = function(diagnostic)
  --           local message = diagnostic.message:gsub('\n', ' '):gsub('\t', ' '):gsub('%s+', ' '):gsub('^%s+', '')
  --           return message
  --         end,
  --       },
  --     }, neotest_ns)
  --
  --     local neotest = require 'neotest'
  --
  --     local config = { -- Specify configuration
  --       go_test_args = {
  --         '-v',
  --         '-race',
  --         '-timeout=60s',
  --       },
  --
  --       dap_go_enabled = true,
  --     }
  --
  --     ---@diagnostic disable-next-line: missing-fields
  --     neotest.setup {
  --       status = {
  --         enabled = true,
  --         signs = true,
  --         virtual_text = false,
  --       },
  --       output = {
  --         enabled = true,
  --         open_on_run = true,
  --       },
  --       -- your neotest config here
  --       adapters = {
  --         require 'neotest-golang'(config), -- Registration
  --       },
  --     }
  --
  --     vim.api.nvim_create_autocmd('FileType', {
  --       pattern = 'neotest-output-panel',
  --       callback = function()
  --         vim.cmd 'norm G'
  --       end,
  --     })
  --   end,
  --   keys = function()
  --     local keys = {
  --       {
  --         '<leader>tt',
  --         function()
  --           require('neotest').summary.toggle()
  --         end,
  --         desc = '[T]est [T]oggle',
  --       },
  --       {
  --         '<leader>tr',
  --         function()
  --           require('neotest').run.run()
  --         end,
  --         desc = '[T]est [R]un',
  --       },
  --       {
  --         '<leader>tR',
  --         function()
  --           require('neotest').run.run(vim.fn.expand '%')
  --         end,
  --         desc = '[T]est [R]un file',
  --       },
  --       {
  --         '<leader>ts',
  --         function()
  --           require('neotest').output.open { enter = true }
  --         end,
  --         desc = '[T]est [S]how result',
  --       },
  --       {
  --         '<leader>tS',
  --         function()
  --           require('neotest').output_panel.open()
  --         end,
  --         desc = '[T]est [S]how all results',
  --       },
  --       {
  --         '<leader>tl',
  --         function()
  --           require('neotest').run.run_last()
  --         end,
  --         desc = '[T]est [L]ast',
  --       },
  --       {
  --         '<leader>tp',
  --         function()
  --           require('neotest').output.open { enter = true, last_run = true }
  --         end,
  --         desc = '[T]est [P]revious run preview',
  --       },
  --     }
  --
  --     return keys
  --   end,
  -- },

  -- Show labels on f/F jumps
  -- {
  --   'unblevable/quick-scope',
  --   config = function()
  --     vim.cmd [[
  --       let g:qs_second_highlight=0
  --       let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
  --
  --       " augroup qs_colors
  --       "   autocmd!
  --       "   autocmd ColorScheme * highlight QuickScopePrimary gui=underline ctermfg=155 cterm=underline
  --       "   autocmd ColorScheme * highlight QuickScopeSecondary gui=underline ctermfg=81 cterm=underline
  --       " augroup END
  --       " highlight QuickScopePrimary guifg='#000' gui=underline cterm=underline
  --     ]]
  --   end,
  -- },

  -- Show tooltip on args while typing
  {
    'ray-x/lsp_signature.nvim',
    event = 'VeryLazy',
    opts = {
      always_trigger = true,
    },
    config = function(_, opts)
      require('lsp_signature').setup(opts)
    end,
  },

  -- Illuminate parentheses
  {
    'RRethy/vim-illuminate',
    config = function()
      require('illuminate').configure {
        providers = {
          'lsp',
          'treesitter',
        },
      }
    end,
  },

  -- The author is not ative anymore
  -- {
  --   'crusj/bookmarks.nvim',
  --   -- keys = {
  --   --   -- { '<tab><tab>', mode = { 'n' } },
  --   -- },
  --   branch = 'main',
  --   dependencies = { 'nvim-web-devicons' },
  --   config = function()
  --     require('bookmarks').setup {
  --       fix_enable = true,
  --       keymap = {
  --         toggle = '<leader>bb', -- Toggle bookmarks(global keymap)
  --         close = 'q', -- close bookmarks (buf keymap)
  --         add = '<leader>ba', -- Add bookmarks(global keymap)
  --         add_global = '\\g', -- Add global bookmarks(global keymap), global bookmarks will appear in all projects. Identified with the symbol
  --         jump = '<CR>', -- Jump from bookmarks(buf keymap)
  --         delete = 'dd', -- Delete bookmarks(buf keymap)
  --         order = '<space><space>', -- Order bookmarks by frequency or updated_time(buf keymap)
  --         delete_on_virt = '\\dd', -- Delete bookmark at virt text line(global keymap)
  --         show_desc = '\\sd', -- show bookmark desc(global keymap)
  --         focus_tags = '<c-j>', -- focus tags window
  --         focus_bookmarks = '<c-k>', -- focus bookmarks window
  --         toogle_focus = '<S-Tab>', -- toggle window focus (tags-window <-> bookmarks-window)
  --       },
  --       width = 0.9,
  --       preview_ratio = 0.4,
  --     }
  --     require('telescope').load_extension 'bookmarks'
  --   end,
  -- },

  -- Nvim lua profiler
  -- {
  --   'stevearc/profile.nvim',
  --   config = function()
  --     local should_profile = os.getenv 'NVIM_PROFILE'
  --     if should_profile then
  --       require('profile').instrument_autocmds()
  --       if should_profile:lower():match '^start' then
  --         require('profile').start '*'
  --       else
  --         require('profile').instrument '*'
  --       end
  --     end
  --
  --     local function toggle_profile()
  --       local prof = require 'profile'
  --       if prof.is_recording() then
  --         prof.stop()
  --         vim.ui.input({ prompt = 'Save profile to:', completion = 'file', default = 'profile.json' }, function(filename)
  --           if filename then
  --             prof.export(filename)
  --             vim.notify(string.format('Wrote %s', filename))
  --           end
  --         end)
  --       else
  --         prof.start '*'
  --       end
  --     end
  --
  --     vim.keymap.set('n', '<leader>pt', toggle_profile)
  --   end,
  -- },

  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    opts = {
      menu = {
        width = vim.api.nvim_win_get_width(0) - 4,
      },
      settings = {
        save_on_toggle = true,
        tabline = true,
      },
    },
    keys = function()
      local keys = {
        {
          '<leader>H',
          function()
            require('harpoon'):list():add()
          end,
          desc = '[H]arpoon File',
        },
        {
          '<leader>eh',
          function()
            local harpoon = require 'harpoon'
            harpoon.ui:toggle_quick_menu(harpoon:list())
          end,
          desc = '[E]dit [H]arpoon',
        },
      }

      for i = 1, 9 do
        table.insert(keys, {
          '<leader>' .. i,
          function()
            require('harpoon'):list():select(i)
          end,
          desc = 'Harpoon to File ' .. i,
        })
      end

      return keys
    end,
  },

  -- Close all active buffers except current
  -- {
  --   'Asheq/close-buffers.vim',
  --   keys = {
  --     {
  --       '<leader>bd',
  --       function()
  --         vim.cmd 'Bdelete hidden'
  --       end,
  --       desc = '[B]uffer [D]elete',
  --     },
  --   },
  -- },
  -- Kep propotions of window size
  {
    'kwkarlwang/bufresize.nvim',
    config = function()
      require('bufresize').setup()
    end,
  },
  -- {
  --   'mfussenegger/nvim-dap',
  --   dependencies = {
  --     -- Creates a beautiful debugger UI
  --     'rcarriga/nvim-dap-ui',
  --     'theHamsta/nvim-dap-virtual-text',
  --
  --     -- Required dependency for nvim-dap-ui
  --     'nvim-neotest/nvim-nio',
  --
  --     -- Installs the debug adapters for you
  --     'williamboman/mason.nvim',
  --     'jay-babu/mason-nvim-dap.nvim',
  --
  --     -- Add your own debuggers here
  --     'leoluz/nvim-dap-go',
  --     'quolpr/neotest',
  --   },
  --   config = function()
  --     local dap = require 'dap'
  --     local dapui = require 'dapui'
  --
  --     require('nvim-dap-virtual-text').setup {}
  --
  --     require('mason-nvim-dap').setup {
  --       -- Makes a best effort to setup the various debuggers with
  --       -- reasonable debug configurations
  --       automatic_installation = true,
  --
  --       -- You can provide additional configuration to the handlers,
  --       -- see mason-nvim-dap README for more information
  --       handlers = {},
  --
  --       -- You'll need to check that you have the required things installed
  --       -- online, please don't ask me how to install them :)
  --       ensure_installed = {
  --         -- Update this to ensure that you have the debuggers for the langs you want
  --         'delve',
  --       },
  --     }
  --
  --     -- Dap UI setup
  --     -- For more information, see |:help nvim-dap-ui|
  --     ---@diagnostic disable-next-line: missing-fields
  --     dapui.setup {
  --       -- Set icons to characters that are more likely to work in every terminal.
  --       --    Feel free to remove or use ones that you like more! :)
  --       --    Don't feel like these are good choices.
  --       icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
  --       ---@diagnostic disable-next-line: missing-fields
  --       controls = {
  --         ---@diagnostic disable-next-line: missing-fields
  --         icons = {
  --           pause = '⏸',
  --           play = '▶',
  --           step_into = '⏎',
  --           step_over = '⏭',
  --           step_out = '⏮',
  --           step_back = 'b',
  --           run_last = '▶▶',
  --           terminate = '⏹',
  --           disconnect = '⏏',
  --         },
  --       },
  --     }
  --
  --     -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
  --     vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'Debug: See last session result.' })
  --
  --     dap.listeners.after.event_initialized['dapui_config'] = dapui.open
  --     dap.listeners.before.event_terminated['dapui_config'] = dapui.close
  --     dap.listeners.before.event_exited['dapui_config'] = dapui.close
  --
  --     -- Install golang specific config
  --     require('dap-go').setup {
  --       delve = {
  --         -- On Windows delve must be run attached or it crashes.
  --         -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
  --         detached = vim.fn.has 'win32' == 0,
  --       },
  --     }
  --   end,
  --
  --   keys = {
  --     {
  --       '<leader>db',
  --       function()
  --         require('dap').toggle_breakpoint()
  --       end,
  --       desc = 'toggle [d]ebug [b]reakpoint',
  --     },
  --     {
  --       '<leader>dB',
  --       function()
  --         require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
  --       end,
  --       desc = '[d]ebug [B]reakpoint',
  --     },
  --     {
  --       '<leader>dc',
  --       function()
  --         require('dap').continue()
  --       end,
  --       desc = '[d]ebug [c]ontinue (start here)',
  --     },
  --     {
  --       '<leader>dC',
  --       function()
  --         require('dap').run_to_cursor()
  --       end,
  --       desc = '[d]ebug [C]ursor',
  --     },
  --     {
  --       '<leader>dg',
  --       function()
  --         require('dap').goto_()
  --       end,
  --       desc = '[d]ebug [g]o to line',
  --     },
  --     {
  --       '<leader>do',
  --       function()
  --         require('dap').step_over()
  --       end,
  --       desc = '[d]ebug step [o]ver',
  --     },
  --     {
  --       '<leader>dO',
  --       function()
  --         require('dap').step_out()
  --       end,
  --       desc = '[d]ebug step [O]ut',
  --     },
  --     {
  --       '<leader>di',
  --       function()
  --         require('dap').step_into()
  --       end,
  --       desc = '[d]ebug [i]nto',
  --     },
  --     {
  --       '<leader>dj',
  --       function()
  --         require('dap').down()
  --       end,
  --       desc = '[d]ebug [j]ump down',
  --     },
  --     {
  --       '<leader>dk',
  --       function()
  --         require('dap').up()
  --       end,
  --       desc = '[d]ebug [k]ump up',
  --     },
  --     {
  --       '<leader>dl',
  --       function()
  --         require('dap').run_last()
  --       end,
  --       desc = '[d]ebug [l]ast',
  --     },
  --     {
  --       '<leader>dp',
  --       function()
  --         require('dap').pause()
  --       end,
  --       desc = '[d]ebug [p]ause',
  --     },
  --     {
  --       '<leader>dr',
  --       function()
  --         require('dap').repl.toggle()
  --       end,
  --       desc = '[d]ebug [r]epl',
  --     },
  --     {
  --       '<leader>dR',
  --       function()
  --         require('dap').clear_breakpoints()
  --       end,
  --       desc = '[d]ebug [R]emove breakpoints',
  --     },
  --     {
  --       '<leader>ds',
  --       function()
  --         require('dap').session()
  --       end,
  --       desc = '[d]ebug [s]ession',
  --     },
  --     {
  --       '<leader>dt',
  --       function()
  --         require('dap').terminate()
  --       end,
  --       desc = '[d]ebug [t]erminate',
  --     },
  --     {
  --       '<leader>dw',
  --       function()
  --         require('dap.ui.widgets').hover()
  --       end,
  --       desc = '[d]ebug [w]idgets',
  --     },
  --   },
  -- },
  --  Copilot on steroids
  {
    'supermaven-inc/supermaven-nvim',
    config = function()
      require('supermaven-nvim').setup {

        ignore_filetypes = { markdown = true },
        keymaps = {
          accept_suggestion = '<C-u>',
        },
      }
    end,
  },
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
            -- remove Package since luals uses it for control flow structures
            ['not'] = { ft = 'lua', kind = 'Package' },
            any = {
              -- all symbol kinds for help / markdown files
              ft = { 'help', 'markdown' },
              -- default set of symbol kinds
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
    }, -- for default options, refer to the configuration section for custom setup.
    cmd = 'Trouble',
    keys = {
      {
        '<leader>cD',
        '<cmd>Trouble diagnostics toggle filter.severity=vim.diagnostic.severity.ERROR<cr>',
        desc = '[C]ode [D]iagnostics',
      },
      {
        '<leader>cd',
        '<cmd>Trouble diagnostics toggle filter.buf=0 filter.severity=vim.diagnostic.severity.ERROR<cr>',
        desc = '[C]ode [d]iagnostics of current buffer',
      },
    },
  },
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
  {
    -- 'quolpr/quicktest.nvim',
    dir = '~/projects/quolpr/quicktest.nvim',
    config = function()
      local qt = require 'quicktest'

      qt.setup {
        adapters = {
          require 'quicktest.adapters.golang' {
            args = function(bufnt, args)
              vim.list_extend(args, { '-count=1' })
              return args
            end,
          },
          require 'quicktest.adapters.vitest',
          --   -- bin = function(path)
          --   --   print(path)
          --   --   return 'vitest'
          --   -- end,
          -- },
          require 'quicktest.adapters.elixir',
          require 'quicktest.adapters.dart',
          -- require 'quicktest.adapters.playwright',
        },
        default_win_mode = 'split',
      }
    end,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      'm00qek/baleia.nvim',
    },
    keys = {
      {
        '<leader>tl',
        function()
          local qt = require 'quicktest'

          qt.run_line('auto', 'auto', { additional_args = { '-count=5' } })
        end,
        desc = '[T]est Run [L]ine',
      },
      {
        '<leader>tf',
        function()
          local qt = require 'quicktest'

          qt.run_file()
        end,
        desc = '[T]est Run [F]ile',
      },
      {
        '<leader>td',
        function()
          local qt = require 'quicktest'

          qt.run_dir()
        end,
        desc = '[T]est Run [D]ir',
      },
      {
        '<leader>ta',
        function()
          local qt = require 'quicktest'

          qt.run_all()
        end,
        desc = '[T]est Run [A]ll',
      },
      {
        '<leader>tp',
        function()
          local qt = require 'quicktest'

          qt.run_previous()
        end,
        desc = '[T]est Run [P]revious',
      },
      {
        '<leader>tt',
        function()
          local qt = require 'quicktest'

          qt.toggle_win 'split'
        end,
        desc = '[T]est [T]oggle Window',
      },
      {
        '<leader>tc',
        function()
          local qt = require 'quicktest'

          qt.cancel_current_run()
        end,
        desc = '[T]est [C]ancel run',
      },
    },
  },
  -- {
  --   dir = '~/projects/quolpr/quicktest.nvim',
  --   config = function()
  --     require('quicktest').setup()
  --   end,
  --   dependencies = {
  --     'nvim-lua/plenary.nvim',
  --   },
  --   -- keys = function()
  --   --   local gotest = require 'quicktest'
  --   --   local keys = {
  --   --     {
  --   --       '<leader>tr',
  --   --       function()
  --   --         gotest.run_current(gotest.current_win_mode())
  --   --       end,
  --   --       desc = '[T]est [R]un',
  --   --     },
  --   --     {
  --   --       '<leader>tR',
  --   --       function()
  --   --         gotest.run_file(gotest.current_win_mode())
  --   --       end,
  --   --       desc = '[T]est [R]un file',
  --   --     },
  --   --     {
  --   --       '<leader>tt',
  --   --       function()
  --   --         gotest.open 'popup'
  --   --       end,
  --   --       desc = '[T]est [T]toggle result',
  --   --     },
  --   --     {
  --   --       '<leader>ts',
  --   --       function()
  --   --         gotest.open 'split'
  --   --       end,
  --   --       desc = '[T]est [S]plit result',
  --   --     },
  --   --
  --   --     {
  --   --       '<leader>tp',
  --   --       function()
  --   --         gotest.run_previous(gotest.current_win_mode())
  --   --       end,
  --   --       desc = '[T]est [P]revious',
  --   --     },
  --   --   }
  --   --
  --   --   return keys
  --   -- end,
  -- },
  {
    'rcarriga/nvim-notify',
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('notify').setup {
        stages = 'static',
      }

      vim.notify = require 'notify'
    end,
    priority = 1000,
  },
  -- {
  --   'folke/noice.nvim',
  --   event = 'VeryLazy',
  --   dependencies = {
  --     -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
  --     'MunifTanjim/nui.nvim',
  --     -- OPTIONAL:
  --     --   `nvim-notify` is only needed, if you want to use the notification view.
  --     --   If not available, we use `mini` as the fallback
  --     'rcarriga/nvim-notify',
  --   },
  --   config = function()
  --     require('notify').setup {
  --       stages = 'static',
  --     }
  --
  --     require('noice').setup {
  --       lsp = {
  --         -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
  --         override = {
  --           ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
  --           ['vim.lsp.util.stylize_markdown'] = true,
  --           ['cmp.entry.get_documentation'] = true, -- requires hrsh7th/nvim-cmp
  --         },
  --       },
  --       lsp = {
  --         progress = {
  --           enabled = false,
  --         },
  --       },
  --       -- you can enable a preset for easier configuration
  --       presets = {
  --         bottom_search = true, -- use a classic bottom cmdline for search
  --         command_palette = true, -- position the cmdline and popupmenu together
  --         long_message_to_split = true, -- long messages will be sent to a split
  --         inc_rename = false, -- enables an input dialog for inc-rename.nvim
  --         lsp_doc_border = false, -- add a border to hover docs and signature help
  --       },
  --       routes = {
  --         {
  --           filter = {
  --             event = 'notify',
  --             find = 'nohlsearch',
  --           },
  --           opts = { skip = true },
  --         },
  --         {
  --           filter = {
  --             event = 'msg_show',
  --             find = 'yanked',
  --           },
  --           opts = { skip = true },
  --         },
  --         {
  --           filter = {
  --             event = 'msg_show',
  --             find = 'written',
  --           },
  --           opts = { skip = true },
  --         },
  --       },
  --     }
  --   end,
  -- },

  {
    -- Horrible performance on highlight, so use matchparen.nvim
    'andymass/vim-matchup',
    setup = function()
      vim.cmd [[
        let g:matchup_matchparen_enabled = 0
      ]]
    end,
  },
  -- {
  --   -- faster matchparen
  --   -- During profiling I noticeed that matchparen is the slow scroll, so that's why I use nvim version
  --   'monkoose/matchparen.nvim',
  --   config = function()
  --     require('matchparen').setup {}
  --   end,
  -- },
  -- {
  --   'luckasRanarison/clear-action.nvim',
  --   config = function()
  --     require('clear-action').setup {
  --       signs = {
  --         enable = false,
  --       },
  --       popup = {
  --         enable = true,
  --       },
  --     }
  --   end,
  -- },
  -- {
  --   'ravibrock/spellwarn.nvim',
  --   event = 'VeryLazy',
  --   config = true,
  -- },

  -- {
  --   'kdheepak/lazygit.nvim',
  --   cmd = {
  --     'LazyGit',
  --     'LazyGitConfig',
  --     'LazyGitCurrentFile',
  --     'LazyGitFilter',
  --     'LazyGitFilterCurrentFile',
  --   },
  --   -- optional for floating window border decoration
  --   dependencies = {
  --     'nvim-lua/plenary.nvim',
  --   },
  --   -- setting the keybinding for LazyGit with 'keys' is recommended in
  --   -- order to load the plugin when the command is run for the first time
  --   keys = {
  --     { '<leader>go', '<cmd>LazyGit<cr>', desc = '[G]it [O]pen' },
  --   },
  -- },
  -- {
  --   'nvim-neo-tree/neo-tree.nvim',
  --   branch = 'v3.x',
  --   dependencies = {
  --     'nvim-lua/plenary.nvim',
  --     'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
  --     'MunifTanjim/nui.nvim',
  --     '3rd/image.nvim',
  --   },
  --   config = function()
  --     require('neo-tree').setup {
  --       enable_diagnostics = false,
  --       close_if_last_window = false,
  --       default_component_configs = {
  --         last_modified = { enabled = false },
  --         file_size = { enabled = false },
  --         created = { enabled = false },
  --         type = { enabled = false },
  --       },
  --       filesystem = {
  --         async_directory_scan = 'never',
  --       },
  --     }
  --     vim.keymap.set('n', '_', '<cmd>Neotree source=filesystem reveal=true position=current <CR>', { desc = 'Open neotree' })
  --   end,
  -- },
  {
    'backdround/global-note.nvim',
    config = function()
      local get_project_name = function()
        local result = vim
          .system({
            'git',
            'rev-parse',
            '--show-toplevel',
          }, {
            text = true,
          })
          :wait()

        if result.stderr ~= '' then
          vim.notify(result.stderr, vim.log.levels.WARN)
          return nil
        end

        local project_directory = result.stdout:gsub('\n', '')

        local project_name = vim.fs.basename(project_directory)
        if project_name == nil then
          vim.notify('Unable to get the project name', vim.log.levels.WARN)
          return nil
        end

        return project_name
      end

      local get_git_branch = function()
        local result = vim
          .system({
            'git',
            'symbolic-ref',
            '--short',
            'HEAD',
          }, {
            text = true,
          })
          :wait()

        if result.stderr ~= '' then
          vim.notify(result.stderr, vim.log.levels.WARN)
          return nil
        end

        return result.stdout:gsub('\n', '')
      end

      local global_note = require 'global-note'
      global_note.setup {
        additional_presets = {
          git_branch_local = {
            command_name = 'GitBranchNote',

            directory = function()
              return vim.fn.stdpath 'data' .. '/global-note/' .. get_project_name()
            end,

            filename = function()
              local git_branch = get_git_branch()
              if git_branch == nil then
                return nil
              end
              return get_git_branch():gsub('[^%w-]', '-') .. '.md'
            end,

            title = get_git_branch,
          },
          project_local = {
            command_name = 'ProjectNote',

            filename = function()
              return get_project_name() .. '.md'
            end,

            title = 'Project note',
          },
        },
      }
    end,
    keys = {
      {
        '<leader>nb',
        function()
          local global_note = require 'global-note'
          global_note.toggle_note 'git_branch_local'
        end,
        desc = 'Toggle [N]otes [B]ranch',
      },
      {
        '<leader>np',
        function()
          local global_note = require 'global-note'
          global_note.toggle_note 'project_local'
        end,
        desc = 'Toggle [N]otes [P]roject',
      },
    },
  },
  -- {
  --   dir = './plugins/pls-cspell',
  --   lazy = false,
  --   config = function()
  --     require('pls-cspell').setup {}
  --   end,
  -- },
  {
    dir = '~/projects/quolpr/parrot.nvim',
    lazy = false,
    config = function()
      require('parrot').setup {
        hooks = {
          Complete = function(prt, params)
            local template = [[
        I have the following code from {{filename}}:

        ```{{filetype}}
        {{filecontent}}
        ```

        And I want to work on part of the code at line_start={{linestart}}, line_end={{lineend}}:
        ```{{filetype}}
        {{selection}}
        ```

        Please finish the code above carefully and logically.
        Respond just with the snippet of code that should be inserted."
        ]]
            local agent = prt.get_command_agent()
            prt.Prompt(params, prt.ui.Target.append, nil, agent.model, template, agent.system_prompt, agent.provider)
          end,
          Explain = function(prt, params)
            local template = [[
        Your task is to take the code snippet from {{filename}} and explain it.
        Break down the code's functionality, purpose, and key components.
        The goal is to help the reader understand what the code does and how it works.

        Here is the full code:
        ```{{filetype}}
        {{filecontent}}
        ```

        And I need to explain the code at line_start={{linestart}}, line_end={{lineend}}:
        ```{{filetype}}
        {{selection}}
        ```

        Use the markdown format with codeblocks and inline code.
        Explanation of the code above:
        ]]
            local agent = prt.get_chat_agent()
            prt.logger.info('Explaining selection with agent: ' .. agent.name)
            prt.Prompt(params, prt.ui.Target.new, nil, agent.model, template, agent.system_prompt, agent.provider)
          end,
          FixBugs = function(prt, params)
            local template = [[
        You are an expert in {{filetype}}.
        Fix bugs in the below code from {{filename}} carefully and logically:
        Your task is to analyze the provided {{filetype}} code snippet, identify
        any bugs or errors present, and provide a corrected version of the code
        that resolves these issues. Explain the problems you found in the
        original code and how your fixes address them. The corrected code should
        be functional, efficient, and adhere to best practices in
        {{filetype}} programming.

        Here is the full code:
        ```{{filetype}}
        {{filecontent}}
        ```

        And I want to work on part of the code at line_start={{linestart}}, line_end={{lineend}}:
        ```{{filetype}}
        {{selection}}
        ```

        Fixed code:
        ]]
            local agent = prt.get_command_agent()
            prt.logger.info('Fixing bugs in selection with agent: ' .. agent.name)
            prt.Prompt(params, prt.ui.Target.new, nil, agent.model, template, agent.system_prompt, agent.provider)
          end,
          Optimize = function(prt, params)
            local template = [[
        You are an expert in {{filetype}}.
        Your task is to analyze the provided {{filetype}} code snippet and
        suggest improvements to optimize its performance. Identify areas
        where the code can be made more efficient, faster, or less
        resource-intensive. Provide specific suggestions for optimization,
        along with explanations of how these changes can enhance the code's
        performance. The optimized code should maintain the same functionality
        as the original code while demonstrating improved efficiency.

        Here is the full code:
        ```{{filetype}}
        {{filecontent}}
        ```

        And I want to work on part of the code at line_start={{linestart}}, line_end={{lineend}}:
        ```{{filetype}}
        {{selection}}
        ```

        Optimized code:
        ]]
            local agent = prt.get_command_agent()
            prt.logger.info('Optimizing selection with agent: ' .. agent.name)
            prt.Prompt(params, prt.ui.Target.new, nil, agent.model, template, agent.system_prompt, agent.provider)
          end,
          UnitTests = function(prt, params)
            local template = [[
        I have the following code from {{filename}}:

        ```{{filetype}}
        {{filecontent}}
        ```

        And I want to work on part of the code at line_start={{linestart}}, line_end={{lineend}}:
        ```{{filetype}}
        {{selection}}
        ```

        Please respond by writing table driven unit tests for the code above.
        ]]
            local agent = prt.get_command_agent()
            prt.logger.info('Creating unit tests for selection with agent: ' .. agent.name)
            prt.Prompt(params, prt.ui.Target.enew, nil, agent.model, template, agent.system_prompt, agent.provider)
          end,
          ProofReader = function(prt, params)
            local chat_system_prompt = [[
        I want you to act as a proofreader. I will provide you with texts and
        I would like you to review them for any spelling, grammar, or
        punctuation errors. Once you have finished reviewing the text,
        provide me with any necessary corrections or suggestions to improve the
        text. Highlight the corrections with markdown bold or italics style.
        ]]
            local agent = prt.get_chat_agent()
            prt.logger.info('Proofreading selection with agent: ' .. agent.name)
            prt.cmd.ChatNew(params, agent.model, chat_system_prompt)
          end,
          Debug = function(prt, params)
            local template = [[
        I want you to act as {{filetype}} expert.
        Review the following code, carefully examine it, and report potential
        bugs and edge cases alongside solutions to resolve them.
        Keep your explanation short and to the point:

        Full file:
        ```{{filetype}}
        {{filecontent}}
        ```

        And I want to work on part of the code at line_start={{linestart}}, line_end={{lineend}}:
        ```{{filetype}}
        {{selection}}
        ```
        ]]
            local agent = prt.get_chat_agent()
            prt.logger.info('Debugging selection with agent: ' .. agent.name)
            prt.Prompt(params, prt.ui.Target.enew, nil, agent.model, template, agent.system_prompt, agent.provider)
          end,
        },
        template_selection = [[
I have the following content from {{filename}}:

```{{filetype}}
{{filecontent}}
```

And I want to work on part of the code at line_start={{linestart}}, line_end={{lineend}}:

```{{filetype}}
{{selection}}
```

{{command}}
]],
        template_rewrite = [[
I have the following content from {{filename}}:

```{{filetype}}
{{filecontent}}
```

And I want modify this part of the code at line_start={{linestart}}, line_end={{lineend}}:

```{{filetype}}
{{selection}}
```

Do this:{{command}}

Respond exclusively with the snippet that should replace the selection above.
DO NOT RESPOND WITH ANY TYPE OF COMMENTS, JUST THE CODE!!!
]],
        template_append = [[
I have the following content from {{filename}}:

```{{filetype}}
{{filecontent}}
```

And I want modify this part of the code at line_start={{linestart}}, line_end={{lineend}}:

```{{filetype}}
{{selection}}
```

Do this:{{command}}

Respond exclusively with the snippet that should be appended after the selection above.
DO NOT RESPOND WITH ANY TYPE OF COMMENTS, JUST THE CODE!!!
DO NOT REPEAT ANY CODE FROM ABOVE!!!
]],
        template_prepend = [[
I have the following content from {{filename}}:

```{{filetype}}
{{filecontent}}
```

And I want modify this part of the code at line_start={{linestart}}, line_end={{lineend}}:

```{{filetype}}
{{selection}}
```

Do this:{{command}}

Respond exclusively with the snippet that should be prepended before the selection above.
DO NOT RESPOND WITH ANY TYPE OF COMMENTS, JUST THE CODE!!!
DO NOT REPEAT ANY CODE FROM ABOVE!!!
]],
        providers = {
          openai = {
            api_key = 'sk-proj-HgRzNaw1bVrqxckA0xA5T3BlbkFJOmcxQqjHyit0qqeyBOOJ',
          },
        },
        toggle_target = 'popup',
        curl_params = { '--socks5-hostname', '91.108.241.124:34390' },
      }

      -- or setup with your own config (see Install > Configuration in Readme)
      -- require("gp").setup(config)

      -- shortcuts might be setup here (see Usage > Shortcuts in Readme)

      -- local function keymapOptions(desc)
      --   return {
      --     noremap = true,
      --     silent = true,
      --     nowait = true,
      --     desc = 'GPT prompt ' .. desc,
      --   }
      -- end

      -- Chat commands
      -- vim.keymap.set({ 'n', 'i' }, '<leader>at', '<cmd>GpChatToggle popup<cr>', keymapOptions 'Ch[a]tGPT [T]oggle')
      -- vim.keymap.set({ 'n', 'i' }, '<leader>at', '<cmd>GpChatToggle popup<cr>', keymapOptions 'Ch[a]tGPT [T]oggle')
    end,
    keys = {
      {
        '<leader>at',
        function()
          return ':PrtChatToggle popup<cr>'
        end,
        desc = 'Ch[a]tGPT [T]oggle',
        expr = true,
      },
      {
        '<leader>av',
        function()
          return ':PrtChatToggle vsplit<cr>'
        end,
        desc = 'Ch[a]tGPT open [V]-split',
        expr = true,
      },
      {
        '<leader>an',
        function()
          return ':PrtChatNew popup<cr>'
        end,
        desc = 'Ch[a]tGPT [N]ew',
        expr = true,
      },
      {
        '<leader>an',
        function()
          return ":<C-u>'<,'>PrtChatNew popup<cr>"
        end,
        desc = 'Ch[a]tGPT [N]ew',
        expr = true,
        mode = { 'v' },
      },
      {
        '<leader>fa',
        function()
          return ':PrtChatFinder<cr>'
        end,
        desc = '[F]ind Ch[a]t',
        expr = true,
      },
      {
        '<leader>ai',
        function()
          return ":<C-u>'<,'>PrtImplement<cr>"
        end,
        desc = 'Ch[a]tGPT [I]implement',
        mode = { 'v' },
        expr = true,
      },
      {
        '<leader>ap',
        function()
          return ":<C-u>'<,'>PrtPrepend<cr>"
        end,
        desc = 'Ch[a]tGPT [P]repend',
        mode = { 'v' },
        expr = true,
      },
      {
        '<leader>aa',
        function()
          return ":<C-u>'<,'>PrtAppend<cr>"
        end,
        desc = 'Ch[a]tGPT [A]ppend',
        mode = { 'v' },
        expr = true,
      },
      {
        '<leader>ar',
        function()
          return ":<C-u>'<,'>PrtRewrite<cr>"
        end,
        desc = 'Ch[a]tGPT [R]ewrite',
        mode = { 'v' },
        expr = true,
      },
      {
        '<leader>am',
        function()
          return ":<C-u>'<,'>PrtChatPaste popup<cr>"
        end,
        desc = 'Ch[a]tGPT [M]ove to chat',
        mode = { 'v' },
        expr = true,
      },
    },
  },

  -- {
  --   'jinh0/eyeliner.nvim',
  --   config = function()
  --     require('eyeliner').setup {
  --       highlight_on_key = true, -- show highlights only after keypress
  --       dim = false, -- dim all other characters if set to true (recommended!)
  --     }
  --   end,
  -- },
  -- {
  --   'folke/flash.nvim',
  --   event = 'VeryLazy',
  --   ---@type Flash.Config
  --   opts = {},
  --   -- stylua: ignore
  --   keys = {
  --     { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
  --     { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
  --     { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
  --     { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
  --     { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
  --   },
  -- },
}

local function file_exists(path)
  local stat = vim.loop.fs_stat(path)
  return (stat and stat.type) or false
end

local function is_cwd_in_file_path(file_path)
  local cwd = vim.fn.getcwd()
  -- Ensure both paths end with a slash for consistent comparison
  cwd = cwd .. (cwd:sub(-1) == '/' and '' or '/')
  file_path = file_path .. (file_path:sub(-1) == '/' and '' or '/')
  -- Check if the cwd is a prefix of the file path
  return file_path:sub(1, #cwd) == cwd
end

function jumps()
  local core = require 'fzf-lua.core'
  local config = require 'fzf-lua.config'

  local jumps_res = vim.fn.execute 'jumps'
  local jumps = vim.split(jumps_res, '\n')

  local in_list = {}
  local entries = {}
  for i = #jumps - 1, 3, -1 do
    local _, _, _, text = jumps[i]:match '(%d+)%s+(%d+)%s+(%d+)%s+(.*)'

    if not in_list[text] and file_exists(text) and is_cwd_in_file_path(vim.fn.fnamemodify(text, ':p')) then
      table.insert(entries, text)
      in_list[text] = true
    end
  end

  if #entries == 0 then
    vim.notify 'No jumps found'
    return
  end

  require('fzf-lua').fzf_exec(entries, {
    actions = {
      ['default'] = require('fzf-lua').actions.file_edit,
    },
  })
end

-- local function run()
--   local path = vim.fn.stdpath 'data' .. '/buffer_paths.log'
--
--   local function write_path_async()
--     local current_path = vim.api.nvim_buf_get_name(0)
--     if current_path == '' then
--       return
--     end
--     if not (file_exists(current_path) and is_cwd_in_file_path(vim.fn.fnamemodify(current_path, ':p'))) then
--       return
--     end
--
--     vim.loop.fs_open(path, 'a+', 438, function(err_open, fd)
--       if err_open or not fd then
--         return
--       end
--
--       vim.loop.fs_fstat(fd, function(err_fstat, stat)
--         if err_fstat or not stat then
--           vim.notify('Failed to get fstat of file: ' .. err_fstat)
--           vim.loop.fs_close(fd)
--           return
--         end
--
--         -- Ограничение файла 20 строками
--         local max_lines = 20
--         local lines_to_keep = max_lines - 1
--
--         if stat.size > 0 then
--           vim.loop.fs_read(fd, stat.size, 0, function(err_read, data)
--             if err_read then
--               vim.notify('Failed to read file: ' .. err_read)
--               vim.loop.fs_close(fd)
--               return
--             end
--
--             data = data or ''
--
--             local lines = vim.split(data, '\n', { plain = true, trimempty = true })
--             if #lines > lines_to_keep then
--               data = table.concat(vim.list_slice(lines, #lines - lines_to_keep), '\n') .. '\n'
--             else
--               data = data .. '\n'
--             end
--
--             -- Запись текущего пути
--             vim.loop.fs_write(fd, data .. current_path .. '\n', 0, function(err)
--               if err then
--                 vim.notify('Failed to write to file: ' .. err)
--               end
--
--               vim.loop.fs_close(fd)
--             end)
--           end)
--         else
--           vim.loop.fs_write(fd, current_path .. '\n', 0, function(err)
--             if err then
--               vim.notify('Failed to write to file: ' .. err)
--             end
--
--             vim.loop.fs_close(fd)
--           end)
--         end
--       end)
--     end)
--   end
--
--   vim.api.nvim_create_autocmd('BufEnter', {
--     pattern = '*',
--     callback = write_path_async,
--   })
-- end
--
-- run()

-- jumps()

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
