local config = {}

function config.hexokinase()
    vim.g.Hexokinase_optInPatterns = {
        "full_hex",
        "triple_hex",
        "rgb",
        "rgba",
        "hsl",
        "hsla",
        "colour_names",
    }
    vim.g.Hexokinase_highlighters = {
        "virtual",
        "sign_column", -- 'background',
        "backgroundfull",
        -- 'foreground',
        -- 'foregroundfull'
    }
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
        force_write_shada = false,
        refresh_interval = 9,
        sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
        excluded_filetypes = {
            "NeogitStatus",
            "NeogitCommitMessage",
            "toggleterm",
            "harpoon",
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
        fix_enable = false, -- if true, when saving the current file, if the bookmark line number of the current file changes, try to fix it.
    })
end

function config.sidebar()
    if not packer_plugins["neogit"].loaded then
        require("packer").loader("neogit")
    end
    require("sidebar-nvim").setup({
        open = true,
        side = "left",
        initial_width = 32,
        hide_statusline = false,
        bindings = {
            ["q"] = function(a, b) end,
        },
        update_interval = 1000,
        section_separator = { "────────────────" },
        sections = { "files", "git", "symbols", "containers" },

        git = {
            icon = "",
        },
        symbols = {
            icon = "ƒ",
        },
        containers = {
            icon = "",
            attach_shell = "/bin/sh",
            show_all = true,
            interval = 5000,
        },
        datetime = { format = "%a%b%d|%H:%M", clocks = { { name = "local" } } },
        todos = { ignored_paths = { "~" } },
    })
end

function config.diaglist()
    require("diaglist").init({
        debug = false,
        debounce_ms = 150,
    })
    local add_cmd = vim.api.nvim_create_user_command

    vim.api.nvim_create_user_command("Qfa", function()
        require("diaglist").open_all_diagnostics()
    end, { force = true })

    vim.api.nvim_create_user_command("Qfb", function()
        vim.diagnostic.setqflist()
        require("diaglist").open_buffer_diagnostics()
    end, { force = true })

    vim.keymap.set(
        "n",
        ";qw",
        "<cmd>lua require('diaglist').open_all_diagnostics()<cr>",
        { noremap = true, silent = true }
    )
    vim.keymap.set("n", ";qq", function()
        vim.diagnostic.setqflist()

        require("diaglist").open_buffer_diagnostics()
    end, { noremap = true, silent = true })
end

function config.surround()
    require("nvim-surround").setup({
        keymaps = {
            insert = "<c-c><leader>",
            insert_line = "<C-g>g",
            normal = "ys",
            normal_cur = "yss",
            normal_line = "yS",
            normal_cur_line = "ySS",
            visual = "yS",
            visual_line = "gS",
            delete = "ds",
            change = "<c-/>",
        },
    })
end

function config.guess_indent_setup()
    vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "*",
        callback = function()
            local f = vim.fn
            if lambda.config.use_guess_indent then
                require("packer").loader("guess-indent.nvim")
            end
        end,
    })
end

function config.guess_indent()
    require("guess-indent").setup({
        auto_cmd = true, -- Set to false to disable automatic execution
        filetype_exclude = { -- A list of filetypes for which the auto command gets disabled
            "netrw",
            "neo-tree",
            "tutor",
        },
        buftype_exclude = { -- A list of buffer types for which the auto command gets disabled
            "help",
            "nofile",
            "terminal",
            "prompt",
        },
    })
end

function config.headers()
    local highlights = require("utils.ui.highlights")
    -- https://observablehq.com/@d3/color-schemes?collection=@d3/d3-scale-chromatic
    -- NOTE: this must be set in the setup function or it will crash nvim...
    highlights.plugin("Headlines", {
        theme = {
            ["*"] = {
                { Headline1 = { background = "#003c30", foreground = "White" } },
                { Headline2 = { background = "#00441b", foreground = "White" } },
                { Headline3 = { background = "#084081", foreground = "White" } },
                { Dash = { background = "#0b60a1", bold = true } },
            },
            ["horizon"] = {
                { Headline = { background = { from = "Normal", alter = 20 } } },
            },
        },
    })
    require("headlines").setup()
end

function config.NeoWell()
    require("neo-well").setup({
        height = 10,
    })
end

function config.session_setup()
    vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "*",
        callback = function()
            if lambda.config.use_session == true then
                require("packer").loader("persisted.nvim")
            end
        end,
        once = true,
    })
end
function config.session_config()
    require("persisted").setup({
        save_dir = vim.fn.expand(vim.fn.stdpath("data") .. "/sessions/"), -- Resolves to ~/.local/share/nvim/sessions/
        autosave = true,
        autoload = true,
        use_git_branch = true,
        after_source = function()
            -- Reload the LSP servers
            vim.lsp.stop_client(vim.lsp.get_active_clients())
        end,

        telescope = {
            before_source = function()
                vim.api.nvim_input("<ESC>:%bd<CR>")
            end,
            after_source = function(session)
                print("Loaded session " .. session.name)
            end,
        },
    })
    require("telescope").load_extension("persisted") -- To load the telescope extension
end

function config.autosave()
    require("save").setup()
end

function config.carbon()
    require("carbon-now").setup({
        options = {
            theme = "dracula pro",
            window_theme = "none",
            font_family = "Hack",
            font_size = "18px",
            bg = "gray",
            line_numbers = true,
            line_height = "133%",
            drop_shadow = false,
            drop_shadow_offset_y = "20px",
            drop_shadow_blur = "68px",
            width = "680",
            watermark = false,
        },
    })
end

function config.attempt()
    local attempt = require("attempt")
    attempt.setup()

    require("telescope").load_extension("attempt")

    function map(mode, l, r, opts)
        opts = opts or {}
        opts = vim.tbl_extend("force", { silent = true }, opts)
        vim.keymap.set(mode, l, r, opts)
    end

    map("n", "<leader>an", attempt.new_select) -- new attempt, selecting extension
    map("n", "<leader>ai", attempt.new_input_ext) -- new attempt, inputing extension
    map("n", "<leader>ar", attempt.run) -- run attempt
    map("n", "<leader>ad", attempt.delete_buf) -- delete attempt from current buffer
    map("n", "<leader>ac", attempt.rename_buf) -- rename attempt from current buffer
    map("n", "<leader>aL", "Telescope attempt") -- search through attempts
    map("n", "<leader>al", attempt.open_select) -- use ui.select instead of telescope
end

return config
