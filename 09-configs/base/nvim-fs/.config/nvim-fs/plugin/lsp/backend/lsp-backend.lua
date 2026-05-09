vim.filetype.add({
	filename = {
		["buf.yaml"] = "buf-config",
		["buf.gen.yaml"] = "buf-config",
		["buf.policy.yaml"] = "buf-config",
		["buf.lock"] = "buf-config",
	},
})

vim.treesitter.language.register("yaml", "buf-config")

vim.lsp.enable("buf_ls")

vim.lsp.enable("smithy_ls")
