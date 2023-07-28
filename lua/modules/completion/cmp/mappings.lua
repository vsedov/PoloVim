local cmp = require("cmp")
local luasnip = require("luasnip")
local utils = require("modules.completion.cmp.utils")
local function copilot()
    local suggestion = require("copilot.suggestion")
    if suggestion.is_visible() then
        return suggestion.accept()
    end
    vim.api.nvim_feedkeys(lambda.replace_termcodes("<Tab>"), "n", false)
end

local mappings = {
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
        if lambda.config.ai.sell_your_soul then
            copilot()
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
