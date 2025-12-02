return {
  'NickvanDyke/opencode.nvim',
  dependencies = {
    -- Recommended for better prompt input, and required to use `opencode.nvim`'s embedded terminal — otherwise optional
    {
      'folke/snacks.nvim',
      opts = {
        input = { enabled = true },
        picker = { enabled = true },
        terminal = { enabled = true },
      },
    },
  },
  config = function()
    ---@type opencode.Opts
    vim.g.opencode_opts = {
      prompts = {
        fix = {
          description = 'Fix all diagnostics',
          prompt = 'Fix these @diagnostics',
        },
        fix_one = {
          description = 'Fix this diagnostic',
          prompt = 'Fix @this diagnostic',
        },
      },
    }

    -- Required for opts.events.reload
    vim.o.autoread = true

    -- stylua: ignore start
    vim.keymap.set('n', '<leader>oo', function() require('opencode').toggle() end, { desc = 'Toggle opencode' })
    vim.keymap.set('n', '<leader>oA', function() require('opencode').ask() end, { desc = 'Ask opencode' })
    vim.keymap.set('n', '<leader>oa', function() require('opencode').ask('@this: ') end, { desc = 'Ask opencode about this' })
    vim.keymap.set('v', '<leader>oa', function() require('opencode').ask('@this: ') end, { desc = 'Ask opencode about selection' })
    vim.keymap.set('n', '<leader>on', function() require('opencode').command('session.new') end, { desc = 'New opencode session' })
    vim.keymap.set('n', '<leader>os', function() require('opencode').command('session.share') end, { desc = 'Share opencode session' })
    vim.keymap.set('n', '<S-C-u>',    function() require('opencode').command('session.half.page.up') end, { desc = 'Messages half page up' })
    vim.keymap.set('n', '<S-C-d>',    function() require('opencode').command('session.half.page.down') end, { desc = 'Messages half page down' })
    vim.keymap.set({ 'n', 'v' }, '<leader>op', function() require('opencode').select() end, { desc = 'Select opencode prompt' })

    -- Example: keymap for custom prompt
    vim.keymap.set('n', '<leader>oe', function() require('opencode').prompt('Explain @this and its context') end, { desc = 'Explain this code' })
    -- stylua: ignore end
  end,
}
