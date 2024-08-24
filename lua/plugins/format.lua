return {
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
}
