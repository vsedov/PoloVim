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
    end, {force =true})
end

function config.autopair()
    return {
        bs = {
            enable = true,
            overjump = true,
            space = true,
            multichar = true,
            fallback = nil,
        },
        cr = {
            enable = true,
            autoclose = false,
            multichar = {
                enable = false,
                markdown = { { "```", "```", pair = true, noalpha = true, next = true } },
                lua = { { "then", "end" }, { "do", "end" } },
            },
            addsemi = { "c", "cpp", "rust" },
            fallback = nil,
        },
        fastwarp = {
            enable = true,
            hopout = true,
            map = "<c-e>",
            rmap = "<C-E>",
            Wmap = "<C-e>",
            cmap = "<c-e>",
            rcmap = "<c-E>",
            Wcmap = "<c-e>",
            multiline = true,
            fallback = nil,
        },
        fastend = {
            enable = true,
            map = "<c-c>",
            cmap = "<c-c>",
            smart = true,
            fallback = nil,
        },
    }
end

function config.vim_sonictemplate()
    vim.g.sonictemplate_postfix_key = "<C-,>"
    vim.g.sonictemplate_vim_template_dir = os.getenv("HOME") .. "/.config/nvim/template"
end

function config.tabout()
    require("tabout").setup({
        tabkey = "<C-;>",
        backwards_tabkey = "<C-j>",
        act_as_tab = true, -- shift content if tab out is not possible
        act_as_shift_tab = false, -- reverse shift content if tab out is not possible (if your keyboard/terminal supports <S-Tab>)
        default_tab = "<C-t>", -- shift default action (only at the beginning of a line, otherwise <TAB> is used)
        default_shift_tab = "<C-i>", -- reverse shift default action,
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
