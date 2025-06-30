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
        theme = 'light',
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
    },
    config = function(_, opts)
      require('nordic').load(opts)
    end,
  },
  {
    'neanias/everforest-nvim',
    version = false,
  },
}
