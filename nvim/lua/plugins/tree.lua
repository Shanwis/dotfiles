return {
  {
    'nvim-tree/nvim-tree.lua',
    cmd = { 'NvimTreeToggle', 'NvimTreeFindFile', 'NvimTreeFocus', 'NvimTreeClose' },
    init = function()
      -- Let nvim-tree take over the default file explorer
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
    end,
    config = function()
      require('nvim-tree').setup {
        view = { width = 34 },
        renderer = { group_empty = true },
        filters = { dotfiles = false },
      }
    end,
    keys = {
      { '<leader>e', '<cmd>NvimTreeToggle<CR>', desc = 'Toggle file [E]xplorer' },
      { '<leader>E', '<cmd>NvimTreeFindFile<CR>', desc = 'Reveal current file in [E]xplorer' },
    },
  },
}
