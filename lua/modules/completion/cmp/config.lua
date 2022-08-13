local cmp = require("cmp")
local utils = require("modules.completion.cmp.utils")
local border = lambda.style.border.type_0
local fields = {
    "kind",
    "abbr",
    "menu",
}

local config = {
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },
    preselect = cmp.PreselectMode.None, -- None | Item
    experimental = { ghost_text = true }, -- native_menu = false
    mapping = require("modules.completion.cmp.mappings"),
    sources = require("modules.completion.cmp.sources"),
    -- maybe this was cauasing the lag, lol, this cactually could of been the cause
    --[[ sorting = { ]]
    --[[     comparators = { ]]
    --[[         cmp.config.compare.offset, ]]
    --[[         cmp.config.compare.exact, ]]
    --[[         cmp.config.compare.score, ]]
    --[[         function() ]]
    --[[             if vim.o.filetype == "c" or vim.o.filetype == "cpp" then ]]
    --[[                 require("clangd_extensions.cmp_scores") ]]
    --[[             end ]]
    --[[         end, ]]
    --[[         function(entry1, entry2) ]]
    --[[             local _, entry1_under = entry1.completion_item.label:find("^_+") ]]
    --[[             local _, entry2_under = entry2.completion_item.label:find("^_+") ]]
    --[[             entry1_under = entry1_under or 0 ]]
    --[[             entry2_under = entry2_under or 0 ]]
    --[[             if entry1_under > entry2_under then ]]
    --[[                 return false ]]
    --[[             elseif entry1_under < entry2_under then ]]
    --[[                 return true ]]
    --[[             end ]]
    --[[         end, ]]
    --[[         cmp.config.compare.kind, ]]
    --[[         cmp.config.compare.sort_text, ]]
    --[[         cmp.config.compare.length, ]]
    --[[         cmp.config.compare.order, ]]
    --[[]]
    --[[     }, ]]
    --[[ }, ]]
    --[[]]
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

if lambda.config.cmp_theme == "border" then
    local kind = require("utils.ui.kind")

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
    local kind = require("utils.ui.kind")

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
        fields = fields,
        format = function(entry, item)
            item.surround_start = "▐"
            item.surround_start_hl_group = ("CmpItemKindBlock%s"):format(item.kind)
            item.surround_end_hl_group = ("CmpItemKindBlock%s"):format(item.kind)
            item.menu_hl_group = ("CmpItemKindMenu%s"):format(item.kind)
            item.padding = " "
            item.kind = kind.presets.default[item.kind] or ""
            item.dup = vim.tbl_contains({ "path", "buffer" }, entry.source.name)
            item.abbr = utils.get_abbr(item, entry)

            if entry.source.name == "cmp_tabnine" then
                if entry.completion_item.data ~= nil and entry.completion_item.data.detail ~= nil then
                    item.menu = entry.completion_item.data.detail
                end
            end

            return item
        end,
    }
elseif lambda.config.cmp_theme == "extra" then
    local cmp_window = {
        border = border,
        winhighlight = table.concat({
            "Normal:NormalFloat",
            "FloatBorder:FloatBorder",
            "CursorLine:Visual",
            "Search:None",
        }, ","),
    }
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
                cmp_tabnine = "[TN]",
            })[entry.source.name]

            return vim_item
        end,
    }
end

return config
