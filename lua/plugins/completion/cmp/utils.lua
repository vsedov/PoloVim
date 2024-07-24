local str = require("cmp.utils.str")
local types = require("cmp.types")

local M = {}

M.get_abbr = function(vim_item, entry)
    local word = entry:get_insert_text()
    if entry.completion_item.insertTextFormat == types.lsp.InsertTextFormat.Snippet then
        -- word = vim.lsp.util.parse_snippet(word)
    end
    word = str.oneline(word)

    -- concatenates the string
    local max = 50
    if string.len(word) >= max then
        local before = string.sub(word, 1, math.floor((max - 3) / 2))
        word = before .. "..."
    end

    if
        entry.completion_item.insertTextFormat == types.lsp.InsertTextFormat.Snippet
        and string.sub(vim_item.abbr, -1, -1) == "~"
    then
        word = word .. "~"
    end
    return word
end

-- https://github.com/wincent/wincent/blob/fba0bbb9a81e085f654253926138b6675d3a6ad2/aspects/nvim/files/.config/nvim/after/plugin/nvim-cmp.lua
-- local kind = cmp.lsp.CompletionItemKind
M.rhs = function(rhs_str)
    return vim.api.nvim_replace_termcodes(rhs_str, true, true, true)
end

-- Returns the current column number.
M.column = function()
    local _line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col
end

-- Based on (private) function in LuaSnip/lua/luasnip/init.lua.
M.in_snippet = function()
    local session = require("luasnip.session")
    local node = session.current_nodes[vim.api.nvim_get_current_buf()]
    if not node then
        return false
    end
    local snippet = node.parent.snippet
    local snip_begin_pos, snip_end_pos = snippet.mark:pos_begin_end()
    local pos = vim.api.nvim_win_get_cursor(0)
    if pos[1] - 1 >= snip_begin_pos[1] and pos[1] - 1 <= snip_end_pos[1] then
        return true
    end
end

-- Returns true if the cursor is in leftmost column or at a whitespace
-- character.
M.in_whitespace = function()
    local col = M.column()
    return col == 0 or vim.api.nvim_get_current_line():sub(col, col):match("%s")
end

M.shift_width = function()
    if vim.o.softtabstop <= 0 then
        return vim.fn.shiftwidth()
    else
        return vim.o.softtabstop
    end
end

-- Complement to `smart_tab()`.
--
-- When 'noexpandtab' is set (ie. hard tabs are in use), backspace:
--
--    - On the left (ie. in the indent) will delete a tab.
--    - On the right (when in trailing whitespace) will delete enough
--      spaces to get back to the previous tabstop.
--    - Everywhere else it will just delete the previous character.
--
-- For other buffers ('expandtab'), we let Neovim behave as standard and that
-- yields intuitive behavior.
M.smart_bs = function()
    if vim.o.expandtab then
        return M.rhs(":<")
    else
        local col = column()
        local line = vim.api.nvim_get_current_line()
        local prefix = line:sub(1, col)
        local in_leading_indent = prefix:find("^%s*$")
        if in_leading_indent then
            return M.rhs(":<")
        end
        local previous_char = prefix:sub(#prefix, #prefix)
        if previous_char ~= " " then
            return M.rhs(":<")
        end
        return M.rhs("<C-\\><C-o>:set expandtab<CR><BS><C-\\><C-o>:set noexpandtab<CR>")
    end
end

-- In buffers where 'noexpandtab' is set (ie. hard tabs are in use), <Tab>:
--
--    - Inserts a tab on the left (for indentation).
--    - Inserts spaces everywhere else (for alignment).
--
-- For other buffers (ie. where 'expandtab' applies), we use spaces everywhere.
M.smart_tab = function(opts)
    local keys = nil
    if vim.o.expandtab then
        keys = "<Tab>" -- Neovim will insert spaces.
    else
        local col = M.column()
        local line = vim.api.nvim_get_current_line()
        local prefix = line:sub(1, col)
        local in_leading_indent = prefix:find("^%s*$")
        if in_leading_indent then
            keys = "<Tab>" -- Neovim will insert a hard tab.
        else
            -- virtcol() returns last column occupied, so if cursor is on a
            -- tab it will report `actual column + tabstop` instead of `actual
            -- column`. So, get last column of previous character instead, and
            -- add 1 to it.
            local sw = M.shift_width()
            local previous_char = prefix:sub(#prefix, #prefix)
            local previous_column = #prefix - #previous_char + 1
            local current_column = vim.fn.virtcol({ vim.fn.line("."), previous_column }) + 1
            local remainder = (current_column - 1) % sw
            local move = remainder == 0 and sw or sw - remainder
            keys = (" "):rep(move)
        end
    end

    vim.api.nvim_feedkeys(M.rhs(keys), "nt", true)
end

M.has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

-- print("cmp setup")
-- local t = function(str)
-- return vim.api.nvim_replace_termcodes(str, true, true, true)
-- end

M.check_backspace = function()
    local col = vim.fn.col(".") - 1
    return col == 0 or vim.fn.getline("."):sub(col, col):match("%s") ~= nil
end

return M
