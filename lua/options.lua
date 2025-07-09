-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

vim.o.number = true -- Show line numbers by default
vim.o.relativenumber = true -- Enable relative line numbers, for help with jumping.
vim.o.cursorline = true -- Show which line your cursor is on
vim.o.scrolloff = 7 -- Minimal number of screen lines to keep above and below the cursor.
vim.o.wrap = true -- Line wrap

vim.o.expandtab = false -- Use tabs instead of spaces
vim.o.shiftwidth = 4 -- Size of an indent
vim.o.tabstop = 4 -- Number of spaces tabs count for
vim.o.smarttab = true -- Use shiftwidths at left margin, tabstops everywhere else
vim.o.shiftround = true -- Round indent to multiple of shiftwidth

vim.o.mouse = 'a' -- Enable mouse mode, can be useful for resizing splits for example!
vim.o.showmode = false -- Don't show the mode, since it's already in the status line

vim.o.breakindent = true -- Enable break indent
vim.o.undofile = true -- Save undo history

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.inccommand = 'split' -- Preview substitutions live, as you type!
vim.o.signcolumn = 'yes' -- Keep signcolumn on by default

vim.o.updatetime = 250 -- Decrease update time
vim.o.timeoutlen = 300 -- Decrease mapped sequence wait time

-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
--
--  Notice listchars is set using `vim.opt` instead of `vim.o`.
--  It is very similar to `vim.o` but offers an interface for conveniently interacting with tables.
--   See `:help lua-options`
--   and `:help lua-options-guide`
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.o.confirm = true

--[[ Custom global options ]]

-- Disable macro recording
vim.g.macro_recording = false
