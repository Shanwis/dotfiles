--[[
  Modular Neovim configuration.
  Layout:
    lua/config/  core editor behavior: options, keymaps, autocmds
    lua/plugins/ lazy.nvim plugin specs, one file per feature area

  Plugin management uses lazy.nvim. Run :Lazy to inspect/update plugins.
]]

vim.loader.enable()

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

require 'config.options'
require 'config.keymaps'
require 'config.autocmds'

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  local out = vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    '--branch=stable',
    'https://github.com/folke/lazy.nvim.git',
    lazypath,
  }
  if vim.v.shell_error ~= 0 then
    error('Failed to clone lazy.nvim:\n' .. out)
  end
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup {
  spec = { { import = 'plugins' } },
  install = { colorscheme = { 'tokyonight-night', 'habamax' } },
  change_detection = { enabled = true, notify = false },
  ui = { border = 'rounded' },
}
