require("core")

local genie = require("SnippetGenie")
genie.setup({
    -- SnippetGenie will use this regex to find the pattern in your snippet file,
    -- and insert the newly generated snippet there.
    regex = [[-\+ Snippets goes here]],
    -- A line that matches this regex looks like:
    ------------------------------------------------ Snippets goes here

    -- this must be configured
    snippets_directory = "/home/viv/.config/nvim/lua/modules/completion/snippets/",

    -- let's say you're creating a snippet for Lua,
    -- SnippetGenie will look for the file at `/path/to/my/LuaSnip/snippet/folder/lua/generated.lua`
    -- and add the new snippet there.
    file_name = "generated",

    -- SnippetGenie was designed to generate LuaSnip's `fmt()` snippets.
    -- here you can configure the generated snippet's "skeleton" / "template" according to your use case
    snippet_skeleton = [[
s(
    "{trigger}",
    fmt([=[
{body}
]=], {{
        {nodes}
    }})
),
]],
})

vim.keymap.set("x", "<CR>", function()
    genie.create_new_snippet_or_add_placeholder()
    vim.notify("I am called")
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), "x", true)
end, {})

vim.keymap.set("n", ";<CR>", function()
    genie.finalize_snippet()
end, {})

function test()
    local module = require("module")

    local function my_func()
        local x = 10
        local y = 100
    end
end

-- vim.t.bufs = vim.api.nvim_list_bufs()

