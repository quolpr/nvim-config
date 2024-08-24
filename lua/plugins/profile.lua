vim.keymap.set('n', '<leader>ps', function()
  vim.cmd [[
    profile start profile.log
    profile func *
    profile file *
  ]]
  vim.notify('Profile started', 'info')
end, { desc = '[P]rofile [S]tart' })

vim.keymap.set('n', '<leader>pe', function()
  vim.cmd [[
    profile pause
    noautocmd qall!
  ]]
end, { desc = '[P]rofile [S]tart' })

return {
  {
    'stevearc/profile.nvim',
    config = function()
      local should_profile = os.getenv 'NVIM_PROFILE'
      if should_profile then
        require('profile').instrument_autocmds()
        if should_profile:lower():match '^start' then
          require('profile').start '*'
        else
          require('profile').instrument '*'
        end
      end

      local function toggle_profile()
        local prof = require 'profile'
        if prof.is_recording() then
          prof.stop()
          vim.ui.input({ prompt = 'Save profile to:', completion = 'file', default = 'profile.json' }, function(filename)
            if filename then
              prof.export(filename)
              vim.notify(string.format('Wrote %s', filename))
            end
          end)
        else
          prof.start '*'
        end
      end

      vim.keymap.set('n', '<leader>pt', toggle_profile)
    end,
  },
}
