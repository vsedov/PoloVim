local function goto_headline(which)
    local ts_utils = require("nvim-treesitter.ts_utils")
    local tsparser = vim.treesitter.get_parser()
    local tstree = tsparser:parse()
    local root = tstree[1]:root()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local cursor_range = { cursor[1] - 1, cursor[2] }
    -- Query all headings (from 1 to 6)
    local query = vim.treesitter.query.parse(
        "norg",
        [[
    (heading1) @h1
    (heading2) @h2
    (heading3) @h3
    (heading4) @h4
    (heading5) @h5
    (heading6) @h6
    ]]
    )
    local previous_headline = nil
    local next_headline = nil
    -- Find the previous and next heading from the captures
    for _, captures, metadata in query:iter_matches(root) do ---@diagnostic disable-line
        for _, node in pairs(captures) do
            local row = node:start()
            if row < cursor_range[1] then
                previous_headline = node
            elseif row > cursor_range[1] and next_headline == nil then
                next_headline = node
                break
            end
        end
    end
    if which == "previous" then
        ts_utils.goto_node(previous_headline)
    elseif which == "next" then
        ts_utils.goto_node(next_headline)
    end
end

return {
    hook = function(kb)
        local norg_utils = require("modules.notes.norg.utils")
        kb.map("norg", "n", "\\" .. "e", function()
            norg_utils.export_file(".md", { open_file = true, open_markdown_preview = false })
        end, { desc = "Neorg: export to markdown and open file" })

        kb.map("norg", "n", "\\" .. "E", function()
            norg_utils.export_file(".md", { open_file = true, open_markdown_preview = true })
        end, { desc = "Neorg: export to markdown and open MarkdownPreview" })

        kb.map_event("norg", "n", "\\" .. "c", "core.looking-glass.magnify-code-block")
        kb.map("norg", "n", "\\" .. "q", "<Cmd>Neorg return<CR>")

        kb.map("norg", "n", "[h", function()
            goto_headline("previous")
        end, { desc = "Neorg: Go to previous headline" })
        kb.map("norg", "n", "]h", function()
            goto_headline("next")
        end, { desc = "Neorg: Go to next headline" })
    end,
}
