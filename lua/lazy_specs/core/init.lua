-- Core plugins from rocks.toml that need to be installed
-- These are essential dependencies and core plugins
return {
    -- Core dependencies
    { "nvim-lua/plenary.nvim" },
    { "nvim-tree/nvim-web-devicons" },
    { "MunifTanjim/nui.nvim" },
    { "nvim-neotest/nvim-nio" },
    { "kkharji/sqlite.lua" },

    -- Notification
    { "rcarriga/nvim-notify" },

    -- Treesitter
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

    -- LSP & Completion
    { "neovim/nvim-lspconfig" },
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },
    { "onsails/lspkind.nvim" },

    -- Snippets
    { "L3MON4D3/LuaSnip" },
    { "rafamadriz/friendly-snippets" },
    { "evesdropper/luasnip-latex-snippets.nvim" },

    -- Completion with blink.cmp
    { "Saghen/blink.cmp", build = "cargo build --release" },
    { "Saghen/blink.compat" },
    { "saadparwaiz1/cmp_luasnip" },
    { "CKolkey/colorful-menu.nvim" },

    -- Autopairs & Surround
    { "windwp/nvim-autopairs" },
    { "kylechui/nvim-surround" },

    -- Telescope
    { "nvim-telescope/telescope.nvim" },
    { "natecraddock/telescope-zf-native.nvim" },

    -- UI enhancements
    { "stevearc/dressing.nvim" },
    { "Bekaboo/dropbar.nvim" },
    { "j-hui/fidget.nvim" },
    { "lukas-reineke/indent-blankline.nvim" },
    { "folke/trouble.nvim" },
    { "folke/edgy.nvim" },

    -- File navigation
    { "stevearc/oil.nvim" },
    { "mikavilpas/yazi.nvim" },

    -- Git
    { "lewis6991/gitsigns.nvim" },

    -- Utilities
    { "akinsho/toggleterm.nvim" },
    { "kevinhwang91/nvim-ufo", dependencies = { "kevinhwang91/promise-async" } },
    { "gbprod/yanky.nvim" },
    { "gbprod/substitute.nvim" },
    { "famiu/bufdelete.nvim" },
    { "chrisgrieser/nvim-various-textobjs" },
    { "NMAC427/guess-indent.nvim" },
    { "mrjones2014/smart-splits.nvim" },
    { "hiphish/rainbow-delimiters.nvim" },

    -- Flash (navigation)
    { "folke/flash.nvim" },

    -- Better escape
    { "max397574/better-escape.nvim" },

    -- Misc
    { "nvim-pack/nvim-spectre" },
    { "debugloop/layers.nvim" },
}
