# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a Neovim configuration using [lazy.nvim](https://github.com/folke/lazy.nvim) as the plugin manager. The entry point is `init.lua`, which sets core options/keymaps and bootstraps lazy.nvim to load all plugins from `lua/plugins/`.

## Formatting

Lua files use **stylua** (configured in `.stylua.toml`):
- 2-space indent, 120 column width, single quotes preferred, `sort_requires` enabled
- Run: `stylua lua/ init.lua`

## Architecture

### Entry Point: `init.lua`
Sets vim options, keymaps (leader = `<space>`), language mappings (Russian/English layout), filetype detection overrides (OpenAPI, Helm, gotmpl), then bootstraps lazy.nvim.

### Plugin Files: `lua/plugins/`
Each file returns a lazy.nvim spec table. Key files:

| File | Purpose |
|------|---------|
| `snacks.lua` | Core UI: picker (file/buffer/grep/LSP nav), git, scratch buffers, image preview |
| `lsp.lua` | LSP servers: gopls, ts_ls, lua_ls, golangci-lint, biome, sql, etc. + blink.cmp capabilities |
| `ai.lua` | AI integrations: Copilot/supermaven, Claude (codecompanion), ChatGPT |
| `git.lua` | Neogit, Diffview, Gitsigns, blame.nvim |
| `search.lua` | fzf-lua (secondary fuzzy finder with LSP integration) |
| `complete.lua` | blink.cmp completion engine |
| `format.lua` | conform.nvim: stylua, prettierd, buf (proto), goimports |
| `test.lua` | quicktest.nvim: Go (`-count=1`, `TEST_USE_LOCAL_DB=true`), vitest, Elixir, Dart, RSpec, Playwright |
| `treesitter.lua` | nvim-treesitter + textobjects (note: textobject swap disabled for perf) |
| `ui.lua` | lualine statusline, which-key, notifications (snacks) |

### Custom Modules: `lua/`
- `cspell-lsp/` — custom cspell language server integration
- `history/` — custom history tracking module

### Treesitter Queries: `after/queries/`
Custom query overrides for Go and GoMod.

## Installed Plugins

Before suggesting or adding a plugin, check `lazy-lock.json` to see what is already installed. This avoids adding duplicate functionality. Key plugins currently installed include: snacks.nvim, blink.cmp, vim-illuminate, fzf-lua, gitsigns.nvim, neogit, diffview.nvim, trouble.nvim, which-key.nvim, nvim-treesitter, conform.nvim, quicktest.nvim, lazydev.nvim, todo-comments.nvim, grug-far.nvim, and more.

## Plugin Configuration Pattern

```lua
return {
  {
    'owner/plugin',
    dependencies = { 'other/plugin' },
    event = 'VeryLazy',  -- lazy loading trigger
    opts = { ... },
    config = function(_, opts)
      require('plugin').setup(opts)
    end,
    keys = {
      { '<leader>xx', function() ... end, desc = 'Description' },
    },
  },
}
```

## Keymap Namespacing
- `<leader>c` — code actions / LSP
- `<leader>f` — find (snacks picker)
- `<leader>g` — git
- `<leader>h` — git hunks (gitsigns)
- `<leader>t` — tests (quicktest)
- `<leader>s` — search/replace (grug-far)

## Primary Languages Supported
Go, TypeScript/JavaScript, Lua, Elixir — with full LSP, formatting, and test runner support.

## Setup Script
`setup.sh` creates symlinks for dotfiles (tmux, git, wezterm, ghostty, alacritty) and installs npm LSP dependencies (cspell, yaml-language-server).
