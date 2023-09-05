local M = {}

M.setup = function()
  local cmp = require('cmp')
  local luasnip = require('luasnip')
  local lspkind = require('lspkind')

  lspkind.init({
    mode = 'text_symbol',
    preset = 'codicons',
  })

  cmp.setup({
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    mapping = cmp.mapping.preset.insert({
      ['<c-j>'] = cmp.mapping.select_next_item(),
      ['<c-k>'] = cmp.mapping.select_prev_item(),
      ['<c-b>'] = cmp.mapping.scroll_docs(-4),
      ['<c-f>'] = cmp.mapping.scroll_docs(4),
      ['<c-space>'] = cmp.mapping.complete(),
      ['<c-e>'] = cmp.mapping.abort(),
      ['<c-i>'] = cmp.mapping.confirm({ select = true }),
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp', priority = 10 },
      { name = 'nvim_lua', priority = 9 },
      { name = 'luasnip', priority = 8 },
    }, {
      { name = 'buffer', priority = 1 },
    }),
    experimental = { ghost_text = true },
    window = {
      completion = {
        col_offset = -1,
        side_padding = 0,
      },
    },
    formatting = {
      format = lspkind.cmp_format({
        mode = 'symbol',
        maxwidth = 50,
        ellipsis_char = '...',
        menu = {
          buffer = '[BUF]',
          nvim_lsp = '[LSP]',
          luasnip = '[SNP]',
          nvim_lua = '[VIM]',
        },
      }),
      fields = { 'kind', 'abbr', 'menu' },
    },
  })
end

return M
