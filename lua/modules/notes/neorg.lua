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
        ["core.completion"] = {
            config = {
                engine = "nvim-cmp",
            },
        },
        ["core.latex.renderer"] = {},
        ["core.integrations.image"] = {},
        ["core.looking-glass"] = {}, -- Enable the looking_glass module
        ["core.itero"] = {},
        ["core.export"] = {},
        ["core.export.markdown"] = {
            config = {
                extensions = "all",
            },
        },
        ["external.exec"] = {},
        ["external.hop-extras"] = {},
        ["core.concealer"] = {
            config = {
                icon_preset = "varied",
                icons = {
                    delimiter = {
                        horizontal_line = {
                            highlight = "@neorg.delimiters.horizontal_line",
                        },
                    },
                    code_block = {
                        -- If true will only dim the content of the code block (without the
                        -- `@code` and `@end` lines), not the entirety of the code block itself.
                        content_only = true,

                        -- The width to use for code block backgrounds.
                        --
                        -- When set to `fullwidth` (the default), will create a background
                        -- that spans the width of the buffer.
                        --
                        -- When set to `content`, will only span as far as the longest line
                        -- within the code block.
                        width = "content",

                        -- Additional padding to apply to either the left or the right. Making
                        -- these values negative is considered undefined behaviour (it is
                        -- likely to work, but it's not officially supported).
                        padding = {
                            -- left = 20,
                            -- right = 20,
                        },

                        -- If `true` will conceal (hide) the `@code` and `@end` portion of the code
                        -- block.
                        conceal = true,

                        nodes = { "ranged_verbatim_tag" },
                        highlight = "CursorLine",
                        -- render = module.public.icon_renderers.render_code_block,
                        insert_enabled = true,
                    },
                },
            },
        },
        ["core.esupports.metagen"] = {
            config = {
                type = "auto",
            },
        },
        ["core.qol.todo_items"] = {},

        ["core.keybinds"] = {
            config = {
                default_keybinds = true,
                neorg_leader = "\\",
                hook = require("modules.notes.norg.keybinds").hook,
            },
        },
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

        ["core.qol.toc"] = {
            config = {
                close_split_on_jump = true,
                toc_split_placement = "left",
            },
        },
        ["core.journal"] = {
            config = {
                workspace = "home",
                journal_folder = "journal",
                use_folders = true,
            },
        },
        ["core.summary"] = {},
        ["core.manoeuvre"] = {},
        ["core.ui.calendar"] = {},
        --  ──────────────────────────────────────────────────────────────────────
        ["core.presenter"] = {
            config = {
                zen_mode = "zen-mode",
            },
        },

        ["core.integrations.telescope"] = {},
        ["core.integrations.roam"] = {
            -- default keymaps
            config = {
                keymaps = {
                    select_prompt = "<C-n>",
                    insert_link = "<leader>ni",
                    find_note = "<leader>nf",
                    capture_note = "<leader>nc",
                    capture_index = "<leader>nl",
                    capture_cancel = "<C-q>",
                    capture_save = "<C-w>",
                },
                -- telescope theme

                theme = "ivy",

                capture_templates = {
                    {
                        name = "default",
                        file = "${title}",
                        lines = { "" },
                    },
                    {
                        name = "New Fleeting Note",
                        file = "${title}_${date}",
                        title = "${title}",
                        lines = { "", "* ${heading1}", "" },
                    },
                    {
                        name = "Author Template",
                        file = "${title}_${date}",
                        lines = {
                            "",
                            "* {Title}",
                            "",
                            "** {Bio}",
                            "",
                            "** {Notes}",
                            "",
                            "** {Quotes}",
                            "",
                            "** {Questions}",
                            "",
                            "** {References}",
                        },
                    },

                    {
                        name = "Core Template",
                        file = "${title}_${date}",
                        lines = {
                            "",
                            "* Title",
                            "",
                            "** Notes",
                            "",
                            "** Questions",
                            "",
                            "===",
                            "",
                            "** Terms",
                            "",
                            "** References}",
                        },
                    },
                    {
                        name = "Pro Con",
                        file = "$tool_{title}_${date}",
                        lines = {
                            "",
                            "* Title",
                            "",
                            "** Usage ",
                            "",
                            "** Pros",
                            "",
                            "** Cons",
                            "",
                            "===",
                            "",
                            "** {References}",
                        },
                    },
                },

                substitutions = {
                    title = function(metadata)
                        return metadata.title
                    end,
                    date = function(metadata)
                        return os.date("%Y-%m-%d")
                    end,
                    time = function(metadata)
                        return os.date("%H:%M:%S")
                    end,
                },
            },
        },
    },
}

M.config = function(_, op)
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
end
return M
