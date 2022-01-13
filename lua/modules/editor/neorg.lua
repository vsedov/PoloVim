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
    ["core.norg.qol.toc"] = {
      config = {
        close_split_on_jump = false,
        toc_split_placement = "left",
      },
    },
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

local neorg_leader = "<leader>o"
neorg_callbacks.on_event("core.keybinds.events.enable_keybinds", function(_, keybinds)
  -- Map all the below keybinds only when the "norg" mode is active
  keybinds.map_event_to_mode("norg", {
    n = { -- Bind keys in normal mode

      -- Keys for managing TODO items and setting their states
      { "gtu", "core.norg.qol.todo_items.todo.task_undone" },
      { "gtp", "core.norg.qol.todo_items.todo.task_pending" },
      { "gtd", "core.norg.qol.todo_items.todo.task_done" },
      { "gth", "core.norg.qol.todo_items.todo.task_on_hold" },
      { "gtc", "core.norg.qol.todo_items.todo.task_cancelled" },
      { "gtr", "core.norg.qol.todo_items.todo.task_recurring" },
      { "gti", "core.norg.qol.todo_items.todo.task_important" },
      { "<C-Space>", "core.norg.qol.todo_items.todo.task_cycle" },

      -- Keys for managing GTD
      { neorg_leader .. "tc", "core.gtd.base.capture" },
      { neorg_leader .. "tv", "core.gtd.base.views" },
      { neorg_leader .. "te", "core.gtd.base.edit" },

      -- Keys for managing notes
      { neorg_leader .. "nn", "core.norg.dirman.new.note" },

      { "<CR>", "core.norg.esupports.hop.hop-link" },
      { "<M-CR>", "core.norg.esupports.hop.hop-link", "vsplit" },

      { "<M-k>", "core.norg.manoeuvre.item_up" },
      { "<M-j>", "core.norg.manoeuvre.item_down" },

      -- mnemonic: markup toggle
      { neorg_leader .. "mt", "core.norg.concealer.toggle-markup" },

      { neorg_leader .. "l", "core.integrations.telescope.insert_link" },
    },

    o = {
      { "ah", "core.norg.manoeuvre.textobject.around-heading" },
      { "ih", "core.norg.manoeuvre.textobject.inner-heading" },
      { "at", "core.norg.manoeuvre.textobject.around-tag" },
      { "it", "core.norg.manoeuvre.textobject.inner-tag" },
      { "al", "core.norg.manoeuvre.textobject.around-whole-list" },
    },
    i = {
      { "<C-l>", "core.integrations.telescope.insert_link" },
    },
  }, {
    silent = true,
    noremap = true,
  })

  -- Map the below keys only when traverse-heading mode is active
  keybinds.map_event_to_mode("traverse-heading", {
    n = {
      -- Rebind j and k to move between headings in traverse-heading mode
      { "j", "core.integrations.treesitter.next.heading" },
      { "k", "core.integrations.treesitter.previous.heading" },
    },
  }, {
    silent = true,
    noremap = true,
  })
  keybinds.map_event_to_mode("toc-split", {
    n = {
      { "<CR>", "core.norg.qol.toc.hop-toc-link" },

      -- Keys for closing the current display
      { "q", "core.norg.qol.toc.close" },
      { "<Esc>", "core.norg.qol.toc.close" },
    },
  }, {
    silent = true,
    noremap = true,
    nowait = true,
  })

  -- Map the below keys on gtd displays
  keybinds.map_event_to_mode("gtd-displays", {
    n = {
      { "<CR>", "core.gtd.ui.goto_task" },

      -- Keys for closing the current display
      { "q", "core.gtd.ui.close" },
      { "<Esc>", "core.gtd.ui.close" },

      { "e", "core.gtd.ui.edit_task" },
      { "<Tab>", "core.gtd.ui.details" },
    },
  }, {
    silent = true,
    noremap = true,
    nowait = true,
  })

  -- Map the below keys on presenter mode
  keybinds.map_event_to_mode("presenter", {
    n = {
      { "<CR>", "core.presenter.next_page" },
      { "l", "core.presenter.next_page" },
      { "h", "core.presenter.previous_page" },

      -- Keys for closing the current display
      { "q", "core.presenter.close" },
      { "<Esc>", "core.presenter.close" },
    },
  }, {
    silent = true,
    noremap = true,
    nowait = true,
  })
  -- Apply the below keys to all modes
  keybinds.map_to_mode("all", {
    n = {
      { neorg_leader .. "mn", ":Neorg mode norg<CR>" },
      { neorg_leader .. "mh", ":Neorg mode traverse-heading<CR>" },
    },
  }, {
    silent = true,
    noremap = true,
  })
end)
