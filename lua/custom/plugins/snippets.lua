return {
  {
    'L3MON4D3/LuaSnip',
    dependencies = { 'rafamadriz/friendly-snippets' },
    init = function()
      require('luasnip.loaders.from_vscode').lazy_load()
    end,
  },
}
