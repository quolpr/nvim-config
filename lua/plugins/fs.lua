vim.api.nvim_create_autocmd('User', {
  pattern = 'OilEnter',
  callback = vim.schedule_wrap(function(args)
    local oil = require 'oil'
    if vim.api.nvim_get_current_buf() == args.data.buf and oil.get_cursor_entry() then
      oil.open_preview()
    end
  end),
})

return {
  -- {
  --   'lambdalisue/fern.vim',
  --   branch = 'main',
  --   dependencies = {
  --     'lambdalisue/nerdfont.vim',
  --     'lambdalisue/fern-renderer-nerdfont.vim',
  --     'lambdalisue/fern-hijack.vim',
  --   },
  --   lazy = false,
  --
  --   config = function()
  --     vim.g['fern#renderer'] = 'nerdfont'
  --
  --     -- TODO: port it to lua
  --     vim.cmd [[
  --       nmap <silent> - :Fern . -reveal=% -wait <CR>
  --       nmap <silent> _ :Fern %:p:h -wait -reveal=% <CR>
  --
  --
  --       function! s:init_fern() abort
  --         nmap <buffer> <C-J> <C-W><C-J>
  --         nmap <buffer> <C-K> <C-W><C-K>
  --         nmap <buffer> <C-L> <C-W><C-L>
  --         nmap <buffer> <C-H> <C-W><C-H>
  --         nmap <buffer> <CR> <Plug>(fern-action-open-or-expand)
  --       endfunction
  --
  --       augroup fern-custom
  --         autocmd! *
  --         autocmd FileType fern call s:init_fern()
  --       augroup END
  --     ]]
  --   end,
  --   keys = {
  --     {
  --       '-',
  --       function()
  --         vim.cmd [[Fern . -reveal=% -wait <CR>]]
  --       end,
  --     },
  --     {
  --       '_',
  --       function()
  --         vim.cmd [[Fern %:h -wait <CR>]]
  --       end,
  --     },
  --   },
  -- },
  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
      default_file_explorer = true,
      delete_to_trash = true,
      watch_for_changes = true,
      view_options = {
        show_hidden = true,
        natural_sort = true,
        is_always_hidden = function(name)
          return name == '.git' or name == '..'
        end,
      },
      win_options = {
        signcolumn = 'yes:2',
      },
    },
    keys = {
      { '-', '<cmd>Oil --float<CR>', desc = 'Open parent directory' },
    },
    -- Optional dependencies
    dependencies = { { 'echasnovski/mini.icons', opts = {} } },
    -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
  },
  {
    'refractalize/oil-git-status.nvim',

    dependencies = {
      'stevearc/oil.nvim',
    },

    config = true,
  },
  -- {
  --   'nvim-neo-tree/neo-tree.nvim',
  --   branch = 'v3.x',
  --   dependencies = {
  --     'nvim-lua/plenary.nvim',
  --     'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
  --     'MunifTanjim/nui.nvim',
  --     '3rd/image.nvim',
  --   },
  --   config = function()
  --     require('neo-tree').setup {
  --       enable_diagnostics = false,
  --       close_if_last_window = false,
  --       default_component_configs = {
  --         last_modified = { enabled = false },
  --         file_size = { enabled = false },
  --         created = { enabled = false },
  --         type = { enabled = false },
  --       },
  --       filesystem = {
  --         async_directory_scan = 'never',
  --       },
  --     }
  --     vim.keymap.set('n', '_', '<cmd>Neotree source=filesystem reveal=true position=current <CR>', { desc = 'Open neotree' })
  --   end,
  -- },
}
