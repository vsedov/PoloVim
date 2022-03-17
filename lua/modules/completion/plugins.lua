local completion = {}
local conf = require("modules.completion.config")

completion["neovim/nvim-lspconfig"] = {
    -- ft = {'html','css', 'javascript', 'java', 'javascriptreact', 'vue','typescript', 'typescriptreact', 'go', 'lua', 'cpp', 'c',
    -- 'markdown', 'makefile','python','bash', 'sh', 'php', 'yaml', 'json', 'sql', 'vim', 'sh'},
    config = conf.nvim_lsp,

    requires = {
        { "nvim-lua/lsp_extensions.nvim", opt = true },
        { "williamboman/nvim-lsp-installer", opt = true },
        { "folke/lua-dev.nvim", module = "lua-dev" },
        -- { "lewis6991/hover.nvim"}
    },

    opt = true,
}

completion["tami5/lspsaga.nvim"] = {
    cmd = "lspsaga",
    module = "lspsaga",
    opt = true,
    config = conf.saga,
    after = "nvim-lspconfig",
}

if load_coq() then
    completion["ms-jpq/coq_nvim"] = {
        -- opt = true,
        -- ft = {'html','css', 'javascript', 'java', 'typescript', 'typescriptreact','go', 'python', 'cpp', 'c', 'rust'},
        -- event = "InsertCharPre",
        after = { "coq.artifacts" },
        branch = "coq",
        setup = function()
            vim.g.coq_settings = { auto_start = false }
            -- vim.g.coq_settings = { auto_start = false, ['display.icons.mode'] = 'short', ['display.pum.kind_context'] = {'',''}, ['display.pum.source_context'] = {'',''} , ['display.pum.fast_close'] = false}
        end,
        config = function()
            vim.g.coq_settings = {
                auto_start = false,
                ["display.icons.mode"] = "short",
                ["display.pum.kind_context"] = { "", "" },
                ["display.pum.source_context"] = { "", "" },
                ["display.icons.spacing"] = 0,
            } -- ['display.pum.fast_close'] = false,
            if not load_coq() then
                return
            end
            vim.cmd([[COQnow]])
        end,
    }
    completion["ms-jpq/coq.thirdparty"] = {
        after = { "coq_nvim" },
        -- event = "InsertEnter",
        branch = "3p",
        config = function()
            if not load_coq() then
                return
            end
            require("coq_3p")({ { src = "nvimlua", short_name = "", conf_only = true } })
        end,
    }

    completion["ms-jpq/coq.artifacts"] = {
        -- opt = true,
        event = "InsertEnter",
        branch = "artifacts",
    }
else
    completion["ms-jpq/coq_nvim"] = { opt = true }
    completion["ms-jpq/coq.thirdparty"] = { opt = true }
    completion["ms-jpq/coq.artifacts"] = { opt = true }
end

completion["https://github.com/github/copilot.vim.git"] = {
    event = "InsertEnter",
    after = "nvim-cmp",
    keys = {
        "<Plug>(copilot-next)",
        "<Plug>(copilot-previous)",
    },
    setup = function()
        local default_keymaps = {
            { "i", "<A-,>", "<Plug>(copilot-next)" },
            { "i", "<A-.>", "<Plug>(copilot-previous)" },
        }
        for _, m in ipairs(default_keymaps) do
            vim.keymap.set(m[1], m[2], m[3], { silent = true })
        end
    end,

    config = function()
        vim.opt.completeopt = "menuone,noselect"
        vim.g.copilot_enabled = false
        -- Have copilot play nice with nvim-cmp.
        vim.g.copilot_no_tab_map = true
        vim.g.copilot_assume_mapped = true
        vim.g.copilot_tab_fallback = ""
        local excluded_filetypes = { "norg", "nofile", "prompt" }
        local copilot_filetypes = {}
        for _, ft in pairs(excluded_filetypes) do
            copilot_filetypes[ft] = false
        end

        vim.g["copilot_filetypes"] = copilot_filetypes
    end,
}

-- loading sequence LuaSnip -> nvim-cmp -> cmp_luasnip -> cmp-nvim-lua -> cmp-nvim-lsp ->cmp-buffer -> friendly-snippets
-- hrsh7th
-- Iron-E
completion["hrsh7th/nvim-cmp"] = {
    branch = "dev",
    -- opt = true,
    event = { "InsertEnter", "CmdLineEnter", "InsertCharPre" }, -- InsertCharPre Due to luasnip
    -- ft = {'lua', 'markdown',  'yaml', 'json', 'sql', 'vim', 'sh', 'sql', 'vim', 'sh'},
    after = { "LuaSnip" }, -- "nvim-snippy",
    requires = {
        {
            "tzachar/cmp-tabnine",
            run = "./install.sh",
            after = "nvim-cmp",
            config = conf.tabnine,
            opt = true,
        },
        -- { "hrsh7th/cmp-nvim-lsp-signature-help", after = "nvim-cmp", opt = true },
        { "kdheepak/cmp-latex-symbols", after = "nvim-cmp", opt = true },
        { "hrsh7th/cmp-buffer", after = "nvim-cmp", opt = true },
        { "hrsh7th/cmp-nvim-lua", after = "nvim-cmp", opt = true },
        { "hrsh7th/cmp-calc", after = "nvim-cmp", opt = true },
        { "hrsh7th/cmp-path", after = "nvim-cmp", opt = true },
        { "hrsh7th/cmp-cmdline", after = "nvim-cmp", opt = true },
        { "ray-x/cmp-treesitter", after = "nvim-cmp", opt = true },
        { "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp", opt = true },
        { "f3fora/cmp-spell", after = "nvim-cmp", opt = true },
        { "octaltree/cmp-look", after = "nvim-cmp", opt = true },
        -- {"quangnguyen30192/cmp-nvim-ultisnips", event = "InsertCharPre", after = "nvim-cmp", opt=true },
        { "saadparwaiz1/cmp_luasnip", after = { "nvim-cmp", "LuaSnip" } },
    },
    config = function()
        require("modules.completion.cmp")
    end,
}
-- can not lazyload, it is also slow...
completion["L3MON4D3/LuaSnip"] = { -- need to be the first to load
    event = "InsertEnter",
    module = "luasnip",
    requires = {
        { "rafamadriz/friendly-snippets", event = "InsertEnter" },
    }, -- , event = "InsertEnter"
    config = conf.luasnip,
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

completion["nvim-lua/plenary.nvim"] = {
    module = "plenary",
}

completion["nvim-telescope/telescope.nvim"] = {
    module = { "telescope", "utils.telescope" },
    config = conf.telescope,
    setup = conf.telescope_preload,
    requires = {
        { "nvim-lua/popup.nvim", opt = true }, -- test
        { "nvim-neorg/neorg-telescope", branch = "feat/gtd_pickers", opt = true },
        { "nvim-lua/plenary.nvim", opt = true },
        { "nvim-telescope/telescope-fzy-native.nvim", opt = true },
        { "nvim-telescope/telescope-fzf-native.nvim", run = "make", opt = true },
        { "nvim-telescope/telescope-live-grep-raw.nvim", opt = true },
        { "nvim-telescope/telescope-file-browser.nvim", opt = true },
    },
    opt = true,
}

completion["mattn/emmet-vim"] = {
    event = "InsertEnter",
    ft = {
        "html",
        "css",
        "javascript",
        "javascriptreact",
        "vue",
        "typescript",
        "typescriptreact",
        "scss",
        "sass",
        "less",
        "jade",
        "haml",
        "elm",
    },
    setup = conf.emmet,
}

-- note: part of the code is used in navigator
completion["ray-x/lsp_signature.nvim"] = {
    opt = true,
    config = function()
        require("lsp_signature").setup({
            bind = true,
            -- doc_lines = 4,
            toggle_key = "<C-x>",
            floating_window = true,
            floating_window_above_cur_line = true,
            hint_enable = true,
            use_lspsaga = false,
            fix_pos = false,
            -- floating_window_above_first = true,
            log_path = vim.fn.expand("$HOME") .. "/tmp/sig.log",
            -- hi_parameter = "Search",
            zindex = 1002,
            timer_interval = 100,
            extra_trigger_chars = {},
            -- handler_opts = {
            --   border = { "🭽", "▔", "🭾", "▕", "🭿", "▁", "🭼", "▏" },
            -- },
            max_height = 4,
        })
    end,
}

-- This too should also be lazy loaded
completion["weilbith/nvim-code-action-menu"] = {
    cmd = "CodeActionMenu",
    ft = { "python", "lua", "c", "java", "prolog", "lisp", "cpp" },
}

completion["dense-analysis/ale"] = {
    -- Maybe just for python and C ? - not sure
    ft = {
        "python",
        "norg",
    },
    opt = true,
    -- Test out norg files
    config = conf.ale,
}

completion["~/GitHub/vim-sonictemplate"] = {
    cmd = "Template",
    config = conf.vim_sonictemplate,
}

return completion
