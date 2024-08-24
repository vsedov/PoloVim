local M = {}

M.config = {
    enabled_on_start_v = "none",
    enabled_on_start_h = "none",
}

local function clear_keep_cursor()
    if _G.KeepCursorGroup then
        vim.api.nvim_clear_autocmds({ group = _G.KeepCursorGroup })
    end
end

local function clear_keep_side_cursor()
    if _G.KeepSideCursorGroup then
        vim.api.nvim_clear_autocmds({ group = _G.KeepSideCursorGroup })
    end
end

function M.ToggleCursorTop(newscrolloff)
    if _G.KeepCursorAt == "top" then
        clear_keep_cursor()
        _G.KeepCursorAt = nil
        vim.opt.scrolloff = _G.prev_scrolloff or 0
        print("KeepCursor: Scrolloff returned to default.")
    else
        if not _G.KeepCursorAt then
            _G.prev_scrolloff = vim.opt.scrolloff:get()
        end
        _G.KeepCursorAt = "top"
        vim.opt.scrolloff = newscrolloff or vim.opt.scrolloff:get()
        _G.KeepCursorGroup = vim.api.nvim_create_augroup("KeepCursor", { clear = true })
        vim.api.nvim_create_autocmd("CursorMoved", {
            command = "normal! zt",
            group = _G.KeepCursorGroup,
        })
        print("KeepCursor: keeping cursor at top.")
    end
end

function M.ToggleCursorBot(newscrolloff)
    if _G.KeepCursorAt == "bottom" then
        clear_keep_cursor()
        _G.KeepCursorAt = nil
        vim.opt.scrolloff = _G.prev_scrolloff or 0
        print("KeepCursor: Scrolloff returned to default.")
    else
        if not _G.KeepCursorAt then
            _G.prev_scrolloff = vim.opt.scrolloff:get()
        end
        _G.KeepCursorAt = "bottom"
        vim.opt.scrolloff = newscrolloff or vim.opt.scrolloff:get()
        _G.KeepCursorGroup = vim.api.nvim_create_augroup("KeepCursor", { clear = true })
        vim.api.nvim_create_autocmd("CursorMoved", {
            command = "normal! zb",
            group = _G.KeepCursorGroup,
        })
        print("KeepCursor: keeping cursor at bottom.")
    end
end

function M.ToggleCursorMid()
    if _G.KeepCursorAt == "middle" then
        clear_keep_cursor()
        _G.KeepCursorAt = nil
        vim.opt.scrolloff = _G.prev_scrolloff or 0
        print("KeepCursor: Scrolloff returned to default.")
    else
        if not _G.KeepCursorAt then
            _G.prev_scrolloff = vim.opt.scrolloff:get()
        end
        _G.KeepCursorAt = "middle"
        _G.KeepCursorGroup = vim.api.nvim_create_augroup("KeepCursor", { clear = true })
        vim.api.nvim_create_autocmd("CursorMoved", {
            command = "normal! zz",
            group = _G.KeepCursorGroup,
        })
        print("KeepCursor: keeping cursor at middle.")
    end
end

function M.DisableKeepCursor()
    clear_keep_cursor()
    _G.KeepCursorAt = nil
    vim.opt.scrolloff = _G.prev_scrolloff or 0
    print("KeepCursor: Scrolloff returned to default.")
end

function M.ToggleCursorRight(newscrolloff)
    if _G.KeepSideCursorAt == "right" then
        clear_keep_side_cursor()
        _G.KeepSideCursorAt = nil
        vim.opt.sidescrolloff = _G.prev_sidescrolloff or 0
        print("KeepCursor: Sidescrolloff returned to default.")
    else
        if not _G.KeepSideCursorAt then
            _G.prev_sidescrolloff = vim.opt.sidescrolloff:get()
        end
        _G.KeepSideCursorAt = "right"
        vim.opt.sidescrolloff = newscrolloff or vim.opt.sidescrolloff:get()
        _G.KeepSideCursorGroup = vim.api.nvim_create_augroup("KeepSideCursor", { clear = true })
        vim.api.nvim_create_autocmd("CursorMoved", {
            command = "normal! ze",
            group = _G.KeepSideCursorGroup,
        })
        print("KeepCursor: keeping cursor to the right.")
    end
end

function M.ToggleCursorLeft(newscrolloff)
    if _G.KeepSideCursorAt == "left" then
        clear_keep_side_cursor()
        _G.KeepSideCursorAt = nil
        vim.opt.sidescrolloff = _G.prev_sidescrolloff or 0
        print("KeepCursor: Sidescrolloff returned to default.")
    else
        if not _G.KeepSideCursorAt then
            _G.prev_sidescrolloff = vim.opt.sidescrolloff:get()
        end
        _G.KeepSideCursorAt = "left"
        vim.opt.sidescrolloff = newscrolloff or vim.opt.sidescrolloff:get()
        _G.KeepSideCursorGroup = vim.api.nvim_create_augroup("KeepSideCursor", { clear = true })
        vim.api.nvim_create_autocmd("CursorMoved", {
            command = "normal! zs",
            group = _G.KeepSideCursorGroup,
        })
        print("KeepCursor: keeping cursor to the left.")
    end
end

function M.KeepCursorStatus()
    local status_map = {
        top = "  top",
        middle = "  mid",
        bottom = "  bot",
    }
    return status_map[_G.KeepCursorAt] or nil
end

function M.setup(opts)
    M.config = vim.tbl_deep_extend("force", M.config, opts or {})

    if M.config.enabled_on_start_v ~= "none" then
        _G.onstart_v = true
        if M.config.enabled_on_start_v == "top" then
            M.ToggleCursorTop()
        elseif M.config.enabled_on_start_v == "middle" then
            M.ToggleCursorMid()
        elseif M.config.enabled_on_start_v == "bottom" then
            M.ToggleCursorBot()
        end
    end

    if M.config.enabled_on_start_h ~= "none" then
        _G.onstart_h = true
        if M.config.enabled_on_start_h == "left" then
            M.ToggleCursorLeft()
        elseif M.config.enabled_on_start_h == "right" then
            M.ToggleCursorRight()
        end
    end
    --
    local list_command = {
        "ToggleCursorTop",
        "ToggleCursorBot",
        "ToggleCursorMid",
        "DisableKeepCursor",
        "ToggleCursorRight",
        "ToggleCursorLeft",
    }

    for _, command in ipairs(list_command) do
        vim.api.nvim_create_user_command(command, function(opts)
            if command == "ToggleCursorTop" then
                M.ToggleCursorTop(tonumber(opts.args))
            elseif command == "ToggleCursorBot" then
                M.ToggleCursorBot(tonumber(opts.args))
            elseif command == "ToggleCursorMid" then
                M.ToggleCursorMid()
            elseif command == "DisableKeepCursor" then
                M.DisableKeepCursor()
            elseif command == "ToggleCursorRight" then
                M.ToggleCursorRight(tonumber(opts.args))
            elseif command == "ToggleCursorLeft" then
                M.ToggleCursorLeft(tonumber(opts.args))
            end
        end, { nargs = "?" })
    end
end

return M
