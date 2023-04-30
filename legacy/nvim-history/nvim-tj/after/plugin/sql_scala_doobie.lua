local run_formatter = function(text)
  local split = vim.split(text, "\n")
  local result = table.concat(vim.list_slice(split, 2, #split - 1), "\n")

  -- Finds sql-format-via-python somewhere in your nvim config path
  --local bin = vim.api.nvim_get_runtime_file("~/appslnx/bin/sql-format-via-python.py", false)[1]
  local bin = os.getenv("HOME").."/appslnx/bin/sql-format-via-python.py"

  local j = require("plenary.job"):new {
    command = bin,
    args = {  },
    writer = { result },
  }
  return j:sync()
end

local embedded_sql = vim.treesitter.query.parse(
  "scala",
  [[
(interpolated_string_expression
  interpolator: (identifier) @interpolator (#eq? @interpolator "sql")

  (interpolated_string) @sql

  )
]]
)

local get_root = function(bufnr)
  local parser = vim.treesitter.get_parser(bufnr, "scala", {})
  local tree = parser:parse()[1]
  return tree:root()
end

local format_dat_sql = function(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  if vim.bo[bufnr].filetype ~= "scala" then
    vim.notify "can only be used in Scala"
    return
  end

  local root = get_root(bufnr)

  local changes = {}
  for id, node in embedded_sql:iter_captures(root, bufnr, 0, -1) do
    local name = embedded_sql.captures[id]
    if name == "sql" then
      -- { start row, start col, end row, end col }
      local range = { node:range() }
      local indentation = string.rep(" ", range[2])

      -- Run the formatter, based on the node text
      local formatted = run_formatter(vim.treesitter.get_node_text(node, bufnr))
      print(vim.inspect(formatted))

      -- Add some indentation (can be anything you like!)
      for idx, line in ipairs(formatted) do
        formatted[idx] = indentation .. line
      end

      -- Keep track of changes
      --    But insert them in reverse order of the file,
      --    so that when we make modifications, we don't have
      --    any out of date line numbers

      local startV = range[1] + 1
      local endV = range[3]
      if startV > endV then
        endV = startV
      end
      table.insert(changes, 1, {
        --start = range[1] + 1,
        --final = range[3],
        start = startV,
        final = endV,
        formatted = formatted,
      })
    end
  end

  for _, change in ipairs(changes) do
    vim.api.nvim_buf_set_lines(bufnr, change.start, change.final, false, change.formatted)
    -- error: change.start > change.final
  end
end

vim.api.nvim_create_user_command("SqlDoobie", function()
  format_dat_sql()
end, {})

-- local group = vim.api.nvim_create_augroup("rust-sql-magic", { clear = true })
-- vim.api.nvim_create_autocmd("BufWritePre", {
--   group = group,
--   pattern = "*.rs",
--   callback = function()
--     format_dat_sql()
--   end,
-- })
