local M = {}

M.setup = function()
  require('tokyonight').setup({
    style = 'storm',
    transparent = true,
    terminal_colors = true,
    styles = {
      comments = { italic = true },
      keywords = { italic = true },
      functions = {},
      variables = {},
      sidebars = 'dark',
      floats = 'dark',
    },
  })
  U.cmd('colorscheme tokyonight-moon')
end

return M
