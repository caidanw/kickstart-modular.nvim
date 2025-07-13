---@module 'lazy'
---@type LazySpec
return {
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
    ft = { 'markdown', 'codecompanion' },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
    init = function()
      -- Set up snacks toggle keymap for rendering markdown
      require('snacks').toggle
        .new({
          name = 'Markdown Render',
          get = require('render-markdown').get,
          set = require('render-markdown').set,
        })
        :map('<leader>um')
    end,
  },
}
