-- local km = require("core.keymap")
local hydra = require("hydra")

if table.unpack == nil then
    table.unpack = unpack
end

local mx = function(feedkeys)
    return function()
        local keys = vim.api.nvim_replace_termcodes(feedkeys, true, false, true)
        vim.api.nvim_feedkeys(keys, "m", false)
    end
end

-- NOTE:
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

config.parenth_mode = {
    color = "pink",
    body = "\\<leader>",
    mode = { "n", "v", "x", "o" },
    ["<Esc>"] = { nil, { exit = true, desc = false } },
    ["\\<leader>"] = { nil, { exit = true, desc = false } },
    j = {
        function()
            vim.fn.search("[({[]")
        end,
        { nowait = true, desc = "next" },
    },
    k = {
        function()
            vim.fn.search("[({[]", "b")
        end,
        { nowait = true, desc = "next" },
    },
    J = {
        function()
            vim.fn.search("[)}\\]]")
        end,
        { nowait = true, desc = "next" },
    },
    K = {
        function()
            vim.fn.search("[)}\\]]", "b")
        end,
        { nowait = true, desc = "next" },
    },
    [")"] = { mx("ysi%)"), { nowait = true, desc = "i)" } },
    ["("] = { mx("ysa%)"), { nowait = true, desc = "a(" } },
    ["]"] = { mx("ysi%]"), { nowait = true, desc = "i]" } },
    ["["] = { mx("ysa%]"), { nowait = true, desc = "a[" } },
    ["}"] = { mx("ysi%}"), { nowait = true, desc = "i}" } },
    ["{"] = { mx("ysa%{"), { nowait = true, desc = "a{" } },
    ["f"] = { mx("ysa%f"), { nowait = true, desc = "af" } },
    ["F"] = { mx("ysi%f"), { nowait = true, desc = "iF" } },
}

for surround, motion in pairs({ i = "j", a = "k" }) do
    for doc, key in pairs({ d = "d", c = "c", y = "y" }) do
        local motiondoc = surround
        -- if motion == "j" then motiondoc = "i" else motiondoc = "i" end
        local mapping = table.concat({ key, motion })
        config.parenth_mode[mapping] = {
            mx(table.concat({ key, surround, "%" })),
            { nowait = true, desc = table.concat({ doc, motiondoc }) },
        }
    end
end

local harpoon_hint = [[
^ ^▔▔▔▔▔▔▔▔▔▔▔▔ ^ ^
^ ^   _j_: next
    _k_: prev
    _J_: next
    _K_: prev
    _)_: i)
    _(_: a)
    _]_: i]
    _[_: a]
    _}_: i}
    _{_: a{
    _f_: af
    _F_: iF

    _cj_: ci
    _yj_: yi
    _ck_: ca
    _yk_: ya
    _dj_: di
    _dk_: da

^ ^ _<Esc>_: quit^ ^
]]

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
-- Make a bind view

--#region

for name, spec in pairs(config) do
    local new_hydra = {
        hint = harpoon_hint,
        name = name,
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
    for lhs, rhs in pairs(spec) do
        local action = mapping[lhs]
        if action == nil then
            new_hydra.heads[#new_hydra.heads + 1] = { lhs, table.unpack(rhs) }
        else
            action(new_hydra, rhs)
        end
    end
    hydra(new_hydra)
end
