return {
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-neotest/nvim-nio',
      'nvim-neotest/neotest-python',
      'fredrikaverpil/neotest-golang',
      'rouge8/neotest-rust',
      'rcasia/neotest-java',
    },
    config = function()
      require('neotest').setup {
        adapters = {
          require('neotest-python') {
            runner = 'pytest',
            dap = { justMyCode = false },
          },
          require('neotest-golang') {},
          -- neotest-rust runs `cargo nextest`, so cargo-nextest must be installed
          require('neotest-rust') {
            args = { '--no-capture' },
          },
          require('neotest-java') {},
        },
      }
    end,
    keys = {
      { '<leader>Tn', function() require('neotest').run.run() end, desc = 'Run [N]earest test' },
      { '<leader>Tf', function() require('neotest').run.run(vim.fn.expand '%') end, desc = 'Run [F]ile tests' },
      { '<leader>Ta', function() require('neotest').run.run(vim.fn.getcwd()) end, desc = 'Run [A]ll tests' },
      { '<leader>Td', function() require('neotest').run.run { strategy = 'dap' } end, desc = '[D]ebug nearest test' },
      { '<leader>Ts', function() require('neotest').summary.toggle() end, desc = 'Toggle test [S]ummary' },
      { '<leader>To', function() require('neotest').output_panel.toggle() end, desc = 'Toggle [O]utput panel' },
    },
  },
}
