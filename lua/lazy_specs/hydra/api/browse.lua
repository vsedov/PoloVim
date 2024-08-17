local leader = ";b"

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

local config = {
    Browse = {
        color = "red",
        body = leader,
        mode = { "n" },
        ["<ESC>"] = { nil, { exit = true } },

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

        g = { require("utils.telescope").devdocs_ft, { exit = true, desc = "Dev Doc search ft" } },
        f = { require("utils.telescope").devdocs_search, { exit = true, desc = "Dev Doc search" } },
        F = { require("utils.telescope").google_search, { exit = true, desc = "Google search" } },
    },
}
local bracket = { "<CR>", "s", "w", "W", "g", "f", "F" }

return {
    config,
    "Browse",
    { { "d", "D", "z", "K" }, { "l", "j", "k" } },
    bracket,
    6,
    3,
}
