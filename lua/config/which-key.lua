return function()
  require('which-key').setup()

  -- Document existing key chains
  require('which-key').add({
    { '<leader>1', hidden = true },
    { '<leader>2', hidden = true },
    { '<leader>3', hidden = true },
    { '<leader>4', hidden = true },
    { '<leader>5', hidden = true },
    { '<leader>6', hidden = true },
    { '<leader>7', hidden = true },
    { '<leader>8', hidden = true },
    { '<leader>9', hidden = true },
    { '<leader>a', group = 'ChatGPT' },
    { '<leader>a_', hidden = true },
    { '<leader>e', group = 'Edit' },
    { '<leader>e_', hidden = true },
    { '<leader>c', group = 'Code' },
    { '<leader>c_', hidden = true },
    { '<leader>f', group = 'Find' },
    { '<leader>f_', hidden = true },
    { '<leader>g', group = 'Git' },
    { '<leader>g_', hidden = true },
    { '<leader>h', group = 'Git Hunk' },
    { '<leader>h_', hidden = true },
    { '<leader>n', group = 'Notes' },
    { '<leader>n_', hidden = true },
    { '<leader>q', group = 'Quit Persistence' },
    { '<leader>q_', hidden = true },
    { '<leader>t', group = 'Test' },
    { '<leader>t_', hidden = true },
    { 'gr', group = 'LSP Actions' },
  })
end
