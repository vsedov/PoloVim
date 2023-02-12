-- local global = require("core.global")
local config = {}

function config.cmp()
    require("modules.completion.cmp")
end

function config.luasnip()
    require("modules.completion.snippets")
end

function config.autopair()
    local has_autopairs, autopairs = pcall(require, "nvim-autopairs")
    if not has_autopairs then
        print("autopairs not loaded")
        has_autopairs, autopairs = pcall(require, "nvim-autopairs")
        if not has_autopairs then
            print("autopairs not installed")
            return
        end
    end
    local npairs = require("nvim-autopairs")
    -- local Rule = require("nvim-autopairs.rule")
    -- local cond = require("nvim-autopairs.conds")

    npairs.setup({
        enable_moveright = true,
        disable_in_macro = false,
        enable_afterquote = true,
        map_bs = true,
        map_c_w = true,
        map_cr = false,
        -- disable_in_visualblock = false,

        disable_filetype = { "TelescopePrompt", "guihua", "guihua_rust", "clap_input" },
        autopairs = { enable = true },
        ignored_next_char = string.gsub([[ [%w%%%'%[%"%.] ]], "%s+", ""), -- "[%w%.+-"']",
        -- enable_check_bracket_line = true, -- Messes with abbrivaitions
        html_break_line_filetype = { "html", "vue", "typescriptreact", "svelte", "javascriptreact" },
        check_ts = false,
        ts_config = {
            lua = { "string", "source" },
            javascript = { "string", "template_string" },
            java = false,
        },
        fast_wrap = {
            map = "<C-c>",
            chars = { "{", "[", "(", '"', "'", "`" },
            pattern = string.gsub([[ [%'%"%`%+%)%>%]%)%}%,%s] ]], "%s+", ""),
            end_key = "$",
            keys = "qwertyuiopzxcvbnmasdfghjkl",
            check_comma = true,
            hightlight = "Search",
        },
    })
end

function config.vim_sonictemplate()
    vim.g.sonictemplate_postfix_key = "<C-,>"
    vim.g.sonictemplate_vim_template_dir = os.getenv("HOME") .. "/.config/nvim/template"
end

function config.tabout()
    require("tabout").setup({
        tabkey = "<C-l>",
        backwards_tabkey = "<C-h>",
        act_as_tab = true, -- shift content if tab out is not possible
        act_as_shift_tab = false, -- reverse shift content if tab out is not possible (if your keyboard/terminal supports <S-Tab>)
        default_tab = "<C-t>", -- shift default action (only at the beginning of a line, otherwise <TAB> is used)
        default_shift_tab = "<C-f>", -- reverse shift default action,
        enable_backwards = true, -- well ...
        completion = true, -- if the tabkey is used in a completion pum
        tabouts = {
            { open = "'", close = "'" },
            { open = '"', close = '"' },
            { open = "", close = "" },
            { open = "(", close = ")" },
            { open = "[", close = "]" },
            { open = "{", close = "}" },
        },
        ignore_beginning = true, --[[ if the cursor is at the beginning of a filled element it will rather tab out than shift the content ]]
        exclude = {}, -- tabout will ignore these filetypes
    })
end
return config
