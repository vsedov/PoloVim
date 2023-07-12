local startup = require("core.pack").package
local visible_buffers = {}
--  NVIM_PROFILE=start nvim
-- to run this, you have to run the above
startup({
    "stevearc/profile.nvim",
    config = function()
        local should_profile = os.getenv("NVIM_PROFILE")
        if should_profile then
            require("profile").instrument_autocmds()
            if should_profile:lower():match("^start") then
                require("profile").start("*")
            else
                require("profile").instrument("*")
            end
        end

        local function toggle_profile()
            local prof = require("profile")
            if prof.is_recording() then
                prof.stop()
                vim.ui.input(
                    { prompt = "Save profile to:", completion = "file", default = "profile.json" },
                    function(filename)
                        if filename then
                            prof.export(filename)
                            vim.notify(string.format("Wrote %s", filename))
                        end
                    end
                )
            else
                prof.start("*")
            end
        end
        vim.keymap.set("", "<f3>", toggle_profile)
    end,
})

startup({
    "olimorris/persisted.nvim",
    cond = lambda.config.tools.session.use_persisted,
    event = "VimEnter",
    init = function()
        if lambda.config.tools.session.use_persisted then
            lambda.command("ListSessions", "Telescope persisted", {})
            lambda.augroup("PersistedEvents", {
                {
                    event = "User",
                    pattern = "PersistedTelescopeLoadPre",
                    command = function()
                        vim.schedule(function()
                            vim.cmd("%bd")
                        end)
                    end,
                },
                {
                    event = "User",
                    pattern = "PersistedSavePre",
                    -- Arguments are always persisted in a session and can't be removed using 'sessionoptions'
                    -- so remove them when saving a session
                    command = function()
                        vim.cmd("%argdelete")
                    end,
                },
            })
        end
    end,
    opts = {
        autosave = true,
        autoload = true,
        use_git_branch = true,
        ignored_dirs = { vim.fn.stdpath("data") },
    },
    config = function(_, opts)
        require("persisted").setup(opts)
        require("telescope").load_extension("persisted")
    end,
})
startup({
    "stevearc/resession.nvim",
    cond = lambda.config.tools.session.use_resession,
    event = "VimEnter",
    opts = {
        autosave = {
            enabled = true,
            notify = true,
        },

        tab_buf_filter = function(tabpage, bufnr)
            local dir = vim.fn.getcwd(-1, vim.api.nvim_tabpage_get_number(tabpage))
            return vim.startswith(vim.api.nvim_buf_get_name(bufnr), dir)
        end,
        buf_filter = function(bufnr)
            if not require("resession").default_buf_filter(bufnr) then
                return false
            end
            return visible_buffers[bufnr] or require("three").is_buffer_in_any_tab(bufnr)
        end,
        extensions = {
            overseer = {
                filter = function(task)
                    return task.metadata.run_on_open
                end,
            },
        },
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

        vim.keymap.set("n", "\\ss", resession.save, { desc = "[S]ession [S]ave" })
        vim.keymap.set("n", "\\st", function()
            resession.save_tab()
        end, { desc = "[S]ession save [T]ab" })
        vim.keymap.set("n", "\\so", function()
            resession.load("last")
        end, { desc = "[S]ession [O]pen" })

        vim.keymap.set("n", "\\sl", function()
            resession.load(nil, { reset = false })
        end, { desc = "[S]ession [L]oad without reset" })

        vim.keymap.set("n", "\\sd", resession.delete, { desc = "[S]ession [D]elete" })
        vim.api.nvim_create_user_command("SessionDetach", function()
            resession.detach()
        end, {})
        vim.keymap.set("n", "ZZ", function()
            resession.save("__quicksave__", { notify = false })
            vim.cmd("wa")
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
--
-- When you open a file in Vim but it was already open in another instance or not closed properly in a past edit, Vim will warn you, but it won't show you what the difference is between the hidden swap file and the regular saved file. Of all the actions you might want to do, the most obvious one is missing: compare, that is, see a diff.
-- enabled by default, will need to load on boot

startup({
    "chrisbra/Recover.vim",
    lazy = false,
})

-- nvim filename.py:10:20 -- you can open a file based on its filename and location.
startup({
    "lewis6991/fileline.nvim",
})
