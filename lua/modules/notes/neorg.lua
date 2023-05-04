local M = {}
M.opts = {
    load = {
        ["core.defaults"] = {}, -- Load all the default modules
        ["core.upgrade"] = {},
        ["core.completion"] = {
            config = {
                engine = "nvim-cmp",
            },
        },
        ["core.promo"] = {},
        ["core.presenter"] = {
            config = {
                zen_mode = "zen-mode",
                slide_count = {
                    enable = true,
                    position = "top",
                    count_format = "[%d/%d]",
                },
            },
        },
        ["core.looking-glass"] = {}, -- Enable the looking_glass module
        ["core.export.markdown"] = {
            config = {
                extensions = "all",
            },
        },
        ["core.concealer"] = {},
        ["core.esupports.metagen"] = {
            config = {
                type = "auto",
            },
        },

        ["core.keybinds"] = {
            config = {
                default_keybinds = true,
                neorg_leader = "\\",
                hook = function(keybinds)
                    keybinds.remap_event("norg", "n", "tc", "core.norg.qol.todo_items.todo.task_cycle")
                end,
            },
        },
        ["core.dirman"] = { -- Manage your directories with Neorg
            config = {
                workspaces = {
                    home = "~/neorg",
                    personal = "~/neorg/personal",
                    work = "~/neorg/work",
                    notes = "~/neorg/notes",
                    recipes = "~/neorg/notes/recipes",
                    prolog = "~/neorg/notes/prolog",
                    example_gtd = "~/example_workspaces/gtd",
                },
                index = "index.norg",
                --[[ autodetect = true,
                  autochdir = false, ]]
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
    },
}

M.config = function()

local neorg_callbacks = require("neorg.callbacks")

neorg_callbacks.on_event("core.keybinds.events.enable_keybinds", function(_, keybinds)
    -- Map all the below keybinds only when the "norg" mode is active
    keybinds.map_event_to_mode("norg", {
        n = { -- Bind keys in normal mode
            { "<C-f>", "core.integrations.telescope.find_linkable" },
        },
        i = { -- Bind in insert mode
            { "<C-l>", "core.integrations.telescope.insert_link" },
        },
    }, {
        silent = true,
        noremap = true,
    })

end

return M
