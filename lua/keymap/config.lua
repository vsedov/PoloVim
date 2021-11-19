local function check_back_space()
	local col = vim.fn.col(".") - 1
	if col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
		return true
	else
		return false
	end
end

local t = function(str)
	return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local is_prior_char_whitespace = function()
	local col = vim.fn.col(".") - 1
	if col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
		return true
	else
		return false
	end
end

_G.ctrl_k = function()
	vim.lsp.buf.signature_help()
	vim.cmd([[:MatchupWhereAmI?]])
end

_G.enhance_jk_move = function(key)
	if packer_plugins["accelerated-jk"] and not packer_plugins["accelerated-jk"].loaded then
		vim.cmd([[packadd accelerated-jk]])
	end

	local map = key == "j" and "<Plug>(accelerated_jk_gj)" or "<Plug>(accelerated_jk_gk)"
	return t(map)
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

-- -- _G.enhance_nice_block = function(key)
-- -- 	if not packer_plugins["vim-niceblock"].loaded then
-- -- 		vim.cmd([[packadd vim-niceblock]])
-- -- 	end
-- -- 	local map = {
-- -- 		I = "<Plug>(niceblock-I)",
-- -- 		["gI"] = "<Plug>(niceblock-gI)",
-- -- 		A = "<Plug>(niceblock-A)",
-- -- 	}
-- -- 	return t(map[key])
-- -- end
