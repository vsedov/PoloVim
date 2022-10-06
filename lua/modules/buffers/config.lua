local config = {}

function config.reach()
    require("reach").setup({
        notifications = true,
    })
end

function config.scope_setup()
    vim.api.nvim_create_autocmd({ "BufAdd", "TabEnter" }, {
        pattern = "*",
        group = vim.api.nvim_create_augroup("scope_loading", {}),
        callback = function()
            local count = #vim.fn.getbufinfo({ buflisted = 1 })
            if count >= 2 then
                require("packer").loader("scope.nvim")
            end
        end,
    })
end

function config.scope()
    require("scope").setup()
end

function config.close_buffers()
    require("close_buffers").setup({
        preserve_window_layout = { "this" },
        next_buffer_cmd = function(windows)
            require("bufferline").cycle(1)
            local bufnr = vim.api.nvim_get_current_buf()

            for _, window in ipairs(windows) do
                vim.api.nvim_win_set_buf(window, bufnr)
            end
        end,
    })
    vim.api.nvim_create_user_command("Kwbd", function()
        require("close_buffers").delete({ type = "this" })
    end, { range = true })
end

function config.bbye()
    vim.keymap.set("n", "_q", "<Cmd>Bwipeout<CR>", { silent = true })
end

return config
