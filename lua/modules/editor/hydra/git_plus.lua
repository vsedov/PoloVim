local Hydra = require("hydra")
local gitrepo = vim.fn.isdirectory(".git/index")
local cmd = require("hydra.keymap-util").cmd

local function caller(options, ch)
    require("guihua.gui").select(options, {
        prompt = "Select a choice",
        format_item = function(item)
            return "Octo " .. ch .. " " .. item
        end,
    }, function(choice)
        if
            vim.tbl_contains({
                "issue",
                "gist",
                "pr",
                "search",
                "comment",
            }, ch)
        then
            if
                vim.tbl_contains({
                    "search",
                    "list",
                    "edit",
                    "create",
                }, choice)
            then
                require("guihua.gui").input({
                    prompt = "Enter a option for " .. ch .. " > ",
                    default = " 1",
                }, function(choice_2)
                    vim.cmd("Octo " .. ch .. " " .. choice .. " " .. choice_2)
                end)
            end
        else
            vim.cmd("Octo " .. ch .. " " .. choice)
        end
    end)
end

if gitrepo then
    local octo_hint = [[
^ Navigation
^ _g_: Gists
^ _i_: Issues
^ _p_: Pull Requests
^ _r_: Repos
^ _s_: Search
^ _C_: Card
^ _c_: Comment
^ _l_: label
^ _t_: thread
^ _R_: Review
^ _-_: React
^ _q_: Quit
]]
    Hydra({
        name = "Octo",
        mode = "n",
        body = "<leader>o",
        hint = octo_hint,
        config = {
            hint = {
                position = "middle-right",
                border = lambda.style.border.type_0,
            },
            timeout = false,
            invoke_on_body = true,
        },
        heads = {
            {
                "g",
                cmd("Octo gist"),
                { exit = false },
            },
            {
                "i",
                -- cmd("Octo issue"),
                function()
                    options = {
                        "close",
                        "create",
                        "edit",
                        "list",
                        "search",
                        "reload",
                        "browser",
                        "url",
                    }
                    caller(options, "issue")
                end,

                { exit = true },
            },
            {
                "p",
                function()
                    options = {
                        "create",
                        "list",
                        "search",
                        "edit",
                        "reopen",
                        "checkout",
                        "commits",
                        "changes",
                        "diff",
                        "ready",
                        "merge",
                        "checks",
                        "reload",
                        "url",
                    }
                    caller(options, "pr")
                end,

                { exit = true },
            },
            {
                "r",
                function()
                    options = {
                        "list",
                        "fork",
                        "browser",
                        "url",
                        "view",
                    }
                    caller(options, "repo")
                end,

                { exit = true },
            },
            {
                "s",
                cmd("Octo Search"),
                { exit = true },
            },

            {
                "C",
                function()
                    options = {
                        "add",
                        "remove",
                        "move",
                    }
                    caller(options, "card")
                end,
                { exit = true },
            },

            {
                "l",
                cmd("Octo label"),
                { exit = true },
            },

            {
                "t",
                cmd("Octo thread"),
                { exit = true },
            },
            {
                "R",
                function()
                    options = {
                        "start",
                        "submit",
                        "resume",
                        "discard",
                        "comments",
                        "commit",
                        "close",
                    }
                    caller(options, "review")
                end,
                { exit = true },
            },
            {
                "c",
                function()
                    options = {
                        "add",
                        "delete",
                    }
                    caller(options, "comment")
                end,
                { exit = true },
            },
            {
                "-",
                function()
                    options = {
                        "thumbs_up",
                        "thumbs_down",
                        "eyes",
                        "laugh",
                        "confused",
                        "rocket",
                        "heart",
                        "hooray",
                        "party",
                        "tada",
                    }
                    caller(options, "reaction add")
                end,
                { exit = true },
            },

            { "q", nil, { exit = true } },
        },
    })
end
