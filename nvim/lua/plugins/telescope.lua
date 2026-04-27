return {
    {
        'nvim-telescope/telescope.nvim',
        dependencies = { { 'nvim-lua/plenary.nvim' } },
        init = function()
            require('telescope').setup {
                defaults = {
                    -- ...
                },
                pickers = {
                    find_files = {
                        theme = "ivy",
                    }
                },
                extensions = {
                    -- ...
                }
            }
        end,
        config = function()
            local builtin = require('telescope.builtin')
            -- Files
            vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
            vim.keymap.set('n', '<leader>pw', builtin.live_grep, {})
            vim.keymap.set('n', '<leader>po', builtin.oldfiles, {})

            -- Git
            vim.keymap.set('n', '<leader>gc', builtin.git_commits, {})
            vim.keymap.set('n', '<leader>gb', builtin.git_branches, {})
            vim.keymap.set('n', '<leader>gs', builtin.git_status, {})
        end
    },
    {
        "nvim-telescope/telescope-file-browser.nvim",
        dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
        config = function()
            require('telescope').setup {
                extensions = {
                    file_browser = {
                        hidden = { file_browser = true },
                    }
                }
            }
            vim.keymap.set('n', '<leader>fb', "<CMD>:Telescope file_browser path=%:p:h select_buffer=true<CR>", {})
        end
    }
}
