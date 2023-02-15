local api = vim.api
-- default sources
local plugins = {
    {
        name = "luasnip_choice",
        enable = lambda.config.cmp.luasnip.luasnip_choice,
    },
    {
        name = "luasnip",
        enable = lambda.config.cmp.luasnip.luasnip.enable,
        options = {
            priority = lambda.config.cmp.luasnip.luasnip.priority,
        },
    },
    {
        name = "neorg",
        enable = true,
        options = { priority = 6 },
    },
    {
        name = "codeium",
        enable = lambda.config.cmp.codeium.use_codeium,
        options = {
            priority = lambda.config.cmp.codeium.codium_priority,
        },
    },
    {
        name = "cmp_tabnine",
        enable = lambda.config.cmp.tabnine.use_tabnine,
        options = {
            priority = lambda.config.cmp.tabnine.tabnine_priority,
        },
    },
    {
        name = "rg",
        enable = lambda.config.cmp.rg.use_rg,
        options = {
            options = {
                keyword_length = lambda.config.cmp.rg.keyword_length,
                option = {
                    additional_arguments = "--max-depth "
                        .. lambda.config.cmp.rg.depth
                        .. " --one-file-system --ignore-file ~/.config/nvim/utils/abbreviations/dictionary.lua",
                },
            },
        },
    },
    {
        name = "buffer",
        enable = true,
        options = {
            get_bufnrs = function()
                return vim.api.nvim_list_bufs()
            end,
        },
    },
    {
        name = "nvim_lsp",
        enable = true,
        options = {
            priority = 10,
        },
    },

    {
        name = "path",
        enable = true,
    },
    {
        name = "tmux",
        enable = true,
    },
    {
        name = "nvim_lua",
        enable = true,
    },
    {
        name = "cmp_overseer",
        enable = true,
    },
    {
        name = "lab.quick_data",
        enable = false,
        options = {
            keyword_length = 4,
        },
    },
}

local filetype = {
    sql = function()
        table.insert(plugins, { name = "vim-dadbod-completion" })
    end,
    norg = function()
        table.insert(plugins, { name = "latex_symbols" })
    end,
    markdown = function()
        table.insert(plugins, { name = "latex_symbols" })
    end,
}

if filetype[vim.bo.ft] then
    filetype[vim.bo.ft]()
end

local function apply_options(t)
    local ret = {}
    for _, plugin in ipairs(t) do
        local plugin_entry = {
            name = plugin.name,
        }
        if plugin.enable then
            if plugin.options then
                plugin_entry.options = plugin.options
            end
            table.insert(ret, plugin_entry)
        end
    end
    return ret
end

return apply_options(plugins)
