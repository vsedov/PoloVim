vim.g.barbar_auto_setup = true
require("barbar").setup({ aimation = false })
require("scope").setup({
    hooks = {
        pre_tab_leave = function()
            vim.api.nvim_exec_autocmds("User", { pattern = "ScopeTabLeavePre" })
            -- [other statements]
        end,

        post_tab_enter = function()
            vim.api.nvim_exec_autocmds("User", { pattern = "ScopeTabEnterPost" })
            -- [other statements]
        end,

        -- [other hooks]
    },

    -- [other options]
})
require("stickybuf").setup({
    get_auto_pin = function(bufnr)
        return require("stickybuf").should_auto_pin(bufnr)
    end,
})
