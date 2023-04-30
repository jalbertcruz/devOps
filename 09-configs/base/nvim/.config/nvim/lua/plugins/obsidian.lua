local get_env_variable = require("extras.local_lib.utils").get_env_variable

--vim.opt_local.shiftwidth=4

local workspace_1 = {
  name = get_env_variable({ variable = "OBSIDIAN_WORKSPACE_1_NAME", default = "work" }),
  path = get_env_variable({ variable = "OBSIDIAN_WORKSPACE_1_PATH", default = "~/vaults/work" }),
}

local workspace_2 = {
  name = get_env_variable({ variable = "OBSIDIAN_WORKSPACE_2_NAME", default = "obsidian" }),
  path = get_env_variable({ variable = "OBSIDIAN_WORKSPACE_2_PATH", default = "~/vaults/obsidian" }),
}

local workspaces_data = {}
local expanded_path = vim.fn.expand(workspace_1.path)
if not vim.loop.fs_stat(expanded_path) then
  vim.fn.mkdir(expanded_path, "p")
end

table.insert(workspaces_data, workspace_1)

if vim.loop.fs_stat(vim.fn.expand(workspace_2.path)) then
  table.insert(workspaces_data, workspace_2)
end

return {
  {
    "obsidian-nvim/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    lazy = true,
    --enabled = false,
    ft = "markdown",
    -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
    -- event = {
    --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
    --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
    --   -- refer to `:h file-pattern` for more examples
    --   "BufReadPre path/to/my-vault/*.md",
    --   "BufNewFile path/to/my-vault/*.md",
    -- },
    dependencies = {
      -- Required.
      "nvim-lua/plenary.nvim",
      -- see below for full list of optional dependencies 👇
    },
    opts = {
      workspaces = workspaces_data,

      -- see below for full list of options 👇
    },
  },
}
