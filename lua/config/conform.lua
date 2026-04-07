return {
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
}
