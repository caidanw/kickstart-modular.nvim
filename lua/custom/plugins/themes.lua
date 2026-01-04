---@module 'lazy'
---@type LazySpec
return {
  {
    'AlexvZyl/nordic.nvim',
    lazy = false,
    priority = 1000,
    opts = {
      bold_keywords = false,
      bright_border = false,
      cursorline = {
        -- theme = 'light',
        -- blend = 1.5,
      },
      telescope = {
        style = 'classic',
      },
      after_palette = function(palette)
        -- Fix the border colors from being too dark
        palette.border_fg = palette.grey5
        palette.fg_float_border = palette.grey5
        palette.fg_popup_border = palette.grey5
      end,
      on_highlight = function(highlights, palette)
        -- Fix word highlighting under cursor (LSP references) with yellow underline
        local yellow = palette.yellow.base
        highlights.LspReferenceText = { underline = true, sp = yellow }
        highlights.LspReferenceRead = { underline = true, sp = yellow }
        highlights.LspReferenceWrite = { underline = true, sp = yellow }
      end,
    },
    config = function(_, opts)
      require('nordic').load(opts)
    end,
  },
  {
    'neanias/everforest-nvim',
    version = false,
  },
  { 'rmehri01/onenord.nvim' },
}
