return {
  {
    "stevearc/aerial.nvim",
    event = "LazyFile",
    opts = function()
      local opts = {

        layout = {
          default_direction = "prefer_left",
        },
      }
      return opts
    end,
  },
}
