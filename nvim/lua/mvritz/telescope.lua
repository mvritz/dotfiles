local M = {}

M.setup = function()
  local telescope = require('telescope')

  telescope.setup({})

  require('mvritz.keymaps').telescope()
end

return M
