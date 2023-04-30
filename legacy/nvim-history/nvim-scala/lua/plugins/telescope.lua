


return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<C-p>", builtin.find_files, {})
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
			vim.keymap.set("n", "<leader>fs", builtin.grep_string, {})

			--require('telescope').load_extension('git_worktree')
			--vim.keymap.set("n", "<leader>lw", "<CMD>lua require('telescope').extensions.git_worktree.git_worktrees()<CR>", silent)
			--vim.keymap.set("n", "<leader>cw", "<CMD>lua require('telescope').extensions.git_worktree.create_git_worktree()<CR>", silent)

		end,
	},
	{
		"nvim-telescope/telescope-ui-select.nvim",
		config = function()
			-- This is your opts table
			require("telescope").setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({}),
					},
				},
			})
			require("telescope").load_extension("ui-select")
		end,
	},
}
