local tools = {}
local conf = require("modules.tools.config")

tools["kristijanhusak/vim-dadbod-ui"] = {
    cmd = { "DBUIToggle", "DBUIAddConnection", "DBUI", "DBUIFindBuffer", "DBUIRenameBuffer", "DB" },
    config = conf.vim_dadbod_ui,
    requires = { "tpope/vim-dadbod", ft = { "sql" } },
    opt = true,
    setup = function()
        vim.g.dbs = {
            eraser = "postgres://postgres:password@localhost:5432/eraser_local",
            staging = "postgres://postgres:password@localhost:5432/my-staging-db",
            wp = "mysql://root@localhost/wp_awesome",
            uni = "sqlite:/home/viv/GitHub/TeamProject2022_28/ARMS/src/main/resources/db/DummyARMS.sql",
        }
    end,
}
tools["j-hui/fidget.nvim"] = {
    opt = true,
    ft = { "python", "lua", "c" },
    config = function()
        local relative = "editor"
        require("fidget").setup({
            text = {
                spinner = {
                    " ",
                    " ",
                    " ",
                    " ",
                    " ",
                    " ",
                    " ",
                    " ",
                    " ",
                    " ",
                    " ",
                    " ",
                    " ",
                    " ",
                    " ",
                    " ",
                    " ",
                    " ",
                    " ",
                    " ",
                    " ",
                    " ",
                    " ",
                    " ",
                    " ",
                    " ",
                    " ",
                    " ",
                },
                done = "", -- character shown when all tasks are complete
                commenced = " ", -- message shown when task starts
                completed = " ", -- message shown when task completes
            },
            align = {
                bottom = true, -- align fidgets along bottom edge of buffer
                right = true, -- align fidgets along right edge of buffer
            },
            timer = {
                spinner_rate = 100, -- frame rate of spinner animation, in ms
                fidget_decay = 500, -- how long to keep around empty fidget, in ms
                task_decay = 300, -- how long to keep around completed task, in ms
            },
            window = {
                relative = relative, -- where to anchor the window, either `"win"` or `"editor"`
                blend = 100, -- `&winblend` for the window
                zindex = nil, -- the `zindex` value for the window
            },
            fmt = {
                leftpad = true, -- right-justify text in fidget box
                stack_upwards = true, -- list of tasks grows upwards
                max_width = 0, -- maximum width of the fidget box
                -- function to format fidget title
                fidget = function(fidget_name, spinner)
                    return string.format("%s %s", spinner, fidget_name)
                end,
                -- function to format each task line
                task = function(task_name, message, percentage)
                    return string.format(
                        "%s%s [%s]",
                        message,
                        percentage and string.format(" (%s%%)", percentage) or "",
                        task_name
                    )
                end,
            },

            debug = {
                logging = false, -- whether to enable logging, for debugging
                strict = false, -- whether to interpret LSP strictly
            },
        })
    end,
}
tools["editorconfig/editorconfig-vim"] = {
    opt = true,
    cmd = { "EditorConfigReload" },
    -- ft = { 'go','typescript','javascript','vim','rust','zig','c','cpp' }
}

tools["olimorris/persisted.nvim"] = {
    event = "VimLeavePre",
    module = "persisted",
    cmd = {"SessionStart", "SessionStop", "SessionSave", "SessionLoad", "SessionLoadLast", "SessionDelete", "SessionToggle"},
    setup = function()
        vim.keymap.set("n", "<leader>R", function()
            require("persisted").load({ last = true })
        end)
        vim.keymap.set("n", "<leader>L", function()
            require("persisted").start()
        end)
    end,
    config = function()
        require("persisted").setup()
    end,
}

tools["rktjmp/paperplanes.nvim"] = {
    cmd = { "PP" },
    opt = true,
    config = conf.paperplanes,
}

tools["ThePrimeagen/harpoon"] = {
    module = "harpoon",
    opt = true,
    config = function()
        require("harpoon").setup({

            global_settings = {
                save_on_toggle = true,
                save_on_change = true,
                enter_on_sendcmd = true,
                tmux_autoclose_windows = false,
                excluded_filetypes = { "harpoon" },
                mark_branch = false,
            },
        })
        require("telescope").load_extension("harpoon")
    end,
}

  -- -- IPython Mappings
  -- M.map("n", "p", "<cmd>lua require('py.ipython').toggleIPython()<CR>")
  -- M.map("n", "c", "<cmd>lua require('py.ipython').sendObjectsToIPython()<CR>")
  -- M.map("v", "c", '"zy:lua require("py.ipython").sendHighlightsToIPython()<CR>')
  -- M.map("v", "s", '"zy:lua require("py.ipython").sendIPythonToBuffer()<CR>')

  -- -- Pytest Mappings
  -- M.map("n", "t", "<cmd>lua require('py.pytest').launchPytest()<CR>")
  -- M.map("n", "r", "<cmd>lua require('py.pytest').showPytestResult()<CR>")

  -- -- Poetry Mappings
  -- M.map("n", "a", "<cmd>lua require('py.poetry').inputDependency()<CR>")
  -- M.map("n", "d", "<cmd>lua require('py.poetry').showPackage()<CR>")
tools["KCaverly/py.nvim"] = {
    ft = { "python" },
    config = function()
        require("py").setup({
            leader = "<leader><leader>",
        })
    end,
}

tools["natecraddock/workspaces.nvim"] = {
    module = "workspaces",
    config = function()
        require("workspaces").setup({
            global_cd = true,
            sort = true,
            notify_info = true,

            hooks = {
                open = { "Telescope find_files" },
            },
        })
        require("telescope").load_extension("workspaces")
    end,
}

tools["nmac427/guess-indent.nvim"] = {
    module = "guess-indent",
    event = "BufRead",
    config = function()
        require("guess-indent").setup({})
    end,
    after = "nvim-treesitter",
}
-- github GH ui
tools["pwntester/octo.nvim"] = {
    requires = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
        "kyazdani42/nvim-web-devicons",
    },
    cmd = "Octo",
    keys = { "<Leader>Op", "<Leader>Opl", "<Leader>Ope", "<Leader>Oil", "<Leader>Oic", "<Leader>Oie" },
    config = function()
        require("octo").setup()
        require("which-key").register({
            O = {
                name = "+octo",
                p = {
                    name = "+pr",
                    l = { "<Cmd>Octo pr list<CR>", "pull requests List" },
                    e = { "<Cmd>Octo pr edit<CR>", "pull requests edit" },
                },
                i = {
                    name = "+issues",
                    l = { "<Cmd>Octo issue list<CR>", "Issue List" },
                    c = { "<Cmd>Octo issue create<CR>", "Issue Create" },
                    e = { "<Cmd>Octo issue edit<CR>", "Issue Edit" },
                },
            },
        }, { prefix = "<leader>" })
    end,
}
tools["jghauser/mkdir.nvim"] = {
    opt = true,
    cmd = "new",
    config = [[require'mkdir']],
}

tools["NFrid/due.nvim"] = {
    ft = "norg",
    config = function()
        vim.cmd([[packadd due.nvim]])
        require("due_nvim").setup({
            ft = "*.norg",
            use_clock_time = true, -- display also hours and minutes
            use_clock_today = true, -- do it instead of TODAY
            use_seconds = true, -- if use_clock_time == true, display seconds        ft = '*.norg',
        })
    end,
}

-- tools["wellle/targets.vim"] = {}

tools["liuchengxu/vista.vim"] = { cmd = "Vista", setup = conf.vim_vista, opt = true }

------------- Spelling and Grammer
tools["kamykn/spelunker.vim"] = {
    opt = true,
    fn = { "spelunker#check" },
    setup = conf.spelunker,
    config = conf.spellcheck,
}

tools["lewis6991/spellsitter.nvim"] = {
    ft = { "norg", "markdown" },
    config = function()
        require("spellsitter").setup({
            filetypes = { "norg" },
            enable = true,
        })
    end,
}
tools["rhysd/vim-grammarous"] = {
    opt = true,
    cmd = { "GrammarousCheck" },
    ft = { "markdown", "txt", "norg" },
    setup = conf.grammarous,
}
-------------

tools["plasticboy/vim-markdown"] = {
    ft = "markdown",
    requires = { "godlygeek/tabular" },
    cmd = { "Toc" },
    setup = conf.markdown,
    opt = true,
}

tools["ekickx/clipboard-image.nvim"] = {
    ft = { "norg", "markdown" },
    opt = true,
    config = conf.clipboardimage,
}

tools["iamcco/markdown-preview.nvim"] = {
    ft = { "markdown", "pandoc.markdown", "rmd" },
    cmd = { "MarkdownPreview" },
    setup = conf.mkdp,
    run = [[sh -c "cd app && yarn install"]],
    opt = true,
}

tools["turbio/bracey.vim"] = {
    ft = { "html", "javascript", "typescript" },
    cmd = { "Bracey", "BraceyEval" },
    run = 'sh -c "npm install --prefix server"',
    opt = true,
}

tools["akinsho/toggleterm.nvim"] = {
    cmd = { "FocusTerm", "TermTrace", "TermExec", "ToggleTerm" },
    keys = { "<c-t>", "<leader>gh", "<leader>tf", "<leader>tv", "<leader>tr" },
    config = function()
        require("modules.tools.toggleterm")
    end,
}

tools["liuchengxu/vim-clap"] = {
    cmd = { "Clap" },
    run = function()
        vim.fn["clap#installer#download_binary"]()
    end,
    setup = conf.clap,
    config = conf.clap_after,
}

-- For this to record, cmd might not work
tools["wakatime/vim-wakatime"] = {
    event = "InsertEnter",
    cmd = {
        "WakaTimeApiKey",
        "WakaTimeDebugEnable",
        "WakaTimeDebugDisable",
        "WakaTimeScreenRedrawEnable",
        "WakaTimeScreenRedrawEnableAuto",
        "WakaTimeScreenRedrawDisable",
        "WakaTimeToday",
    },
}

-- ze black magic
tools["windwp/nvim-spectre"] = {
    module = "spectre",
    requires = { "nvim-lua/plenary.nvim" },
    keys = {
        ";w",
        ";W",
        ";v",
        ";c",
    },

    config = function()
        local status_ok, spectre = pcall(require, "spectre")
        if not status_ok then
            return
        end
        spectre.setup()
    end,
}

tools["FraserLee/ScratchPad"] = {
    cmd = { "ScratchPad" },
}
tools["ray-x/sad.nvim"] = {
    cmd = { "Sad" },
    requires = { "ray-x/guihua.lua", opt = true, after = "sad.nvim" },
    opt = true,
    config = function()
        require("sad").setup({
            diff = "diff-so-fancy", -- you can use `diff`, `diff-so-fancy`
            ls_file = "fd", -- also git ls_file
            exact = false, -- exact match
        })
    end,
}
-- ╭────────────────────────────────────────────────────────────────────╮
-- │ git tools                                                          │
-- ╰────────────────────────────────────────────────────────────────────╯

tools["ThePrimeagen/git-worktree.nvim"] = {
    event = { "CmdwinEnter", "CmdlineEnter" },
    config = conf.worktree,
}

tools["sindrets/diffview.nvim"] = {
    cmd = {
        "DiffviewOpen",
        "DiffviewFileHistory",
        "DiffviewFocusFiles",
        "DiffviewToggleFiles",
        "DiffviewRefresh",
    },
    config = conf.diffview,
}

tools["lewis6991/gitsigns.nvim"] = {
    config = conf.gitsigns,
    -- keys = {']c', '[c'},  -- load by lazy.lua
    opt = true,
}

tools["TimUntersberger/neogit"] = {
    opt = true,
    cmd = { "Neogit" },
    config = conf.neogit,
}

tools["ruifm/gitlinker.nvim"] = {
    keys = { "<leader>gy" },
    config = function()
        require("gitlinker").setup()
    end,
}

tools["tanvirtin/vgit.nvim"] = { -- gitsign has similar features
    setup = function()
        vim.o.updatetime = 2000
    end,
    cmd = { "VGit" },
    -- after = {"telescope.nvim"},
    opt = true,
    config = conf.vgit,
}

tools["akinsho/git-conflict.nvim"] = {
    cmd = {
        "GitConflictChooseOurs",
        "GitConflictChooseTheirs",
        "GitConflictChooseBoth",
        "GitConflictChooseNone",
        "GitConflictNextConflict",
        "GitConflictPrevConflict",
        "GitConflictListQf",
    },
    config = function()
        require("git-conflict").setup()
    end,
}

tools["tpope/vim-fugitive"] = {
    cmd = { "Gvsplit", "Git", "Gedit", "Gstatus", "Gdiffsplit", "Gvdiffsplit" },
    opt = true,
}

tools["LhKipp/nvim-git-fixer"] = {
    cmd = { "FixUp", "Ammend" },
    opt = true,
    config = function()
        -- defaults shown --
        require("fixer").setup({
            stage_hunk_action = function()
                require("gitsigns").stage_hunk()
            end,
            undo_stage_hunk_action = function()
                require("gitsigns").undo_stage_hunk()
            end,
            refresh_hunks_action = function()
                require("gitsigns").refresh()
            end,
        })
        vim.cmd(
            [[command! -nargs=*  FixUp lua require('fixer/picker/telescope').commit{hunk_only=true, type="fixup"} ]]
        )
        vim.cmd([[command! -nargs=*  Ammend lua require('fixer/picker/telescope').commit{type="amend"} ]])
    end,
}

-- need quick fix  :vimgrep /\w\+/j % | copen
tools["kevinhwang91/nvim-bqf"] = {
    opt = true,
    event = { "CmdlineEnter", "QuickfixCmdPre" },
    config = conf.bqf,
}

tools["ahmedkhalf/project.nvim"] = {
    module = "project",
    ft = { "python", "java", "c", "cpp", "lua" },
    opt = true,
    config = conf.project,
}

-- config this better https://github.com/jvgrootveld/telescope-zoxide
tools["jvgrootveld/telescope-zoxide"] = {
    opt = true,
    after = { "telescope.nvim" },
    config = function()
        require("utils.telescope")
        require("telescope").load_extension("zoxide")
    end,
}

-- :Z {query}: cd to the highest ranked directory matching your query. If {query} is omitted, cd to the home directory
-- :Lz {query}: same as :Z, but local to the current window
-- :Tz {query}: same as :Z, but local to the current tab
-- :Zi {query}: cd to one of your highest ranking directories using fzf
-- :Lzi {query}: same as :Zi, but local to the current window
-- :Tzi {query}: same as :Zi, but local to the current tab

tools["nanotee/zoxide.vim"] = { cmd = { "Z", "Lz", "Zi", "Tz" } }

tools["tami5/sqlite.lua"] = {
    branch = "new/index_access",
    module = "sqlite",
}
-- manual call
tools["AckslD/nvim-neoclip.lua"] = {
    opt = true,
    requires = { "tami5/sqlite.lua" },
    config = conf.neoclip,
}

-- This can be lazy loaded probably, figure out how ?
tools["camspiers/animate.vim"] = {
    opt = true,
}
-- interferes with nui and popus
tools["chentau/marks.nvim"] = {
    opt = true,
    event = { "BufReadPost" },
    config = function()
        require("marks").setup({
            default_mappings = true,
            builtin_marks = { ".", "<", ">", "^" },
            cyclic = true,
            force_write_shada = true,
            refresh_interval = 250,
            sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
            excluded_filetypes = {
                "neo-tree",
                "neo-tree-popup",
            },
            bookmark_0 = {
                sign = "⚑",
                virt_text = "BookMark",
            },
            mappings = {},
        })
    end,
}

tools["Krafi2/jeskape.nvim"] = {
    event = "InsertEnter",
    config = function()
        require("jeskape").setup({
            mappings = {
                -- avoid tex values getting in teh way
                ["\\l"] = {
                    i = "<cmd>Clap | startinsert<cr>",
                    f = "<cmd>Clap grep ++query=<cword> |  startinsert<cr>",
                },
                j = {
                    h = "<esc>O",
                    k = "<esc>",
                    j = "<esc>o",
                },
            },
        })
    end,
}

tools["fladson/vim-kitty"] = {
    ft = { "*.conf" },
}

tools["marekzidek/vim-nayvy"] = {
    ft = "python",
    run = ":UpdateRemotePlugins",
    config = function()
        vim.g.nayvy_import_config_path = "$HOME/nayvy.py"
    end,
}

-- Dont know why, but i kinda enjoy this
tools["sQVe/sort.nvim"] = {
    cmd = "Sort",
    config = function()
        require("sort").setup({})
    end,
}

tools["gelguy/wilder.nvim"] = {
    opt = true,
    requires = { "romgrk/fzy-lua-native", opt = true, after = "wilder.nvim" },
    event = "CmdlineEnter",
    config = conf.wilder,
    run = ":UpdateRemotePlugins",
}

return tools
