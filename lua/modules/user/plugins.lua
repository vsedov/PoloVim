local conf = require("modules.user.config")
local user = require("core.pack").package

-- True emotional Support
user({ "rtakasuke/vim-neko", cmd = "Neko", opt = true })

-- TODO(vsedov) (00:11:22 - 13/08/22): Temp plugin
user({
    "RRethy/vim-illuminate",
    event = "BufEnter",
    config = function()
        -- default configuration
        require("illuminate").configure({
            -- providers: provider used to get references in the buffer, ordered by priority
            providers = {
                "lsp",
                "treesitter",
                "regex",
            },
            -- delay: delay in milliseconds
            delay = 100,
            -- filetype_overrides: filetype specific overrides.
            -- The keys are strings to represent the filetype while the values are tables that
            -- supports the same keys passed to .configure except for filetypes_denylist and filetypes_allowlist
            filetype_overrides = {},
            -- filetypes_denylist: filetypes to not illuminate, this overrides filetypes_allowlist
            filetypes_denylist = {
                "dirvish",
                "fugitive",
            },
            -- filetypes_allowlist: filetypes to illuminate, this is overriden by filetypes_denylist
            filetypes_allowlist = {},
            -- modes_denylist: modes to not illuminate, this overrides modes_allowlist
            modes_denylist = {},
            -- modes_allowlist: modes to illuminate, this is overriden by modes_denylist
            modes_allowlist = {},
            -- providers_regex_syntax_denylist: syntax to not illuminate, this overrides providers_regex_syntax_allowlist
            -- Only applies to the 'regex' provider
            -- Use :echom synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
            providers_regex_syntax_denylist = {},
            -- providers_regex_syntax_allowlist: syntax to illuminate, this is overriden by providers_regex_syntax_denylist
            -- Only applies to the 'regex' provider
            -- Use :echom synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
            providers_regex_syntax_allowlist = {},
            -- under_cursor: whether or not to illuminate under the cursor
            under_cursor = true,
        })
    end,
})

-- TODO: (vsedov) (09:02:43 - 29/08/22): https://github.com/luk400/vim-jukit set this thing up,
-- looks very nice to have .

user({
    "luk400/vim-jukit",
    opt = true,
    config = function()
        vim.g.jukit_terminal = "kitty"
        vim.cmd([[
        let g:jukit_layout = {
            \'split': 'horizontal',
            \'p1': 0.6, 
            \'val': [
                \'file_content',
                \{
                    \'split': 'vertical',
                    \'p1': 0.6,
                    \'val': ['output', 'output_history']
                \}
            \]
        \}
        fun! DFColumns()
            let visual_selection = jukit#util#get_visual_selection()
            let cmd = visual_selection . '.columns'
            call jukit#send#send_to_split(cmd)
        endfun
        vnoremap C :call DFColumns()<cr>

        fun! PythonHelp()
            let visual_selection = jukit#util#get_visual_selection()
            let cmd = 'help(' . visual_selection . ')'
            call jukit#send#send_to_split(cmd)
        endfun
        vnoremap H :call PythonHelp()<cr>
        ]])
    end,
})

-- I elegit have no clue what thisis .
user({
    "delphinus/cellwidths.nvim",
    event = "BufEnter",
    config = function()
        require("cellwidths").setup({
            name = "default",
        })
    end,
})

-- Default:~
--     normal = {
--       ["<cr>"] = "open_data",
--       ["<s-cr>"] = "open_data_index",
--       ["<tab>"] = "toggle_node",
--       ["<s-tab>"] = "toggle_node",
--       ["/"] = "select_path",
--       ["$"] = "change_icon_menu",
--       c = "add_inside_end_index",
--       I = "add_inside_start",
--       i = "add_inside_end",
--       l = "copy_node_link",
--       L = "copy_node_link_index",
--       d = "delete",
--       O = "add_above",
--       o = "add_below",
--       q = "quit",
--       r = "rename",
--       R = "change_icon",
--       u = "make_url",
--       x = "select",
--     }

--     selection = {
--       ["<cr>"] = "open_data",
--       ["<s-tab>"] = "toggle_node",
--       ["/"] = "select_path",
--       I = "move_inside_start",
--       i = "move_inside_end",
--       O = "move_above",
--       o = "move_below",
--       q = "quit",
--       x = "select",
--     }

user({
    "phaazon/mind.nvim",
    cmd = { "MindOpenMain", "MindOpenProject", "MindReloadState" },
    config = function()
        require("mind").setup()
    end,
})

user({
    "jouderianjr/pomodoro.nvim",
    keys = {
        "<leader>Pf",
        "<leader>Pb",
        "<leader>Plb",
        "<leader>Pp",
        "<leader>Pr",
    },
    cmd = {
        "PomodoroStartFocus",
        "PomodoroStartBreak",
        "PomodoroStartLongBreak",
        "PomodoroPause",
        "PomodoroResume",
    },
})
