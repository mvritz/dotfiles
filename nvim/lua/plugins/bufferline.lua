return {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
        require("bufferline").setup {
            options = {
                indicator = {
                    icon = '▎',
                    style = 'underline'
                }
            }
        }
    end,

    vim.keymap.set('n', '<C-Tab>', '<Cmd>BufferLineCycleNext<CR>', { silent = true }),
    vim.keymap.set('n', '<C-S-Tab>', '<Cmd>BufferLineCyclePrev<CR>', { silent = true }),
    vim.keymap.set('n', '<C-W>', '<Cmd>bw<CR>', { silent = true })
}
