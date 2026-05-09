local M = {}

-- M.setup = function(opts)
--   print("Options:", opts)
-- end

-- functions we need:
-- - vim.keymap.set(...) -> create new keymaps
-- - nvim_get_keymap

-- vim.api.nvim_get_keymap(...)

M._stack = {}

M.push = function(name, mode, mappings)
	local maps = vim.api.nvim_get_keymap(mode)

	P(maps)
end

M.pop = function(name, mode) end

--M.push("debug_mode", "n", {
--  ["<leader>st"] = "echo 'Hello'",
--  ["<leader>sz"] = "echo 'Goodbye'",
--})

P(vim.fn.stdpath("data"))
P(vim.fn.stdpath("cache"))

--lua require("mapstack").pop("debug_mode")
--]]

M._clear = function()
	M._stack = {}
end

return M
