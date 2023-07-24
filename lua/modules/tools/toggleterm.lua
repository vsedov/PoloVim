local toggleterm = require("toggleterm")
local Terminal = require("toggleterm.terminal").Terminal

-- Function to remove keymaps "jk" and "<esc>" from the terminal buffer
local function float_handler(term)
    if vim.fn.mapcheck("jk", "t") ~= "" then
        vim.api.nvim_buf_del_keymap(term.bufnr, "t", "jk")
        vim.api.nvim_buf_del_keymap(term.bufnr, "t", "<esc>")
    end
end

-- Define terminals
local terminals = {
    Htop = Terminal:new({
        cmd = "htop",
        hidden = true,
        direction = "float",
        on_open = float_handler,
    }),
    Ghdash = Terminal:new({
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
    }),
    Nap = Terminal:new({
        cmd = "nap",
        hidden = true,
        direction = "float",
        on_open = float_handler,
    }),
}

-- Set keymap bindings using a table
local keymaps = {
    { "<Leader>t0", "<cmd>ToggleTermToggleAll<CR>", desc = "Toggle display all terminals" },
    { "<Leader>t1", "<cmd>1ToggleTerm<CR>", desc = "Toggle terminal with id 1" },
    { "<Leader>t2", "<cmd>2ToggleTerm<CR>", desc = "Toggle terminal with id 2" },
    { "<Leader>t3", "<cmd>3ToggleTerm<CR>", desc = "Toggle terminal with id 3" },
    { "<Leader>t4", "<cmd>4ToggleTerm<CR>", desc = "Toggle terminal with id 4" },
    {
        "<Leader>t!",
        [[<cmd>execute v:count . "TermExec cmd='exit;'"<CR>]],
        silent = true,
        desc = "Quit terminal",
    },
    {
        "<Leader>gh",
        function()
            Terminal:new({ cmd = "lazygit", hidden = true }):toggle()
        end,
    },
    { "<leader>tf", "<cmd>ToggleTerm direction='vertical'<cr>" },
    { "<leader>th", "<cmd>ToggleTerm direction='vertical'<cr>" },
}

-- Create keymap bindings from the table
for _, mapping in ipairs(keymaps) do
    vim.keymap.set("n", mapping[1], mapping[2], mapping[3] or {})
end

-- captilize

-- Create commands to toggle terminals
for name, terminal in pairs(terminals) do
    lambda.command(name, function()
        terminal:toggle()
    end, {})
end

-- Configure toggleterm
toggleterm.setup({
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
