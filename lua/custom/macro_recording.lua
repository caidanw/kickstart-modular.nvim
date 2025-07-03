---@class MuteMacro
---@field enabled boolean State of macro recording
local M = {}

function M.setup()
  -- Disable repeating last recorded register n times
  vim.keymap.set('n', 'Q', '<NOP>')

  M.set(vim.g.macro_recording or false)
end

function M.is_enabled() return M.enabled end

function M.enable()
  vim.keymap.set('n', 'q', 'q', { noremap = true })
  M.enabled = true
end

function M.disable()
  vim.keymap.set('n', 'q', '<NOP>', { noremap = true })
  M.enabled = false
end

---@param should_enable boolean
function M.set(should_enable)
  if should_enable then
    M.enable()
  else
    M.disable()
  end
end

---Toggle macro recording functionality
function M.toggle() M.set(not M.enabled) end

return M
