return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "rcarriga/nvim-dap-ui",
        "theHamsta/nvim-dap-virtual-text",
        "mfussenegger/nvim-dap-python",
        "nvim-neotest/nvim-nio",
    },
    config = function()
        local dap = require("dap")
        local dapui = require("dapui")
        dapui.setup()
        dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open()
        end
        dap.listeners.after.event_terminated["dapui_config"] = function()
            dapui.close()
        end
        dap.listeners.after.event_exited["dapui_config"] = function()
            dapui.close()
        end
        vim.keymap.set("n", "<leader>db", "<CMD>DapToggleBreakpoint<CR>", { noremap = true })
        vim.keymap.set("n", "<leader>dc", "<CMD>DapContinue<CR>", { noremap = true })
        vim.keymap.set("n", "<leader>do", function()
            require("dapui").toggle()
        end, { noremap = true })
        local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
        require("dap-python").setup(path)
    end
}
