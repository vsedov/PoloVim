local config = {}

function config.autopairs()
    local has_autopairs, autopairs = pcall(require, "nvim-autopairs")
    if not has_autopairs then
        print("autopairs not loaded")

        local loader = require("packer").loader
        loader("nvim-autopairs")
        has_autopairs, autopairs = pcall(require, "nvim-autopairs")
        if not has_autopairs then
            print("autopairs not installed")
            return
        end
    end
    local npairs = require("nvim-autopairs")
    local Rule = require("nvim-autopairs.rule")
    local cond = require("nvim-autopairs.conds")

    npairs.setup({
        enable_moveright = true,
        disable_in_macro = false,
        enable_afterquote = true,
        map_bs = true,
        map_c_w = true,
        -- disable_in_visualblock = false,

        disable_filetype = { "TelescopePrompt", "guihua", "guihua_rust", "clap_input" },
        autopairs = { enable = true },
        ignored_next_char = string.gsub([[ [%w%%%'%[%"%.] ]], "%s+", ""), -- "[%w%.+-"']",
        -- enable_check_bracket_line = true, -- Messes with abbrivaitions
        html_break_line_filetype = { "html", "vue", "typescriptreact", "svelte", "javascriptreact" },
        check_ts = false,
        ts_config = {
            lua = { "string", "source" },
            javascript = { "string", "template_string" },
            java = false,
        },
        fast_wrap = {
            map = "<c-c>",
            chars = { "{", "[", "(", '"', "'", "`" },
            pattern = string.gsub([[ [%'%"%`%+%)%>%]%)%}%,%s] ]], "%s+", ""),
            end_key = "$",
            keys = "qwertyuiopzxcvbnmasdfghjkl",
            check_comma = true,
            hightlight = "Search",
        },
    })

    -- local ts_conds = require("nvim-autopairs.ts-conds")
    -- -- you need setup cmp first put this after cmp.setup()
    -- npairs.add_rules({
    --     Rule("%", "%", "lua"):with_pair(ts_conds.is_ts_node({ "string", "comment" })),
    --     Rule("$", "$", "lua"):with_pair(ts_conds.is_not_ts_node({ "function" })),
    -- })

    -- npairs.add_rules({
    --     Rule("=", "")
    --         :with_pair(cond.not_inside_quote())
    --         :with_pair(function(opts)
    --             local last_char = opts.line:sub(opts.col - 1, opts.col - 1)
    --             if last_char:match("[%w%=%s]") then
    --                 return true
    --             end
    --             return false
    --         end)
    --         :replace_endpair(function(opts)
    --             local prev_2char = opts.line:sub(opts.col - 2, opts.col - 1)
    --             local next_char = opts.line:sub(opts.col, opts.col)
    --             next_char = next_char == " " and "" or " "
    --             if prev_2char:match("%w$") then
    --                 return "<bs> =" .. next_char
    --             end
    --             if prev_2char:match("%=$") then
    --                 return next_char
    --             end
    --             if prev_2char:match("=") then
    --                 return "<bs><bs>=" .. next_char
    --             end
    --             return ""
    --         end)
    --         :set_end_pair_length(0)
    --         :with_move(cond.none())
    --         :with_del(cond.none()),

    --     Rule("( ", " )")
    --         :with_pair(function()
    --             return false
    --         end)
    --         :with_move(function(opts)
    --             return opts.prev_char:match(".%)") ~= nil
    --         end)
    --         :use_key(")"),
    --     Rule("{ ", " }")
    --         :with_pair(function()
    --             return false
    --         end)
    --         :with_move(function(opts)
    --             return opts.prev_char:match(".%}") ~= nil
    --         end)
    --         :use_key("}"),
    --     Rule("[ ", " ]")
    --         :with_pair(function()
    --             return false
    --         end)
    --         :with_move(function(opts)
    --             return opts.prev_char:match(".%]") ~= nil
    --         end)
    --         :use_key("]"),
    -- })

    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    if load_coq() then
        local remap = vim.api.nvim_set_keymap

        npairs.setup({ map_bs = false })

        vim.g.coq_settings = { keymap = { recommended = false } }

        -- these mappings are coq recommended mappings unrelated to nvim-autopairs
        remap("i", "<esc>", [[pumvisible() ? "<c-e><esc>" : "<esc>"]], { expr = true, noremap = true })
        remap("i", "<c-c>", [[pumvisible() ? "<c-e><c-c>" : "<c-c>"]], { expr = true, noremap = true })
        remap("i", "<tab>", [[pumvisible() ? "<c-n>" : "<tab>"]], { expr = true, noremap = true })
        remap("i", "<s-tab>", [[pumvisible() ? "<c-p>" : "<bs>"]], { expr = true, noremap = true })

        -- skip it, if you use another global object
        _G.MUtils = {}

        MUtils.CR = function()
            if vim.fn.pumvisible() ~= 0 then
                if vim.fn.complete_info({ "selected" }).selected ~= -1 then
                    return npairs.esc("<c-y>")
                else
                    -- you can change <c-g><c-g> to <c-e> if you don't use other i_CTRL-X modes
                    return npairs.esc("<c-g><c-g>") .. npairs.autopairs_cr()
                end
            else
                return npairs.autopairs_cr()
            end
        end
        remap("i", "<cr>", "v:lua.MUtils.CR()", { expr = true, noremap = true })

        MUtils.BS = function()
            if vim.fn.pumvisible() ~= 0 and vim.fn.complete_info({ "mode" }).mode == "eval" then
                return npairs.esc("<c-e>") .. npairs.autopairs_bs()
            else
                return npairs.autopairs_bs()
            end
        end
        remap("i", "<bs>", "v:lua.MUtils.BS()", { expr = true, noremap = true })
    end

    -- skip it, if you use another global object
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

function config.comment()
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

function config.vim_cursorwod()
    vim.api.nvim_command("augroup user_plugin_cursorword")
    vim.api.nvim_command("autocmd!")
    vim.api.nvim_command("autocmd FileType NvimTree let b:cursorword = 0")
    vim.api.nvim_command("autocmd WinEnter * if &diff || &pvw | let b:cursorword = 0 | endif")
    vim.api.nvim_command("autocmd InsertEnter * let b:cursorword = 0")
    vim.api.nvim_command("autocmd InsertLeave * let b:cursorword = 1")
    vim.api.nvim_command("augroup END")
end

function config.hlslens()
    -- body
    -- vim.cmd([[packadd nvim-hlslens]])
    vim.cmd(
        [[noremap <silent> n <Cmd>execute('normal! ' . v:count1 . 'n')<CR> <Cmd>lua require('hlslens').start()<CR>]]
    )
    vim.cmd(
        [[noremap <silent> N <Cmd>execute('normal! ' . v:count1 . 'N')<CR> <Cmd>lua require('hlslens').start()<CR>]]
    )
    vim.cmd([[noremap * *<Cmd>lua require('hlslens').start()<CR>]])
    vim.cmd([[noremap # #<Cmd>lua require('hlslens').start()<CR>]])
    vim.cmd([[noremap g* g*<Cmd>lua require('hlslens').start()<CR>]])
    vim.cmd([[noremap g# g#<Cmd>lua require('hlslens').start()<CR>]])
    vim.cmd([[nnoremap <silent> <leader>l :noh<CR>]])
    require("hlslens").setup({
        calm_down = true,
        -- nearest_only = true,
        nearest_float_when = "always",
    })
    vim.cmd([[aug VMlens]])
    vim.cmd([[au!]])
    vim.cmd([[au User visual_multi_start lua require('utils.vmlens').start()]])
    vim.cmd([[au User visual_multi_exit lua require('utils.vmlens').exit()]])
    vim.cmd([[aug END]])
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

function config.twilight()
    require("twilight").setup({
        dimming = {
            alpha = 0.25,
            color = { "Normal", "#ffffff" },
            inactive = false,
        },
        context = 10,
        treesitter = true,
        expand = {
            "function",
            "method",
            "table",
            "if_statement",
        },
    })
end

function config.zen()
    require("zen-mode").setup({
        window = {
            backdrop = 0.3, -- shade the backdrop of the Zen window. Set to 1 to keep the same as Normal
            width = 0.85, -- width of the Zen window
            height = 1, -- height of the Zen window
            options = {
                -- signcolumn = "no", -- disable signcolumn
                -- number = false, -- disable number column
                -- relativenumber = false, -- disable relative numbers
                -- cursorline = false, -- disable cursorline
                cursorcolumn = false, -- disable cursor column
                foldcolumn = "0", -- disable fold column
                list = false, -- disable whitespace characters
            },
        },
        plugins = {
            options = {
                enabled = true,
                ruler = false, -- disables the ruler text in the cmd line area
                showcmd = false, -- disables the command in the last line of the screen
            },
            twilight = { enabled = true }, -- enable to start Twilight when zen mode opens
            gitsigns = { enabled = true }, -- disables git signs
            tmux = { enabled = false }, -- disables the tmux statusline
            kitty = {
                enabled = true,
            },
        },
        -- callback where you can add custom code when the Zen window opens
        on_open = function(win)
            vim.cmd([[PackerLoad twilight.nvim]])
        end,
        -- callback where you can add custom code when the Zen window closes
        on_close = function() end,
    })
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

--- to be updated  - better way of doing this im sure .
function config.side_bar()
    local sidebar = require("sidebar-nvim")
    local opts = {
        -- i dont want this
        open = false,
        disable_default_keybindings = true,
        side = "left",
        initial_width = 30,
        update_interval = 900,
        sections = {
            "datetime",
            "git",
            "diagnostics",
            "symbols",
            "todos",
        },
        section_separator = "─────",
        bindings = {
            ["q"] = function()
                require("sidebar-nvim").close()
            end,

            ["<C-q>"] = function()
                require("sidebar-nvim").close()
            end,
        },
        datetime = { format = "%a %b %d, %H:%M", clocks = { { name = "こんにちは" } } },
        todos = { ignored_paths = { "~" } },
        disable_closing_prompt = false,
        dap = {
            breakpoints = {
                icon = "",
            },
        },
    }
    sidebar.setup(opts)

    -- vim.cmd.("link SidebarNvimLspDiagnosticsTotalNumber Normal")
end

function config.dial_setup()
    vim.keymap.set({ "n", "x" }, "<C-a>", "<Plug>(dial-increment)")
    vim.keymap.set({ "n", "x" }, "<C-x>", "<Plug>(dial-decrement)")
    vim.keymap.set("x", "<C-a>", "<Plug>(dial-increment-additional)")
    vim.keymap.set("x", "<C-x>", "<Plug>(dial-decrement-additional)")
end

return config
