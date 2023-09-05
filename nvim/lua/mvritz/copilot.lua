local M = {}

M.setup = function()
  vim.g.copilot_no_tab_map = true
  vim.api.nvim_set_keymap(
    'i',
    '<C-J>',
    'copilot#Accept("<CR>")',
    { silent = true, expr = true }
  )

  require('copilot').setup({
    suggestion = {
      auto_trigger = true,
    },
  })
end

return M
