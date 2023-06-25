local config = {}
function config.animate()
    local animate = require("mini.animate")

    animate.setup({
        -- Cursor path
        cursor = {
            -- Whether to enable this animation
            enable = true,
            --<function: implemenmini linear total 250ms animation duration>,
            timing = animate.gen_timing.linear({ duration = 150, unit = "total" }),
        },
        -- Vertical scroll
        scroll = {
            enable = false,
            timing = animate.gen_timing.linear({ duration = 150, unit = "total" }),
            subscroll = animate.gen_subscroll.equal({ max_output_steps = 60 }),
        },
        -- Window resize -- we use the animation library that comes with windows.nvim instead
        resize = {
            enable = false,
        },
        -- Window open
        open = {
            enable = false,
        },
        -- Window close
        close = {
            enable = false,
        },
    })
end
return config
