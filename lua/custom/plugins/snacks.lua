-- Terminal Mappings
local function term_nav(dir)
  ---@param self snacks.terminal
  return function(self)
    return self:is_floating() and '<c-' .. dir .. '>' or vim.schedule(function()
      vim.cmd.wincmd(dir)
    end)
  end
end

-- Create some toggle mappings with Snacks
local function setup_snacks_toggles()
  Snacks.toggle.option('spell', { name = 'Spelling' }):map('<leader>us')
  Snacks.toggle.option('wrap', { name = 'Wrap' }):map('<leader>uw')
  Snacks.toggle.option('relativenumber', { name = 'Relative Number' }):map('<leader>uL')
  Snacks.toggle.option('conceallevel', { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map('<leader>uc')
  Snacks.toggle.option('background', { off = 'light', on = 'dark', name = 'Dark Background' }):map('<leader>ub')
  Snacks.toggle.option('foldcolumn', { off = '0', on = 'auto', name = 'Fold Column' }):map('<leader>uf')
  Snacks.toggle.animate():map('<leader>ua')
  Snacks.toggle.line_number():map('<leader>ul')
  Snacks.toggle.diagnostics():map('<leader>ud')
  Snacks.toggle.treesitter():map('<leader>uT')
  Snacks.toggle.inlay_hints():map('<leader>uh')
  Snacks.toggle.indent():map('<leader>ug')
  Snacks.toggle.dim():map('<leader>uD')
  Snacks.toggle.zen():map('<leader>uz')
  Snacks.toggle.zoom():map('<leader>uZ'):map('<leader>wm')
  Snacks.toggle.scroll():map('<leader>uS')
end

---@module 'lazy'
---@type LazySpec
return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  dependencies = {
    -- Useful for getting pretty icons, but requires a Nerd Font.
    { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
  },

  -- snacks.nvim is a plugin that contains a collection of QoL improvements.
  -- One of those plugins is called snacks-picker
  -- It is a fuzzy finder, inspired by Telescope, that comes with a lot of different
  -- things that it can fuzzy find! It's more than just a "file finder", it can search
  -- many different aspects of Neovim, your workspace, LSP, and more!
  --
  -- Two important keymaps to use while in a picker are:
  --  - Insert mode: <c-/>
  --  - Normal mode: ?
  --
  -- This opens a window that shows you all of the keymaps for the current
  -- Snacks picker. This is really useful to discover what snacks-picker can
  -- do as well as how to actually do it!

  -- [[ Configure Snacks ]]
  -- See `:help snacks-init`
  ---@module 'snacks'
  ---@type snacks.Config
  opts = {
    dashboard = {
      sections = {
        { section = 'header' },
        { section = 'keys', gap = 1, padding = 2 },
        { icon = ' ', title = 'Recent Files', section = 'recent_files', indent = 2, padding = 2 },
        { icon = ' ', title = 'Projects', section = 'projects', indent = 2, padding = 2 },
        { section = 'startup' },
      },
    },
    dim = {},
    explorer = {},
    gitbrowse = {},
    indent = {},
    lazygit = {},
    notifier = {},
    picker = {
      sources = {
        explorer = {
          auto_close = false,
          hidden = true,
          ignored = true,
        },
      },
    },
    quickfile = {},
    scratch = {},
    scroll = {},
    terminal = {
      win = {
        keys = {
          nav_h = { '<C-h>', term_nav('h'), desc = 'Go to Left Window', expr = true, mode = 't' },
          nav_j = { '<C-j>', term_nav('j'), desc = 'Go to Lower Window', expr = true, mode = 't' },
          nav_k = { '<C-k>', term_nav('k'), desc = 'Go to Upper Window', expr = true, mode = 't' },
          nav_l = { '<C-l>', term_nav('l'), desc = 'Go to Right Window', expr = true, mode = 't' },
        },
      },
    },
    words = {},
    zen = {
      toggles = {
        dim = true,
        git_signs = false,
        mini_diff_signs = false,
        diagnostics = true,
        inlay_hints = false,
      },
      ---@type snacks.win.Config
      win = {
        width = 0.6,
        min_width = 120,
        max_width = 200,
        backdrop = {
          bg = string.format('#%06x', vim.api.nvim_get_hl(0, { name = 'Normal' }).bg),
          transparent = false,
        },
      },
      zoom = {
        ---@type snacks.win.Config
        win = {
          max_width = 1000,
        },
      },
    },
  },

  init = function()
    vim.api.nvim_create_autocmd('User', {
      pattern = 'OilActionsPost',
      callback = function(event)
        if event.data.actions.type == 'move' then
          Snacks.rename.on_rename_file(event.data.actions.src_url, event.data.actions.dest_url)
        end
      end,
    })

    vim.api.nvim_create_autocmd('User', {
      pattern = 'VeryLazy',
      callback = function()
        -- Setup some globals for debugging (lazy-loaded)
        _G.dd = function(...)
          Snacks.debug.inspect(...)
        end
        _G.bt = function()
          Snacks.debug.backtrace()
        end
        vim.print = _G.dd -- Override print to use snacks for `:=` command

        -- Create some toggle mappings
        setup_snacks_toggles()

        -- Create toggle mapping for custom macro recording keymaps
        local MacroRecording = require('custom.macro_recording')
        MacroRecording.setup()
        Snacks.toggle
          .new({
            name = 'Macro Recording',
            get = MacroRecording.is_enabled,
            set = MacroRecording.set,
          })
          :map('<leader>uq')
      end,
    })
  end,

  -- stylua: ignore
  keys = {
    -- [[ Terminal ]]
    { '<c-/>', function() Snacks.terminal() end, desc = 'Toggle Terminal' },
    { '<C-/>', '<cmd>close<cr>', desc = 'Hide Terminal', mode = 't' },

    -- [[ Scratch ]]
    { '<leader>.',  function() Snacks.scratch() end, desc = 'Toggle Scratch Buffer' },
    { '<leader>bs', function() Snacks.scratch.select() end, desc = 'Select Scratch Buffer' },

    -- [[ Notifications ]]
    { '<leader>n', function() Snacks.notifier.show_history() end, desc = 'Notification History' },

    -- [[ Buffers ]]
    { '<leader>bd', function() Snacks.bufdelete() end, desc = 'Delete Buffer' },
    { '<leader>bo', function() Snacks.bufdelete.other() end, desc = 'Delete Other Buffers' },

    -- [[ Code ]]
    { '<leader>cR', function() Snacks.rename.rename_file() end, desc = 'Rename File' },
    { ']]',         function() Snacks.words.jump(vim.v.count1) end, desc = 'Next Reference', mode = { 'n', 't' } },
    { '[[',         function() Snacks.words.jump(-vim.v.count1) end, desc = 'Prev Reference', mode = { 'n', 't' } },

    -- [[ Git ]]
    { '<leader>gb', function() Snacks.git.blame_line({ count = 20, interactive = true }) end, desc = 'Git Blame Line' },
    { '<leader>gB', function() Snacks.gitbrowse() end, desc = 'Git Browse', mode = { 'n', 'v' } },
    { '<leader>gY', function() Snacks.gitbrowse({ open = function(url) vim.fn.setreg('+', url); Snacks.notify("Copied Git URL") end, notify = false }) end, desc = 'Git Browse (copy)' },
    { '<leader>gg', function() Snacks.lazygit() end, desc = 'LazyGit' },
    { '<leader>gl', function() Snacks.lazygit.log() end, desc = 'LazyGit Log' },
    { '<leader>gf', function() Snacks.lazygit.log_file() end, desc = 'LazyGit Log (Current File)' },

    --[[ Pickers ]]
    -- See `:help snacks-pickers-sources`
    -- top pickers & explorer
    { '<leader><leader>', function() Snacks.picker.buffers() end, desc = 'Find existing buffers' },
    { '<leader>/', function() Snacks.picker.lines() end, desc = 'Fuzzily search in current buffer' },
    { '<leader>:', function() Snacks.picker.command_history() end, desc = 'Command History' },
    { '<leader>e', function() Snacks.picker.explorer() end, desc = 'Snacks Explorer' },
    -- search
    { '<leader>s.', function() Snacks.picker.recent() end, desc = 'Recent Files ("." for repeat)' },
    { '<leader>sc', function() Snacks.picker.commands() end, desc = 'Commands' },
    { '<leader>sd', function() Snacks.picker.diagnostics() end, desc = 'Diagnostics' },
    { '<leader>sf', function() Snacks.picker.smart() end, desc = 'Files' },
    { '<leader>sg', function() Snacks.picker.grep() end, desc = 'Grep' },
    { '<leader>sh', function() Snacks.picker.help() end, desc = 'Help' },
    { '<leader>sk', function() Snacks.picker.keymaps() end, desc = 'Keymaps' },
    { '<leader>sn', function() Snacks.picker.files({ cwd = vim.fn.stdpath('config') }) end, desc = 'Neovim Files' },
    { '<leader>sr', function() Snacks.picker.resume() end, desc = 'Resume' },
    { '<leader>ss', function() Snacks.picker.pickers() end, desc = 'Snacks Pickers' },
    { '<leader>sw', function() Snacks.picker.grep_word() end, desc = 'Current Word', mode = { 'n', 'x' } },
    { '<leader>uC', function() Snacks.picker.colorschemes() end, desc = 'Colorscheme with Preview' },
    -- find
    { '<leader>fb', function() Snacks.picker.buffers() end, desc = 'Buffers' },
    { '<leader>ff', function() Snacks.picker.files() end, desc = 'Files' },
    { '<leader>fg', function() Snacks.picker.git_files() end, desc = 'Git Files' },
    { '<leader>fn', function() Snacks.picker.files({ cwd = vim.fn.stdpath('config') }) end, desc = 'Neovim Files' },
    { '<leader>fp', function() Snacks.picker.projects() end, desc = 'Projects' },
    { '<leader>fr', function() Snacks.picker.recent() end, desc = 'Recent' },

    --[[ Misc ]]
    {
      '<leader>N',
      desc = 'Neovim News',
      function()
        Snacks.win({
          file = vim.api.nvim_get_runtime_file('doc/news.txt', false)[1],
          width = 0.6,
          height = 0.6,
          wo = {
            spell = false,
            wrap = false,
            signcolumn = 'yes',
            statuscolumn = ' ',
            conceallevel = 3,
          },
        })
      end,
    },
  },
}
