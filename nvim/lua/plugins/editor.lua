return {
  {
    'NMAC427/guess-indent.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require('guess-indent').setup {}
    end,
  },

  {
    'nvim-mini/mini.nvim',
    event = 'VeryLazy',
    config = function()
      -- Better around/inside textobjects: va)  yiiq  ci'
      require('mini.ai').setup {
        -- Avoid conflicts with builtin incremental selection on Neovim >= 0.12
        mappings = {
          around_next = 'aa',
          inside_next = 'ii',
        },
        n_lines = 500,
      }

      -- Add/delete/replace surroundings: saiw)  sd'  sr)'
      require('mini.surround').setup()

      -- Auto-close brackets and quotes
      require('mini.pairs').setup()

      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = vim.g.have_nerd_font }

      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function() return '%2l:%-2v' end
    end,
  },
}
