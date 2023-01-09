if lambda.config.use_lightspeed or lambda.config.use_both_leap_light_speed then
    local Hydra = require("hydra")
    local function starts(String, Start)
        return string.sub(String, 1, string.len(Start)) == Start
    end

    local leader = "<leader>l"
    local hydra = require("hydra")

    local bracket = {}

    local function make_core_table(core_table, second_table)
        for _, v in pairs(second_table) do
            table.insert(core_table, v)
        end
        table.insert(core_table, "\n")
    end

    local function create_table_normal(var, sorted, string_len, start_val)
        start_val = start_val or nil
        var = {}
        for _, v in pairs(sorted) do
            if string.len(v) == string_len and not vim.tbl_contains(bracket, v) then
                if start_val ~= nil then
                    if type(start_val) == "table" then
                        if vim.tbl_contains(start_val, v) then
                            table.insert(var, v)
                        end
                    else
                        if starts(v, start_val) then
                            table.insert(var, v)
                        end
                    end
                else
                    table.insert(var, v)
                end
            end
        end
        table.sort(var, function(a, b)
            return a:lower() < b:lower()
        end)

        return var
    end

    local config = {}

    local exit = { nil, { exit = true, desc = "EXIT" } }
    config.parenth_mode = {
        color = "red",
        body = leader,
        mode = { "n", "v", "x", "o" },
        ["<ESC>"] = { nil, { exit = true } },
        k = {
            function()
                require("grapple").toggle()
            end,
            { nowait = true, exit = true, desc = "[G] Toggle" },
        },
        m = {
            function()
                require("grapple").tag()
            end,
            { nowait = true, exit = true, desc = "[G] Tag" },
        },
        M = {
            function()
                require("grapple").untag()
            end,
            { nowait = true, exit = true, desc = "[G] UnTag" },
        },
        P = {
            function()
                require("grapple").popup_tags("global")
            end,
            { nowait = true, exit = true, desc = "[G] Popup Global" },
        },
        S = {
            function()
                require("grapple").popup_tags()
            end,
            { nowait = true, exit = true, desc = "[G] Popup All" },
        },
        s = {
            function()
                require("grapple").popup_scopes()
            end,
            { nowait = true, exit = true, desc = "[G] Popup Scope" },
        },
        R = {
            function()
                require("grapple").reset()
            end,
            { nowait = true, exit = true, desc = "[G] Reset" },
        },

        ["t1"] = {
            function()
                require("grapple").tag({ key = 1 })
            end,
            { nowait = true, desc = "Tag File 1", exit = false },
        },
        ["t2"] = {
            function()
                require("grapple").tag({ key = 2 })
            end,
            { nowait = true, desc = "Tag File 2", exit = false },
        },
        ["t3"] = {
            function()
                require("grapple").tag({ key = 3 })
            end,
            { nowait = true, desc = "Tag File 3", exit = false },
        },
        ["t4"] = {
            function()
                require("grapple").tag({ key = 4 })
            end,
            { nowait = true, desc = "Tag File 4", exit = false },
        },
        ["t5"] = {
            function()
                require("grapple").tag({ key = 5 })
            end,
            { nowait = true, desc = "Tag File 5", exit = false },
        },

        ["t6"] = {
            function()
                require("grapple").tag({ key = 6 })
            end,
            { nowait = true, desc = "Tag File 6", exit = false },
        },

        ["t7"] = {
            function()
                require("grapple").tag({ key = 7 })
            end,
            { nowait = true, desc = "Tag File 7", exit = false },
        },

        ["t8"] = {
            function()
                require("grapple").tag({ key = 8 })
            end,
            { nowait = true, desc = "Tag File 8", exit = false },
        },

        ["t9"] = {
            function()
                require("grapple").tag({ key = 9 })
            end,
            { nowait = true, desc = "Tag File 9", exit = false },
        },

        ["u1"] = {
            function()
                require("grapple").untag({ key = 1 })
            end,
            { nowait = true, desc = "UnTag File 1", exit = false },
        },
        ["u2"] = {
            function()
                require("grapple").untag({ key = 2 })
            end,
            { nowait = true, desc = "UnTag File 2", exit = false },
        },
        ["u3"] = {
            function()
                require("grapple").untag({ key = 3 })
            end,
            { nowait = true, desc = "UnTag File 3", exit = false },
        },
        ["u4"] = {
            function()
                require("grapple").untag({ key = 4 })
            end,
            { nowait = true, desc = "UnTag File 4", exit = false },
        },
        ["u5"] = {
            function()
                require("grapple").untag({ key = 5 })
            end,
            { nowait = true, desc = "UnTag File 5", exit = false },
        },

        ["u6"] = {
            function()
                require("grapple").untag({ key = 6 })
            end,
            { nowait = true, desc = "UnTag File 6", exit = false },
        },

        ["u7"] = {
            function()
                require("grapple").untag({ key = 7 })
            end,
            { nowait = true, desc = "UnTag File 7", exit = false },
        },

        ["u8"] = {
            function()
                require("grapple").untag({ key = 8 })
            end,
            { nowait = true, desc = "UnTag File 8", exit = false },
        },

        ["u9"] = {
            function()
                require("grapple").untag({ key = 9 })
            end,
            { nowait = true, desc = "UnTag File 9", exit = false },
        },

        ["1"] = {
            function()
                require("grapple").select({ key = 1 })
            end,
            { nowait = true, desc = "Goto File 1", exit = false },
        },
        ["2"] = {
            function()
                require("grapple").select({ key = 2 })
            end,
            { nowait = true, desc = "Goto File 2", exit = false },
        },
        ["3"] = {
            function()
                require("grapple").select({ key = 3 })
            end,
            { nowait = true, desc = "Goto File 3", exit = false },
        },
        ["4"] = {
            function()
                require("grapple").select({ key = 4 })
            end,
            { nowait = true, desc = "Goto File 4", exit = false },
        },
        ["5"] = {
            function()
                require("grapple").select({ key = 5 })
            end,
            { nowait = true, desc = "Goto File 5", exit = false },
        },

        ["6"] = {
            function()
                require("grapple").select({ key = 6 })
            end,
            { nowait = true, desc = "Goto File 6", exit = false },
        },

        ["7"] = {
            function()
                require("grapple").select({ key = 7 })
            end,
            { nowait = true, desc = "Goto File 7", exit = false },
        },

        ["8"] = {
            function()
                require("grapple").select({ key = 8 })
            end,
            { nowait = true, desc = "Goto File 8", exit = false },
        },

        ["9"] = {
            function()
                require("grapple").select({ key = 9 })
            end,
            { nowait = true, desc = "Goto File 9", exit = false },
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
    -- Create a Auto Hinting Table same as above but with auto generated

    local new_hydra = {
        name = "Grapple",
        config = {
            hint = {
                position = "middle-right",
                border = lambda.style.border.type_0,
            },
            timeout = false,
            invoke_on_body = true,
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

    --
    local function auto_hint_generate()
        container = {}
        for x, y in pairs(config.parenth_mode) do
            local mapping = x
            if type(y[1]) == "function" then
                for x, y in pairs(y[2]) do
                    if x == "desc" then
                        container[mapping] = y
                    end
                end
            end
        end
        sorted = {}
        for k, v in pairs(container) do
            table.insert(sorted, k)
        end
        table.sort(sorted)

        graple = create_table_normal({}, sorted, 1, { "k", "m", "M", "P", "s", "S", "R" })
        tags = create_table_normal({}, sorted, 2, "t")
        untags = create_table_normal({}, sorted, 2, "u")
        go = create_table_normal({}, sorted, 1, { "1", "2", "3", "4", "5", "6", "7", "8", "9" })

        core_table = {}

        make_core_table(core_table, bracket)
        make_core_table(core_table, graple)
        make_core_table(core_table, go)
        make_core_table(core_table, tags)
        make_core_table(core_table, untags)

        hint_table = {}
        string_val = "^ ^      Graple       ^ ^\n\n"
        string_val = string_val .. "^ ^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^ ^\n"

        for _, v in pairs(core_table) do
            if v == "\n" then
                hint = "\n"
                hint = hint .. "^ ^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^ ^\n"
            else
                hint = "^ ^ _" .. v .. "_: " .. container[v] .. " ^ ^\n"
            end
            table.insert(hint_table, hint)
            string_val = string_val .. hint
            -- end
        end
        return string_val
    end

    val = auto_hint_generate()
    new_hydra.hint = val
    hydra(new_hydra)
end
