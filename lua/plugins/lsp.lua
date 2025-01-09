return {
  {
    'gbprod/yanky.nvim',
    config = function()
      require('yanky').setup {}

      vim.keymap.set({ 'n', 'x' }, 'p', '<Plug>(YankyPutAfter)')
      vim.keymap.set({ 'n', 'x' }, 'P', '<Plug>(YankyPutBefore)')
      vim.keymap.set({ 'n', 'x' }, 'gp', '<Plug>(YankyGPutAfter)')
      vim.keymap.set({ 'n', 'x' }, 'gP', '<Plug>(YankyGPutBefore)')

      vim.keymap.set('n', '<c-p>', '<Plug>(YankyPreviousEntry)')
      vim.keymap.set('n', '<c-n>', '<Plug>(YankyNextEntry)')
    end,
  },
  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      -- 'luckasRanarison/clear-action.nvim',

      -- Useful status updates for LSP.
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', opts = {} },
    },
    config = function(_, opts)
      local lspconfig = require 'lspconfig'
      for server, config in pairs(opts.servers or {}) do
        config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)
        lspconfig[server].setup(config)
      end

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
        group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
        callback = function(event)
          local client = vim.lsp.get_client_by_id(event.data.client_id)

          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('ds', vim.diagnostic.open_float, 'Diagnost Show')

          -- Rename the variable under your cursor
          --  Most Language Servers support renaming across files, etc.
          map('<leader>cc', vim.lsp.buf.rename, 'Code Change')

          -- Opens a popup that displays documentation about the word under your cursor
          --  See `:help K` for why this keymap
          map('K', vim.lsp.buf.hover, 'Hover Documentation')

          -- if client and client.name ~= 'elixirls' and client.name ~= 'gopls'  then
          --   client.server_capabilities.documentFormattingProvider = false
          --   client.server_capabilities.documentRangeFormattingProvider = false
          -- end

          -- not needed more, fixed in https://go-review.googlesource.com/c/tools/+/462215
          -- if client and client.name == 'gopls' then
          --   print('client.server_capabilities.semanticTokensProvider', client.server_capabilities.semanticTokensProvider)
          --   if not client.server_capabilities.semanticTokensProvider then
          --     local semantic = client.config.capabilities.textDocument.semanticTokens
          --
          --     if semantic then
          --       print('semantic', semantic)
          --       client.server_capabilities.semanticTokensProvider = {
          --         full = true,
          --         legend = {
          --           tokenTypes = semantic.tokenTypes,
          --           tokenModifiers = semantic.tokenModifiers,
          --         },
          --         range = true,
          --       }
          --     end
          --   end
          -- end

          if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled {})
            end, 'Toggle Inlay Hints')
          end
        end,
      })

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP Specification.
      --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      -- capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

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
                gc_details = true,
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
                rangeVariableTypes = false,
              },
              analyses = {
                fieldalignment = true,
                nilness = true,
                unusedparams = true,
                unusedwrite = true,
                useany = true,
                shadow = true,
                unusedvariable = true,
              },
              usePlaceholders = true,
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
        ts_ls = {
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
        buf = {},
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
}
