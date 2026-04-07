local M = {}

M.build = function()
  require('fff.download').download_or_build_binary()
end

M.opts = {
  debug = {
    enabled = true,
    show_scores = true,
  },
}

M.config = function(_, opts)
  require('fff').setup(opts)
end

return M
