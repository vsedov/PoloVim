local loader = require("lazy").load

local lazy_timer = 30
if vim.env.KITTY_SCROLLBACK_NVIM == "true" then
else
    -- require("utils.ui.highlights")
    function set_colourscheme()
        math.randomseed(os.clock() * 100000000000)

        -- local theme = lambda.config.colourscheme.themes.dark
        -- if lambda.config.colourscheme.use_light_theme then
        --     theme = lambda.config.colourscheme.themes.light
        -- end
        --
        -- local rand = math.random(#theme)
        --
        -- require("lazy").load({ plugins = { theme[rand] } })

        require("lazy").load({ plugins = { "heirline.nvim" } })
    end
    -- set_colourscheme()
    -- user_highlights()
end
