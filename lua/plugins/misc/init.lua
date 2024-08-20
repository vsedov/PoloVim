local opts = { move_cursor = true, keymaps = { visual = "s" } }
require("nvim-surround").setup(opts)

-- surr*ound_words             ysiw)           (surround_words)
-- *make strings               ys$"            "make strings"
-- [delete ar*ound me!]        ds]             delete around me!
-- remove <b>HTML t*ags</b>    dst             remove HTML tags
-- 'change quot*es'            cs'"            "change quotes"
-- <b>or tag* types</b>        csth1<CR>       <h1>or tag types</h1>
-- delete(functi*on calls)     dsf             function calls

local bind_list = {
    ["surround_word"] = {
        bind = "ysiw)",
        text = "(surround_words)",
    },

    ["*make strings"] = {
        bind = 'ys$"',
        text = '"make strings"',
    },

    ["[delete around me!]"] = {
        bind = "ds]",
        text = "delete around me!",
    },

    ["remove <b>HTML tags</b>"] = {
        bind = "dst",
        text = "remove HTML tags",
    },

    ["'change quotes'"] = {
        bind = "cs'\"",
        text = '"change quotes"',
    },

    ["<b>or tag types</b>"] = {
        bind = "csth1<CR>",
        text = "<h1>or tag types</h1>",
    },

    ["delete(function calls)"] = {
        bind = "dsf",
        text = "function calls",
    },
}

-- not make it like info, bind , text in one big text and print it using vim.notify
local table_string = ""
for k, v in pairs(bind_list) do
    table_string = table_string .. k .. " " .. v.bind .. " " .. v.text .. "\n"
end

lambda.command("SurroundBinds", function()
    vim.notify(table_string)
end)

vim.keymap.set({ "i", "n" }, "<C-y>", "<Plug>(dmacro-play-macro)")

vim.g.wordmotion_prefix = ","
vim.g.wordmotion_nomap = 1
require("spider").setup({
    skipInsignificantPunctuation = true,
    consistentOperatorPending = false, -- see "Consistent Operator-pending Mode" in the README
    subwordMovement = true,
    customPatterns = {}, -- check "Custom Movement Patterns" in the README for details
})

vim.keymap.set({ "n", "o", "x" }, "w", "<cmd>lua require('spider').motion('w')<CR>", { desc = "Spider-w" })
vim.keymap.set({ "n", "o", "x" }, "e", "<cmd>lua require('spider').motion('e')<CR>", { desc = "Spider-e" })
vim.keymap.set({ "n", "o", "x" }, "b", "<cmd>lua require('spider').motion('b')<CR>", { desc = "Spider-b" })
vim.keymap.set({ "n", "o", "x" }, "ge", "<cmd>lua require('spider').motion('ge')<CR>", { desc = "Spider-ge" })
vim.keymap.set("o", "w", "<cmd>lua require('spider').motion('w')<CR>")
vim.keymap.set("n", "cw", "ce", { remap = true })

-- or the same in one mapping without `remap = true`
vim.keymap.set("n", "cw", "c<cmd>lua require('spider').motion('e')<CR>")
local oil = require("oil")

oil.setup({
    skip_confirm_for_simple_edits = true,
    view_options = {
        show_hidden = true,
        natural_order = true,
        is_always_hidden = function(name, _)
            return name == ".." or name == ".git"
        end,
        win_options = {
            wrap = true,
        },
    },
})
vim.keymap.set("n", "-", ":Oil<CR>", { desc = "Open parent directory" })

-- Might as well configure vimtex if it ever gets loaded
-- ──────────────────────────────────────────────────────────────────────
vim.g.vimtex_view_method = "zathura" -- sioyek
vim.g.vimtex_view_general_options = "@pdf"
vim.g.vimtex_compiler_method = "latexmk"
vim.g.vimtex_compiler_latexmk = {
    executable = "latexmk",
    out_dir = "output",
    options = {
        "--pdflatex",
        "--shell-escape",
        "--file-line-error",
        "--synctex=1",
        "--interaction=nonstopmode",
    },
}

vim.cmd([[
        let g:Tex_FormatDependency_dvi='dvi,ps,pdf'
        let g:Tex_DefaultTargetFormat='pdf'
    ]])
vim.g.vimtex_quickfix_mode = 0
vim.g.vimtex_view_automatic = 1

vim.cmd([[ " backwards search
            function! s:write_server_name() abort
            let nvim_server_file = "/tmp/vimtexserver.txt"
            call writefile([v:servername], nvim_server_file)
            endfunction

            augroup vimtex_common
            autocmd!
            autocmd FileType tex call s:write_server_name()
            augroup END
        ]])

vim.g.vimtex_syntax_enable = 1
-- vim.g.vimtex_syntax_conceal_disable = 0
vim.opt.conceallevel = 2
vim.g.vimtex_quickfix_ignore_filters = {
    "Command terminated with space",
    "LaTeX Font Warning: Font shape",
    "Package caption Warning: The option",
    [[Underfull \\hbox (badness [0-9]*) in]],
    "Package enumitem Warning: Negative labelwidth",
    [[Overfull \\hbox ([0-9]*.[0-9]*pt too wide) in]],
    [[Package caption Warning: Unused \\captionsetup]],
    "Package typearea Warning: Bad type area settings!",
    [[Package fancyhdr Warning: \\headheight is too small]],
    [[Underfull \\hbox (badness [0-9]*) in paragraph at lines]],
    "Package hyperref Warning: Token not allowed in a PDF string",
    [[Overfull \\hbox ([0-9]*.[0-9]*pt too wide) in paragraph at lines]],
}
vim.g.matchup_override_vimtex = 1
