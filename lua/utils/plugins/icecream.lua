-- https://github.com/camilotorresf/icecream.nvim/blob/main/lua/icecream/init.lua
local get_variable_name_from_node = function(node)
    local variable = ""
    if node:type() == "identifier" then
        local start_row, start_column, end_row, end_column = node:range(false)
        local results = vim.api.nvim_buf_get_text(0, start_row, start_column, end_row, end_column, {})
        variable = results[1]
    end
    return variable
end

local get_parent_type_from_node = function(node)
    local parent = node:parent()
    local parent_type = parent:type()
    if parent_type == "assignment" then
        return "variable"
    elseif vim.list_contains({ "typed_parameter", "parameters" }, parent_type) then
        return "parameter"
    else
        return ""
    end
end

local get_spaces_at_the_beginning_of_line_number = function(lineno)
    local line_text = vim.api.nvim_buf_get_text(0, lineno, 0, lineno, -1, {})
    local match = string.match(line_text[1], "^%s+")
    if match then
        return match
    else
        return ""
    end
end

local M = {}

M.add_ic_for_variable_in_line = function()
    -- get the current element
    local current_node = vim.treesitter.get_node()
    if not current_node then
        return
    end
    -- get the variable name
    local identifier_to_print = get_variable_name_from_node(current_node)
    local parent_type = get_parent_type_from_node(current_node)
    local spaces
    local line_number
    if parent_type == "parameter" then
        local parent_node = current_node:parent()
        while parent_node:type() ~= "function_definition" do
            parent_node = parent_node:parent()
        end
        local block_node
        for child_node in parent_node:iter_children() do
            if child_node:type() == "block" then
                block_node = child_node
                break
            end
        end
        local start_row, _, _, _ = block_node:range(false)
        line_number = start_row
        spaces = get_spaces_at_the_beginning_of_line_number(start_row)
    else
        local parent_node = current_node:parent()
        while parent_node:type() ~= "expression_statement" do
            parent_node = parent_node:parent()
        end
        local start_row, _, endr, _ = parent_node:range(false)
        line_number = endr + 1
        spaces = get_spaces_at_the_beginning_of_line_number(start_row)
    end
    local line = spaces .. "ic(" .. identifier_to_print .. ")"
    vim.api.nvim_buf_set_lines(0, line_number, line_number, true, { line })

    -- Add the icecream import if not already there
    local query_text = [[
(import_from_statement
	module_name: (dotted_name
		(identifier) @module (#eq? @module "icecream")
	)
	name: (dotted_name
		(identifier) @name (#eq? @name "ic")
	)
)
	]]
    local parser = vim.treesitter.get_parser()
    local tree = parser:parse()
    local root = tree[1]:root()
    local query = vim.treesitter.query.parse("python", query_text)
    local is_already_imported = false
    for id, node in query:iter_matches(root, 0, 0, -1) do
        is_already_imported = true
        break
    end
    if not is_already_imported then
        vim.api.nvim_buf_set_lines(0, 0, 0, true, { "from icecream import ic" })
    end
end

M.clear_ic_from_file = function()
    -- Find all ic statements
    local query_text_for_ic = [[
(expression_statement
	(call
		(identifier) @id (#eq? @id "ic")
	)
)
	]]
    local parser = vim.treesitter.get_parser()
    local tree = parser:parse()
    local root = tree[1]:root()
    local query_ic = vim.treesitter.query.parse("python", query_text_for_ic)

    -- add the lines to remove, in reverse, from bottom to top
    local lines_to_delete = {}
    for pattern, match, metadata in query_ic:iter_matches(root, 0, 0, -1) do
        for id, node in pairs(match) do
            local start_row, _, end_row, _ = node:range(false)
            local start_line = start_row
            local end_line = end_row + 1
            table.insert(lines_to_delete, 1, { start_line, end_line })
        end
    end

    -- Delete the lines, they start from the bottom
    for i, lines in ipairs(lines_to_delete) do
        local start_line, end_line = unpack(lines)
        vim.api.nvim_buf_set_lines(0, start_line, end_line, true, {})
    end

    -- Remove the icecream import
    local query_text_for_import = [[
(import_from_statement
	module_name: (dotted_name
		(identifier) @module (#eq? @module "icecream")
	)
	name: (dotted_name
		(identifier) @name (#eq? @name "ic")
	)
)
	]]
    local query_import = vim.treesitter.query.parse("python", query_text_for_import)
    for pattern, match, metadata in query_import:iter_matches(root, 0, 0, -1) do
        for id, node in pairs(match) do
            local start_row, _, end_row, _ = node:range(false)
            local start_line = start_row
            local end_line = end_row + 1
            vim.api.nvim_buf_set_lines(0, start_line, end_line, true, {})
            break
        end
        break
    end
end
M.setup = function(opts)
    opts = opts or {
        binds = {
            add = "<leader>ic",
            clear = "<leader>ci",
        },
    }
    local function_binds = {
        add = "add_ic_for_variable_in_line",
        clear = "clear_ic_from_file",
    }
    local binds = opts.binds
    for k, v in pairs(binds) do
        vim.keymap.set("n", v, function()
            M[function_binds[k]]()
        end, { noremap = true, silent = true })
    end
end

return M
