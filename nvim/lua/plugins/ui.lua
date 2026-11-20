return {
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('tokyonight').setup {
        styles = {
          comments = { italic = false },
        },
      }
      vim.cmd.colorscheme 'tokyonight-night'
    end,
  },

  {
    'nvim-tree/nvim-web-devicons',
    lazy = true,
    cond = function() return vim.g.have_nerd_font end,
  },

  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    config = function()
      require('which-key').setup {
        delay = 0,
        icons = { mappings = vim.g.have_nerd_font },
        spec = {
          { '<leader>s', group = '[S]earch', mode = { 'n', 'v' } },
          { '<leader>t', group = '[T]oggle' },
          { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
          { '<leader>d', group = '[D]ebug' },
          { '<leader>T', group = '[T]est' },
          { 'gr', group = 'LSP Actions', mode = 'n' },
        },
      }
    end,
  },

  {
    'folke/todo-comments.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      require('todo-comments').setup { signs = false }
    end,
  },
}
