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

  use { 'vim-scripts/bufexplorer.zip' } --bufexplorer

  -- Start Completion framework
  use 'hrsh7th/nvim-cmp'
  -- Completion sources
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  -- Snippet engine
  use 'hrsh7th/vim-vsnip'
  use 'hrsh7th/cmp-vsnip'
  -- End Completion framework
  use 'neovim/nvim-lspconfig'

  -- git blame
    use 'f-person/git-blame.nvim'

  -- telescope
    use {
      'nvim-telescope/telescope.nvim', tag = '0.1.6',
      requires = { {'nvim-lua/plenary.nvim'} }
    }
    use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }

    -- Install nvim-treesitter
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
    }

    -- Add NERDTree
    use 'preservim/nerdtree'
end)

-- Set ',' as the leader key
vim.g.mapleader = ','

-- prev tab with ,r,
vim.api.nvim_set_keymap('n', '<leader>r<leader>', ':tabprevious<CR>', { noremap = true, silent = true })
-- prev tab with ,t,
vim.api.nvim_set_keymap('n', '<leader>t<leader>', ':tabnext<CR>', { noremap = true, silent = true })

-- enable line numbers
vim.o.number = true

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

-- arrows, brackets, and hl can wrap around
vim.opt.whichwrap:append("<,>,[,],h,l")

-- bufexplorer customization
vim.g.bufExplorerDefaultHelp = 0
vim.g.bufExplorerShowRelativePath = 1
vim.g.bufExplorerFindActive = 1
vim.g.bufExplorerSortBy = 'name'
vim.api.nvim_set_keymap('n', '<leader>o', ':BufExplorer<CR>', { noremap = true, silent = true })

-- clear search with leader + enter
vim.api.nvim_set_keymap('n', '<leader><CR>', ':noh<CR>', { noremap = true, silent = true })

-- start autocomplete setup
local cmp = require'cmp'
cmp.setup({
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        end,
    },
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<Tab>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
      ['<S-Tab>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
    }, {
      { name = 'buffer' },
    })
})
  -- Use buffer source for `/` (searching)
cmp.setup.cmdline('/', {
    sources = {
        { name = 'buffer' }
    }
})

-- Use cmdline & path source for ':' (command prompts)
cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    })
})
-- end autocomplete setup

-- default disable and toggle git blame with gl
require('gitblame').setup {
    enabled = false,
}
vim.api.nvim_set_keymap('n', 'gl', ':GitBlameToggle<CR>', { noremap = true, silent = true })

-- Telescope preview lags with very big files
require("telescope").setup {
  defaults = {
    preview = {
        filesize_limit = 1, -- MB
    },
  }
}
-- Telescope key mappings
vim.api.nvim_set_keymap('n', '<leader>ff', "<cmd>lua require('telescope.builtin').find_files()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fg', "<cmd>lua require('telescope.builtin').live_grep()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fd', "<cmd>lua require('telescope.builtin').grep_string({ search = vim.fn.expand('<cword>') })<CR>", { noremap = true, silent = true })

-- Configure nvim-treesitter
require'nvim-treesitter.configs'.setup {
  -- Install languages synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- List of parsers to install
  ensure_installed = { "cpp", "python", "c", "rust", "cuda" },

  -- Install languages synchronously
  highlight = {
    enable = true,              -- false will disable the whole extension
    disable = {},               -- list of language that will be disabled
  },
}

vim.api.nvim_set_keymap('n', '<leader>nn', ':NERDTreeToggle<CR>', { noremap = true, silent = true })

-- Neovide specific config
if vim.g.neovide then
    vim.g.neovide_fullscreen = true
    vim.g.neovide_scroll_animation_length = 0.3
end

-- Setup language servers
local lspconfig = require("lspconfig")
local cmp_nvim_lsp = require("cmp_nvim_lsp")

local capabilities = cmp_nvim_lsp.default_capabilities()

-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
lspconfig.clangd.setup {
  capabilities = capabilities,
  cmd = {
    "/usr_src/firmware/bazel-firmware/external/tesla_clang/usr/bin/clangd",
    "--header-insertion=never",
  },
}

lspconfig.rust_analyzer.setup { capabilities = capabilities }
lspconfig.vala_ls.setup { capabilities = capabilities }
lspconfig.pylyzer.setup { capabilities = capabilities }

-- Key mapping for :ClangdSwitchSourceHeader
vim.keymap.set('n', 'gh', ':ClangdSwitchSourceHeader<CR>', { noremap = true, silent = true })
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { noremap = true, silent = true })
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { noremap = true, silent = true })
vim.keymap.set('n', 'gr', vim.lsp.buf.references, { noremap = true, silent = true })
vim.keymap.set('n', 'K', vim.lsp.buf.hover, { noremap = true, silent = true })
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { noremap = true, silent = true })
vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, { noremap = true, silent = true })

-- Paste with ctrl-shift-v
vim.api.nvim_set_keymap('i', '<C-S-v>', '<C-r>+', { noremap = true, silent = true })
