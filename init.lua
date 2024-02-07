-- add kitty-scrollback.nvim to the runtimepath to allow us to require the kitty-scrollback module
-- pick a runtimepath that corresponds with your package manager, if you are not sure leave them all it will not cause any issues
vim.opt.runtimepath:append(vim.fn.stdpath("data") .. "/lazy/kitty-scrollback.nvim") -- lazy.nvim
if vim.env.KITTY_SCROLLBACK_NVIM == "true" then
    print("kitty-scrollback.nvim: kitty-scrollback is enabled")
else
    require("core")
    local function load_colourscheme(colourscheme)
        require("utils.ui.highlights")
    end
    load_colourscheme() -- loads default colourscheme
end
