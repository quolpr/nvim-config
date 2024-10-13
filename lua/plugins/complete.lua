vim.opt.complete = ''

return {
  {
    'saghen/blink.cmp',
    lazy = false, -- lazy loading handled internally
    -- optional: provides snippets for the snippet source
    dependencies = 'rafamadriz/friendly-snippets',

    -- use a release tag to download pre-built binaries
    version = 'v0.*',
    -- OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- On musl libc based systems you need to add this flag
    -- build = 'RUSTFLAGS="-C target-feature=-crt-static" cargo build --release',

    opts = {
      keymap = {
        show = '<C-space>',
        hide = '<C-e>',
        accept = '<Tab>',
        select_prev = { '<C-p>' },
        select_next = { '<C-n>' },
      },
      highlight = {
        -- sets the fallback highlight groups to nvim-cmp's highlight groups
        -- useful for when your theme doesn't support blink.cmp
        -- will be removed in a future release, assuming themes add support
        use_nvim_cmp_as_default = true,
      },
      -- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- adjusts spacing to ensure icons are aligned
      nerd_font_variant = 'mono',

      -- experimental auto-brackets support
      -- accept = { auto_brackets = { enabled = true } }
      -- experimental signature help support
      -- trigger = { signature_help = { enabled = true } }
    },
  },
  -- { -- Autocompletion
  --   'hrsh7th/nvim-cmp',
  --   event = 'InsertEnter',
  --   dependencies = {
  --     -- Snippet Engine & its associated nvim-cmp source
  --     -- {
  --     --   'L3MON4D3/LuaSnip',
  --     --   build = (function()
  --     --     -- Build Step is needed for regex support in snippets
  --     --     -- This step is not supported in many windows environments
  --     --     -- Remove the below condition to re-enable on windows
  --     --     if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
  --     --       return
  --     --     end
  --     --     return 'make install_jsregexp'
  --     --   end)(),
  --     --   dependencies = {
  --     --     -- `friendly-snippets` contains a variety of premade snippets.
  --     --     --    See the README about individual language/framework/plugin snippets:
  --     --     --    https://github.com/rafamadriz/friendly-snippets
  --     --     {
  --     --       'rafamadriz/friendly-snippets',
  --     --       config = function()
  --     --         require('luasnip.loaders.from_vscode').lazy_load()
  --     --       end,
  --     --     },
  --     --   },
  --     -- },
  --     -- 'saadparwaiz1/cmp_luasnip',
  --
  --     -- Adds other completion capabilities.
  --     --  nvim-cmp does not ship with all sources by default. They are split
  --     --  into multiple repos for maintenance purposes.
  --     'hrsh7th/cmp-nvim-lsp',
  --
  --     'hrsh7th/cmp-buffer',
  --     'hrsh7th/cmp-path',
  --     'onsails/lspkind.nvim',
  --
  --     -- nvim-cmp source for neovim Lua API
  --     -- so that things like vim.keymap.set, etc. are autocompleted
  --     'hrsh7th/cmp-nvim-lua',
  --     -- {
  --     --   'MattiasMTS/cmp-dbee',
  --     --   ft = 'sql', -- optional but good to have
  --     --   opts = {}, -- needed
  --     -- },
  --   },
  --   -- luasnip has horrible performance :(
  --   config = function()
  --     -- See `:help cmp`
  --     local cmp = require 'cmp'
  --     -- local luasnip = require 'luasnip'
  --     -- luasnip.config.setup {}
  --
  --     cmp.setup {
  --       preselect = cmp.PreselectMode.None,
  --       -- snippet = {
  --       --   expand = function(args)
  --       --     luasnip.lsp_expand(args.body)
  --       --   end,
  --       -- },
  --       completion = { completeopt = 'menu,menuone,noinsert' },
  --
  --       -- For an understanding of why these mappings were
  --       -- chosen, you will need to read `:help ins-completion`
  --       --
  --       -- No, but seriously. Please read `:help ins-completion`, it is really good!
  --       mapping = cmp.mapping.preset.insert {
  --         -- Select the next item
  --         ['<C-n>'] = cmp.mapping.select_next_item(),
  --         -- Select the previous item
  --         ['<C-p>'] = cmp.mapping.select_prev_item(),
  --
  --         -- Accept (yes) the completion.
  --         --  This will auto-import if your LSP supports it.
  --         --  This will expand snippets if the LSP sent a snippet.
  --         ['<Tab>'] = cmp.mapping.confirm { select = false },
  --
  --         -- Manually trigger a completion from nvim-cmp.
  --         --  Generally you don't need this, because nvim-cmp will display
  --         --  completions whenever it has completion options available.
  --         ['<C-Space>'] = cmp.mapping.complete {},
  --
  --         -- Think of <c-l> as moving to the right of your snippet expansion.
  --         --  So if you have a snippet that's like:
  --         --  function $name($args)
  --         --    $body
  --         --  end
  --         --
  --         -- <c-l> will move you to the right of each of the expansion locations.
  --         -- <c-h> is similar, except moving you backwards.
  --
  --         -- TODO: fix
  --         -- ['<C-l>'] = cmp.mapping(function()
  --         --   -- if luasnip.expand_or_locally_jumpable() then
  --         --   --   luasnip.expand_or_jump()
  --         --   -- end
  --         -- end, { 'i', 's' }),
  --         -- ['<C-h>'] = cmp.mapping(function()
  --         --   -- if luasnip.locally_jumpable(-1) then
  --         --   --   luasnip.jump(-1)
  --         --   -- end
  --         -- end, { 'i', 's' }),
  --       },
  --       sources = {
  --         {
  --           name = 'lazydev',
  --           group_index = 0, -- set group index to 0 to skip loading LuaLS completions
  --         },
  --         { name = 'nvim_lsp' },
  --         { name = 'nvim_lua' },
  --         { name = 'buffer' },
  --         { name = 'path' },
  --         -- { name = 'cmp-dbee' },
  --         -- { name = 'luasnip' },
  --       },
  --       ---@diagnostic disable-next-line: missing-fields
  --       formatting = {
  --         format = require('lspkind').cmp_format {
  --           mode = 'symbol_text', -- show only symbol annotations
  --           maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
  --           ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
  --         },
  --       },
  --     }
  --   end,
  -- },
}
