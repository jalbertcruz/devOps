--if true then
--  return {}
--end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- https://github.com/nvimtools/none-ls.nvim/blob/main/doc/BUILTINS.md
-- https://github.com/nvimtools/none-ls.nvim/blob/main/doc/CONFIG.md#diagnostics_format-string
-- https://github.com/nvimtools/none-ls.nvim/blob/main/doc/BUILTIN_CONFIG.md?plain=1#L227

local check_variable = require("extras.local_lib.utils").check_variable

local null_ls = require("null-ls")

local function null_ls_shell_entry()
  local result = {}
  if check_variable({ variable = "NULL_LS_SHELL_ACTIVE", default = false }) then
    local value = {
      null_ls.builtins.formatting.shellharden,
      null_ls.builtins.formatting.shfmt,
    }
    result = vim.tbl_deep_extend("force", result, value)
  end
  return result
end

local function null_ls_style_entry()
  local result = {}
  if check_variable({ variable = "NULL_LS_STYLE_ACTIVE", default = false }) then
    local value = {
      null_ls.builtins.diagnostics.vale.with({
        diagnostics_format = "#{s}: [#{c}] #{m}",
      }),
    }
    result = vim.tbl_deep_extend("force", result, value)
  end
  return result
end

local function null_ls_writing_entry()
  local result = {}
  if check_variable({ variable = "NULL_LS_WRITING_ACTIVE", default = false }) then
    local value = {
      null_ls.builtins.diagnostics.ltrs.with({
        diagnostics_format = "#{s}: [#{c}] #{m}",
      }),
    }
    result = vim.tbl_deep_extend("force", result, value)
  end
  return result
end

local function null_ls_just_entry()
  local result = {}
  if check_variable({ variable = "NULL_LS_JUST_ACTIVE", default = false }) then
    local value = {
      null_ls.builtins.formatting.just,
    }
    result = vim.tbl_deep_extend("force", result, value)
  end
  return result
end

local function null_ls_sql_entry()
  local result = {}
  if check_variable({ variable = "NULL_LS_SQL_ACTIVE", default = false }) then
    local value = {
      null_ls.builtins.formatting.sqlfluff.with({
        extra_args = { "--dialect", "postgres" }, -- change to your dialect
      }),
    }
    result = vim.tbl_deep_extend("force", result, value)
  end
  return result
end

local function null_ls_yaml_entry()
  local result = {}
  if check_variable({ variable = "NULL_LS_YAML_ACTIVE", default = false }) then
    local value = {
      null_ls.builtins.formatting.yamlfmt,
    }
    result = vim.tbl_deep_extend("force", result, value)
  end
  return result
end

local function null_ls_buf_entry()
  local result = {}
  if check_variable({ variable = "NULL_LS_BUF_ACTIVE", default = false }) then
    local value = {
      null_ls.builtins.diagnostics.buf.with({
        diagnostics_format = "#{s}: [#{c}] #{m}",
      }),
    }
    result = vim.tbl_deep_extend("force", result, value)
  end
  return result
end

local function null_ls_fish_entry()
  local result = {}
  if check_variable({ variable = "NULL_LS_FISH_ACTIVE", default = false }) then
    local value = {
      null_ls.builtins.diagnostics.fish.with({
        diagnostics_format = "#{s}: [#{c}] #{m}",
      }),
    }
    result = vim.tbl_deep_extend("force", result, value)
  end
  return result
end

local function null_ls_dockerfile_entry()
  local result = {}
  if check_variable({ variable = "NULL_LS_DOCKERFILE_ACTIVE", default = false }) then
    local value = {
      -- Dockerfile
      null_ls.builtins.diagnostics.hadolint.with({
        diagnostics_format = "#{s}: [#{c}] #{m}",
      }),
    }
    result = vim.tbl_deep_extend("force", result, value)
  end
  return result
end

local function null_ls_pylint_entry()
  local result = {}
  if check_variable({ variable = "NULL_LS_PYLINT_ACTIVE", default = false }) then
    local value = {
      null_ls.builtins.diagnostics.pylint.with({
        diagnostics_postprocess = function(diagnostic)
          diagnostic.code = diagnostic.message_id
        end,
        diagnostics_format = "#{s}: [#{c}] #{m}",
      }),
    }
    result = vim.tbl_deep_extend("force", result, value)
  end
  return result
end

local function null_ls_pylint_entry_()
  local result = {}
  if check_variable({ variable = "NULL_LS_PYLINT_ACTIVE", default = false }) then
    local value = {
      null_ls.builtins.diagnostics.pylint.with({
        diagnostics_postprocess = function(diagnostic)
          diagnostic.code = diagnostic.message_id
        end,
        diagnostics_format = "#{s}: [#{c}] #{m}",
      }),
    }
    result = vim.tbl_deep_extend("force", result, value)
  end
  return result
end
local function null_ls_d2_entry()
  local result = {}
  if check_variable({ variable = "NULL_LS_D2_ACTIVE", default = false }) then
    local value = {
      null_ls.builtins.formatting.d2_fmt,
    }
    result = vim.tbl_deep_extend("force", result, value)
  end
  return result
end
local function null_ls_golang_entry()
  local result = {}
  if check_variable({ variable = "NULL_LS_GOLANG_ACTIVE", default = false }) then
    local value = {
      null_ls.builtins.code_actions.gomodifytags,
      null_ls.builtins.code_actions.impl,
      null_ls.builtins.formatting.goimports,
      null_ls.builtins.formatting.gofumpt,
    }
    result = vim.tbl_deep_extend("force", result, value)
  end
  return result
end

local null_ls_entries_optional = {
  {
    null_ls.builtins.diagnostics.todo_comments.with({
      diagnostics_format = "[#{c}] #{m} => (#{s})",
    }),
  },
  null_ls_shell_entry(),
  null_ls_style_entry(),
  null_ls_writing_entry(),
  null_ls_just_entry(),
  null_ls_sql_entry(),
  null_ls_yaml_entry(),
  null_ls_buf_entry(),
--   null_ls_fish_entry(),
  null_ls_dockerfile_entry(),
  null_ls_pylint_entry(),
  null_ls_d2_entry(),
  null_ls_golang_entry(),
}

local null_ls_entries = {}

if check_variable({ variable = "NULL_LS_ACTIVE", default = false }) then
  for _, value in ipairs(null_ls_entries_optional) do
    null_ls_entries = vim.list_extend(null_ls_entries, value)
  end
end

return {
  {
    "nvimtools/none-ls.nvim",
    event = "LazyFile",
    dependencies = { "mason.nvim" },
    init = function()
      LazyVim.on_very_lazy(function()
        -- register the formatter with LazyVim
        LazyVim.format.register({
          name = "none-ls.nvim",
          priority = 200, -- set higher than conform, the builtin formatter
          primary = true,
          format = function(buf)
            return LazyVim.lsp.format({
              bufnr = buf,
              filter = function(client)
                return client.name == "null-ls"
              end,
            })
          end,
          sources = function(buf)
            local ret = require("null-ls.sources").get_available(vim.bo[buf].filetype, "NULL_LS_FORMATTING") or {}
            return vim.tbl_map(function(source)
              return source.name
            end, ret)
          end,
        })
      end)
    end,
    opts = function(_, opts)
      opts.root_dir = opts.root_dir
        or require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git")
      --nls.builtins.formatting.fish_indent,
      --nls.builtins.diagnostics.fish,
      --nls.builtins.formatting.stylua,
      --nls.builtins.formatting.shfmt,
      --null_ls.builtins.formatting.prettier, -- already in conform
      --null_ls.builtins.diagnostics.markuplint, -- HTML
      --null_ls.builtins.formatting.tidy, -- HTML
      --null_ls.builtins.formatting.biome, -- Formatter, linter, bundler, and more for JavaScript, TypeScript, JSON, HTML, Markdown, CSS and GraphQL

      --null_ls.builtins.formatting.scalafmt,

      --null_ls.builtins.formatting.sqlfmt,
      --null_ls.builtins.formatting.sqlformat,
      --null_ls.builtins.formatting.sql_formatter

      --null_ls.builtins.diagnostics.spectral, -- openapi
      --null_ls.builtins.diagnostics.credo, -- elixir
      --null_ls.builtins.diagnostics.mypy, -- Python
      --null_ls.builtins.formatting.isort,
      --null_ls.builtins.formatting.black,

      --null_ls.builtins.diagnostics.selene, -- lua
      --null_ls.builtins.diagnostics.textidote, -- latex
      opts.sources = vim.list_extend(opts.sources or {}, null_ls_entries)
    end,
  },
}
