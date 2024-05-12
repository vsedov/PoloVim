local startup = require("core.pack").package
local function focus_me()
    if vim.g.neovide then
        lambda.pcall(vim.cmd.NeovideFocus)
    else
        require("kitty.current_win").focus()
    end
end
local function FNV_hash(s)
    local prime = 1099511628211
    local hash = 14695981039346656037
    for i = 1, #s do
        hash = require("bit").bxor(hash, s:byte(i))
        hash = hash * prime
    end
    return hash
end

-- When you open a file in Vim but it was already open in another instance or not closed properly in a past edit, Vim will warn you, but it won't show you what the difference is between the hidden swap file and the regular saved file. Of all the actions you might want to do, the most obvious one is missing: compare, that is, see a diff.
-- enabled by default, will need to load on boot
startup({
    "Abstract-IDE/abstract-autocmds",
    lazy = false,
    config = function()
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
            smart_dd = true,
            visually_codeblock_shift = true,
            move_selected_upndown = true,
            dont_suspend_with_cz = true,
            scroll_from_center = true,
            ctrl_backspace_delete = true,

            -- Binds that i already have that are better than this
            go_back_normal_in_terminal = false,
            smart_visual_paste = false,
            smart_save_in_insert_mode = false,
            open_file_last_position = false,
        })
    end,
})

startup({
    "chrisbra/Recover.vim",
    config = function()
        vim.g.RecoverPlugin_Edit_Unmodified = 1
    end,
})

startup({
    "lewis6991/fileline.nvim",
})

startup({
    "pteroctopus/faster.nvim",
    config = true,
})
startup({

    "willothy/flatten.nvim",
    lazy = false,
    priority = 1001,
    opts = {
        pipe_path = function()
            -- If running in a Kitty terminal, all tabs/windows/os-windows in the same instance of kitty will open in the first neovim instance
            if vim.env.NVIM then
                return vim.env.NVIM
            end

            local addr

            -- If running in a Kitty terminal, all tabs/windows/os-windows in the same instance of kitty will open in the first neovim instance
            if vim.env.KITTY_PID then
                addr = ("%s/kitty.nvim-%s"):format(vim.fn.stdpath("run"), vim.env.KITTY_PID)
            end

            if not addr then
                addr = ("%s/nvim-%s"):format(vim.fn.stdpath("run"), FNV_hash(vim.loop.cwd()))
            end

            if addr then
                local ok = pcall(vim.fn.serverstart, addr)
                return addr
            end
        end,
        -- <String, Bool> dictionary of filetypes that should be blocking
        block_for = {
            gitcommit = true,
        },
        -- Window options
        window = {
            open = "current",
            -- open = function(bufs, argv)
            --   if vim.tbl_contains(argv, "-s") then
            --   end
            --   vim.api.nvim_win_set_buf(0, bufs[1])
            -- end,
            focus = "first",
        },
        callbacks = {
            ---@param argv table a list of all the arguments in the nested session
            should_block = function(argv)
                -- Note that argv contains all the parts of the CLI command, including
                -- Neovim's path, commands, options and files.
                -- See: :help v:argv

                -- In this case, we would block if we find the `-b` flag
                -- This allows you to use `nvim -b file1` instead of `nvim --cmd 'let g:flatten_wait=1' file1`
                return vim.tbl_contains(argv, "-b")

                -- Alternatively, we can block if we find the diff-mode option
                -- return vim.tbl_contains(argv, "-d")
            end,

            no_files = function()
                -- TODO: this seems to open minifiles?
                pcall(function()
                    focus_me()
                end)
            end,
            -- Called when a request to edit file(s) is received
            pre_open = function() end,
            post_open = function(bufnr, winnr, filetype)
                -- Called after a file is opened
                -- Passed the buf id, win id, and filetype of the new window

                -- Switch kitty window
                focus_me()

                -- If the file is a git commit, create one-shot autocmd to delete its buffer on write
                -- If you just want the toggleable terminal integration, ignore this bit
                -- ft = vim.api.nvim_buf_get_option(bufnr, "filetype")
                ft = vim.bo[bufnr].filetype

                if ft == "gitcommit" or ft == "gitrebase" then
                    vim.api.nvim_create_autocmd("BufWritePost", {
                        buffer = bufnr,
                        once = true,
                        callback = vim.schedule_wrap(function()
                            vim.api.nvim_buf_delete(bufnr, {})
                        end),
                    })
                end
            end,
        },
    },
})
local visible_buffers = {}
startup({
    "stevearc/resession.nvim",
    init = function()
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
    end,
    opts = {
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
    },
    config = function(_, opts)
        local resession = require("resession")
        local aug = vim.api.nvim_create_augroup("StevearcResession", {})
        resession.setup(opts)

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
    end,
})
