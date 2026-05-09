return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "elixir", "heex", "eex" })
      vim.treesitter.language.register("markdown", "livebook")
    end,
  },
  --  {
  --  "elixir-tools/elixir-tools.nvim",
  --  version = "*",
  --  event = { "BufReadPre", "BufNewFile" },
  --  config = function()
  --    local elixir = require("elixir")
  --    local elixirls = require("elixir.elixirls")
  --
  --    elixir.setup {
  --      nextls = {enable = false},
  --      elixirls = {
  --        enable = true,
  --         cmd = "/home/a/src/Elixir/demos/elixir-ls/elixir_ls_bin/launch.fish",
  --        settings = elixirls.settings {
  --          dialyzerEnabled = false,
  --          enableTestLenses = false,
  --        },
  --        on_attach = function(client, bufnr)
  --          vim.keymap.set("n", "<space>fp", ":ElixirFromPipe<cr>", { buffer = true, noremap = true })
  --          vim.keymap.set("n", "<space>tp", ":ElixirToPipe<cr>", { buffer = true, noremap = true })
  --          vim.keymap.set("v", "<space>em", ":ElixirExpandMacro<cr>", { buffer = true, noremap = true })
  --        end,
  --      },
  --      projectionist = {
  --        enable = true
  --      }
  --    }
  --  end,
  --  dependencies = {
  --    "nvim-lua/plenary.nvim",
  --  },
  --},
}
