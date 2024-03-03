if not lambda then
    return
end
local function find_files()
    local dir = require("oil").get_current_dir()
    if vim.api.nvim_win_get_config(0).relative ~= "" then
        vim.api.nvim_win_close(0, true)
    end
    require("telescope.builtin").find_files({ cwd = dir, hidden = true })
end

local function livegrep()
    local dir = require("oil").get_current_dir()
    if vim.api.nvim_win_get_config(0).relative ~= "" then
        vim.api.nvim_win_close(0, true)
    end
    require("telescope.builtin").live_grep({ cwd = dir })
end

local settings, highlight = lambda.filetype_settings, lambda.highlight
local cmd, fn = vim.cmd, vim.fn
-- local ftplugin = require("ftplugin")
-- ftplugin.set("oil", {
vim.treesitter.language.register("gitcommit", "NeogitCommitMessage")
settings({
    ["oil"] = {
        opt = {
            conceallevel = 3,
            concealcursor = "n",
            list = false,
            wrap = false,
            signcolumn = "no",
        },
        mappings = {
            {
                "n",
                "<leader>ff",
                function()
                    find_files()
                end,
                desc = "[F]ind [F]iles in dir",
            },
            {
                "n",
                "<leader>fg",
                function()
                    livegrep()
                end,
                desc = "[F]ind by [G]rep in dir",
            },
        },
        --
        function()
            local oil = require("oil")

            vim.api.nvim_buf_create_user_command(0, "Save", function(params)
                oil.save({ confirm = not params.bang })
            end, {
                desc = "Save oil changes with a preview",
                bang = true,
            })
            vim.api.nvim_buf_create_user_command(0, "EmptyTrash", function(params)
                oil.empty_trash()
            end, {
                desc = "Empty the trash directory",
            })
            vim.api.nvim_buf_create_user_command(0, "OpenTerminal", function(params)
                require("oil.adapters.ssh").open_terminal()
            end, {
                desc = "Open the debug terminal for ssh connections",
            })
        end, -- open startup time to the left
    },
    chatgpt = {
        function()
            vim.treesitter.language.register("markdown", "chatgpt")
        end,
    },
    prompt = {
        plugins = {
            cmp = function(cmp)
                cmp.setup.filetype("Prompt", {
                    sources = {},
                })
            end,
        },
    },
    ["Neogit*"] = {
        wo = { winbar = "" },
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
            { "n", "h", "<CR>" },
            { "n", "o", "<CR>" },
        },
    },
    norg = {
        opt = {
            -- conceallevel = 3,
            -- concealcursor = "n",
            -- list = false,
            -- wrap = false,
            -- signcolumn = "no",
            -- foldlevel = 9999,
        },

        plugins = {
            cmp = function(cmp)
                cmp.setup.filetype("norg", {
                    sources = {
                        { name = "otter" },
                        { name = "path", group_index = 1 },
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
    -- [{ "lua", "python", "rust" }] = { opt = { spell = true } },
})
