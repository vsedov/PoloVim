if lambda.config.use_lightspeed or lambda.config.use_both_leap_light_speed then
    local Hydra = require("hydra")
    local function starts(String, Start)
        return string.sub(String, 1, string.len(Start)) == Start
    end

    local leader = "<leader>l"
    local hydra = require("hydra")

    local bracket = { "j", "t", "u" }

    local function make_core_table(core_table, second_table)
        for _, v in pairs(second_table) do
            table.insert(core_table, v)
        end
        table.insert(core_table, "\n")
    end
    local function isInteger(str)
        return not (str == "" or str:find("%D")) -- str:match("%D") also works
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

        ["t"] = {
            function()
                vim.ui.input({ prompt = "Enter a number you want to tag > ", default = "1" }, function(index)
                    if isInteger(index) then
                        require("harpoon.ui").nav_file(tonumber(index))
                    end
                end)
            end,
            { nowait = true, desc = "Tag File X", exit = false },
        },

        ["u"] = {
            function()
                vim.ui.input({ prompt = "Enter a number you want to untag > ", default = "1" }, function(index)
                    if isInteger(index) then
                        require("harpoon.ui").nav_file(tonumber(index))
                    end
                end)
            end,
            { nowait = true, desc = "UnTag File X", exit = false },
        },

        ["j"] = {
            function()
                vim.ui.input({ prompt = "Enter a number to jump to   > ", default = "1" }, function(index)
                    if isInteger(index) then
                        require("harpoon.ui").nav_file(tonumber(index))
                    end
                end)
            end,
            { nowait = true, desc = "Goto File X", exit = false },
        },
    }

    local new_hydra = require("modules.editor.hydra.utils").new_hydra(config, {
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
    })

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

        core_table = {}

        make_core_table(core_table, bracket)
        make_core_table(core_table, graple)

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
