local opts = { noremap = true, silent = true }
local sts = require("syntax-tree-surfer")

sts.setup({
    highlight_group = "STS_highlight",
    disable_no_instance_found_report = false,
    default_desired_types = {
        "function",
        "function_definition",
        "struct_definition",
        "if_statement",
        "else_clause",
        "do_clause",
        "else_statement",
        "elseif_statement",
        "for_statement",
        "let_statement",
        "while_statement",
        "switch_statement",
    },
    left_hand_side = "fdsawervcxqtzb",
    right_hand_side = "jkl;oiu.,mpy/n",
    icon_dictionary = {
        ["if_statement"] = "𝒾",
        ["else_clause"] = "ℯ",
        ["else_statement"] = "ℯ",
        ["elseif_statement"] = "ℯ",
        ["elseif_clause"] = "ℯ",
        ["for_statement"] = "ﭜ",
        ["while_statement"] = "ﯩ",
        ["switch_statement"] = "ﳟ",
        ["function"] = "",
        ["function_definition"] = "",
        ["variable_declaration"] = "",
        ["let_statement"] = "ℒ",
        ["do_statement"] = "𝒟",
        ["struct_definition"] = "𝒮",
    },
})

-- -- Normal Mode Swapping:
-- -- Swap The Master Node relative to the cursor with it's siblings, Dot Repeatable
vim.keymap.set("n", "vU", function()
    vim.opt.opfunc = "v:lua.STSSwapUpNormal_Dot"
    return "g@l"
end, { silent = true, expr = true })

vim.keymap.set("n", "vD", function()
    vim.opt.opfunc = "v:lua.STSSwapDownNormal_Dot"
    return "g@l"
end, { silent = true, expr = true })

-- Swap Current Node at the Cursor with it's siblings, Dot Repeatable
vim.keymap.set("n", "vd", function()
    vim.opt.opfunc = "v:lua.STSSwapCurrentNodeNextNormal_Dot"
    return "g@l"
end, { silent = true, expr = true })

vim.keymap.set("n", "vu", function()
    vim.opt.opfunc = "v:lua.STSSwapCurrentNodePrevNormal_Dot"
    return "g@l"
end, { silent = true, expr = true })

-- Visual Selection from Normal Mode
vim.keymap.set("n", "vx", "<cmd>STSSelectMasterNode<cr>", opts)
vim.keymap.set("n", "vn", "<cmd>STSSelectCurrentNode<cr>", opts)
vim.keymap.set("n", "gfu", function() -- only jump to functions
    sts.targeted_jump({ "function", "function_definition" })
    --> In this example, the Lua language schema uses "function",
    --  when the Python language uses "function_definition"
    --  we include both, so this keymap will work on both languages
end, opts)

vim.keymap.set("n", "gif", function() -- only jump to if_statements
    sts.targeted_jump({ "if_statement", "else_clause", "else_statement", "elseif_statement" })
end, opts)

vim.keymap.set("n", "gfo", function() -- only jump to for_statements
    sts.targeted_jump({ "for_statement", "do_clause", "while_statement" })
end, opts)

vim.keymap.set("n", "J", function() -- jump to all that you specify
    sts.targeted_jump({
        "function",
        "function_definition",
        "struct_definition",
        "if_statement",
        "else_clause",
        "do_clause",
        "else_statement",
        "elseif_statement",
        "for_statement",
        "let_statement",
        "while_statement",
        "switch_statement",
    })
end, opts)
