return {
    {
        "xiyaowong/transparent.nvim",
        config = function()
            vim.cmd([[TransparentEnable]])
        end
    },
    {
        "norcalli/nvim-colorizer.lua",
        init = function ()
            require("colorizer").setup()
            vim.cmd([[ColorizerReloadAllBuffers]])
        end,
    }
}
