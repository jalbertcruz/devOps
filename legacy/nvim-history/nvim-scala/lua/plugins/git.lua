return {
 --{
 --   'polarmutex/git-worktree.nvim',
 --    config = function()
 --    end
 --},
 {
  "NeogitOrg/neogit",
  dependencies = {
   "nvim-lua/plenary.nvim",         -- required
   "sindrets/diffview.nvim",        -- optional - Diff integration

   -- Only one of these is needed, not both.
   "nvim-telescope/telescope.nvim", -- optional
  },
      config = function()
       require('neogit').setup({})
       vim.keymap.set("n", "<leader>G", "<CMD>Neogit<CR>", silent)
      end
 },
 {'lewis6991/gitsigns.nvim'},
}
