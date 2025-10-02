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

-- local map = function(keys, func, desc)
--   vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
-- end

vim.keymap.set('n', '<leader>ca', function()
  vim.lsp.buf.code_action({
    -- context = {
    --   diagnostics = get_diagnostic_at_cursor(),
    -- },
    filter = function(action)
      if string.find(action.title, 'to user settings') then
        return false
      end

      return true
    end,
  })
end)

return {
  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Useful status updates for LSP.
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', opts = {} },
    },
    config = function(_, opts)
      local lspconfig = require 'lspconfig'
      local configs = require('lspconfig.configs')
      configs['cspell'] = require('cspell-lsp')

      if not configs.golangcilsp then
        configs.golangcilsp = {
          default_config = {
            cmd = { 'golangci-lint-langserver' },
            root_dir = lspconfig.util.root_pattern('.git', 'go.mod'),
            init_options = {
              command = { "golangci-lint", "run", "--output.json.path", "stdout", "--show-stats=false", "--issues-exit-code=1" },
            },
          }
        }
      end

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

          if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
            map('<leader>ch', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({}))
            end, 'Toggle Inlay Hints')
          end
        end,
      })

      local servers = {
        -- clangd = {},
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
        -- eslint = {},
        biome = {},
        -- buf = {},
        helm_ls = {},
        -- yamlls = {},
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
              -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              -- diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
        cspell = {},
        -- golangci_lint_ls = {
        --   filetypes = { 'go', 'gomod' }
        -- },
      }

      local lspconfig = require('lspconfig')
      for server, config in pairs(servers) do
        config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)
        lspconfig[server].setup(config)
      end
    end,
  },
}
