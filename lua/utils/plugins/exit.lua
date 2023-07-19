-- https://github.com/NTBBloodbath/nvim.fnl/blob/5226c19e70d466b2a61da9552ac60ab761f42022/fnl/utils/quit.fnl
-- https://github.com/yutkat/confirm-quit.nvim
local message = {

    "Please don't leave, there's more demons to toast!",
    "I wouldn't leave if I were you. DOS is much worse.",
    "Don't leave yet -- There's a demon around that corner!",
    "Ya know, next time you come in here I'm gonna toast ya.",
    "Go ahead and leave. See if I care.",
    "Are you sure you want to quit this great editor?",

    "You can't fire me, I quit!",
    "I don't know what you think you are doing, but I don't like it. I want you to stop.",
    "This isn't brave. It's murder. What did I ever do to you?",
    "I'm the man who's going to burn your house down! With the lemons!",
    "Okay, look. We've both said a lot of things you're going to regret...",

    "Go ahead and leave. I'll convert your code to Python!",
    "Neovim will remember that.",
    "Please don't leave, otherwise I'll tell packer to break your setup on next launch!",
    "It's not like I'll miss you or anything, b-baka!",
    "You are *not* prepared!",
}
local config = {
    overwrite_q_command = true,
}
local M = {}

local function is_last_window()
    local wins = vim.api.nvim_list_wins()
    local count = 0

    for _, v in ipairs(wins) do
        local win = vim.api.nvim_win_get_config(v).relative

        if win == "" then
            count = count + 1
        end
    end

    return count == 1
end
local function random_message()
    return message[math.random(#message)]
end

local function user_wants_to_quit()
    return vim.fn.confirm(random_message(), "&Yes\n&No", 2, "Question") == 1
end

local function quit(opts)
    local ok, result = pcall(vim.cmd.quit, opts)
    if not ok then
        if result then
            vim.notify(result)
        else
            vim.notify("ConfirmQuit: Error while quitting")
        end
    end
end

local function quitall(opts)
    local ok, result = pcall(vim.cmd.quit, opts)
    if not ok then
        if result then
            vim.notify(result)
        else
            vim.notify("ConfirmQuit: Error while quitting")
        end
    end
end

function M.confirm_quit(opts)
    if opts.bang == true then
        quit({ bang = true })
    end

    local is_last_tab_page = vim.fn.tabpagenr("$") == 1

    if not is_last_window() then
        quit()
        return
    end
    if not is_last_tab_page then
        quit()
        return
    end

    if user_wants_to_quit() then
        quit()
    end
end

function M.confirm_quit_all(opts)
    if opts.bang == true then
        quitall({ bang = true })
    end
    if user_wants_to_quit() then
        quitall()
    end
end

local function setup_cmdline_quit()
    if config.overwrite_q_command then
        vim.cmd([[ cnoreabbrev <expr> q (getcmdtype() == ":" && getcmdline() ==# "q") ? "ConfirmQuit" : "q" ]])
        vim.cmd([[ cnoreabbrev qq quit ]])
        vim.cmd([[ cnoreabbrev Q quit ]])
    end

    vim.api.nvim_create_user_command("ConfirmQuit", function(opts)
        M.confirm_quit(opts)
    end, { force = true, bang = true })

    vim.api.nvim_create_user_command("ConfirmQuitAll", function(opts)
        M.confirm_quit_all(opts)
    end, { force = true, bang = true })
end

function M.setup()
    setup_cmdline_quit()
end

return M
