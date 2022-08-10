if lambda.config.loaded_confirm_quit ~= true then
    return
end
local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end
-- https://github.com/NTBBloodbath/nvim.fnl/blob/5226c19e70d466b2a61da9552ac60ab761f42022/fnl/utils/quit.fnl
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
local function is_last_window()
    local wins = vim.api.nvim_list_wins()
    local count = 0
    for i, v in ipairs(wins) do
        local win = vim.api.nvim_win_get_config(v).relative
        if win == "" then
            count = count + 1
        end
    end
    if count == 1 then
        return true
    end
    return false
end

local function random_message(mess)
    return mess[math.random(1, #mess)]
end
function _G.confirm_quit()
    if vim.fn.getcmdtype() == ":" and vim.fn.getcmdline() == "q" then
        if is_last_window() and vim.fn.tabpagenr("$") == 1 then
            if vim.fn.confirm(random_message(message), "&Yes\n&No", 2) ~= 1 then
                return false
            end
        end
    end
    return true
end

vim.cmd([[cnoreabbrev <expr> q (luaeval(v:lua.confirm_quit())) ? 'q' : '']])
vim.cmd([[cnoreabbrev qq  quit]])
vim.api.nvim_create_user_command("Q", "qall<bang>", { force = true, bang = true })

vim.g.confirm_quit_isk_save = ""

lambda.augroup("confirm-quit", {
    {
        -- automatically check for changed files outside vim
        event = { "CmdlineEnter" },
        pattern = ":",
        command = function()
            vim.g.confirm_quit_isk_save = vim.bo.iskeyword
            vim.opt_local.iskeyword:append("!")
        end,
        once = false,
    },
    {
        event = { "CmdlineLeave" },
        patter = ":",
        command = function()
            vim.bo.iskeyword = vim.g.confirm_quit_isk_save
        end,
        once = false,
    },
})
