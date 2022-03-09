local function prequire(...)
    local status, lib = pcall(require, ...)
    if status then
        return lib
    end
    return nil
end

local luasnip = prequire("luasnip")
local cmp = prequire("cmp")

local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col(".") - 1
    if col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
        return true
    else
        return false
    end
end

_G.tab_complete = function()
    if cmp and cmp.visible() then
        cmp.select_next_item()
    elseif luasnip and luasnip.expand_or_jumpable() then
        return t("<Plug>luasnip-expand-or-jump")
    elseif check_back_space() then
        return t("<Tab>")
    else
        cmp.complete()
    end
    return ""
end
_G.s_tab_complete = function()
    if cmp and cmp.visible() then
        cmp.select_prev_item()
    elseif luasnip and luasnip.jumpable(-1) then
        return t("<Plug>luasnip-jump-prev")
    else
        return t("<S-Tab>")
    end
    return ""
end

_G.syn_stack = function()
    local c = vim.api.nvim_win_get_cursor(0)
    local stack = vim.fn.synstack(c[1], c[2] + 1)
    for i, l in ipairs(stack) do
        stack[i] = vim.fn.synIDattr(l, "name")
    end
    print(vim.inspect(stack))
end

-- change case of cword
_G.caseChange = function()
    local cursor = vim.api.nvim_win_get_cursor(0)
    vim.api.nvim_feedkeys("b~", "n", true)
    vim.defer_fn(function()
        vim.api.nvim_win_set_cursor(0, cursor)
    end, 1)
end

_G.toggle_venn = function()
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
end

-- _G.enhance_jk_move = function()
--   return "fo:qP:"
-- end

_G.toggleCopilot = function()
    if vim.fn["copilot#Enabled"]() == 1 then
        vim.cmd([[ Copilot disable ]])
    else
        vim.cmd([[ Copilot enable ]])
    end
    vim.cmd([[ Copilot status ]])
end

_G.word_motion_move = function(key)
    if not packer_plugins["vim-wordmotion"] or not packer_plugins["vim-wordmotion"].loaded then
        vim.cmd([[packadd vim-wordmotion]])
    end

    local map = key == "w" and "<Plug>(WordMotion_w)" or "<Plug>(WordMotion_b)"
    return t(map)
end

_G.word_motion_move_b = function(key)
    if not packer_plugins["vim-wordmotion"] or not packer_plugins["vim-wordmotion"].loaded then
        vim.cmd([[packadd vim-wordmotion]])
    end

    local map = key == "b" and "<Plug>(WordMotion_b)"
    return t(map)
end

_G.word_motion_move_gE = function(key)
    if not packer_plugins["vim-wordmotion"] or not packer_plugins["vim-wordmotion"].loaded then
        vim.cmd([[packadd vim-wordmotion]])
    end
    local map = key == "gE" and "<Plug>(WordMotion_gE)"
    return t(map)
end
