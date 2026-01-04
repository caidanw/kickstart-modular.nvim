---Docs: https://github.com/neovim/nvim-lspconfig/blob/master/lsp/astro.lua

-- Find the TypeScript SDK path
-- First check for project-local typescript, then fall back to mason's version
local function get_typescript_server_path()
  local local_ts = vim.fn.getcwd() .. '/node_modules/typescript/lib'
  if vim.fn.isdirectory(local_ts) == 1 then
    return local_ts
  end
  -- Fall back to mason's astro-language-server bundled typescript
  return vim.fs.normalize('~/.local/share/nvim/mason/packages/astro-language-server/node_modules/typescript/lib')
end

---@type vim.lsp.Config
return {
  init_options = {
    typescript = {
      tsdk = get_typescript_server_path(),
    },
  },
}
