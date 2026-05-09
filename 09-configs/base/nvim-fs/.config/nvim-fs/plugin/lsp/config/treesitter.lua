--: treesitter
---- https://github.com/nvim-treesitter/nvim-treesitter/discussions/8546
-- https://www.qu8n.com/posts/treesitter-migration-guide-for-nvim-0-12
-- https://neovim.io/doc/user/treesitter/
-- https://neovim.io/doc/user/treesitter/#%3AInspectTree
-- https://tduyng.com/blog/neovim-highlight-syntax/
vim.pack.add({
	{ src = "git:nvim-treesitter/nvim-treesitter", version = "main" },
})
-- require('nvim-treesitter').install { "javascript", "typescript", "python", "c", "lua", "vim", "vimdoc", "query", "htmldjango", "gdscript", "godot_resource", "gdshader" }
require("nvim-treesitter").setup({
	auto_install = false,
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
	indent = {
		enable = true,
	},
})
require("nvim-treesitter").install({
	"python",
	"scala",
	"dart",
	"elixir",
	"heex",
	"eex",
	"regex",
	"bash",
	"astro",
	"markdown",
	"tsx",
	"typescript",

	-- already present in the neovim installation
	-- <install-dir>/lib/nvim/parser
	--     "markdown",
	--     "markdown_inline",
	--     "vim",
	--     "vimdoc",
	--     "lua",
	--     "c",
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "*" },
	callback = function()
		local filetype = vim.bo.filetype
		if filetype and filetype ~= "" then
			local success = pcall(function()
				vim.treesitter.start()
			end)
			if not success then
				return
			end
		end
	end,
})

-- OLD:
-- require('nvim-treesitter.configs').setup {
-- 	-- A list of parser names, or "all" (the five listed parsers should always be installed)
-- 	ensure_installed = { "javascript", "typescript", "python", "c", "lua", "vim", "vimdoc", "query", "htmldjango", "gdscript", "godot_resource", "gdshader" },
-- 	sync_install = false,
-- 	auto_install = true,
-- 	ignore_install = {},
-- 	highlight = {
-- 		enable = true,
-- 		additional_vim_regex_highlighting = false,
-- 	},
-- }
--:

vim.pack.add({
	{ src = "git:mfussenegger/nvim-treehopper", version = "master" },
	{ src = "git:smoka7/hop.nvim", version = "master" },
})

require("tsht").config.hint_keys = { "h", "j", "f", "d", "n", "v", "s", "l", "a" }

vim.keymap.set({ "n", "x", "o" }, "S", function()
	require("tsht").nodes()
end, { desc = "Tree hopper" })

local hop = require("hop")
local directions = require("hop.hint").HintDirection
hop.setup({ keys = "etovxqpdygfblzhckisuran" })
vim.keymap.set("n", "s", "<cmd>HopChar1<cr>", { desc = "Hop to char1", noremap = true, silent = true })
vim.keymap.set("n", "gs", "<cmd>HopChar2MW<cr>", { desc = "Hop to Char2MW", noremap = true, silent = true })
vim.keymap.set({ "n" }, "f", function()
	hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
end, { desc = "Tree hopper" })
vim.keymap.set({ "n" }, "F", function()
	hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
end, { desc = "Tree hopper" })
vim.keymap.set({ "n" }, "t", function()
	hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
end, { desc = "Tree hopper" })
vim.keymap.set({ "n" }, "T", function()
	hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })
end, { desc = "Tree hopper" })
