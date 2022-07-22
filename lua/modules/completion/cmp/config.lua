local cmp = require("cmp")
local types = require("cmp.types")
local utils = require("modules.completion.cmp.utils")
local kind = require("utils.ui.kind")
local border = { "🭽", "▔", "🭾", "▕", "🭿", "▁", "🭼", "▏" }
local config = {
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },
    -- completion = {
    --     autocomplete = { types.cmp.TriggerEvent.TextChanged },
    --     completeopt = "menu,menuone,noselect",
    -- },
    preselect = cmp.PreselectMode.None, -- None | Item
    experimental = { ghost_text = true, native_menu = false },

    mapping = require("modules.completion.cmp.mappings"),
    sources = require("modules.completion.cmp.sources"),
    sorting = {
        comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            function()
                if vim.o.filetype == "c" or vim.o.filetype == "cpp" then
                    require("clangd_extensions.cmp_scores")
                end
            end,
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
    },
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
        behavior = cmp.ConfirmBehavior.Replace,
        select = false,
    },
}

if lambda.config.cmp_theme == "border" then
    config.window = {
        completion = {
            border = border,
            scrollbar = "║",
        },
        documentation = {
            border = border,
            scrollbar = "║",
        },
    }
    config.formatting = {
        fields = {
            "kind",
            "abbr",
            "menu",
        },
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
elseif lambda.config.cmp_theme == "no-border" then
    config.window = {
        completion = {
            -- border = border,
            winhighlight = "Normal:Pmenu,FloatBorder:CmpDocumentationBorder,Search:None",
            left_side_padding = 0,
            right_side_padding = 1,
            col_offset = 1,
        },
        documentation = {
            -- border = border,
            winhighlight = "FloatBorder:CmpDocumentationBorder,Search:None",
            max_width = 80,
            col_offset = -1,
            max_height = 12,
        },
    }
    config.formatting = {
        fields = {
            "kind",
            "abbr",
            "menu",
        },
        format = function(entry, item)
            item.menu = item.kind
            item.menu_hl_group = ("CmpItemKindMenu%s"):format(item.kind)
            item.padding = " "
            item.kind = kind.presets.default[item.kind] or ""
            item.dup = vim.tbl_contains({ "path", "buffer" }, entry.source.name)
            item.abbr = utils.get_abbr(item, entry)
            item.test = "test"
            item.test_hl_group = "String"

            if entry.source.name == "cmp_tabnine" then
                if entry.completion_item.data ~= nil and entry.completion_item.data.detail ~= nil then
                    menu = entry.completion_item.data.detail
                end
            end

            item.menu = menu
            return item
        end,
    }
end

return config
