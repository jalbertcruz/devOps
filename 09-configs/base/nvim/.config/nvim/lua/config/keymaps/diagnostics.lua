local set = vim.keymap.set
local k = vim.keycode

-- vim.g["diagnostics_active"] = true
--
-- function Toggle_diagnostics()
--   if vim.g.diagnostics_active then
--     vim.g.diagnostics_active = false
--     vim.diagnostic.disable()
--     vim.opt.spell = false
--   else
--     vim.g.diagnostics_active = true
--     vim.diagnostic.enable()
--     vim.opt.spell = true
--   end
-- end
--
-- set("n", "<leader>xd", Toggle_diagnostics, { noremap = true, silent = true, desc = "Toggle vim diagnostics" }) -- already present in LazyVim

set(
  "n",
  "<leader>dq",
  vim.diagnostic.setqflist,
  { noremap = true, silent = true, desc = "Add diagnostics messages to quickfix list." }
)
