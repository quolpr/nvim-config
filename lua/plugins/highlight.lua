return {
  -- Highlight todo, notes, etc in comments
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },
  -- Illuminate parentheses
  {
    'RRethy/vim-illuminate',
    config = function()
      require('illuminate').configure {
        providers = {
          'lsp',
          'treesitter',
        },
      }
    end,
  },
  -- Highlight #hexhex colors
  -- Slow at lua profiling
  -- {
  --   'norcalli/nvim-colorizer.lua',
  --   config = function()
  --     require('colorizer').setup {}
  --   end,
  -- },
  -- Highlight on f/F press
  -- {
  --   'jinh0/eyeliner.nvim',
  --   config = function()
  --     require('eyeliner').setup {
  --       highlight_on_key = true, -- show highlights only after keypress
  --       dim = false, -- dim all other characters if set to true (recommended!)
  --     }
  --   end,
  -- },
  -- {
  --   'folke/flash.nvim',
  --   event = 'VeryLazy',
  --   ---@type Flash.Config
  --   opts = {},
  --   -- stylua: ignore
  --   keys = {
  --     { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
  --     { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
  --     { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
  --     { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
  --     { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
  --   },
  -- },
}
