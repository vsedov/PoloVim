local config = {}
function config.overlen()
    require("overlength").setup({
        -- Overlength highlighting enabled by default
        enabled = true,

        -- Colors for highlight by specifying a ctermbg and bg
        ctermbg = "darkgrey",
        bg = "#8B0000",

        -- Mode to use textwidth local options
        -- 0: Don't use textwidth at all, always use config.default_overlength.
        -- 1: Use `textwidth, unless it's 0, then use config.default_overlength.
        -- 2: Always use textwidth. There will be no highlighting where
        --    textwidth == 0, unless added explicitly
        textwidth_mode = 2,
        -- Default overlength with no filetype
        default_overlength = 80,
        -- How many spaces past your overlength to start highlighting
        grace_length = 1,
        -- Highlight only the column or until the end of the line
        highlight_to_eol = true,

        -- List of filetypes to disable overlength highlighting
        disable_ft = { "qf", "help", "man", "packer", "NvimTree", "Telescope", "WhichKey" },
    })
    require("overlength").set_overlength("python", 150)
end
return config
