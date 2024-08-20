require("abstract-autocmds").setup({
    auto_resize_splited_window = true,
    remove_whitespace_on_save = true,
    no_autocomment_newline = true,
    clear_last_used_search = true,
    highlight_on_yank = {
        enable = true,
        opts = {
            timeout = 150,
        },
    },
    give_border = {
        enable = true,
        opts = {
            pattern = { "null-ls-info", "lspinfo" },
        },
    },
    smart_dd = false,
    visually_codeblock_shift = true,
    move_selected_upndown = true,
    dont_suspend_with_cz = true,
    scroll_from_center = true,
    ctrl_backspace_delete = true,

    -- Binds that i already have that are better than this
    go_back_normal_in_terminal = true,
    smart_visual_paste = true,
    smart_save_in_insert_mode = false,
    open_file_last_position = false,
    -- ──────────────────────────────────────────────────────────────────────
})
vim.g.RecoverPlugin_Edit_Unmodified = 1
