local function is_autoformat_enabled(bufnr)
  if vim.b[bufnr].autoformat ~= nil then
    return vim.b[bufnr].autoformat
  end
  return vim.g.autoformat
end

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

        if not is_autoformat_enabled(bufnr) then
          return
        end

        return {
          timeout_ms = 2000,
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

      vim.g.autoformat = true

      -- Commands to toggle autoformatting
      vim.api.nvim_create_user_command('FormatDisable', function(args)
        if args.bang then -- FormatDisable! will disable formatting just for this buffer
          vim.b.autoformat = false
        else
          vim.g.autoformat = false
        end
      end, { desc = 'Disable autoformat on save', bang = true })

      vim.api.nvim_create_user_command('FormatEnable', function()
        vim.b.autoformat = true
        vim.g.autoformat = true
      end, { desc = 'Enable autoformat on save' })
    end,
  },
}
