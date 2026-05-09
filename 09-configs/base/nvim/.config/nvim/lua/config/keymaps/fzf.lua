local set = vim.keymap.set
local k = vim.keycode

set("n", "<leader>fw", function()
  require("fzf-lua").live_grep_glob()
  -- https://github.com/ibhagwan/fzf-lua/blob/8330321fa135f7fa9e4855099026c4ad622a0c85/lua/fzf-lua/providers/grep.lua#L43
end, { noremap = true, silent = true, desc = "Grep blob (Root dir)" })

set("n", "<leader>fW", function()
  local buf_path = vim.api.nvim_buf_get_name(0)
  local buf_dir = vim.fn.fnamemodify(buf_path, ":p:h")
  require("fzf-lua").live_grep_glob({ cwd = buf_dir })
end, { noremap = true, silent = true, desc = "Grep blob (Buf dir)" })

set("n", "<leader>fds", function()
  require("fzf-lua").files({ cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy") })
end, { noremap = true, silent = true, desc = "nvim-lua std files" })

set("n", "<leader>fdl", function()
  require("fzf-lua").live_grep_glob({
    cwd = vim.fn.expand("$HOME/.config/nvim"),
  })
end, {
  desc = "nvim-lua files",
})

set("n", "<leader>fdd", function()
  local env_var = "DEVOPS_CONFIG_PATH"
  local file_path = vim.fn.getenv(env_var)
  if file_path == "" then
    print("Environment variable " .. env_var .. " is not set or empty")
    return
  end
  require("fzf-lua").live_grep_glob({ cwd = file_path })
  --require("fzf-lua").files({ cwd = file_path })
end, {
  --desc = "find files in devOps repo"
  desc = "devOps repo",
})

set("n", "<leader>fdp", function()
  require("fzf-lua").live_grep_glob({
    cwd = ".venv/lib",
  })
end, {
  --desc = "find files in Python virtual env packages"
  desc = "Python libs content",
})

set("n", "<leader>sB", function()
  require("fzf-lua").lines()
end, { noremap = true, silent = true, desc = "Grep Open Buffers" })
