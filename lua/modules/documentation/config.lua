local config = {}

function config.neogen()
    require("neogen").setup({
        snippet_engine = "luasnip",
        languages = {
            lua = {
                template = { annotation_convention = "emmylua" },
            },
            python = {
                template = { annotation_convention = "numpydoc" },
            },
            c = {
                template = { annotation_convention = "doxygen" },
            },
        },
    })
end
function config.dyn_help()
    vim.keymap.set("n", "<leader>xw", function()
        if require("dynamic_help.extras.statusline").available() ~= "" then
            require("dynamic_help").float_help(vim.fn.expand("<cword>"))
        else
            local help = vim.fn.input("Help Tag> ")
            require("dynamic_help").float_help(help)
        end
    end, {})
end
function config.nvim_doc_help()
    require("docs-view").setup({
        position = "bottom",
        height = 10,
    })
end

return config
