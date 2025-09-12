---Docs: https://github.com/neovim/nvim-lspconfig/blob/master/lsp/basedpyright.lua
---@type vim.lsp.Config
return {
  settings = {
    basedpyright = {
      analysis = {
        typeCheckingMode = 'basic',
      },
    },
  },
}
