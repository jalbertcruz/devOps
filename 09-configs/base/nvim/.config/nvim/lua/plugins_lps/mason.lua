-- $HOME/.local/share/nvim/mason/packages/

local check_variable = require("extras.local_lib.utils").check_variable
local function mason_shell_entry()
  local result = {}
  if check_variable({ variable = "MASON_SHELL_ACTIVE", default = false }) then
    local value = {
      "shfmt",
      "shellcheck",
    }
    result = vim.tbl_deep_extend("force", result, value)
  end
  return result
end
local function mason_python_extra_entry()
  local result = {}
  if check_variable({ variable = "MASON_PYTHON_EXTRA_ACTIVE", default = true }) then
    local value = {
      "pylint",
    }
    result = vim.tbl_deep_extend("force", result, value)
  end
  return result
end
local function mason_writing_entry()
  local result = {}
  if check_variable({ variable = "MASON_WRITING_ACTIVE", default = false }) then
    local value = {

      --writing
      "proselint",
      "write-good",
      "alex",
    }
    result = vim.tbl_deep_extend("force", result, value)
  end
  return result
end
local function mason_frontend_entry()
  local result = {}
  if check_variable({ variable = "MASON_FRONTEND_ACTIVE", default = false }) then
    local value = {
      "prettier",
      --"astro-language-server",
      "html-lsp",
      "css-lsp",
      "tailwindcss-language-server",
    }
    result = vim.tbl_deep_extend("force", result, value)
  end
  return result
end
local function mason_general_backend_entry()
  local result = {}
  if check_variable({ variable = "MASON_GENERAL_BACKEND_ACTIVE", default = false }) then
    local value = {
      "json-lsp",
    }
    result = vim.tbl_deep_extend("force", result, value)
  end
  return result
end
local function mason_markdown_entry()
  if not check_variable("MASON_MARKDOWN_ACTIVE") then
    return {}
  end
  return {
    "markdownlint",
    --"markdown-toc",
    --     "sqlfluff",
  }
  --"biome",
  --"shellharden",
  --"yamlfmt",
  --"hadolint",
  --"sqlfluff",
  --"",
end

local mason_entries_optional = {
  mason_shell_entry(),
  mason_python_extra_entry(),
  mason_writing_entry(),
  mason_frontend_entry(),
  mason_general_backend_entry(),
  mason_markdown_entry(),
}
local mason_ensure_installed_entries = {}
for _, value in ipairs(mason_entries_optional) do
  mason_ensure_installed_entries = vim.list_extend(mason_ensure_installed_entries, value)
end

return {
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    build = ":MasonUpdate",
    opts_extend = { "ensure_installed" },
    opts = {
      ensure_installed = mason_ensure_installed_entries,
    },
    ---@param opts MasonSettings | {ensure_installed: string[]}
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      mr:on("package:install:success", function()
        vim.defer_fn(function()
          -- trigger FileType event to possibly load this newly installed LSP server
          require("lazy.core.handler.event").trigger({
            event = "FileType",
            buf = vim.api.nvim_get_current_buf(),
          })
        end, 100)
      end)

      mr.refresh(function()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            if check_variable({ variable = "INSTALL_NVIM_MASON_APPS", default = true }) then
              p:install() -- poor internet :-)
            end
          end
        end
      end)
    end,
  },
}
