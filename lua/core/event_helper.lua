-- local leader = wincent.mappings.leader

local M = {}

local function should_mkview()
    return vim.bo.buftype == ""
        and vim.fn.getcmdwintype() == ""
        and M.mkview_filetype_blocklist[vim.bo.filetype] == nil
        and vim.fn.exists("$SUDO_USER") == 0 -- Don't create root-owned files.
end

function M.mkview()
    if should_mkview() then
        local success, err = pcall(function()
            if vim.fn.exists("*haslocaldir") and vim.fn.haslocaldir() then
                -- We never want to save an :lcd command, so hack around it...
                vim.api.nvim_command("cd -")
                vim.api.nvim_command("mkview")
                vim.api.nvim_command("lcd -")
            else
                vim.api.nvim_command("mkview")
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
        vim.api.nvim_command("silent! loadview")
        vim.api.nvim_command("silent! " .. vim.fn.line(".") .. "foldopen!")
    end
end

function M.disable_heavy_plugins()
    if
        M.heavy_plugins_blocklist[vim.bo.filetype] ~= nil
        or vim.regex("\\.min\\..*$"):match_str(vim.fn.expand("%:t")) ~= nil
        or vim.fn.getfsize(vim.fn.expand("%")) > 200000
    then
        if vim.fn.exists(":ALEDisableBuffer") == 2 then
            vim.api.nvim_command(":ALEDisableBuffer")
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
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, true, true), "n", false)
        end

        if vim.tbl_contains({ 1, 2, 0 }, #vim.fn.expand("<cword>")) then
            return
        end

        feed("<esc>blgulhela")
        timer = nil
        called_func = false
    end, 100)
end

local column_exclude = { "gitcommit" }
local column_clear = {
    "startify",
    "vimwiki",
    "vim-plug",
    "help",
    "fugitive",
    "mail",
    "norg",
    "orgagenda",
    "NeogitStatus",
}

-- https://github.com/akinsho/dotfiles/blob/main/.config/nvim/plugin/autocommands.lua
--- Set or unset the color column depending on the filetype of the buffer and its eligibility
---@param leaving boolean indicates if the function was called on window leave
function M.check_color_column(leaving)
    if vim.tbl_contains(column_exclude, vim.bo.filetype) then
        return
    end

    local not_eligible = not vim.bo.modifiable or vim.wo.previewwindow or vim.bo.buftype ~= "" or not vim.bo.buflisted

    local small_window = vim.api.nvim_win_get_width(0) <= vim.bo.textwidth + 1
    local is_last_win = #vim.api.nvim_list_wins() == 1

    if
        vim.tbl_contains(column_clear, vim.bo.filetype)
        or not_eligible
        or (leaving and not is_last_win)
        or small_window
    then
        vim.wo.colorcolumn = ""
        return
    end
    if vim.wo.colorcolumn == "" then
        vim.wo.colorcolumn = "+1"
    end
end

return M
