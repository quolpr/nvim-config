return {
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
      end, { desc = 'Find Files' })

      vim.keymap.set('n', '<leader>fw', function()
        -- fzf.grep_cword { formatter = 'path.filename_first' }
        fzf.grep_cword()
      end, { desc = 'Find current Word' })
      vim.keymap.set('v', '<leader>fw', function()
        -- fzf.grep_visual { formatter = 'path.filename_first' }
        fzf.grep_visual()
      end, { desc = 'Find current Word' })

      vim.keymap.set('n', '<leader>fg', function()
        -- fzf.live_grep { formatter = 'path.filename_first' }
        fzf.live_grep()
      end, { desc = 'Find by Grep' })

      vim.keymap.set('n', '<leader>fr', fzf.resume, { desc = 'Find Resume' })

      -- In current buffer
      -- Use code -> diagnostics
      -- vim.keymap.set('n', '<leader>fd', function()
      --   fzf.diagnostics_document { formatter = 'path.filename_first' }
      -- end, { desc = 'Find Diagnostic' })
      --
      -- -- In all buffers
      -- vim.keymap.set('n', '<leader>fD', function()
      --   fzf.diagnostics_workspace { formatter = 'path.filename_first' }
      -- end, { desc = 'Find Diagnostic' })

      vim.keymap.set('n', '<leader>fo', function()
        -- fzf.git_status { formatter = 'path.filename_first' }
        fzf.git_status()
      end, { desc = 'Find by git status' })

      vim.keymap.set('n', '<leader><leader>', function()
        -- fzf.lsp_live_workspace_symbols { formatter = 'path.filename_first' }
        fzf.lsp_live_workspace_symbols()
      end, { desc = 'Find workspace symbols' })

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp-fzf-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('gd', function()
            require('fzf-lua').lsp_definitions { formatter = 'path.filename_first' }
          end, 'Goto Definition')

          -- Find references for the word under your cursor.
          map('gr', function()
            require('fzf-lua').lsp_references { formatter = 'path.filename_first' }
          end, 'Goto References')

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          map('gi', function()
            require('fzf-lua').lsp_implementations { formatter = 'path.filename_first' }
          end, 'Goto Implementation')

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          map('gD', function()
            require('fzf-lua').lsp_typedefs { formatter = 'path.filename_first' }
          end, 'Type Definition')

          -- map('gc', function()
          --   require('fzf-lua').lsp_outgoing_calls { formatter = 'path.filename_first' }
          -- end, 'Goto outgoing Calls')
          -- map('gC', function()
          --   require('fzf-lua').lsp_incoming_calls { formatter = 'path.filename_first' }
          -- end, 'Goto incoming Calls')

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
          end, 'Code Action')
        end,
      })
    end,
  },
  {
    dir = '~/.config/nvim/lua/history',
    config = function()
      local history = require 'history'

      vim.keymap.set('n', '<leader>fh', function()
        history()
      end, { desc = 'Find History' })
    end,
  },
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
          desc = 'Harpoon File',
        },
        {
          '<leader>eh',
          function()
            local harpoon = require 'harpoon'
            harpoon.ui:toggle_quick_menu(harpoon:list())
          end,
          desc = 'Edit Harpoon',
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
  --     -- end, { desc = 'Find Files' })
  --
  --     vim.keymap.set('v', '<leader>fw', function()
  --       local text = getVisualSelection()
  --       builtin.grep_string { search = text }
  --     end, { desc = 'Find current Word' })
  --
  --     vim.keymap.set('n', '<leader>fw', builtin.grep_string, { desc = 'Find current Word' })
  --     vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Find by Grep' })
  --     vim.keymap.set('n', '<leader>fr', builtin.resume, { desc = 'Find Resume' })
  --
  --     -- In current buffer
  --     vim.keymap.set('n', '<leader>fd', function()
  --       builtin.diagnostics { bufnr = 0 }
  --     end, { desc = 'Find Diagnostic' })
  --     -- In all buffers
  --     vim.keymap.set('n', '<leader>fD', function()
  --       builtin.diagnostics { bufnr = nil }
  --     end, { desc = 'Find Diagnostic' })
  --
  --     vim.keymap.set('n', '<leader>fs', function()
  --       builtin.lsp_document_symbols { fname_width = 60, symbol_width = 60 }
  --     end, { desc = 'Find Symbols' })
  --     vim.keymap.set('n', '<leader>fS', builtin.lsp_dynamic_workspace_symbols, { desc = 'Find Symbols' })
  --     -- vim.keymap.set('n', '<leader>fh', builtin.search_history, { desc = 'Find History' })
  --     -- vim.keymap.set('n', '<leader><leader>', builtin.git_status, { desc = 'Find by git Status' })
  --
  --     vim.keymap.set('n', '<leader>ff', function()
  --       require('telescope').extensions.smart_open.smart_open {
  --         cwd_only = true,
  --       }
  --       -- require('telescope').extensions.frecency.frecency {
  --       --   workspace = 'CWD',
  --       -- }
  --     end, { desc = 'Find Files' })
  --
  --     vim.keymap.set('n', '<leader>fo', function()
  --       builtin.git_status()
  --     end, { desc = 'Find by git status' })
  --
  --     vim.keymap.set('n', '<leader><leader>', function()
  --       builtin.lsp_dynamic_workspace_symbols()
  --     end, { desc = 'Find by git Status' })
  --
  --     -- vim.keymap.set('n', '<leader>fm', function()
  --     --   builtin.marks { mark_type = 'local' }
  --     -- end, { desc = 'Find Marks' })
  --     -- vim.keymap.set('n', '<leader>fm', function()
  --     --   require('telescope').extensions.harpoon.marks()
  --     -- end, { desc = 'Find Marks' })
  --
  --     -- Shortcut for searching your neovim configuration files
  --     -- vim.keymap.set('n', '<leader>fn', function()
  --     --   builtin.find_files { cwd = vim.fn.stdpath 'config' }
  --     -- end, { desc = 'Search Neovim files' })
  --   end,
  -- },
}
