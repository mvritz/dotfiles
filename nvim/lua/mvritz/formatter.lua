local M = {}

M.__augroup = vim.api.nvim_create_augroup('Format', {})

M.mason_dependencies = { 'stylua', 'prettierd' }

M.setup = function()
  require('formatter').setup({
    logging = true,
    log_level = vim.log.levels.WARN,
    filetype = {
      lua = {
        require('formatter.filetypes.lua').stylua,
      },
      typescriptreact = {
        require('formatter.filetypes.typescriptreact').prettierd,
      },
      typescript = {
        require('formatter.filetypes.typescript').prettierd,
      },
    },
  })
end

M.on_attach = function(bufnr)
  vim.api.nvim_clear_autocmds({ group = M.__augroup, buffer = bufnr })
  vim.api.nvim_create_autocmd('BufWritePost', {
    group = M.__augroup,
    buffer = bufnr,
    callback = U.make_cmd('FormatWriteLock'),
  })
end

return M
