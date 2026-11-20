return {
  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require('gitsigns').setup {
        signs = {
          add = { text = '+' }, ---@diagnostic disable-line: missing-fields
          change = { text = '~' }, ---@diagnostic disable-line: missing-fields
          delete = { text = '_' }, ---@diagnostic disable-line: missing-fields
          topdelete = { text = '‾' }, ---@diagnostic disable-line: missing-fields
          changedelete = { text = '~' }, ---@diagnostic disable-line: missing-fields
        },
      }
    end,
    keys = {
      { ']h', function() require('gitsigns').nav_hunk 'next' end, desc = 'Go to next git [H]unk' },
      { '[h', function() require('gitsigns').nav_hunk 'prev' end, desc = 'Go to previous git [H]unk' },

      { '<leader>hs', function() require('gitsigns').stage_hunk() end, mode = 'n', desc = '[S]tage hunk' },
      { '<leader>hs', function() require('gitsigns').stage_hunk { vim.fn.line '.', vim.fn.line 'v' } end, mode = 'v', desc = '[S]tage hunk' },
      { '<leader>hr', function() require('gitsigns').reset_hunk() end, mode = 'n', desc = '[R]eset hunk' },
      { '<leader>hr', function() require('gitsigns').reset_hunk { vim.fn.line '.', vim.fn.line 'v' } end, mode = 'v', desc = '[R]eset hunk' },

      { '<leader>hS', function() require('gitsigns').stage_buffer() end, desc = '[S]tage buffer' },
      { '<leader>hu', function() require('gitsigns').undo_stage_hunk() end, desc = '[U]ndo stage hunk' },
      { '<leader>hp', function() require('gitsigns').preview_hunk() end, desc = '[P]review hunk' },
      { '<leader>hb', function() require('gitsigns').blame_line { full = true } end, desc = '[B]lame line' },
      { '<leader>hd', function() require('gitsigns').diffthis() end, desc = '[D]iff against index' },
    },
  },
}
