return function(_, opts)
  vim.lsp.config('cspell', require('cspell-lsp').default_config)

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

      if client and client:supports_method('textDocument/inlayHint', event.buf) then
        map('<leader>ch', function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({}))
        end, 'Toggle Inlay Hints')
      end
    end,
  })

  local servers = {
    gopls = {
      settings = {
        gopls = {
          buildFlags = { '-tags=wireinject' },
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
            nilness = true,
            unusedparams = true,
            unusedwrite = true,
            useany = true,
            shadow = true,
            unusedvariable = true,
          },
          completeUnimported = true,
          staticcheck = true,
          directoryFilters = { '-.git', '-.vscode', '-.idea', '-.vscode-test', '-node_modules' },
          semanticTokens = true,
          usePlaceholders = true,
        },
      },
    },
    golangci_lint_ls = {},
    elixirls = {},
    tsgo = {},
    sqlls = {},
    biome = {},
    helm_ls = {},
    vacuum = {},
    lua_ls = {
      settings = {
        Lua = {
          hint = {
            enable = true,
          },
          completion = {
            callSnippet = 'Replace',
          },
        },
      },
    },
    cspell = {},
  }

  vim.lsp.config('*', {
    capabilities = require('blink.cmp').get_lsp_capabilities(),
  })

  for server, config in pairs(servers) do
    if next(config) ~= nil then
      vim.lsp.config(server, config)
    end
  end

  vim.lsp.enable(vim.tbl_keys(servers))
end
