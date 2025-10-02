function start()
  local M = {}

  local conf = require('fff.conf')
  local file_picker = require('fff.file_picker')

  ---@class FFFSnacksState
  ---@field current_file_cache? string
  ---@field config table FFF config
  M.state = { config = {} }

  local staged_status = {
    staged_new = true,
    staged_modified = true,
    staged_deleted = true,
    renamed = true,
  }

  local status_map = {
    untracked = 'untracked',
    modified = 'modified',
    deleted = 'deleted',
    renamed = 'renamed',
    staged_new = 'added',
    staged_modified = 'modified',
    staged_deleted = 'deleted',
    ignored = 'ignored',
    -- clean = "",
    -- clear = "",
    unknown = 'untracked',
  }

  --- tweaked version of `Snacks.picker.format.file_git_status`
  --- @type snacks.picker.format
  local function format_file_git_status(item, picker)
    local ret = {} ---@type snacks.picker.Highlight[]
    local status = item.status

    local hl = 'SnacksPickerGitStatus'
    if status.unmerged then
      hl = 'SnacksPickerGitStatusUnmerged'
    elseif status.staged then
      hl = 'SnacksPickerGitStatusStaged'
    else
      hl = 'SnacksPickerGitStatus' .. status.status:sub(1, 1):upper() .. status.status:sub(2)
    end

    local icon = picker.opts.icons.git[status.status]
    if status.staged then icon = picker.opts.icons.git.staged end

    local text_icon = status.status:sub(1, 1):upper()
    text_icon = status.status == 'untracked' and '?' or status.status == 'ignored' and '!' or text_icon

    ret[#ret + 1] = { icon, hl }
    ret[#ret + 1] = { ' ', virtual = true }

    ret[#ret + 1] = {
      col = 0,
      virt_text = { { text_icon, hl }, { ' ' } },
      virt_text_pos = 'right_align',
      hl_mode = 'combine',
    }
    return ret
  end

  ---@type snacks.picker.Config
  M.source = {
    title = 'FFFiles',
    finder = function(opts, ctx)
      -- initialization code from require('fff.picker_ui').open
      -- on_show does not seem to be called before finder
      if not M.state.current_file_cache then
        local current_buf = vim.api.nvim_get_current_buf()
        if current_buf and vim.api.nvim_buf_is_valid(current_buf) then
          local current_file = vim.api.nvim_buf_get_name(current_buf)
          if current_file ~= '' and vim.fn.filereadable(current_file) == 1 then
            M.state.current_file_cache = current_file
          else
            M.state.current_file_cache = nil
          end
        end
      end
      if not file_picker.is_initialized() then
        if not file_picker.setup() then
          vim.notify('Failed to initialize file picker', vim.log.levels.ERROR)
          return {}
        end
      end
      local config = conf.get()
      M.state.config = vim.tbl_deep_extend('force', config or {}, opts or {})

      local fff_result = file_picker.search_files(
        ctx.filter.search,
        opts.limit or M.state.config.max_results,
        M.state.config.max_threads,
        M.state.current_file_cache,
        false
      )

      ---@type snacks.picker.finder.Item[]
      local items = {}
      for _, fff_item in ipairs(fff_result) do
        ---@type snacks.picker.finder.Item
        local item = {
          text = fff_item.name,
          file = fff_item.path,
          score = fff_item.total_frecency_score,
          -- HACK: in original snacks implementation status is a string of
          -- `git status --porcelain` output
          status = status_map[fff_item.git_status] and {
            status = status_map[fff_item.git_status],
            staged = staged_status[fff_item.git_status] or false,
            unmerged = fff_item.git_status == 'unmerged',
          },
        }
        items[#items + 1] = item
      end

      return items
    end,
    format = function(item, picker)
      ---@type snacks.picker.Highlight[]
      local ret = {}

      if item.label then
        ret[#ret + 1] = { item.label, 'SnacksPickerLabel' }
        ret[#ret + 1] = { ' ', virtual = true }
      end

      if item.status then
        vim.list_extend(ret, format_file_git_status(item, picker))
      else
        ret[#ret + 1] = { '  ', virtual = true }
      end

      vim.list_extend(ret, require('snacks').picker.format.filename(item, picker))

      if item.line then
        require('snacks').picker.highlight.format(item, item.line, ret)
        table.insert(ret, { ' ' })
      end
      return ret
    end,
    on_close = function() M.state.current_file_cache = nil end,
    formatters = {
      file = {
        filename_first = true,
      },
    },
    live = true,
  }

  return M
end

return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,

  ---@type snacks.Config
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    bigfile = { enabled = true },
    dashboard = { enabled = true },
    indent = {
      enabled = true,
      char = '▎',
      animate = {
        enabled = false,
      },
    },
    input = { enabled = true },
    picker = {
      enabled = true,
      -- layout = {
      --   layout = {
      --     width = 0.95,
      --     height = 0.95,
      --   },
      -- },
      layouts = {
        default = {
          layout = {
            box = 'horizontal',
            width = 0.95,
            height = 0.95,
            {
              box = 'vertical',
              border = 'rounded',
              title = '{source} {live}',
              title_pos = 'center',
              { win = 'input', height = 1,     border = 'bottom' },
              { win = 'list',  border = 'none' },
            },
            { win = 'preview', border = 'rounded', width = 0.5 },
          },
        },
      },
    },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    statuscolumn = {
      left = { 'mark', 'sign', 'fold', 'git' },
      right = {},
      enabled = true,
    },
    words = { enabled = true },
    scratch = {
      ft = function()
        return 'markdown'
      end,
      win = { style = 'split' },
      filekey = {
        cwd = true,
        branch = true,
        count = false
      }
    },
    -- explorer = {
    --   replace_netrw = true,
    --   layout = {
    --     preset = 'sidebar',
    --     layout = {
    --       width = 40,
    --       min_width = 40,
    --       height = 0,
    --     },
    --   },
    -- },
  },
  keys = {
    {
      '<leader>go',
      function()
        Snacks.lazygit()
      end,
      desc = 'Open git',
      mode = { 'n', 'x' },
    },
    -- {
    --   '-',
    --   function()
    --     Snacks.explorer({ layout = { preset = 'sidebar' }, auto_close = true })
    --   end,
    -- },
    {
      '<leader>\\',
      function()
        Snacks.scratch()
      end,
      desc = 'Toggle Scratch Buffer',
    },
    -- {
    --   '<leader>S',
    --   function()
    --     Snacks.scratch.select()
    --   end,
    --   desc = 'Select Scratch Buffer',
    -- },
    {
      '<leader>gl',
      function()
        Snacks.gitbrowse()
      end,
      desc = 'Git link',
    },
    --picker
    {
      '<leader>,',
      function()
        Snacks.picker.buffers()
      end,
      desc = 'Buffers',
    },
    {
      '<leader>/',
      function()
        Snacks.picker.grep()
      end,
      desc = 'Grep',
    },
    {
      '<leader><space>',
      function()
        Snacks.picker(start().source)
      end,
      desc = 'Find Files',
    },
    {
      '<leader>u',
      function()
        Snacks.picker.undo()
      end,
      desc = 'Undo Tree',
    },
    -- {
    --   '<leader>ff',
    --   function()
    --     Snacks.picker.files()
    --   end,
    --   desc = 'Find Files',
    -- },
    -- {
    --   '<leader>fg',
    --   function()
    --     Snacks.picker.git_files()
    --   end,
    --   desc = 'Find Git Files',
    -- },
    -- {
    --   '<leader>fr',
    --   function()
    --     Snacks.picker.recent()
    --   end,
    --   desc = 'Recent',
    -- },
    -- git
    -- {
    --   '<leader>gc',
    --   function()
    --     Snacks.picker.git_log()
    --   end,
    --   desc = 'Git Log',
    -- },
    {
      '<leader>.',
      function()
        Snacks.picker.git_status()
      end,
      desc = 'Git find Status',
    },
    -- Grep
    -- {
    --   '<leader>sb',
    --   function()
    --     Snacks.picker.lines()
    --   end,
    --   desc = 'Buffer Lines',
    -- },
    -- {
    --   '<leader>sB',
    --   function()
    --     Snacks.picker.grep_buffers()
    --   end,
    --   desc = 'Grep Open Buffers',
    -- },
    -- {
    --   '<leader>sg',
    --   function()
    --     Snacks.picker.grep()
    --   end,
    --   desc = 'Grep',
    -- },
    {
      '<leader>fw',
      function()
        Snacks.picker.grep_word()
      end,
      desc = 'Visual selection or word',
      mode = { 'n', 'x' },
    },
    {
      '<leader>f\\',
      function()
        Snacks.scratch.select()
      end,
      desc = 'Find Scratchpad',
      mode = { 'n', 'x' },
    },
    -- search
    -- {
    --   '<leader>s"',
    --   function()
    --     Snacks.picker.registers()
    --   end,
    --   desc = 'Registers',
    -- },
    -- {
    --   '<leader>sa',
    --   function()
    --     Snacks.picker.autocmds()
    --   end,
    --   desc = 'Autocmds',
    -- },
    -- {
    --   '<leader>sc',
    --   function()
    --     Snacks.picker.command_history()
    --   end,
    --   desc = 'Command History',
    -- },
    -- {
    --   '<leader>sC',
    --   function()
    --     Snacks.picker.commands()
    --   end,
    --   desc = 'Commands',
    -- },
    -- {
    --   '<leader>sd',
    --   function()
    --     Snacks.picker.diagnostics()
    --   end,
    --   desc = 'Diagnostics',
    -- },
    -- {
    --   '<leader>sh',
    --   function()
    --     Snacks.picker.help()
    --   end,
    --   desc = 'Help Pages',
    -- },
    -- {
    --   '<leader>sH',
    --   function()
    --     Snacks.picker.highlights()
    --   end,
    --   desc = 'Highlights',
    -- },
    -- {
    --   '<leader>sj',
    --   function()
    --     Snacks.picker.jumps()
    --   end,
    --   desc = 'Jumps',
    -- },
    -- {
    --   '<leader>sk',
    --   function()
    --     Snacks.picker.keymaps()
    --   end,
    --   desc = 'Keymaps',
    -- },
    -- {
    --   '<leader>sl',
    --   function()
    --     Snacks.picker.loclist()
    --   end,
    --   desc = 'Location List',
    -- },
    -- {
    --   '<leader>sM',
    --   function()
    --     Snacks.picker.man()
    --   end,
    --   desc = 'Man Pages',
    -- },
    -- {
    --   '<leader>sm',
    --   function()
    --     Snacks.picker.marks()
    --   end,
    --   desc = 'Marks',
    -- },
    {
      '<leader>fr',
      function()
        Snacks.picker.resume()
      end,
      desc = 'Resume',
    },
    -- {
    --   '<leader>sq',
    --   function()
    --     Snacks.picker.qflist()
    --   end,
    --   desc = 'Quickfix List',
    -- },
    -- {
    --   '<leader>uC',
    --   function()
    --     Snacks.picker.colorschemes()
    --   end,
    --   desc = 'Colorschemes',
    -- },
    -- {
    --   '<leader>qp',
    --   function()
    --     Snacks.picker.projects()
    --   end,
    --   desc = 'Projects',
    -- },
    -- LSP
    {
      'gd',
      function()
        Snacks.picker.lsp_definitions({ jump = { tagstack = true, reuse_win = false } })
      end,
      desc = 'Goto Definition',
    },
    {
      'gr',
      function()
        Snacks.picker.lsp_references({ jump = { tagstack = true, reuse_win = false } })
      end,
      nowait = true,
      desc = 'References',
    },
    {
      'gi',
      function()
        Snacks.picker.lsp_implementations({ jump = { tagstack = true, reuse_win = false } })
      end,
      desc = 'Goto Implementation',
    },
    -- {
    --   'gy',
    --   function()
    --     Snacks.picker.lsp_type_definitions()
    --   end,
    --   desc = 'Goto T[y]pe Definition',
    -- },
    {
      '<leader>fs',
      function()
        Snacks.picker.lsp_symbols()
      end,
      desc = 'LSP Symbols',
    },
    {
      '<leader>fS',
      function()
        Snacks.picker.lsp_workspace_symbols()
      end,
      desc = 'LSP Symbols',
    },
  },
}
