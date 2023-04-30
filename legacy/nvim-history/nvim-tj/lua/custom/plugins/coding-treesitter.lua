return {

  {
    "numToStr/Comment.nvim",
    opts = {
      -- add any options here

    },
    config = function()
        require('Comment').setup()
    end
  },
  -- swap arguments and things
  {
    "mizlan/iswap.nvim",
    keys = {
      { "<leader>Sr", ":ISwapWithRight<cr>", desc = "Swap two arguments" },
      { "<leader>is", ":ISwap<cr>", desc = "Swap many arguments" },
    },
    opts = {
      keys = "arstdhneio",
    },
  },

  -- https://github.com/kylechui/nvim-surround
  -- https://github.com/kylechui/nvim-surround/blob/main/doc/nvim-surround.txt
  -- https://www.youtube.com/watch?v=96FS45IaUgo&ab_channel=NerdSignals
  {
      "kylechui/nvim-surround",
      version = "*", -- Use for stability; omit to use `main` branch for the latest features
      event = "VeryLazy",
      config = function()
          require("nvim-surround").setup({
              -- Configuration here, or leave empty to use defaults
          })
      end
  },

  -- surround
  --{
  --  "echasnovski/mini.surround",
  --  opts = {
  --    mappings = {
  --      add = "<space>sa", -- Add surrounding in Normal and Visual modes
  --      delete = "<space>sd", -- Delete surrounding
  --      find = "<space>sf", -- Find surrounding (to the right)
  --      find_left = "<space>sF", -- Find surrounding (to the left)
  --      highlight = "<space>sh", -- Highlight surrounding
  --      replace = "<space>sr", -- Replace surrounding
  --      update_n_lines = "<space>sn", -- Update `n_lines`
  --    },
  --  },
  --},

  { "echasnovski/mini.pairs", enabled = false },

  {
    "mfussenegger/nvim-treehopper",
    dependencies = {
      "smoka7/hop.nvim",
    },
    keys = {
      { "S", mode = { "n", "o", "x" }, function()
        require("tsht").nodes()
      end, desc = "Tree hopper" },
    },
    config = function()
    end,
  },

  {
    "folke/zen-mode.nvim",
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    }
  },

  {
    "folke/twilight.nvim",
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    }
  },

}
