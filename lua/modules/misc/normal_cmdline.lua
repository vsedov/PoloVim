local normal_cmdline = {}
local is_enabled = false
local disable_normal_cmdline = nil
local enable_cmdline = nil

--- Sets the commandline to a certain value
---@param value string Value
local function set_commandline(value)
    disable_normal_cmdline()
    vim.api.nvim_input("<esc>:" .. value)
end

local mappings = {
    ["x"] = "<right><bs>",
    ["l"] = "<right>",
    ["1l"] = string.rep("<right>", 1),
    ["2l"] = string.rep("<right>", 2),
    ["3l"] = string.rep("<right>", 3),
    ["4l"] = string.rep("<right>", 4),
    ["5l"] = string.rep("<right>", 5),
    ["6l"] = string.rep("<right>", 6),
    ["7l"] = string.rep("<right>", 7),
    ["8l"] = string.rep("<right>", 8),
    ["9l"] = string.rep("<right>", 9),
    ["10l"] = string.rep("<right>", 10),
    ["h"] = "<left>",
    ["1h"] = string.rep("<left>", 1),
    ["2h"] = string.rep("<left>", 2),
    ["3h"] = string.rep("<left>", 3),
    ["4h"] = string.rep("<left>", 4),
    ["5h"] = string.rep("<left>", 5),
    ["6h"] = string.rep("<left>", 6),
    ["7h"] = string.rep("<left>", 7),
    ["8h"] = string.rep("<left>", 8),
    ["9h"] = string.rep("<left>", 9),
    ["10h"] = string.rep("<left>", 10),
    ["w"] = function()
        local line = vim.fn.getcmdline()
        local full_line = line
        local pos = vim.fn.getcmdpos()
        -- how many characters are behind cursor
        local behind_cursor = #line - pos
        local last_line = line
        while true do
            -- remove complete `word`s from the beginning
            line = line:gsub("^[%w_]+", "")
            -- if nothing was removed (no word characters in the beginning) remove the first char
            if line == last_line then
                line = line:sub(2, -1)
            end
            -- check if the word in which the cursor is got removed
            if #line < behind_cursor then
                break
            end
            -- store the shortened line
            last_line = line
        end
        -- `line` is now without current word
        -- `last_line` is with current word
        -- everything before word is removed
        local end_pos = #full_line - #line
        vim.api.nvim_input(string.rep("<left>", pos - 1))
        print(end_pos)
        vim.api.nvim_input(string.rep("<right>", end_pos))
    end,
    ["e"] = function()
        local line = vim.fn.getcmdline()
        local full_line = line
        local pos = vim.fn.getcmdpos()
        -- how many characters are behind cursor
        local behind_cursor = #line - pos
        local last_line = line
        while true do
            -- remove complete `word`s from the beginning
            line = line:gsub("^[%w_]+", "")
            -- if nothing was removed (no word characters in the beginning) remove the first char
            if line == last_line then
                line = line:sub(2, -1)
            end
            -- check if the word in which the cursor is got removed
            if #line < behind_cursor then
                break
            end
            -- store the shortened line
            last_line = line
        end
        -- `line` is now without current word
        -- `last_line` is with current word
        -- everything before word is removed
        local end_pos = #full_line - #line
        vim.api.nvim_input(string.rep("<left>", pos - 1))
        print(end_pos)
        vim.api.nvim_input(string.rep("<right>", end_pos - 1))
    end,
    ["b"] = function()
        local line = vim.fn.getcmdline()
        local full_line = line
        local pos = vim.fn.getcmdpos()
        local behind_cursor = #line - (pos - 1)
        local last_line = line
        while true do
            -- remove complete `word`s from the beginning
            line = line:gsub("^[%w_]+", "")
            -- if nothing was removed (no word characters in the beginning) remove the first char
            if line == last_line then
                line = line:sub(2, -1)
            end
            -- check if the word in which the cursor is got removed
            if #line <= behind_cursor then
                break
            end
            -- store the shortened line
            last_line = line
        end
        -- `line` is now without current word
        -- `last_line` is with current word
        -- everything before word is removed
        local start_pos = #full_line - #last_line
        vim.api.nvim_input(string.rep("<left>", pos - 1))
        vim.api.nvim_input(string.rep("<right>", start_pos))
        -- local end_pos = #full_line - #line
    end,
    ["dd"] = function()
        set_commandline("")
        enable_cmdline()
    end,
    ["cc"] = function()
        set_commandline("")
        enable_cmdline()
    end,
    ["cl"] = function()
        vim.api.nvim_input("<right><bs>")
        disable_normal_cmdline()
    end,
    ["j"] = "<down>",
    ["k"] = "<up>",
    ["i"] = function()
        disable_normal_cmdline()
    end,
    ["ciw"] = function()
        local line = vim.fn.getcmdline()
        local full_line = line
        local pos = vim.fn.getcmdpos()
        local behind_cursor = #line - (pos - 1)
        local last_line = line
        while true do
            -- remove complete `word`s from the beginning
            line = line:gsub("^[%w_]+", "")
            -- if nothing was removed (no word characters in the beginning) remove the first char
            if line == last_line then
                line = line:sub(2, -1)
            end
            -- check if the word in which the cursor is got removed
            if #line <= (behind_cursor - 1) then
                break
            end
            -- store the shortened line
            last_line = line
        end
        -- `line` is now without current word
        -- `last_line` is with current word
        -- everything before word is removed
        local text = full_line:sub(1, -(#last_line + 1)) .. full_line:sub(-#line, -1)

        if line == "" then
            text = full_line:sub(1, -(#last_line + 1))
        end

        set_commandline(text)
        vim.api.nvim_input(string.rep("<left>", #line))
    end,
    ["D"] = function()
        local line = vim.fn.getcmdline()
        local pos = vim.fn.getcmdpos()
        local chars_left = #line - (pos - 1)
        vim.api.nvim_input(string.rep("<right>", chars_left))
        vim.api.nvim_input(string.rep("<bs>", chars_left))
    end,
    ["$"] = function()
        local line = vim.fn.getcmdline()
        local pos = vim.fn.getcmdpos()
        local chars_left = #line - (pos - 1)
        vim.api.nvim_input(string.rep("<right>", chars_left))
    end,
    ["0"] = function()
        local pos = vim.fn.getcmdpos()
        vim.api.nvim_input(string.rep("<left>", pos - 1))
    end,
    ["a"] = function()
        vim.api.nvim_input("<right>")
        disable_normal_cmdline()
    end,
    ["s"] = function()
        vim.api.nvim_input("<right><bs>")
        disable_normal_cmdline()
    end,
    ["A"] = function()
        local line = vim.fn.getcmdline()
        local pos = vim.fn.getcmdpos()
        local chars_left = #line - (pos - 1)
        vim.api.nvim_input(string.rep("<right>", chars_left))
        disable_normal_cmdline()
    end,
    ["C"] = function()
        local line = vim.fn.getcmdline()
        local pos = vim.fn.getcmdpos()
        local chars_left = #line - (pos - 1)
        vim.api.nvim_input(string.rep("<right>", chars_left))
        vim.api.nvim_input(string.rep("<bs>", chars_left))
        disable_normal_cmdline()
    end,
}

enable_cmdline = function()
    is_enabled = true
    vim.cmd([[set guicursor=n-v-ci-sm:block,i-c-ve:ver25,r-cr-o:hor20]])
    vim.keymap.del("c", "jk")
    for key, mapping in pairs(mappings) do
        vim.keymap.set("c", key, mapping, {})
    end
end

disable_normal_cmdline = function()
    if not is_enabled then
        return
    end
    is_enabled = false
    vim.keymap.set("c", "jk", function()
        enable_cmdline()
    end)
    vim.cmd([[set guicursor=n-v-sm:block,i-c-ci-ve:ver25,r-cr-o:hor20]])
    for key, _ in pairs(mappings) do
        vim.keymap.del("c", key, {})
    end
end

normal_cmdline.setup = function()
    vim.keymap.set("c", "jk", function()
        enable_cmdline()
    end)
    vim.api.nvim_create_autocmd("CmdLineLeave", {
        callback = function()
            if is_enabled then
                disable_normal_cmdline()
            end
        end,
    })
end

return normal_cmdline
