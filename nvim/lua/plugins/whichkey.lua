return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 300
    end,
    opts = {
        ignore_missing = true,
    },
    config = function()
        local wk = require("which-key")
        wk.register({
            ["<leader>"] = {
                p = {
                    name = "+file",
                    f = { "Find File" },
                    w = { "Find Word" },
                    o = { "Old Files" },
                },
                l = {
                    name = "+latex",
                    l = { "Start/Stop Compilation" },
                    v = { "View PDF" },
                },
                g = {
                    name = "+git",
                    l = { "Open LazyGit" },
                    c = { "List commits with diff" },
                    b = { "List all branches with log preview" },
                    s = { "List current changes" },
                },
                f = {
                    name = "+filebrowser",
                    b = { "Open Filebrowser" },
                },
                d = {
                    name = "+debugger",
                    c = { "Continue" },
                    o = { "Toggle debugger" },
                    b = { "Toggle breakpoint" },
                }
            },
            ["<leader>w"] = { "<cmd>w<cr>", "Write File" },
            ["<leader>q"] = { "<cmd>q<cr>", "Quit Session" },
        })
    end
}
