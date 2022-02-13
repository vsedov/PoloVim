local ui = {}
local conf = require("modules.ui.config")

--
local winwidth = function()
  return vim.api.nvim_call_function("winwidth", { 0 })
end

ui["kyazdani42/nvim-web-devicons"] = {}

ui["windwp/windline.nvim"] = {
  -- event = "UIEntwindlineer",
  config = conf.windline,
  -- requires = {'kyazdani42/nvim-web-devicons'},
  opt = true,
}

ui["akinsho/bufferline.nvim"] = {
  config = conf.nvim_bufferline,
  event = "UIEnter",
  diagnostics_update_in_insert = false,
  -- after = {"aurora"}
  -- requires = {'kyazdani42/nvim-web-devicons'}
  opt = true,
}

-- TODO MODIFY THIS
ui["startup-nvim/startup.nvim"] = {
  opt = true,
  requires = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
  config = function()
    -- require("startup").setup({theme = "dashboard"})
    require("startup").setup({ theme = "evil" })
  end,
}

-- Lazy Loading nvim-notify
ui["rcarriga/nvim-notify"] = {
  opt = true,
  requires = "telescope.nvim", -- this might not be needed
  config = conf.notify,
}

ui["kyazdani42/nvim-tree.lua"] = {
  cmd = { "NvimTreeToggle", "NvimTreeOpen" },
  -- requires = {'kyazdani42/nvim-web-devicons'},
  setup = conf.nvim_tree_setup,
  config = conf.nvim_tree,
}
-- Use this with nvimtree .
ui["elihunter173/dirbuf.nvim"] = {
  cmd = { "Dirbuf" },
  config = conf.dir_buff,
}

ui["lukas-reineke/indent-blankline.nvim"] = { opt = true, config = conf.blankline } -- after="nvim-treesitter",

-- disabled does not work with muliti split
ui["lukas-reineke/virt-column.nvim"] = {
  opt = true,
  -- event = {"CursorMoved", "CursorMovedI"},
  config = function()
    vim.cmd("highlight clear ColorColumn")
    require("virt-column").setup()

    vim.cmd("highlight VirtColumn guifg=#4358BF")
  end,
}

-- ui["dstein64/nvim-scrollview"] = {
--   event = { "CursorMoved", "CursorMovedI" },
--   config = conf.scrollview,
-- }

ui["petertriho/nvim-scrollbar"] = {
  event = { "CursorMoved", "CursorMovedI" },
  config = conf.scrollbar,
}

-- test fold
ui["xiyaowong/nvim-transparent"] = {
  cmd = { "TransparentEnable", "TransparentDisable", "TransparentToggle" },
  config = function()
    require("transparent").setup({
      enable = false,
      -- additional groups that should be clear
      extra_groups = {
        -- example of akinsho/nvim-bufferline.lua
        "BufferLineTabClose",
        "BufferlineBufferSelected",
        "BufferLineFill",
        "BufferLineBackground",
        "BufferLineSeparator",
        "BufferLineIndicatorSelected",
      },
      -- groups you don't want to clear
      exclude = {},
    })
  end,
}

ui["anuvyklack/pretty-fold.nvim"] = {
  ft = { "python", "c", "lua", "cpp", "java" },
  config = conf.pretty_fold,
}

ui["folke/tokyonight.nvim"] = {
  opt = true,
  setup = conf.tokyonight,
  config = function()
    vim.cmd([[hi CursorLine guibg=#353644]])
    vim.cmd([[colorscheme tokyonight]])
  end,
}

ui["tiagovla/tokyodark.nvim"] = {
  opt = true,
  setup = conf.tokyodark,
  config = function()
    vim.cmd([[hi CursorLine guibg=#353644]])
    vim.cmd([[colorscheme tokyodark]])
  end,
}

ui["catppuccin/nvim"] = {
  as = "catppuccin",
  opt = true,
  config = conf.catppuccin,
}

-- fix annoying strikethrough issue as that was not a valid key apparently .
ui["~/GitHub/Sakura.nvim"] = {
  module = "Sakura",
  opt = true,
  config = function()
    vim.cmd([[colorscheme sakura]])
  end,
}

-- Use default when loading this .
ui["rebelot/kanagawa.nvim"] = {
  opt = true,
  module = "kanagawa",
  config = conf.kanagawa,
}

-- Might want to manually call this through telescope or something .
-- ui["~/GitHub/themer/themer.lua"] = {
ui["ThemerCorp/themer.lua"] = {
  branch = "main",
  module = "themer",
  config = conf.themer,
}

ui["kazhala/close-buffers.nvim"] = {
  cmd = { "BDelete", "BWipeout" },
  config = conf.buffers_close,
}

return ui
-- hemer.lua: ...te/pack/packer/opt/themer.lua/lua/themer/core/mapper.lua:64: attempt to index field 'bg' (a string value)
