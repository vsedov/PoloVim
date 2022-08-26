-- https://github.com/josephsdavid/neovim2/blob/master/lua/core/hydra.lua
local Hydra = require("hydra")

local function colorcycler(reverse)
    local colors = vim.fn.getcompletion("", "color")
    local ccol = vim.g.colors_name
    local len = #colors
    local i = 1
    for index, value in ipairs(colors) do
        if value == ccol then
            i = index
        end
    end
    return function()
        if reverse then
            i = i - 1
        else
            i = i + 1
        end
        if i > len then
            i = 1
        elseif i < 1 then
            i = len
        end
        local out = colors[i]
        local loader = require("packer").loader
        print(out)
        local valid = lambda.config.colourscheme.themes.dark
        -- if out contains a valid theme, load it like kanagawa is in kangawa.nvim
        -- check if it matches or contains

        for _, theme in ipairs(valid) do
            if out:find(theme) then
                loader(theme)
                break
            end
        end

        vim.cmd("colorscheme " .. out)
        print("using colorcheme: " .. out)
    end
end

Hydra({
    name = "Color Cycler",
    mode = "n",
    body = "<localleader>C",
    config = {
        color = "amaranth",
        invoke_on_body = true,
        hint = {
            border = "single",
            position = "middle",
        },
    },

    heads = {
        { "j", colorcycler(false), { desc = "next colorscheme" } },
        { "k", colorcycler(true), { desc = "previous colorscheme" } },
    },
})
