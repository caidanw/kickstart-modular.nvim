-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

local function augroup(name)
  return vim.api.nvim_create_augroup('caidan_' .. name, { clear = true })
end

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = augroup('highlight-yank'),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
  group = augroup('checktime'),
  callback = function()
    if vim.o.buftype ~= 'nofile' then
      vim.cmd('checktime')
    end
  end,
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
      if add_mtime > spl_mtime or spl_mtime == -1 then
        vim.cmd('silent! mkspell! ' .. spl_file .. ' ' .. add_file)
      end
    end
  end,
})

-- Create an autocommand to disable LSP diagnostics for .env and *.env.* files
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  group = vim.api.nvim_create_augroup('DisableLspDiagnosticsForEnv', { clear = true }),
  pattern = { '.env', '.env.*' },
  callback = function(args)
    vim.diagnostic.enable(false, { bufnr = args.buf })
  end,
})

-- vim: ts=2 sts=2 sw=2 et
