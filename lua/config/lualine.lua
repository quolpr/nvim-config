return function()
  -- Eviline config for lualine
  -- Author: shadmansaleh
  -- Credit: glepnir
  local lualine = require('lualine')

  -- Color table for highlights
  -- stylua: ignore
  local colors = {
    bg       = '#202328',
    fg       = '#bbc2cf',
    yellow   = '#ECBE7B',
    cyan     = '#008080',
    darkblue = '#081633',
    green    = '#98be65',
    orange   = '#FF8800',
    violet   = '#a9a1e1',
    magenta  = '#c678dd',
    blue     = '#51afef',
    red      = '#ec5f67',
  }

  vim.cmd('highlight! HarpoonInactive guibg=NONE guifg=#63698c')
  vim.cmd('highlight! HarpoonActive guibg=NONE guifg=white')
  vim.cmd('highlight! HarpoonNumberActive guibg=NONE guifg=#7aa2f7')
  vim.cmd('highlight! HarpoonNumberInactive guibg=NONE guifg=#7aa2f7')
  vim.cmd('highlight! TabLineFill guibg=NONE guifg=white')

  local conditions = {
    buffer_not_empty = function()
      return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
    end,
    hide_in_width = function()
      return vim.fn.winwidth(0) > 80
    end,
    check_git_workspace = function()
      local filepath = vim.fn.expand('%:p:h')
      local gitdir = vim.fn.finddir('.git', filepath .. ';')
      return gitdir and #gitdir > 0 and #gitdir < #filepath
    end,
  }

  function Harpoon_files()
    -- Function to truncate the last directory and filename using Neovim's API
    local function truncate_last_dir_and_filename(file_path)
      -- Get the directory containing the file
      local dir = vim.fn.fnamemodify(file_path, ':h')
      -- Extract the last directory name
      local last_dir = vim.fn.fnamemodify(dir, ':t')
      -- Get the filename
      local filename = vim.fn.fnamemodify(file_path, ':t')
      -- Extract the extension from the filename
      local base, ext = string.match(filename, '(.-)%.([^%.]+)$')

      if last_dir == '.' then
        local truncated_path = base .. '.' .. ext
        return truncated_path
      else
        local truncated_path = last_dir .. '/' .. base .. '.' .. ext
        return truncated_path
      end
    end

    -- Function to get the last directory and filename using Vim's API
    local function get_last_dir_and_filename(file_path)
      -- Get the directory containing the file
      local dir = vim.fn.fnamemodify(file_path, ':h')
      -- Get the last part of the directory (last directory name)
      local last_dir = vim.fn.fnamemodify(dir, ':t')
      -- Get the file name
      local filename = vim.fn.fnamemodify(file_path, ':t')

      if last_dir == '.' then
        return filename
      else
        return last_dir .. '/' .. filename
      end
    end

    local harpoon = require('harpoon')
    local contents = {}
    local marks_length = harpoon:list():length()
    local current_file_path = vim.fn.fnamemodify(vim.fn.expand('%:p'), ':.')
    for index = 1, marks_length do
      local harpoon_file_path = harpoon:list():get(index).value
      local file_name = harpoon_file_path == '' and '(empty)' or truncate_last_dir_and_filename(harpoon_file_path)

      if current_file_path == harpoon_file_path then
        contents[index] = string.format('%%#HarpoonNumberActive# %s. %%#HarpoonActive#%s ', index, file_name)
      else
        contents[index] = string.format('%%#HarpoonNumberInactive# %s. %%#HarpoonInactive#%s ', index, file_name)
      end
    end

    return table.concat(contents)
  end

  -- Config
  local config = {
    options = {
      -- Disable sections and component separators
      component_separators = '',
      section_separators = '',
    },
    sections = {
      -- these are to remove the defaults
      lualine_a = {},
      lualine_b = {},
      lualine_y = {},
      lualine_z = {},
      -- These will be filled later
      lualine_c = {},
      lualine_x = {},
    },
    inactive_sections = {
      -- these are to remove the defaults
      lualine_a = {},
      lualine_b = {},
      lualine_y = {},
      lualine_z = {},
      lualine_c = { 'filename' },
      lualine_x = {},
    },
    tabline = {
      lualine_a = {
        { Harpoon_files },
      },
    },
  }

  -- Inserts a component in lualine_c at left section
  local function ins_left(component)
    table.insert(config.sections.lualine_c, component)
  end

  -- Inserts a component in lualine_x at right section
  local function ins_right(component)
    table.insert(config.sections.lualine_x, component)
  end

  ins_left({
    -- mode component
    function()
      return ' '
    end,
    color = function()
      -- auto change color according to neovims mode
      local mode_color = {
        n = colors.fg,
        i = colors.green,
        v = colors.blue,
        [''] = colors.blue,
        V = colors.blue,
        c = colors.magenta,
        no = colors.red,
        s = colors.orange,
        S = colors.orange,
        [''] = colors.orange,
        ic = colors.yellow,
        R = colors.violet,
        Rv = colors.violet,
        cv = colors.red,
        ce = colors.red,
        r = colors.cyan,
        rm = colors.cyan,
        ['r?'] = colors.cyan,
        ['!'] = colors.red,
        t = colors.red,
      }
      return { fg = mode_color[vim.fn.mode()] }
    end,
    padding = { right = 1 },
  })

  ins_left({
    'filename',
    cond = conditions.buffer_not_empty,
  })

  ins_left({
    'diagnostics',
    sources = { 'nvim_diagnostic' },
    symbols = { error = ' ', warn = ' ', info = ' ' },
    diagnostics_color = {
      color_error = { fg = colors.red },
      color_warn = { fg = colors.yellow },
      color_info = { fg = colors.cyan },
    },
  })

  -- Insert mid section. You can make any number of sections in neovim :)
  -- for lualine it's any number greater then 2
  ins_left({
    function()
      return '%='
    end,
  })

  ins_right({ 'progress', color = { fg = colors.fg } })
  ins_right({ 'copilot', show_colors = true })
  ins_right({
    'branch',
    icon = '',
    color = { fg = colors.violet },
  })

  ins_right({
    'diff',
    -- Is it me or the symbol for modified us really weird
    symbols = { added = ' ', modified = '󰝤 ', removed = ' ' },
    diff_color = {
      added = { fg = colors.green },
      modified = { fg = colors.orange },
      removed = { fg = colors.red },
    },
    cond = conditions.hide_in_width,
  })

  -- Now don't forget to initialize lualine
  lualine.setup(config)
end
