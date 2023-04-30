local M = {}

function M.check_variable(params)
  local activate = vim.fn.getenv(params.variable)
  local default = (activate == vim.NIL or activate == "")
  if default then
    if params.default then
      return params.default
    else
      return false
    end
  end
  return activate == "true"
end

function M.get_env_variable(params)
  local value = vim.fn.getenv(params.variable)
  local default = (value == vim.NIL or value == "")
  if default then
    return params.default
  end
  return value
end

function M.read_cli_output_to_table(command)
  local handle = io.popen(command)
  local result = {}

  if handle then
    for line in handle:lines() do
      table.insert(result, line)
    end
    handle:close()
  end

  return result
end

return M
