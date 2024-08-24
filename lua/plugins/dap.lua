return {
  'mfussenegger/nvim-dap',
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',
    'theHamsta/nvim-dap-virtual-text',

    -- Required dependency for nvim-dap-ui
    'nvim-neotest/nvim-nio',

    -- Installs the debug adapters for you
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Add your own debuggers here
    'leoluz/nvim-dap-go',
    'quolpr/neotest',
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('nvim-dap-virtual-text').setup {}

    require('mason-nvim-dap').setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        'delve',
      },
    }

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    ---@diagnostic disable-next-line: missing-fields
    dapui.setup {
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      ---@diagnostic disable-next-line: missing-fields
      controls = {
        ---@diagnostic disable-next-line: missing-fields
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }

    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'Debug: See last session result.' })

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- Install golang specific config
    require('dap-go').setup {
      delve = {
        -- On Windows delve must be run attached or it crashes.
        -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
        detached = vim.fn.has 'win32' == 0,
      },
    }
  end,

  keys = {
    {
      '<leader>db',
      function()
        require('dap').toggle_breakpoint()
      end,
      desc = 'toggle [d]ebug [b]reakpoint',
    },
    {
      '<leader>dB',
      function()
        require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end,
      desc = '[d]ebug [B]reakpoint',
    },
    {
      '<leader>dc',
      function()
        require('dap').continue()
      end,
      desc = '[d]ebug [c]ontinue (start here)',
    },
    {
      '<leader>dC',
      function()
        require('dap').run_to_cursor()
      end,
      desc = '[d]ebug [C]ursor',
    },
    {
      '<leader>dg',
      function()
        require('dap').goto_()
      end,
      desc = '[d]ebug [g]o to line',
    },
    {
      '<leader>do',
      function()
        require('dap').step_over()
      end,
      desc = '[d]ebug step [o]ver',
    },
    {
      '<leader>dO',
      function()
        require('dap').step_out()
      end,
      desc = '[d]ebug step [O]ut',
    },
    {
      '<leader>di',
      function()
        require('dap').step_into()
      end,
      desc = '[d]ebug [i]nto',
    },
    {
      '<leader>dj',
      function()
        require('dap').down()
      end,
      desc = '[d]ebug [j]ump down',
    },
    {
      '<leader>dk',
      function()
        require('dap').up()
      end,
      desc = '[d]ebug [k]ump up',
    },
    {
      '<leader>dl',
      function()
        require('dap').run_last()
      end,
      desc = '[d]ebug [l]ast',
    },
    {
      '<leader>dp',
      function()
        require('dap').pause()
      end,
      desc = '[d]ebug [p]ause',
    },
    {
      '<leader>dr',
      function()
        require('dap').repl.toggle()
      end,
      desc = '[d]ebug [r]epl',
    },
    {
      '<leader>dR',
      function()
        require('dap').clear_breakpoints()
      end,
      desc = '[d]ebug [R]emove breakpoints',
    },
    {
      '<leader>ds',
      function()
        require('dap').session()
      end,
      desc = '[d]ebug [s]ession',
    },
    {
      '<leader>dt',
      function()
        require('dap').terminate()
      end,
      desc = '[d]ebug [t]erminate',
    },
    {
      '<leader>dw',
      function()
        require('dap.ui.widgets').hover()
      end,
      desc = '[d]ebug [w]idgets',
    },
  },
}
