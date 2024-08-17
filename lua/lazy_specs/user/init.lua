return {

    {
        "moody.nvim",
        event = "ModeChanged",
    },

    {
        "calculator.nvim",
        cmd = "Calculate",
        after = function()
            vim.api.nvim_create_user_command(
                "Calculate",
                'lua require("calculator").calculate()',
                { ["range"] = 1, ["nargs"] = 0 }
            )
        end,
    },
    {
        "buffalo-nvim",
        keys = {
            {
                ";;;",
                ";;<leader>",
            },
        },
        after = function()
            local opts = { noremap = true }
            local map = vim.keymap.set
            local buffalo = require("buffalo.ui")
            map({ "t", "n" }, ";;;", buffalo.toggle_buf_menu, opts)
            map({ "t", "n" }, ";;<leader>", buffalo.toggle_tab_menu, opts)
            require("buffalo").setup()
        end,
    },
    {
        "github-preview.nvim",
        cmd = { "GithubPreviewToggle" },
        keys = { "<leader>mpt", "<leader>mps", "<leader>mpd" },
        after = function()
            local gpreview = require("github-preview")
            gpreview.setup({})

            local fns = gpreview.fns
            vim.keymap.set("n", "<leader>mpt", fns.toggle)
            vim.keymap.set("n", "<leader>mps", fns.single_file_toggle)
            vim.keymap.set("n", "<leader>mpd", fns.details_tags_toggle)
        end,
    },
    {
        "open-handlers.nvim",
        after = function()
            local oh = require("open-handlers")

            oh.setup({
                -- In order, each handler is tried.
                -- The first handler to successfully open will be used.
                handlers = {
                    oh.issue, -- A builtin which handles github and gitlab issues
                    oh.commit, -- A builtin which handles git commits
                    oh.native, -- Default native handler. Should always be last
                },
            })
        end,
    },
    {
        "nvim-rgflow.lua",
        keys = {
            {
                ";rG",
                desc = "rgflow: open blank",
            },
            {
                ";rg",
                desc = "rgflow: open cword",
            },
            {
                ";ro",
                desc = "rgflow: open paste",
            },
            {
                ";ra",
                desc = "rgflow: open again",
            },
            {
                ";rc",
                desc = "rgflow: abort",
            },
            {
                ";rO",
                desc = "rgflow: print cmd",
            },
            {
                ";r?",
                desc = "rgflow: print status",
            },
        },
        after = function()
            require("rgflow").setup({
                default_trigger_mappings = false,
                default_ui_mappings = true,
                default_quickfix_mappings = true,
                mappings = {
                    trigger = {
                        -- Normal mode maps
                        n = {
                            [";rG"] = "open_blank", -- open UI - search pattern = blank
                            [";rg"] = "open_cword", -- open UI - search pattern = <cword>
                            [";ro"] = "open_paste", -- open UI - search pattern = First line of unnamed register as the search pattern
                            [";ra"] = "open_again", -- open UI - search pattern = Previous search pattern
                            [";rc"] = "abort", -- close UI / abort searching / abortadding results
                            [";rO"] = "print_cmd", -- Print a version of last run rip grep that can be pasted into a shell
                            [";r?"] = "print_status", -- Print info about the current state of rgflow (mostly useful for deving on rgflow)
                        },
                        -- Visual/select mode maps
                        x = {
                            [";rg"] = "open_visual", -- open UI - search pattern = current visual selection
                        },
                    },
                },
                cmd_flags = "--smart-case --fixed-strings --no-fixed-strings --no-ignore --ignore --max-columns 500",
            })
        end,
    },
    {
        "scrollofffraction.nvim",
        event = "BufWinEnter",
        after = function()
            require("scrollofffraction").setup()
        end,
    },
    {
        "expand.nvim",
        event = "InsertEnter",
        load = function(name)
            rocks.safe_packadd({ name, "indent.nvim" })
        end,
        after = function()
            require("expand").setup({
                filetypes = {
                    lua = {
                        -- if we are expanding on an unnamed function might aswell add the pairs
                        { "function\\s*$", { "()", "end" } },
                        { "function", { "", "end" } },
                        { "if", { " then", "end" } },
                        -- regex for a lua variable
                        { "^\\s*\\w\\+\\s*\\w*\\s*=\\s*$", { "{", "}" } },
                        { "", { " do", "end" } },
                    },
                    sh = {
                        { "elif", { " ;then", "" } },
                        { "if", { " ;then", "if" } },
                        { "case", { "", "esac" } },
                        { "while", { " do", "done" } },
                        { "for", { " do", "done" } },
                        { "", { "{", "}" } },
                    },
                    bash = {
                        { "elif", { " ;then", "" } },
                        { "if", { " ;then", "if" } },
                        { "case", { "", "esac" } },
                        { "while", { " do", "done" } },
                        { "for", { " do", "done" } },
                        { "", { "{", "}" } },
                    },
                    zsh = {
                        { "elif", { " then", "" } },
                        { "if", { " then", "if" } },
                        { "case", { "", "esac" } },
                        { "while", { " do", "done" } },
                        { "for", { " do", "done" } },
                        { "", { "{", "}" } },
                    },
                    c = {
                        { ".*(.*)", { "{", "}" } },
                        { "", { "{", "};" } },
                    },
                    cpp = {
                        { ".*(.*)", { "{", "}" } },
                        { "", { "{", "};" } },
                    },
                    python = {
                        {
                            "print",
                            {
                                "(",
                                ")",
                            },
                        },
                        { ".*(.*)", { ":", "" } },
                        { "", { ":", "" } },

                        {

                            "def",
                            {
                                "():",
                                "",
                            },
                        },
                    },
                },

                hotkey = "<C-Space>",
            })
        end,
    },

    {
        "gx.nvim",
        keys = { { "gx", "<cmd>Browse<cr>", mode = { "n", "x" } } },
        cmd = { "Browse" },
        beforeAll = function()
            vim.g.netrw_nogx = 1 -- disable netrw gx
        end,
        after = function()
            require("gx").setup({
                open_browser_app = "waterfox", -- specify your browser app; default for macOS is "open", Linux "xdg-open" and Windows "powershell.exe"
                -- open_browser_args = { "--background" }, -- specify any arguments, such as --background for macOS' "open".
                handlers = {
                    plugin = true, -- open plugin links in lua (e.g. packer, lazy, ..)
                    github = true, -- open github issues
                    brewfile = true, -- open Homebrew formulaes and casks
                    package_json = true, -- open dependencies from package.json
                    search = true, -- search the web/selection on the web if nothing else is found
                    go = true, -- open pkg.go.dev from an import statement (uses treesitter)
                    jira = { -- custom handler to open Jira tickets (these have higher precedence than builtin handlers)
                        name = "jira", -- set name of handler
                        handle = function(mode, line, _)
                            local ticket = require("gx.helper").find(line, mode, "(%u+-%d+)")
                            if ticket and #ticket < 20 then
                                return "http://jira.company.com/browse/" .. ticket
                            end
                        end,
                    },
                    rust = { -- custom handler to open rust's cargo packages
                        name = "rust", -- set name of handler
                        filetype = { "toml" }, -- you can also set the required filetype for this handler
                        filename = "Cargo.toml", -- or the necessary filename
                        handle = function(mode, line, _)
                            local crate = require("gx.helper").find(line, mode, "(%w+)%s-=%s")

                            if crate then
                                return "https://crates.io/crates/" .. crate
                            end
                        end,
                    },
                },
                handler_options = {
                    search_engine = "google", -- you can select between google, bing, duckduckgo, ecosia and yandex
                    select_for_search = true, -- if your cursor is e.g. on a link, the pattern for the link AND for the word will always match. This disables this behaviour for default so that the link is opened without the select option for the word AND link
                    git_remotes = { "upstream", "origin" }, -- list of git remotes to search for git issue linking, in priority
                    git_remote_push = function(fname) -- you can also pass in a function
                        return fname:match("myproject")
                    end,
                },
            })
        end,
    },
}
