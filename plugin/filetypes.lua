if not lambda then
    return
end

local settings, highlight = lambda.filetype_settings, lambda.highlight
local cmd, fn = vim.cmd, vim.fn

settings({
    chatgpt = {
        function()
            vim.treesitter.language.register("markdown", "chatgpt")
        end,
    },
    checkhealth = {
        opt = { spell = false },
    },
    ["dap-repl"] = {
        opt = {
            buflisted = false,
            winfixheight = true,
            signcolumn = "yes:2",
        },
        function()
            lambda.adjust_split_height(12, math.floor(vim.o.lines * 0.3))
        end,
    },
    [{ "gitcommit", "gitrebase" }] = {
        bo = { bufhidden = "delete" },
        opt = {
            list = false,
            spell = true,
            spelllang = "en_gb",
        },
    },
    NeogitCommitMessage = {
        opt = {
            spell = true,
            spelllang = "en_gb",
            list = false,
        },
        plugins = {
            cmp = function(cmp)
                cmp.setup.filetype("NeogitCommitMessage", {
                    sources = {
                        { name = "luasnip", group_index = 1 },
                        { name = "git", group_index = 1 },
                        { name = "dictionary", group_index = 1 },
                        { name = "spell", group_index = 1 },
                        { name = "buffer", group_index = 2 },
                    },
                })
            end,
        },
        function()
            vim.treesitter.language.register("gitcommit", "NeogitCommitMessage")
        end,
    },
    netrw = {
        g = {
            netrw_liststyle = 3,
            netrw_banner = 0,
            netrw_browse_split = 0,
            netrw_winsize = 25,
            netrw_altv = 1,
            netrw_fastbrowse = 0,
        },
        bo = { bufhidden = "wipe" },
        mappings = {
            { "n", "q", "<Cmd>q<CR>" },
            { "n", "l", "<CR>" },
            { "n", "h", "<CR>" },
            { "n", "o", "<CR>" },
        },
    },
    norg = {
        plugins = {
            cmp = function(cmp)
                cmp.setup.filetype("norg", {
                    sources = {
                        { name = "luasnip", group_index = 1 },
                        { name = "neorg", group_index = 1 },
                        { name = "dictionary", group_index = 1 },
                        { name = "spell", group_index = 1 },
                        { name = "emoji", group_index = 1 },
                        { name = "buffer", group_index = 2 },
                    },
                })
            end,
            ["nvim-surround"] = function(surround)
                surround.buffer_setup({
                    surrounds = {
                        l = {
                            add = function()
                                return { { "[" }, { "]{" .. vim.fn.getreg("*") .. "}" } }
                            end,
                        },
                    },
                })
            end,
        },
    },
    [{ "javascript", "javascriptreact" }] = {
        bo = { textwidth = 100 },
        opt = { spell = true },
    },
    startuptime = {
        function()
            cmd.wincmd("H")
        end, -- open startup time to the left
    },
    [{ "typescript", "typescriptreact" }] = {
        bo = { textwidth = 100 },
        opt = { spell = true },
        mappings = {
            { "n", "gd", "<Cmd>TypescriptGoToSourceDefinition<CR>", desc = "typescript: go to source definition" },
        },
    },
    [{ "lua", "python", "rust" }] = { opt = { spell = true } },
})
