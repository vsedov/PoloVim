local config = {}
function config.vimtex()
    vim.g.vimtex_view_method = "sioyek" -- sioyek
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
end

function config.papis()
    require("papis").setup({
        -- These are configuration options of the `papis` program relevant to papis.nvim.
        -- Papis.nvim can get them automatically from papis, but this is very slow. It is
        -- recommended to copy the relevant settings from your papis configuration file.
        papis_python = {
            dir = "/home/viv/Documents/papers/",
            info_name = "info.yaml", -- (when setting papis options `-` is replaced with `_`
            -- in the keys names)
            notes_name = [[notes.norg]],
        },
        enable_keymaps = true,
    })
end
return config
