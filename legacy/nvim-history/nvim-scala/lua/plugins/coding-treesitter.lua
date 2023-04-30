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

  -- auto completion
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      local cmp = require("cmp")
      opts.mapping = cmp.mapping.preset.insert({
        ["<C-Space>"] = function()
          if cmp.visible() then
            cmp.confirm({ select = true })
          else
            cmp.complete()
          end
        end,
        ["<C-c>"] = cmp.mapping.abort(),
      })
    end,
  },

  -- surround
  {
    "echasnovski/mini.surround",
    opts = {
      mappings = {
        add = "<space>sa", -- Add surrounding in Normal and Visual modes
        delete = "<space>sd", -- Delete surrounding
        find = "<space>sf", -- Find surrounding (to the right)
        find_left = "<space>sF", -- Find surrounding (to the left)
        highlight = "<space>sh", -- Highlight surrounding
        replace = "<space>sr", -- Replace surrounding
        update_n_lines = "<space>sn", -- Update `n_lines`
      },
    },
  },

  -- 30ms of load time for not much use
  { "rafa madriz/friendly-snippets", enabled = false },
  { "garymjr/nvim-snippets", enabled = false },

  { "echasnovski/mini.pairs", enabled = false },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "scala",
        "markdown",
        "markdown_inline",
        "sql"
      },
    },
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
