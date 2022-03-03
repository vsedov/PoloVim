local function check_back_space()
  local col = vim.fn.col(".") - 1
  if col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
    return true
  else
    return false
  end
end

local function prequire(name)
  local module_found, res = pcall(require, name)
  return module_found and res or nil
end

local is_prior_char_whitespace = function()
  local col = vim.fn.col(".") - 1
  if col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
    return true
  else
    return false
  end
end

local function termcodes(code)
  return vim.api.nvim_replace_termcodes(code, true, true, true)
end

local t = termcodes

_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t("<C-n>")
  elseif check_back_space() then
    return t("<Tab>")
  elseif prequire("luasnip") and require("luasnip").expand_or_jumpable() then
    return t("<Plug>luasnip-expand-or-jump")
  elseif prequire("cmp") and require("cmp").visible() then
    return require("cmp").mapping.select_next_item()
  end
  return t("<Tab>")
end

_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t("<C-p>")
  elseif prequire("luasnip") and prequire("luasnip").jumpable(-1) then
    return t("<Plug>luasnip-jump-prev")
  elseif prequire("cmp") and require("cmp").visible() then
    return require("cmp").mapping.select_prev_item()
  end
  return t("<S-Tab>")
end

_G.toggle_venn = function()
  local venn_enabled = vim.inspect(vim.b.venn_enabled)
  if venn_enabled == "nil" then
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
