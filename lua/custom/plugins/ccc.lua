---@module 'lazy'
---@type LazySpec
return {
  'uga-rosa/ccc.nvim',
  event = 'BufReadPre',
  opts = {
    highlighter = {
      auto_enable = true,
      lsp = true,
    },
  },
}
