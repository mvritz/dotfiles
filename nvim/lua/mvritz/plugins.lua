local M = {
  'folke/lazy.nvim',
  'nvim-lua/plenary.nvim',
  {
    'folke/tokyonight.nvim',
    name = 'tokyonight',
    lazy = false,
    priority = 1000,
    config = require('mvritz.colorscheme').setup,
  },
  {
    'nvim-tree/nvim-tree.lua',
    lazy = false,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = require('mvritz.nvim_tree').setup,
  },
  {
    'hrsh7th/nvim-cmp',
    config = require('mvritz.cmp').setup,
    event = 'BufEnter',
    dependencies = {
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-cmdline',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'onsails/lspkind.nvim',
    },
  },
  { 'williamboman/mason.nvim', config = true, cmd = 'Mason' },
  { 'williamboman/mason-lspconfig.nvim', config = true, event = 'BufEnter' },
  {
    'neovim/nvim-lspconfig',
    event = 'BufEnter',
    config = require('mvritz.lsp').setup,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    build = 'TSUpdate',
    config = require('mvritz.treesitter').setup,
    event = 'BufEnter',
  },
  { 'JoosepAlviste/nvim-ts-context-commentstring', event = 'BufEnter' },
  {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    config = require('mvritz.telescope').setup,
    keys = '<leader>t',
  },
  {
    'mhartington/formatter.nvim',
    event = 'BufEnter',
    config = require('mvritz.formatter').setup,
  },
  {
    'numToStr/FTerm.nvim',
    keys = '<c-\\>',
    config = require('mvritz.terminal').setup,
  },
  {
    'windwp/nvim-autopairs',
    event = 'BufEnter',
    config = true,
  },
  {
    'lewis6991/gitsigns.nvim',
    event = 'BufEnter',
    config = true,
  },
  {
    'numToStr/Comment.nvim',
    config = require('mvritz.comment').setup,
    event = 'BufEnter',
  },
  'b0o/SchemaStore.nvim',
  {
    'folke/trouble.nvim',
    event = 'BufEnter',
  },
  {
    'jose-elias-alvarez/typescript.nvim',
    event = 'BufEnter',
  },
  {
    'zbirenbaum/copilot.lua',
    event = 'BufEnter',
    config = require('mvritz.copilot').setup,
  },
  {
    'nathom/filetype.nvim',
    lazy = false,
    config = require('mvritz.filetype').setup,
  },
  {
    'karb94/neoscroll.nvim',
    lazy = false,
    config = require('mvritz.neoscroll').setup,
  },
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    opts = {},
  },
  {
    'mihaimaruseac/hindent',
    lazy = false,
  },
  {
    'sbdchd/neoformat',
    lazy = false,
  },
  {
    'sudoerwx/vim-ray-so-beautiful',
    lazy = false,
  },
  {
    'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
    lazy = false,
    config = function()
      require('lsp_lines').setup()
    end,
  },
  {
    'mrcjkb/haskell-tools.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
    },
    branch = '1.x.x',
    lazy = false,
  },
  {
    'neovimhaskell/haskell-vim',
    lazy = false,
  },
  {
    'ray-x/lsp_signature.nvim',
    event = 'VeryLazy',
    opts = {},
    config = function(_, opts)
      require('lsp_signature').setup(opts)
    end,
  },
  {
    'nvim-telescope/telescope-media-files.nvim',
    lazy = false,
    dependencies = {
      'nvim-lua/popup.nvim',
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
    },
    config = function()
      require('telescope').load_extension('media_files')
    end,
  },
  {
    'itspriddle/vim-shellcheck',
    lazy = false,
  },
  {
    'neoclide/coc.nvim',
    branch = 'master',
    lazy = false,
    build = 'yarn install --frozen-lockfile',
  },
  {
    'mattn/emmet-vim',
    lazy = false,
  },
  {
    'alvan/vim-closetag',
    lazy = false,
  },
  {
    'AndrewRadev/tagalong.vim',
    lazy = false,
  },
}

return M
