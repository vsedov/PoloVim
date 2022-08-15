local config = {}
function config.norg()
    require("modules.editor.neorg")
end

function config.femaco()
    require("femaco").setup()
end

function config.zen()
    require("true-zen").setup({})
end

function config.acc_jk()
    require("accelerated-jk").setup({
        mode = "time_driven",
        enable_deceleration = false,
        acceleration_limit = 150,
        acceleration_table = { 7, 12, 17, 21, 24, 26, 28, 30 },
        deceleration_table = { { 150, 9999 } },
    })
    vim.keymap.set("n", "j", "<Plug>(accelerated_jk_gj)", { noremap = true })
    vim.keymap.set("n", "k", "<Plug>(accelerated_jk_gk)", { noremap = true })
end

function config.setup_yanky()
    local default_keymaps = {
        { "n", "y", "<Plug>(YankyYank)" },
        { "x", "y", "<Plug>(YankyYank)" },

        { "n", "p", "<Plug>(YankyPutAfter)" },
        { "n", "P", "<Plug>(YankyPutBefore)" },

        { "x", "p", "<Plug>(YankyPutAfter)" },
        { "x", "P", "<Plug>(YankyPutBefore)" },

        { "n", "gp", "<Plug>(YankyGPutAfter)" },
        { "n", "gP", "<Plug>(YankyGPutBefore)" },

        { "x", "gp", "<Plug>(YankyGPutAfter)" },
        { "x", "gP", "<Plug>(YankyGPutBefore)" },

        { "n", "<Leader>n", "<Plug>(YankyCycleForward)" },
        { "n", "<Leader>N", "<Plug>(YankyCycleBackward)" },
    }
    for _, m in ipairs(default_keymaps) do
        vim.keymap.set(m[1], m[2], m[3], {})
    end
end

function config.config_yanky()
    local mapping = require("yanky.telescope.mapping")
    require("yanky").setup({
        ring = {
            history_length = 50,
            storage = "shada",
            sync_with_numbered_registers = true,
        },
        picker = {
            telescope = {
                mappings = {
                    default = mapping.put("p"),
                    i = {
                        ["<c-p>"] = mapping.put("p"),
                        ["<c-k>"] = mapping.put("P"),
                        ["<c-x>"] = mapping.delete(),
                    },
                    n = {
                        p = mapping.put("p"),
                        P = mapping.put("P"),
                        d = mapping.delete(),
                    },
                },
            },
        },
        system_clipboard = {
            sync_with_ring = true,
        },
        highlight = {
            on_put = true,
            on_yank = true,
            timer = 500,
        },
        preserve_cursor_position = {
            enabled = true,
        },
    })
    require("telescope").load_extension("yank_history")
    vim.keymap.set("n", "<leader>yu", "<cmd>Telescope yank_history<cr>", {})
end

function config.comment()
    vim.cmd([[packadd nvim-ts-context-commentstring ]])
    require("Comment").setup({
        padding = true,
        sticky = true,
        ignore = nil,
        mappings = {
            basic = true,
            extra = true,
            extended = true,
        },
        pre_hook = function(ctx)
            local U = require("Comment.utils")

            local location = nil
            if ctx.ctype == U.ctype.block then
                location = require("ts_context_commentstring.utils").get_cursor_location()
            elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
                location = require("ts_context_commentstring.utils").get_visual_start_location()
            end

            return require("ts_context_commentstring.internal").calculate_commentstring({
                key = ctx.ctype == U.ctype.line and "__default" or "__multiline",
                location = location,
            })
        end,
        post_hook = function(ctx)
            -- lprint(ctx)
            if ctx.range.scol == -1 then
                -- do something with the current line
            else
                -- print(vim.inspect(ctx), ctx.range.srow, ctx.range.erow, ctx.range.scol, ctx.range.ecol)
                if ctx.range.ecol > 400 then
                    ctx.range.ecol = 1
                end
                if ctx.cmotion > 1 then
                    -- 322 324 0 2147483647
                    vim.fn.setpos("'<", { 0, ctx.range.srow, ctx.range.scol })
                    vim.fn.setpos("'>", { 0, ctx.range.erow, ctx.range.ecol })
                    vim.cmd([[exe "norm! gv"]])
                end
            end
        end,
    })
end

function config.comment_box()
    require("comment-box").setup({
        box_width = 70, -- width of the boxex
        borders = { -- symbols used to draw a box
            top = "─",
            bottom = "─",
            left = "│",
            right = "│",
            top_left = "╭",
            top_right = "╮",
            bottom_left = "╰",
            bottom_right = "╯",
        },
        line_width = 70, -- width of the lines
        line = { -- symbols used to draw a line
            line = "─",
            line_start = "─",
            line_end = "─",
        },
        outer_blank_lines = false, -- insert a blank line above and below the box
        inner_blank_lines = false, -- insert a blank line above and below the text
        line_blank_line_above = false, -- insert a blank line above the line
        line_blank_line_below = false, -- insert a blank line below the line
    })

    local keymap = vim.keymap.set
    local cb = require("comment-box")

    keymap({ "n", "v" }, "<Leader>cb", cb.lbox, {})
    keymap({ "n", "v" }, "<Leader>cc", cb.cbox, {})

    keymap("n", "<Leader>cl", cb.line, {})
    keymap("i", "<M-p>", cb.line, {})
end

function config.winshift()
    require("winshift").setup({
        highlight_moving_win = true, -- Highlight the window being moved
        focused_hl_group = "Visual", -- The highlight group used for the moving window
        moving_win_options = {
            wrap = false,
            cursorline = false,
            cursorcolumn = false,
            colorcolumn = "",
        },
        window_picker_chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
        window_picker_ignore = {
            -- This table allows you to indicate to the window picker that a window
            -- should be ignored if its buffer matches any of the following criteria.
            filetype = { -- List of ignored file types
                "NvimTree",
            },
            buftype = { -- List of ignored buftypes
                "terminal",
                "quickfix",
            },
            bufname = { -- List of regex patterns matching ignored buffer names
                [[.*foo/bar/baz\.qux]],
            },
        },
    })
end

function config.neoscroll()
    require("cinnamon").setup({
        extra_keymaps = true,
        scroll_limit = 150,
        always_scroll = true,
    })
    local map = vim.keymap.set

    map({ "n", "x" }, "gg", "<Cmd>lua Scroll('gg', 0, 0, 1)<CR>")
    map({ "n", "x" }, "G", "<Cmd>lua Scroll('G', 0, 1, 1)<CR>")

    map({ "n", "x" }, "<ScrollWheelUp>", "<Cmd>lua Scroll('<ScrollWheelUp>')<CR>")
    map({ "n", "x" }, "<ScrollWheelDown>", "<Cmd>lua Scroll('<ScrollWheelDown>')<CR>")
end

function config.discord()
    --i don\'t want to deal with vscode , The One True Text Editor
    -- Editor For The True Traditionalist
    require("presence"):setup({
        -- General options
        auto_update = true, -- Update activity based on autocmd events (if `false`, map or manually execute `:lua package.loaded.presence:update()`)
        neovim_image_text = "Editor For The True Traditionalist", -- Text displayed when hovered over the Neovim image
        main_image = "file", -- Main image display (either "neovim" or "file")
        client_id = "793271441293967371", -- Use your own Discord application client id (not recommended)
        log_level = nil, -- Log messages at or above this level (one of the following: "debug", "info", "warn", "error")
        debounce_timeout = 10, -- Number of seconds to debounce events (or calls to `:lua package.loaded.presence:update(<filename>, true)`)
        enable_line_number = true, -- Displays the current line number instead of the current project
        blacklist = {}, -- A list of strings or Lua patterns that disable Rich Presence if the current file name, path, or workspace matches
        buttons = true, -- Configure Rich Presence button(s), either a boolean to enable/disable, a static table (`{{ label = "<label>", url = "<url>" }, ...}`, or a function(buffer: string, repo_url: string|nil): table)
        file_assets = {}, -- Custom file asset definitions keyed by file names and extensions (see default config at `lua/presence/file_assets.lua` for reference)

        -- Rich Presence text options
        editing_text = "Editing %s", -- Format string rendered when an editable file is loaded in the buffer (either string or function(filename: string): string)
        file_explorer_text = "Browsing %s", -- Format string rendered when browsing a file explorer (either string or function(file_explorer_name: string): string)
        git_commit_text = "Committing changes", -- Format string rendered when committing changes in git (either string or function(filename: string): string)
        plugin_manager_text = "Managing plugins", -- Format string rendered when managing plugins (either string or function(plugin_manager_name: string): string)
        reading_text = "Reading %s", -- Format string rendered when a read-only or unmodifiable file is loaded in the buffer (either string or function(filename: string): string)
        workspace_text = "Working on %s", -- Format string rendered when in a git repository (either string or function(project_name: string|nil, filename: string): string)
        line_number_text = "Line %s out of %s", -- Format string rendered when `enable_line_number` is set to true (either string or function(line_number: number, line_count: number): string)
    })
end

function config.dial()
    local dial = require("dial.map")
    local augend = require("dial.augend")
    require("dial.config").augends:register_group({
        -- default augends used when no group name is specified
        default = {
            augend.integer.alias.decimal, -- nonnegative decimal number (0, 1, 2, 3, ...)
            augend.integer.alias.hex, -- nonnegative hex number  (0x01, 0x1a1f, etc.)
            augend.date.alias["%Y/%m/%d"], -- date (2022/02/19, etc.)
        },

        -- augends used when group with name `mygroup` is specified
        mygroup = {
            augend.integer.alias.decimal,
            augend.constant.alias.bool, -- boolean value (true <-> false)
            augend.date.alias["%m/%d/%Y"], -- date (02/19/2022, etc.)
        },
    })
    local map = vim.keymap.set
    map("n", "<C-a>", dial.inc_normal(), { remap = false })
    map("n", "<C-x>", dial.dec_normal(), { remap = false })
    map("v", "<C-a>", dial.inc_visual(), { remap = false })
    map("v", "<C-x>", dial.dec_visual(), { remap = false })
    map("v", "g<C-a>", dial.inc_gvisual(), { remap = false })
    map("v", "g<C-x>", dial.dec_gvisual(), { remap = false })
end

function config.hlargs()
    require("utils.ui.highlights").plugin("hlargs", {
        { Hlargs = { fg = "#ef9062", italic = true, bold = false } },
    })
    require("hlargs").setup({
        color = "#ef9062",
        highlight = {},
        excluded_filetypes = {},
        paint_arg_declarations = true,
        paint_arg_usages = true,
        hl_priority = 10000,
        excluded_argnames = {
            declarations = {},
            usages = {
                python = { "self", "cls" },
                lua = { "self" },
            },
        },
        performance = {
            parse_delay = 1,
            slow_parse_delay = 50,
            max_iterations = 400,
            max_concurrent_partial_parses = 30,
            debounce = {
                partial_parse = 3,
                partial_insert_mode = 100,
                total_parse = 700,
                slow_parse = 5000,
            },
        },
    })
end

function config.hydra()
    require("modules.editor.hydra")
end

function config.substitute()
    vim.cmd([[packadd yanky.nvim]])
    require("substitute").setup({
        yank_substituted_text = true,
        on_substitute = function(event)
            require("yanky").init_ring("p", event.register, event.count, event.vmode:match("[vV�]"))
        end,
        motion1 = true,
        motion2 = true,
    })
    vim.keymap.set("n", "LL", "<cmd>lua require('substitute').operator()<cr>", { noremap = true })
    vim.keymap.set("n", "Ll", "<cmd>lua require('substitute').line()<cr>", { noremap = true })
    vim.keymap.set("n", "<leader>L", "<cmd>lua require('substitute').eol()<cr>", { noremap = true })
    vim.keymap.set("x", "L", "<cmd>lua require('substitute').visual()<cr>", { noremap = true })

    vim.keymap.set("n", "<leader>l", "<cmd>lua require('substitute.range').operator()<cr>", { noremap = true })
    vim.keymap.set("x", "<leader>l", "<cmd>lua require('substitute.range').visual()<cr>", { noremap = true })
    vim.keymap.set("n", "<leader>lr", "<cmd>lua require('substitute.range').word()<cr>", { noremap = true })

    vim.keymap.set("n", "Lx", "<cmd>lua require('substitute.exchange').operator()<cr>", { noremap = true })
    vim.keymap.set("n", "Lxx", "<cmd>lua require('substitute.exchange').line()<cr>", { noremap = true })
    vim.keymap.set("x", "Lx", "<cmd>lua require('substitute.exchange').visual()<cr>", { noremap = true })
    vim.keymap.set("n", "Lxc", "<cmd>lua require('substitute.exchange').cancel()<cr>", { noremap = true })
end

function config.cool_sub()
    require("cool-substitute").setup({
        setup_keybindings = true,
        mappings = {
            start = "gm", -- Mark word / region
            start_and_edit = "gM", -- Mark word / region and also edit
            start_and_edit_word = "g!M", -- Mark word / region and also edit.  Edit only full word.
            start_word = "g!m", -- Mark word / region. Edit only full word
            apply_substitute_and_next = "\\m", -- Start substitution / Go to next substitution
            apply_substitute_and_prev = "\\p", -- same as M but backwards
            apply_substitute_all = "\\\\a", -- Substitute all
            force_terminate_substitute = "g!!",
        },
        -- reg_char = "o", -- letter to save macro (Dont use number or uppercase here)
        -- mark_char = "t", -- mark the position at start of macro
    })
end

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

function config.bbye()
    vim.keymap.set("n", "_q", "<Cmd>Bwipeout<CR>", { silent = true })
end
function config.matchup()
    require("nvim-treesitter.configs").setup({
        matchup = {
            enable = true, -- mandatory, false will disable the whole extension
            disable = { "c", "ruby" }, -- optional, list of language that will be disabled
            -- [options]
        },
    })

    vim.g.matchup_enabled = 1
    vim.g.matchup_surround_enabled = 1
    -- vim.g.matchup_transmute_enabled = 1
    vim.g.matchup_matchparen_deferred = 1
    vim.g.matchup_matchparen_offscreen = { method = "popup" }
    vim.keymap.set("n", "<leader><leader><leader>", "<cmd>MatchupWhereAmI?<cr>", { noremap = true })
end

function config.readline()
    local readline = require("readline")
    local map = vim.keymap.set
    map("!", "<M-f>", readline.forward_word)
    map("!", "<M-b>", readline.backward_word)
    map("!", "<C-a>", readline.beginning_of_line)
    map("!", "<C-e>", readline.end_of_line)
    map("!", "<M-d>", readline.kill_word)
    map("!", "<M-BS>", readline.backward_kill_word)
    map("!", "<C-w>", readline.unix_word_rubout)
    map("!", "<C-k>", readline.kill_line)
    map("!", "<C-u>", readline.backward_kill_line)
end

function config.asterisk_setup()
    vim.g["asterisk#keeppos"] = 1
    local default_keymaps = {
        { "n", "*", "<Plug>(asterisk-*)" },
        { "n", "#", "<Plug>(asterisk-#)" },
        { "n", "g*", "<Plug>(asterisk-g*)" },
        { "n", "g#", "<Plug>(asterisk-g#)" },
        { "n", "z*", "<Plug>(asterisk-z*)" },
        { "n", "gz*", "<Plug>(asterisk-gz*)" },
        { "n", "z#", "<Plug>(asterisk-z#)" },
        { "n", "gz#", "<Plug>(asterisk-gz#)" },
    }
    for _, m in ipairs(default_keymaps) do
        vim.keymap.set(m[1], m[2], m[3], {})
    end
end

return config
