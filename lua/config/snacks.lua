local M = {}

---@type snacks.Config
M.opts = {
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
            { win = 'input', height = 1, border = 'bottom' },
            { win = 'list', border = 'none' },
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
      count = false,
    },
  },
}

M.keys = {
  {
    '<leader>\\',
    function()
      Snacks.scratch()
    end,
    desc = 'Toggle Scratch Buffer',
  },
  {
    '<leader>gl',
    function()
      Snacks.gitbrowse()
    end,
    desc = 'Git link',
  },
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
      Snacks.picker.files()
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
  {
    '<leader>.',
    function()
      Snacks.picker.git_status()
    end,
    desc = 'Git find Status',
  },
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
  {
    '<leader>fr',
    function()
      Snacks.picker.resume()
    end,
    desc = 'Resume',
  },
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
}

return M
