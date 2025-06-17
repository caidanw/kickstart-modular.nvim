-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

-- Source current file and execute lua code
vim.keymap.set('n', '<leader>cx', '<cmd>source %<CR>', { desc = 'Source current file' })
vim.keymap.set('n', '<leader>cX', '<cmd>.lua<CR>', { desc = 'Execute current line as Lua' })
vim.keymap.set('v', '<leader>cx', '<cmd>lua<CR>', { desc = 'Execute selection as Lua' })

vim.keymap.set('n', '<leader>l', '<cmd>Lazy<CR>', { desc = 'Open Lazy' })

-- Disable repeating last recorded register n times
vim.keymap.set('n', 'Q', '<NOP>')

-- Disable `q` for macro recording as default
-- Set initial state for 'q'
vim.g.q_record_macro = false

-- Function to toggle 'q' functionality
local function toggle_q_macro()
  if vim.g.q_record_macro then
    -- If currently set for recording macros, make 'q' do nothing
    vim.keymap.set('n', 'q', '<NOP>', { noremap = true })
    vim.g.q_record_macro = false
    -- LazyVim.warn('Disabled Macro Recording', { title = 'Option' })
  else
    -- If currently set to do nothing, make 'q' record macros
    vim.keymap.set('n', 'q', 'q', { noremap = true })
    vim.g.q_record_macro = true
    -- LazyVim.info('Enabled Macro Recording', { title = 'Option' })
  end
end

vim.keymap.set('n', '<leader>tq', toggle_q_macro, { noremap = true, silent = true, desc = '[T]oggle Macro Recording' })
vim.keymap.set('n', 'q', '<NOP>', { noremap = true })

-- vim: ts=2 sts=2 sw=2 et
