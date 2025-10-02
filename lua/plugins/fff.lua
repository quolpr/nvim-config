return {
  'dmtrKovalenko/fff.nvim',
  build = function()
    -- this will download prebuild binary or try to use existing rustup toolchain to build from source
    -- (if you are using lazy you can use gb for rebuilding a plugin if needed)
    require("fff.download").download_or_build_binary()
  end,
  dependencies = { 'folke/snacks.nvim' },
  -- if you are using nixos
  -- build = "nix run .#release",
  opts = {                -- (optional)
    debug = {
      enabled = true,     -- we expect your collaboration at least during the beta
      show_scores = true, -- to help us optimize the scoring system, feel free to share your scores!
    },
  },
  config = function(_, opts)
    require('fff').setup(opts)
  end,
  lazy = true,
}
