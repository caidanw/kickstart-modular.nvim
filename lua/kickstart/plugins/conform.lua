---@module 'lazy'
---@type LazySpec
return {
  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>cf',
        function()
          require('conform').format({ async = true, lsp_format = 'fallback' })
        end,
        mode = '',
        desc = 'Format buffer',
      },
    },
    ---@module 'conform'
    ---@type conform.setupOpts
    opts = {
      notify_no_formatters = true,
      notify_on_error = true,
      format_on_save = function(bufnr)
        -- Disable autoformat on certain filetypes
        local ignore_filetypes = { 'c', 'cpp' }
        if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
          return
        end
        -- Disable with a global or buffer-local variable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end

        return {
          timeout_ms = 500,
          lsp_format = 'fallback',
        }
      end,
      formatters_by_ft = {
        lua = { 'stylua' },

        -- Conform can also run multiple formatters sequentially
        python = { 'ruff_fix', 'ruff_format', 'ruff_organize_imports' },

        -- You can use 'stop_after_first' to run the first available formatter from the list
        -- javascript = { 'prettierd', 'prettier', stop_after_first = true },

        javascript = { 'prettier' },
        javascriptreact = { 'prettier' },
        typescript = { 'prettier' },
        typescriptreact = { 'prettier' },
        json = { 'prettier' },
        html = { 'prettier' },
        css = { 'prettier' },
        scss = { 'prettier' },
      },
      formatters = {
        prettier = {
          options = {
            ft_parsers = {
              javascript = 'babel',
              javascriptreact = 'babel',
              typescript = 'typescript',
              typescriptreact = 'typescript',
              html = 'html',
              css = 'css',
              scss = 'scss',
              less = 'less',
              json = 'json',
              jsonc = 'jsonc',
              yaml = 'yaml',
              markdown = 'markdown',
              ['markdown.mdx'] = 'mdx',
              graphql = 'graphql',
            },
          },
        },
      },
    },
    init = function()
      -- If you want the formatexpr, here is the place to set it
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
