

local data = assert(vim.fn.stdpath "data") --[[@as string]]

require("telescope").setup {
  extensions = {
    wrap_results = true,

    fzf = {},
    history = {
      path = vim.fs.joinpath(data, "telescope_history.sqlite3"),
      limit = 100,
    },
    ["ui-select"] = {
      require("telescope.themes").get_dropdown {},
    },
  },
}

pcall(require("telescope").load_extension, "smart_history")
pcall(require("telescope").load_extension, "ui-select")

local builtin = require "telescope.builtin"

vim.keymap.set("n", "<space>fd", builtin.find_files)
vim.keymap.set("n", "<space>ft", builtin.git_files)
vim.keymap.set("n", "<space>fh", builtin.help_tags)
vim.keymap.set("n", "<space>fgg", builtin.live_grep)
vim.keymap.set("n", "<space>fk", builtin.keymaps)
vim.keymap.set("n", "<space>fq", builtin.quickfix)
vim.keymap.set("n", "<space>/", builtin.current_buffer_fuzzy_find)

-- find words under cursor
vim.keymap.set("n", "<space>gw", function() builtin.grep_string({ word_match = "-w" }) end, {})
--vim.keymap.set("n", "<space>gw", function() builtin.grep_string() end, {})

-- https://www.reddit.com/r/neovim/comments/yv9iy0/how_to_include_options_in_telescope_builtins/
--vim.keymap.set("n", "<my key map>", function() builtin.find_files({ no_ignore = true }) end, {})

vim.keymap.set("n", "<space>fa", function()
  ---@diagnostic disable-next-line: param-type-mismatch
  builtin.find_files { cwd = vim.fs.joinpath(vim.fn.stdpath "data", "lazy") }
end)

vim.keymap.set("n", "<space>en", function()
  builtin.find_files { cwd = "~/src/devOps/setup/nvim-tj/.config/nvim/" }
end)

vim.keymap.set("n", "<space>eo", function()
  builtin.find_files { cwd = "~/.config/nvim-backup/" }
end)
