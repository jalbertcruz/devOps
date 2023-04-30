require("luasnip.session.snippet_collection").clear_snippets("scala")

local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local extras = require("luasnip.extras")
local l = extras.lambda
local rep = extras.rep
local p = extras.partial
local m = extras.match
local n = extras.nonempty
local dl = extras.dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local conds = require("luasnip.extras.expand_conditions")
local postfix = require("luasnip.extras.postfix").postfix
local types = require("luasnip.util.types")
local parse = require("luasnip.util.parser").parse_snippet
local ms = ls.multi_snippet
local k = require("luasnip.nodes.key_indexer").new_key

-- https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md#adding-snippets
-- https://github.com/L3MON4D3/LuaSnip/blob/master/Examples/snippets.lua
-- https://github.com/L3MON4D3/LuaSnip

ls.setup({
  keep_roots = true,
  link_roots = true,
  link_children = true,

  -- Update more often, :h events for more info.
  update_events = "TextChanged,TextChangedI",
  -- Snippets aren't automatically removed if their text is deleted.
  -- `delete_check_events` determines on which events (:h events) a check for
  -- deleted snippets is performed.
  -- This can be especially useful when `history` is enabled.
  delete_check_events = "TextChanged",
  ext_opts = {
    [types.choiceNode] = {
      active = {
        virt_text = { { "choiceNode", "Comment" } },
      },
    },
  },
  -- treesitter-hl has 100, use something higher (default is 200).
  ext_base_prio = 300,
  -- minimal increase in priority.
  ext_prio_increase = 1,
  enable_autosnippets = true,
  -- mapping for cutting selected text so it's usable as SELECT_DEDENT,
  -- SELECT_RAW or TM_SELECTED_TEXT (mapped via xmap).
  store_selection_keys = "<Tab>",
  -- luasnip uses this function to get the currently active filetype. This
  -- is the (rather uninteresting) default, but it's possible to use
  -- eg. treesitter for getting the current filetype by setting ft_func to
  -- require("luasnip.extras.filetype_functions").from_cursor (requires
  -- `nvim-treesitter/nvim-treesitter`). This allows correctly resolving
  -- the current filetype in eg. a markdown-code block or `vim.cmd()`.
  ft_func = function()
    return vim.split(vim.bo.filetype, ".", true)
  end,
})

-- Maps a node type to a handler function.
local simple_enum_case_handlers = {
  identifier = function(node, info)
    local text = vim.treesitter.get_node_text(node, 0)
    return {
      t(string.format(' extends %s("%s")', text, info.label_name)),
    }
  end,
}

--- Gets the corresponding enum type name based on the
--- current enum label context of the cursor.
---@param info table
local function scala_enum_name_value(info)
  local function_node_types = {
    enum_definition = true,
  }

  -- Find the first function node that's a parent of the cursor
  local node = vim.treesitter.get_node()
  while node ~= nil do
    if function_node_types[node:type()] then
      break
    end

    node = node:parent()
  end

  -- Exit if no match
  if not node then
    --vim.notify("Not inside of an enum definition")
    return t("")
  end

  -- This file is in `queries/go/return-snippet.scm`
  --local query = assert(vim.treesitter.query.get("scala", "enum-definition-snippet"), "No query")
  local query = vim.treesitter.query.parse(
    "scala",
    [[
                (enum_definition
                name: (identifier) @enumDefName
                  )
          ]]
  )
  for _, capture in query:iter_captures(node, 0) do
    if simple_enum_case_handlers[capture:type()] then
      return simple_enum_case_handlers[capture:type()](capture, info)
    end
  end
end

local simple_enum_case_value = function(args)
  return sn(
    nil,
    scala_enum_name_value({
      label_name = args[1][1],
    })
  )
end

ls.add_snippets("scala", {
  s(
    "c",
    fmta(
      [[
              case <label> <result>
              <finish>
              ]],
      {
        label = i(1),
        result = d(2, simple_enum_case_value, { 1 }),
        finish = i(0),
      }
    )
  ),
})

local rec_next_case
rec_next_case = function()
  return sn(
    nil,
    c(1, {
      t(""),

      sn(nil, {
        t({ "", "  case " }),
        i(1),

        d(2, simple_enum_case_value, { 1 }),

        d(3, rec_next_case, {}),
      }),
    })
  )
end

local rec_next_case2
rec_next_case2 = function(args)
  return sn(
    nil,
    c(1, {
      t(""),
      sn(nil, {
        t({ "  case " }),
        i(1),

        d(2, simple_enum_case_value, { 1 }),

        d(3, rec_next_case, {}),
      }),
    })
  )
end

ls.add_snippets("scala", {

  s(
    "e",
    fmta(
      [[
                    enum <primero> (id: String):
                    <next>
                    <finish>
                    ]],
      {
        primero = i(1),
        next = d(2, rec_next_case2, {}),
        finish = i(0),
      }
    )
  ),
}, {})
