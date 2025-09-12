---Docs: https://github.com/neovim/nvim-lspconfig/blob/master/lsp/lua_ls.lua
---@type vim.lsp.Config
return {
  settings = {
    Lua = {
      completion = {
        callSnippet = 'Replace',
      },
      runtime = {
        version = 'LuaJIT',
        -- Tell the language server how to find Lua modules same way as Neovim
        -- (see `:h lua-module-load`)
        path = {
          'lua/?.lua',
          'lua/?/init.lua',
        },
      },
      -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
      -- diagnostics = { disable = { 'missing-fields' } },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_list_runtime_paths(),
        checkThirdParty = false,
      },
      -- Enable hover documentation
      hover = { enable = true },
      signature = { enable = true },
    },
  },
}
