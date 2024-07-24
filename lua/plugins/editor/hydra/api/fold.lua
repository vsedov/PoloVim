local leader = "<leader><leader>z"
local api = vim.api
local function nN(char)
    local ok, winid = require("hlslens").nNPeekWithUFO(char)
    if ok and winid then
        -- Safe to override buffer scope keymaps remapped by ufo,
        -- ufo will restore previous buffer keymaps before closing preview window
        -- Type <CR> will switch to preview window and fire `trace` action
        vim.keymap.set("n", "<CR>", function()
            local keyCodes = vim.keycode("<Tab><CR>", true, false, true)
            api.nvim_feedkeys(keyCodes, "im", false)
        end, { buffer = true })
    end
end
local config = {
    Fold = {
        color = "pink",
        body = leader,
        mode = { "n" },
        ["<ESC>"] = { nil, { exit = true } },
        N = {
            function()
                nN("N")
            end,
            { silent = true, exit = false, desc = "hlslens.nNPeekWithUFO('N')" },
        },
        n = {
            function()
                nN("n")
            end,
            { silent = true, exit = false, desc = "hlslens.nNPeekWithUFO('n')" },
        },
        w = {
            function()
                vim.ui.input({ prompt = "Enter Fold Ammount", default = "4" }, function(fold)
                    require("foldcus").fold(tonumber(fold))
                end)
            end,
            { silent = true, nowait = true, exit = true, desc = "Fold Multiline" },
        },
        W = {
            function()
                vim.ui.input({ prompt = "Enter Fold Ammount", default = "4" }, function(fold)
                    require("foldcus").unfold(tonumber(fold))
                end)
            end,
            { silent = true, nowait = true, exit = true, desc = "Unfold Multiline Longer than 4" },
        },
        R = {
            function()
                require("ufo").openAllFolds()
            end,
            { silent = true, nowait = true, exit = true, desc = "Open all folds" },
        },
        M = {
            function()
                require("ufo").closeAllFolds()
            end,
            { silent = true, nowait = true, exit = true, desc = "Close all folds" },
        },
        r = {
            function()
                require("ufo").openFoldsExceptKinds()
            end,
            { silent = true, nowait = true, exit = true, desc = "Open folds except kinds" },
        },
        m = {
            function()
                require("ufo").closeFoldsWithKinds()
            end,
            { silent = true, nowait = true, exit = true, desc = "Close folds with kinds" },
        },
        L = {
            function()
                require("fold-cycle").open_all()
            end,
            { exit = true, desc = "open folds underneath" },
        },
        K = {
            function()
                require("fold-cycle").close_all()
            end,
            { exit = true, desc = "close folds underneath" },
        },
        j = {
            "zj",
            { exit = false, desc = "next fold" },
        },
        k = {
            "zk",
            { exit = false, desc = "previous fold" },
        },
    },
}
return {
    config,
    "Fold",
    { { "W", "w", "R", "M", "r", "m", "L", "K" } },
    { "j", "k", "n", "N" },
    6,
    3,
}
