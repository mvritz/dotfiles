vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.cmd([[
  autocmd BufWritePre *.hs Neoformat
]])

require('mvritz.bootstrap')
require('mvritz.util')
require('mvritz.options')
require('mvritz.keymaps').setup()

require('lazy').setup('mvritz.plugins', {
  defaults = {
    lazy = true,
  },
})
