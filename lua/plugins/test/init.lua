require("nvim-surround").setup({ move_cursor = true, keymaps = { visual = "s" } })

-- surr*ound_words             ysiw)           (surround_words)
-- *make strings               ys$"            "make strings"
-- [delete ar*ound me!]        ds]             delete around me!
-- remove <b>HTML t*ags</b>    dst             remove HTML tags
-- 'change quot*es'            cs'"            "change quotes"
-- <b>or tag* types</b>        csth1<CR>       <h1>or tag types</h1>
-- delete(functi*on calls)     dsf             function calls

local bind_list = {
    ["surround_word"] = {
        bind = "ysiw)",
        text = "(surround_words)",
    },

    ["*make strings"] = {
        bind = 'ys$"',
        text = '"make strings"',
    },

    ["[delete around me!]"] = {
        bind = "ds]",
        text = "delete around me!",
    },

    ["remove <b>HTML tags</b>"] = {
        bind = "dst",
        text = "remove HTML tags",
    },

    ["'change quotes'"] = {
        bind = "cs'\"",
        text = '"change quotes"',
    },

    ["<b>or tag types</b>"] = {
        bind = "csth1<CR>",
        text = "<h1>or tag types</h1>",
    },

    ["delete(function calls)"] = {
        bind = "dsf",
        text = "function calls",
    },
}

-- not make it like info, bind , text in one big text and print it using vim.notify
local table_string = ""
for k, v in pairs(bind_list) do
    table_string = table_string .. k .. " " .. v.bind .. " " .. v.text .. "\n"
end

lambda.command("SurroundBinds", function()
    vim.notify(table_string)
end)

vim.keymap.set({ "i", "n" }, "<C-y>", "<Plug>(dmacro-play-macro)")

vim.g.wordmotion_prefix = ","
vim.g.wordmotion_nomap = 1

require("spider").setup({
    skipInsignificantPunctuation = true,
    consistentOperatorPending = false, -- see "Consistent Operator-pending Mode" in the README
    subwordMovement = true,
    customPatterns = {}, -- check "Custom Movement Patterns" in the README for details
})

vim.keymap.set({ "n", "o", "x" }, "w", "<cmd>lua require('spider').motion('w')<CR>", { desc = "Spider-w" })
vim.keymap.set({ "n", "o", "x" }, "e", "<cmd>lua require('spider').motion('e')<CR>", { desc = "Spider-e" })
vim.keymap.set({ "n", "o", "x" }, "b", "<cmd>lua require('spider').motion('b')<CR>", { desc = "Spider-b" })
vim.keymap.set({ "n", "o", "x" }, "ge", "<cmd>lua require('spider').motion('ge')<CR>", { desc = "Spider-ge" })
vim.keymap.set("o", "w", "<cmd>lua require('spider').motion('w')<CR>")
vim.keymap.set("n", "cw", "ce", { remap = true })
vim.keymap.set("n", "cw", "<cmd>lua require('spider').motion('e')<CR>")

require("oil").setup({
    -- Oil will take over directory buffers (e.g. `vim .` or `:e src/`)
    -- Set to false if you want some other plugin (e.g. netrw) to open when you edit directories.
    default_file_explorer = true,
    -- Id is automatically added at the beginning, and name at the end
    -- See :help oil-columns
    columns = {
        "icon",
        "permissions",
        "size",
        "mtime",
    },
    -- Buffer-local options to use for oil buffers
    buf_options = {
        buflisted = false,
        bufhidden = "hide",
    },
    -- Window-local options to use for oil buffers
    win_options = {
        wrap = false,
        signcolumn = "no",
        cursorcolumn = false,
        foldcolumn = "0",
        spell = false,
        list = false,
        conceallevel = 3,
        concealcursor = "nvic",
    },
    -- Send deleted files to the trash instead of permanently deleting them (:help oil-trash)
    delete_to_trash = false,
    -- Skip the confirmation popup for simple operations (:help oil.skip_confirm_for_simple_edits)
    skip_confirm_for_simple_edits = false,
    -- Selecting a new/moved/renamed file or directory will prompt you to save changes first
    -- (:help prompt_save_on_select_new_entry)
    prompt_save_on_select_new_entry = true,
    -- Oil will automatically delete hidden buffers after this delay
    -- You can set the delay to false to disable cleanup entirely
    -- Note that the cleanup process only starts when none of the oil buffers are currently displayed
    cleanup_delay_ms = 2000,
    lsp_file_methods = {
        -- Time to wait for LSP file operations to complete before skipping
        timeout_ms = 1000,
        -- Set to true to autosave buffers that are updated with LSP willRenameFiles
        -- Set to "unmodified" to only save unmodified buffers
        autosave_changes = false,
    },
    -- Constrain the cursor to the editable parts of the oil buffer
    -- Set to `false` to disable, or "name" to keep it on the file names
    constrain_cursor = "editable",
    -- Set to true to watch the filesystem for changes and reload oil
    watch_for_changes = true,
    -- Keymaps in oil buffer. Can be any value that `vim.keymap.set` accepts OR a table of keymap
    -- options with a `callback` (e.g. { callback = function() ... end, desc = "", mode = "n" })
    -- Additionally, if it is a string that matches "actions.<name>",
    -- it will use the mapping at require("oil.actions").<name>
    -- Set to `false` to remove a keymap
    -- See :help oil-actions for a list of all available actions
    keymaps = {
        ["g?"] = "actions.show_help",
        ["<CR>"] = "actions.select",
        ["<C-v>"] = { "actions.select", opts = { vertical = true }, desc = "Open the entry in a vertical split" },
        ["<C-h>"] = { "actions.select", opts = { horizontal = true }, desc = "Open the entry in a horizontal split" },
        ["<C-t>"] = { "actions.select", opts = { tab = true }, desc = "Open the entry in new tab" },
        ["<C-p>"] = "actions.preview",
        ["<C-c>"] = "actions.close",
        ["<C-l>"] = "actions.refresh",
        ["-"] = "actions.parent",
        ["_"] = "actions.open_cwd",
        ["<br>"] = "actions.cd",
        ["~"] = { "actions.cd", opts = { scope = "tab" }, desc = ":tcd to the current oil directory" },
        ["gs"] = "actions.change_sort",
        ["gx"] = "actions.open_external",
        ["g."] = "actions.toggle_hidden",
        ["g\\"] = "actions.toggle_trash",
    },
    -- Set to false to disable all of the above keymaps
    use_default_keymaps = true,
    view_options = {
        -- Show files and directories that start with "."
        show_hidden = false,
        -- This function defines what is considered a "hidden" file
        is_hidden_file = function(name, bufnr)
            return vim.startswith(name, ".")
        end,
        -- This function defines what will never be shown, even when `show_hidden` is set
        is_always_hidden = function(name, bufnr)
            return false
        end,
        -- Sort file names in a more intuitive order for humans. Is less performant,
        -- so you may want to set to false if you work with large directories.
        natural_order = true,
        -- Sort file and directory names case insensitive
        case_insensitive = false,
        sort = {
            -- sort order can be "asc" or "desc"
            -- see :help oil-columns to see which columns are sortable
            { "type", "asc" },
            { "name", "asc" },
        },
    },
    -- Extra arguments to pass to SCP when moving/copying files over SSH
    extra_scp_args = {},
    -- EXPERIMENTAL support for performing file operations with git
    git = {
        -- Return true to automatically git add/mv/rm files
        add = function(path)
            return false
        end,
        mv = function(src_path, dest_path)
            return false
        end,
        rm = function(path)
            return false
        end,
    },
    -- Configuration for the floating window in oil.open_float
    float = {
        -- Padding around the floating window
        padding = 2,
        max_width = 0,
        max_height = 0,
        border = "rounded",
        win_options = {
            winblend = 0,
        },
        -- preview_split: Split direction: "auto", "left", "right", "above", "below".
        preview_split = "auto",
        -- This is the config that will be passed to nvim_open_win.
        -- Change values here to customize the layout
        override = function(conf)
            return conf
        end,
    },
    -- Configuration for the actions floating preview window
    preview = {
        -- Width dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
        -- min_width and max_width can be a single value or a list of mixed integer/float types.
        -- max_width = {100, 0.8} means "the lesser of 100 columns or 80% of total"
        max_width = 0.9,
        -- min_width = {40, 0.4} means "the greater of 40 columns or 40% of total"
        min_width = { 40, 0.4 },
        -- optionally define an integer/float for the exact width of the preview window
        width = nil,
        -- Height dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
        -- min_height and max_height can be a single value or a list of mixed integer/float types.
        -- max_height = {80, 0.9} means "the lesser of 80 columns or 90% of total"
        max_height = 0.9,
        -- min_height = {5, 0.1} means "the greater of 5 columns or 10% of total"
        min_height = { 5, 0.1 },
        -- optionally define an integer/float for the exact height of the preview window
        height = nil,
        border = "rounded",
        win_options = {
            winblend = 0,
        },
        -- Whether the preview window is automatically updated when the cursor is moved
        update_on_cursor_moved = true,
    },
    -- Configuration for the floating progress window
    progress = {
        max_width = 0.9,
        min_width = { 40, 0.4 },
        width = nil,
        max_height = { 10, 0.9 },
        min_height = { 5, 0.1 },
        height = nil,
        border = "rounded",
        minimized_border = "none",
        win_options = {
            winblend = 0,
        },
    },
    -- Configuration for the floating SSH window
    ssh = {
        border = "rounded",
    },
    -- Configuration for the floating keymaps help window
    keymaps_help = {
        border = "rounded",
    },
})

vim.keymap.set("n", "-", ":Oil<CR>", { desc = "Open parent directory" })

-- Might as well configure vimtex if it ever gets loaded
-- ──────────────────────────────────────────────────────────────────────
vim.g.vimtex_view_method = "zathura" -- sioyek
vim.g.vimtex_view_general_options = "@pdf"
vim.g.vimtex_compiler_method = "latexmk"
vim.g.vimtex_compiler_latexmk = {
    executable = "latexmk",
    out_dir = "output",
    options = {
        "--pdflatex",
        "--shell-escape",
        "--file-line-error",
        "--synctex=1",
        "--interaction=nonstopmode",
    },
}

vim.cmd([[
        let g:Tex_FormatDependency_dvi='dvi,ps,pdf'
        let g:Tex_DefaultTargetFormat='pdf'
    ]])
vim.g.vimtex_quickfix_mode = 0
vim.g.vimtex_view_automatic = 1

vim.cmd([[ " backwards search
            function! s:write_server_name() abort
            let nvim_server_file = "/tmp/vimtexserver.txt"
            call writefile([v:servername], nvim_server_file)
            endfunction

            augroup vimtex_common
            autocmd!
            autocmd FileType tex call s:write_server_name()
            augroup END
        ]])

vim.g.vimtex_syntax_enable = 1
-- vim.g.vimtex_syntax_conceal_disable = 0
vim.opt.conceallevel = 2
vim.g.vimtex_quickfix_ignore_filters = {
    "Command terminated with space",
    "LaTeX Font Warning: Font shape",
    "Package caption Warning: The option",
    [[Underfull \\hbox (badness [0-9]*) in]],
    "Package enumitem Warning: Negative labelwidth",
    [[Overfull \\hbox ([0-9]*.[0-9]*pt too wide) in]],
    [[Package caption Warning: Unused \\captionsetup]],
    "Package typearea Warning: Bad type area settings!",
    [[Package fancyhdr Warning: \\headheight is too small]],
    [[Underfull \\hbox (badness [0-9]*) in paragraph at lines]],
    "Package hyperref Warning: Token not allowed in a PDF string",
    [[Overfull \\hbox ([0-9]*.[0-9]*pt too wide) in paragraph at lines]],
}
vim.g.matchup_override_vimtex = 1

vim.g.rooter_silent_chdir = 1
vim.g.rooter_resolve_links = 1
vim.g.rooter_silent_chdir = 1
vim.g.rooter_cd_cmd = "lcd"
vim.g.rooter_patterns = { ".git", ".git/", ".jj", "project.toml", ".env" }
