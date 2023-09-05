local M = {}

M.setup = function()
  require('filetype').setup({
    overrides = {
      extensions = {
        mdx = 'markdown',
        -- json = 'jsonc',
        tf = 'terraform',
      },
      literal = {
        ['.gitignore'] = 'gitignore',
        ['.prettierignore'] = 'gitignore',
        ['.prettierrc'] = 'jsonc',
        ['.eslintrc'] = 'jsonc',
        ['.env'] = 'sh',
        ['.env.development'] = 'sh',
        ['.env.production'] = 'sh',
        ['.env.local'] = 'sh',
      },
    },
  })
end

return M
