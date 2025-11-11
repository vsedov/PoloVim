local types = require("luasnip.util.types")
local ls_types = require("luasnip.util.types")
local luasnip = require("luasnip")
local util = require("luasnip.util.util")
local api = vim.api
local ls = require("luasnip")
local types = require("luasnip.util.types")
local extras = require("luasnip.extras")
local fmt = require("luasnip.extras.fmt").fmt

-- require("luasnip.config").set_config({
--     -- Update more often, :h events for more info.
--     history = true,
--     updateevents = "TextChanged , TextChangedI",
-- })
require("luasnip.config").setup({
    history = true,
    enable_autosnippets = true,

    ext_opts = {
        [ls_types.choiceNode] = {
            active = {
                hl_mode = "combine",
                virt_text = { { "●", "Operator" } },
            },
        },
        [ls_types.insertNode] = {
            active = {
                hl_mode = "combine",
                virt_text = { { "●", "Type" } },
            },
        },
    },
    snip_env = {
        fmt = fmt,
        m = extras.match,
        t = ls.text_node,
        f = ls.function_node,
        c = ls.choice_node,
        d = ls.dynamic_node,
        i = ls.insert_node,
        l = extras.lamda,
        snippet = ls.snippet,
    },
    parser_nested_assembler = function(_, snippet)
        local select = function(snip, no_move)
            snip.parent:enter_node(snip.indx)
            -- upon deletion, extmarks of inner nodes should shift to end of
            -- placeholder-text.
            for _, node in ipairs(snip.nodes) do
                node:set_mark_rgrav(true, true)
            end

            -- SELECT all text inside the snippet.
            if not no_move then
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
                local pos_begin, pos_end = snip.mark:pos_begin_end()
                -- util.normal_move_on(pos_begin)
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("v", true, false, true), "n", true)
                -- util.normal_move_before(pos_end)
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("o<C-G>", true, false, true), "n", true)
            end
        end
        function snippet:jump_into(dir, no_move)
            if self.active then
                -- inside snippet, but not selected.
                if dir == 1 then
                    self:input_leave()
                    return self.next:jump_into(dir, no_move)
                else
                    select(self, no_move)
                    return self
                end
            else
                -- jumping in from outside snippet.
                self:input_enter()
                if dir == 1 then
                    select(self, no_move)
                    return self
                else
                    return self.inner_last:jump_into(dir, no_move)
                end
            end
        end

        -- this is called only if the snippet is currently selected.
        function snippet:jump_from(dir, no_move)
            if dir == 1 then
                return self.inner_first:jump_into(dir, no_move)
            else
                self:input_leave()
                return self.prev:jump_into(dir, no_move)
            end
        end

        return snippet
    end,
})
