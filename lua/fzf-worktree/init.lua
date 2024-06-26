local parse_entry = function(entry)
  local parsed = vim.split(entry, '%s+')
  print(vim.inspect(parsed))
  return { path = parsed[1], hash = parsed[2], branch = parsed[3]:sub(2, #parsed[3] - 1) }
end

local switch_worktree = function(selected, _)
  local parsed = parse_entry(selected[1])

  require('git-worktree').switch_worktree(parsed.branch)
end

-- local delete_worktree = function(selected, _)
--   local parsed = parse_entry(selected[1])
--   vim.ui.input({
--     prompt = string.format('Delete worktree %s? [y/N] ', parsed.branch),
--   }, function(input)
--     if vim.trim(input):lower() == 'y' then
--       require('git-worktree').delete_worktree(parsed.branch, true)
--     end
--   end)
-- end

local fzf = require 'fzf-lua'
local actions = require 'fzf-lua.actions'

-- local create_worktree = function(...)
--   vim.schedule(function()
--     print(vim.inspect(arg))
--     print('create_worktree', print(vim.inspect(fzf.config.__resume_data.last_query)))
--   end)
--
--   local query = fzf.config.__resume_data.last_query
--
--   if query == nil or query == '' then
--     return
--   end
--   local path, branch, upstream = unpack(vim.split(vim.trim(query), ' '))
--   branch = not branch and vim.fn.fnamemodify(path, ':t') or branch
--
--   -- require('git-worktree').create_worktree(path, branch, upstream)
-- end

-- call with require('file').git_worktrees()
return {
  git_worktrees = function()
    local opts = fzf.config.normalize_opts({}, fzf.config.globals.git)

    opts.cmd = fzf.path.git_cwd('git worktree list | sed "s|$HOME|~|g" | sed  "/\\(bare\\)/d" ', opts)

    opts.actions = {
      ['default'] = switch_worktree,
    }

    fzf.core.fzf_wrap(opts, opts.cmd, function(selected)
      if not selected then
        return
      end
      actions.act(opts.actions, selected, opts)
    end)()
  end,
}
