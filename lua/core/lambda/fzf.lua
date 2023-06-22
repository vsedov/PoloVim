local fn, env, ui = vim.fn, vim.env, lambda.style
local icons, lsp_hls = ui.icons, ui.lsp.highlights
local prompt = icons.misc.telescope .. "  "

------------------------------------------------------------------------------------------------------------------------
-- FZF-LUA HELPERS
------------------------------------------------------------------------------------------------------------------------
local function format_title(str, icon, icon_hl)
    return {
        { " " },
        { (icon and icon .. " " or ""), icon_hl or "DevIconDefault" },
        { str, "Bold" },
        { " " },
    }
end

local function dropdown(opts)
    opts = opts or { winopts = {} }
    local title = vim.tbl_get(opts, "winopts", "title") ---@type string?
    if title and type(title) == "string" then
        opts.winopts.title = format_title(title)
    end
    return vim.tbl_deep_extend("force", {
        prompt = prompt,
        fzf_opts = { ["--layout"] = "reverse" },
        winopts = {
            title_pos = opts.winopts.title and "center" or nil,
            height = 0.70,
            width = 0.45,
            row = 0.1,
            preview = { hidden = "hidden", layout = "vertical", vertical = "up:50%" },
        },
    }, opts)
end

local function cursor_dropdown(opts)
    return dropdown(vim.tbl_deep_extend("force", {
        winopts = {
            row = 1,
            relative = "cursor",
            height = 0.33,
            width = 0.25,
        },
    }, opts))
end

lambda.fzf = { dropdown = dropdown, cursor_dropdown = cursor_dropdown }
------------------------------------------------------------------------------------------------------------------------
