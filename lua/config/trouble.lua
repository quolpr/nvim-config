local M = {}

M.opts = {
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
}

M.keys = {
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
}

return M
