local mode = vim.api.nvim_get_mode().mode:sub(1, 1)
if mode == "V" then -- visual-line mode
    local esc = vim.api.nvim_replace_termcodes("<Esc>", true, true, true)
    vim.api.nvim_feedkeys(esc, "x", false) -- exit visual mode
    vim.cmd("'<,'>Gitsigns stage_hunk")
else
    vim.cmd("Gitsigns stage_hunk")
end
