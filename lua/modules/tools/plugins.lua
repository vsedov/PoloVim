local tools = {}
local conf = require('modules.tools.config')

tools['kristijanhusak/vim-dadbod-ui'] = {
  cmd = {'DBUIToggle','DBUIAddConnection','DBUI','DBUIFindBuffer','DBUIRenameBuffer'},
  config = conf.vim_dadbod_ui,
  requires = {{'tpope/vim-dadbod',opt = true}}
}

tools['editorconfig/editorconfig-vim'] = {
  ft = { 'go','typescript','javascript','vim','rust','zig','c','cpp' }
}

tools['b3nj5m1n/kommentary'] = {
  config = conf.kommentary,
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
--^D ^U ^F ^B gg1 G1





tools['euclidianAce/BetterLua.vim'] = {}

tools['nacro90/numb.nvim'] = {
  config = function ()
  require('numb').setup()  end
}


tools['gennaro-tedesco/nvim-jqx'] = {
}




tools['Pocco81/HighStr.nvim'] = {
}



tools['jbyuki/nabla.nvim'] = {
}

tools['liuchengxu/vista.vim'] = {
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



tools['brooth/far.vim'] = {
  cmd = {'Far','Farp'},
  config = function ()
    vim.g['far#source'] = 'rg'
  end
}



tools['iamcco/markdown-preview.nvim'] = {
  run = ':call mkdp#util#install()',

  ft = 'markdown',
  config = function ()
    vim.g.mkdp_auto_start = 1
  end
}




-- Nice toools 


tools['kevinhwang91/nvim-hlslens'] = {
  config = function ()
    require('hlslens').setup({
      calm_down = true,
      nearest_only = true,
      nearest_float_when = 'always'
    })
  end
}


return tools
