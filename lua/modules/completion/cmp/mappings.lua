local cmp = require("cmp")
local luasnip = require("luasnip")
local utils = require("modules.completion.cmp.utils")
local mappings = {

    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-e>"] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
    }),

    ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
    ["<C-' '>"] = cmp.mapping.confirm({ select = true }),

    ["<CR>"] = cmp.mapping.confirm({
        select = true,
        behavior = cmp.ConfirmBehavior.Insert,
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
    -- ["<BS>"] = cmp.mapping(function(_fallback)
    --     local keys = utils.smart_bs()
    --     vim.api.nvim_feedkeys(keys, "nt", true)
    -- end, { "i", "s" }),

    ["<Tab>"] = cmp.mapping(function(core, fallback)
        if cmp.visible() then
            cmp.select_next_item()
        elseif luasnip.expandable() then
            luasnip.expand()
        elseif luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
        elseif not utils.check_backspace() then
            cmp.mapping.complete()(core, fallback)
        elseif utils.has_words_before() then
            cmp.complete()
        else
            utils.smart_tab()
            -- vim.cmd(":>")
        end
    end, {
        "i",
        "s",
        "c",
    }),

    -- Avoid full fallback as it acts retardedly
    ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
            cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
        else
            -- smart_bs()
            vim.cmd(":<")
        end
    end, {
        "i",
        "s",
        "c",
    }),

    ["<C-j>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
            cmp.mapping.abort()
            cmp.mapping.close()
        end
        if luasnip.expandable() then
            luasnip.expand()
        elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
        elseif utils.check_backspace() then
            fallback()
        elseif has_words_before() then
            cmp.complete()
        else
            fallback()
        end
    end, {
        "i",
        "s",
    }),

    ["<C-k>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
            cmp.mapping.abort()
            cmp.mapping.close()
        end
        if luasnip.jumpable(-1) then
            luasnip.jump(-1)
        else
            fallback()
        end
    end, {
        "i",
        "s",
    }),
    ["<C-l>"] = cmp.mapping(function(fallback)
        local copilot_keys = vim.fn["copilot#Accept"]("")
        if copilot_keys ~= "" then
            vim.api.nvim_feedkeys(copilot_keys, "i", true)
        else
            fallback()
        end
    end, {
        "i",
        "s",
    }),
}

return mappings
