local set = vim.keymap.set
--local k = vim.keycode

local state = {
  value = 1,
  sbt = 1,
}

set({ "n", "i" }, "<leader>gts", function()
  local Terminal = require("toggleterm.terminal").Terminal
  local term = Terminal:new({
    cmd = "fish --init-command='set DENV " .. state.sbt .. "; direnv reload'",
    display_name = "sbt " .. state.sbt,
  })
  term:toggle()
  set("n", "<leader>gtgs" .. state.sbt, function()
    term:toggle()
  end, { noremap = true, silent = true, desc = "go to scala terminal " .. state.sbt })
  state.sbt = state.sbt + 1
end, { desc = "Create terminal for sbt" })

set({ "n", "i" }, "<leader>gtc", function()
  local Terminal = require("toggleterm.terminal").Terminal
  local term = Terminal:new({
    cmd = "fish",
    display_name = "Terminal " .. state.value,
  })
  set("n", "<leader>tgt" .. state.value, function()
    term:toggle()
  end, { noremap = true, silent = true, desc = "go to scala terminal " .. state.value })
  state.value = state.value + 1
  term:toggle()
end, { desc = "Create terminal" })

set({ "n", "i" }, "<leader>gtl", "<cmd>TermSelect<cr>", { desc = "List/Select terminal" })

vim.keymap.set({ "n", "i" }, "<Left>", "<Left>", { noremap = true })
vim.keymap.set({ "n", "i" }, "<Right>", "<Right>", { noremap = true })

-- for some crazy reason I have to do this
vim.keymap.set({ "n", "i" }, "<leader><Left>", "<cmd>vertical resize -2<cr>", { noremap = true })
vim.keymap.set({ "n", "i" }, "<leader><Right>", "<cmd>vertical resize +2<cr>", { noremap = true })
