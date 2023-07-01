local M = {}

local function has_value(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end

local clipboard_commands = {
    ["xsel"] = {
        ["unnamed"] = "xsel -i --clipboard",
        ["unnamedplus"] = "xsel -i --primary",
    },
    ["xclip"] = {
        ["unnamed"] = "xclip -i -selection clipboard",
        ["unnamedplus"] = "xclip -i -selection primary",
    },
}

local function execute_command(command, register)
    if vim.fn.executable(command) == 1 then
        vim.fn.system(command, register)
        return true
    end
    return false
end

function M.save()
    if vim.fn.has("clipboard") == 0 or os.getenv("DISPLAY") == nil or os.getenv("WAYLAND_DISPLAY") == nil then
        return
    end

    local clipboard_supported = false

    for executable, commands in pairs(clipboard_commands) do
        for clipboard_option, command in pairs(commands) do
            if has_value(vim.opt.clipboard, clipboard_option) then
                clipboard_supported = execute_command(executable, command, vim.fn.getreg(clipboard_option))
                if clipboard_supported then
                    break
                end
            end
        end
        if clipboard_supported then
            break
        end
    end

    if not clipboard_supported then
        return
    end
end
function M.setup()
    lambda.augroup("save_clipboard_on_exit", {
        {
            event = { "VimLeavePre" },
            pattern = "*",
            command = function()
                if lambda.config.save_clipboard_on_exit then
                    require("utils.plugins.save_clipboard_on_exit").save()
                end
            end,
            once = false,
        },
    })
end
return M
