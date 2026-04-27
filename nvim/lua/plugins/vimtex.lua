return {
    "lervag/vimtex",
    lazy = false, -- lazy-loading will disable inverse search
    config = function()
        vim.api.nvim_create_autocmd({ "FileType" }, {
            group = vim.api.nvim_create_augroup("lazyvim_vimtex_conceal", { clear = true }),
            pattern = { "bib", "tex" },
            callback = function()
                vim.wo.conceallevel = 2
            end,
        })

        vim.g.vimtex_mappings_disable = { ["n"] = { "K" } } -- disable `K` as it conflicts with LSP hover
        vim.g.vimtex_quickfix_method = vim.fn.executable("pplatex") == 1 and "pplatex" or "latexlog"
        vim.keymap.set('n','<leader>ll','<Cmd>VimtexCompile<CR>', {silent=true})
        vim.keymap.set('n','<leader>lv','<Cmd>VimtexView<CR>', {silent=true})
    end,
}
