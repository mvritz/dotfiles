local M = {}

M.setup = function()
  require("barbar").setup({
    dependencies = {
        'lewis6991/gitsigns.nvim',
        'nvim-tree/nvim-web-devicons',
    },
    init = function()
      vim.g.barbar_auto_setup = false
    end,
    opts = {
      animation = true,
    },
    version = '^1.0.0',
  })
end

return M
