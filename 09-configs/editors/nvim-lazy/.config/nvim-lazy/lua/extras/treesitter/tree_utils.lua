-- Function to list all installed Tree-sitter parsers and export to a text file
local function export_installed_parsers_to_text()
  local env_var = "PARSERS_FILE_PATH"
  local file_path = vim.fn.getenv(env_var)
  if file_path == vim.NIL or file_path == "" then
    print("Environment variable " .. env_var .. " is not set or empty")
    return
  end

  local file = io.open(file_path, "w")
  if not file then
    print("Failed to open parsers file: " .. file_path)
    return
  end

  local parsers = require("nvim-treesitter.parsers").get_parser_configs()
  local installed_parsers = {}

  for parser_name, _ in pairs(parsers) do
    table.insert(installed_parsers, parser_name)
  end

  file:write("Installed Tree-sitter parsers:\n")
  for _, parser in ipairs(installed_parsers) do
    file:write(parser .. "\n")
  end

  file:close()
  print("Parsers exported to: " .. file_path)
end

-- Create a custom command to export installed parsers
vim.api.nvim_create_user_command("ExportParsersText", export_installed_parsers_to_text, {})

local function replace_node_with_env_vars()
  -- Retrieve the paths to the Treesitter query and new text files from environment variables
  local query_file_path = vim.fn.getenv("TREESITTER_QUERY_PATH")
  local new_text_file_path = vim.fn.getenv("NEW_TEXT_PATH")

  if
    query_file_path == vim.NIL
    or query_file_path == ""
    or new_text_file_path == vim.NIL
    or new_text_file_path == ""
  then
    print("Environment variables TREESITTER_QUERY_PATH or NEW_TEXT_PATH are not set or empty")
    return
  end

  -- Read the content of the query file
  local query_file = io.open(query_file_path, "r")
  if not query_file then
    print("Failed to open query file: " .. query_file_path)
    return
  end
  local query_str = query_file:read("*a")
  query_file:close()

  -- Read the content of the new text file
  local new_text_file = io.open(new_text_file_path, "r")
  if not new_text_file then
    print("Failed to open new text file: " .. new_text_file_path)
    return
  end
  local new_text = new_text_file:read("*a")
  new_text_file:close()

  -- Parse the Treesitter query
  local query = vim.treesitter.query.parse("scala", query_str)

  -- Get the current buffer and parse the syntax tree
  local bufnr = vim.api.nvim_get_current_buf()
  local parser = vim.treesitter.get_parser(bufnr, "scala")
  local tree = parser:parse()[1]
  local root = tree:root()

  -- Function to replace the text of a node
  local function replace_node(bufnr, old_node, new_text)
    local start_row, start_col, end_row, end_col = old_node:range()
    vim.api.nvim_buf_set_text(bufnr, start_row, start_col, end_row, end_col, vim.split(new_text, "\n"))
  end

  -- Find the node to replace using the query
  for id, node in query:iter_captures(root, bufnr, 0, -1) do
    replace_node(bufnr, node, new_text)
    break
  end
end

vim.api.nvim_create_user_command("ReplaceNode", replace_node_with_env_vars, {})
