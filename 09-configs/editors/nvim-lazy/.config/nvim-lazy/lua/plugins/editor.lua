return {
  {
    "mfussenegger/nvim-treehopper",
    dependencies = {
      "smoka7/hop.nvim",
    },
    keys = {
      {
        "S",
        mode = { "n", "o", "x" },
        function()
          require("tsht").nodes()
        end,
        desc = "Tree hopper",
      },
    },
    config = function() end,
  },
  {
    "smoka7/hop.nvim",
    version = "*",
    --enable = false,
    opts = {
      keys = "etovxqpdygfblzhckisuran",
    },
    keys = {
      {
        "s",
        "<cmd>HopChar1<cr>",
        desc = "Hop to char1",
      },
      {
        "gs",
        "<cmd>HopChar2MW<cr>",
        desc = "Hop to Char2MW",
      },
      {
        "f",
        function()
          local hop = require("hop")
          local directions = require("hop.hint").HintDirection
          hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
        end,
        { remap = true },
      },
      {
        "F",
        function()
          local hop = require("hop")
          local directions = require("hop.hint").HintDirection
          hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
        end,
        { remap = true },
      },
      {
        "t",
        function()
          local hop = require("hop")
          local directions = require("hop.hint").HintDirection
          hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
        end,
        { remap = true },
      },
      {
        "T",
        function()
          local hop = require("hop")
          local directions = require("hop.hint").HintDirection
          hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })
        end,
        { remap = true },
      },
    },
  },
  {
    "nvim-mini/mini.surround",
    optional = true,
    opts = {
      mappings = {
        add = "gza", -- Add surrounding in Normal and Visual modes
        delete = "gzd", -- Delete surrounding
        find = "gzf", -- Find surrounding (to the right)
        find_left = "gzF", -- Find surrounding (to the left)
        highlight = "gzh", -- Highlight surrounding
        replace = "gzr", -- Replace surrounding
        update_n_lines = "gzn", -- Update `n_lines`
      },
    },
    keys = {
      { "gz", "", desc = "+surround" },
    },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    version = false,
    opts = {
      filesystem = {
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = false,
        },
      },
    },
  },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    config = function()
      vim.o.foldcolumn = "1" -- '0' is not bad
      vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true

      vim.keymap.set("n", "zR", require("ufo").openAllFolds, { desc = "Open all folds" })
      vim.keymap.set("n", "zM", require("ufo").closeAllFolds, { desc = "Close all folds" })
      vim.keymap.set("n", "zK", function()
        local winid = require("ufo").peekFoldedLinesUnderCursor()
        if not winid then
          vim.lsp.buf.hover()
        end
      end, { desc = "Peek Fold" })

      vim.keymap.set("n", "zl0", function()
        require("ufo").closeFoldsWith(0)
      end, { desc = "closeFoldsWith 0" })

      vim.keymap.set("n", "zl1", function()
        require("ufo").closeFoldsWith(1)
      end, { desc = "closeFoldsWith 1" })

      vim.keymap.set("n", "zl2", function()
        require("ufo").closeFoldsWith(2)
      end, { desc = "closeFoldsWith 2" })

      vim.keymap.set("n", "zl3", function()
        require("ufo").closeFoldsWith(3)
      end, { desc = "closeFoldsWith 3" })

      vim.keymap.set("n", "zl4", function()
        require("ufo").closeFoldsWith(4)
      end, { desc = "closeFoldsWith 4" })

      vim.keymap.set("n", "zl5", function()
        require("ufo").closeFoldsWith(5)
      end, { desc = "closeFoldsWith 5" })

      vim.keymap.set("n", "zl6", function()
        require("ufo").closeFoldsWith(6)
      end, { desc = "closeFoldsWith 6" })
      require("ufo").setup({
        provider_selector = function(bufnr, filetype, buftype)
          return { "lsp", "indent" }
        end,
      })
    end,
  },
  {
    "jdev-ops/harpoon",
    branch = "dev",
    enabled = false,
    opts = {
      menu = {
        width = vim.api.nvim_win_get_width(0) - 4,
      },
      settings = {
        save_on_toggle = true,
      },
    },
    keys = function()
      local keys = {
        {
          "<leader>H",
          function()
            require("harpoon"):list():add()
          end,
          desc = "Harpoon File",
        },
        {
          "<leader>h",
          function()
            local harpoon = require("harpoon")
            harpoon.ui:toggle_quick_menu(harpoon:list())
          end,
          desc = "Harpoon Quick Menu",
        },
      }

      for i = 1, 5 do
        table.insert(keys, {
          "<leader>" .. i,
          function()
            require("harpoon"):list():select(i)
          end,
          desc = "Harpoon to File " .. i,
        })
      end
      return keys
    end,
  },
  {
    "jdev-ops/persistence.nvim",
    branch = "dev",
    event = "BufReadPre",
    opts = {},
  -- stylua: ignore
  keys = {
    { "<leader>qs", function() require("persistence").load() end, desc = "Restore Session" },
    { "<leader>qS", function() require("persistence").select() end,desc = "Select Session" },
    { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
    { "<leader>qd", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
  },
  },
  {
    "junegunn/fzf.vim",
  },
  {
    "ojroques/nvim-lspfuzzy",
    dependencies = {
      "junegunn/fzf",
      "junegunn/fzf.vim",
    },

    opts = {
      setup = {
        methods = "all", -- either 'all' or a list of LSP methods (see below)
        jump_one = true, -- jump immediately if there is only one location
        save_last = false, -- save last location results for the :LspFuzzyLast command
        callback = nil, -- callback called after jumping to a location
        fzf_preview = { -- arguments to the FZF '--preview-window' option
          "right:+{2}-/2", -- preview on the right and centered on entry
        },
        fzf_action = { -- FZF actions
          ["ctrl-t"] = "tab split", -- go to location in a new tab
          ["ctrl-v"] = "vsplit", -- go to location in a vertical split
          ["ctrl-x"] = "split", -- go to location in a horizontal split
        },
        fzf_modifier = ":~:.", -- format FZF entries, see |filename-modifiers|
        fzf_trim = true, -- trim FZF entries
      },
    },
  },
  {
    "nvim-mini/mini.splitjoin",
    version = false,
    config = function()
      local msj = require("mini.splitjoin")
      msj.setup({
        mappings = { toggle = "" },
      })
      vim.keymap.set({ "n", "x" }, "<leader>jj", function()
        msj.join()
      end, { desc = "Join arguments" })
      vim.keymap.set({ "n", "x" }, "<leader>jk", function()
        msj.split()
      end, { desc = "Split arguments" })
    end,
  },
  {
    "mcauley-penney/visual-whitespace.nvim",
    config = true,
    event = "ModeChanged *:[vV\22]", -- optionally, lazy load on entering visual mode
    opts = {
      enabled = false,
    },
  },
  -- swap arguments and things
  --     {
  --       "mizlan/iswap.nvim",
  --       event = "VeryLazy",
  --       keys = {
  --         { "<leader>il", ":ISwapNodeWithLeft<cr>", desc = "iSwap nodes with left one" },
  --         { "<leader>ir", ":ISwapNodeWithRight<cr>", desc = "iSwap nodes with right one" },
  --         { "<leader>in", ":ISwapNode<cr>", desc = "iSwap nodes (never the first)" },
  --         { "<leader>ic", ":ISwapNodeWith<cr>", desc = "iSwap current (never the first function) node with" },
  --       },
  --       opts = {
  --         keys = "arstdhneio",
  --       },
  --     },
}
