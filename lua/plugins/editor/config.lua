local config = {}

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
end

function config.discord()
    --i don\'t want to deal with vscode , The One True Text Editor
    -- Editor For The True Traditionalist
    require("presence"):setup({
        auto_update = true, -- Update activity based on autocmd events (if `false`, map or manually execute `:lua package.loaded.presence:update()`)
        neovim_image_text = "The One True Text Editor", -- Text displayed when hovered over the Neovim image
        main_image = "file", -- Main image display (either "neovim" or "file")
        client_id = "793271441293967371", -- Use your own Discord application client id (not recommended)
        log_level = nil, -- Log messages at or above this level (one of the following: "debug", "info", "warn", "error")
        debounce_timeout = 10, -- Number of seconds to debounce events (or calls to `:lua package.loaded.presence:update(<filename>, true)`)
        enable_line_number = true, -- Displays the current line number instead of the current project
        -- blacklist = {"private"}, -- A list of strings or Lua patterns that disable Rich Presence if the current file name, path, or workspace matches
        blacklist = { "p_.*%.norg" },
        buttons = true, -- Configure Rich Presence button(s), either a boolean to enable/disable, a static table (`{{ label = "<label>", url = "<url>" }, ...}`, or a function(buffer: string, repo_url: string|nil): table)
        file_assets = {}, -- Custom file asset definitions keyed by file names and extensions (see default config at `lua/presence/file_assets.lua` for reference)
        show_time = true, -- Show the timer

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
    vim.keymap.set("n", "<C-a>", require("dial.map").inc_normal(), { noremap = true })
    vim.keymap.set("n", "<C-x>", require("dial.map").dec_normal(), { noremap = true })
    vim.keymap.set("n", "g<C-a>", require("dial.map").inc_gnormal(), { noremap = true })
    vim.keymap.set("n", "g<C-x>", require("dial.map").dec_gnormal(), { noremap = true })
    vim.keymap.set("v", "<C-a>", require("dial.map").inc_visual(), { noremap = true })
    vim.keymap.set("v", "<C-x>", require("dial.map").dec_visual(), { noremap = true })
    vim.keymap.set("v", "g<C-a>", require("dial.map").inc_gvisual(), { noremap = true })
    vim.keymap.set("v", "g<C-x>", require("dial.map").dec_gvisual(), { noremap = true })
end

function config.hydra()
    require("modules.editor.hydra")
end

function config.smart_q()
    vim.g.smartq_goyo_integration = 0
    vim.g.smartq_zenmode_integration = 0
end

return config
