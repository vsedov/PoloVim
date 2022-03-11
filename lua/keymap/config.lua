-- change case of cword
_G.caseChange = function()
    local cursor = vim.api.nvim_win_get_cursor(0)
    vim.api.nvim_feedkeys("b~", "n", true)
    vim.defer_fn(function()
        vim.api.nvim_win_set_cursor(0, cursor)
    end, 1)
end

-- _G.toggle_venn =

-- _G.enhance_jk_move = function()
--   return "fo:qP:"
-- end

-- _G.word_motion_move = function(key)
--     if not packer_plugins["vim-wordmotion"] or not packer_plugins["vim-wordmotion"].loaded then
--         vim.cmd([[packadd vim-wordmotion]])
--     end

--     local map = key == "w" and "<Plug>(WordMotion_w)" or "<Plug>(WordMotion_b)"
--     return t(map)
-- end

-- _G.word_motion_move_b = function(key)
--     if not packer_plugins["vim-wordmotion"] or not packer_plugins["vim-wordmotion"].loaded then
--         vim.cmd([[packadd vim-wordmotion]])
--     end

--     local map = key == "b" and "<Plug>(WordMotion_b)"
--     return t(map)
-- end

-- _G.word_motion_move_gE = function(key)
--     if not packer_plugins["vim-wordmotion"] or not packer_plugins["vim-wordmotion"].loaded then
--         vim.cmd([[packadd vim-wordmotion]])
--     end
--     local map = key == "gE" and "<Plug>(WordMotion_gE)"
--     return t(map)
-- end
