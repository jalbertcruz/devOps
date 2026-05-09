return {
  {
    "jake-stewart/multicursor.nvim",
    branch = "1.0",
    config = function()
      local mc = require("multicursor-nvim")
      mc.setup()

      local set = vim.keymap.set

      function Toggle_multi_line()
        --vim.keymap.del("n", "<down>")
        --vim.keymap.del("n", "<up>")
        if vim.g.multi_line_active then
          map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
          map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
          vim.g.multi_line_active = false
        else
          set({ "n", "v" }, "<up>", function()
            mc.lineAddCursor(-1)
          end, { desc = "cursors up" })

          set({ "n", "v" }, "<down>", function()
            --"<down>"
            mc.lineAddCursor(1)
          end, { desc = "cursors down" })

          vim.g.multi_line_active = true
        end
      end

      set({ "n", "v" }, "gmt", Toggle_multi_line, { desc = "multi active toggle" })

      set(
        { "n", "v" },
        "<leader><up>", -- ok
        function()
          mc.lineSkipCursor(-1)
        end
      )
      set(
        { "n", "v" },
        "<leader><down>", -- ok

        function()
          mc.lineSkipCursor(1)
        end
      )

      set("n", "<c-leftmouse>", mc.handleMouse)
      set({ "n", "v" }, "<c-q>", mc.toggleCursor)

      -- Add or skip adding a new cursor by matching word/selection
      set({ "n", "v" }, "gmn", function()
        mc.matchAddCursor(1)
      end, { desc = "" })
      set({ "n", "v" }, "gms", function()
        mc.matchSkipCursor(1)
      end, { desc = "" })
      set({ "n", "v" }, "gmN", function()
        mc.matchAddCursor(-1)
      end, { desc = "" })
      set({ "n", "v" }, "gmS", function()
        mc.matchSkipCursor(-1)
      end, { desc = "" })

      -- Add all matches in the document, ok
      set({ "n", "v" }, "gmA", mc.matchAllAddCursors, { desc = "Add all matches" })

      set({ "n", "v" }, "<left>", mc.nextCursor)
      set({ "n", "v" }, "<right>", mc.prevCursor)

      -- Delete the main cursor.
      set({ "n", "v" }, "gmx", mc.deleteCursor, { desc = "Delete cursor" })

      -- Add and remove cursors with control + left click., ok
      set("n", "<c-leftmouse>", mc.handleMouse)

      -- Easy way to add and remove cursors using the main cursor., ok
      set({ "n", "v" }, "<c-q>", mc.toggleCursor)

      -- Clone every cursor and disable the originals., ok
      set({ "n", "v" }, "<leader><c-q>", mc.duplicateCursors)

      set("n", "<leader>xc", function()
        if not mc.cursorsEnabled() then
          mc.enableCursors()
        elseif mc.hasCursors() then
          mc.clearCursors()
        else
        end
      end, { desc = "Toggle cursors" })

      -- Append/insert for each line of visual selections.
      set("v", "I", mc.insertVisual)
      set("v", "A", mc.appendVisual)

      -- Customize how cursors look.
      local hl = vim.api.nvim_set_hl
      hl(0, "MultiCursorCursor", { link = "Cursor" })
      hl(0, "MultiCursorVisual", { link = "Visual" })
      hl(0, "MultiCursorSign", { link = "SignColumn" })
      hl(0, "MultiCursorDisabledCursor", { link = "Visual" })
      hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
      hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
    end,
  },
  {
    "brenoprata10/nvim-highlight-colors",
    config = function()
      require("nvim-highlight-colors").setup({})
    end,
  },
  {
    "akinsho/toggleterm.nvim",
    --enabled = false,
    version = "*",
    opts = {
      --[[ things you want to change go here]]
    },
    config = function()
      require("toggleterm").setup({
        persist_size = false,
        open_mapping = [[<c-\>]],
      })
    end,
  },
}
