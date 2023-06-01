require("terminal").setup()

local term_map = require("terminal.mappings")
vim.keymap.set(
    { "n", "x" },
    "<leader>ts",
    term_map.operator_send,
    { expr = true, desc = "Operat1or: send to terminal" }
)
vim.keymap.set("n", "<leader>to", term_map.toggle, { desc = "toggle terminal" })
vim.keymap.set("n", "<c-t>", term_map.toggle({ open_cmd = "enew" }), { desc = "toggle terminal" })
vim.keymap.set("n", "<leader>tr", term_map.run, { desc = "run terminal" })
vim.keymap.set("n", "<leader>tR", term_map.run(nil, { layout = { open_cmd = "enew" } }), { desc = "run terminal" })
vim.keymap.set("n", "<leader>tk", term_map.kill, { desc = "kill terminal" })
vim.keymap.set("n", "<leader>t]", term_map.cycle_next, { desc = "cycle terminal" })
vim.keymap.set("n", "<leader>t[", term_map.cycle_prev, { desc = "cycle terminal" })
vim.keymap.set("n", "<leader>tl", term_map.move({ open_cmd = "belowright vnew" }), { desc = "move terminal" })
vim.keymap.set("n", "<leader>tL", term_map.move({ open_cmd = "botright vnew" }), { desc = "move terminal" })
vim.keymap.set("n", "<leader>th", term_map.move({ open_cmd = "belowright new" }), { desc = "move terminal" })
vim.keymap.set("n", "<leader>tH", term_map.move({ open_cmd = "botright new" }), { desc = "move terminal" })
vim.keymap.set("n", "<leader>tf", term_map.move({ open_cmd = "float" }), { desc = "move terminal" })

local ipython = require("terminal").terminal:new({
    layout = { open_cmd = "botright vertical new" },
    cmd = { "ipython" },
    autoclose = true,
})

vim.api.nvim_create_user_command("IPython", function()
    ipython:toggle(nil, true)
    local bufnr = vim.api.nvim_get_current_buf()
    vim.keymap.set("x", "<leader>ts", function()
        vim.api.nvim_feedkeys('"+y', "n", false)
        ipython:send("%paste")
    end, { buffer = bufnr })
    vim.keymap.set("n", "<leader>t?", function()
        ipython:send(vim.fn.expand("<cexpr>") .. "?")
    end, { buffer = bufnr })
end, {})

local lazygit = require("terminal").terminal:new({
    layout = { open_cmd = "float", height = 0.9, width = 0.9 },
    cmd = { "lazygit" },
    autoclose = true,
})

vim.api.nvim_create_user_command("LazygitTerm", function(args)
    lazygit.cwd = args.args and vim.fn.expand(args.args)
    lazygit:toggle(nil, true)
end, { nargs = "?" })

local htop = require("terminal").terminal:new({
    layout = { open_cmd = "float" },
    cmd = { "htop" },
    autoclose = true,
})
vim.api.nvim_create_user_command("HtopTerm", function()
    htop:toggle(nil, true)
end, { nargs = "?" })

vim.api.nvim_create_autocmd({ "WinEnter", "BufWinEnter", "TermOpen" }, {
    callback = function(args)
        if vim.startswith(vim.api.nvim_buf_get_name(args.buf), "term://") then
            vim.cmd("startinsert")
        end
    end,
})
