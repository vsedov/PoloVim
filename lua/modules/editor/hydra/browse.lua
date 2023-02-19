local utils = require("modules.editor.hydra.utils")
local hydra = require("hydra")
local config = {}
local exit = { nil, { exit = true, desc = "EXIT" } }

local bookmarks = {
    default = {
        ["github"] = {
            ["name"] = "search github from neovim",
            ["code_search"] = "https://github.com/search?q=%s&type=code",
            ["repo_search"] = "https://github.com/search?q=%s&type=repositories",
            ["issues_search"] = "https://github.com/search?q=%s&type=issues",
            ["pulls_search"] = "https://github.com/search?q=%s&type=pullrequests",
        },
        ["medium"] = {
            ["name"] = "Search Medium for data",
            ["data_science"] = "https://towardsdatascience.com/search?q=%s",
            ["article_lookup "] = "https://medium.com/search?q=%s",
        },
        ["pytorch"] = {
            ["name"] = "Search Pytorch Docs and Forms",
            ["tutorial_search"] = "https://pytorch.org/tutorials/search.html?q=%s&check_keywords=yes&area=default",
            ["torch_docs"] = "https://pytorch.org/docs/stable/search.html?q=%s&check_keywords=yes&area=default",
            ["torch_audio"] = "https://pytorch.org/audio/stable/search.html?q=%s&check_keywords=yes&area=default",
            ["torch_text"] = "https://pytorch.org/text/stable/search.html?q=%s&check_keywords=yes&area=default",
            ["torch_vision"] = "https://pytorch.org/vision/stable/search.html?q=%s&check_keywords=yes&area=default",
            ["torch_arrow"] = "https://pytorch.org/torcharrow/beta/search.html?q=%s&check_keywords=yes&area=default",
            ["torch_data"] = "https://pytorch.org/data/beta/search.html?q=%s&check_keywords=yes&area=default",
            ["torch_rec"] = "https://pytorch.org/torchrec/stable/search.html?q=%s&check_keywords=yes&area=default",
            ["torch_serve"] = "https://pytorch.org/serve/stable/search.html?q=%s&check_keywords=yes&area=default",
        },
    },
    alias = {
        ["github_code_search"] = "https://github.com/search?q=%s&type=code",
        ["github_repo_search"] = "https://github.com/search?q=%s&type=repositories",
    },
    query = {
        "https://github.com/search?q=%s&type=code",
        "https://github.com/search?q=%s&type=repositories",
    },
}

local items = {}
for i, v in pairs(bookmarks) do
    table.insert(items, i)
end

local bookmark_surfer = function()
    vim.ui.select(items, { prompt = "search: ", default = "default" }, function(item)
        require("browse").open_bookmarks({ bookmarks = bookmarks[item] })
    end)
end

local bracket = { "<CR>", "s", "w", "W", ";" }
config.browse = {
    color = "red",
    body = "<leader><cr>",
    mode = { "n", "v", "x", "o" },
    ["<ESC>"] = { nil, { exit = true } },

    [";"] = {
        function()
            vim.cmd([[Telescope bookmarks]])
        end,
        { nowait = true, exit = true, desc = "BookMarks" },
    },

    w = {
        function()
            bookmark_surfer()
        end,
        { nowait = true, exit = true, desc = "BMSurfer" },
    },

    s = {
        function()
            require("browse").input_search()
        end,
        { nowait = true, exit = true, desc = "Search" },
    },
    ["<CR>"] = {
        function()
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<leader>d", true, false, true), "x", true)
        end,
        { nowait = true, exit = true, desc = "Doc Hydra" },
    },

    W = {
        function()
            require("browse").browse({ bookmarks = bookmarks["default"] })
        end,
        { nowait = true, exit = true, desc = "Browse" },
    },

    d = {
        function()
            require("browse.devdocs").search()
        end,
        { nowait = true, exit = true, desc = "DevDoc[S]" },
    },

    D = {
        function()
            require("browse.devdocs").search_with_filetype()
        end,
        { nowait = true, exit = true, desc = "DevDocsFT" },
    },

    z = {
        function()
            vim.cmd("Zeavim")
        end,
        { nowait = true, silent = true, desc = "Zeal", exit = true },
    },
    K = {
        function()
            vim.cmd("DD")
        end,
        { nowait = true, silent = true, desc = "DevDocCursor", exit = true },
    },

    l = {
        function()
            require("updoc").lookup()
        end,

        { nowait = true, silent = true, desc = "UpDoc Lookup", exit = true },
    },
    j = {
        function()
            vim.defer_fn(function()
                require("updoc").search()
            end, 100)
        end,
        { nowait = true, silent = true, desc = "UpDoc Search", exit = true },
    },

    k = {
        function()
            require("updoc").show_hover_links()
        end,

        { nowait = true, silent = true, desc = "UpDoc Links", exit = true },
    },
    ["<leader>"] = {
        function()
            require("browse.mdn").search()
        end,
        { nowait = true, exit = true, desc = "mdn" },
    },
}

local function auto_hint_generate()
    container = {}
    for x, y in pairs(config.browse) do
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

    core_table = {}

    utils.make_core_table(core_table, bracket)
    utils.make_core_table(core_table, { "d", "D", "z", "K" })
    utils.make_core_table(core_table, { "l", "j", "k", "<leader>" })

    hint_table = {}
    string_val = "^ ^     Browser   ^ ^\n\n"
    string_val = string_val .. "^ ^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^ ^\n"

    for _, v in pairs(core_table) do
        if v == "\n" then
            hint = "\n"
            hint = hint .. "^ ^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^ ^\n"
        else
            if container[v] then
                hint = "^ ^ _" .. v .. "_: " .. container[v] .. " ^ ^\n"
            end
        end
        table.insert(hint_table, hint)
        string_val = string_val .. hint
    end
    return string_val
end

vim.defer_fn(function()
    local new_hydra = require("modules.editor.hydra.utils").new_hydra(config, {
        name = "Browser",
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

    val = auto_hint_generate()
    new_hydra.hint = val
    hydra(new_hydra)
end, 100)
