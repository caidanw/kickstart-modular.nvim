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
        local U = require('nordic.utils')

        -- Fix the border colors from being too dark
        palette.border_fg = palette.grey5
        palette.fg_float_border = palette.grey5
        palette.fg_popup_border = palette.grey5

        -- Subtle yellow-tinted background for LSP references
        palette.lsp_reference_bg = U.blend(palette.yellow.base, palette.gray0, 0.8)
      end,
      on_highlight = function(highlights, palette)
        -- Fix word highlighting under cursor (LSP references)
        highlights.LspReferenceText = { underline = true, sp = palette.lsp_reference_bg }
        highlights.LspReferenceRead = { underline = true, sp = palette.lsp_reference_bg }
        highlights.LspReferenceWrite = { underline = true, sp = palette.lsp_reference_bg }

        -- Lighter cursorline for lazygit
        highlights.LazyGitSelectedLine = { bg = palette.gray3 }
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
