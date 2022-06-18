local config = {}

function config.syntax_surfer()
    require("modules.misc.syntax_surfer")
end

function config.lightspeed_setup()
    local default_keymaps = {
        { "n", "<M-s>", "<Plug>Lightspeed_omni_s" },
        { "n", "<M-S>", "<Plug>Lightspeed_omni_gs" },
        { "x", "<M-s>", "<Plug>Lightspeed_omni_s" },
        { "x", "<M-S>", "<Plug>Lightspeed_omni_gs" },
        { "o", "<M-s>", "<Plug>Lightspeed_omni_s" },
        { "o", "<M-S>", "<Plug>Lightspeed_omni_gs" },

        { "n", "gs", "<Plug>Lightspeed_gs" },
        { "n", "gS", "<Plug>Lightspeed_gS" },
        { "x", "gs", "<Plug>Lightspeed_gs" },
        { "x", "gS", "<Plug>Lightspeed_gS" },
        { "o", "gs", "<Plug>Lightspeed_gs" },
        { "o", "gS", "<Plug>Lightspeed_gS" },
    }
    for _, m in ipairs(default_keymaps) do
        vim.keymap.set(m[1], m[2], m[3], { noremap = true, silent = true })
    end
end
function config.lightspeed()
    require("lightspeed").setup({
        ignore_case = false,
        exit_after_idle_msecs = { unlabeled = 1000, labeled = nil },

        --- s/x ---
        jump_to_unique_chars = { safety_timeout = 400 },
        match_only_the_start_of_same_char_seqs = true,
        force_beacons_into_match_width = false,
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

function config.surround()
    require("surround").setup({
        mappings_style = "sandwich",
        pairs = {
            nestable = {
                { "(", ")" },
                { "[", "]" },
                { "{", "}" },
                { "/", "/" },
                {
                    "*",
                    "*",
                },
            },
            linear = { { "'", "'" }, { "`", "`" }, { '"', '"' } },
        },
        prefix = "<F3>",
    })
end

function config.jetscape()
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
end

function config.text_case()
    require("textcase").setup({})
    vim.keymap.set("n", "gaw", "<cmd>lua require('textcase').current_word('to_snake_case')<cr>", { noremap = true })
    vim.keymap.set("n", "gaW", "<cmd>lua require('textcase').lsp_rename('to_snake_case')<cr>", { noremap = true })
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
        refresh_interval = 250,
        sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
        excluded_filetypes = { "NeogitStatus", "NeogitCommitMessage", "toggleterm" },
        bookmark_0 = {
            sign = "⚑",
            virt_text = "BookMark",
        },
        mappings = {},
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
        require("diaglist").open_buffer_diagnostics()
    end, { force = true })
end

return config
