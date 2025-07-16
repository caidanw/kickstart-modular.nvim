---@module 'lazy'
---@type LazySpec
return {
  'folke/flash.nvim',
  event = 'VeryLazy',

  ---@type Flash.Config
  opts = {},

  init = function()
    local search = require('flash.plugins.search')

    -- Set up snacks toggle keymap for flash search
    require('snacks').toggle
      .new({
        name = 'Flash Search',
        -- stylua: ignore
        get = function() return search.enabled end,
        set = search.toggle,
      })
      :map('<leader>u/')
  end,

  -- stylua: ignore
  keys = {
    { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
    { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
    { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
  },
}
