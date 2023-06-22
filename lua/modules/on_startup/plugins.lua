local startup = require("core.pack").package
startup({
    "lewis6991/fileline.nvim",
})
-- ╰─λ NVIM_PROFILE=start nvim
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
