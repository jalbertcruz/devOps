local M = {}

local run = function(opts)
  --local bin = opts.bin
  local run_formatter = function(text, case_format)
    --local bin = os.getenv "HOME" .. "/appslnx/bin/id-format-via-python.py"
    local bin = "case-conversor"
    local j = require("plenary.job"):new({
      command = bin,
      args = {
        "-i",
        text,
        "-f",
        case_format,
      },
      --writer = { text },
      on_exit = function(j, return_val)
        --print(return_val)
      end,

      on_stderr = function(_, line)
        print(line)
      end,
    })
    return j:sync()
  end

  local enumIdText = vim.treesitter.query.parse(
    "scala",
    [[
(simple_enum_case
   (extends_clause
    (arguments (string) @enumId)
))
]]
  )

  local get_root = function(bufnr)
    local parser = vim.treesitter.get_parser(bufnr, "scala", {})
    local tree = parser:parse()[1]
    return tree:root()
  end

  local format_enums_ids = function(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    if vim.bo[bufnr].filetype ~= "scala" then
      vim.notify("can only be used in Scala")
      return
    end
    local root = get_root(bufnr)
    for id, node in enumIdText:iter_captures(root, bufnr, 0, -1) do
      local name = enumIdText.captures[id]
      if name == "enumId" then
        -- { start row, start col, end row, end col }
        local range = { node:range() }
        local formatted =
          run_formatter(string.sub(vim.treesitter.get_node_text(node, bufnr), 2, -2), "LOWER_UNDERSCORE")
        for idx, line in ipairs(formatted) do
          formatted[idx] = '"' .. line .. '"'
        end
        local allLine = vim.api.nvim_buf_get_lines(bufnr, range[1], range[1] + 1, false)[1]
        local prefix = string.sub(allLine, 1, range[2])
        local suffix = string.sub(allLine, range[4] + 1, -1)
        vim.api.nvim_buf_set_lines(bufnr, range[1], range[1] + 1, false, { prefix .. formatted[1] .. suffix })
      end
    end
  end

  -- TODO: fix the bug that is not formatting correctly when there are multiple enum cases
  format_enums_ids()
end

M.setup = function(opts)
  vim.api.nvim_create_user_command("EnumIdsFormat", function()
    run(opts)
  end, {})
end

return M
