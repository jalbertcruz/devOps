return {
    dir = "~/src/devOps/editors/nvim-plugins/run-cmd",
    config = function()
      require("run-cmd").setup({
        code_dir = "code",
        }
      )
    end
}