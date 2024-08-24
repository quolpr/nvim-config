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
