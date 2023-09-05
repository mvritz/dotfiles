local M = {}

M.setup = function()
  local lsp_config = require('lspconfig')
  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  local icons = require('mvritz.icons')

  local signs = {
    {
      name = 'DiagnosticSignError',
      text = icons.diagnostics.error,
    },
    {
      name = 'DiagnosticSignWarn',
      text = icons.diagnostics.warning,
    },
    {
      name = 'DiagnosticSignHint',
      text = icons.diagnostics.hint,
    },
    {
      name = 'DiagnosticSignInfo',
      text = icons.diagnostics.info,
    },
  }

  ---@diagnostic disable-next-line: unused-local
  local function on_attach(client, bufnr)
    require('mvritz.formatter').on_attach(bufnr)

    for _, sign in ipairs(signs) do
      vim.fn.sign_define(
        sign.name,
        { texthl = sign.name, text = sign.text, numhl = '' }
      )
    end

    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    require('mvritz.keymaps').lsp(bufnr)
  end

  local servers = {
    { name = 'lua_ls', settings = require('mvritz.lsp.settings.lua_ls') },
    { name = 'eslint' },
    { name = 'jsonls', settings = require('mvritz.lsp.settings.jsonls') },
    { name = 'rust_analyzer' },
    { name = 'astro' },
    {
      name = 'tailwindcss',
      settings = require('mvritz.lsp.settings.tailwindcss'),
    },
    { name = 'prismals' },
    { name = 'jedi_language_server' },
    { name = 'terraformls' },
    { name = 'cssls' },
    { name = 'stylelint_lsp' },
  }

  for _, server in ipairs(servers) do
    lsp_config[server.name].setup({
      on_attach = on_attach,
      capabilities = capabilities,
      settings = server.settings,
    })
  end

  require('typescript').setup({
    go_to_source_definition = {
      fallback = true,
    },
    server = {
      on_attach = on_attach,
      capabilities = capabilities,
    },
  })
end

return M
