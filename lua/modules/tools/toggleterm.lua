local exp = vim.fn.expand
local nore_silent = { noremap = true, silent = true }

require("toggleterm").setup({
    open_mapping = [[<c-t>]],
    shade_filetypes = { "none" },
    direction = "horizontal",
    insert_mappings = false,
    start_in_insert = true,
    float_opts = { border = "rounded", winblend = 3 },
    size = function(term)
        if term.direction == "horizontal" then
            return 15
        elseif term.direction == "vertical" then
            return math.floor(vim.o.columns * 0.4)
        end
    end,
})

vim.keymap.set("n", "<Leader>gh", function()
    require("toggleterm.terminal").Terminal:new({ cmd = "lazygit", hidden = true }):toggle()
end)

vim.keymap.set("n", "<leader>tf", "<cmd>ToggleTerm direction='vertical'<cr>")
vim.keymap.set("n", "<leader><Tab>", "<cmd>ToggleTerm direction='float'<cr>")

local float_handler = function(term)
    if vim.fn.mapcheck("jk", "t") ~= "" then
        vim.api.nvim_buf_del_keymap(term.bufnr, "t", "jk")
        vim.api.nvim_buf_del_keymap(term.bufnr, "t", "<esc>")
    end
end

local Terminal = require("toggleterm.terminal").Terminal

local htop = Terminal:new({
    cmd = "htop",
    hidden = true,
    direction = "float",
    on_open = float_handler,
})

local gh_dash = Terminal:new({
    cmd = "gh dash",
    hidden = true,
    direction = "float",
    on_open = float_handler,
    float_opts = {
        height = function()
            return math.floor(vim.o.lines * 0.8)
        end,
        width = function()
            return math.floor(vim.o.columns * 0.95)
        end,
    },
})

local nap = Terminal:new({
    cmd = "nap",
    hidden = true,
    direction = "float",
    on_open = float_handler,
})

vim.api.nvim_create_user_command("GDash", function()
    gh_dash:toggle()
end, {})

vim.api.nvim_create_user_command("Htop", function()
    htop:toggle()
end, {})

vim.api.nvim_create_user_command("Nap", function()
    nap:toggle()
end, {})
