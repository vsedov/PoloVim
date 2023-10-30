local highlight, ui, k = lambda.highlight, lambda.ui, vim.keycode
local api = vim.api
local cmp = require("cmp")
local types = require("cmp.types")
local utils = require("modules.completion.cmp.utils")
local border = lambda.style.border.type_0
local cmp_window = {
    border = border,
    winhighlight = table.concat({
        "Normal:Normal",
        "FloatBorder:SuggestWidgetBorder",
        "CursorLine:Normal",
        "Search:None", --[[ , ]]
    }, ","),
}
local lspkind = require("lspkind")
local ellipsis = lambda.style.icons.misc.ellipsis
local MIN_MENU_WIDTH, MAX_MENU_WIDTH = 25, math.min(50, math.floor(vim.o.columns * 0.5))

local config = {
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },
    -- performance = { debounce = 42, throttle = 42, fetching_timeout = 284 },
    preselect = cmp.PreselectMode.Item, -- None | Item
    confirmation = { default_behavior = require("cmp.types").cmp.ConfirmBehavior.Replace },
    -- confirmation = {
    --     default_behavior = types.cmp.ConfirmBehavior.Replace, -- Item
    --     get_commit_characters = function(commit_characters)
    --         return commit_characters
    --     end,
    -- },
    -- experimental = { ghost_text = { hl_group = "Dimmed" } },
    experimental = {
        ghost_text = lambda.config.cmp.use_ghost,
    },
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

local function setWindowConfiguration(theme, border)
    local winhighlight = "Normal:Normal,FloatBorder:None,CursorLine:None,Search:None"
    if theme == "border" then
        config.window = {
            completion = cmp.config.window.bordered({ border = border, winhighlight = winhighlight }),
            documentation = cmp.config.window.bordered({ border = border, winhighlight = winhighlight }),
        }
    elseif theme == "borderv2" then
        config.window = {
            completion = cmp.config.window.bordered(cmp_window),
            documentation = cmp.config.window.bordered(cmp_window),
        }
    elseif theme == "extra" then
        config.window = {
            completion = cmp.config.window.bordered({
                scrollbar = false,
                border = "shadow",
                winhighlight = "NormalFloat:Pmenu,CursorLine:PmenuSel,FloatBorder:FloatBorder",
            }),
            documentation = cmp.config.window.bordered({
                border = lambda.style.border.type_0,
                winhighlight = "FloatBorder:FloatBorder",
            }),
        }
    end
end

local function setFormattingConfiguration(theme)
    if theme == "border" then
        config.formatting = {
            format = lspkind.cmp_format({
                with_text = false,
                before = function(entry, vim_item)
                    vim_item.abbr = utils.get_abbr(vim_item, entry)
                    vim_item.dup = ({ buffer = 1, path = 1, nvim_lsp = 0 })[entry.source.name] or 0
                    return vim_item
                end,
            }),
        }
    elseif theme == "borderv2" then
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
    elseif theme == "extra" then
        config.window = {
            completion = cmp.config.window.bordered({
                border = lambda.style.border.type_0,
                winhighlight = "FloatBorder:FloatBorder",
            }),
            documentation = cmp.config.window.bordered({
                border = lambda.style.border.type_0,
                winhighlight = "FloatBorder:FloatBorder",
            }),
        }

        config.formatting = {
            deprecated = true,
            fields = { "kind", "abbr", "menu" },
            format = lspkind.cmp_format({
                mode = "symbol",
                maxwidth = MAX_MENU_WIDTH,
                ellipsis_char = ellipsis,
                before = function(_, vim_item)
                    local label, length = vim_item.abbr, api.nvim_strwidth(vim_item.abbr)
                    if length < MIN_MENU_WIDTH then
                        vim_item.abbr = label .. string.rep(" ", MIN_MENU_WIDTH - length)
                    end
                    return vim_item
                end,
                menu = {
                    nvim_lsp = "[LSP]",
                    nvim_lua = "[LUA]",
                    emoji = "[EMOJI]",
                    path = "[PATH]",
                    neorg = "[NEORG]",
                    luasnip = "[SNIP]",
                    dictionary = "[DIC]",
                    buffer = "[BUF]",
                    spell = "[SPELL]",
                    orgmode = "[ORG]",
                    norg = "[NORG]",
                    rg = "[RG]",
                    git = "[GIT]",
                    cmp_tabnine = "[Tn]",
                    cmp_codeium = "[]",
                    codeium = "[]",
                    kitty = "[]",
                },
            }),
        }
    end
end

local theme = lambda.config.cmp.cmp_theme

setWindowConfiguration(theme, border)
setFormattingConfiguration(theme)

if
    lambda.config.ai.tabnine.use_tabnine
    and lambda.config.ai.tabnine.use_tabnine_cmp
    and lambda.config.ai.tabnine.use_sort
then
    local sorting = {
    comparators = {},
    }

    if lambda.config.ai.tabnine.cmp.tabnine_sort then
        table.insert(sorting.comparators, 1, require("cmp_tabnine.compare"))
    end

    if lambda.config.ai.tabnine.cmp.tabnine_bottom_sort then
        table.insert(sorting.comparators, require("cmp_tabnine.compare"))
    end
    config.sorting = sorting
end

return config
