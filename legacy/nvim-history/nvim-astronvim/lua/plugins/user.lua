--if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- You can also add or configure plugins by creating files in this `plugins/` folder
-- Here are some examples:

---@type LazySpec
return {

    {
        "folke/flash.nvim",
        event = "VeryLazy",
        ---@type Flash.Config
        opts = {
            jump = {
                autojump = true,
            },
            modes = {
                char = {
                    jump_labels = true,
                    multi_line = false,
                }
            }
        },
        -- stylua: ignore
        keys = {
            { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
            { "S",     mode = { "n" },           function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
            { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
            { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
            { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
        },
    },

    {
        "voldikss/vim-floaterm",
        config = function()
            vim.keymap.set(
                    "n",
                    "<leader>ftt",
                    "<cmd>:FloatermNew --height=0.7 --width=0.8 --wintype=float --name=floaterm1 --position=center --autoclose=2<CR>",
                    { desc = "Open FloatTerm" }
            )
            vim.keymap.set("n", "<leader>tt", "<cmd>:FloatermToggle<CR>", { desc = "Toggle FloatTerm" })
            vim.keymap.set("t", "<leader>tt", "<cmd>:FloatermToggle<CR>", { desc = "Toggle FloatTerm" })
        end,
    },

    -- Autoformatting MINE
    { "lukas-reineke/lsp-format.nvim", enabled = true },

    {
        "okuuva/auto-save.nvim",
        version = '^1.0.0', -- see https://devhints.io/semver, alternatively use '*' to use the latest tagged release
        cmd = "ASToggle", -- optional for lazy loading on command
        event = { "InsertLeave", "TextChanged" }, -- optional for lazy loading on trigger events
        keys = {
            { "<leader>n", ":ASToggle<CR>", desc = "Toggle auto-save" },
        },
        opts = {
            -- your config goes here
            -- or just leave it empty :)
        },
    },

    {
        "AckslD/nvim-neoclip.lua",
        dependencies = {
            { "nvim-telescope/telescope.nvim" },
        },
        config = function()
            require("neoclip").setup({
                history = 1000,
                enable_persistent_history = false,
                length_limit = 1048576,
                continuous_sync = false,
                db_path = vim.fn.stdpath("data") .. "/databases/neoclip.sqlite3",
                filter = nil,
                preview = true,
                prompt = nil,
                default_register = '"',
                --default_register = 'unnamedplus',
                default_register_macros = "q",
                enable_macro_history = true,
                content_spec_column = false,
                disable_keycodes_parsing = false,
                on_select = {
                    move_to_front = false,
                    close_telescope = true,
                },
                on_paste = {
                    set_reg = false,
                    move_to_front = false,
                    close_telescope = true,
                },
                on_replay = {
                    set_reg = false,
                    move_to_front = false,
                    close_telescope = true,
                },
                on_custom_action = {
                    close_telescope = true,
                },
                keys = {
                    telescope = {
                        i = {
                            select = "<cr>",
                            paste = "<c-j>",
                            paste_behind = "<c-k>",
                            replay = "<c-q>", -- replay a macro
                            delete = "<c-d>", -- delete an entry
                            edit = "<c-e>", -- edit an entry
                            custom = {},
                        },
                        n = {
                            select = "<cr>",
                            paste = "p",
                            --- It is possible to map to more than one key.
                            -- paste = { 'p', '<c-p>' },
                            paste_behind = "P",
                            replay = "q",
                            delete = "d",
                            edit = "e",
                            custom = {},
                        },
                    },
                },
            })

            vim.keymap.set("n", "<leader>o", "<cmd>Telescope neoclip<CR>", { desc = "Telescope Neoclip" })
        end,
    },

    { 'folke/neodev.nvim', opts = {} },

    --{
    --    "nvim-treesitter/nvim-treesitter-context",
    --    config = function()
    --        require("treesitter-context").setup({
    --            max_lines = 5,
    --        })
    --    end,
    --},

}
