local M = {}

function setup()
    local conditions = require("heirline.conditions")
    local utils = require("heirline.utils")

    local colors = {
        diag = {
            error = utils.get_highlight("DiagnosticError").fg,
            hint = utils.get_highlight("DiagnosticHint").fg,
            info = utils.get_highlight("DiagnosticInfo").fg,
            warn = utils.get_highlight("DiagnosticWarn").fg,
        },
        git = {
            del = utils.get_highlight("diffRemoved").fg,
            add = utils.get_highlight("diffAdded").fg,
            change = utils.get_highlight("diffChanged").fg,
        },
    }

    local space = { provider = " " }
    local align = { provider = "%=" }

    -- Setup statuslines
    local statusline_default = {
        { provider = "Active!" },
        align,
    }
    local statusline_inactive = {
        condition = function()
            return not conditions.is_active()
        end,

        { provider = "Inactive..." },
        align,
    }

    local statuslines = {
        hl = function()
            if conditions.is_active() then
                local h = utils.get_highlight("StatusLine")
                return { fg = h.fg, bg = h.bg }
            else
                local h = utils.get_highlight("StatusLineNC")
                return {
                    fg = h.fg,
                    bg = h.bg,
                }
            end
        end,
        init = utils.pick_child_on_condition,
        statusline_inactive,
        statusline_default,
    }

    require("heirline").setup(statuslines)
end

setup()
