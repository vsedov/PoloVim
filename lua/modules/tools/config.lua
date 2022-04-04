local config = {}

local function load_env_file()
    local env_file = require("core.global").home .. "/.env"
    local env_contents = {}
    if vim.fn.filereadable(env_file) ~= 1 then
        print(".env file does not exist")
        return
    end
    local contents = vim.fn.readfile(env_file)
    for _, item in pairs(contents) do
        local line_content = vim.fn.split(item, "=")
        env_contents[line_content[1]] = line_content[2]
    end
    return env_contents
end

local function load_dbs()
    local env_contents = load_env_file()
    local dbs = {}
    for key, value in pairs(env_contents) do
        if vim.fn.stridx(key, "DB_CONNECTION_") >= 0 then
            local db_name = vim.fn.split(key, "_")[3]:lower()
            dbs[db_name] = value
        end
    end
    return dbs
end

function config.diffview()
    local cb = require("diffview.config").diffview_callback
    require("diffview").setup({
        diff_binaries = false, -- Show diffs for binaries
        use_icons = true, -- Requires nvim-web-devicons
        enhanced_diff_hl = false, -- See ':h diffview-config-enhanced_diff_hl'
        signs = { fold_closed = "", fold_open = "" },
        file_panel = {
            position = "left", -- One of 'left', 'right', 'top', 'bottom'
            width = 35, -- Only applies when position is 'left' or 'right'
            height = 10, -- Only applies when position is 'top' or 'bottom'
        },
        key_bindings = {
            -- The `view` bindings are active in the diff buffers, only when the current
            -- tabpage is a Diffview.
            view = {
                ["<tab>"] = cb("select_next_entry"), -- Open the diff for the next file
                ["<s-tab>"] = cb("select_prev_entry"), -- Open the diff for the previous file
                ["<leader>e"] = cb("focus_files"), -- Bring focus to the files panel
                ["<leader>b"] = cb("toggle_files"), -- Toggle the files panel.
            },
            file_panel = {
                ["j"] = cb("next_entry"), -- Bring the cursor to the next file entry
                ["<down>"] = cb("next_entry"),
                ["k"] = cb("prev_entry"), -- Bring the cursor to the previous file entry.
                ["<up>"] = cb("prev_entry"),
                ["<cr>"] = cb("select_entry"), -- Open the diff for the selected entry.
                ["o"] = cb("select_entry"),
                ["R"] = cb("refresh_files"), -- Update stats and entries in the file list.
                ["<tab>"] = cb("select_next_entry"),
                ["<s-tab>"] = cb("select_prev_entry"),
                ["<leader>e"] = cb("focus_files"),
                ["<leader>b"] = cb("toggle_files"),
            },
        },
    })
end

function config.vim_dadbod_ui()
    if packer_plugins["vim-dadbod"] and not packer_plugins["vim-dadbod"].loaded then
        require("packer").loader("vim-dadbod")
    end
    vim.g.db_ui_show_help = 0
    vim.g.db_ui_win_position = "left"
    vim.g.db_ui_use_nerd_fonts = 1
    vim.g.db_ui_winwidth = 35
    vim.g.db_ui_save_location = require("core.global").home .. "/.cache/vim/db_ui_queries"
    vim.g.dbs = load_dbs()
end

function config.vim_vista()
    vim.g["vista#renderer#enable_icon"] = 1
    vim.g.vista_disable_statusline = 1

    vim.g.vista_default_executive = "nvim_lsp" -- ctag
    vim.g.vista_echo_cursor_strategy = "floating_win"
    vim.g.vista_vimwiki_executive = "markdown"
    vim.g.vista_executive_for = {
        vimwiki = "markdown",
        pandoc = "markdown",
        markdown = "toc",
        typescript = "nvim_lsp",
        typescriptreact = "nvim_lsp",
        go = "nvim_lsp",
        lua = "nvim_lsp",
    }

    -- vim.g['vista#renderer#icons'] = {['function'] = "", ['method'] = "ℱ", variable = "כֿ"}
end

function config.clap()
    -- require("packer").loader("LuaSnip")

    vim.g.clap_preview_size = 10
    vim.g.airline_powerline_fonts = 1
    vim.g.clap_layout = { width = "80%", row = "8%", col = "10%", height = "34%" } -- height = "40%", row = "17%", relative = "editor",
    -- vim.g.clap_popup_border = "rounded"
    vim.g.clap_selected_sign = { text = "", texthl = "ClapSelectedSign", linehl = "ClapSelected" }
    vim.g.clap_current_selection_sign = {
        text = "",
        texthl = "ClapCurrentSelectionSign",
        linehl = "ClapCurrentSelection",
    }
    -- vim.g.clap_always_open_preview = true
    vim.g.clap_preview_direction = "UD"
    -- if vim.g.colors_name == 'zephyr' then
    vim.g.clap_theme = "material_design_dark"
    vim.api.nvim_command(
        "autocmd FileType clap_input lua require'cmp'.setup.buffer { completion = {autocomplete = false} }"
    )
    -- end
    -- vim.api.nvim_command("autocmd FileType clap_input call compe#setup({ 'enabled': v:false }, 0)")
end

function config.clap_after()
    if not packer_plugins["LuaSnip"].loaded then
        require("packer").loader("LuaSnip")
    end

    if not packer_plugins["nvim-cmp"].loaded then
        require("packer").loader("nvim-cmp")
    end
end

function config.vgit()
    -- use this as a diff tool (faster than Diffview)
    -- there are overlaps with gitgutter. following are nice features
    require("vgit").setup({
        keymaps = {
            ["n <leader>ga"] = "actions", -- show all commands in telescope
            ["n <leader>ba"] = "buffer_gutter_blame_preview", -- show all blames
            ["n <leader>bp"] = "buffer_blame_preview", -- buffer diff
            ["n <leader>bh"] = "buffer_history_preview", -- buffer commit history DiffviewFileHistory
            ["n <leader>gp"] = "buffer_staged_diff_preview", -- diff for staged changes
            ["n <leader>pd"] = "project_diff_preview", -- diffview is slow
        },
        controller = {
            hunks_enabled = false, -- gitsigns
            blames_enabled = false,
            diff_strategy = "index",
            diff_preference = "vertical",
            predict_hunk_signs = true,
            predict_hunk_throttle_ms = 500,
            predict_hunk_max_lines = 50000,
            blame_line_throttle_ms = 250,
            show_untracked_file_signs = true,
            action_delay_ms = 500,
        },
    })
    require("packer").loader("telescope.nvim")
    -- print('vgit')
    -- require("vgit")._buf_attach()
end

-- Nice
function config.project()
    require("project_nvim").setup({
        datapath = vim.fn.stdpath("data"),
        ignore_lsp = { "efm" },
        exclude_dirs = { "~/.cargo/*", "~/.conf/nvim/" },
        silent_chdir = true, -- fucking annoying thing
        detection_methods = { "lsp", "pattern" },
        patterns = {
            "pom.xml", --
            "Pipfile",
            ".venv", -- for python
            "_darcs",
            ".hg",
            ".bzr",
            ".svn",
            "node_modules",
            "xmake.lua",
            "pom.xml", -- java
            "CMakeLists.txt",
            ".null-ls-root",
            "Makefile",
            "package.json",
            "tsconfig.json",
            ".git",
        },

        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
    })
    require("telescope").load_extension("projects")
end

function config.worktree()
    function git_worktree(arg)
        if arg == "create" then
            require("telescope").extensions.git_worktree.create_git_worktree()
        else
            require("telescope").extensions.git_worktree.git_worktrees()
        end
    end

    require("git-worktree").setup({})
    vim.api.nvim_add_user_command("Worktree", "lua git_worktree(<f-args>)", {
        nargs = "*",
        complete = function()
            return { "create" }
        end,
    })

    local Worktree = require("git-worktree")
    Worktree.on_tree_change(function(op, metadata)
        if op == Worktree.Operations.Switch then
            print("Switched from " .. metadata.prev_path .. " to " .. metadata.path)
        end

        if op == Worktree.Operations.Create then
            print("Create worktree " .. metadata.path)
        end

        if op == Worktree.Operations.Delete then
            print("Delete worktree " .. metadata.path)
        end
    end)
end

function config.neoclip()
    require("neoclip").setup({
        history = 2000,
        enable_persistent_history = true,
        db_path = vim.fn.stdpath("data") .. "/databases/neoclip.sqlite3",
        filter = nil,
        preview = true,
        default_register = "a extra=star,plus,unnamed,b",
        default_register_macros = "q",
        enable_macro_history = true,
        content_spec_column = true,
        on_paste = {
            set_reg = false,
        },
        on_replay = {
            set_reg = false,
        },
        keys = {
            telescope = {
                i = {
                    select = "<cr>",
                    paste = "<c-p>",
                    paste_behind = "<c-k>",
                    replay = "<c-q>",
                    custom = {},
                },
                n = {
                    select = "<cr>",
                    paste = "p",
                    paste_behind = "P",
                    replay = "q",
                    custom = {},
                },
            },
        },
    })
end

function config.neogit()
    require("neogit").setup({
        disable_signs = false,
        disable_context_highlighting = false,
        disable_commit_confirmation = false,
        auto_refresh = true,
        disable_builtin_notifications = true,
        use_magit_keybindings = true,
        signs = {
            -- { CLOSED, OPENED }
            section = { ">", "v" },
            item = { ">", "v" },
            hunk = { "", "" },
        },
        integrations = {
            diffview = true,
        },
        -- override/add mappings
        mappings = {
            -- modify status buffer mappings
            status = {
                -- Adds a mapping with "B" as key that does the "BranchPopup" command
                ["B"] = "BranchPopup",
                -- Removes the default mapping of "s"
                ["s"] = "",
            },
        },
    })
end

function config.gitsigns()
    if not packer_plugins["plenary.nvim"].loaded then
        require("packer").loader("plenary.nvim")
    end

    local gitsigns = require("gitsigns")

    local line = vim.fn.line

    vim.keymap.set("n", "gts", function()
        gitsigns.dump_cache()
    end)
    vim.keymap.set("n", "gtS", function()
        gitsigns.debug_messages()
    end)

    local function on_attach(bufnr)
        local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
        end

        map("n", "]c", function()
            if vim.wo.diff then
                return "]c"
            end
            vim.schedule(gitsigns.next_hunk)
            return "<Ignore>"
        end, { expr = true })

        map("n", "[c", function()
            if vim.wo.diff then
                return "[c"
            end
            vim.schedule(gitsigns.prev_hunk)
            return "<Ignore>"
        end, { expr = true })

        map("n", "<leader>hs", gitsigns.stage_hunk)
        map("n", "<leader>hr", gitsigns.reset_hunk)
        map("v", "<leader>hs", function()
            gitsigns.stage_hunk({ line("."), line("v") })
        end)
        map("v", "<leader>hr", function()
            gitsigns.reset_hunk({ line("."), line("v") })
        end)
        map("n", "<leader>hS", gitsigns.stage_buffer)
        map("n", "<leader>hu", gitsigns.undo_stage_hunk)
        map("n", "<leader>hR", gitsigns.reset_buffer)
        map("n", "<leader>hp", gitsigns.preview_hunk)
        map("n", "<leader>hb", function()
            gitsigns.blame_line({ full = true })
        end)
        map("n", "<leader>tb", gitsigns.toggle_current_line_blame)
        map("n", "<leader>hd", gitsigns.diffthis)
        map("n", "<leader>hD", function()
            gitsigns.diffthis("~")
        end)
        map("n", "<leader>td", gitsigns.toggle_deleted)

        map("n", "<leader>hQ", function()
            gitsigns.setqflist("all")
        end)
        map("n", "<leader>hq", function()
            gitsigns.setqflist()
        end)

        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
    end
    gitsigns.setup({
        debug_mode = true,
        max_file_length = 1000000000,
        signs = {
            add = { show_count = false, text = "│" },
            change = { show_count = false, text = "│" },
            delete = { show_count = true, text = "ﬠ" },
            topdelete = { show_count = true, text = "ﬢ" },
            changedelete = { show_count = true, text = "┊" },
        },
        on_attach = on_attach,
        preview_config = {
            border = "rounded",
        },
        current_line_blame = true,
        current_line_blame_formatter = " : <author> | <author_time:%Y-%m-%d> | <summary>",
        current_line_blame_formatter_opts = {
            relative_time = true,
        },
        current_line_blame_opts = {
            delay = 0,
        },
        count_chars = {
            "⒈",
            "⒉",
            "⒊",
            "⒋",
            "⒌",
            "⒍",
            "⒎",
            "⒏",
            "⒐",
            "⒑",
            "⒒",
            "⒓",
            "⒔",
            "⒕",
            "⒖",
            "⒗",
            "⒘",
            "⒙",
            "⒚",
            "⒛",
        },
        _refresh_staged_on_update = false,
        watch_gitdir = { interval = 1000, follow_files = true },
        sign_priority = 6,
        status_formatter = nil, -- Use default
        update_debounce = 0,
        word_diff = true,
        diff_opts = { internal = true },
    })
end

function config.bqf()
    require("bqf").setup({
        auto_enable = true,
        auto_resize_height = true,
        preview = {
            win_height = 12,
            win_vheight = 12,
            delay_syntax = 80,
            border_chars = { "┃", "┃", "━", "━", "┏", "┓", "┗", "┛", "█" },
        },
        func_map = { vsplit = "", ptogglemode = "z,", stoggleup = "" },
        filter = {
            fzf = {
                action_for = { ["ctrl-s"] = "split" },
                extra_opts = { "--bind", "ctrl-o:toggle-all", "--prompt", "> " },
            },
        },
    })
    local function tabDropHandler()
        require("bqf.qfwin.handler").open(true, "TabDrop")
    end

    local function setItemMappings()
        vim.keymap.set({ "n" }, "<2-LeftMouse>", tabDropHandler, { buffer = true })
    end

    vim.api.nvim_create_augroup("BqfMappings", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
        group = "BqfMappings",
        pattern = "qf",
        callback = setItemMappings,
    })
end

function config.clipboardimage()
    vim.cmd([[packadd clipboard-image.nvim]])
    require("clipboard-image").setup({})
end

function config.dapui()
    vim.cmd([[let g:dbs = {
  \ 'eraser': 'postgres://postgres:password@localhost:5432/eraser_local',
  \ 'staging': 'postgres://postgres:password@localhost:5432/my-staging-db',
  \ 'wp': 'mysql://root@localhost/wp_awesome' }]])
    require("dapui").setup({
        icons = { expanded = "⯆", collapsed = "⯈", circular = "↺" },

        mappings = {
            -- Use a table to apply multiple mappings
            expand = { "<CR>", "<2-LeftMouse>" },
            open = "o",
            remove = "d",
            edit = "e",
        },
        sidebar = {
            elements = {
                -- You can change the order of elements in the sidebar
                "scopes",
                "stacks",
                "watches",
            },
            width = 40,
            position = "left", -- Can be "left" or "right"
        },
        tray = {
            elements = { "repl" },
            height = 10,
            position = "bottom", -- Can be "bottom" or "top"
        },
        floating = {
            max_height = nil, -- These can be integers or a float between 0 and 1.
            max_width = nil, -- Floats will be treated as percentage of your screen.
        },
    })
end

function config.markdown()
    vim.g.vim_markdown_frontmatter = 1
    vim.g.vim_markdown_strikethrough = 1
    vim.g.vim_markdown_folding_level = 6
    vim.g.vim_markdown_override_foldtext = 1
    vim.g.vim_markdown_folding_style_pythonic = 1
    vim.g.vim_markdown_conceal = 1
    vim.g.vim_markdown_conceal_code_blocks = 1
    vim.g.vim_markdown_new_list_item_indent = 0
    vim.g.vim_markdown_toc_autofit = 0
    vim.g.vim_markdown_edit_url_in = "vsplit"
    vim.g.vim_markdown_strikethrough = 1
    vim.g.vim_markdown_fenced_languages = {
        "c++=javascript",
        "js=javascript",
        "json=javascript",
        "jsx=javascript",
        "tsx=javascript",
    }
end

--[[
Use `git ls-files` for git files, use `find ./ *` for all files under work directory.
]]
--

function config.floaterm()
    -- Set floaterm window's background to black
    -- Set floating window border line color to cyan, and background to orange
    vim.g.floaterm_wintype = "float"
    vim.g.floaterm_width = 0.9
    vim.g.floaterm_height = 0.9
    vim.cmd("hi Floaterm guibg=black")
    -- vim.cmd('hi FloatermBorder guibg=orange guifg=cyan')
    vim.cmd("command! FZF FloatermNew fzf --autoclose=1")
    vim.cmd("command! NNN FloatermNew --autoclose=1 --height=0.96 --width=0.96 nnn")
    vim.cmd("command! FN FloatermNew --autoclose=1 --height=0.96 --width=0.96")
    vim.cmd("command! LG FloatermNew --autoclose=1 --height=0.96 --width=0.96 lazygit")
    vim.cmd("command! Ranger FloatermNew --autoclose=1 --height=0.96 --width=0.96 ranger")

    vim.g.floaterm_gitcommit = "split"
    vim.g.floaterm_keymap_new = "<F19>" -- S-f7
    vim.g.floaterm_keymap_prev = "<F20>"
    vim.g.floaterm_keymap_next = "<F21>"
    vim.g.floaterm_keymap_toggle = "<F24>"
    -- Use `git ls-files` for git files, use `find ./ *` for all files under work directory.
    -- vim.cmd([[ command! Sad lua Sad()]])
    -- grep -rli 'old-word' * | xargs -i@ sed -i 's/old-word/new-word/g' @
    --  rg -l 'old-word' * | xargs -i@ sed -i 's/old-word/new-word/g' @
end

function config.spelunker()
    -- vim.cmd("command! Spell call spelunker#check()")
    vim.g.enable_spelunker_vim_on_readonly = 0
    vim.g.spelunker_target_min_char_len = 5
    vim.g.spelunker_check_type = 2
    vim.g.spelunker_highlight_type = 2
    vim.g.spelunker_disable_uri_checking = 1
    vim.g.spelunker_disable_account_name_checking = 1
    vim.g.spelunker_disable_email_checking = 1
    -- vim.cmd("highlight SpelunkerSpellBad cterm=underline ctermfg=247 gui=undercurl guifg=#F3206e guisp=#EF3050")
    -- vim.cmd("highlight SpelunkerComplexOrCompoundWord cterm=underline gui=undercurl guisp=#EF3050")
    vim.cmd("highlight def link SpelunkerSpellBad SpellBad")
    vim.cmd("highlight def link SpelunkerComplexOrCompoundWord Rare")
end

function config.spellcheck()
    vim.cmd("highlight def link SpelunkerSpellBad SpellBad")
    vim.cmd("highlight def link SpelunkerComplexOrCompoundWord Rare")

    vim.fn["spelunker#check"]()
end

function config.grammcheck()
    -- body
    if not packer_plugins["rhysd/vim-grammarous"] or not packer_plugins["rhysd/vim-grammarous"].loaded then
        require("packer").loader("vim-grammarous")
    end
    vim.cmd([[GrammarousCheck]])
end

function config.vim_test()
    vim.g["test#strategy"] = { nearest = "neovim", file = "neovim", suite = "neovim" }
    vim.g["test#neovim#term_position"] = "vert botright 60"
    vim.g["test#go#runner"] = "ginkgo"
    -- nmap <silent> t<C-n> :TestNearest<CR>
    -- nmap <silent> t<C-f> :TestFile<CR>
    -- nmap <silent> t<C-s> :TestSuite<CR>
    -- nmap <silent> t<C-l> :TestLast<CR>
    -- nmap <silent> t<C-g> :TestVisit<CR>
end

function config.mkdp()
    -- print("mkdp")
    vim.g.mkdp_command_for_global = 1
    vim.cmd(
        [[let g:mkdp_preview_options = { 'mkit': {}, 'katex': {}, 'uml': {}, 'maid': {}, 'disable_sync_scroll': 0, 'sync_scroll_type': 'middle', 'hide_yaml_meta': 1, 'sequence_diagrams': {}, 'flowchart_diagrams': {}, 'content_editable': v:true, 'disable_filename': 0 }]]
    )
end

function config.paperplanes()
    require("paperplanes").setup({
        register = "+",
        provider = "ix.io",
    })
end

function config.wilder()
    vim.cmd([[packadd fzy-lua-native]])
    vim.cmd([[packadd cpsm]])
    vim.cmd([[
call wilder#setup({'modes': [':', '/', '?']})

let s:popupmenu_renderer = wilder#popupmenu_renderer(wilder#popupmenu_border_theme({
      \ 'border': 'Normal',
      \ 'empty_message': wilder#popupmenu_empty_message_with_spinner(),
      \ 'left': [
      \   ' ',
      \   wilder#popupmenu_devicons(),
      \   wilder#popupmenu_buffer_flags({
      \     'flags': ' a + ',
      \     'icons': {'+': '', 'a': '', 'h': ''},
      \   }),
      \ ],
      \ 'right': [
      \   ' ',
      \   wilder#popupmenu_scrollbar(),
      \ ],
      \ }))

let s:wildmenu_renderer = wilder#wildmenu_renderer({
      \ 'separator': ' · ',
      \ 'left': [' ', wilder#wildmenu_spinner(), ' '],
      \ 'right': [' ', wilder#wildmenu_index()],
      \ })

call wilder#set_option('renderer', wilder#renderer_mux({
      \ ':': s:popupmenu_renderer,
      \ '/': s:wildmenu_renderer,
      \ 'substitute': s:wildmenu_renderer,
      \ }))]])
end
return config
