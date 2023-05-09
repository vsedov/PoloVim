local cmp = require("cmp")
local types = require("cmp.types")
local compare = require("cmp.config.compare")
local utils = require("modules.completion.cmp.utils")
local border = lambda.style.border.type_0
local fields = {
    "kind",
    "abbr",
    "menu",
}
local cmp_window = {
    border = border,
    winhighlight = table.concat({
        "Normal:Normal",
        "FloatBorder:SuggestWidgetBorder",
        "CursorLine:Normal",
        "Search:None",--[[ , ]]
    }, ","),
}
local config = {
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },
    performance = {
        debounce = 60,
        throttle = 30,
        fetching_timeout = 500,
    },

    preselect = cmp.PreselectMode.None, -- None | Item
    completion = {
        types.cmp.TriggerEvent.None,
        completeopt = "menu,menuone,noselect",
        keyword_pattern = [[\%(-\?\d\+\%(\.\d\+\)\?\|\h\w*\%(-\w*\)*\)]],
        keyword_length = 1,
    },
    -- confirmation = {
    --     default_behavior = types.cmp.ConfirmBehavior.Insert,
    --     get_commit_characters = function(commit_characters)
    --         return commit_characters
    --     end,
    -- },
    experimental = { ghost_text = false, native_menu = false }, -- native_menu = false -- im not sure if this will make things faster

    mapping = require("modules.completion.cmp.mappings"),
    sources = require("modules.completion.cmp.sources"),

    enabled = function()
        if vim.bo.ft == "TelescopePrompt" then
            return false
        end
        if vim.bo.ft == "dashboard" then
            return false
        end
        if vim.bo.ft == "lua" then
            return true
        end
        local lnum, col = vim.fn.line("."), math.min(vim.fn.col("."), #vim.fn.getline("."))
        for _, syn_id in ipairs(vim.fn.synstack(lnum, col)) do
            syn_id = vim.fn.synIDtrans(syn_id) -- Resolve :highlight links
            if vim.fn.synIDattr(syn_id, "name") == "Comment" then
                return false
            end
        end
        if string.find(vim.api.nvim_buf_get_name(0), "neorg://") then
            return false
        end
        if string.find(vim.api.nvim_buf_get_name(0), "s_popup:/") then
            return false
        end
        return true
    end,
    confirm_opts = {
        behavior = cmp.ConfirmBehavior.Insert,
        select = true,
    },
}

if lambda.config.cmp.cmp_theme == "border" then
    local kind = require("utils.ui.kind")
    cmp_window = {
        border = border,
        winhighlight = table.concat({
            "Normal:Normal",
            "FloatBorder:None",
            "CursorLine:None",
            "Search:None",
        }, ","),
    }
    config.window = {
        completion = cmp.config.window.bordered(cmp_window),
        documentation = cmp.config.window.bordered(cmp_window),
    }

    config.window = {
        completion = {
            border = border,
            scrollbar = "║",
        },
        documentation = {
            border = border,
        },
    }
    config.formatting = {

        format = kind.cmp_format({
            with_text = false,
            before = function(entry, vim_item)
                vim_item.abbr = utils.get_abbr(vim_item, entry)
                vim_item.dup = ({
                    buffer = 1,
                    path = 1,
                    nvim_lsp = 0,
                })[entry.source.name] or 0
                return vim_item
            end,
        }),
    }
elseif lambda.config.cmp.cmp_theme == "borderv2" then
    config.formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
            vim_item.kind = lambda.style.lsp.kinds.codicons[vim_item.kind] or " "
            vim_item.menu = ({
                cmp_tabnine = "[Tn]",
                cmp_codeium = "[]",
                codeium = "[]",
                norg = "[Norg]",
                rg = "[Rg]",
                kitty = "[]",
                git = "[Git]",
            })[entry.source.name]
            return vim_item
        end,

        border = border,
    }

    config.window = {
        completion = cmp.config.window.bordered(cmp_window),
        documentation = cmp.config.window.bordered(cmp_window),
    }
elseif lambda.config.cmp.cmp_theme == "extra" then
    config.window = {
        completion = cmp.config.window.bordered(cmp_window),
        documentation = cmp.config.window.bordered(cmp_window),
    }
    config.formatting = {
        deprecated = true,
        fields = fields,
        format = function(entry, vim_item)
            local MAX = math.floor(vim.o.columns * 0.5)
            if #vim_item.abbr >= MAX then
                vim_item.abbr = vim_item.abbr:sub(1, MAX) .. lambda.style.icons.misc.ellipsis
            end
            vim_item.kind = string.format("%s %s", lambda.style.lsp.kinds.codicons[vim_item.kind], vim_item.kind)
            vim_item.menu = ({
                nvim_lsp = "[LSP]",
                nvim_lua = "[Lua]",
                path = "[Path]",
                neorg = "[N]",
                luasnip = "[SN]",
                dictionary = "[D]",
                buffer = "[B]",
                spell = "[SP]",
                cmdline = "[Cmd]",
                cmdline_history = "[Hist]",
                norg = "[Norg]",
                -- Man this thing lagged like crazy if i remember correctly
                rg = "[Rg]",
                git = "[Git]",
            })[entry.source.name]
            if entry.source.name == "cmp_tabnine" then
                local detail = (entry.completion_item.data or {}).detail
                vim_item.kind = "[TN]"
                if detail and detail:find(".*%%.*") then
                    vim_item.kind = vim_item.kind .. " " .. detail
                end

                if (entry.completion_item.data or {}).multiline then
                    vim_item.kind = vim_item.kind .. " " .. "[ML]"
                end
            end
            return vim_item
        end,
    }
end

if lambda.config.ai.tabnine.use_tabnine then
    local sorting = {
        comparators = {
            compare.offset,
            compare.exact,
            compare.score,
            compare.recently_used,
            compare.kind,
            compare.sort_text,
            compare.length,
            compare.order,
        },
    }

    if lambda.config.ai.tabnine.cmp.tabnine_sort then
        sorting.priority_weight = 2
        table.insert(sorting.comparators, 1, require("cmp_tabnine.compare"))
    end

    if lambda.config.ai.tabnine.cmp.tabnine_bottom_sort then
        table.insert(sorting.comparators, require("cmp_tabnine.compare"))
    end

    config.sorting = sorting
else
    config.sorting = {
        comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            function(entry1, entry2)
                local _, entry1_under = entry1.completion_item.label:find("^_+")
                local _, entry2_under = entry2.completion_item.label:find("^_+")
                entry1_under = entry1_under or 0
                entry2_under = entry2_under or 0
                if entry1_under > entry2_under then
                    return false
                elseif entry1_under < entry2_under then
                    return true
                end
            end,

            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
        },
    }
end
return config
