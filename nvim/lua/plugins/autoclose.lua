return {
    'm4xshen/autoclose.nvim',
    config = function()
        require("autoclose").setup({
            keys = {
                ["\'"] = { close = false, escape = true },
            },
        })
    end
}
