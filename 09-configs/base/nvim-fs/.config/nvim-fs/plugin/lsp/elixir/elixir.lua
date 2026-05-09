local on_attach = require("utils.lsp").on_attach

-- elixir
-- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/elixirls.lua

--     /home/z/src/elixir/ex_packages/expert/apps/expert/_build/prod/rel/plain/bin/start_expert --stdio

vim.lsp.config("expert", {
	filetypes = { "elixir", "heex", "mix" },
	cmd = { "start_expert", "--stdio" },
	on_attach = on_attach,
	settings = {
		workspaceSymbols = {
			minQueryLength = 0,
		},
	},
})

vim.lsp.enable("expert")
