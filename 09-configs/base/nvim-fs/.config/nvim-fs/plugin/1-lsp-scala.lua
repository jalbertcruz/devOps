local on_attach = require("utils.lsp").on_attach

vim.pack.add({
	{ src = "git:scalameta/nvim-metals" },
})

local metals_config = require("metals").bare_config()
metals_config.on_attach = on_attach
metals_config.root_markers = { "build.sbt", "build.sc", "xxpom.xml" }
metals_config.init_options = {
	statusBarProvider = "on",
	isHttpEnabled = true,
	compilerOptions = {
		snippetAutoIndent = false,
	},
}

metals_config.settings = {
	excludedPackages = {
		"akka.actor.typed.javadsl",
		"com.github.swagger.akka.javadsl",
	},

	autoImportBuild = "initial",
	bloopSbtAlreadyInstalled = true,
	inlayHints = {
		byNameParameters = { enable = true },
		hintsInPatternMatch = { enable = true },
		implicitArguments = { enable = true },
		implicitConversions = { enable = true },
		inferredTypes = { enable = true },
		typeParameters = { enable = true },
	},

	-- mavenScript = vim.fn.expand("~/appslnx/build-tools/maven/bin/mvn"),
	superMethodLensesEnabled = true,
	verboseCompilation = true,

	metals = {
		useGlobalExecutable = true,
	},
}

local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
-- vim.api.nvim_create_autocmd("FileType", {
-- 	pattern = { "scala", "sbt", "java" },
-- 	callback = function()
-- 		require("metals").initialize_or_attach(metals_config)
-- 	end,
-- 	group = nvim_metals_group,
-- })

vim.lsp.config("metals", metals_config)

--: telescope to be use by metals
vim.pack.add({
	{ src = "git:nvim-lua/plenary.nvim" },
	{ src = "git:nvim-telescope/telescope.nvim" },
})

-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/lang/scala.lua#L19
vim.keymap.set(
	"n",
	"<leader>me",
	":lua require('telescope').extensions.metals.commands()<cr>",
	{ desc = "Metals commands", noremap = true, silent = true }
)

local dap = require("dap")

--dap.configurations.scala = {
--{
--  type = "scala",
--  request = "launch",
--  name = "RunOrTest",
--  metals = {
--	runType = "runOrTestFile",
--	--args = { "firstArg", "secondArg", "thirdArg" }, -- here just as an example
--  },
--},
--{
--  type = "scala",
--  request = "launch",
--  name = "Test Target",
--  metals = {
--	runType = "testTarget",
--  },
--},
--}


vim.lsp.enable("metals")
