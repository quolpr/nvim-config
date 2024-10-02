local M = {}

local api = vim.api
local fn = vim.fn

-- Configuration
local config = {
  api_key = '',
  api_url = 'https://api.anthropic.com/v1/messages',
  model = 'claude-3-5-sonnet-20240620',
}

function M.setup(opts)
  config = vim.tbl_extend('force', config, opts or {})
end

local function encode_json(data)
  return fn.json_encode(data)
end

local function decode_json(str)
  local success, result = pcall(fn.json_decode, str)
  if success then
    return result
  else
    api.nvim_err_writeln('Error decoding JSON: ' .. result)
    return nil
  end
end

local function parse_sse(data, callback)
  for line in vim.gsplit(data, '\n') do
    if line:match '^data: ' then
      local json_str = line:gsub('^data: ', '')
      if json_str ~= '[DONE]' then
        local decoded = decode_json(json_str)
        if decoded and decoded.type == 'content_block_delta' then
          callback(decoded.delta.text or '')
        end
      end
    end
  end
end

local function stream_request(prompt, callback)
  local data = {
    model = config.model,
    messages = {
      {
        role = 'user',
        content = prompt,
      },
      {
        role = 'assistant',
        content = "You are Claude, an AI assistant that helps people write better code. In response return the whole updated file. Don't put markdown marks. Just a file. And don't any comments. Just code. And it should start with code immediately, with new lines at top",
      },
    },
    max_tokens = 8192,
    stream = true,
  }

  local json_data = encode_json(data)
  local temp_file = fn.tempname()
  local file = io.open(temp_file, 'w')
  file:write(json_data)
  file:close()

  local curl_command = string.format(
    'curl -s -N -X POST %s ' .. "-H 'Content-Type: application/json' " .. "-H 'x-api-key: %s' " .. "-H 'anthropic-version: 2023-06-01' " .. '-d @%s',
    config.api_url,
    config.api_key,
    temp_file
  )

  local job_id = fn.jobstart(curl_command, {
    on_stdout = function(_, data)
      parse_sse(table.concat(data, '\n'), callback)
    end,
    on_exit = function(_, exit_code)
      os.remove(temp_file)
      if exit_code ~= 0 then
        api.nvim_err_writeln('Error in API request. Exit code: ' .. exit_code)
      end
      callback(nil, true)
    end,
  })

  return job_id
end

function M.claude_request()
  if config.api_key == '' then
    api.nvim_err_writeln 'API key not set. Please set up the plugin with your API key.'
    return
  end

  -- Get current buffer content
  local current_buf = api.nvim_get_current_buf()
  local lines = api.nvim_buf_get_lines(current_buf, 0, -1, false)
  local content = table.concat(lines, '\n')
  local current_buftype = api.nvim_buf_get_option(current_buf, 'buftype')
  local current_filetype = api.nvim_buf_get_option(current_buf, 'filetype')

  -- Get user prompt
  local prompt = fn.input 'Enter your prompt for Claude (default: Improve the code): '
  if prompt == '' then
    prompt = 'Improve the code'
  end

  local full_prompt = string.format(
    "Here's the current buffer content:\n\n%s\n\nUser prompt: %s\n\n"
      .. 'Please provide only the modified code as your response, without any additional comments, explanations, or markdown formatting. '
      .. 'The response should be in a format suitable for direct use in a diff view.',
    content,
    prompt
  )

  -- Create a new split buffer for the result
  api.nvim_command 'vnew'
  local result_buf = api.nvim_get_current_buf()
  api.nvim_buf_set_option(result_buf, 'buftype', current_buftype)
  api.nvim_buf_set_option(result_buf, 'filetype', current_filetype)
  -- api.nvim_buf_set_name(result_buf, 'Claude Result (Streaming)')

  -- Disable undo history for the new buffer
  api.nvim_buf_set_option(result_buf, 'undolevels', -1)

  local full_response = ''

  -- Start the streaming request
  local job_id = stream_request(full_prompt, function(response, is_complete)
    if response then
      full_response = full_response .. response
      local lines = vim.split(full_response, '\n')

      -- Update the buffer with all lines
      api.nvim_buf_set_lines(result_buf, 0, -1, false, lines)

      -- -- Scroll to the bottom of the buffer
      -- api.nvim_command 'normal! G'
    end

    if is_complete then
      print 'Claude response completed. Applying diff...'

      local diff_buf = api.nvim_get_current_buf()
      api.nvim_buf_set_option(diff_buf, 'buftype', 'nofile')

      -- Enable diff mode for all windows
      api.nvim_command 'windo diffthis'

      -- Move cursor to the first window (original content)
      api.nvim_command 'wincmd t'

      -- Set up autocmd to disable diff mode when closing the diff buffer
      api.nvim_command [[
        augroup ClaudeDiff
          autocmd!
          autocmd BufWinLeave <buffer> windo diffoff
        augroup END
      ]]
    end
  end)

  -- Allow user to cancel the request
  vim.api.nvim_buf_set_keymap(result_buf, 'n', 'q', string.format(':call jobstop(%d)|q<CR>', job_id), { noremap = true, silent = true })
end

vim.keymap.set('n', '<leader>C', function()
  M.claude_request()
end, { desc = 'Claude Request' })

return {
  {
    'supermaven-inc/supermaven-nvim',
    config = function()
      require('supermaven-nvim').setup {

        ignore_filetypes = { markdown = true },
        keymaps = {
          accept_suggestion = '<C-u>',
        },
      }
    end,
  },
  --   {
  --     dir = '~/projects/quolpr/parrot.nvim',
  --     lazy = false,
  --     config = function()
  --       require('parrot').setup {
  --         hooks = {
  --           Complete = function(prt, params)
  --             local template = [[
  --         I have the following code from {{filename}}:
  --
  --         ```{{filetype}}
  --         {{filecontent}}
  --         ```
  --
  --         And I want to work on part of the code at line_start={{linestart}}, line_end={{lineend}}:
  --         ```{{filetype}}
  --         {{selection}}
  --         ```
  --
  --         Please finish the code above carefully and logically.
  --         Respond just with the snippet of code that should be inserted."
  --         ]]
  --             local agent = prt.get_command_agent()
  --             prt.Prompt(params, prt.ui.Target.append, nil, agent.model, template, agent.system_prompt, agent.provider)
  --           end,
  --           Explain = function(prt, params)
  --             local template = [[
  --         Your task is to take the code snippet from {{filename}} and explain it.
  --         Break down the code's functionality, purpose, and key components.
  --         The goal is to help the reader understand what the code does and how it works.
  --
  --         Here is the full code:
  --         ```{{filetype}}
  --         {{filecontent}}
  --         ```
  --
  --         And I need to explain the code at line_start={{linestart}}, line_end={{lineend}}:
  --         ```{{filetype}}
  --         {{selection}}
  --         ```
  --
  --         Use the markdown format with codeblocks and inline code.
  --         Explanation of the code above:
  --         ]]
  --             local agent = prt.get_chat_agent()
  --             prt.logger.info('Explaining selection with agent: ' .. agent.name)
  --             prt.Prompt(params, prt.ui.Target.new, nil, agent.model, template, agent.system_prompt, agent.provider)
  --           end,
  --           FixBugs = function(prt, params)
  --             local template = [[
  --         You are an expert in {{filetype}}.
  --         Fix bugs in the below code from {{filename}} carefully and logically:
  --         Your task is to analyze the provided {{filetype}} code snippet, identify
  --         any bugs or errors present, and provide a corrected version of the code
  --         that resolves these issues. Explain the problems you found in the
  --         original code and how your fixes address them. The corrected code should
  --         be functional, efficient, and adhere to best practices in
  --         {{filetype}} programming.
  --
  --         Here is the full code:
  --         ```{{filetype}}
  --         {{filecontent}}
  --         ```
  --
  --         And I want to work on part of the code at line_start={{linestart}}, line_end={{lineend}}:
  --         ```{{filetype}}
  --         {{selection}}
  --         ```
  --
  --         Fixed code:
  --         ]]
  --             local agent = prt.get_command_agent()
  --             prt.logger.info('Fixing bugs in selection with agent: ' .. agent.name)
  --             prt.Prompt(params, prt.ui.Target.new, nil, agent.model, template, agent.system_prompt, agent.provider)
  --           end,
  --           Optimize = function(prt, params)
  --             local template = [[
  --         You are an expert in {{filetype}}.
  --         Your task is to analyze the provided {{filetype}} code snippet and
  --         suggest improvements to optimize its performance. Identify areas
  --         where the code can be made more efficient, faster, or less
  --         resource-intensive. Provide specific suggestions for optimization,
  --         along with explanations of how these changes can enhance the code's
  --         performance. The optimized code should maintain the same functionality
  --         as the original code while demonstrating improved efficiency.
  --
  --         Here is the full code:
  --         ```{{filetype}}
  --         {{filecontent}}
  --         ```
  --
  --         And I want to work on part of the code at line_start={{linestart}}, line_end={{lineend}}:
  --         ```{{filetype}}
  --         {{selection}}
  --         ```
  --
  --         Optimized code:
  --         ]]
  --             local agent = prt.get_command_agent()
  --             prt.logger.info('Optimizing selection with agent: ' .. agent.name)
  --             prt.Prompt(params, prt.ui.Target.new, nil, agent.model, template, agent.system_prompt, agent.provider)
  --           end,
  --           UnitTests = function(prt, params)
  --             local template = [[
  --         I have the following code from {{filename}}:
  --
  --         ```{{filetype}}
  --         {{filecontent}}
  --         ```
  --
  --         And I want to work on part of the code at line_start={{linestart}}, line_end={{lineend}}:
  --         ```{{filetype}}
  --         {{selection}}
  --         ```
  --
  --         Please respond by writing table driven unit tests for the code above.
  --         ]]
  --             local agent = prt.get_command_agent()
  --             prt.logger.info('Creating unit tests for selection with agent: ' .. agent.name)
  --             prt.Prompt(params, prt.ui.Target.enew, nil, agent.model, template, agent.system_prompt, agent.provider)
  --           end,
  --           ProofReader = function(prt, params)
  --             local chat_system_prompt = [[
  --         I want you to act as a proofreader. I will provide you with texts and
  --         I would like you to review them for any spelling, grammar, or
  --         punctuation errors. Once you have finished reviewing the text,
  --         provide me with any necessary corrections or suggestions to improve the
  --         text. Highlight the corrections with markdown bold or italics style.
  --         ]]
  --             local agent = prt.get_chat_agent()
  --             prt.logger.info('Proofreading selection with agent: ' .. agent.name)
  --             prt.cmd.ChatNew(params, agent.model, chat_system_prompt)
  --           end,
  --           Debug = function(prt, params)
  --             local template = [[
  --         I want you to act as {{filetype}} expert.
  --         Review the following code, carefully examine it, and report potential
  --         bugs and edge cases alongside solutions to resolve them.
  --         Keep your explanation short and to the point:
  --
  --         Full file:
  --         ```{{filetype}}
  --         {{filecontent}}
  --         ```
  --
  --         And I want to work on part of the code at line_start={{linestart}}, line_end={{lineend}}:
  --         ```{{filetype}}
  --         {{selection}}
  --         ```
  --         ]]
  --             local agent = prt.get_chat_agent()
  --             prt.logger.info('Debugging selection with agent: ' .. agent.name)
  --             prt.Prompt(params, prt.ui.Target.enew, nil, agent.model, template, agent.system_prompt, agent.provider)
  --           end,
  --         },
  --         template_selection = [[
  -- I have the following content from {{filename}}:
  --
  -- ```{{filetype}}
  -- {{filecontent}}
  -- ```
  --
  -- And I want to work on part of the code at line_start={{linestart}}, line_end={{lineend}}:
  --
  -- ```{{filetype}}
  -- {{selection}}
  -- ```
  --
  -- {{command}}
  -- ]],
  --         template_rewrite = [[
  -- I have the following content from {{filename}}:
  --
  -- ```{{filetype}}
  -- {{filecontent}}
  -- ```
  --
  -- And I want modify this part of the code at line_start={{linestart}}, line_end={{lineend}}:
  --
  -- ```{{filetype}}
  -- {{selection}}
  -- ```
  --
  -- Do this:{{command}}
  --
  -- Respond exclusively with the snippet that should replace the selection above.
  -- DO NOT RESPOND WITH ANY TYPE OF COMMENTS, JUST THE CODE!!!
  -- ]],
  --         template_append = [[
  -- I have the following content from {{filename}}:
  --
  -- ```{{filetype}}
  -- {{filecontent}}
  -- ```
  --
  -- And I want modify this part of the code at line_start={{linestart}}, line_end={{lineend}}:
  --
  -- ```{{filetype}}
  -- {{selection}}
  -- ```
  --
  -- Do this:{{command}}
  --
  -- Respond exclusively with the snippet that should be appended after the selection above.
  -- DO NOT RESPOND WITH ANY TYPE OF COMMENTS, JUST THE CODE!!!
  -- DO NOT REPEAT ANY CODE FROM ABOVE!!!
  -- ]],
  --         template_prepend = [[
  -- I have the following content from {{filename}}:
  --
  -- ```{{filetype}}
  -- {{filecontent}}
  -- ```
  --
  -- And I want modify this part of the code at line_start={{linestart}}, line_end={{lineend}}:
  --
  -- ```{{filetype}}
  -- {{selection}}
  -- ```
  --
  -- Do this:{{command}}
  --
  -- Respond exclusively with the snippet that should be prepended before the selection above.
  -- DO NOT RESPOND WITH ANY TYPE OF COMMENTS, JUST THE CODE!!!
  -- DO NOT REPEAT ANY CODE FROM ABOVE!!!
  -- ]],
  --         providers = {
  --           openai = {
  --             api_key = '',
  --           },
  --         },
  --         toggle_target = 'popup',
  --       }
  --
  --       -- or setup with your own config (see Install > Configuration in Readme)
  --       -- require("gp").setup(config)
  --
  --       -- shortcuts might be setup here (see Usage > Shortcuts in Readme)
  --
  --       -- local function keymapOptions(desc)
  --       --   return {
  --       --     noremap = true,
  --       --     silent = true,
  --       --     nowait = true,
  --       --     desc = 'GPT prompt ' .. desc,
  --       --   }
  --       -- end
  --
  --       -- Chat commands
  --       -- vim.keymap.set({ 'n', 'i' }, '<leader>at', '<cmd>GpChatToggle popup<cr>', keymapOptions 'ChatGPT Toggle')
  --       -- vim.keymap.set({ 'n', 'i' }, '<leader>at', '<cmd>GpChatToggle popup<cr>', keymapOptions 'ChatGPT Toggle')
  --     end,
  --     keys = {
  --       {
  --         '<leader>at',
  --         function()
  --           return ':PrtChatToggle popup<cr>'
  --         end,
  --         desc = 'ChatGPT Toggle',
  --         expr = true,
  --       },
  --       {
  --         '<leader>av',
  --         function()
  --           return ':PrtChatToggle vsplit<cr>'
  --         end,
  --         desc = 'ChatGPT open V-split',
  --         expr = true,
  --       },
  --       {
  --         '<leader>an',
  --         function()
  --           return ':PrtChatNew popup<cr>'
  --         end,
  --         desc = 'ChatGPT New',
  --         expr = true,
  --       },
  --       {
  --         '<leader>an',
  --         function()
  --           return ":<C-u>'<,'>PrtChatNew popup<cr>"
  --         end,
  --         desc = 'ChatGPT New',
  --         expr = true,
  --         mode = { 'v' },
  --       },
  --       {
  --         '<leader>fa',
  --         function()
  --           return ':PrtChatFinder<cr>'
  --         end,
  --         desc = 'Find Chat',
  --         expr = true,
  --       },
  --       {
  --         '<leader>ai',
  --         function()
  --           return ":<C-u>'<,'>PrtImplement<cr>"
  --         end,
  --         desc = 'ChatGPT Iimplement',
  --         mode = { 'v' },
  --         expr = true,
  --       },
  --       {
  --         '<leader>ap',
  --         function()
  --           return ":<C-u>'<,'>PrtPrepend<cr>"
  --         end,
  --         desc = 'ChatGPT Prepend',
  --         mode = { 'v' },
  --         expr = true,
  --       },
  --       {
  --         '<leader>aa',
  --         function()
  --           return ":<C-u>'<,'>PrtAppend<cr>"
  --         end,
  --         desc = 'ChatGPT Append',
  --         mode = { 'v' },
  --         expr = true,
  --       },
  --       {
  --         '<leader>ar',
  --         function()
  --           return ":<C-u>'<,'>PrtRewrite<cr>"
  --         end,
  --         desc = 'ChatGPT Rewrite',
  --         mode = { 'v' },
  --         expr = true,
  --       },
  --       {
  --         '<leader>am',
  --         function()
  --           return ":<C-u>'<,'>PrtChatPaste popup<cr>"
  --         end,
  --         desc = 'ChatGPT Move to chat',
  --         mode = { 'v' },
  --         expr = true,
  --       },
  --     },
  --   },
}
