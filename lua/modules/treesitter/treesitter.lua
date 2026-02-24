local enable = true
local langtree = true
local lines = vim.fn.line("$")

local treesitter = function()
    -- lprint("loading treesitter")
    if lines > 30000 then -- skip some settings for large file
        -- vim.cmd[[syntax on]]
        print("skip treesitter")
        return
    end

    if lines > 7000 then
        enable = false
        langtree = false
        print("disable ts txtobj")
    end
end

local treesitter_obj = function()
    -- lprint("loading treesitter textobj")
    if lines > 30000 then -- skip some settings for large file
        print("skip treesitter obj")
        return
    end

end

local treesitter_ref = function()
    -- lprint("loading treesitter refactor")

    if vim.fn.line("$") > 10000 then -- skip for large file
        -- vim.cmd[[syntax on]]
        print("skip treesitter")
        enable = false
    end

    require("nvim-treesitter.config").setup({
        refactor = {
            highlight_definitions = { enable = enable },
            highlight_current_scope = { enable = false },
            smart_rename = {
                enable = false,
            },
            navigation = {
                enable = true, -- enabled navigation might conflict with mapping
                keymaps = {
                    goto_definition = "gnd", -- mapping to go to definition of symbol under cursor
                    list_definitions = "gnD", -- mapping to list all definitions in current file
                    list_definitions_toc = "gO", -- gT navigator
                    goto_next_usage = "<c->>",
                    goto_previous_usage = "<c-<>",
                },
            },
        },
    })
end

local endwise = function()
    require("nvim-treesitter.config").setup({
        endwise = {
            enable = true,
        },
    })
end

local function textsubjects()
    require("nvim-treesitter.config").setup({
        textsubjects = {
            enable = true,
            keymaps = {
                ["<leader><leader><leader>"] = "textsubjects-smart",
                ["<leader><leader><cr>"] = "textsubjects-container-outer",
                ['<leader><leader>;"'] = "textsubjects-container-inner",
            },
        },
    })
end

-- treesitter()

return {
    endwise = endwise,
    treesitter = treesitter,
    treesitter_obj = treesitter_obj,
    treesitter_ref = treesitter_ref,
    textsubjects = textsubjects,
    -- pyfold = pyfoldo,
}
