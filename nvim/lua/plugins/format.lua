return {
  {
    'stevearc/conform.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require('conform').setup {
        notify_on_error = false,
        format_on_save = {
          timeout_ms = 500,
        },
        default_format_opts = {
          lsp_format = 'fallback',
        },
        formatters_by_ft = {
          lua = { 'stylua' },
          python = { 'ruff_organize_imports', 'ruff_format' },
          rust = { 'rustfmt' },
          go = { 'goimports', 'gofumpt' },
          c = { 'clang_format' },
          cpp = { 'clang_format' },
          sh = { 'shfmt' },
        },
      }

      vim.keymap.set({ 'n', 'v' }, '<leader>f', function() require('conform').format { async = true } end, { desc = '[F]ormat buffer' })
    end,
  },
}
