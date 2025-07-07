-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

local function augroup(name)
  return vim.api.nvim_create_augroup('caidan:' .. name, { clear = true })
end

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = augroup('highlight_yank'),
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

-- resize splits if window got resized
vim.api.nvim_create_autocmd('VimResized', {
  group = augroup('resize_splits'),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd('tabdo wincmd =')
    vim.cmd('tabnext ' .. current_tab)
  end,
})

-- Ensure that the binary spl file is up-to-date with the source add file
-- Source: https://www.lorenzobettini.it/2025/01/automatically-regenerating-neovim-spell-files/
vim.api.nvim_create_autocmd('FocusGained', {
  group = augroup('spell_file_update'),
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
  group = augroup('disable_lsp_diagnostics_for_env'),
  pattern = { '.env', '.env.*' },
  callback = function(args)
    vim.diagnostic.enable(false, { bufnr = args.buf })
  end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd('FileType', {
  group = augroup('close_with_q'),
  pattern = {
    'PlenaryTestPopup',
    'checkhealth',
    'dbout',
    'gitsigns-blame',
    'grug-far',
    'help',
    'lspinfo',
    'neotest-output',
    'neotest-output-panel',
    'neotest-summary',
    'notify',
    'qf',
    'spectre_panel',
    'startuptime',
    'tsplayground',
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.schedule(function()
      vim.keymap.set('n', 'q', function()
        vim.cmd('close')
        pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
      end, {
        buffer = event.buf,
        silent = true,
        desc = 'Quit buffer',
      })
    end)
  end,
})

-- make it easier to close man-files when opened inline
vim.api.nvim_create_autocmd('FileType', {
  group = augroup('man_unlisted'),
  pattern = { 'man' },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
  end,
})

-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd('FileType', {
  group = augroup('wrap_spell'),
  pattern = { 'text', 'plaintex', 'typst', 'gitcommit', 'markdown' },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- Fix conceallevel for json files
vim.api.nvim_create_autocmd({ 'FileType' }, {
  group = augroup('json_conceal'),
  pattern = { 'json', 'jsonc', 'json5' },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})
