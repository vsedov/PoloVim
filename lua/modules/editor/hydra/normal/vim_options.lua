local Hydra = require("hydra")

local hint = [[
  ^ ^        Options
  ^
  _v_ %{ve} virtual edit
  _i_ %{list} invisible characters
  _s_ %{spell} spell
  _w_ %{wrap} wrap
  _c_ %{cul} cursor line
  _n_ %{nu} number
  _r_ %{rnu} relative number
  _[_ %{cuc} cursorcolumn
  _]_ %{cul} cursorline
  ^
       ^^^^                _<Esc>_
]]

Hydra({
    name = "Options",
    hint = hint,
    config = {
        color = "amaranth",
        invoke_on_body = true,
        hint = {
            position = "middle-right",
        },
    },
    mode = { "n", "x" },
    body = ";o",
    heads = {
        {
            "n",
            function()
                if vim.o.number == true then
                    vim.o.number = false
                else
                    vim.o.number = true
                end
            end,
            { desc = "number" },
        },
        {
            "r",
            function()
                if vim.o.relativenumber == true then
                    vim.o.relativenumber = false
                else
                    vim.o.number = true
                    vim.o.relativenumber = true
                end
            end,
            { desc = "relativenumber" },
        },
        {
            "v",
            function()
                if vim.o.virtualedit == "all" then
                    vim.o.virtualedit = "block"
                else
                    vim.o.virtualedit = "all"
                end
            end,
            { desc = "virtualedit" },
        },
        {
            "i",
            function()
                if vim.o.list == true then
                    vim.o.list = false
                else
                    vim.o.list = true
                end
            end,
            { desc = "show invisible" },
        },
        {
            "s",
            function()
                if vim.o.spell == true then
                    vim.o.spell = false
                else
                    vim.o.spell = true
                end
            end,
            { exit = true, desc = "spell" },
        },
        {
            "w",
            function()
                if vim.o.wrap ~= true then
                    vim.o.wrap = true
                    -- Dealing with word wrap:
                    -- If cursor is inside very long line in the file than wraps
                    -- around several rows on the screen, then 'j' key moves you to
                    -- the next line in the file, but not to the next row on the
                    -- screen under your previous position as in other editors. These
                    -- bindings fixes this.
                    vim.keymap.set("n", "k", function()
                        return vim.v.count > 0 and "k" or "gk"
                    end, { expr = true, desc = "k or gk" })
                    vim.keymap.set("n", "j", function()
                        return vim.v.count > 0 and "j" or "gj"
                    end, { expr = true, desc = "j or gj" })
                else
                    vim.o.wrap = false
                    vim.keymap.del("n", "k")
                    vim.keymap.del("n", "j")
                end
            end,
            { desc = "wrap" },
        },
        {
            "[",
            function()
                vim.opt.cursorcolumn = not vim.opt.cursorcolumn
            end,
            { desc = "Toggle the cursorcolumn" },
        },

        {
            "]",
            function()
                require("reticle").toggle_cursorline()
            end,
            { desc = "Toggle the cursorline" },
        },

        {
            "c",
            function()
                if vim.o.cursorline == true then
                    vim.o.cursorline = false
                else
                    vim.o.cursorline = true
                end
            end,
            { desc = "cursor line" },
        },

        { "<Esc>", nil, { exit = true } },
    },
})
