local bind = require("keymap.bind")
local map_cr = bind.map_cr
local map_cu = bind.map_cu
local map_cmd = bind.map_cmd
local map_args = bind.map_args

local plug_map = {
    -- Show syntax highlighting groups for word under cursor
    ["n|<localleader>c["] = map_cmd(function()
        local c = vim.api.nvim_win_get_cursor(0)
        local stack = vim.fn.synstack(c[1], c[2] + 1)
        for i, l in ipairs(stack) do
            stack[i] = vim.fn.synIDattr(l, "name")
        end
        Log:info(vim.inspect(stack))
    end, "Debug / Inspect"):with_silent(),

    -- Venv
    ["n|<localleader>V"] = map_cmd(function()
        local venn_enabled = vim.inspect(vim.b.venn_enabled)
        if venn_enabled == "nil" then
            print("Venn active")
            vim.b.venn_enabled = true
            vim.cmd([[setlocal ve=all]])
            -- draw a line on HJKL keystokes
            vim.api.nvim_buf_set_keymap(0, "n", "J", "<C-v>j:VBox<CR>", { noremap = true })
            vim.api.nvim_buf_set_keymap(0, "n", "K", "<C-v>k:VBox<CR>", { noremap = true })
            vim.api.nvim_buf_set_keymap(0, "n", "L", "<C-v>l:VBox<CR>", { noremap = true })
            vim.api.nvim_buf_set_keymap(0, "n", "H", "<C-v>h:VBox<CR>", { noremap = true })
            -- draw a box by pressing "f" with visual selection
            vim.api.nvim_buf_set_keymap(0, "v", "f", ":VBox<CR>", { noremap = true })
        else
            print("Venn inactive")

            vim.cmd([[setlocal ve=]])
            vim.cmd([[mapclear <buffer>]])
            vim.b.venn_enabled = nil
        end
    end, "Venn Toggle"):with_silent(),

    ["n|<leader>hw"] = map_cmd(function()
        if require("dynamic_help.extras.statusline").available() ~= "" then
            require("dynamic_help").float_help(vim.fn.expand("<cword>"))
        else
            local help = vim.fn.input("Help Tag> ")
            require("dynamic_help").float_help(help)
        end
    end, "Dynamic Help"):with_noremap():with_silent(),
    -- Scuffed way of doing this, but this works .

    ["n|<Leader>gr"] = map_cmd(function()
        return ":IncRename " .. vim.fn.expand("<cword>")
    end, "rename"):with_expr(),
}

return plug_map
