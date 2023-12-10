local user = require("core.pack").package
local uv = vim.uv or vim.loop
local api, fn = vim.api, vim.fn

user({
    "axieax/urlview.nvim",
    lazy = true,
    keys = {
        { "\\u", vim.cmd.UrlView, desc = "view buffer URLS " },
    },
    config = true,
})

user({
    "superDross/spellbound.nvim",
    keys = {
        {
            "<c-g>w",
            desc = "toggle spellbound",
        },
        {
            "<c-g>n",
            desc = "fix right",
        },
        {
            "<c-g>N",
            desc = "fix left",
        },
    },
    init = function()
        vim.o.dictionary = "/usr/share/dict/directory-list-2.3-medium.txt"
        -- default settings
        vim.g.spellbound_settings = {
            mappings = {
                toggle_map = "<c-g>w",
                fix_right = "<c-g>n",
                fix_left = "<c-g>p",
            },
            language = "en_gb",
            autospell_filetypes = { "*.txt", "*.md", "*.rst", "*.norg" },
            autospell_gitfiles = true,
            number_suggestions = 10,
            return_to_position = true,
        }
    end,
})

user({
    "Bekaboo/dropbar.nvim",
    event = "VeryLazy",
    cond = lambda.config.ui.use_dropbar,
    keys = {
        {
            "<leader>wp",
            function()
                require("dropbar.api").pick()
            end,
            desc = "winbar: pick",
        },
    },
    opts = {
        general = {
            update_interval = 100,
            enable = function(buf, win)
                local b, w = vim.bo[buf], vim.wo[win]
                local decor = lambda.style.decorations.get({ ft = b.ft, bt = b.bt, setting = "winbar" })
                return decor.ft ~= false
                    and decor.bt ~= false
                    and b.bt == ""
                    and not w.diff
                    and not api.nvim_win_get_config(win).zindex
                    and api.nvim_buf_get_name(buf) ~= ""
            end,
        },
        icons = {
            ui = { bar = { separator = " " .. lambda.style.icons.misc.arrow_right .. " " } },
        },
        menu = {
            win_configs = {
                border = "single",
                col = function(menu)
                    return menu.prev_menu and menu.prev_menu._win_configs.width + 1 or 0
                end,
            },
        },
    },
})

user({
    "Zeioth/markmap.nvim",
    lazy = true,
    build = "yarn global add markmap-cli",
    cmd = { "MarkmapOpen", "MarkmapSave", "MarkmapWatch", "MarkmapWatchStop" },
    opts = {
        html_output = "/tmp/markmap.html", -- (default) Setting a empty string "" here means: [Current buffer path].html
        hide_toolbar = false, -- (default)
        grace_period = 3600000, -- (default) Stops markmap watch after 60 minutes. Set it to 0 to disable the grace_period.
    },
    config = function(_, opts)
        require("markmap").setup(opts)
    end,
})
user({
    "azabiong/vim-highlighter",
    keys = {
        {
            "m<cr>",
            desc = "Highlight word",
        },
        {
            "m<bs>",
            desc = "Highlight delete",
        },
        {
            "mD>",
            desc = "Higlihgt clear",
        },
        {
            "m;",
            "<cmd>Hi}<cr>",
        },
    },
    init = function()
        vim.cmd("let HiSet = 'm<cr>'")

        vim.cmd("let HiErase = 'm<bs>'")
        vim.cmd("let HiClear = 'mD'")
    end,
})

user({
    "KaitlynEthylia/TreePin",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    cmd = {
        "TPPin",
        "TPRoot",
        "TPGrow",
        "TPShrink",
        "TPClear",
        "TPGo",
        "TpHide",
        "TPToggle",
    },
    keys = {
        { ",tp", "<cmd>TPPin<CR>", desc = "TreePin Pin" },
        { ",tc", "<cmd>TPClear<CR>", desc = "TreePin Clear" },
        { ",tt", "<cmd>TPToggle<CR>", desc = "TreePin Toggle" },
        { ",tr", "<cmd>TPRoot<CR>", desc = "TreePin Root" },
        { ",tj", "<cmd>TPGrow<CR>", desc = "TreePin Grow" },
        { ",tk", "<cmd>TPShrink<CR>", desc = "TreePin Shrink" },
        {
            ",tg",
            function()
                vim.cmd("normal! m'")
                vim.cmd("TPGo")
            end,
            desc = "TreePin Go",
        },
        { ",ts", "<cmd>TPShow<CR>", desc = "TreePin Show" },
        { ",th", "<cmd>TPHide<CR>", desc = "TreePin Hide" },
    },
    opts = {
        seperator = "▔",
    },
})
-- user({
--     "lewis6991/whatthejump.nvim",
--     cond = false,
--     keys = { "<c-i>", "<c-o>" },
-- })
--  ──────────────────────────────────────────────────────────────────────
user({
    "thinca/vim-qfreplace",
    ft = "qf",
    lazy = true,
})

user({
    "creativenull/dotfyle-metadata.nvim",
    cmd = "DotfyleGenerate",
})

user({
    "mikesmithgh/kitty-scrollback.nvim",
    enabled = true,
    lazy = true,
    cmd = { "KittyScrollbackGenerateKittens", "KittyScrollbackCheckHealth" },
    event = { "User KittyScrollbackLaunch" },
    -- version = '*', -- latest stable version, may have breaking changes if major version changed
    -- version = '^2.0.0', -- pin major version, include fixes and features that do not have breaking changes
    config = function()
        require("kitty-scrollback").setup({
            ksb_builtin_last_cmd_output = function()
                return {
                    kitty_get_text = {
                        extent = "last_visited_cmd_output",
                        ansi = true,
                    },
                }
            end,
        })
    end,
})

user({
    "Sam-programs/expand.nvim",
    cond = false, -- disable this i guess ?
    event = "VeryLazy",
    dependencies = { "Sam-Programs/indent.nvim" },
    config = true,
})

user({
    "sychen52/smart-term-esc.nvim",
    event = "TermEnter",
    config = function()
        require("smart-term-esc").setup({
            key = "<Esc>",
            except = { "nvim", "fzf" },
        })
    end,
})

-- user({
--     "Aasim-A/scrollEOF.nvim",
--     event = "VeryLazy",
--     config = true,
-- })

user({
    "vidocqh/data-viewer.nvim",
    ft = {
        "csv",
        "tsv",
    },
    dependencies = {
        "nvim-lua/plenary.nvim",
        "kkharji/sqlite.lua", -- Optional, sqlite support
    },
    config = true,
    cmd = {

        "DataViewer",
        "DataViewerNextTable",
        "DataViewerPrevTable",
        "DataViewerClose",
    },
})
user({
    "neph-iap/easycolor.nvim",
    dependencies = { "stevearc/dressing.nvim" }, -- Optional, but provides better UI for editing the formatting template
    opts = {},
    cmd = {
        "EasyColor",
    },
})

-- TRIAL: (vsedov) (10:51:37 - 13/11/23): I am not sure what to think about this.

user({
    "mangelozzi/nvim-rgflow.lua",
    keys = {
        ";rG",
        ";rg",
        ";ro",
        ";ra",
        ";rc",
        ";rO",
        ";r?",
    },
    config = function()
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
})
-- ah this is better than tint, i think
-- lets disable this for now.
user({
    "miversen33/sunglasses.nvim",
    event = "UIEnter",
    cond = lambda.config.ui.use_tint == "sunglasses",
    config = true,
})

user({
    "chipsenkbeil/distant.nvim",
    cmd = { "Distant" },
    config = function()
        require("distant"):setup()
    end,
})
user({
    "jpmcb/nvim-llama",
    cmd = {
        "Llama",
        "LlamaInstall",
        "LlamaRebuild",
        "LlamaUpdate",
    },
    config = true,
})
user({
    "EtiamNullam/deferred-clipboard.nvim",
    -- event = "LazyFile",
    event = "VeryLazy",
    opts = {
        lazy = true,
    },
})
user({
    "krady21/compiler-explorer.nvim",
    cmd = {
        "CECompile",
        "CECompileLive",
        "CEFormat",
        "CEAddLibrary",
        "CELoadExample",
        "CEOpenWebsite",
        "CEDeleteCache",
        "CEShowTooltip",
        "CEGotoLabel",
    },
    opts = {},
})
user({
    "mrshmllow/open-handlers.nvim",
    -- We modify builtin functions, so be careful lazy loading
    lazy = false,
    cond = vim.ui.open ~= nil,
    config = function()
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
})

user({
    "David-Kunz/gen.nvim",
    -- cmd = "Gen",
    opts = {
        model = "deepseek-coder",
        display_mode = "split", -- The display mode. Can be "float" or "split".
        show_prompt = true, -- Shows the Prompt submitted to Ollama.
        show_model = true, -- Displays which model you are using at the beginning of your chat session.
        no_auto_close = true, -- Never closes the window automatically.
        init = function(options)
            pcall(io.popen, "ollama serve > /dev/null 2>&1 &")
        end,
        -- Function to initialize Ollama
        command = "curl --silent --no-buffer -X POST http://localhost:11434/api/generate -d $body",
    },
    config = function(_, opts)
        require("gen").setup(opts)
        require("gen").prompts["Elaborate_Text"] = {
            prompt = "Elaborate the following text:\n$text",
            replace = true,
        }
        require("gen").prompts["Fix_Code"] = {
            prompt = "Fix the following code. Only ouput the result in format ```$filetype\n...\n```:\n```$filetype\n$text\n```",
            replace = true,
            extract = "```$filetype\n(.-)```",
        }
        require("gen").prompts["DevOps me!"] = {
            prompt = "You are a senior devops engineer, acting as an assistant. You offer help with cloud technologies like: Terraform, AWS, kubernetes, python. You answer with code examples when possible. $input:\n$text",
            replace = true,
        }

        local icn = {
            Chat = "", --     
            Test = "", --    
            Regex = "", --   
            Comment = "", --  
            Code = "", --   
            Text = "", --   
            Items = "", --    
            Swap = "", -- 
            Keep = "", --  
            into = "", --  
        }

        require("gen").prompts = {
            [icn.Chat .. " Ask about given context " .. icn.Keep] = {
                prompt = "Regarding the following text, $input:\n$text",
                model = "mistral",
            },
            [icn.Chat .. " Chat about anything " .. icn.Keep] = {
                prompt = "$input",
                model = "mistral",
            },
            [icn.Regex .. " Regex create " .. icn.Swap] = {
                prompt = "Create a regular expression for $filetype language that matches the following pattern:\n```$filetype\n$text\n```",
                replace = true,
                no_auto_close = false,
                extract = "```$filetype\n(.-)```",
                model = "deepseek-coder",
            },
            [icn.Regex .. " Regex explain " .. icn.Keep] = {
                prompt = "Explain the following regular expression:\n```$filetype\n$text\n```",
                extract = "```$filetype\n(.-)```",
                model = "deepseek-coder",
            },
            [icn.Comment .. " Code " .. icn.into .. " JSDoc " .. icn.Keep] = {
                prompt = "Write JSDoc comments for the following $filetype code:\n```$filetype\n$text\n```",
                model = "deepseek-coder",
            },
            [icn.Comment .. " JSDoc " .. icn.into .. " Code " .. icn.Keep] = {
                prompt = "Read the following comment and create the $filetype code below it:\n```$filetype\n$text\n```",
                extract = "```$filetype\n(.-)```",
                model = "deepseek-coder",
            },
            [icn.Test .. " Unit Test add missing (React/Jest) " .. icn.Keep] = {
                prompt = "Read the following $filetype code that includes some unit tests inside the 'describe' function. We are using Jest with React testing library, and the main component is reused by the tests via the customRender function. Detect if we have any missing unit tests and create them.\n```$filetype\n$text\n```",
                extract = "```$filetype\n(.-)```",
                model = "deepseek-coder",
            },
            [icn.Code .. " Code suggestions " .. icn.Keep] = {
                prompt = "Review the following $filetype code and make concise suggestions:\n```$filetype\n$text\n```",
                model = "deepseek-coder",
            },
            [icn.Code .. " Explain code " .. icn.Keep] = {
                prompt = "Explain the following $filetype code in a very concise way:\n```$filetype\n$text\n```",
                model = "deepseek-coder",
            },
            [icn.Code .. " Fix code " .. icn.Swap] = {
                prompt = "Fix the following $filetype code:\n```$filetype\n$text\n```",
                replace = true,
                no_auto_close = false,
                extract = "```$filetype\n(.-)```",
                model = "deepseek-coder",
            },
            [icn.Items .. " Text " .. icn.into .. " List of items " .. icn.Swap] = {
                prompt = "Convert the following text, except for the code blocks, into a markdown list of items without additional quotes around it:\n$text",
                replace = true,
                no_auto_close = false,
                model = "mistral",
            },
            [icn.Items .. " List of items " .. icn.into .. " Text " .. icn.Swap] = {
                prompt = "Convert the following list of items into a block of text, without additional quotes around it. Modify the resulting text if needed to use better wording.\n$text",
                replace = true,
                no_auto_close = false,
                model = "mistral",
            },
            [icn.Text .. " Fix Grammar / Syntax in text " .. icn.Swap] = {
                prompt = "Fix the grammar and syntax in the following text, except for the code blocks, and without additional quotes around it:\n$text",
                replace = true,
                no_auto_close = false,
                model = "mistral",
            },
            [icn.Text .. " Reword text " .. icn.Swap] = {
                prompt = "Modify the following text, except for the code blocks, to use better wording, and without additional quotes around it:\n$text",
                replace = true,
                no_auto_close = false,
                model = "mistral",
            },
            [icn.Text .. " Simplify text " .. icn.Swap] = {
                prompt = "Modify the following text, except for the code blocks, to make it as simple and concise as possible and without additional quotes around it:\n$text",
                replace = true,
                no_auto_close = false,
                model = "mistral",
            },
            [icn.Text .. " Summarize text " .. icn.Keep] = {
                prompt = "Summarize the following text, except for the code blocks, without additional quotes around it:\n$text",
                model = "mistral",
            },
        }
    end,
})
