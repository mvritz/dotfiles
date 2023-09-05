local M = {}

M.setup = function()
  require('FTerm').setup({
    border = 'single',
  })

  require('mvritz.keymaps').terminal()
end

return M
