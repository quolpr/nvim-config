---@module 'blink.cmp'
---@type blink.cmp.Config
return {
  keymap = { preset = 'super-tab' },
  appearance = {
    use_nvim_cmp_as_default = true,
    nerd_font_variant = 'mono',
  },
  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
  },
  completion = {
    documentation = {
      auto_show = true,
    },
  },
  signature = {
    enabled = false,
  },
}
