local fn = vim.fn
local api = vim.api
local fmt = string.format
local H = lambda.highlight

local function fileicon()
    local name = fn.bufname()
    local icon, hl
    local loaded, devicons = lambda.require("nvim-web-devicons")
    if loaded then
        icon, hl = devicons.get_icon(name, fn.fnamemodify(name, ":e"), { default = true })
    end
    return icon, hl
end
function title_string()
    local dir = fn.fnamemodify(fn.getcwd(), ":t")
    local icon, hl = fileicon()
    if not hl then
        return (icon or "") .. " "
    end
    local has_tmux = vim.env.TMUX ~= nil
    return has_tmux and fmt("%s #[fg=%s]%s ", dir, H.get(hl, "fg"), icon) or dir .. " " .. icon
end

function clear_pane_title()
    fn.jobstart("tmux set-window-option automatic-rename on")
end

local M = {}
M.setup = function()
    lambda.augroup("External", {
        {
            event = { "BufEnter" },
            pattern = "*",
            command = function()
                vim.o.titlestring = title_string()
            end,
        },
    })
end
return M
