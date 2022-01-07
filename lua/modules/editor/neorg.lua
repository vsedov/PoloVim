local loader = require("packer").loader

if not packer_plugins["zen-mode.nvim"].loaded then
  vim.cmd([[packadd zen-mode.nvim ]])
end
if not packer_plugins["neorg-telescope"].loaded then
  vim.cmd([[packadd neorg-telescope ]])
end
if not packer_plugins["telescope.nvim"].loaded then
  vim.cmd([[packadd telescope.nvim ]])
end

if not packer_plugins["nvim-treesitter"].loaded then
  vim.cmd([[packadd nvim-treesitter ]])
  vim.cmd([[packadd plenary.nvim ]])
end

if not packer_plugins["nvim-cmp"].loaded then
  vim.cmd([[packadd nvim-cmp]])
end

local neorg_callbacks = require("neorg.callbacks")
-- neorg_callbacks.on_event("core.autocommands.events.bufenter", function(event, event_content)
neorg_callbacks.on_event("core.started", function(event, event_content)
  require("neorg").setup({
    load = {
      ["core.integrations.telescope"] = {},
    },
  })
  require("telescope").setup({})
end)

require("neorg").setup({

  load = {
    ["core.integrations.telescope"] = {}, -- Enable the telescope module
    ["core.defaults"] = {}, -- Load all the default modules
    ["core.norg.completion"] = {
      config = {
        engine = "nvim-cmp", -- We current support nvim-compe and nvim-cmp only
      },
    },

    ["core.norg.concealer"] = {
      config = {
        icon_preset = "diamond",
        icons = {
          marker = {
            icon = " ",
          },
          todo = {
            enable = true,
            pending = {
              -- icon = ""
              icon = "",
            },
            uncertain = {
              icon = "?",
            },
            urgent = {
              icon = "",
            },
            on_hold = {
              icon = "",
            },
            cancelled = {
              icon = "",
            },
          },
        },
      },
    },
    ["core.presenter"] = {
      config = {
        zen_mode = "zen-mode",
      },
    },
    ["core.keybinds"] = {
      config = {
        default_keybinds = true,
        neorg_leader = "<Leader>o",
      },
    },
    ["core.norg.dirman"] = {
      config = {
        workspaces = {
          my_workspace = "~/neorg",
          example_ws = "~/example_workspaces/gtd/",
          gtd = "~/gtd",
          notes = "~notes",
        },
      },
    },
    ["core.gtd.base"] = {
      config = {
        workspace = "gtd",
      },
    },
    -- ["core.norg.qol.toc"] = {
    --   config = {
    --     close_split_on_jump = false,
    --     toc_split_placement = "left",
    --   },
    -- },
    ["core.norg.journal"] = {
      config = {
        journal_folder = "my_journal",
        use_folders = false,
      },
    },
  },
})

local neorg_callbacks = require("neorg.callbacks")

neorg_callbacks.on_event("core.keybinds.events.enable_keybinds", function(_, keybinds)
  -- Map all the below keybinds only when the "norg" mode is active
  keybinds.map_event_to_mode("norg", {
    n = { -- Bind keys in normal mode
      { "<c-s>", "core.integrations.telescope.find_linkable" },
      { "<c-i>", "core.integrations.telescope.search_headings" },
      { "<c-k>", "core.integrations.telescope.insert_link" },
    },
    i = { -- Bind in insert mode
      { "<c-k>", "core.integrations.telescope.insert_link" },
    },
  }, { silent = true, noremap = true })
end)
