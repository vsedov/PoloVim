local M = {}

local function has_value(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end

function M.save()
    if vim.fn.has("clipboard") == 0 then
        return
    end
    if os.getenv("$DISPLAY") == nil or os.getenv("WAYLAND_DISPLAY") == nil then
        return
    end

    if vim.fn.executable("xsel") == 1 then
        if has_value(vim.opt.clipboard, "unnamed") then
            vim.fn.system("xsel -i --clipboard", vim.fn.getreg("*"))
        end
        if has_value(vim.opt.clipboard, "unnamedplus") then
            vim.fn.system("xsel -i --primary", vim.fn.getreg("+"))
        end
    elseif vim.fn.executable("xclip") == 1 then
        if has_value(vim.opt.clipboard, "unnamed") then
            vim.fn.system("xclip -i -selection clipboard", vim.fn.getreg("*"))
        end
        if has_value(vim.opt.clipboard, "unnamedplus") then
            vim.fn.system("xclip -i -selection primary", vim.fn.getreg("+"))
        end
    end
end

function M.setup()
    lambda.augroup("save_clipboard_on_exit", {
        {
            event = { "VimLeave" },
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
