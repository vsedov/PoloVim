--https://github.com/Mike325/nvim
local M = {}

local queries = {
    ["function"] = {
        lua = [[
            (function_declaration)
            [
                (function_declaration name: [
                    ((identifier) @function) ((dot_index_expression field: (identifier) @function))
                ])
            ] @function_name
        ]],
        python = [[
            (function_definition)
            [
                (function_definition name: (identifier) @definition.function)
            ] @function_name
        ]],
        go = [[
            [
                (function_declaration)
                (method_declaration)
            ] @func

            [
                (function_declaration name: (identifier) @definition.function)
                (method_declaration name: (field_identifier) @definition.method)
            ] @function_name
        ]],
    },
    class = {
        cpp = [[
            [
                (struct_specifier)
                (class_specifier)
            ] @class

            [
                (struct_specifier name: [((type_identifier) @name) (template_type name: (type_identifier) @name)])
                (class_specifier name: [((type_identifier) @name) (template_type name: (type_identifier) @name)])
            ] @class_name
        ]],
        python = [[
            (class_definition)
            [
                (class_definition name: (identifier) @definition.type)
            ] @class_name
        ]],
    },
}

-- Copied from nvim-treesitter in ts_utils
local function get_vim_range(range, buf)
    local srow, scol, erow, ecol = unpack(range)
    srow = srow + 1
    scol = scol + 1
    erow = erow + 1

    if ecol == 0 then
        -- Use the value of the last col of the previous row instead.
        erow = erow - 1
        if not buf or buf == 0 then
            ecol = vim.fn.col({ erow, "$" }) - 1
        else
            ecol = #vim.api.nvim_buf_get_lines(buf, erow - 1, erow, false)[1]
        end
    end
    return srow, scol, erow, ecol
end

local function is_in_range(linenr, range)
    if linenr >= range[1] and linenr <= range[2] then
        return true
    end
    return false
end

-- luacheck: ignore 631
-- Took from: https://github.com/folke/todo-comments.nvim/blob/9983edc5ef38c7a035c17c85f60ee13dbd75dcc8/lua/todo-comments/highlight.lua#L43,#L71
-- Checks if the 3 TS nodes nodes in a range correspond with the target node
-- @param range table: range to look for the node
-- @param node table: list of nodes to look for
-- @param buf number: buffer number
-- @return true or false otherwise
function M.is_node(range, node, buf)
    vim.validate({
        buf = { buf, "number", true },
        range = {
            range,
            function(r)
                return vim.tbl_islist(r)
            end,
            "an array",
        },
        node = {
            node,
            function(n)
                return not n or type(n) == type("") or vim.tbl_islist(n)
            end,
            "should be a string or an array",
        },
    })
    buf = buf or vim.api.nvim_get_current_buf()
    node = node or { "comment" }

    if not vim.tbl_islist(node) then
        node = { node }
    end

    local ok, parser = pcall(vim.treesitter.get_parser, buf)
    if not ok then
        return
    end

    local ts_to_ft = {
        bash = "sh",
    }

    local langtree = parser:language_for_range(range)
    -- local buf_lang = vim.bo[buf].filetype
    local ts_lang = langtree:lang()
    ts_lang = ts_to_ft[ts_lang] or ts_lang

    for _, tree in ipairs(langtree:trees()) do
        local root = tree:root()
        if root then
            local tnode = root:named_descendant_for_range(unpack(range))
            -- NOTE: langtree can be "comment" so we do a safe check to avoid "comment" treesitter language
            if vim.tbl_contains(node, ts_lang) or vim.tbl_contains(node, tnode:type()) then
                return true
            end
        end
    end

    return false
end

function M.list_nodes(node_type)
    local buf = vim.api.nvim_get_current_buf()

    local ok, parser = pcall(vim.treesitter.get_parser, buf)
    if not ok then
        return {}
    end

    local buf_lines = vim.api.nvim_buf_line_count(0)
    local line = vim.api.nvim_buf_get_lines(0, buf_lines - 1, buf_lines, false)[1]

    local langtree = parser:language_for_range({ 0, 0, buf_lines, #line })
    local ts_lang = langtree:lang()

    if not queries[node_type] or not queries[node_type][ts_lang] then
        return {}
    end

    local result = {}
    for _, tree in ipairs(langtree:trees()) do
        local root = tree:root()

        if root then
            local query = vim.treesitter.parse_query(ts_lang, queries[node_type][ts_lang])
            for _, node, _ in query:iter_matches(root, buf) do
                if #node > 1 then
                    local func_name, func_range
                    for _, v in pairs(node) do
                        if not func_name then
                            func_name = v
                        else
                            func_range = v
                            break
                        end
                    end
                    local lbegin, _, lend, _ = get_vim_range({ func_range:range() })
                    local name = vim.treesitter.query.get_node_text(func_name, buf)
                    table.insert(result, { name, lbegin, lend })
                end
            end
        end
    end

    return result
end

function M.get_current_node(linenr, node_name)
    local cursor = vim.api.nvim_win_get_cursor(0)
    linenr = linenr or cursor[1]

    local func_list = M.list_nodes(node_name)

    for idx, func in ipairs(func_list) do
        if is_in_range(linenr, { func[2], func[3] }) then
            return func_list[idx]
        end
    end

    return nil
end

function M.get_current_func(linenr)
    return M.get_current_node(linenr, "function")
end

function M.get_current_class(linenr)
    return M.get_current_node(linenr, "class")
end

function M.has_ts(buf)
    vim.validate({ buf = { buf, "number", true } })
    buf = buf or vim.api.nvim_get_current_buf()
    local ok, _ = pcall(vim.treesitter.get_parser, buf)
    return ok
end

return M
