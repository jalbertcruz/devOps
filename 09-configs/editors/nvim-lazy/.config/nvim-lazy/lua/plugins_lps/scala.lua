local check_variable = require("extras.local_lib.utils").check_variable

return {
  {
    "scalameta/nvim-metals",
    ft = { "scala", "sbt", "java" },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    enabled = check_variable({ variable = "METALS_SERVER_ACTIVE", default = false }),
    opts = function()
      local metals_config = require("metals").bare_config()
      metals_config.init_options.statusBarProvider = "on"
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

        mavenScript = vim.fn.expand("~/appslnx/build-tools/maven/bin/mvn"),
        superMethodLensesEnabled = true,
        verboseCompilation = true,

        metals = {
          useGlobalExecutable = true,
        },
      }

      metals_config.on_attach = function(client, bufnr)
        -- your on_attach function
      end

      return metals_config
    end,
    config = function(self, metals_config)
      local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })

      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = { "*.worksheet.sc" },
        callback = function()
          vim.lsp.inlay_hint.enable(true)
        end,
        group = nvim_metals_group,
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = self.ft,
        callback = function()
          require("metals").initialize_or_attach(metals_config)
        end,
        group = nvim_metals_group,
      })

      local set = vim.keymap.set
      local k = vim.keycode

-- TODO: review keymaps (not being used)
      set("n", "<leader>ma", function()
        require("telescope").extensions.metals.commands()
      end, { noremap = true, silent = true, desc = "Metals commands" })

      set("n", "<leader>mc", function()
        require("metals").compile_cascade()
      end, { noremap = true, silent = true, desc = "Metals compile cascade" })

      set("n", "<leader>mw", function()
        require("metals").hover_worksheet()
      end, { noremap = true, silent = true, desc = "Metals hover worksheet" })

      --       set("n", "<leader>m", function()
      --       end, { noremap = true, silent = true, desc = "" })
    end,
  },
}
