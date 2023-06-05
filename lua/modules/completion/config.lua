-- local global = require("core.global")
local config = {}

function config.cmp()
    require("modules.completion.cmp")
end

function config.luasnip()
    require("modules.completion.snippets")
end

function config.snip_genie()
    local genie = require("SnippetGenie")
    genie.setup({
        regex = [[-\+ Snippets goes here]],
        snippets_directory = "/home/viv/.config/nvim/snippets/",
        file_name = "generated",
        snippet_skeleton = [[
        s(
            "{trigger}",
            fmt([=[
        {body}
        ]=], {{
                {nodes}
            }})
        ),
        ]],
    })

    vim.keymap.set("x", "<CR>", function()
        genie.create_new_snippet_or_add_placeholder()
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), "x", true)
    end, {})

    vim.keymap.set("n", ";<CR>", function()
        genie.finalize_snippet()
    end, {})

    lambda.command("SnipCreate", function()
        vim.notify("<cr> to start and ;<cr> to add the variables")
    end, { force = true })
end

function config.autopair()
    return {
        config_type = "default",
        map = true,
        --whether to allow any insert map
        cmap = true, --cmap stands for cmd-line map
        --whether to allow any cmd-line map
        pair_map = true,
        --whether to allow pair insert map
        pair_cmap = true,
        --whether to allow pair cmd-line map
        bs = {
            -- *ultimate-autopair-map-backspace-config*
            enable = true,
            map = "<bs>", --string or table
            cmap = "<bs>",
            overjumps = true,
            --(|foo) > bs > |foo
            space = true,
            --( |foo ) > bs > (|foo)
            indent_ignore = false,
            --(\n\t|\n) > bs > (|)
            conf = {},
            --contains extension config
        },
        cr = {
            -- *ultimate-autopair-map-newline-config*
            enable = true,
            map = "<cr>", --string or table
            autoclose = false,
            --(| > cr > (\n|\n)
            --addsemi={}, --list of filetypes
            conf = {},
            --contains extension config
        },
        space = {
            -- *ultimate-autopair-map-space-config*
            enable = true,
            map = " ",
            cmap = " ",
            check_box_ft = { "markdown", "vimwiki" },
            --+ [|] > space > + [ ]
            conf = {},
            --contains extension config
        },
        space2 = {
            -- *ultimate-autopair-map-space2-config*
            enable = false,
            match = [[\a]],
            --what character activate
            conf = {},
            --contains extension config
        },
        fastwarp = {
            -- *ultimate-autopair-map-fastwarp-config*
            enable = true,
            enable_normal = true,
            enable_reverse = true,
            hopout = false,
            --{(|)} > fastwarp > {(}|)
            map = "<c-s>",
            rmap = "<c-s>",
            cmap = "<c-s>",
            rcmap = "<c-s>",
            multiline = true,
            --(|) > fastwarp > (\n|)
            nocursormove = true,
            --makes the cursor not move (|)foo > fastwarp > (|foo)
            --disables multiline feature
            --only activates if prev char is start pair, otherwise fallback to normal
            do_nothing_if_fail = true,
            --add a module so that if fastwarp fails
            --then an `e` will not be inserted
            filter = false,
            --whether to use filters (like inside string)
            conf = {},
            --contains extension config
        },
        extensions = {
            -- *ultimate-autopair-extensions-default-config*
            cmdtype = { types = { "/", "?", "@" }, p = 90 },
            filetype = { p = 80, nft = { "TelescopePrompt" } },
            escape = { filter = true, p = 70 },
            string = { p = 60 },
            rules = { p = 40, rules = nil },
            alpha = { p = 30 },
            suround = { p = 20 },
            fly = { other_char = { " " }, nofilter = false, p = 10, undomapconf = {}, undomap = nil, undocmap = nil },
        },
        internal_pairs = { -- *ultimate-autopair-pairs-default-config*
            {
                "[",
                "]",
                fly = true,
                dosuround = true,
                newline = true,
                space = true,
                fastwarp = true,
            },
            {
                "(",
                ")",
                fly = true,
                dosuround = true,
                newline = true,
                space = true,
                fastwarp = true,
            },
            {
                "{",
                "}",
                fly = true,
                dosuround = true,
                newline = true,
                space = true,
                fastwarp = true,
            },
            {
                '"',
                '"',
                suround = true,
                rules = { { "when", { "filetype", "vim" }, { "not", { "regex", "^%s*$" } } } },
                string = true,
            },
            {
                "'",
                "'",
                suround = true,
                rules = { { "when", { "option", "lisp" }, { "instring" } } },
                alpha = true,
                nft = {
                    "tex",
                },
                string = true,
            },
            { "`", "`", nft = { "tex" } },
            { "``", "''", ft = { "tex" } },
            { "```", "```", newline = true, ft = { "markdown" } },
            { "<!--", "-->", ft = { "markdown", "html" } },
            { '"""', '"""', newline = true, ft = { "python" } },
            { "'''", "'''", newline = true, ft = { "python" } },
            { "string", type = "tsnode", string = true },
            { "raw_string", type = "tsnode", string = true },
        },
    }
end

function config.vim_sonictemplate()
    vim.g.sonictemplate_postfix_key = "<C-,>"
    vim.g.sonictemplate_vim_template_dir = os.getenv("HOME") .. "/.config/nvim/template"
end

function config.tabout()
    require("tabout").setup({
        tabkey = "<Tab>", -- key to trigger tabout, set to an empty string to disable
        backwards_tabkey = "<S-Tab>", -- key to trigger backwards tabout, set to an empty string to disable
        act_as_tab = true, -- shift content if tab out is not possible
        act_as_shift_tab = false, -- reverse shift content if tab out is not possible (if your keyboard/terminal supports <S-Tab>)
        default_tab = "<C-t>", -- shift default action (only at the beginning of a line, otherwise <TAB> is used)
        default_shift_tab = "<C-d>", -- reverse shift default action,
        enable_backwards = true, -- well ...
        completion = true, -- if the tabkey is used in a completion pum
        tabouts = {
            { open = "'", close = "'" },
            { open = '"', close = '"' },
            { open = "`", close = "`" },
            { open = "(", close = ")" },
            { open = "[", close = "]" },
            { open = "{", close = "}" },
        },
        ignore_beginning = true, --[[ if the cursor is at the beginning of a filled element it will rather tab out than shift the content ]]
        exclude = {}, -- tabout will ignore these filetypes
    })
    vim.api.nvim_set_keymap("i", "<A-x>", "<Plug>(TaboutMulti)", { silent = true })
    vim.api.nvim_set_keymap("i", "<A-z>", "<Plug>(TaboutBackMulti)", { silent = true })
end

return config
