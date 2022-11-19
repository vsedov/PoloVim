local config = {}
function config.syntax_surfer()
    require("modules.movement.syntax_surfer")
end

function config.lightspeed()
    require("lightspeed").setup({
        ignore_case = false,
        exit_after_idle_msecs = { unlabeled = 1000, labeled = nil },
        --- s/x ---
        jump_to_unique_chars = { safety_timeout = 400 },
        match_only_the_start_of_same_char_seqs = true,
        force_beacons_into_match_width = true,
        -- Display characters in a custom way in the highlighted matches.
        substitute_chars = { ["\r"] = "¬" },
        -- Leaving the appropriate list empty effectively disables "smart" mode,
        -- and forces auto-jump to be on or off.
        -- These keys are captured directly by the plugin at runtime.
        special_keys = {
            next_match_group = "<space>",
            prev_match_group = "<tab>",
        },
        --- f/t ---
        limit_ft_matches = nil,
        repeat_ft_with_target_char = false,
    })
    local default_keymaps = {
        { "n", "<c-s>", "<Plug>Lightspeed_omni_s" },
        { "x", "<c-s>", "<Plug>Lightspeed_omni_s" },
        { "o", "<c-s>", "<Plug>Lightspeed_omni_s" },

        { "x", "cS", "<Plug>Lightspeed_omni_gs" },
        { "n", "cS", "<Plug>Lightspeed_omni_gs" },
        { "o", "cS", "<Plug>Lightspeed_omni_gs" },
    }
    for _, m in ipairs(default_keymaps) do
        vim.keymap.set(m[1], m[2], m[3], { noremap = true, silent = true })
    end

    vim.g.lightspeed_last_motion = ""
    lambda.augroup("lightspeed_last_motion", {
        {

            event = "User",
            pattern = { "LightspeedSxEnter" },
            command = function()
                vim.g.lightspeed_last_motion = "sx"
            end,
        },
        {
            event = "User",
            pattern = { "LightspeedFxEnter" },
            command = function()
                vim.g.lightspeed_last_motion = "fx"
            end,
        },
    })

    local search_types = {
        ["<c-[>"] = ";",
        ["<c-]>"] = ",",
    }

    for k, v in pairs(search_types) do
        vim.keymap.set("n", k, function()
            return vim.g.lightspeed_last_motion == "sx" and "<Plug>Lightspeed_" .. v .. "_sx"
                or "<Plug>Lightspeed_" .. v .. "_ft"
        end, { expr = true, noremap = true })
    end
end
function config.leap()
    require("utils.ui.highlights").plugin("leap", {
        theme = {
            ["*"] = {
                { LeapBackdrop = { fg = "#707070" } },
            },
            horizon = {
                { LeapLabelPrimary = { bg = "NONE", fg = "#ccff88", italic = true } },
                { LeapLabelSecondary = { bg = "NONE", fg = "#99ccff" } },
                { LeapLabelSelected = { bg = "NONE", fg = "Magenta" } },
            },
        },
    })
    require("leap").add_default_mappings()
end

function config.hop()
    require("hop").setup({
        -- keys = 'etovxqpdygfblzhckisuran',
        quit_key = "<ESC>",
        jump_on_sole_occurrence = true,
        case_insensitive = true,
        multi_windows = true,
    })
    vim.keymap.set("n", "<leader><leader>s", "<cmd>HopWord<cr>", {})
    vim.keymap.set("n", "<leader><leader>j", "<cmd>HopChar1<cr>", {})
    vim.keymap.set("n", "<leader><leader>k", "<cmd>HopChar2<cr>", {})
    vim.keymap.set("n", "<leader><leader>w", "<cmd>HopLine<cr>", {})
    vim.keymap.set("n", "<leader><leader>l", "<cmd>HopLineStart<cr>", {})
    vim.keymap.set("n", "g/", "<cmd>HopVertical<cr>", {})

    vim.keymap.set("n", "g,", "<cmd>HopPattern<cr>", {})
end
-- use normal config for now
function config.gomove()
    require("gomove").setup({
        -- whether or not to map default key bindings, (true/false)
        map_defaults = true,
        -- what method to use for reindenting, ("vim-move" / "simple" / ("none"/nil))
        reindent_mode = "vim-move",
        -- whether to not to move past end column when moving blocks horizontally, (true/false)
        move_past_end_col = false,
        -- whether or not to ignore indent when duplicating lines horizontally, (true/false)
        ignore_indent_lh_dup = true,
    })
end

function config.iswap()
    require("iswap").setup({
        keys = "qwertyuiop",
        autoswap = true,
    })
end

function config.houdini()
    require("houdini").setup({
        mappings = { "jk", "AA", "II" },
        escape_sequences = {
            t = false,
            i = function(first, second)
                local seq = first .. second

                if vim.opt.filetype:get() == "terminal" then
                    return "" -- disabled
                end

                if seq == "AA" then
                    -- jump to the end of the line in insert mode
                    return "<BS><BS><End>"
                end
                if seq == "II" then
                    -- jump to the beginning of the line in insert mode
                    return "<BS><BS><Home>"
                end
                return "<BS><BS><ESC>"
            end,
            R = "<BS><BS><ESC>",
            c = "<BS><BS><C-c>",
        },
    })
end

function config.sj()
    local colors = {
        black = "#000000",
        light_gray = "#DDDDDD",
        white = "#FFFFFF",

        blue = "#5AA5DE",
        dark_blue = "#345576",
        darker_blue = "#005080",

        green = "#40BC60",
        magenta = "#C000C0",
        orange = "#DE945A",
    }

    local sj = require("sj")
    sj.setup({
        pattern_type = "vim_very_magic",
        prompt_prefix = "/",
        search_scope = "buffer",

        highlights = {
            SjFocusedLabel = { fg = colors.white, bg = colors.magenta, bold = false, italic = false },
            SjLabel = { fg = colors.black, bg = colors.blue, bold = true, italic = false },
            SjLimitReached = { fg = colors.black, bg = colors.orange, bold = true, italic = false },
            SjMatches = { fg = colors.light_gray, bg = colors.darker_blue, bold = false, italic = false },
            SjNoMatches = { fg = colors.orange, bold = false, italic = false },
            SjOverlay = { fg = colors.dark_blue, bold = false, italic = false },
        },

        keymaps = {
            prev_match = "<C-p>", -- focus the previous label and match
            next_match = "<C-n>", -- focus the next label and match
            send_to_qflist = "<C-q>", --- send search result to the quickfix list
        },
    })
    vim.keymap.set("n", "!", function()
        sj.run({ select_window = true })
    end)

    vim.keymap.set("n", "<A-!>", function()
        sj.select_window()
    end)

    --- visible lines -------------------------------------

    vim.keymap.set({ "n", "o", "x" }, "<leader>sv", function()
        vim.fn.setpos("''", vim.fn.getpos("."))
        sj.run({
            forward_search = false,
        })
    end, { desc = "CJ VL " })

    vim.keymap.set({ "n", "o", "x" }, "<leader>sV", function()
        vim.fn.setpos("''", vim.fn.getpos("."))
        sj.run()
    end, { desc = "CJ VL run" })

    vim.keymap.set("n", "<leader>sP", function()
        sj.run({
            max_pattern_length = 1,
            pattern_type = "lua_plain",
        })
    end, { desc = "CJ VL lua_plain" })

    --- buffer --------------------------------------------

    vim.keymap.set("n", "c/", function()
        vim.fn.setpos("''", vim.fn.getpos("."))
        sj.run({
            forward_search = false,
            search_scope = "buffer",
            update_search_register = true,
        })
    end, { desc = "c/" })

    vim.keymap.set("n", "c?", function()
        vim.fn.setpos("''", vim.fn.getpos("."))
        sj.run({
            search_scope = "buffer",
            update_search_register = true,
        })
    end, { desc = "c?" })

    --- current line --------------------------------------

    vim.keymap.set({ "n", "o", "x" }, "<leader>sc", function()
        sj.run({
            auto_jump = true,
            max_pattern_length = 1,
            pattern_type = "lua_plain",
            search_scope = "current_line",
            use_overlay = false,
        })
    end, { desc = "Current line " })

    --- prev/next match -----------------------------------

    vim.keymap.set("n", "<leader>sp", function()
        sj.prev_match()
        if sj_cache.options.search_scope:match("^buffer") then
            vim.cmd("normal! zzzv")
        end
    end, { desc = "Prev search " })

    vim.keymap.set("n", "<leader>sn", function()
        sj.next_match()
        if sj_cache.options.search_scope:match("^buffer") then
            vim.cmd("normal! zzzv")
        end
    end, { desc = "Next search " })

    --- redo ----------------------------------------------

    vim.keymap.set("n", "<leader>sr", function()
        local relative_labels = sj_cache.options.relative_labels
        sj.redo({
            relative_labels = false,
            max_pattern_length = 1,
        })
        sj_cache.options.relative_labels = relative_labels
    end, { desc = "Redo last " })

    vim.keymap.set("n", "<leader>sR", function()
        sj.redo({
            relative_labels = true,
            max_pattern_length = 1,
        })
    end, { desc = "Redo Relative " })
end

function config.harpoon()
    require("harpoon").setup({

        global_settings = {

            save_on_toggle = false,
            save_on_change = true,
            enter_on_sendcmd = true,
            tmux_autoclose_windows = false,
            excluded_filetypes = { "harpoon" },
            mark_branch = false,
        },
    })
    require("telescope").load_extension("harpoon")
end
function config.quick_scope()
    vim.g.qs_max_chars = 256
    vim.g.qs_buftype_blacklist = { "terminal", "nofile", "startify", "qf", "mason" }
    vim.g.qs_lazy_highlight = 1

    require("utils.ui.highlights").plugin("QuickScope", {
        { QuickScopePrimary = { ctermfg = 155, fg = "#ff5fff", underline = true, italic = true, bold = true } },
        { QuickScopeSecondary = { ctermfg = 81, fg = "#5fffff", underline = true, italic = true, bold = true } },
    })
    local function disable_quick_scope()
        if vim.g.qs_enable == 1 then
            return vim.cmd("QuickScopeToggle")
        end
    end

    local function enable_quick_scope()
        if vim.g.qs_enable == 0 then
            return vim.cmd("QuickScopeToggle")
        end
    end
    lambda.augroup("LightspeedQuickscope", {
        {
            event = "User",
            pattern = "LightspeedSxEnter",
            command = disable_quick_scope,
        },
        {
            event = "User",
            pattern = "LightspeedSxLeave",
            command = enable_quick_scope,
        },
        {
            event = "ColorScheme",
            pattern = "*",
            command = function()
                require("utils.ui.highlights").plugin("QuickScope", {
                    {
                        QuickScopePrimary = {
                            ctermfg = 155,
                            fg = "#ff5fff",
                            italic = true,
                            bold = true,
                            underline = true,
                        },
                    },
                    {
                        QuickScopeSecondary = {
                            ctermfg = 81,
                            fg = "#5fffff",
                            italic = true,
                            bold = true,
                            underline = true,
                        },
                    },
                })
            end,
        },
    })
end
function config.marks()
    require("utils.ui.highlights").plugin("marks", {
        { MarkSignHL = { link = "Directory" } },
        { MarkSignNumHL = { link = "Directory" } },
    })
    require("which-key").register({
        m = {
            name = "+marks",
            b = { "<Cmd>MarksListBuf<CR>", "list buffer" },
            g = { "<Cmd>MarksQFListGlobal<CR>", "list global" },
            ["0"] = { "<Cmd>BookmarksQFList 0<CR>", "list bookmark" },
        },
    }, { prefix = "<leader>" })

    require("marks").setup({
        default_mappings = true,
        builtin_marks = { ".", "<", ">", "^" },
        cyclic = true,
        force_write_shada = true,
        refresh_interval = 0,
        sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
        excluded_filetypes = {
            "NeogitStatus",
            "NeogitCommitMessage",
            "toggleterm",
            "harpoon",
            "memento",
            "harpoon-menu",
            "BookMarks",
            "BookMark",
            "bookmarks",
            "bookmark",
        },
        bookmark_0 = {
            sign = "⚑",
            virt_text = "BookMark",
        },
        mappings = {},
    })
    -- https://github.com/chentoast/marks.nvim/issues/40
    vim.api.nvim_create_autocmd("cursorhold", {
        pattern = "*",
        callback = require("marks").refresh,
    })
end

function config.bookmark()
    require("bookmarks").setup({
        keymap = {
            toggle = "<tab><tab>", -- toggle bookmarks
            add = "\\a", -- add bookmarks
            jump = "<CR>", -- jump from bookmarks
            delete = "\\d", -- delete bookmarks
            order = "<\\o", -- order bookmarks by frequency or updated_time
        },
        width = 0.8, -- bookmarks window width:  (0, 1]
        height = 0.6, -- bookmarks window height: (0, 1]
        preview_ratio = 0.4, -- bookmarks preview window ratio (0, 1]
        preview_ext_enable = true, -- if true, preview buf will add file ext, preview window may be highlighed(treesitter), but may be slower.
        fix_enable = true, -- if true, when saving the current file, if the bookmark line number of the current file changes, try to fix it.
        virt_text = "🐼", -- Show virt text at the end of bookmarked lines
        virt_pattern = { "*.python", "*.go", "*.lua", "*.sh", "*.php", "*.rust" }, -- Show virt text only on matched pattern
    })
end

function config.portal()
    vim.cmd([[packadd grapple.nvim]])
    require("grapple").setup({
        ---@type "debug" | "info" | "warn" | "error"
        log_level = "warn",

        ---The scope used when creating, selecting, and deleting tags
        ---@type Grapple.Scope
        scope = "directory",

        ---The save location for tags
        save_path = vim.fn.stdpath("data") .. "/" .. "grapple.json",

        integrations = {
            ---Integration with portal.nvim. Registers a "tagged" query item
            portal = true,
        },
    })

    require("portal").setup({})
end
return config
