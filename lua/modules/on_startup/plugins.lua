local startup = require("core.pack").package
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
    cond = lambda.config.tools.use_session,
    event = "VimEnter",
    init = function()
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
--
-- When you open a file in Vim but it was already open in another instance or not closed properly in a past edit, Vim will warn you, but it won't show you what the difference is between the hidden swap file and the regular saved file. Of all the actions you might want to do, the most obvious one is missing: compare, that is, see a diff.
-- enabled by default, will need to load on boot

startup({
    "chrisbra/Recover.vim",
    lazy = false,
})
startup({
    "lewis6991/fileline.nvim",
})
