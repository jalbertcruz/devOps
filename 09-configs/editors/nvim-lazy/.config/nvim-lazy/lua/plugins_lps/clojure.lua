
if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- https://github.com/rafaeldelboni/cajus-nfnl

local lisp_dialects = { "clojure", "fennel" }
return {

    {
        "Olical/conjure",
        filetype = lisp_dialects,
        config = function()
            -- Let LSP do documentation and jump definitions
            -- For SEXP (Turn off jumping in insert mode)
            vim.cmd([[
        let g:conjure#mapping#doc_word = v:false
        let g:conjure#mapping#def_word = v:false
        let g:sexp_enable_insert_mode_mappings = 0
      ]])
            -- clojure/astro/lua/plugins/clojure.lua
            -- Width of HUD as percentage of the editor width between 0.0 and 1.0. Default: `0.42`
            vim.cmd([[
        let g:conjure#log#hud#width = 1
      ]])
            -- Display HUD (REPL log). Default: `true`
            vim.cmd([[
        let g:conjure#log#hud#enabled = v:false
      ]])
            -- HUD corner position (over-ridden by HUD cursor detection). Default: `"NE"`
            -- Example: Set to `"SE"` and HUD width to `1.0` for full width HUD at bottom of screen
            vim.cmd([[
        let g:conjure#log#hud#anchor = "SE"
      ]])
            -- Open log at bottom or far right of editor, using full width or height. Default: `false`
            vim.cmd([[
        let g:conjure#log#botright = v:true
      ]])
            -- Lines from top of file to check for `ns` form, to sett evaluation context Default: `24`
            -- `b:conjure#context` to override a specific buffer that isn't finding the context
            vim.cmd([[
        let g:conjure#extract#context_header_lines = 100
      ]])
            -- comment pattern for eval to comment command
            vim.cmd([[
        let g:conjure#eval#comment_prefix = ";; "
      ]])
            -- Hightlight evaluated forms
            vim.cmd([[
        let g:conjure#highlight#enabled = v:true
      ]])
            -- Start "auto-repl" process when nREPL connection not found, e.g. babashka. ;; Default: `true`
            vim.cmd([[
        let g:conjure#client#clojure#nrepl#connection#auto_repl#enabled = v:false
      ]])
            -- Hide auto-repl buffer when triggered. Default: `false`
            vim.cmd([[
        let g:conjure#client#clojure#nrepl#connection#auto_repl#hidden = v:true
      ]])
            -- Command to start the auto-repl. Default: `"bb nrepl-server localhost:8794"`
            vim.cmd([[
        let g:conjure#client#clojure#nrepl#connection#auto_repl#cmd = ""
      ]])
            -- Ensure namespace required after REPL connection. Default: `true`
            vim.cmd([[
        let g:conjure#client#clojure#nrepl#eval#auto_require = v:false
      ]])
            -- suppress `; (out)` prefix in log evaluation results
            vim.cmd([[
        let g:conjure#client#clojure#nrepl#eval#raw_out = v:true
      ]])
            -- test runner "clojure" (clojure.test) "clojurescript" (cljs.test) "kaocha"
            vim.cmd([[
        let g:conjure#client#clojure#nrepl#test#runner = "clojure"
      ]])

            vim.keymap.set("n", "<localleader>T", ":ConjureEvalRootForm<CR> <bar> :ConjureCljRunCurrentTest<CR>")
            vim.keymap.set("n", "<localleader>tfr", ":ConjureEvalBuf<CR> <bar> :ConjureCljRunCurrentTest<CR>")
        end,
    },
 {
    "PaterJason/cmp-conjure",
    lazy = true,
    config = function()
      local cmp = require("cmp")
      local config = cmp.get_config()
      table.insert(config.sources, { name = "conjure" })
      return cmp.setup(config)
    end,
  },

  -- As an example, we can change the default prefix from `<localleader>` to `,c`
  -- with the following command:
  --
  --     :let g:conjure#mapping#prefix = ",c"
  --
  -- All mappings are prefixed by this by default. To have a mapping work without
  -- the prefix simply wrap the string in a list.
  --
  --     :let g:conjure#mapping#log_split = ["ClS"]
  --
  -- Now you can hit `ClS` without a prefix in any buffer Conjure has a client for.
  --
  -- You can disable a mapping entirely by setting it to `v:false` like so.
  --
  --     :let g:conjure#mapping#doc_word = v:false
  --
  -- These need to be set before you enter a relevant buffer since the mappings are
  -- defined as you enter a buffer and can't be altered after the fact.
  --
  -- Tip: Booleans in Vim Script are written as `v:true` and `v:false`.
  {
    -- https://github.com/Olical/nfnl
    "Olical/nfnl",
    ft = "fennel",
    init = function()
      --       require("config")
    end,
  },
  {
    -- https://github.com/julienvincent/nvim-paredit?tab=readme-ov-file#configuration
    "julienvincent/nvim-paredit",
    filetype = lisp_dialects,
    config = function()
      require("nvim-paredit").setup()
    end,
  },
  {
     "windwp/nvim-autopairs",
      -- dir = "~/src/clojure/poc/nvim-autopairs",
    event = "InsertEnter",
    config = true,
    filetype = lisp_dialects,
    -- use opts = {} for passing setup options
    -- this is equivalent to setup({}) function
    opts = {
      enable_check_bracket_line = false,
      map_bs = true, -- map the <BS> key
       --map_c_h = true, -- Map the <C-h> key to delete a pair
--       map_c_w = true, -- map <c-w> to delete a pair if possible
       fast_wrap = {},
    },
    config = function(_, opts)
      local config = require("nvim-autopairs")
      config.setup(opts)
    end,
  },
  {
    "HiPhish/rainbow-delimiters.nvim",
  },
  --   {
  --     "gpanders/nvim-parinfer",
  --     filetype = lisp_dialects,
  --   },
}
