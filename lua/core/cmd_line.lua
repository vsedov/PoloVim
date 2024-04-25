local M = {
    history = { window = -1, buffer = -1, messages = {} },
    output = { window = -1, buffer = -1 },
}

function M.content_to_lines(content)
    local message = ""
    for _, chunk in ipairs(content) do
        message = message .. chunk[2]
    end
    message = string.gsub(message, "\r", "")
    return vim.split(message, "\n")
end

function M.clear_buffer(display)
    if vim.api.nvim_buf_is_loaded(M[display].buffer) then
        vim.bo[M[display].buffer].modifiable = true
        vim.api.nvim_buf_set_lines(M[display].buffer, 0, -1, false, {})
        vim.bo[M[display].buffer].modifiable = false
    end
end

function M.init_buffer(display)
    if vim.api.nvim_buf_is_loaded(M[display].buffer) then
        return
    end
    local buf = vim.api.nvim_create_buf(false, true)
    vim.bo[buf].filetype = "MsgArea"
    vim.bo[buf].bufhidden = "wipe"
    vim.api.nvim_buf_set_name(buf, "[MsgArea - ]" .. display)
    vim.bo[buf].modifiable = false
    vim.keymap.set("n", "q", function()
        vim.api.nvim_win_close(M[display].window, true)
        M[display].window = -1
    end, { buffer = buf, nowait = true, silent = true })
    M[display].buffer = buf
end

function M.init_window(display)
    if vim.api.nvim_win_is_valid(M[display].window) then
        return
    end
    M[display].window = vim.api.nvim_open_win(M[display].buffer, true, {
        split = "below",
        height = 10,
    })
    vim.wo[M[display].window].winfixbuf = true
end

function M.render_split(display, lines, clear)
    M.init_buffer(display)
    local buf, win = M[display].buffer, M[display].window
    local start_line, end_line = 0, -1
    if not vim.api.nvim_win_is_valid(win) then
        M.init_window(display)
        M.clear_buffer(display)
    end
    if not clear then
        local buf_lines = vim.api.nvim_buf_get_lines(buf, 0, -1, true)
        start_line = vim.deep_equal(buf_lines, { "" }) and 0 or #buf_lines
        end_line = -1
    end
    vim.bo[buf].modifiable = true
    vim.api.nvim_buf_set_lines(buf, start_line, end_line, false, lines)
    vim.bo[buf].modifiable = false
end

function M.on_usr_msg(show_kind, lines)
    M.history.messages = vim.iter({ M.history.messages, lines }):flatten():totable()
    local text = table.concat(lines, "\n")
    if show_kind == "echo" then
        vim.notify(text, vim.log.levels.INFO)
    else
        vim.notify(text, vim.log.levels.ERROR)
    end
end

function M.on_history_show()
    vim.api.nvim_input("<cr>")
    if #M.history.messages == 0 then
        vim.notify("No history messages", vim.log.levels.INFO)
        return
    end
    M.render_split("history", M.history.messages, false)
end

function M.on_empty(lines)
    if #lines == 1 then
        M.on_usr_msg("echo", lines)
        return
    end
    -- check if the message is a terminal command output
    if lines[1]:find("^:!") then
        table.remove(lines, 1)
    end
    M.render_split("output", lines, false)
end

function M.on_show(...)
    local kind, content, _ = ...
    local lines = M.content_to_lines(content)
    if kind == "" then
        M.on_empty(lines, replace_last)
        return
    elseif kind == "return_prompt" then
        return vim.api.nvim_input("<cr>")
    elseif
        kind == "echo"
        or kind == "emsg"
        or kind == "echomsg"
        or kind == "echoerr"
        or kind == "lua_error"
        or kind == "rpc_error"
    then
        M.on_usr_msg(kind, lines)
        return
    elseif kind == "search_count" or "quickfix" then
        return
    end
end

function M.handler(event, ...)
    if event == "msg_show" then
        M.on_show(...)
    elseif event == "msg_history_show" then
        M.on_history_show()
    -- I don't care about other events (showcmd, showmode, showruler,
    -- history_clear and msg_clear)
    else
        return
    end
end

function M.debug_handler(event, ...)
    local kind, content, _ = ...
    vim.api.nvim_win_set_buf(0, 0)
    vim.api.nvim_buf_set_lines(
        0,
        -1,
        -1,
        true,
        { "E : " .. event .. " K: " .. kind .. " C: " .. vim.inspect(unpack(content)) }
    )
end

-- Also need to override the default vim.ui.input(), vim.ui.select() and other
-- stuff that might render in msg-area with user input. vim commands like ls do
-- not seem to send any msg_show event.

function M.notify(msg, log_level, opts)
    vim.g.status_line_notify = { message = msg, level = log_level }
    vim.defer_fn(function()
        vim.g.status_line_notify = { message = "", level = nil }
        vim.cmd("redrawstatus!")
    end, 2000)
end

function M.init()
    vim.notify = M.notify
    local ns = vim.api.nvim_create_namespace("msg")
    vim.ui_attach(ns, { ext_messages = true }, function(event, ...)
        M.handler(event, ...)
        -- M.debug_handler(event, ...)
    end)
end

M.init()
