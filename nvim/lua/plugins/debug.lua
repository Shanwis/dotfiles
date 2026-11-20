return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'nvim-neotest/nvim-nio',
      'rcarriga/nvim-dap-ui',
      'theHamsta/nvim-dap-virtual-text',
      'leoluz/nvim-dap-go',
    },
    config = function()
      local dap = require 'dap'
      local dapui = require 'dapui'

      local mason = vim.fn.stdpath 'data' .. '/mason/packages'

      -- Python (debugpy, installed via mason)
      dap.adapters.python = {
        type = 'executable',
        command = mason .. '/debugpy/venv/bin/python',
        args = { '-m', 'debugpy.adapter' },
      }
      dap.configurations.python = {
        {
          type = 'python',
          request = 'launch',
          name = 'Launch file',
          program = '${file}',
          console = 'integratedTerminal',
          pythonPath = function()
            local venv = vim.fn.getcwd() .. '/.venv/bin/python'
            return (vim.fn.executable(venv) == 1) and venv or 'python3'
          end,
        },
      }

      -- C / C++ / Rust (codelldb, installed via mason)
      dap.adapters.codelldb = {
        type = 'server',
        port = '${port}',
        executable = {
          command = mason .. '/codelldb/extension/adapter/codelldb',
          args = { '--port', '${port}' },
        },
      }

      local function pick_executable(default_dir)
        return vim.fn.input('Path to executable: ', default_dir, 'file')
      end

      dap.configurations.c = {
        {
          name = 'Launch file',
          type = 'codelldb',
          request = 'launch',
          program = function() return pick_executable(vim.fn.getcwd() .. '/') end,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
        },
      }
      dap.configurations.cpp = dap.configurations.c

      dap.configurations.rust = {
        {
          name = 'Launch executable',
          type = 'codelldb',
          request = 'launch',
          program = function() return pick_executable(vim.fn.getcwd() .. '/target/debug/') end,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
        },
      }

      -- Go (delve via nvim-dap-go; also powers neotest-golang's debug strategy)
      require('dap-go').setup()

      require('dapui').setup()
      require('nvim-dap-virtual-text').setup()

      dap.listeners.after.event_initialized['dapui_config'] = function() dapui.open() end
      dap.listeners.before.event_terminated['dapui_config'] = function() dapui.close() end
      dap.listeners.before.event_exited['dapui_config'] = function() dapui.close() end
    end,
    keys = {
      { '<leader>db', function() require('dap').toggle_breakpoint() end, desc = 'Toggle [B]reakpoint' },
      { '<leader>dB', function() require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ') end, desc = 'Conditional [B]reakpoint' },
      { '<leader>dc', function() require('dap').continue() end, desc = '[C]ontinue / start' },
      { '<leader>di', function() require('dap').step_into() end, desc = 'Step [I]nto' },
      { '<leader>do', function() require('dap').step_over() end, desc = 'Step [O]ver' },
      { '<leader>dO', function() require('dap').step_out() end, desc = 'Step [O]ut' },
      { '<leader>dt', function() require('dap').terminate() end, desc = '[T]erminate session' },
      { '<leader>du', function() require('dapui').toggle() end, desc = 'Toggle debug [U]I' },
    },
  },
}
