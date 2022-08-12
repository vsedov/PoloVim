local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local l = require("luasnip.extras").lambda
local r = require("luasnip.extras").rep
local p = require("luasnip.extras").partial
local m = require("luasnip.extras").match
local n = require("luasnip.extras").nonempty
local dl = require("luasnip.extras").dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local types = require("luasnip.util.types")
-- local conds = require("luasnip.extras.conditions")

local has_treesitter, ts = pcall(require, "vim.treesitter")
local _, query = pcall(require, "vim.treesitter.query")

local MATH_ENVIRONMENTS = {
    displaymath = true,
    eqnarray = true,
    equation = true,
    math = true,
    array = true,
}
local MATH_NODES = {
    displayed_equation = true,
    inline_formula = true,
}

local function get_node_at_cursor()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local cursor_range = { cursor[1] - 1, cursor[2] }
    local buf = vim.api.nvim_get_current_buf()
    local ok, parser = pcall(ts.get_parser, buf, "latex")
    if not ok or not parser then
        return
    end
    local root_tree = parser:parse()[1]
    local root = root_tree and root_tree:root()

    if not root then
        return
    end

    return root:named_descendant_for_range(cursor_range[1], cursor_range[2], cursor_range[1], cursor_range[2])
end

local utils = {}
-- Returns a snippet_node wrapped around an insert_node whose initial
-- text value is set to the current date in the desired format.
utils.date_input = function(args, state, fmt)
    local fmt = fmt or "%Y-%m-%d"
    return sn(nil, i(1, os.date(fmt)))
end

-- Make sure to not pass an invalid command, as io.popen() may write over nvim-text.
-- $(git config github.user)
utils.bash = function(_, _, command)
    local file = io.popen(command, "r")
    local res = {}
    for line in file:lines() do
        table.insert(res, line)
    end
    return res
end
utils.part = function(func, ...)
    local args = { ... }
    return function()
        return func(unpack(args))
    end
end

utils.pair = function(pair_begin, pair_end, expand_func, ...)
    return s(
        { trig = pair_begin, wordTrig = false },
        { t({ pair_begin }), i(1), t({ pair_end }) },
        { condition = utils.part(expand_func, utils.part(..., pair_begin, pair_end)) }
    )
end

-- complicated function for dynamicNode.
utils.jdocsnip = function(args, _, old_state)
    local nodes = {
        t({ "/**", " * " }),
        i(1, "A short Description"),
        t({ "", "" }),
    }

    -- These will be merged with the snippet; that way, should the snippet be updated,
    -- some user input eg. text can be referred to in the new snippet.
    local param_nodes = {}

    if old_state then
        nodes[2] = i(1, old_state.descr:get_text())
    end
    param_nodes.descr = nodes[2]

    -- At least one param.
    if string.find(args[2][1], ", ") then
        vim.list_extend(nodes, { t({ " * ", "" }) })
    end

    local insert = 2
    for indx, arg in ipairs(vim.split(args[2][1], ", ", true)) do
        -- Get actual name parameter.
        arg = vim.split(arg, " ", true)[2]
        if arg then
            local inode
            -- if there was some text in this parameter, use it as static_text for this new snippet.
            if old_state and old_state[arg] then
                inode = i(insert, old_state["arg" .. arg]:get_text())
            else
                inode = i(insert)
            end
            vim.list_extend(nodes, { t({ " * @param " .. arg .. " " }), inode, t({ "", "" }) })
            param_nodes["arg" .. arg] = inode

            insert = insert + 1
        end
    end

    if args[1][1] ~= "void" then
        local inode
        if old_state and old_state.ret then
            inode = i(insert, old_state.ret:get_text())
        else
            inode = i(insert)
        end

        vim.list_extend(nodes, { t({ " * ", " * @return " }), inode, t({ "", "" }) })
        param_nodes.ret = inode
        insert = insert + 1
    end

    if vim.tbl_count(args[3]) ~= 1 then
        local exc = string.gsub(args[3][2], " throws ", "")
        local ins
        if old_state and old_state.ex then
            ins = i(insert, old_state.ex:get_text())
        else
            ins = i(insert)
        end
        vim.list_extend(nodes, { t({ " * ", " * @throws " .. exc .. " " }), ins, t({ "", "" }) })
        param_nodes.ex = ins
        insert = insert + 1
    end

    vim.list_extend(nodes, { t({ " */" }) })

    local snip = sn(nil, nodes)
    -- Error on attempting overwrite.
    snip.old_state = param_nodes
    return snip
end

-- TODO: convert to lua
-- complicated function for dynamicNode.
utils.luadocsnip = function(args, _, old_state)
    local nodes = {
        t({ "/**", " * " }),
        i(1, "A short Description"),
        t({ "", "" }),
    }

    -- These will be merged with the snippet; that way, should the snippet be updated,
    -- some user input eg. text can be referred to in the new snippet.
    local param_nodes = {}

    if old_state then
        nodes[2] = i(1, old_state.descr:get_text())
    end
    param_nodes.descr = nodes[2]

    -- At least one param.
    if string.find(args[2][1], ", ") then
        vim.list_extend(nodes, { t({ " * ", "" }) })
    end

    local insert = 2
    for indx, arg in ipairs(vim.split(args[2][1], ", ", true)) do
        -- Get actual name parameter.
        arg = vim.split(arg, " ", true)[2]
        if arg then
            local inode
            -- if there was some text in this parameter, use it as static_text for this new snippet.
            if old_state and old_state[arg] then
                inode = i(insert, old_state["arg" .. arg]:get_text())
            else
                inode = i(insert)
            end
            vim.list_extend(nodes, { t({ " * @param " .. arg .. " " }), inode, t({ "", "" }) })
            param_nodes["arg" .. arg] = inode

            insert = insert + 1
        end
    end

    if args[1][1] ~= "void" then
        local inode
        if old_state and old_state.ret then
            inode = i(insert, old_state.ret:get_text())
        else
            inode = i(insert)
        end

        vim.list_extend(nodes, { t({ " * ", " * @return " }), inode, t({ "", "" }) })
        param_nodes.ret = inode
        insert = insert + 1
    end

    if vim.tbl_count(args[3]) ~= 1 then
        local exc = string.gsub(args[3][2], " throws ", "")
        local ins
        if old_state and old_state.ex then
            ins = i(insert, old_state.ex:get_text())
        else
            ins = i(insert)
        end
        vim.list_extend(nodes, { t({ " * ", " * @throws " .. exc .. " " }), ins, t({ "", "" }) })
        param_nodes.ex = ins
        insert = insert + 1
    end

    vim.list_extend(nodes, { t({ " */" }) })

    local snip = sn(nil, nodes)
    -- Error on attempting overwrite.
    snip.old_state = param_nodes
    return snip
end

-- complicated function for dynamicNode.
utils.cppdocsnip = function(args, _, old_state)
    dump(args)
    -- !!! old_state is used to preserve user-input here. DON'T DO IT THAT WAY!
    -- Using a restoreNode instead is much easier.
    -- View this only as an example on how old_state functions.
    local nodes = {
        t({ "/**", " * " }),
        i(1, "A short Description"),
        t({ "", "" }),
    }

    -- These will be merged with the snippet; that way, should the snippet be updated,
    -- some user input eg. text can be referred to in the new snippet.
    local param_nodes = {}

    if old_state then
        nodes[2] = i(1, old_state.descr:get_text())
    end
    param_nodes.descr = nodes[2]

    -- At least one param.
    if string.find(args[2][1], ", ") then
        vim.list_extend(nodes, { t({ " * ", "" }) })
    end

    local insert = 2
    for indx, arg in ipairs(vim.split(args[2][1], ", ", true)) do
        -- Get actual name parameter.
        arg = vim.split(arg, " ", true)[2]
        if arg then
            local inode
            -- if there was some text in this parameter, use it as static_text for this new snippet.
            if old_state and old_state[arg] then
                inode = i(insert, old_state["arg" .. arg]:get_text())
            else
                inode = i(insert)
            end
            vim.list_extend(nodes, { t({ " * @param " .. arg .. " " }), inode, t({ "", "" }) })
            param_nodes["arg" .. arg] = inode

            insert = insert + 1
        end
    end

    if args[1][1] ~= "void" then
        local inode
        if old_state and old_state.ret then
            inode = i(insert, old_state.ret:get_text())
        else
            inode = i(insert)
        end

        vim.list_extend(nodes, { t({ " * ", " * @return " }), inode, t({ "", "" }) })
        param_nodes.ret = inode
        insert = insert + 1
    end

    if vim.tbl_count(args[3]) ~= 1 then
        local exc = string.gsub(args[3][2], " throws ", "")
        local ins
        if old_state and old_state.ex then
            ins = i(insert, old_state.ex:get_text())
        else
            ins = i(insert)
        end
        vim.list_extend(nodes, { t({ " * ", " * @throws " .. exc .. " " }), ins, t({ "", "" }) })
        param_nodes.ex = ins
        insert = insert + 1
    end

    vim.list_extend(nodes, { t({ " */" }) })

    local snip = sn(nil, nodes)
    -- Error on attempting overwrite.
    snip.old_state = param_nodes
    return snip
end

utils.env = function(name)
    local x, y = unpack(vim.fn["vimtex#env#is_inside"](name))
    return x ~= "0" and y ~= "0"
end
utils.comment = function()
    return vim.fn["vimtex#syntax#in_comment"]() == 1
    -- return in_comment()
end

utils.not_math = function()
    return not utils.is_math()
end
utils.is_math = function()
    return vim.fn["vimtex#syntax#in_mathzone"]() == 1
    -- return in_mathzone()
end

utils.no_backslash = function(line_to_cursor, matched_trigger)
    local start = line_to_cursor:find(matched_trigger .. "$")
    return not line_to_cursor:match("\\" .. matched_trigger, start - 1)
end

utils.pipe = function(fns)
    return function(...)
        for _, fn in ipairs(fns) do
            if not fn(...) then
                return false
            end
        end

        return true
    end
end

-- TODO: Update this with TS support
function utils.get_comment(text)
    vim.validate({
        text = {
            text,
            function(x)
                return not x or type(x) == type("") or vim.tbl_islist(x)
            end,
            "text must be either a string or an array of lines",
        },
    })
    local comment = vim.opt_local.commentstring:get()
    if not comment:match("%s%%s") then
        comment = comment:format(" %s")
    end
    local comment_str
    if text then
        if vim.tbl_islist(text) then
            comment_str = {}
            for _, line in ipairs(text) do
                table.insert(comment_str, comment:format(line))
            end
            comment_str = table.concat(comment_str, "\n")
        else
            comment_str = comment:format(text)
        end
    end
    return comment_str or comment
end

function utils.saved_text(args, snip, old_state, user_args)
    local nodes = {}
    old_state = old_state or {}
    user_args = user_args or {}

    local indent = user_args.indent and "\t" or ""

    if snip.snippet.env and snip.snippet.env.SELECT_DEDENT and #snip.snippet.env.SELECT_DEDENT > 0 then
        local lines = vim.deepcopy(snip.snippet.env.SELECT_DEDENT)
        -- local indent_level = require'utils.buffers'.get_indent_block_level(lines)
        -- lines = require'utils.buffers'.indent(lines, -indent_level)
        -- TODO: We may need to use an indent indepente node to avoid indenting empty lines
        for idx = 1, #lines do
            local line = indent .. lines[idx]
            local node = idx == #lines and { line } or { line, "" }
            table.insert(nodes, t(node))
        end
    else
        local text = user_args.text or utils.get_comment("code")
        if indent ~= "" then
            table.insert(nodes, t(indent))
        end
        table.insert(nodes, i(1, text))
    end

    local snip_node = sn(nil, nodes)
    snip_node.old_state = old_state
    return snip_node
end

function utils.surround_with_func(args, snip, old_state, user_args)
    local nodes = {}
    old_state = old_state or {}
    user_args = user_args or {}

    if snip.snippet.env and snip.snippet.env.SELECT_RAW and #snip.snippet.env.SELECT_RAW == 1 then
        local node = snip.snippet.env.SELECT_RAW[1]
        table.insert(nodes, t(node))
    else
        local text = user_args.text or "placeholder"
        table.insert(nodes, i(1, text))
    end

    local snip_node = sn(nil, nodes)
    snip_node.old_state = old_state
    return snip_node
end

function utils.copy(args)
    return args[1]
end

function utils.return_value()
    local clike = {
        c = true,
        cpp = true,
        java = true,
    }

    local snippet = { t({ "return " }), i(1, "value") }

    if clike[vim.bo.filetype] then
        table.insert(snippet, t({ ";" }))
    end

    return snippet
end

function utils.else_clause(args, snip, old_state, placeholder)
    local nodes = {}
    local ft = vim.opt_local.filetype:get()

    if snip.captures[1] == "e" then
        if ft == "lua" then
            table.insert(nodes, t({ "", "else", "\t" }))
            table.insert(nodes, i(1, utils.get_comment("code")))
        elseif ft == "python" then
            table.insert(nodes, t({ "", "else", "\t" }))
            table.insert(nodes, i(1, "pass"))
        elseif ft == "sh" or ft == "bash" or ft == "zsh" then
            table.insert(nodes, t({ "else", "\t" }))
            table.insert(nodes, i(1, ":"))
            table.insert(nodes, t({ "", "" }))
        elseif ft == "go" or ft == "rust" then
            table.insert(nodes, t({ " else {", "\t" }))
            table.insert(nodes, i(1, utils.get_comment("code")))
            table.insert(nodes, t({ "", "}" }))
        else
            table.insert(nodes, t({ "", "else {", "\t" }))
            table.insert(nodes, i(1, utils.get_comment("code")))
            table.insert(nodes, t({ "", "}" }))
        end
    else
        table.insert(nodes, t({ "" }))
    end

    local snip_node = sn(nil, nodes)
    snip_node.old_state = old_state
    return snip_node
end

return utils
