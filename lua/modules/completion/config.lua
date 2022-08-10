-- local global = require("core.global")
local config = {}

function config.nvim_doc_help()
    require("docs-view").setup({
        position = "bottom",
        height = 10,
    })
end

function config.cmp()
    require("modules.completion.cmp")
end

-- packer.nvim: Error running config for LuaSnip: [string "..."]:0: attempt to index global 'ls_types' (a nil value)
function config.luasnip()
    require("modules.completion.snippets")
end

function config.tabnine()
    local tabnine = require("cmp_tabnine.config")
    tabnine:setup({
        max_lines = 1000,
        max_num_results = 20,
        sort = true,
        run_on_every_keystroke = true,
        snippet_placeholder = "..",
        ignored_file_types = { -- default is not to ignore
            -- uncomment to ignore in lua:
            -- lua = true
            norg = "true",
        },
        show_prediction_strength = true,
    })
end

function config.autopair()
    local has_autopairs, autopairs = pcall(require, "nvim-autopairs")
    if not has_autopairs then
        print("autopairs not loaded")

        local loader = require("packer").loader
        loader("nvim-autopairs")
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

function config.neogen()
    require("neogen").setup({
        snippet_engine = "luasnip",
        languages = {
            lua = {
                template = { annotation_convention = "emmylua" },
            },
            python = {
                template = { annotation_convention = "numpydoc" },
            },
            c = {
                template = { annotation_convention = "doxygen" },
            },
        },
    })
end

function config.vim_sonictemplate()
    vim.g.sonictemplate_postfix_key = "<C-,>"
    vim.g.sonictemplate_vim_template_dir = os.getenv("HOME") .. "/.config/nvim/template"
end

return config
