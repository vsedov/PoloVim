local function load_colourscheme(colourscheme)
    require("utils.ui.highlights")
end
if vim.env.KITTY_SCROLLBACK_NVIM == "true" then
else
    load_colourscheme() -- loads default colourscheme
end
