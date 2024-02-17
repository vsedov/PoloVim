local cmp = require("cmp")
local luasnip = require("luasnip")
local utils = require("modules.completion.cmp.utils")

local function copilot(fallback)
    -- local suggestion = require("copilot.suggestion")
    -- if suggestion.is_visible() then
    --     return suggestion.accept()
    -- end
    -- vim.api.nvim_feedkeys(lambda.replace_termcodes("<Tab>"), "n", false)
    local copilot_keys = vim.fn["copilot#Accept"]("")
    if copilot_keys ~= "" then
        vim.api.nvim_feedkeys(copilot_keys, "i", true)
    else
        return
    end
end

local function t(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end
local feedkeys = vim.api.nvim_feedkeys

function supertab(when_cmp_visible)
    local cmp = require("cmp")
    local function check_back_space()
        local col = vim.fn.col(".") - 1
        return col == 0 or vim.fn.getline("."):sub(col, col):match("%s") ~= nil
    end

    return function()
        if cmp.visible() then
            when_cmp_visible()
        elseif require("luasnip").expand_or_jumpable() then
            feedkeys(t("<Plug>luasnip-expand-or-jump"), "", false)
        else
            -- local ok, neogen = pcall(require, "neogen")
            -- if ok and neogen.jumpable() then
            -- require'neogen'.jump_next()
            --   feedkeys(t "<cmd>lua require'neogen'.jump_next()<cr>", "", false)
            -- else
            if check_back_space() then
                feedkeys(t("<tab>"), "n", false)
            else
                feedkeys(t("<Plug>(Tabout)"), "", false)
                -- fallback()
            end
        end
    end
end

local function double_mapping(invisible, visible)
    return function()
        if cmp.visible() then
            visible()
        else
            invisible()
        end
    end, {
        "i",
        "s",
        "c",
    }
end

local function autocomplete()
    cmp.complete({ reason = cmp.ContextReason.Auto })
end

local function complete_or(mapping)
    return double_mapping(cmp.complete, mapping)
end
local check_backspace = function()
    local col = vim.fn.col(".") - 1
    return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
end
local function next_item()
    if cmp.visible() then
        cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
    elseif require("luasnip").choice_active() then
        feedkeys(t("<Plug>luasnip-next-choice"), "", false)
    else
        autocomplete()
    end
end

local function prev_item()
    if cmp.visible() then
        cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
    elseif require("luasnip").choice_active() then
        feedkeys(t("<Plug>luasnip-prev-choice"), "", false)
    else
        autocomplete()
    end
end
local mappings = {

    ["<M-d>"] = cmp.mapping({
        c = cmp.mapping.scroll_docs(-4),
        i = function()
            if not require("noice.lsp").scroll(-4) then
                cmp.scroll_docs(-4)
            end
        end,
        s = function()
            if not require("noice.lsp").scroll(-4) then
                cmp.scroll_docs(-4)
            end
        end,
    }),
    ["<M-u>"] = cmp.mapping({
        c = cmp.mapping.scroll_docs(4),
        i = function()
            if not require("noice.lsp").scroll(4) then
                cmp.scroll_docs(4)
            end
        end,
        s = function()
            if not require("noice.lsp").scroll(4) then
                cmp.scroll_docs(4)
            end
        end,
    }),
    ["<M-k>"] = cmp.mapping({
        i = prev_item,
        c = complete_or(cmp.select_prev_item),
    }),
    ["<M-j>"] = cmp.mapping({
        i = next_item,
        c = complete_or(cmp.select_next_item),
    }),
    -- ──────────────────────────────────────────────────────────────────────

    ["<C-e>"] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
    }),

    ["<CR>"] = cmp.mapping.confirm({
        select = true,
    }),

    ["<C-f>"] = cmp.mapping(function(fallback)
        if luasnip.choice_active() then
            require("luasnip").change_choice(1)
        elseif cmp.visible() then
            cmp.scroll_docs(4)
        else
            fallback()
        end
    end, {
        "i",
        "s",
    }),
    ["<C-d>"] = cmp.mapping(function(fallback)
        if luasnip.choice_active() then
            require("luasnip").change_choice(-1)
        elseif cmp.visible() then
            cmp.scroll_docs(-4)
        else
            fallback()
        end
    end, {
        "i",
        "s",
    }),

    ["<Tab>"] = function(fallback)
        if cmp.visible() then
            cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
        else
            fallback()
        end
    end,

    ["<S-Tab>"] = function(fallback)
        if cmp.visible() then
            cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
        else
            fallback()
        end
    end,

    ["<C-l>"] = cmp.mapping(function(fallback)
        if lambda.config.ai.sell_your_soul and lambda.config.ai.copilot.use_cmp_trigger then
            -- copilot()
            local copilot_keys = vim.fn["copilot#Accept"]("")
            if copilot_keys ~= "" then
                vim.api.nvim_feedkeys(copilot_keys, "i", false)
            -- elseif luasnip.expandable() then
            --     luasnip.expand()
            -- elseif luasnip.expand_or_jumpable() then
            --     luasnip.expand_or_jump()
            elseif check_backspace() then
                fallback()
            else
                fallback()
            end
        else
            if luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end
    end, {
        "i",
        "s",
    }),

    ["<C-k>"] = cmp.mapping(function(fallback)
        if luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
        else
            fallback()
        end
    end, {
        "i",
        "s",
    }),

    ["<C-j>"] = cmp.mapping(function(fallback)
        if luasnip.jumpable(-1) then
            luasnip.jump(-1)
        else
            fallback()
        end
    end, {
        "i",
        "s",
    }),
}
return mappings
