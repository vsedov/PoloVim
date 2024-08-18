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

local visible_buffers = {}
local resession = require("resession")
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        -- Only load the session if nvim was started with no args
        if vim.fn.argc(-1) == 0 then
            -- Save these to a different directory, so our manual sessions don't get polluted
            resession.load(vim.fn.getcwd(), { dir = "dirsession", silence_errors = true })
        end
    end,
    nested = true,
})
vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
        resession.save(vim.fn.getcwd(), { dir = "dirsession", notify = false })
    end,
})
resession.setup({
    autosave = {
        enabled = true,
        notify = false,
    },
    extensions = {
        overseer = {
            status = { "RUNNING" },
            oil = {},
            quickfix = {},
        },
    },
    -- tab_buf_filter = function(tabpage, bufnr)
    --   local dir = vim.fn.getcwd(-1, vim.api.nvim_tabpage_get_number(tabpage))
    --   return vim.startswith(vim.api.nvim_buf_get_name(bufnr), dir)
    -- end,
    buf_filter = function(bufnr)
        if not require("resession").default_buf_filter(bufnr) then
            return false
        end
        return visible_buffers[bufnr]
        -- or require("three").is_buffer_in_any_tab(bufnr) -- we are not using three anymore
    end,
})
local resession = require("resession")
local aug = vim.api.nvim_create_augroup("StevearcResession", {})

resession.add_hook("pre_save", function()
    visible_buffers = {}
    for _, winid in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_is_valid(winid) then
            visible_buffers[vim.api.nvim_win_get_buf(winid)] = winid
        end
    end
end)

vim.keymap.set("n", "<leader>ss", resession.save, { desc = "[S]ession [S]ave" })
vim.keymap.set("n", "<leader>st", function()
    resession.save_tab()
end, { desc = "[S]ession save [T]ab" })
vim.keymap.set("n", "<leader>so", resession.load, { desc = "[S]ession [O]pen" })
vim.keymap.set("n", "<leader>sl", function()
    resession.load(nil, { reset = false })
end, { desc = "[S]ession [L]oad without reset" })
vim.keymap.set("n", "<leader>sd", resession.delete, { desc = "[S]ession [D]elete" })
vim.api.nvim_create_user_command("SessionDetach", function()
    resession.detach()
end, {})
vim.keymap.set("n", "ZZ", function()
    vim.cmd("wa")
    resession.save("__quicksave__", { notify = false })
    vim.api.nvim_create_augroup("StevearcResession", {})
    vim.cmd("qa")
end)

if vim.tbl_contains(resession.list(), "__quicksave__") then
    vim.defer_fn(function()
        resession.load("__quicksave__", { attach = false })
        local ok, err = pcall(resession.delete, "__quicksave__")
        if not ok then
            vim.notify(string.format("Error deleting quicksave session: %s", err), vim.log.levels.WARN)
        end
    end, 50)
end

vim.api.nvim_create_autocmd("VimLeavePre", {
    group = aug,
    callback = function()
        resession.save("last")
    end,
})
