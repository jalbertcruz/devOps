local on_attach = require("utils.lsp").on_attach

vim.lsp.config("basedpyright", {
	on_attach = on_attach,
	root_markers = {
		"pyrightconfig.json",
		"pyproject.toml",
		"requirements.txt",
		"Pipfile",
		".git",
	},
	settings = {
		basedpyright = {
			-- Using Ruff's import organizer
			disableOrganizeImports = true,
		},
		python = {
			analysis = {
				-- 				autoSearchPaths = true,
				-- 				useLibraryCodeForTypes = true,
				-- 				typeCheckingMode = "basic",
				-- Ignore all files for analysis to exclusively use Ruff for linting
				ignore = { "*" },
			},
		},
	},
})

-- https://docs.astral.sh/ruff/editors/setup/#neovim
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp_attach_disable_ruff_hover", { clear = true }),
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client == nil then
			return
		end
		if client.name == "ruff" then
			-- Disable hover in favor of Pyright
			client.server_capabilities.hoverProvider = false
		end
	end,
	desc = "LSP: Disable hover capability from Ruff",
})

vim.lsp.config("ruff", {
	init_options = {
		settings = {
			-- Ruff language server settings go here
			logLevel = "debug",
		},
	},
})

vim.lsp.enable("basedpyright")
vim.lsp.enable("ruff")

vim.filetype.add({
	extension = {
		jinja = "jinja",
		jinja2 = "jinja",
		j2 = "jinja",
	},
})

vim.lsp.enable("jinja_lsp")
