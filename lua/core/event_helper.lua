-- local leader = wincent.mappings.leader
local fn = vim.fn
local api = vim.api
local M = {}

local blacklist_files = {
    "c",
    "norg",
    "tex",
    "md",
}

local function should_mkview()
    return vim.bo.buftype == ""
        and vim.fn.getcmdwintype() == ""
        and blacklist_files[vim.bo.filetype] == nil
        and vim.fn.exists("$SUDO_USER") == 0 -- Don't create root-owned files.
end

function M.mkview()
    if should_mkview() then
        local success, err = pcall(function()
            if vim.fn.exists("*haslocaldir") and vim.fn.haslocaldir() then
                -- We never want to save an :lcd command, so hack around it...
                api.nvim_command("cd -")
                api.nvim_command("mkview")
                api.nvim_command("lcd -")
            else
                api.nvim_command("mkview")
            end
        end)
        if not success then
            if
                err:find("%f[%w]E186%f[%W]") == nil -- No previous directory: probably a `git` operation.
                and err:find("%f[%w]E190%f[%W]") == nil -- Could be name or path length exceeding NAME_MAX or PATH_MAX.
                and err:find("%f[%w]E5108%f[%W]") == nil
            then
                error(err)
            end
        end
    end
end

function M.loadview()
    if should_mkview() then
        api.nvim_command("silent! loadview")
        api.nvim_command("silent! " .. vim.fn.line(".") .. "foldopen!")
    end
end

function M.disable_heavy_plugins()
    if
        M.heavy_plugins_blocklist[vim.bo.filetype] ~= nil
        or vim.regex("\\.min\\..*$"):match_str(vim.fn.expand("%:t")) ~= nil
        or vim.fn.getfsize(vim.fn.expand("%")) > 200000
    then
        if vim.fn.exists(":ALEDisableBuffer") == 2 then
            api.nvim_command(":ALEDisableBuffer")
        end
    end
end

local called_func = false
local timer = nil
local space_used
function M.reset_timer(text_changed)
    if timer and not vim.loop.is_closing(timer) then
        vim.loop.timer_stop(timer)
        vim.loop.close(timer)
        timer = nil
    end
    if called_func then
        return
    end
    if text_changed then
        if timer then
            vim.loop.timer_stop(timer)
            vim.loop.close(timer)
            timer = nil
        end
        return
    end
    if vim.v.char and vim.v.char ~= " " then
        space_used = false
        return
    end
    if vim.fn.mode() ~= "i" then
        return
    end
    if space_used then
        return
    end
    space_used = true
    timer = vim.defer_fn(function()
        called_func = true
        local function feed(keys)
            api.nvim_feedkeys(api.nvim_replace_termcodes(keys, true, true, true), "n", false)
        end

        if vim.tbl_contains({ 1, 2, 0 }, #vim.fn.expand("<cword>")) then
            return
        end

        feed("<esc>blgulhela")
        timer = nil
        called_func = false
    end, 100)
end

-- https://github.com/akinsho/dotfiles/blob/479e11e71c6bc042c3987f159da9457acc565121/.config/nvim/plugin/autocommands.lua
vim.keymap.set({ "n", "v", "o", "i", "c" }, "<Plug>(StopHL)", 'execute("nohlsearch")[-1]', { expr = true })

function M.stop_hl()
    if vim.v.hlsearch == 0 or api.nvim_get_mode().mode ~= "n" then
        return
    end
    api.nvim_feedkeys(api.nvim_replace_termcodes("<Plug>(StopHL)", true, true, true), "m", false)
end

function M.hl_search()
    local col = api.nvim_win_get_cursor(0)[2]
    local curr_line = api.nvim_get_current_line()
    local ok, match = pcall(fn.matchstrpos, curr_line, fn.getreg("/"), 0)
    if not ok then
        return vim.notify(match, "error", { title = "HL SEARCH" })
    end
    local _, p_start, p_end = unpack(match)
    -- if the cursor is in a search result, leave highlighting on
    if col < p_start or col > p_end then
        M.stop_hl()
    end
end

return M
