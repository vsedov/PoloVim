local api = vim.api
-- default sources
local plugins = {
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
        name = "luasnip_choice",
        enable = true,
        options = {
            priority = 10,
        },
    },
    {
        name = "luasnip",
        enable = true,
        options = {
            priority = 8,
        },
    },
    {
        name = "neorg",
        enable = true,
        options = { priority = 6 },
    },
    {
        name = "codeium",
        enable = true,
        options = {
            priority = 8,
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
        enable = lambda.config.cmp.use_rg,
        options = {
            options = {
                keyword_length = 3,
                option = {
                    additional_arguments = "--max-depth 6 --one-file-system --ignore-file ~/.config/nvim/utils/abbreviations/dictionary.lua",
                },
            },
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
        end
        table.insert(ret, plugin_entry)
    end
    return ret
end

return apply_options(plugins)
