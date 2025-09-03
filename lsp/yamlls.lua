---Docs: https://github.com/neovim/nvim-lspconfig/blob/master/lsp/yamlls.lua
---@type vim.lsp.Config
return {
  settings = {
    yaml = {
      schemas = require('schemastore').yaml.schemas(),
      schemaStore = {
        -- You must disable built-in schemaStore support if you want to use
        -- this plugin and its advanced options like `ignore`.
        enable = false,
        -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
        url = '',
      },
    },
  },
}
