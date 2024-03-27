local api = vim.api
local ai = lambda.config.ai
local condium_cond = (ai.codeium.use_codeium and ai.codeium.use_codeium_cmp)
local tabnine_cond = (ai.tabnine.use_tabnine and ai.tabnine.use_tabnine_cmp)

local plugins = {
    { name = "vimtex", enable = true },
    {
        name = "luasnip",
        enable = lambda.config.cmp.luasnip.luasnip.enable,
        -- priority = lambda.config.cmp.luasnip.luasnip.priority,
    },
    { name = "cody", enable = true },
    {
        name = "neorg",
        enable = true,
    },
    {
        name = "buffer",
        options = {
            get_bufnrs = function()
                return vim.api.nvim_list_bufs()
            end,
        },
        enable = false,
        group_index = 2,
    },
    { name = "spell", group_index = 2 },
    {
        name = "nvim_lsp",
        enable = true,
        priority = 10,
    },

    {
        name = "path",
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
