return {
  {
    "folke/snacks.nvim",
    opts = {
      bigfile = {
        enabled = false,
        notify = true,
        --         line_length = 1000,
        line_length = 1000 * 1000,
        size = 1.5 * 1024 * 1024, -- 1.5MB
      },
      picker = {
        --         hidden = true,
        --         ignored = true,
        hidden = false,
        ignored = false,
        sources = {
          files = {
            hidden = true,
            ignored = true,
            -- exclude = {
            -- "**/.git/*",
            --},
          },
        },
      },
      quickfile = { enabled = true },
      terminal = {
        win = {
          keys = {
            --nav_h = { "<C-h>", term_nav("h"), desc = "Go to Left Window", expr = true, mode = "t" },
            --nav_j = { "<C-j>", term_nav("j"), desc = "Go to Lower Window", expr = true, mode = "t" },
            --nav_k = { "<C-k>", term_nav("k"), desc = "Go to Upper Window", expr = true, mode = "t" },
            --nav_l = { "<C-l>", term_nav("l"), desc = "Go to Right Window", expr = true, mode = "t" },
          },
        },
      },
      image = {
        resolve = function(path, src)
          if require("obsidian.api").path_is_note(path) then
            return require("obsidian.api").resolve_image_path(src)
          end
        end,
      },
    },
  -- stylua: ignore
  keys = {
    --{ "<leader>.",  function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
    --{ "<leader>S",  function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
    --{ "<leader>dps", function() Snacks.profiler.scratch() end, desc = "Profiler Scratch Buffer" },
  },
  },
}
