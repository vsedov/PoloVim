local config = {
    Telescope = {
        color = "teal",
        body = "<leader>f",
        mode = { "n" },
        g = {
            function()
                require("telescope.builtin").git_files()
            end,
            { exit = true, desc = "Git Files" },
        },

        u = {
            function()
                require("modules.search.telescope.telescope_commands").git_diff()
            end,
            { exit = true, desc = "Git Diff" },
        },

        S = {
            function()
                require("modules.search.telescope.telescope_commands").git_status()
            end,
            { exit = true, desc = "Git Status" },
        },

        h = {
            function()
                require("modules.search.telescope.telescope_commands").git_conflicts()
            end,
            { exit = true, desc = "Git Conflicts" },
        },

        F = {
            function()
                require("telescope.builtin").registers()
            end,
            { exit = true, desc = "Registers" },
        },

        j = {
            function()
                require("modules.search.telescope.telescope_commands").jump()
            end,
            { exit = true, desc = "Jump" },
        },

        a = {
            function()
                lambda.clever_tcd()
                vim.defer_fn(function()
                    vim.ui.input({ prompt = "Silver Surfer", default = "" }, function(item)
                        if item == "" then
                            require("modules.search.telescope.telescope_commands").ag()
                        else
                            require("modules.search.telescope.telescope_commands").ag(tostring(item))
                        end
                    end)
                end, 100)
            end,
            { exit = true, desc = "Ag" },
        },

        r = {
            function()
                vim.cmd.Fzf()
            end,
            { exit = true, desc = "Fzf" },
        },

        f = {
            function()
                vim.cmd.Ranger()
            end,
            { exit = true, desc = "Ranger" },
        },

        w = {
            function()
                require("modules.search.telescope.telescope_commands").egrep()
            end,
            { exit = true, desc = "egrepify" },
        },

        W = {
            function()
                require("modules.search.telescope.telescope_commands").curbuf()
            end,
            { exit = true, desc = "curbuf" },
        },

        l = {
            require("telescope.builtin").lsp_dynamic_workspace_symbols,
            { exit = true, desc = "Lsp" },
        },

        e = {
            -- require("telescope.builtin").ast_grep,
            function()
                vim.cmd.Telescope("ast_grep")
            end,
            { exit = true, desc = "Ast Grep" },
        },

        E = {
            function()
                require("telescope").extensions.live_grep_args.live_grep_args()
            end,
            { exit = true, desc = "Live Grep Args" },
        },

        p = {
            function()
                require("telescope.builtin").workspaces()
            end,
            { exit = true, desc = "Workspaces" },
        },

        M = {
            function()
                require("telescope.builtin").marks()
            end,
            { exit = true, desc = "Marks" },
        },

        B = {
            function()
                require("telescope.builtin").bookmarks()
            end,
            { exit = true, desc = "Bookmarks" },
        },

        ["/"] = {
            function()
                require("telescope.builtin").search_history()
            end,
            { exit = true, desc = "Search History" },
        },

        c = {
            function()
                require("modules.search.telescope.telescope_commands").command_history()
            end,
            { exit = true, desc = "Command History" },
        },

        m = {
            function()
                require("telescope.builtin").commands()
            end,
            { exit = true, desc = "Commands" },
        },

        o = {
            function()
                require("telescope.builtin").oldfiles()
            end,
            { exit = true, desc = "Oldfiles" },
        },

        k = {
            function()
                require("telescope.builtin").keymaps()
            end,
            { exit = true, desc = "Keymaps" },
        },

        R = {
            function()
                require("telescope.builtin").reloader()
            end,
            { exit = true, desc = "Reloader" },
        },

        ["<CR>"] = {
            function()
                require("telescope.builtin").builtin()
            end,
            { exit = true, desc = "Builtin" },
        },

        T = {
            function()
                vim.cmd.Easypick()
            end,
            { exit = true, desc = "Easypick" },
        },

        ["<leader>"] = {
            function()
                require("telescope").extensions.frecency.frecency()
            end,
            { exit = true, desc = "Frecency" },
        },

        ["+"] = {
            function()
                require("telescope").extensions.smart_open.smart_open()
            end,
            { exit = true, desc = "Smart Open" },
        },

        q = { nil, { exit = true, nowait = true, desc = "Exit" } },
        ["<ESC>"] = { nil, { exit = true, nowait = true, desc = "Exit" } },

        ["1"] = {
            function()
                require("modules.search.telescope.telescope_commands").find_files()
            end,
            { exit = true, desc = "Find Files" },
        },

        ["2"] = {
            function()
                require("modules.search.telescope.telescope_commands").files()
            end,
            { exit = true, desc = "Files" },
        },

        s = {
            function()
                require("modules.search.telescope.telescope_commands").find_string()
            end,
            { exit = true, desc = "Find String" },
        },

        t = {
            function()
                require("modules.search.telescope.telescope_commands").search_only_certain_files()
            end,
            { exit = true, desc = "Search Only Certain Files" },
        },

        b = {
            function()
                require("modules.search.telescope.telescope_commands").file_browser()
            end,
            { exit = true, desc = "File Browser" },
        },

        d = {
            function()
                require("modules.search.telescope.telescope_commands").load_dotfiles()
            end,
            { exit = true, desc = "Load Dotfiles" },
        },

        z = {
            function()
                require("telescope").extensions.zoxide.list()
            end,
            { exit = true, desc = "Zoxide" },
        },
    },
}

local buffer = { "w", "f", "R", "a", "W", "E", "z", "e", "l", "M", "<leader>", "<CR>" }
local git = { "g", "u", "S", "h" }
local register = { "r", "F", "j" }
local command = { "c", "m", "o", "k" }
local misc = { "p", "B", "/", "T", "+" }
local filebrowser = { "1", "2", "s", "t", "b", "d" }

return {
    config,
    "Telescope",
    {
        filebrowser,
        git,
        register,
        misc,
        command,
    },
    buffer,
    6,
    4,
    2,
}
