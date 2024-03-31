-- Bootstrap packer
local execute = vim.api.nvim_command
local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
  execute 'packadd packer.nvim'
end

-- Packer initialization
require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use {'junegunn/fzf', run = './install --all'}  -- Installs fzf binaries
  use {'junegunn/fzf.vim'}  -- fzf vim integration

  use { 'Raimondi/delimitMate' } -- auto add closing braces

  use { 'folke/tokyonight.nvim' } -- tokyonight colorscheme
end)

-- Set ',' as the leader key
vim.g.mapleader = ','

-- Keybinding for fzf
vim.api.nvim_set_keymap('n', '<Leader>p', ':Files<CR>', {noremap = true, silent = true})

-- Ag with ,F to search for word
vim.api.nvim_set_keymap('n', '<leader>F', ':Ag<Space>', { noremap = true, silent = true })
-- Ag with ,f to search for current highlighted word
vim.api.nvim_set_keymap('n', '<leader>f', ":lua vim.cmd('Ag ' .. vim.fn.expand('<cword>'))<CR>", { noremap = true, silent = true })


-- prev tab with ,r,
vim.api.nvim_set_keymap('n', '<leader>r<leader>', ':tabprevious<CR>', { noremap = true, silent = true })
-- prev tab with ,t,
vim.api.nvim_set_keymap('n', '<leader>t<leader>', ':tabnext<CR>', { noremap = true, silent = true })

-- enable line numbers
vim.o.number = true

-- go to defintion with gd
vim.api.nvim_set_keymap('n', 'gd', '<C-]>', { noremap = true, silent = true })
-- go to bottom of file with gb
vim.api.nvim_set_keymap('n', 'gb', 'G', { noremap = true, silent = true })

-- Ignore case in searches, but be case-sensitive if a capital letter is used
vim.o.ignorecase = true
vim.o.smartcase = true

-- Use spaces instead of tabs
vim.o.expandtab = true

-- Set the number of spaces per indentation level and for a tab character
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4

-- search with <space>
vim.api.nvim_set_keymap('n', '<Space>', '/', { noremap = true, silent = true })

-- scroll offset of 7
vim.o.scrolloff = 7

-- use the moon variant
vim.cmd[[colorscheme tokyonight-night]]

