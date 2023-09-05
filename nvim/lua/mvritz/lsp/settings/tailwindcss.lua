return {
  tailwindCSS = {
    experimental = {
      classRegex = {
        {
          'cva\\(([^)]*)\\)',
          '["\'`]([^"\'`]*).*?["\'`]',
          ':class\\s*=>\\s*"([^"]*)',
          'class:\\s+"([^"]*)',
          'className:\\s+"([^"]*)',
        },
      },
    },
  },
}
