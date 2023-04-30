-- worktree settings
--require('git-worktree').setup()

-- Enable Comment.nvim
--require('Comment').setup()

return {
    -- search/replace in multiple files
    {
        "nvim-pack/nvim-spectre",
        lazy = true,
        keys = {
            --{
            --    "<leader><leader>s",
            --    ":source %<CR>",
            --},

            {
                "<leader>pR",
                function()
                    require("spectre").open_visual({ select_word = true })
                end,
                desc = "Replace current word in files (Spectre)",
            },

        },
        config = function()
            require("spectre").setup({
                  default = {
                        replace = {
                            cmd = "sd"
                       }
                    }
            })
        end,
    },
}
