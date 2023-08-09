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

    lambda.command("SnipCreate", function()
        vim.notify("<cr> to start and ;<cr> to add the variables")
    end, { force = true })
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
        exclude = {}, -- tabout will ignore these filetypes
        ignore_beginning = false,
    })
    vim.api.nvim_set_keymap("i", "<A-x>", "<Plug>(TaboutMulti)", { silent = true })
    vim.api.nvim_set_keymap("i", "<A-z>", "<Plug>(TaboutBackMulti)", { silent = true })
end
function config.autopair()
    require("npairs-int-upair").setup({
        map = "u", --which of them should be the insert mode autopair
        cmap = "u", --which of them should be the cmd mode autopair (only 'u' supported)
        bs = "n", --which of them should be the backspace
        cr = "u", --which of them should be the newline
        space = "u", --which of them should be the space (only 'u' supported)
        c_h = "n", --which of them should be the <C-h> (only 'n' supported)
        c_w = "n", --which of them should be the <C-w> (only 'n' supported)
        rfastwarp = "<c-x>", --ultimate-autopair's reverse fastwarp mapping ('' for disable)
        fastwrap = "<c-s>", --nvim-autopairs's fastwrap mapping ('' for disable)
        npairs_conf = {
            disable_filetype = {
                "aerial",
                "checkhealth",
                "dapui_breakpoints",
                "dapui_console",
                "dapui_scopes",
                "dapui_stacks",
                "dap-repl",
                "DressingSelect",
                "help",
                "lazy",
                "lspinfo",
                "man",
                "mason",
                "netrw",
                "null-ls-info",
                "qf",
            },
            check_ts = true,
            fast_wrap = { highlight = "Question", highlight_grey = "Dimmed" },
        }, --nvim-autopairs's configuration

        upair_conf = {
            config_type = "default",
            map = true,
            cmap = true, --cmap stands for cmd-line map
            pair_map = true,
            pair_cmap = true,
            bs = { -- *ultimate-autopair-map-backspace-config*
                enable = true,

                map = "<bs>", --string or table
                cmap = "<bs>",
                overjumps = true,
                --(|foo) > bs > |foo
                space = true, --false, true or 'balance'
                --( |foo ) > bs > (|foo)
                --balance:
                --  Will prioritize balanced spaces
                --  ( |foo  ) > bs > ( |foo )
                indent_ignore = true,
                --(\n\t|\n) > bs > (|)
                conf = {},
                --contains extension config
            },
            cr = { -- *ultimate-autopair-map-newline-config*
                enable = true,
                map = "<cr>", --string or table
                autoclose = true,
                --(| > cr > (\n|\n)
                --addsemi={}, --list of filetypes
                conf = {},
                --contains extension config
            },
            space = { -- *ultimate-autopair-map-space-config*
                enable = true,
                map = " ",
                cmap = " ",
                check_box_ft = { "markdown", "vimwiki" },
                --+ [|] > space > + [ ]
                conf = {},
                --contains extension config
            },
            space2 = { -- *ultimate-autopair-map-space2-config*
                enable = true,
                match = [[\a]],
                --what character activate
                conf = {},
                --contains extension config
            },
            fastwarp = { -- *ultimate-autopair-map-fastwarp-config*
                enable = true,
                enable_normal = true,
                enable_reverse = true,
                hopout = true,
                map = "<c-n>",
                rmap = "<c-p>",
                cmap = "<c-n>",
                rcmap = "<c-p>",
                multiline = true,
                nocursormove = true,
                do_nothing_if_fail = true,
                filter = false,
                conf = {},
            },
        },
    })
    -- local npairs = require("nvim-autopairs")
    -- local function backspace()
    --     local col = vim.api.nvim_win_get_cursor(0)[2]
    --     local char = vim.api.nvim_get_current_line():sub(col, col)
    --     if char == " " then
    --         -- expression from a deleted reddit user
    --         vim.cmd([[
    --         let g:exprvalue =
    --         \ (&indentexpr isnot '' ? &indentkeys : &cinkeys) =~? '!\^F' &&
    --         \ &backspace =~? '.*eol\&.*start\&.*indent\&' &&
    --         \ !search('\S','nbW',line('.')) ? (col('.') != 1 ? "\<C-U>" : "") .
    --         \ "\<bs>" . (getline(line('.')-1) =~ '\S' ? "" : "\<C-F>") : "\<bs>"
    --     ]])
    --         return vim.g.exprvalue
    --     else
    --         return npairs.autopairs_bs()
    --     end
    -- end
    -- -- map <bs> to <c-<bs>>
    -- -- vim.api.nvim_set_keymap("i", "<c-<bs>>", ""
    --
    -- vim.keymap.set(
    --     "i",
    --     "<BS>",
    --     backspace,
    --     { expr = true, noremap = true, replace_keycodes = false, desc = "Better Backspace" }
    -- )
end

return config
