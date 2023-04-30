-- stylua: ignore
--if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

return {
  dir = "~/src/devOps/4-editors/nvim-plugins/run-cmd",
    config = function()
      require("run-cmd").setup({
        code_dir = "code",
        }
      )
    end
}
