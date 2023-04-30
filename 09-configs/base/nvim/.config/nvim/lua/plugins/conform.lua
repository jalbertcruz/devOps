return {
  {
    "stevearc/conform.nvim",
    --enabled = false,
    optional = true,
    opts = {
      formatters_by_ft = {
        -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#biome
        html = { "biome" },
        python = { "ruff_format", "ruff_fix", "ruff_organize_imports" },
        sql = { "sqlfluff" },
        json = { "deno_fmt" },
        fish = {  },
--         fish = { "fish-lsp" },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      for _, ft in ipairs(opts.formatters_by_ft) do
        opts.formatters_by_ft[ft] = opts.formatters_by_ft[ft] or {}
        table.insert(opts.formatters_by_ft[ft], "biome")
      end
      opts.formatters = opts.formatters or {}
      opts.formatters.biome = {
        require_cwd = true,
      }
      opts.formatters.sqlfluff = {
        args = { "format", "--dialect=ansi", "-" },
      }
    end,
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters = {
        ["markdown-toc"] = {
          condition = function(_, ctx)
            for _, line in ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)) do
              if line:find("<!%-%- toc %-%->") then
                return true
              end
            end
          end,
        },
        ["markdownlint"] = {
          condition = function(_, ctx)
            local diag = vim.tbl_filter(function(d)
              return d.source == "markdownlint"
            end, vim.diagnostic.get(ctx.buf))
            return #diag > 0
          end,
        },
      },
      formatters_by_ft = {
        ["markdown"] = { "prettier", "markdownlint", "markdown-toc" },
        ["markdown.mdx"] = { "markdownlint", "markdown-toc" },
        go = { "goimports", "gofumpt" },
      },
    },
  },
}
