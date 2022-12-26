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

function config.sidebar()
    if not packer_plugins["neogit"].loaded then
        require("lazy").load("neogit")
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
            insert_line = "<C-#>", -- I am not sure how i feel about this
            normal = "ys",
            normal_cur = "yss",
            normal_line = "yS",
            normal_cur_line = "ySS",
            visual = "gs",
            visual_line = "gS",
            delete = "ds",
            change = "cs",
        },
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
    require("headlines").setup()
end

function config.NeoWell()
    require("neo-well").setup({
        height = 10,
    })
end

function config.session_config()
    -- require("persisted").setup({
    --     save_dir = vim.fn.expand(vim.fn.stdpath("data") .. "/sessions/"), -- Resolves to ~/.local/share/nvim/sessions/
    --     autosave = true,
    --     autoload = true,
    --     use_git_branch = true,
    --     after_source = function()
    --         -- Reload the LSP servers
    --         vim.lsp.stop_client(vim.lsp.get_active_clients())
    --     end,

    --     telescope = {
    --         before_source = function()
    --             vim.api.nvim_input("<ESC>:%bd<CR>")
    --         end,
    --         after_source = function(session)
    --             print("Loaded session " .. session.name)
    --         end,
    --     },
    -- })
    -- require("telescope").load_extension("persisted") -- To load the telescope extension
    local resession = require("resession")
    resession.setup({
        autosave = {
            enabled = true,
            interval = 60,
            notify = false, -- Fucking annoying
        },
        tab_buf_filter = function(tabpage, bufnr)
            local dir = vim.fn.getcwd(-1, vim.api.nvim_tabpage_get_number(tabpage))
            return vim.startswith(vim.api.nvim_buf_get_name(bufnr), dir)
        end,
    })

    vim.keymap.set("n", "_ss", resession.save_tab)
    vim.keymap.set("n", "_sl", resession.load)
    vim.keymap.set("n", "_sd", resession.delete)
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
