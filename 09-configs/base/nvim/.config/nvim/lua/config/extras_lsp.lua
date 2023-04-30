
require("lspconfig").harper_ls.setup({
  settings = {
    ["harper-ls"] = {
      --userDictPath = "",
      --workspaceDictPath = "",
      --fileDictPath = "",
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
      ignoredLintsPath = {},
    },
  },
})
vim.lsp.enable("harper_ls")

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.expandtab = false
    vim.opt_local.tabstop = 2 -- or your preferred tab width
    vim.opt_local.shiftwidth = 2 -- or your preferred indent width
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "smithy" },
  callback = function()
    vim.lsp.start({
      name = "smithy-language-server",
      cmd = { "smithy-language-server", "0" },
      init_options = {
        --         statusBarProvider = "off",
        isHttpEnabled = false,
        compilerOptions = {
          snippetAutoIndent = true,
        },
      },
    })
  end,
})

vim.lsp.enable("docker_language_server")

-- https://github.com/supabase-community/postgres-language-server/blob/main/docs/getting_started.md?plain=1#L7
vim.lsp.enable("postgres_lsp")

vim.lsp.enable("lua_ls")

-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#oxlint
-- vim.lsp.enable("oxlint")

vim.lsp.enable("denols")

-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#clangd
vim.lsp.enable("clangd")
