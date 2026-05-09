vim.api.nvim_create_user_command("SearchInAll", function(opts)
  local command = "_projects-names"
  local output_table = require("extras.local_lib.utils").read_cli_output_to_table(command)
  require("fzf-lua").fzf_exec(output_table, {
    actions = {
      ["default"] = function(selected, o)
        local file_path = vim.fn.system('_project-path "' .. selected[1] .. '"')
        require("fzf-lua").live_grep_glob({ cwd = file_path })
      end,
    },
  })
end, {})
