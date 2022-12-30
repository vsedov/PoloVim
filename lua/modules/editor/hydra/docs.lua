-- local km = require("core.keymap")
local Hydra = require("hydra")
local cmd = require("hydra.keymap-util").cmd

if table.unpack == nil then
    table.unpack = unpack
end

local config = {}

local exit = { nil, { exit = true, desc = "EXIT" } }
-- TODO: make a toggler for cursorhold events, so we can show peek
function toggle(lhs, on_enter, on_exit)
    return {
        color = "pink",
        body = lhs,
        [lhs] = exit,
        on_exit = on_exit,
        on_enter = on_enter,
    }
end

local hints = [[
 ^^^^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^^^^
 ^^^^             Doc gen and References            ^^^^
 ^^^^                                              ^^^^
 ^^^^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^^^^
                    _d_: Gen Docs

    _c_: Gen Class        ▕          _i_: Ref Type
                        ▕
    _s_: Gen Type         ▕          _p_: Ref Go

 ^^^^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^^^^
 ^^^^               Documentation Search           ^^^^
 ^^^^                                              ^^^^
 ^^^^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^^^^
                    _D_: Live Docs
                    _l_: ULook
                           
    _j_: USearch          ▕          _o_: UShowLink
    _z_: Zeavim           ▕          _k_: DevDocs

 ^^^^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^^^^
 ^^^^               Language Specifc Docs          ^^^^
 ^^^^                                              ^^^^
 ^^^^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^^^^
    _[_: Dotted                      _]_: Pytest
]]

config.doc_binds = {
    color = "pink",
    body = "<leader>d",
    mode = { "n", "v", "x", "o" },
    ["<Esc>"] = { nil, { exit = true } },
    -- Neogen stuff
    d = {
        function()
            require("neogen").generate()
        end,
        { nowait = true, silent = true, desc = "Gen Doc", exit = true },
    },
    c = {
        function()
            require("neogen").generate({ type = "class" })
        end,
        { nowait = true, silent = true, desc = "Gen class", exit = true },
    },
    s = {
        function()
            require("neogen").generate({ type = "type" })
        end,
        { nowait = true, silent = true, desc = "Gen type", exit = false },
    },

    -- Reference Stuff
    i = {
        cmd("RefCopy"),
        { nowait = true, silent = true, desc = "refCopy", exit = true },
    },
    p = {
        cmd("RefGo"),
        { nowait = true, silent = true, desc = "RefGo", exit = true },
    },
    -- Documentation types ?
    D = {
        cmd("DocsViewToggle"),
        { nowait = true, silent = true, desc = "Live Docs", exit = true },
    },
    z = {
        cmd("Zeavim"),
        { nowait = true, silent = true, desc = "Zeal", exit = true },
    },
    k = {
        cmd("DD"),
        { nowait = true, silent = true, desc = "DevDoc Search", exit = true },
    },
    ------------
    ------------

    l = {
        function()
            require("updoc").lookup()
        end,
        { exit = true },
    },
    j = {
        function()
            vim.defer_fn(function()
                require("updoc").search()
            end, 100)
        end,
        { exit = true },
    },

    o = {
        function()
            require("updoc").show_hover_links()
        end,
        { exit = true },
    },

    ------------
    -----------

    --- Python stuff Language specific stuff
    ["["] = {
        cmd("PythonCopyReferenceDotted"),
        { nowait = true, silent = true, desc = "Python Dotted", exit = true },
    },
    ["]"] = {
        cmd("PythonCopyReferencePytest"),
        { nowait = true, silent = true, desc = "Python Pytest", exit = true },
    },
}

local mapping = {
    color = function(t, rhs)
        t.config.color = rhs
    end,
    body = function(t, rhs)
        t.body = rhs
    end,
    on_enter = function(t, rhs)
        t.config.on_enter = rhs
    end,
    on_exit = function(t, rhs)
        t.config.on_exit = rhs
    end,
    mode = function(t, rhs)
        t.config.mode = rhs
    end,
}

local new_hydra = {
    hint = hints,
    name = "core",

    config = {
        hint = {
            position = "middle-right",
            border = lambda.style.border.type_0,
        },
        invoke_on_body = true,
        timeout = false,
    },
    heads = {},
}

for name, spec in pairs(config) do
    for lhs, rhs in pairs(spec) do
        local action = mapping[lhs]
        if action == nil then
            new_hydra.heads[#new_hydra.heads + 1] = { lhs, table.unpack(rhs) }
        else
            action(new_hydra, rhs)
        end
    end
end

Hydra(new_hydra)
