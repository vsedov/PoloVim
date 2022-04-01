local M = {}
function M.ScrollerHelp()
    vim.api.nvim_command("echohl Title")
    vim.api.nvim_command("echo 'Color Scroller Help:'")
    vim.api.nvim_command("echohl NONE")
    vim.api.nvim_command("echo 'Arrows       - change colorscheme'")
    vim.api.nvim_command("echo 'Esc,q,Enter  - exit'")
    vim.api.nvim_command("echo 'h,j,k,l      - change colorscheme'")
    vim.api.nvim_command("echo '0,g          - go to first colorscheme'")
    vim.api.nvim_command("echo '$,G          - go to last colorscheme'")
    vim.api.nvim_command("echo 'L            - list colorschemes'")
    vim.api.nvim_command("echo 'PgUp,PgDown  - jump by 10 colorschemes'")
    vim.api.nvim_command("echo '#            - go to colorscheme by index (1-N)'")
    vim.api.nvim_command("echo 'R            - refresh colorscheme list'")
    vim.api.nvim_command("echo '?            - this help text'")
    vim.api.nvim_command("echohl MoreMsg")
    vim.api.nvim_command("echo 'Press any key to continue'")
    vim.api.nvim_command("echohl NONE")
    vim.api.nvim_command("call getchar()")
end

function M.align(s, width)
    if #s >= width then
        return s .. " "
    else
        local pad = "                       "
        local res = s
        while #res < width do
            local chunk = (width - #res > #pad and #pad or width - #res)
            res = res .. string.sub(pad, 0, chunk)
        end
        return res
    end
end

function M.listColors()
    vim.api.nvim_command("echo ' '")
    local list = M.getColorschemesList()
    local width = 18
    local pos = 0
    while list ~= "" do
        local str = string.match(list, "\n.*")
        list = string.gsub(list, "\n.*", "")
        local aligned = M.align(str, width)
        if pos + #aligned + 1 >= vim.api.nvim_get_option("columns") then
            vim.api.nvim_command("echo ' '")
            pos = 0
        end
        vim.api.nvim_command("echon " .. aligned)
        pos = pos + #aligned
    end
    vim.api.nvim_command("echo 'Press any key to continue'")
    vim.api.nvim_command("call getchar()")
end

function M.currentColor()
    if vim.api.nvim_get_var("colors_name") then
        return vim.api.nvim_get_var("colors_name")
    else
        return ""
    end
end

function M.setColor(name)
    vim.api.nvim_command("exe 'color " .. name .. "'")
    vim.api.nvim_set_var("colors_name", name)
end
function M.jumpByIndex(list, total, index)
    local mod = (index <= 0 and 1 or 1 + (index - 1) % total)
    local name = M.entryByIndex(list, mod)
    M.setColor(name)
end

function M.JumpByIndex2(list, total, index)
    local mod = (index <= 0 and 1 or 1 + (index - 1) % total)
    local name = M.entryByIndex(list, mod)
    M.setColor(name)
end

function M.exitDialog(old, action)
    local ans = 0
    if old == M.currentColor() then
        ans = 1
    elseif action == "" then
        ans = vim.api.nvim_call_function("confirm", { "Keep this colorscheme ?", "&Yes\n&No\n&Cancel" })
    elseif action == "keep" then
        ans = 1
    elseif action == "revert" then
        ans = 2
    end
    if ans == 1 or ans == 0 then
        local msg = (old == M.currentColor() and "" or "(original: '" .. old .. "')")
        M.finalEcho(msg)
    elseif ans == 2 then
        M.setColor(old)
        M.finalEcho("original color restored")
    elseif ans == 3 then
        return -1
    end
end

function M.ColorSroller()
    local old = M.currentColor()
    local list = M.getColorschemesList()
    local total = M.countEntries(list)
    local loop = 0
    local index = M.findIndex(list, old)
    if vim.api.nvim_get_var("syntax_on") == 0 then
        vim.api.nvim_command("syntax on")
        vim.api.nvim_command("redraw")
    end
    while 1 do
        vim.api.nvim_command("redraw")

        -- let key = getchar()
        -- let c = nr2char(key)
        local c = vim.fn.getchar()
        --
        if c == "<Left>" or c == "<Up>" or c == "h" or c == "j" then
            M.prevSilent()
        elseif c == "<Down>" or c == "<Right>" or c == "l" or c == "k" or c == " " then
            M.nextSilent()
        elseif c == "g" or c == "0" or c == "1" then
            M.setColor(M.getFirstColors())
        elseif c == "$" or c == "G" then
            M.setColor(M.getLastColors())
        elseif c == "L" then
            M.listColors()
        elseif c == "Z" or c == "z" or c == 13 or c == "q" or c == "Q" or c == ":" or c == 27 then
            local ans = M.exitDialog(old, "")
            if ans == -1 then
                return
            end
            break
        elseif c == "<C-L>" then
            vim.api.nvim_command("redraw")
        elseif c == "#" then
            M.jumpByIndex(list, total, index)
        elseif c == "<PageDown>" then
            M.jumpByIndex(list, total, (index - 10 >= 1 and index - 10 or index - 10 + total))
        elseif c == "<PageUp>" then
            M.jumpByIndex(list, total, index + 10)
        elseif c == "?" then
            M.ScrollerHelp()
        elseif c == "R" then
            M.refreshColorschemesList()
            print("Colorscheme list refreshed. Press any key to continue.")
            vim.api.nvim_command("getchar()")
        else
            M.ScrollerHelp()
        end
        loop = loop + 1
    end
end
--
function M.findIndex(list, entry)
    local str = string.gsub(list, "\n.*", "")
    return 1 + M.countEntries(str)
end


function M.entryByIndex(list, index)
    local k = 1
    local tail = list
    while tail ~= "" and k < index do
        tail = string.gsub(tail, "^[^\n]*\n", "", 1)
        k = k + 1
    end
    tail = string.gsub(tail, "\n.*$", "", 1)
    return tail
end
--

function M.makeWellFormedList(list)
    local str = list .. "\n"
    str = string.gsub(str, "^\n*", "")
    str = string.gsub(str, "\n+", "\n")
    return str
end

function M.countEntries(list)
    local str = M.makeWellFormedList(list)
    str = string.gsub(str, "[^\n] +\n", ".", "g") -- replace all non-newline + newline with dot
    return string.len(str)
end

function M.removeDuplicates(list)
    local sep = "\n"
    local res = M.makeWellFormedList(list .. "\n")
    local beg = 0
    while beg < string.len(res) do
        local end_val = string.find(res, sep, beg)
        local str1 = string.sub(res, beg, end_val - beg)
        local res = string.sub(res, 0, end_val)
            .. string.gsub(string.sub(res, end_val), "\n" .. string.sub(res, end_val), "\n" .. str1, 1)
        res = string.gsub(res, "\n+", "\n")
        beg = end_val
    end
    return res
end
function M.refreshColorschemesList()
    -- get list of colorschemes using globpath and &rtp and colors/*.vim
    -- typ is runtime path and globpath is a vim function
    local x = vim.fn.expand("$VIMRUNTIME/colors/")
    local y = vim.fn.globpath(x, "*.vim")
    local z = string.gsub(y, "^[^\n]*[/\\\\]", "\n")
    print(z)
end


return M.refreshColorschemesList()
