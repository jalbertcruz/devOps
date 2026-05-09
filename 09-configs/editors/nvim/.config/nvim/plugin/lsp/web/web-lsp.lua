-- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/stylelint_lsp.lua

-- vim.lsp.config('stylelint_lsp', {})

vim.lsp.enable("stylelint_lsp")
vim.lsp.enable("cssls")
vim.lsp.enable("tailwindcss")
vim.lsp.enable("eslint")
vim.lsp.enable("html")
vim.lsp.enable("jsonls")

vim.pack.add({
	{ src = "git:mattn/emmet-vim" },
})

vim.lsp.enable("emmet_language_server")

vim.lsp.enable("oxfmt")
vim.lsp.enable("oxlint")

vim.lsp.enable("ts_ls")

local vue_language_server_path = os.getenv("HOME") .. "/appslnx/tools/nodejs/apps/bin/node_modules/@vue/language-server"
local vue_plugin = {
	name = "@vue/typescript-plugin",
	location = vue_language_server_path,
	languages = { "vue" },
	configNamespace = "typescript",
}
vim.lsp.config("vtsls", {
	settings = {
		vtsls = {
			tsserver = {
				globalPlugins = {
					vue_plugin,
				},
			},
		},
	},
	filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
})

vim.lsp.enable("vtsls")

vim.lsp.enable("vue_ls")

vim.pack.add({
	{ src = "git:davidmh/mdx.nvim" },
})

vim.lsp.config("astro", {
	init_options = {
		typescript = {
			--       tsdk = 'node_modules/typescript/lib' -- this need to include '"typescript": "^6.0.3"' in Astro dev projects
			tsdk = os.getenv("HOME") .. "/appslnx/tools/nodejs/apps/bin/node_modules/typescript/lib",
		},
	},
})

vim.lsp.enable("astro")

vim.lsp.config("mdx_analyzer", {})

vim.lsp.enable("mdx_analyzer")

vim.g.markdown_fenced_languages = {
	"ts=typescript",
}
vim.lsp.enable("denols")
