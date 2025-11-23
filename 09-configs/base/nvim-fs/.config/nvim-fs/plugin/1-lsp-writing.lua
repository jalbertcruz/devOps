-- for harper
vim.diagnostic.config({ virtual_lines = true })

local on_attach = require("utils.lsp").on_attach

-- Harper specific setup
vim.lsp.config["harper_ls"] = {
	on_attach = on_attach,
	capabilities = { textDocument = { semanticTokens = { multilineTokenSupport = true } } },
	cmd = { "harper-ls", "--stdio" },
	filetypes = { "markdown", "text", "tex", "typst" },
	settings = {
		["harper-ls"] = {
			userDictPath = os.getenv("HOME") .. "/.config/harper-ls/dictionary.txt",
			linters = {
				SpellCheck = true,
				SpelledNumbers = false,
				AnA = true,
				SentenceCapitalization = true,
				UnclosedQuotes = true,
				WrongQuotes = false,
				LongSentences = true,
				RepeatedWords = true,
				Spaces = true,
				Matcher = true,
				CorrectNumberSuffix = true,
			},
			codeActions = {
				ForceStable = false,
			},
			markdown = {
				IgnoreLinkTitle = false,
			},
			diagnosticSeverity = "hint",
			isolateEnglish = false,
			dialect = "American",
			maxFileLength = 120000,
			--       ignoredLintsPath = "",
			--       excludePatterns = {}
		},
	},
}


vim.lsp.config("typos_lsp", {
	on_attach = on_attach,

	-- typos-lsp must be on your PATH, or otherwise change this to an absolute path to typos-lsp
	-- defaults to typos-lsp if unspecified
	cmd = { "typos-lsp" },
	-- Logging level of the language server. Logs appear in :LspLog. Defaults to error.
	cmd_env = { RUST_LOG = "error" },
	init_options = {
		-- Custom config. Used together with a config file found in the workspace or its parents,
		-- taking precedence for settings declared in both.
		-- Equivalent to the typos `--config` cli argument.
		--         config = '~/code/typos-lsp/crates/typos-lsp/tests/typos.toml',
		-- How typos are rendered in the editor, can be one of an Error, Warning, Info or Hint.
		-- Defaults to Info.
		diagnosticSeverity = "Info",
	},
})

--vim.lsp.enable("ltex_plus")
--vim.lsp.enable("marksman")
--vim.lsp.enable("texlab")
--vim.lsp.enable("vale_ls")
--
--vim.lsp.enable("typos_lsp")
--vim.lsp.enable("harper_ls")
