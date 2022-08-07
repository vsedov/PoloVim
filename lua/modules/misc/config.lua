local config = {}

function config.syntax_surfer()
    require("modules.misc.syntax_surfer")
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
            next_match_group = "<TAB>",
            prev_match_group = "<S-Tab>",
        },
        --- f/t ---
        limit_ft_matches = 20,
        repeat_ft_with_target_char = true,
    })
    local default_keymaps = {
        { "n", "<c-s>", "<Plug>Lightspeed_omni_s" },
        { "n", "cs", "<Plug>Lightspeed_omni_gs" },
        { "x", "<c-s>", "<Plug>Lightspeed_omni_s" },
        { "x", "cs", "<Plug>Lightspeed_omni_gs" },
        { "o", "<c-s>", "<Plug>Lightspeed_omni_s" },
        { "o", "cs", "<Plug>Lightspeed_omni_gs" },
    }
    for _, m in ipairs(default_keymaps) do
        vim.keymap.set(m[1], m[2], m[3], { noremap = true, silent = true })
    end
end

function config.hop()
    require("hop").setup({
        -- keys = 'etovxqpdygfblzhckisuran',
        quit_key = "<ESC>",
        jump_on_sole_occurrence = true,
        case_insensitive = true,
        multi_windows = true,
    })
    -- hopeAnywhere is not really needed
    vim.keymap.set("n", "\\s", "<cmd>HopPatternCurrentLine<cr>", {})
    vim.keymap.set("n", "<leader><leader>s", "<cmd>HopWord<cr>", {})
    vim.keymap.set("n", "<leader><leader>j", "<cmd>HopChar1<cr>", {})
    vim.keymap.set("n", "<leader><leader>k", "<cmd>HopChar2<cr>", {})
    vim.keymap.set("n", "<leader><leader>w", "<cmd>HopLine<cr>", {})
    vim.keymap.set("n", "<leader><leader>l", "<cmd>HopLineStart<cr>", {})
    vim.keymap.set("n", "g/", "<cmd>HopVertical<cr>", {})

    vim.keymap.set("n", "g?", "<cmd>HopPattern<cr>", {})
end

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

-- Exit                  <Esc>       quit VM
-- Find Under            <C-n>       select the word under cursor
-- Find Subword Under    <C-n>       from visual mode, without word boundaries
-- Add Cursor Down       <M-Down>    create cursors vertically
-- Add Cursor Up         <M-Up>      ,,       ,,      ,,
-- Select All            \\A         select all occurrences of a word
-- Start Regex Search    \\/         create a selection with regex search
-- Add Cursor At Pos     \\\         add a single cursor at current position
-- Reselect Last         \\gS        reselect set of regions of last VM session

-- Mouse Cursor    <C-LeftMouse>     create a cursor where clicked
-- Mouse Word      <C-RightMouse>    select a word where clicked
-- Mouse Column    <M-C-RightMouse>  create a column, from current cursor to
--                                   clicked position
function config.vmulti()
    vim.g.VM_mouse_mappings = 1
    -- mission control takes <C-up/down> so remap <M-up/down> to <C-Up/Down>
    -- vim.api.nvim_set_keymap("n", "<M-n>", "<C-n>", {silent = true})
    -- vim.api.nvim_set_keymap("n", "<M-Down>", "<C-Down>", {silent = true})
    -- vim.api.nvim_set_keymap("n", "<M-Up>", "<C-Up>", {silent = true})
    -- for mac C-L/R was mapped to mission control
    -- print('vmulti')
    vim.g.VM_silent_exit = 1
    vim.g.VM_show_warnings = 0
    vim.g.VM_default_mappings = 1
    vim.cmd([[
      let g:VM_maps = {}
      let g:VM_maps['Find Under'] = '<C-n>'
      let g:VM_maps['Find Subword Under'] = '<C-n>'
      let g:VM_maps['Select All'] = '<C-n>a'
      let g:VM_maps['Seek Next'] = 'n'
      let g:VM_maps['Seek Prev'] = 'N'
      let g:VM_maps["Undo"] = 'u'
      let g:VM_maps["Redo"] = '<C-r>'
      let g:VM_maps["Remove Region"] = '<cr>'
      let g:VM_maps["Add Cursor Down"] = '<M-Down>'
      let g:VM_maps["Add Cursor Up"] = "<M-Up>"
      let g:VM_maps["Mouse Cursor"] = "<M-LeftMouse>"
      let g:VM_maps["Mouse Word"] = "<M-RightMouse>"
      let g:VM_maps["Add Cursor At Pos"] = '<M-i>'
  ]])
end

function config.iswap()
    require("iswap").setup({
        keys = "qwertyuiop",
        autoswap = true,
    })
end

function config.houdini_setup()
    vim.api.nvim_create_autocmd("User", {
        desc = "fix for https://github.com/ggandor/lightspeed.nvim/issues/140",
        pattern = "LightspeedSxLeave",
        callback = function()
            local ignore = vim.tbl_contains({ "terminal", "prompt" }, vim.opt.buftype:get())
            if vim.opt.modifiable:get() and not ignore then
                vim.cmd("normal! a")
            end
        end,
    })
end

function config.houdini()
    require("houdini").setup({
        mappings = { "jk", "AA", "II" },
        escape_sequences = {
            i = function(first, second)
                local seq = first .. second

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
        },
    })
end

function config.text_case()
    vim.cmd([[packadd which-key.nvim]])
    vim.cmd([[packadd telescope.nvim]])
    require("textcase").setup({})
    require("telescope").load_extension("textcase")
    vim.keymap.set(
        "n",
        "gaw",
        "<cmd>lua require('textcase').current_word('to_snake_case')<cr>",
        { desc = "to snake case", noremap = true }
    )
    vim.keymap.set(
        "n",
        "gaW",
        "<cmd>lua require('textcase').lsp_rename('to_snake_case')<cr>",
        { desc = "lsp rename to snake_case", noremap = true }
    )
    vim.api.nvim_set_keymap("n", "ga.", "<cmd>TextCaseOpenTelescope<CR>", { desc = "Telescope" })
    vim.api.nvim_set_keymap("v", "ga.", "<cmd>TextCaseOpenTelescope<CR>", { desc = "Telescope" })
end

function config.marks()
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
        excluded_filetypes = { "NeogitStatus", "NeogitCommitMessage", "toggleterm", "harpoon", "harpoon-menu" },
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
function config.reach()
    require("reach").setup({
        notifications = true,
    })
end

function config.scope_setup()
    vim.api.nvim_create_autocmd({ "BufAdd", "TabEnter" }, {
        pattern = "*",
        group = vim.api.nvim_create_augroup("scope_loading", {}),
        callback = function()
            local count = #vim.fn.getbufinfo({ buflisted = 1 })
            if count >= 2 then
                require("packer").loader("scope.nvim")
            end
        end,
    })
end

function config.scope()
    require("scope").setup()
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
        vim.cmd([[lua require("diaglist").open_buffer_diagnostics()]])
    end, { force = true })

    vim.keymap.set(
        "n",
        ";qw",
        "<cmd>lua require('diaglist').open_all_diagnostics()<cr>",
        { noremap = true, silent = true }
    )
    vim.keymap.set(
        "n",
        ";qq",
        "<cmd>lua require('diaglist').open_buffer_diagnostics()<cr>",
        { noremap = true, silent = true }
    )
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
            change = "cS",
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
    require("headlines").setup()
end

function config.NeoWell()
    require("neo-well").setup({
        height = 10,
    })
end

function config.table()
    vim.g.table_mode_corner = "|"
    vim.cmd([[
function! s:isAtStartOfLine(mapping)
  let text_before_cursor = getline('.')[0 : col('.')-1]
  let mapping_pattern = '\V' . escape(a:mapping, '\')
  let comment_pattern = '\V' . escape(substitute(&l:commentstring, '%s.*$', '', ''), '\')
  return (text_before_cursor =~? '^' . ('\v(' . comment_pattern . '\v)?') . '\s*\v' . mapping_pattern . '\v$')
endfunction

inoreabbrev <expr> <bar><bar>
          \ <SID>isAtStartOfLine('\|\|') ?
          \ '<c-o>:TableModeEnable<cr><bar><space><bar><left><left>' : '<bar><bar>'
inoreabbrev <expr> __
          \ <SID>isAtStartOfLine('__') ?
          \ '<c-o>:silent! TableModeDisable<cr>' : '__'w
        ]])
end

function config.session_setup()
    vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "*",
        callback = function()
            local f = vim.fn
            if lambda.config.use_session then
                require("packer").loader("persisted.nvim")
            end
        end,
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
    require("auto-save").setup()
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

return config
