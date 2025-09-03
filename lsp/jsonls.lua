---Docs: https://github.com/neovim/nvim-lspconfig/blob/master/lsp/jsonls.lua
---@type vim.lsp.Config
return {
  settings = {
    json = {
      schemas = require('schemastore').json.schemas(),
      validate = { enable = true },
      format = { enable = true },
    },
  },
}
