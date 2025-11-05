local Hydra = require("hydra")

local reach_options = {
    handle = "dynamic",
    show_current = true,
    sort = function(a, b)
        return vim.fn.getbufinfo(a)[1].lastused > vim.fn.getbufinfo(b)[1].lastused
    end,
}

local buffer_config = function()
    local function smart_close()
        -- Prefer close-buffers.nvim if available, otherwise plain :bdelete
        local ok = pcall(vim.cmd, "BDelete this")
        if not ok then
            vim.cmd("bdelete")
        end
    end

    local hint = [[
  ^^^^                Bufferline                  ^^^^
  ^^^^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^^^^
   _l_: next                _h_: prev
   _H_: move left           _L_: move right
   _p_: toggle pin          _c_: pick buffer
   _D_: pick & close

   _ot_: sort by tabs       _od_: sort by dir
   _or_: sort by rel dir    _b_: Telescope buffers

  ^^^^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^^^^
  ^^^^               BufferJumper                 ^^^^
  ^^^^▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁^^^^

        _1_: Jump 1    _2_: Jump 2    _3_: Jump 3
        _4_: Jump 4    _5_: Jump 5    _6_: Jump 6
        _7_: Jump 7    _8_: Jump 8    _9_: Jump 9
                     _0_: Jump 10
                     _#_: last buffer

  ^^^^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^^^^
  ^^^^                  Tabs                      ^^^^
  ^^^^▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁^^^^

    _[_: prev tab                    _]_: next tab
    _n_: new tab                     _C_: close tab
    _>_: move right                  _<_: move left
                    _P_: tab only

  ^^^^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^^^^
  ^^^^                   Delete                   ^^^^
  ^^^^▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁^^^^

   _qh_: Del Hidden _qn_: Del NameLess _qt_: Del This
   _d_: Bwipeout    _q_: Smart Close   _Q_: Force Close

  ^^^^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^^^^
  ^^^^                   Reacher                  ^^^^
  ^^^^▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁^^^^

    _S_: ReachOpen buffers   _s_: ReachOpen Tabs

   _<Esc>_: Quit
]]

    local config = {
        name = "Buffer / Tab management",
        hint = hint,
        mode = "n",
        color = "teal",
        body = "<leader>b",
        config = {
            hint = { border = "single", position = "bottom-right" },
            invoke_on_body = true,
        },
        heads = {
            ------------------------------------------------------------------ Bufferline nav
            { "l", "<Cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" } },
            { "h", "<Cmd>BufferLineCyclePrev<CR>", { desc = "Prev buffer" } },

            { "H", "<Cmd>BufferLineMovePrev<CR>",  { desc = "Move buffer left" } },
            { "L", "<Cmd>BufferLineMoveNext<CR>",  { desc = "Move buffer right" } },

            { "p", "<Cmd>BufferLineTogglePin<CR>", { desc = "Toggle pin" } },
            { "c", "<Cmd>BufferLinePick<CR>",      { desc = "Pick buffer" } },
            { "D", "<Cmd>BufferLinePickClose<CR>", { desc = "Pick & close", exit = true } },

            ------------------------------------------------------------------ Sorting
            { "ot", "<Cmd>BufferLineSortByTabs<CR>",              { desc = "Sort by tabs", exit = true } },
            { "od", "<Cmd>BufferLineSortByDirectory<CR>",         { desc = "Sort by directory", exit = true } },
            { "or", "<Cmd>BufferLineSortByRelativeDirectory<CR>", { desc = "Sort by relative dir", exit = true } },

            ------------------------------------------------------------------ Jump / buffer index
            { "1", "<Cmd>BufferLineGoToBuffer 1<CR>", { desc = "Go to buffer 1" } },
            { "2", "<Cmd>BufferLineGoToBuffer 2<CR>", { desc = "Go to buffer 2" } },
            { "3", "<Cmd>BufferLineGoToBuffer 3<CR>", { desc = "Go to buffer 3" } },
            { "4", "<Cmd>BufferLineGoToBuffer 4<CR>", { desc = "Go to buffer 4" } },
            { "5", "<Cmd>BufferLineGoToBuffer 5<CR>", { desc = "Go to buffer 5" } },
            { "6", "<Cmd>BufferLineGoToBuffer 6<CR>", { desc = "Go to buffer 6" } },
            { "7", "<Cmd>BufferLineGoToBuffer 7<CR>", { desc = "Go to buffer 7" } },
            { "8", "<Cmd>BufferLineGoToBuffer 8<CR>", { desc = "Go to buffer 8" } },
            { "9", "<Cmd>BufferLineGoToBuffer 9<CR>", { desc = "Go to buffer 9" } },
            { "0", "<Cmd>BufferLineGoToBuffer 10<CR>", { desc = "Go to buffer 10" } },

            { "#", "<Cmd>b#<CR>", { desc = "Alternate buffer" } },

            { "b", "<Cmd>Telescope buffers<CR>", { desc = "Telescope buffers", exit = true } },

            ------------------------------------------------------------------ Tabs
            { "[", "<Cmd>tabprevious<CR>", { desc = "Prev tab" } },
            { "]", "<Cmd>tabnext<CR>",     { desc = "Next tab" } },

            { "n", "<Cmd>$tabnew<CR>",     { desc = "New tab" } },
            { "C", "<Cmd>tabclose<CR>",    { desc = "Close tab" } },

            { ">", "<Cmd>+tabmove<CR>",    { desc = "Move tab right" } },
            { "<", "<Cmd>-tabmove<CR>",    { desc = "Move tab left" } },

            { "P", "<Cmd>tabonly<CR>",     { desc = "Tab only", exit = true } },

            ------------------------------------------------------------------ Delete / close
            { "qh", "<Cmd>BDelete hidden<CR>",    { desc = "Delete hidden buffers" } },
            { "qn", "<Cmd>BDelete! nameless<CR>", { desc = "Delete nameless buffers" } },
            { "qt", "<Cmd>BDelete! this<CR>",     { desc = "Delete this buffer" } },

            { "d", "<Cmd>Bwipeout<CR>",           { desc = "Wipeout buffer" } },

            { "q", function() smart_close() end,  { desc = "Smart close", exit = true } },
            { "Q", "<Cmd>BDelete! this<CR>",      { desc = "Force close buffer", exit = true } },

            ------------------------------------------------------------------ Reacher
            { "S", ":ReachOpen buffers<CR>",   { desc = "Reach: buffers", exit = true } },
            { "s", ":ReachOpen tabpages<CR>",  { desc = "Reach: tabs", exit = true } },

            ------------------------------------------------------------------ Misc
            { "<Esc>", nil, { exit = true, desc = "Quit Hydra" } },
        },
    }

    Hydra(config)
end

return {
    buffer = buffer_config,
}

