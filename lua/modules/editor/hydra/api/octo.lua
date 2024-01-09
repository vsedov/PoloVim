local when = lambda.lib.when
local leader = "<leader>o"

local default_choice = {
    repo = "vsedov",
    pr = "all",
    issue = "all",
    label = "Bug",
    gist = "all",
}

local choice_edge_case = {
    all = "",
}

local function caller(options, ch)
    vim.ui.select(options, {
        prompt = "Select a choice",
        format_item = function(item)
            return "Octo " .. ch .. " " .. item
        end,
    }, function(choice)
        if choice == nil then
            return
        end
        when(
            vim.tbl_contains({
                "issue",
                "gist",
                "pr",
                "repo",
                "search",
                "label",
            }, ch),
            function()
                when(
                    vim.tbl_contains({
                        "search",
                        "list",
                        "edit",
                        "resolve",
                        "unresolve",
                        "add",
                        "remove",
                    }, choice),
                    function()
                        vim.ui.input({
                            prompt = "Enter a option for " .. ch .. " > ",
                            default = default_choice[ch],
                        }, function(choice_2)
                            if choice_2 == nil then
                                return
                            end
                            if vim.tbl_contains(options, choice_2) then
                                choice_2 = choice_edge_case[choice_2]
                            end
                            vim.cmd("Octo " .. ch .. " " .. choice .. " " .. choice_2)
                        end)
                    end,
                    function()
                        vim.cmd("Octo " .. ch .. " " .. choice)
                    end
                )
            end,
            function()
                vim.notify("No Optional Params listed")
                if choice ~= nil and ch ~= nil then
                    return
                end
            end
        )
    end)
end

local config = {
    Octo = {
        body = leader,
        mode = { "n", "v" },
        ["<ESC>"] = { nil, { desc = "Exit", exit = true } },

        g = {
            function()
                caller({ "list" }, "gist")
            end,
            { exit = true, desc = "List Gists" },
        },
        i = {
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

            { exit = true, desc = "Issue" },
        },
        p = {
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

            { exit = true, desc = "Pull Request" },
        },
        r = {
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

            { exit = true, desc = "Repo" },
        },
        s = {
            function()
                vim.ui.input({
                    prompt = "Enter an option for search > ",
                    default = "assignee:vsedov is:pr",
                }, function(choice_2)
                    vim.cmd("Octo search " .. choice_2)
                end)
            end,
            { exit = true, desc = "Search for pr|item" },
        },

        C = {
            function()
                options = {
                    "add",
                    "remove",
                    "move",
                }
                caller(options, "card")
            end,
            { exit = true, desc = "Card Options" },
        },

        l = {
            function()
                options = {
                    "add",
                    "remove",
                    "create",
                }
                caller(options, "label")
            end,

            { exit = true, desc = "Label Options" },
        },

        t = {
            function()
                caller({ "resolve", "unresolve" }, "thread")
            end,

            { exit = true, desc = "Thread Options" },
        },
        R = {
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
            { exit = true, desc = "Review Options" },
        },
        c = {
            function()
                options = {
                    "add",
                    "delete",
                }
                caller(options, "comment")
            end,
            { exit = true, desc = "Comment Options" },
        },
        ["-"] = {
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
                vim.notify("Active")
                caller(options, "reaction")
            end,
            { exit = true, desc = "Reaction Options" },
        },
        ["1"] = {
            function()
                require("gitlinker").get_buf_range_url(
                    "n",
                    { action_callback = require("gitlinker.actions").open_in_browser }
                )
            end,
            { exit = true, desc = "Current file" },
        },
        ["2"] = {
            function()
                require("gitlinker").get_repo_url()
            end,
            { exit = true, desc = "Copy URL" },
        },
        ["3"] = {
            function()
                require("gitlinker").get_repo_url({ action_callback = require("gitlinker.actions").open_in_browser })
            end,
            { exit = true, desc = "Open Repo" },
        },
        ["4"] = {

            function()
                local mode = string.lower(vim.fn.mode())
                require("gitlinker").get_buf_range_url(mode)
            end,
            { exit = true, desc = "Current line range" },
        },
    },
}
return {
    config,
    "Octo",
    { { "1", "2", "3", "4" } },
    { "i", "p", "R", "t", "r", "s", "c", "g", "C", "l", "-" },
    6,
    3,
    1,
}
