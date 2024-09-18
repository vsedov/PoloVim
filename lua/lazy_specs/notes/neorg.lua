local M = {}
M.init = function()
    local function subcmd_alias(_)
        vim.api.nvim_create_user_command(
            "Metadata",
            "Neorg update-metadata",
            { desc = "Neorg: update-metadata", bar = true }
        )
        local days = { "Yesterday", "Today", "Tomorrow" }
        for _, cmd in ipairs(days) do
            vim.api.nvim_create_user_command(cmd, function()
                pcall(vim.cmd, [[Neorg journal ]] .. cmd:lower()) ---@diagnostic disable-line
                vim.schedule(function()
                    vim.cmd([[Metadata | w]])
                    vim.cmd([[normal ]h]h]]) -- move down to {** Daily Review}
                    pcall(vim.cmd, [[Neorg templates load journal]]) ---@diagnostic disable-line
                end)
            end, { desc = "Neorg: open " .. cmd .. "'s journal", force = true })
        end
    end
    subcmd_alias(_)

    -- vim.api.nvim_create_autocmd("BufWritePost", {
    --     pattern = "*.norg",
    --     command = "Neorg tangle current-file",
    -- })
end
M.opts = {
    load = {
        ["core.defaults"] = {}, -- Load all the default modules
        ["core.latex.renderer"] = {},
        ["core.integrations.image"] = {},
        ["core.dirman"] = { -- Manage your directories with Neorg
            config = {
                workspaces = {
                    home = "~/neorg",
                    personal = "~/neorg/personal",
                    work = "~/neorg/work",
                    notes = "~/neorg/notes",
                    phd = "~/Documents/PhD_Norg/",
                },
                index = "index.norg",
                autodetect = true,
                [[ -- autochdir = false, ]],
                default_workspace = "phd",
            },
        },
        ["core.keybinds"] = {
            config = {
                default_keybinds = true,
                neorg_leader = ",",
            },
        },
        ["core.journal"] = {
            config = {
                workspace = "knowledge",
                journal_folder = "journal",
                strategy = "nested",
            },
        },
        ["core.export"] = {},
        ["core.export.markdown"] = {
            config = { extensions = "all" },
        },
        ["external.interim-ls"] = {
            config = {
                completion_provider = {
                    enable = true,
                    categories = true,
                },
            },
        },
        ["core.completion"] = {
            config = { engine = { module_name = "external.lsp-completion" } },
        },
        ["core.concealer"] = {
            config = {
                icon_preset = "diamond",
                icons = {
                    todo = {
                        done = { icon = "󰸞" },
                        on_hold = { icon = "󰏤" },
                        urgent = { icon = "󱈸" },
                        uncertain = { icon = "" },
                        recurring = { icon = "" },
                        pending = { icon = "" },
                    },
                },
            },
        },
    },
}

M.config = function(op)
    vim.cmd([[packadd neorg-interim-ls]])

    require("neorg").setup(op)
    function ToggleToc()
        if vim.bo.filetype == "norg" then
            vim.cmd("Neorg toc left")
            local current_win = vim.api.nvim_get_current_win()
            vim.api.nvim_win_set_width(current_win, 27)
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-w>l", true, true, true), "n", true)
        end
    end

    -- Neorg
    vim.keymap.set("n", "<leader>;", ":lua ToggleToc()<CR>", { noremap = true, silent = true })
    vim.keymap.set("n", "<leader>nt", ":Neorg mode traverse-heading <cr>", {})
    vim.keymap.set("n", "<leader>nT", ":Neorg mode norg <cr>", {})
    vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
            local bufnr = args.buf
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            if not client then
                return
            end

            if client.server_capabilities.completionProvider then
                vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
            end

            local opts = { noremap = true, silent = true, buffer = bufnr }
            vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        end,
    })
end
return M
