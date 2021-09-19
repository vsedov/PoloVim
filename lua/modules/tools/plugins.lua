local tools = {}
local conf = require('modules.tools.config')


tools["kristijanhusak/vim-dadbod-ui"] = {
  cmd = {"DBUIToggle", "DBUIAddConnection", "DBUI", "DBUIFindBuffer", "DBUIRenameBuffer", "DB"},
  config = conf.vim_dadbod_ui,
  requires = {"tpope/vim-dadbod", ft = {'sql'}},
  opt = true,
  setup = function()
    vim.g.dbs = {
      eraser = 'postgres://postgres:password@localhost:5432/eraser_local',
      staging = 'postgres://postgres:password@localhost:5432/my-staging-db',
      wp = 'mysql://root@localhost/wp_awesome'
    }
  end
}


tools["TimUntersberger/neogit"] = {
  cmd = {"Neogit"},
  config = function()
    local neogit = require('neogit')
    neogit.setup {}
  end
}

tools["editorconfig/editorconfig-vim"] = {
  opt = true,
  cmd = {"EditorConfigReload"}
  -- ft = { 'go','typescript','javascript','vim','rust','zig','c','cpp' }
}

tools['b3nj5m1n/kommentary'] = {
  config = conf.kommentary,
}

tools["nanotee/zoxide.vim"] = {cmd = {"Z", "Lz", "Zi"}}
tools["liuchengxu/vim-clap"] = {
  cmd = {"Clap"},
  run = function()
    vim.fn["clap#installer#download_binary"]()
  end,
  setup = conf.clap,
  config = conf.clap_after
}
tools["sindrets/diffview.nvim"] = {
  cmd = {"DiffviewOpen", "DiffviewFileHistory", "DiffviewFocusFiles", "DiffviewToggleFiles", "DiffviewRefresh"},
   config = conf.diffview
}


tools['vimwiki/vimwiki'] = {
  opt = true,
  branch = "dev",
  keys = {"<leader>ww", "<leader>wt", "<leader>wi"},
  event = {"BufEnter *.wiki"},
  setup = conf.vimwiki_setup,
  config = conf.vimwiki_config
}




tools['relastle/vim-nayvy'] ={

  config = function ()
    vim.g.nayvy_import_config_path = '$HOME/nayvy.py'
  end
}



tools['wakatime/vim-wakatime'] ={
}

--Moving stuff 
tools['camspiers/animate.vim'] ={
}

tools['psliwka/vim-smoothie'] ={
  config = function()
    vim.g.smoothie_experimental_mappings =1
  end
}

tools["kamykn/spelunker.vim"] = {
  opt = true, fn = {"spelunker#check"},
  setup = conf.spelunker,
  config = conf.spellcheck,
}

tools["rhysd/vim-grammarous"] = {
  opt = true,
  cmd = {"GrammarousCheck"},
  ft = {"markdown", "txt"}
}




tools['euclidianAce/BetterLua.vim'] = {}

tools['nacro90/numb.nvim'] = {
  config = function ()
    require('numb').setup{
      show_numbers = true, -- Enable 'number' for the window while peeking
      show_cursorline = true -- Enable 'cursorline' for the window while peeking
    }
  end
}



-- quick code snipit , very nice
tools['https://github.com/rktjmp/paperplanes.nvim'] = {
    config = function ()
      require("paperplanes").setup({
        register = "+",
        provider = "dpaste.org"
      })
    end

}




tools['Pocco81/HighStr.nvim'] = {
}



tools['jbyuki/nabla.nvim'] = {
}

tools['liuchengxu/vista.vim'] = {
  opt=true,
  cmd = 'Vista',
  config = conf.vim_vista
}


tools['simrat39/symbols-outline.nvim'] = {

  config = function()
-- init.lua
vim.g.symbols_outline = {
    highlight_hovered_item = false,
    show_guides = true,
    auto_preview = true,
    position = 'right',
    show_numbers = false,
    show_relative_numbers = false,
    show_symbol_details = true,
    keymaps = {
        close = "<Esc>",
        goto_location = "<Cr>",
        focus_location = "o",
        hover_symbol = "<C-space>",
        rename_symbol = "r",
        code_actions = "a",
    },
    lsp_blacklist = {},
    symbols = {
        File = {icon = "", hl = "TSURI"},
        Module = {icon = "", hl = "TSNamespace"},
        Namespace = {icon = "", hl = "TSNamespace"},
        Package = {icon = "", hl = "TSNamespace"},
        Class = {icon = "𝓒", hl = "TSType"},
        Method = {icon = "ƒ", hl = "TSMethod"},
        Property = {icon = "", hl = "TSMethod"},
        Field = {icon = "", hl = "TSField"},
        Constructor = {icon = "", hl = "TSConstructor"},
        Enum = {icon = "ℰ", hl = "TSType"},
        Interface = {icon = "ﰮ", hl = "TSType"},
        Function = {icon = "", hl = "TSFunction"},
        Variable = {icon = "", hl = "TSConstant"},
        Constant = {icon = "", hl = "TSConstant"},
        String = {icon = "𝓐", hl = "TSString"},
        Number = {icon = "#", hl = "TSNumber"},
        Boolean = {icon = "⊨", hl = "TSBoolean"},
        Array = {icon = "", hl = "TSConstant"},
        Object = {icon = "⦿", hl = "TSType"},
        Key = {icon = "🔐", hl = "TSType"},
        Null = {icon = "NULL", hl = "TSType"},
        EnumMember = {icon = "", hl = "TSField"},
        Struct = {icon = "𝓢", hl = "TSType"},
        Event = {icon = "🗲", hl = "TSType"},
        Operator = {icon = "+", hl = "TSOperator"},
        TypeParameter = {icon = "𝙏", hl = "TSParameter"}
    }
}
  end
}

tools['kdheepak/lazygit.nvim'] = {
  opt = true,
  cmd = {'LazyGit'},
  config = function()
    vim.g.lazygit_floating_window_winblend = 2
  end
}



tools["brooth/far.vim"] = {
  cmd = {"Farr", "Farf"},
  run = function()
    require"packer".loader('far.vim')
    vim.cmd [[UpdateRemotePlugins]]
  end,
  config = conf.far,
  opt = true
} -- brooth/far.vim



-- tools['https://github.com/rcarriga/nvim-notify']={

--   config = function()
--     require("notify")("My super important message")
--     vim.notify = require("notify")
--     vim.notify("This is an error message", "error")

--   end
-- }

tools['iamcco/markdown-preview.nvim'] = {
  run = ':call mkdp#util#install()',

  ft = 'markdown',
  config = function ()
    vim.g.mkdp_auto_start = 1
  end
}




-- Nice toools 


-- tools['kevinhwang91/nvim-hlslens'] = {
--   config = function ()
--     require('hlslens').setup({
--     })
--   end
-- }


return tools
