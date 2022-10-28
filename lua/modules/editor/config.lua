local config = {}

function config.zen()
    local truezen = require("true-zen")
    truezen.setup({})
    local keymap = vim.keymap

    keymap.set("n", ";zn", function()
        local first = 0
        local last = vim.api.nvim_buf_line_count(0)
        truezen.narrow(first, last)
    end, { noremap = true })
    keymap.set("v", ";zn", function()
        local first = vim.fn.line("v")
        local last = vim.fn.line(".")
        truezen.narrow(first, last)
    end, { noremap = true })
    keymap.set("n", ";zf", truezen.focus, { noremap = true })
    keymap.set("n", ";zm", truezen.minimalist, { noremap = true })
    keymap.set("n", ";za", truezen.ataraxis, { noremap = true })
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

function config.comment()
    require("Comment").setup({
        padding = true,
        sticky = true,
        ignore = nil,
        toggler = {
            line = "gcc",
            block = "gbc",
        },
        opleader = {
            line = "gc",
            block = "gb",
        },
        extra = {
            above = "gcO",
            below = "gco",
            eol = "gcA",
        },
        mappings = {
            basic = true,
            extra = true,
        },
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

function config.discord()
    --i don\'t want to deal with vscode , The One True Text Editor
    -- Editor For The True Traditionalist
    require("presence"):setup({
        -- General options
        auto_update = true, -- Update activity based on autocmd events (if false, map or manually execute :lua package.loaded.presence:update`)
        neovim_image_text = "Editor For The True Traditionalist", -- Text displayed when hovered over the Neovim image
        main_image = "file", -- Main image display (either "neovim" or "file")
        client_id = "793271441293967371", -- Use your own Discord application client id (not recommended)
        log_level = nil, -- Log messages at or above this level (one of the following: "debug", "info", "warn", "error")
        debounce_timeout = 10, -- Number of seconds to debounce events (or calls to :lua package.loaded.presence:update(<filename>, true))
        enable_line_number = true, -- Displays the current line number instead of the current project
        blacklist = {}, -- A list of strings or Lua patterns that disable Rich Presence if the current file name, path, or workspace matches
        buttons = true, -- Configure Rich Presence button(s), either a boolean to enable/disable, a static table ({{ label = "<label>", url = "<url>" }, ...}, or a function(buffer: string, repo_url: string|nil): table)
        file_assets = {}, -- Custom file asset definitions keyed by file names and extensions (see default config at lua/presence/file_assets.lua for reference)

        -- Rich Presence text options
        editing_text = "Editing %s", -- Format string rendered when an editable file is loaded in the buffer (either string or function(filename: string): string)
        file_explorer_text = "Browsing %s", -- Format string rendered when browsing a file explorer (either string or function(file_explorer_name: string): string)
        git_commit_text = "Committing changes", -- Format string rendered when committing changes in git (either string or function(filename: string): string)
        plugin_manager_text = "Managing plugins", -- Format string rendered when managing plugins (either string or function(plugin_manager_name: string): string)
        reading_text = "Reading %s", -- Format string rendered when a read-only or unmodifiable file is loaded in the buffer (either string or function(filename: string): string)
        workspace_text = "Working on %s", -- Format string rendered when in a git repository (either string or function(project_name: string|nil, filename: string): string)
        line_number_text = "Line %s out of %s", -- Format string rendered when enable_line_number is set to true (either string or function(line_number: number, line_count: number): string)
    })
end

function config.dial()
    local dial = require("dial.map")
    local augend = require("dial.augend")
    require("dial.config").augends:register_group({
        -- default augends used when no group name is specified
        default = {
            augend.constant.new({
                elements = { "and", "or" },
                word = true, -- if false, "sand" is incremented into "sor", "doctor" into "doctand", etc.
                cyclic = true, -- "or" is incremented into "and".
            }),
            augend.constant.new({
                elements = { "&&", "||" },
                word = false,
                cyclic = true,
            }),
            augend.constant.new({
                elements = { "True", "False" },
                word = true,
                cyclic = true,
            }),
            augend.date.alias["%Y/%m/%d"],
            augend.date.alias["%m/%d/%Y"],
            augend.date.alias["%d/%m/%Y"],
            augend.date.alias["%m/%d/%y"],
            augend.date.alias["%d/%m/%y"],
            augend.date.alias["%m/%d"],
            augend.date.alias["%-m/%-d"],
            augend.date.alias["%Y-%m-%d"],
            augend.date.alias["%H:%M:%S"],
            augend.date.alias["%H:%M"],
            augend.constant.alias.bool,
            augend.constant.alias.alpha,
            augend.constant.alias.Alpha,
            augend.paren.alias.quote,
            augend.paren.alias.brackets,
            augend.paren.alias.lua_str_literal,
        },
        -- augends used when group with name mygroup is specified
        mygroup = {
            augend.constant.alias.ja_weekday,
            augend.constant.alias.ja_weekday_full,
            augend.date.alias["%Y年%-m月%-d日"],
            augend.date.alias["%Y年%-m月%-d日(%ja)"],
        },
    })
    local map = vim.keymap.set
    map("n", "<C-a>", dial.inc_normal(), { remap = false })
    map("n", "<C-x>", dial.dec_normal(), { remap = false })
    map("v", "<C-a>", dial.inc_visual(), { remap = false })
    map("v", "<C-x>", dial.dec_visual(), { remap = false })
    map("v", "g<C-a>", dial.inc_gvisual(), { remap = false })
    map("v", "g<C-x>", dial.dec_gvisual(), { remap = false })
    map("n", "_a", require("dial.map").inc_normal("mygroup"), { noremap = true })
    map("n", "_x", require("dial.map").dec_normal("mygroup"), { noremap = true })
end

function config.hydra()
    require("modules.editor.hydra")
end

function config.venn()
    local function noremap(mode, lhs, rhs)
        vim.api.nvim_buf_set_keymap(0, mode, lhs, rhs, { noremap = true })
    end

    local function unmap(mode, lhs)
        vim.api.nvim_buf_del_keymap(0, mode, lhs)
    end

    -- venn.nvim: enable or disable keymappings
    local toggle = function()
        local venn_enabled = vim.inspect(vim.b.venn_enabled)
        if venn_enabled == "nil" then
            vim.b.venn_enabled = true

            vim.b.venn_ve = vim.api.nvim_get_option("virtualedit")
            vim.api.nvim_set_option("virtualedit", "all")

            noremap("n", "<Down>", "<C-v>j:VBox<CR>")
            noremap("n", "<Up>", "<C-v>k:VBox<CR>")
            noremap("n", "<Left>", "<C-v>h:VBox<CR>")
            noremap("n", "<Right>", "<C-v>l:VBox<CR>")
            noremap("v", "<CR>", ":VBox<CR>")

            print("Enabled Venn mode. Press <CR> in visual mode to create box.")
        else
            vim.api.nvim_set_option("virtualedit", vim.b.venn_ve)

            unmap("n", "<Down>")
            unmap("n", "<Up>")
            unmap("n", "<Left>")
            unmap("n", "<Right>")
            unmap("v", "<CR>")

            vim.b.venn_enabled = nil

            print("Disabled Venn mode.")
        end
    end

    lambda.command("Venn", function()
        vim.g.venn_ve = nil
        vim.g.venn_enabled = false
        toggle()
    end, { bang = true })
end

function config.readline()
    local readline = require("readline")
    local map = vim.keymap.set
    map("!", "<M-f>", readline.forward_word)
    map("!", "<M-b>", readline.backward_word)
    map("!", "<M-d>", readline.kill_word)
    map("!", "<M-BS>", readline.backward_kill_word)

    map("!", "<C-a>", readline.beginning_of_line)
    map("!", "<C-e>", readline.end_of_line)

    map("!", "<C-w>", readline.unix_word_rubout)
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
function config.goyo()
    vim.g.goyo_width = "85%" -- Default width
    vim.g.goyo_height = "90%" -- Default height

    vim.cmd([[
        function! s:goyo_enter()
          " Hides mode from showing
          set noshowmode
          " Hides the sign column
          :set scl=no
          " Hides lualine
          lua require"lualine".hide()
          " ...
        endfunction
        function! s:goyo_leave()
          " Resets syntax highlighting (workaround for goyo bug)
          syntax off
          syntax on
          " Makes the signcolumn match the background colorscheme
          highlight clear SignColumn
          " Brings mode back
          set showmode
          " Shows lualine again
          lua require"lualine".hide({unhide=true})
          " ...
        endfunction
        autocmd! User GoyoEnter nested call <SID>goyo_enter()
        autocmd! User GoyoLeave nested call <SID>goyo_leave()
        ]])
end
function config.smart_q()
    vim.g.smartq_goyo_integration = 1
    vim.g.smartq_zenmode_integration = 0
end

return config
