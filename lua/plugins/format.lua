-- vim.api.nvim_create_autocmd('BufWritePre', {
--   pattern = '*.go',
--   callback = function()
--     -- local params = vim.lsp.util.make_range_params()
--     -- params.context = { only = { 'source.organizeImports' } }
--     -- -- buf_request_sync defaults to a 1000ms timeout. Depending on your
--     -- -- machine and codebase, you may want longer. Add an additional
--     -- -- argument after params if you find that you have to write the file
--     -- -- twice for changes to be saved.
--     -- -- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
--     -- local result = vim.lsp.buf_request_sync(0, 'textDocument/codeAction', params)
--     -- for cid, res in pairs(result or {}) do
--     --   for _, r in pairs(res.result or {}) do
--     --     if r.edit then
--     --       local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or 'utf-16'
--     --       vim.lsp.util.apply_workspace_edit(r.edit, enc)
--     --     end
--     --   end
--     -- end
--     vim.lsp.buf.format { async = false }
--   end,
-- })

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
        javascript = { 'biome' },
        typescript = { 'biome' },
        json = { { 'prettierd' } },
        typescriptreact = { 'biome' },
        go = { 'gofumpt', 'goimports' },
        proto = { 'buf' },
      },
    },
  },
}
