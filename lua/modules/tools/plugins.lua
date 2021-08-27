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

-- tools['https://github.com/karb94/neoscroll.nvim']={

--   config = function() 
--     require('neoscroll').setup({
--         easing_function = "quintic",
--         -- All these keys will be mapped to their corresponding default scrolling animation
--         mappings = {'<C-u>', '<C-d>', '<C-b>', '<C-f>',
--                     '<C-y>', '<C-e>', 'zt', 'zz', 'zb'},
--         hide_cursor = true,          -- Hide cursor while scrolling
--         stop_eof = true,             -- Stop at <EOF> when scrolling downwards
--         use_local_scrolloff = false, -- Use the local scope of scrolloff instead of the global scope
--         respect_scrolloff = false,   -- Stop scrolling when the cursor reaches the scrolloff margin of the file
--         cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
--         easing_function = nil,        -- Default easing function
--         pre_hook = nil,              -- Function to run before the scrolling animation starts
--         post_hook = nil,              -- Function to run after the scrolling animation ends
--     })
--         local t = {}
--     -- Syntax: t[keys] = {function, {function arguments}}
--     t['<C-u>'] = {'scroll', {'-vim.wo.scroll', 'true', '250'}}
--     t['<C-d>'] = {'scroll', {'vim.wo.scroll', 'true', '250'}}
--     t['<C-b>'] = {'scroll', {'-vim.api.nvim_win_get_height(0)', 'true', '450'}}
--     t['<C-f>'] = {'scroll', {'vim.api.nvim_win_get_height(0)', 'true', '450'}}
--     t['<C-y>'] = {'scroll', {'-0.10', 'false', '100'}}
--     t['<C-e>'] = {'scroll', {'0.10', 'false', '100'}}
--     t['zt'] = {'zt', {'250'}}
--     t['zz'] = {'zz', {'250'}}
--     t['zb'] = {'zb', {'250'}}
--     require('neoscroll.config').set_mappings(t)
    
--   end
-- }


tools['euclidianAce/BetterLua.vim'] = {}

tools['nacro90/numb.nvim'] = {
  config = function ()
  require('numb').setup()  end
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
  -- cmd = {'Far','Farp'},
  config = function ()
    vim.g['far#source'] = 'rg'
  end
}



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
