local check_variable = require("extras.local_lib.utils").check_variable

-- Register linters and formatters per language
--local eslint = require('efmls-configs.linters.eslint')
--local prettier = require('efmls-configs.formatters.prettier')
--local languages = {
--  typescript = { eslint, prettier },
--}
--local chktex = require("efmls-configs.linters.chktex")
--local languages = {
--  tex = { chktex },
--}

local function ruff_server_entry()
  local result = {}
  if check_variable({ variable = "RUFF_SERVER_ACTIVE", default = false }) then
    local value = {
      ruff = {
        mason = false, -- set to false if you don't want this server to be installed with mason
        cmd_env = { RUFF_TRACE = "messages" },
        init_options = {
          settings = {
            logLevel = "error",
            configurationPreference = "filesystemFirst",
            lineLength = 100,
            fixAll = true,
            organizeImports = true,
            showSyntaxErrors = false,
            codeAction = {
              disableRuleComment = {
                enable = true,
              },
              fixViolation = {
                enable = true,
              },
            },
            lint = {
              enable = true,
              preview = true,
            },
            format = {
              preview = true,
            },
          },
        },
        keys = {
          {
            "<leader>co",
            LazyVim.lsp.action["source.organizeImports"],
            desc = "Organize Imports",
          },
        },
        on_attach = function(client, bufnr)
          client.server_capabilities.hoverProvider = false
        end,
      },
    }
    result = vim.tbl_deep_extend("force", result, value)
  end
  return result
end
local function basedpyright_server_entry()
  local result = {}
  if check_variable({ variable = "BASEDPYRIGHT_SERVER_ACTIVE", default = true }) then
    local value = {
      basedpyright = {
        mason = false, -- check_variable({ variable = "MASON_BASEDPYRIGHT_INSTALLED", default = true }), -- set to false if you don't want this server to be installed with mason
        -- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/configs/basedpyright.lua
        settings = {
          basedpyright = {
            analysis = {
              autoFormatStrings = true,
              autoSearchPaths = true,
              diagnosticMode = "openFilesOnly",
              useLibraryCodeForTypes = true,
              inlayHints = {
                --                 variableTypes = true,
                variableTypes = false,
              },
            },
          },
        },

        --on_attach = function(client, bufnr)
        --  client.server_capabilities.hoverProvider = false
        --end,
      },
    }
    result = vim.tbl_deep_extend("force", result, value)
  end
  return result
end
local function jsonls_server_entry()
  local result = {}
  if check_variable({ variable = "JSONLS_SERVER_ACTIVE", default = false }) then
    local value = {
      jsonls = {
        -- lazy-load schemastore when needed
        on_new_config = function(new_config)
          new_config.settings.json.schemas = new_config.settings.json.schemas or {}
          vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
        end,
        settings = {
          json = {
            format = {
              enable = true,
            },
            validate = { enable = true },
          },
        },
      },
    }
    result = vim.tbl_deep_extend("force", result, value)
  end
  return result
end
local function marksman_server_entry()
  local result = {}
  if check_variable({ variable = "MARKSMAN_SERVER_ACTIVE", default = false }) then
    local value = {
      marksman = {
        mason = false,
      },
    }
    result = vim.tbl_deep_extend("force", result, value)
  end
  return result
end
local function nushell_server_entry()
  local result = {}
  if check_variable({ variable = "NUSHELL_SERVER_ACTIVE", default = false }) then
    local value = {
      nushell = {
        mason = false,
      },
    }
    result = vim.tbl_deep_extend("force", result, value)
  end
  return result
end
local function yamlls_server_entry()
  -- npm install -g yaml-language-server
  local result = {}
  if check_variable({ variable = "YAMLLS_SERVER_ACTIVE", default = false }) then
    local value = {
      yamlls = {
        mason = false,
        settings = {
          yaml = {
            --validate = true,
            --schemaStore = {
            --  enable = true,
            --},
          },
        },
      },
    }
    result = vim.tbl_deep_extend("force", result, value)
  end
  return result
end

local function latex_server_entry()
  local result = {}
  if check_variable({ variable = "LATEX_SERVER_ACTIVE", default = false }) then
    local value = {
      ltex_plus = {
        mason = false,
        settings = {
          ltex = {
            language = "en-US",
            --languageToolHttpServerUri = "http://localhost:9999",
            --languageToolHttpServerUri = "http://localhost:8083",
          },
        },
      },
    }
    result = vim.tbl_deep_extend("force", result, value)
  end
  return result
end

local function haskell_server_entry()
  local result = {}
  if check_variable({ variable = "HASKELL_SERVER_ACTIVE", default = true }) then
    local value = {
      hls = {
        mason = false, -- set to false if you don't want this server to be installed with mason
      },
    }
    result = vim.tbl_deep_extend("force", result, value)
  end
  return result
end

local function golang_server_entry()
  -- https://github.com/go-delve/delve/tree/master/Documentation/installation
  local result = {}
  if check_variable({ variable = "GOLANG_SERVER_ACTIVE", default = false }) then
    local value = {
      gopls = {
        settings = {
          gopls = {
            gofumpt = true,
            codelenses = {
              gc_details = false,
              generate = true,
              regenerate_cgo = true,
              run_govulncheck = true,
              test = true,
              tidy = true,
              upgrade_dependency = true,
              vendor = true,
            },
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              compositeLiteralTypes = true,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },
            analyses = {
              nilness = true,
              unusedparams = true,
              unusedwrite = true,
              useany = true,
            },
            usePlaceholders = true,
            completeUnimported = true,
            staticcheck = true,
            directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
            semanticTokens = true,
          },
        },
        mason = false, -- set to false if you don't want this server to be installed with mason
      },
    }
    result = vim.tbl_deep_extend("force", result, value)
  end
  return result
end

local all_servers = {
  --{
  --  lexical = {
  --    mason = false,
  --    cmd = { "/home/z/src/Elixir/demos/lexical/_build/dev/package/lexical/bin/start_lexical.sh" },
  --    root_dir = function(fname)
  --      local util = require("lspconfig.util")
  --      return util.root_pattern("mix.exs", ".git")(fname) or vim.loop.cwd()
  --    end,
  --    filetypes = { "elixir", "eelixir", "heex" },
  --    -- optional settings
  --    settings = {},
  --  },
  --},
  --{
  --  clojure_lsp = {
  --    mason = false,
  --  },
  --},
  {
    texlab = {
      mason = false,
      keys = {
        { "<Leader>K", "<plug>(vimtex-doc-package)", desc = "Vimtex Docs", silent = true },
      },
      texlab = {
        build = {
          executable = "pdflatex",
        },
        chktex = {
          -- TODO: not working
          onOpenAndSave = true,
        },
      },
    },
  },
  {
    lua_ls = {
      mason = false, -- set to false if you don't want this server to be installed with mason
      -- Use this to add any additional keymaps
      -- for specific lsp servers
      -- ---@type LazyKeysSpec[]
      -- keys = {},
      settings = {
        Lua = {
          workspace = {
            checkThirdParty = false,
          },
          codeLens = {
            enable = true,
          },
          completion = {
            callSnippet = "Replace",
          },
          doc = {
            privateName = { "^_" },
          },
          hint = {
            enable = true,
            setType = false,
            paramType = true,
            paramName = "Disable",
            semicolon = "Disable",
            arrayIndex = "Disable",
          },
        },
      },
    },
  },
  --{
  --  astro = {},
  --},
  {
    volar = {
      init_options = {
        typescript = {
          -- replace with your global TypeScript library path
          --tsdk = "/path/to/node_modules/typescript/lib",
          tsdk = "/home/z/.volta/tools/shared/typescript/lib",
        },
      },
      on_new_config = function(new_config, new_root_dir)
        local lib_path = vim.fs.find("node_modules/typescript/lib", { path = new_root_dir, upward = true })[1]
        if lib_path then
          new_config.init_options.typescript.tsdk = lib_path
        end
      end,
    },
  },

  --{
  --  efm = {
  --    mason = false,
  --    init_options = { documentLinting = true },
  --    filetypes = { "tex" },
  --    settings = {
  --      rootMarkers = { ".git/" },
  --      languages = {
  --        tex = {
  --          require("efmls-configs.linters.chktex"),
  --        },
  --      },
  --    },
  --  },
  --},

  --  {
  --    efm = { --efmls_config = {
  --      filetypes = vim.tbl_keys(languages),
  --      settings = {
  --        rootMarkers = { ".git/" },
  --        languages = languages,
  --      },
  --      init_options = {
  --        documentFormatting = true,
  --        documentRangeFormatting = true,
  --      },
  ----    },
  --    }
  --  },
  basedpyright_server_entry(),
  ruff_server_entry(),
  jsonls_server_entry(),
  marksman_server_entry(),
  nushell_server_entry(),
  yamlls_server_entry(),
  latex_server_entry(),
  --haskell_server_entry(),
  golang_server_entry(),
}

local all_servers_entries = {

  ["*"] = {
    capabilities = {
      workspace = {
        fileOperations = {
          didRename = true,
          willRename = true,
        },
      },
    },
        -- stylua: ignore
        keys = {
            { "<leader>cl", function() Snacks.picker.lsp_config() end, desc = "Lsp Info" },
            { "gd", vim.lsp.buf.definition, desc = "Goto Definition", has = "definition" },
            { "gr", vim.lsp.buf.references, desc = "References", nowait = true },
            { "gI", vim.lsp.buf.implementation, desc = "Goto Implementation" },
            { "gy", vim.lsp.buf.type_definition, desc = "Goto T[y]pe Definition" },
            { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
            { "K", function() return vim.lsp.buf.hover() end, desc = "Hover" },
            { "gK", function() return vim.lsp.buf.signature_help() end, desc = "Signature Help", has = "signatureHelp" },
            { "<c-k>", function() return vim.lsp.buf.signature_help() end, mode = "i", desc = "Signature Help", has = "signatureHelp" },
            { "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "x" }, has = "codeAction" },
            { "<leader>cc", vim.lsp.codelens.run, desc = "Run Codelens", mode = { "n", "x" }, has = "codeLens" },
            { "<leader>cC", vim.lsp.codelens.refresh, desc = "Refresh & Display Codelens", mode = { "n" }, has = "codeLens" },
            { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename File", mode ={"n"}, has = { "workspace/didRenameFiles", "workspace/willRenameFiles" } },
            { "<leader>cr", vim.lsp.buf.rename, desc = "Rename", has = "rename" },
            { "<leader>cA", LazyVim.lsp.action.source, desc = "Source Action", has = "codeAction" },
            { "]]", function() Snacks.words.jump(vim.v.count1) end, has = "documentHighlight",
              desc = "Next Reference", cond = function() return Snacks.words.is_enabled() end },
            { "[[", function() Snacks.words.jump(-vim.v.count1) end, has = "documentHighlight",
              desc = "Prev Reference", cond = function() return Snacks.words.is_enabled() end },
            { "<a-n>", function() Snacks.words.jump(vim.v.count1, true) end, has = "documentHighlight",
              desc = "Next Reference", cond = function() return Snacks.words.is_enabled() end },
            { "<a-p>", function() Snacks.words.jump(-vim.v.count1, true) end, has = "documentHighlight",
              desc = "Prev Reference", cond = function() return Snacks.words.is_enabled() end },
        },
  },
}
for _, value in ipairs(all_servers) do
  all_servers_entries = vim.tbl_deep_extend("force", all_servers_entries, value)
end

local function golang_server_setup_entry()
  local result = {}
  if check_variable({ variable = "GOLANG_SERVER_ACTIVE", default = false }) then
    local value = {
      gopls = function(_, opts)
        -- workaround for gopls not supporting semanticTokensProvider
        -- https://github.com/golang/go/issues/54531#issuecomment-1464982242
        --Snacks.util.lsp.on(function(client, _)
        --  if not client.server_capabilities.semanticTokensProvider then
        --    local semantic = client.config.capabilities.textDocument.semanticTokens
        --    client.server_capabilities.semanticTokensProvider = {
        --      full = true,
        --      legend = {
        --        tokenTypes = semantic.tokenTypes,
        --        tokenModifiers = semantic.tokenModifiers,
        --      },
        --      range = true,
        --    }
        --  end
        --end, "gopls")
        -- end workaround
      end,
    }
    result = vim.tbl_deep_extend("force", result, value)
  end
  return result
end

local function metals_server_setup_entry()
  local result = {}
  if check_variable({ variable = "METALS_SERVER_ACTIVE", default = false }) then
    local value = {
      metals = function(_, opts)
        local metals = require("metals")
        local metals_config = vim.tbl_deep_extend("force", metals.bare_config(), opts)
        metals_config.on_attach = LazyVim.has("nvim-dap") and metals.setup_dap or nil

        local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
        vim.api.nvim_create_autocmd("FileType", {
          pattern = { "scala", "sbt" },
          callback = function()
            metals.initialize_or_attach(metals_config)
          end,
          group = nvim_metals_group,
        })
        --return true
      end,
    }
    result = vim.tbl_deep_extend("force", result, value)
  end
  return result
end

local all_servers_setups = {
  --basedpyright = function(_, opts)
  --   LazyVim.lsp.on_attach(function(client, _)
  --     client.server_capabilities.hoverProvider = false
  --   end)
  -- end,

  --ruff = function(_, opts)
  --  LazyVim.lsp.on_attach(function(client, _)
  --    -- Disable hover in favor of Pyright
  --    client.server_capabilities.hoverProvider = false
  --  end)
  --end,
  -- example to setup with typescript.nvim
  -- tsserver = function(_, opts)
  --   require("typescript").setup({ server = opts })
  --   return true
  -- end,
  --metals_server_setup_entry(),
  golang_server_setup_entry(),
  {
    -- Specify * to use this function as a fallback for any server
    ["*"] = function(server, opts) end,
  },
}

local all_servers_setups_entries = {}
for _, value in ipairs(all_servers_setups) do
  all_servers_setups_entries = vim.tbl_deep_extend("force", all_servers_setups_entries, value)
end

return {
  {
    "neovim/nvim-lspconfig",
    event = "LazyFile",
    dependencies = {
      "mason.nvim",
      { "mason-org/mason-lspconfig.nvim", config = function() end },
    },
    opts_extend = { "servers.*.keys" },
    opts = function()
      ---@class PluginLspOpts
      local ret = {
        -- options for vim.diagnostic.config()
        ---@type vim.diagnostic.Opts
        diagnostics = {
          underline = true,
          update_in_insert = false,
          virtual_text = {
            spacing = 4,
            source = "if_many",
            prefix = "●",
            -- this will set set the prefix to a function that returns the diagnostics icon based on the severity
            -- prefix = "icons",
          },
          severity_sort = true,
          signs = {
            text = {
              [vim.diagnostic.severity.ERROR] = LazyVim.config.icons.diagnostics.Error,
              [vim.diagnostic.severity.WARN] = LazyVim.config.icons.diagnostics.Warn,
              [vim.diagnostic.severity.HINT] = LazyVim.config.icons.diagnostics.Hint,
              [vim.diagnostic.severity.INFO] = LazyVim.config.icons.diagnostics.Info,
            },
          },
        },
        -- Enable this to enable the builtin LSP inlay hints on Neovim.
        -- Be aware that you also will need to properly configure your LSP server to
        -- provide the inlay hints.
        inlay_hints = {
          enabled = true,
          exclude = { "vue" }, -- filetypes for which you don't want to enable inlay hints
        },
        -- Enable this to enable the builtin LSP code lenses on Neovim.
        -- Be aware that you also will need to properly configure your LSP server to
        -- provide the code lenses.
        codelens = {
          enabled = false,
        },
        -- Enable this to enable the builtin LSP folding on Neovim.
        -- Be aware that you also will need to properly configure your LSP server to
        -- provide the folds.
        folds = {
          enabled = true,
        },
        -- options for vim.lsp.buf.format
        -- `bufnr` and `filter` is handled by the LazyVim formatter,
        -- but can be also overridden when specified
        format = {
          formatting_options = nil,
          timeout_ms = nil,
        },
        -- LSP Server Settings
        -- Sets the default configuration for an LSP client (or all clients if the special name "*" is used).
        ---@alias lazyvim.lsp.Config vim.lsp.Config|{mason?:boolean, enabled?:boolean, keys?:LazyKeysLspSpec[]}
        ---@type table<string, lazyvim.lsp.Config|boolean>
        servers = all_servers_entries,
        -- you can do any additional lsp server setup here
        -- return true if you don't want this server to be setup with lspconfig
        ---@type table<string, fun(server:string, opts: vim.lsp.Config):boolean?>
        setup = all_servers_setups_entries,
      }
      return ret
    end,
    ---@param opts PluginLspOpts
    config = vim.schedule_wrap(function(_, opts)
      -- setup autoformat
      LazyVim.format.register(LazyVim.lsp.formatter())

      -- setup keymaps
      for server, server_opts in pairs(opts.servers) do
        if type(server_opts) == "table" and server_opts.keys then
          require("lazyvim.plugins.lsp.keymaps").set({ name = server ~= "*" and server or nil }, server_opts.keys)
        end
      end

      -- inlay hints
      if opts.inlay_hints.enabled then
        Snacks.util.lsp.on({ method = "textDocument/inlayHint" }, function(buffer)
          if
            vim.api.nvim_buf_is_valid(buffer)
            and vim.bo[buffer].buftype == ""
            and not vim.tbl_contains(opts.inlay_hints.exclude, vim.bo[buffer].filetype)
          then
            vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
          end
        end)
      end

      -- folds
      if opts.folds.enabled then
        Snacks.util.lsp.on({ method = "textDocument/foldingRange" }, function()
          if LazyVim.set_default("foldmethod", "expr") then
            LazyVim.set_default("foldexpr", "v:lua.vim.lsp.foldexpr()")
          end
        end)
      end

      -- code lens
      if opts.codelens.enabled and vim.lsp.codelens then
        Snacks.util.lsp.on({ method = "textDocument/codeLens" }, function(buffer)
          vim.lsp.codelens.refresh()
          vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
            buffer = buffer,
            callback = vim.lsp.codelens.refresh,
          })
        end)
      end

      -- diagnostics
      if type(opts.diagnostics.virtual_text) == "table" and opts.diagnostics.virtual_text.prefix == "icons" then
        opts.diagnostics.virtual_text.prefix = function(diagnostic)
          local icons = LazyVim.config.icons.diagnostics
          for d, icon in pairs(icons) do
            if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
              return icon
            end
          end
          return "●"
        end
      end
      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      if opts.capabilities then
        LazyVim.deprecate("lsp-config.opts.capabilities", "Use lsp-config.opts.servers['*'].capabilities instead")
        opts.servers["*"] = vim.tbl_deep_extend("force", opts.servers["*"] or {}, {
          capabilities = opts.capabilities,
        })
      end

      if opts.servers["*"] then
        vim.lsp.config("*", opts.servers["*"])
      end

      -- get all the servers that are available through mason-lspconfig
      local have_mason = LazyVim.has("mason-lspconfig.nvim")
      local mason_all = have_mason
          and vim.tbl_keys(require("mason-lspconfig.mappings").get_mason_map().lspconfig_to_package)
        or {} --[[ @as string[] ]]
      local mason_exclude = {} ---@type string[]

      ---@return boolean? exclude automatic setup
      local function configure(server)
        if server == "*" then
          return false
        end
        local sopts = opts.servers[server]
        sopts = sopts == true and {} or (not sopts) and { enabled = false } or sopts --[[@as lazyvim.lsp.Config]]

        if sopts.enabled == false then
          mason_exclude[#mason_exclude + 1] = server
          return
        end

        local use_mason = sopts.mason ~= false and vim.tbl_contains(mason_all, server)
        local setup = opts.setup[server] or opts.setup["*"]
        if setup and setup(server, sopts) then
          mason_exclude[#mason_exclude + 1] = server
        else
          vim.lsp.config(server, sopts) -- configure the server
          if not use_mason then
            vim.lsp.enable(server)
          end
        end
        return use_mason
      end

      local install = vim.tbl_filter(configure, vim.tbl_keys(opts.servers))
      if have_mason then
        require("mason-lspconfig").setup({
          ensure_installed = vim.list_extend(install, LazyVim.opts("mason-lspconfig.nvim").ensure_installed or {}),
          automatic_enable = { exclude = mason_exclude },
        })
      end
    end),
  },
}
