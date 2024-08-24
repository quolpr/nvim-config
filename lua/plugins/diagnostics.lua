return {
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
}
