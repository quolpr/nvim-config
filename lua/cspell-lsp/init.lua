local util = require 'lspconfig.util'

-- Function to decode a URI to a file path
local function decode_uri(uri)
  return string.gsub(uri, 'file://', '')
end

-- Function to read and parse JSON from a file
local function read_json_file(path)
  local file = io.open(path, 'r')
  print('file-path', path)
  if not file then
    error('Failed to open file: ' .. path)
  end
  local data = file:read '*a'
  file:close()

  -- Parse JSON data into Lua table
  local decoded = vim.json.decode(data)
  return decoded
end

-- Function to write JSON data to a file
local function write_json_file(path, table)
  local encoded = vim.json.encode(table)
  local file = io.open(path, 'w')
  if not file then
    error('Failed to open file for writing: ' .. path)
  end
  file:write(encoded)
  file:close()
end

local function line_byte_from_position(lines, lnum, col, offset_encoding)
  if not lines or offset_encoding == 'utf-8' then
    return col
  end

  local line = lines[lnum + 1]
  local ok, result = pcall(vim.str_byteindex, line, col, offset_encoding == 'utf-16')
  if ok then
    return result --- @type integer
  end

  return col
end

---@param bufnr integer
---@return string[]?
local function get_buf_lines(bufnr)
  if vim.api.nvim_buf_is_loaded(bufnr) then
    return vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  end

  local filename = vim.api.nvim_buf_get_name(bufnr)
  local f = io.open(filename)
  if not f then
    return
  end

  local content = f:read '*a'
  if not content then
    -- Some LSP servers report diagnostics at a directory level, in which case
    -- io.read() returns nil
    f:close()
    return
  end

  local lines = vim.split(content, '\n')
  f:close()
  return lines
end

return {
  default_config = {
    cmd = { 'node', '/Users/quolpr/projects/quolpr/vscode-spell-checker/packages/_server/dist/main.mjs', '--stdio' },
    filetypes = { '*' },
    root_dir = util.root_pattern '.git',
    single_file_support = true,
    settings = {
      cSpell = {
        -- logLevel = 'Debug',
        -- logFile = '/Users/quolpr/debug2.log',
        enabled = true,
        trustedWorkspace = true,
        import = { '/Users/quolpr/.config/nvim/cspell.json' },
        checkOnlyEnabledFileTypes = false,
        doNotUseCustomDecorationForScheme = true,
        useCustomDecorations = false,
      },
    },
    handlers = {
      ['_onDiagnostics'] = function(err, result, ctx, config)
        vim.lsp.handlers['textDocument/publishDiagnostics'](err, result[1][1], ctx, config)
        vim.lsp.diagnostic.on_publish_diagnostics(err, result[1][1], ctx, config)
      end,
      ['_onWorkspaceConfigForDocumentRequest'] = function()
        return {
          ['uri'] = nil,
          ['workspaceFile'] = nil,
          ['workspaceFolder'] = nil,
          ['words'] = {},
          ['ignoreWords'] = {},
        }
      end,
    },
    on_init = function()
      vim.lsp.commands['cSpell.editText'] = function(command, scope)
        local buf_lines = get_buf_lines(scope.bufnr)

        local range = command.arguments[3][1].range
        local new_text = command.arguments[3][1].newText

        local start_line = range.start.line
        local start_ch = line_byte_from_position(buf_lines, range.start.line, range.start.character, 'utf-16')
        local end_line = range['end'].line
        local end_ch = line_byte_from_position(buf_lines, range['end'].line, range['end'].character, 'utf-16')

        local lines = vim.api.nvim_buf_get_lines(scope.bufnr, start_line, end_line + 1, false)

        -- Adjust the line based on the provided start and end characters
        local start_line_content = lines[1]
        local end_line_content = lines[#lines]

        -- Slice the start and end lines based on character positions
        local before_range = start_line_content:sub(1, start_ch)
        local after_range = end_line_content:sub(end_ch + 1)

        -- Replace the range with the given new text
        lines[1] = before_range .. new_text .. after_range

        -- Remove intermediate lines if necessary
        if #lines > 1 then
          for i = 2, #lines do
            lines[i] = nil
          end
        end

        vim.api.nvim_buf_set_lines(scope.bufnr, start_line, start_line + 1, false, lines)
      end
      vim.lsp.commands['cSpell.addWordsToConfigFileFromServer'] = function(command)
        print(vim.inspect(command))
        local words = command.arguments[1]
        local json_file_uri = command.arguments[3].uri
        local json_file_path = decode_uri(json_file_uri)

        -- Read the existing JSON data
        local json_data = read_json_file(json_file_path)

        vim.list_extend(json_data.words, words)

        -- Write the updated JSON back to the file
        write_json_file(json_file_path, json_data)
      end

      vim.lsp.commands['cSpell.addWordsToDictionaryFileFromServer'] = function()
        vim.notify 'Not supported'
      end

      vim.lsp.commands['cSpell.addWordsToVSCodeSettingsFromServer'] = function()
        vim.notify 'Not supported'
      end
    end,
  },
  docs = {
    description = [[]],
  },
}
