return {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
        "nvim-tree/nvim-web-devicons"
    },
    config = function()
        -- disable netrw at the very start of your init.lua
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1

        -- set termguicolors to enable highlight groups
        vim.opt.termguicolors = true

        -- empty setup using defaults
        require("nvim-tree").setup()

        -- OR setup with some options
        require("nvim-tree").setup({
            sort_by = "case_sensitive",
            view = {
                width = 30,
            },
            renderer = {
                group_empty = true,
            },
            filters = {
                dotfiles = false,
            },
            git = {
                ignore = false,
            }
        })

        vim.keymap.set('n','<leader>e','<Cmd>NvimTreeToggle<CR>', {silent=true})
        vim.keymap.set('n','<leader>o','<Cmd>NvimTreeFocus<CR>', {silent=true})
    end
} 
