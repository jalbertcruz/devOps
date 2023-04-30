return {
    {
        "AstroNvim/astrocore",
        ---@type AstroCoreOpts
        opts = { -- extend the plugin options
            diagnostics = {
                -- disable diagnostics virtual text
                --virtual_text = true,
                virtual_text = false,
            },
        },
    },
    -- customize cmp mappings
    {
        "hrsh7th/nvim-cmp",
        -- override the options table that is used
        -- in the `require("cmp").setup()` call
        opts = function(_, opts)
            -- opts parameter is the default options table
            -- the function is lazy loaded so cmp is able to be required
            local cmp = require("cmp")
            -- modify the mapping part of the table
            opts.mapping["<C-x>"] = cmp.mapping.select_next_item()
        end,
    },
    -- customize treesitter parsers
    {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
            -- list like portions of a table cannot be merged naturally and require the user to merge it manually
            -- check to make sure the key exists
            if not opts.ensure_installed then
                opts.ensure_installed = {}
            end
            vim.list_extend(opts.ensure_installed, {
                --"lua",
                "python",
                "scala",
                "sql",
                -- add more arguments for adding more treesitter parsers
            })
            opts.highlight = { enable = true }
            opts.indent = { enable = true }
            opts.incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<C-space>",
                    node_incremental = "<C-space>",
                    scope_incremental = false,
                    node_decremental = "<bs>",
                },
            }
            opts.textobjects = {
                move = {
                    enable = true,
                    goto_next_start = {
                        ["]f"] = "@function.outer",
                        ["]c"] = "@class.outer",
                        ["]a"] = "@parameter.inner"
                    },
                    goto_next_end = {
                        ["]F"] = "@function.outer",
                        ["]C"] = "@class.outer",
                        ["]A"] = "@parameter.inner"
                    },
                    goto_previous_start = {
                        ["[f"] = "@function.outer",
                        ["[c"] = "@class.outer",
                        ["[a"] = "@parameter.inner"
                    },
                    goto_previous_end = {
                        ["[F"] = "@function.outer",
                        ["[C"] = "@class.outer",
                        ["[A"] = "@parameter.inner"
                    },
                },

                select = {
                    enable = true,
                    -- Automatically jump forward to textobj, similar to targets.vim
                    lookahead = true,
                    keymaps = {
                        -- You can use the capture groups defined in textobjects.scm
                        ["af"] = "@function.outer",
                        ["if"] = "@function.inner",
                        ["acc"] = "@class.outer",
                        ["act"] = "@trait.outer",
                        -- You can optionally set descriptions to the mappings (used in the desc parameter of
                        -- nvim_buf_set_keymap) which plugins like which-key display
                        ["icc"] = { query = "@class.inner", desc = "Select inner part of a class region" },

                        ["ict"] = { query = "@trait.inner", desc = "Select inner part of a trait region" },

                        -- You can also use captures from other query groups like `locals.scm`
                        ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
                    },
                    -- You can choose the select mode (default is charwise 'v')
                    --
                    -- Can also be a function which gets passed a table with the keys
                    -- * query_string: eg '@function.inner'
                    -- * method: eg 'v' or 'o'
                    -- and should return the mode ('v', 'V', or '<c-v>') or a table
                    -- mapping query_strings to modes.
                    selection_modes = {
                        ['@parameter.outer'] = 'v', -- charwise
                        ['@trait.outer'] = 'v', -- charwise
                        ['@function.outer'] = 'V', -- linewise
                        ['@class.outer'] = '<c-v>', -- blockwise
                    },
                    -- If you set this to `true` (default is `false`) then any textobject is
                    -- extended to include preceding or succeeding whitespace. Succeeding
                    -- whitespace has priority in order to act similarly to eg the built-in
                    -- `ap`.
                    --
                    -- Can also be a function which gets passed a table with the keys
                    -- * query_string: eg '@function.inner'
                    -- * selection_mode: eg 'v'
                    -- and should return true or false
                    include_surrounding_whitespace = true,
                }

            }
        end,

        ---@param opts TSConfig
        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)

            local ts_repeat_move = require "nvim-treesitter.textobjects.repeatable_move"

            -- Repeat movement with ; and ,
            -- ensure ; goes forward and , goes backward regardless of the last direction
            vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
            vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)

            -- vim way: ; goes to the direction you were moving.
            -- vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
            -- vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

            -- Optionally, make builtin f, F, t, T also repeatable with ; and ,
            vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
            vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
            vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
            vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })

        end,
    },

    {
        "nvim-treesitter/nvim-treesitter-textobjects",
    },
    {
        "kevinhwang91/nvim-ufo",

        config = function()

            vim.o.foldcolumn = '1' -- '0' is not bad
            vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
            vim.o.foldlevelstart = 99
            vim.o.foldenable = true

            -- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
            vim.keymap.set('n', 'zO', require('ufo').openAllFolds)
            vim.keymap.set('n', 'zC', require('ufo').closeAllFolds)
            vim.keymap.set('n', 'zK', function()
                local winid = require('ufo').peekFoldedLinesUnderCursor()
                if not winid then
                    vim.lsp.buf.hover()
                end
            end)


            -- https://github.com/kevinhwang91/nvim-ufo
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities.textDocument.foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true
            }
            local language_servers = require("lspconfig").util.available_servers() -- or list servers manually like {'gopls', 'clangd'}
            for _, ls in ipairs(language_servers) do
                require('lspconfig')[ls].setup({
                    capabilities = capabilities
                    -- you can add other fields for setting up lsp server in this table
                })
            end
            require('ufo').setup()

        end,
    },
}