-- debug.lua
--
-- nvim-dap + nvim-dap-ui core, plus codelldb for C/C++ debugging (relevant
-- to Unreal Engine work). Java debugging is handled separately by
-- ftplugin/java.lua's nvim-jdtls integration, not here.

return {
  'mfussenegger/nvim-dap',
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',

    -- Required dependency for nvim-dap-ui
    'nvim-neotest/nvim-nio',

    -- Installs the debug adapters for you
    'mason-org/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',
  },
  keys = {
    -- No F-keys: grouped entirely under <leader>d so it's discoverable via
    -- which-key and doesn't depend on the keyboard having function keys.
    {
      '<leader>dc',
      function()
        require('dap').continue()
      end,
      desc = '[D]ebug [C]ontinue/Start',
    },
    {
      '<leader>di',
      function()
        require('dap').step_into()
      end,
      desc = '[D]ebug Step [I]nto',
    },
    {
      '<leader>do',
      function()
        require('dap').step_over()
      end,
      desc = '[D]ebug Step [O]ver',
    },
    {
      '<leader>dO',
      function()
        require('dap').step_out()
      end,
      desc = '[D]ebug Step [O]ut',
    },
    {
      '<leader>db',
      function()
        require('dap').toggle_breakpoint()
      end,
      desc = '[D]ebug Toggle [B]reakpoint',
    },
    {
      '<leader>dB',
      function()
        require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end,
      desc = '[D]ebug Conditional [B]reakpoint',
    },
    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    {
      '<leader>du',
      function()
        require('dapui').toggle()
      end,
      desc = '[D]ebug Toggle [U]I',
    },
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,

      -- mason-nvim-dap has a built-in automatic handler for both 'delve'
      -- and 'codelldb', so an empty handlers table is enough to wire up
      -- dap.adapters.delve / dap.adapters.codelldb automatically.
      handlers = {},

      ensure_installed = {
        'delve', -- Go
        'codelldb', -- C/C++ (LLDB-based; independent of the system clangd used for Unreal Engine)
      },
    }

    -- codelldb wires the adapter automatically (see handlers note above),
    -- but unlike Go there's no generic "run this binary" config it can
    -- infer, so the launch configuration is declared explicitly.
    dap.configurations.cpp = {
      {
        name = 'Launch',
        type = 'codelldb',
        request = 'launch',
        program = function()
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
      },
      {
        -- One-key way to launch the Unreal Editor itself under the
        -- debugger, alongside the generic "any executable" config above.
        name = 'Launch UE Editor',
        type = 'codelldb',
        request = 'launch',
        program = '/home/Venthryn/Programs/UnrealEngine/Engine/Binaries/Linux/UnrealEditor',
        args = function()
          local default = vim.fn.glob(vim.fn.getcwd() .. '/*.uproject')
          return { vim.fn.input('Path to .uproject: ', default, 'file') }
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
      },
    }
    dap.configurations.c = dap.configurations.cpp

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup {
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
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

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close
  end,
}
-- vim: ts=2 sts=2 sw=2 et
