-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

-- Ensure that the binary spl file is up-to-date with the source add file
-- Source: https://www.lorenzobettini.it/2025/01/automatically-regenerating-neovim-spell-files/
vim.api.nvim_create_autocmd('FocusGained', {
  pattern = '*',
  callback = function()
    local config_path = vim.fn.stdpath('config') -- Get Neovim's config path
    local add_file = config_path .. '/spell/en.utf-8.add'
    local spl_file = config_path .. '/spell/en.utf-8.add.spl'

    if vim.fn.filereadable(add_file) == 1 then
      local add_mtime = vim.fn.getftime(add_file) -- Get modification time of .add file
      local spl_mtime = vim.fn.getftime(spl_file) -- Get modification time of .add.spl file

      -- Run mkspell! only if .add is newer than .add.spl or .add.spl doesn't exist
      if add_mtime > spl_mtime or spl_mtime == -1 then vim.cmd('silent! mkspell! ' .. spl_file .. ' ' .. add_file) end
    end
  end,
})

-- Create an autocommand to disable LSP diagnostics for .env and *.env.* files
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  group = vim.api.nvim_create_augroup('DisableLspDiagnosticsForEnv', { clear = true }),
  pattern = { '.env', '.env.*' },
  callback = function(args) vim.diagnostic.enable(false, { bufnr = args.buf }) end,
})

-- vim: ts=2 sts=2 sw=2 et
