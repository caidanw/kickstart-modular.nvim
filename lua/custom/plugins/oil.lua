---@module 'lazy'
---@type LazySpec
return {
  'stevearc/oil.nvim',
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {
    -- Oil will take over directory buffers (e.g. `nvim .` or `:e src/`)
    -- Set to false if you want some other plugin (e.g. netrw) to open when you edit directories.
    default_file_explorer = true,
    -- Send deleted files to the trash instead of permanently deleting them (:help oil-trash)
    delete_to_trash = true,
    -- Set to true to watch the filesystem for changes and reload oil
    watch_for_changes = true,

    keymaps = {
      ['q'] = { 'actions.close', mode = 'n' },
      ['<M-h>'] = { 'actions.toggle_hidden', mode = 'n' },
      ['Y'] = { 'actions.yank_entry', mode = 'n' },
      ['gd'] = {
        function()
          vim.g.oil_columns = not vim.g.oil_columns
          local columns = vim.g.oil_columns and { 'icon', 'permissions', 'size', 'mtime' } or { 'icon' }
          require('oil').set_columns(columns)
        end,
        desc = 'Toggle columns',
      },
    },
  },
  -- Optional dependencies
  -- dependencies = { { 'echasnovski/mini.icons', opts = {} } },
  dependencies = { 'nvim-tree/nvim-web-devicons' }, -- use if you prefer nvim-web-devicons
  -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
  lazy = false,
  keys = {
    { '<leader>e', '<CMD>Oil<CR>', mode = 'n', desc = 'Open Oil' },
  },
}
