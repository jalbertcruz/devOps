if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- Custom LSP Definition
-- https://docs.astronvim.com/recipes/advanced_lsp/

local util = require "lspconfig.util"

local root_files = {
  'pyproject.toml',
  'setup.py',
  'setup.cfg',
  'requirements.txt',
  'Pipfile',
  'pyrightconfig.json',
  '.git',
}
local config = require("lspconfig")
--vim.notify("config: " .. vim.inspect(config), vim.log.levels.INFO)
local capabilities = config.util.default_config.capabilities
--local on_attach = config.on_attach

local function organize_imports()
  local params = {
    command = 'basedpyright.organizeimports',
    arguments = { vim.uri_from_bufnr(0) },
  }

  local clients = util.get_lsp_clients {
    bufnr = vim.api.nvim_get_current_buf(),
    name = 'basedpyright',
  }
  for _, client in ipairs(clients) do
    client.request('workspace/executeCommand', params, nil, 0)
  end
end

local function set_python_path(path)
  local clients = util.get_lsp_clients {
    bufnr = vim.api.nvim_get_current_buf(),
    name = 'basedpyright',
  }
  for _, client in ipairs(clients) do
    if client.settings then
      client.settings.python = vim.tbl_deep_extend('force', client.settings.python or {}, { pythonPath = path })
    else
      client.config.settings = vim.tbl_deep_extend('force', client.config.settings, { python = { pythonPath = path } })
    end
    client.notify('workspace/didChangeConfiguration', { settings = nil })
  end
end


return {
  "AstroNvim/astrolsp",
  -- we need to use the function notation to get access to the `lspconfig` module
  opts = function(plugin, opts)

    --local capabilities = nil
    --if pcall(require, "cmp_nvim_lsp") then
    --  capabilities = require("cmp_nvim_lsp").default_capabilities()
    --end
    --if capabilities == nil then
    --  vim.notify("cmp_nvim_lsp not found", vim.log.levels.WARN)
    --else
    --  vim.notify("cmp_nvim_lsp found", vim.log.levels.INFO)
    --end
    -- insert "prolog_lsp" into our list of servers
    opts.servers = opts.servers or {}
    table.insert(opts.servers, "custom_python_lsp")

    -- extend our configuration table to have our new prolog server
    opts.config = require("astrocore").extend_tbl(opts.config or {}, {
      -- this must be a function to get access to the `lspconfig` module
      custom_python_lsp = {
        cmd = { "basedpyright-langserver", "--stdio" },
        filetypes = { "python" },

        root_dir = function(fname) return util.root_pattern(unpack(root_files))(fname) end,
        single_file_support = true,
        settings = {
          basedpyright = {
            analysis = {
              autoSearchPaths = false,
              useLibraryCodeForTypes = true,
              diagnosticMode = "openFilesOnly",
            },
          },
        },
      },
    })

    opts.capabilities = capabilities

    --opts.on_attach = function(client, bufnr)
    --  vim.keymap.set("n", "<Leader>lr", vim.lsp.buf.rename, {desc="Rename current symbol"})
    --end

    opts.mappings = require("astrocore").extend_tbl(opts.mappings or {}, {
      n = {
        -- a `cond` key can provided as the string of a server capability to be required to attach, or a function with `client` and `bufnr` parameters from the `on_attach` that returns a boolean
        gd = {
          function() vim.lsp.buf.declaration() end,
          desc = "Declaration of current symbol",
          cond = "textDocument/declaration",
        },
        --["<Leader>lr"]
        gD = {
          function() vim.lsp.buf.rename() end,
          desc = "Rename current symbol",
        },

      },
    })

    --if not opts.mappings then opts.mappings = require("astrocore").empty_map_table() end
    --local maps = assert(opts.mappings)
    --maps.n["<Leader>lr"] = { "<Plug>(coc-rename)", desc = "Rename current symbol" }

    opts.commands = {
      PyOrganizeImports = {
        organize_imports,
        description = 'Organize Imports',
      },
      PySetPythonPath = {
        set_python_path,
        description = 'Reconfigure basedpyright with the provided python path',
        nargs = 1,
        complete = 'file',
      },
    }
  end,
}
