function get_color_values(color)
    local red = tonumber(color:sub(2, 3), 16)
    local green = tonumber(color:sub(4, 5), 16)
    local blue = tonumber(color:sub(6, 7), 16)
    return { red, green, blue }
end

--- Inspired from https://github.com/fitrh/init.nvim
--- Blends top color over bottom color
---@param top string @#RRGGBB
---@param bottom string @#RRGGBB
---@param alpha float
function blend_colors(top, bottom, alpha)
    local top_rgb = get_color_values(top)
    local bottom_rgb = get_color_values(bottom)
    local function blend(c)
        c = (alpha * top_rgb[c] + ((1 - alpha) * bottom_rgb[c]))
        return math.floor(math.min(math.max(0, c), 255) + 0.5)
    end
    return ("#%02X%02X%02X"):format(blend(1), blend(2), blend(3))
end

local function define_highlights()
    local values = string.format("#%x", vim.api.nvim_get_hl_by_name("Normal", true).background )
    for kind, _ in pairs(require("utils.ui.kind_symbols").Completion) do
        local inherit = ("CmpItemKind%s"):format(kind)
        local fg = vim.api.nvim_get_hl_by_name(inherit, true).foreground
        if fg then
            local foreground = string.format("#%x", fg)
            if praestrictus.config.cmp_theme == "border" then
                vim.api.nvim_set_hl(0, ("CmpItemKind%s"):format(kind_name), {
                    fg = foreground,
                })
            elseif praestrictus.config.cmp_theme == "no-border" then
                vim.api.nvim_set_hl(0, inherit, {
                    fg = foreground,
                    bg = blend_colors(foreground, values, 0.15),
                })
                vim.api.nvim_set_hl(0, ("CmpItemKindMenu%s"):format(kind), {
                    fg = foreground,
                })

            end

        end
    end
end
define_highlights()
