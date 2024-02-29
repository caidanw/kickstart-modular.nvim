return {
  {
    'AlexvZyl/nordic.nvim',
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      -- Load the colorscheme here
      vim.cmd.colorscheme 'nordic'
    end,
  },

  'olimorris/onedarkpro.nvim',
}
-- vim: ts=2 sts=2 sw=2 et
