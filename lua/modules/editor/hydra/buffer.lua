local Hydra = require("hydra")

local hint = [[
  ^^^^                Bufferline                  ^^^^
  ^^^^--------------------------------------------^^^^  
   _l_: BufferLineCycleNext _h_: BufferLineCyclePrev
   _p_: BufferLineTogglePin _c_: BufferLinePick
  ^^^^--------------------------------------------^^^^  
  ^^^^                Delete                      ^^^^
  ^^^^--------------------------------------------^^^^  
   _qh_: Del Hidden _qn_: Del NameLess _qt_: Del This

   _d_: Bwipeout   _D_: BufferLinePickClose 
]]

Hydra({
    hint = hint,
    name = "Buffer management",
    mode = "n",
    body = "<leader>b",
    color = "teal",
    config = {
        hint = { border = "single" },
        invoke_on_body = true,
    },
    heads = {
        { "l", "<Cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" } },
        { "h", "<Cmd>BufferLineCyclePrev<CR>", { desc = "Prev buffer" } },
        { "p", "<Cmd>BufferLineTogglePin<CR>", { desc = "Pin buffer" } },
        { "c", "<Cmd>BufferLinePick<CR>", { desc = "Pin buffer" } },
        { "d", "<Cmd>Bwipeout<CR>", { desc = "delete buffer" } },
        { "D", "<Cmd>BufferLinePickClose<CR>", { desc = "Pick buffer to close", exit = true } },
        { "<Esc>", nil, { exit = true, desc = "Quit" } },

        { "qh", "<cmd>BDelete hidden<CR>" },
        { "qn", "<cmd>BDelete! nameless<CR>" },
        { "qt", "<cmd>BDelete! this<CR>" },
    },
})

local buffer_hydra = Hydra({
    name = "Barbar",
    config = {
        on_key = function()
            -- Preserve animation
            vim.wait(200, function()
                vim.cmd("redraw")
            end, 30, false)
        end,
    },

    heads = {
        {
            "h",
            function()
                vim.cmd("BufferPrevious")
            end,
            { on_key = false },
        },
        {
            "l",
            function()
                vim.cmd("BufferNext")
            end,
            { desc = "choose", on_key = false },
        },

        {
            "H",
            function()
                vim.cmd("BufferMovePrevious")
            end,
        },
        {
            "L",
            function()
                vim.cmd("BufferMoveNext")
            end,
            { desc = "move" },
        },

        {
            "p",
            function()
                vim.cmd("BufferPin")
            end,
            { desc = "pin" },
        },

        {
            "d",
            function()
                vim.cmd("BufferClose")
            end,
            { desc = "close" },
        },
        {
            "c",
            function()
                vim.cmd("BufferClose")
            end,
            { desc = false },
        },
        {
            "q",
            function()
                vim.cmd("BufferClose")
            end,
            { desc = false },
        },

        {
            "od",
            function()
                vim.cmd("BufferOrderByDirectory")
            end,
            { desc = "by directory" },
        },
        {
            "ol",
            function()
                vim.cmd("BufferOrderByLanguage")
            end,
            { desc = "by language" },
        },
        { "<Esc>", nil, { exit = true } },
    },
})

local function choose_buffer()
    if #vim.fn.getbufinfo({ buflisted = true }) > 1 then
        buffer_hydra:activate()
    end
end

vim.keymap.set("n", "<leadeR>gb", choose_buffer)
