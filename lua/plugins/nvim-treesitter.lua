require("nvim-treesitter.configs").setup({
    ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "rust", "javascript", "cpp", "zig" },

    sync_install = false,
    auto_install = false,

    highlight = {
        enable = true,
    },
})
