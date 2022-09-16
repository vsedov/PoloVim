local config = {}

function config.telescope()
    require("utils.telescope").setup()
end
function config.bookmark()
    require("telescope").load_extension("bookmarks")
end
function config.fzf()
    require("fzf-lua").setup({
        lsp = {
            -- make lsp requests synchronous so they work with null-ls
            async_or_timeout = 3000,
        },
    })
    vim.api.nvim_set_keymap("n", "<C-p>", ":FzfLua git_files<CR>", { silent = true })
    vim.api.nvim_create_user_command("GF", "FzfLua git_status", {})
    vim.api.nvim_create_user_command("Gf", "FzfLua git_status", {})
    vim.api.nvim_create_user_command("B", "FzfLua buffers", { bang = true })
    vim.api.nvim_create_user_command("Com", "FzfLua commands", { bang = true })
    vim.api.nvim_create_user_command("Col", "FzfLua colorschemems", { bang = true })
    vim.api.nvim_create_user_command("RG", "FzfLua grep", { bang = true })
end
return config
