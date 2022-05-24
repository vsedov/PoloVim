local completion = {}
local conf = require("modules.completion.config")

completion["hrsh7th/nvim-cmp"] = {
    -- opt = true,
    event = { "InsertEnter", "CmdLineEnter", "InsertCharPre" }, -- InsertCharPre Due to luasnip
    -- ft = {'lua', 'markdown',  'yaml', 'json', 'sql', 'vim', 'sh', 'sql', 'vim', 'sh'},
    after = { "LuaSnip" }, -- "nvim-snippy",
    requires = {
        {
            "tzachar/cmp-tabnine",
            run = "./install.sh",
            -- after = "nvim-cmp",
            config = conf.tabnine,
            opt = true,
        },
        { "hrsh7th/cmp-nvim-lsp-signature-help", after = "nvim-cmp", opt = true },
        { "kdheepak/cmp-latex-symbols", after = "nvim-cmp", opt = true },
        { "hrsh7th/cmp-buffer", after = "nvim-cmp", opt = true },
        { "hrsh7th/cmp-nvim-lua", after = "nvim-cmp", opt = true },
        { "hrsh7th/cmp-calc", after = "nvim-cmp", opt = true },
        { "hrsh7th/cmp-path", after = "nvim-cmp", opt = true },
        { "hrsh7th/cmp-nvim-lsp-document-symbol", after = "nvim-cmp", opt = true },
        { "max397574/cmp-cmdline", branch = "patch-1", after = "nvim-cmp", opt = true },
        { "ray-x/cmp-treesitter", after = "nvim-cmp", opt = true },
        { "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp", opt = true },
        { "f3fora/cmp-spell", after = "nvim-cmp", opt = true },
        { "octaltree/cmp-look", after = "nvim-cmp", opt = true },
        { "petertriho/cmp-git", after = "nvim-cmp", opt = true },
        -- {"quangnguyen30192/cmp-nvim-ultisnips", event = "InsertCharPre", after = "nvim-cmp", opt=true },
        { "saadparwaiz1/cmp_luasnip", after = { "nvim-cmp", "LuaSnip" } },
    },
    config = conf.cmp,
}

completion["L3MON4D3/LuaSnip"] = { -- need to be the first to load
    event = "InsertEnter",
    module = "luasnip",
    requires = {
        { "rafamadriz/friendly-snippets", event = "InsertEnter" },
    }, -- , event = "InsertEnter"
}

completion["/home/viv/.config/nvim/lua/modules/completion/snippets/latex/luasnip-latex-snippets.nvim"] = {
    requires = { "L3MON4D3/LuaSnip", "lervag/vimtex" },
    ft = "tex",
}

completion["kristijanhusak/vim-dadbod-completion"] = {
    event = "InsertEnter",
    ft = { "sql" },
    setup = function()
        vim.cmd([[autocmd FileType sql setlocal omnifunc=vim_dadbod_completion#omni]])
        -- vim.cmd([[autocmd FileType sql,mysql,plsql lua require('cmp').setup.buffer({ sources = {{ name = 'vim-dadbod-completion' }} })]])
        -- body
    end,
}

completion["windwp/nvim-autopairs"] = {
    event = {
        "InsertEnter",
        "CmdLineEnter",
    },
    after = "nvim-cmp",

    config = conf.autopair,
}

completion["danymat/neogen"] = {
    module = { "neogen" },
    requires = { "LuaSnip" },
    config = conf.neogen,
}

return completion
