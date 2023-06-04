local config = {}

function config.fm()
    require("fm-nvim").setup({
        ui = {
            float = {
                border = lambda.style.border.type_0,
            },
        },
    })
end

function config.workspace()
    require("workspaces").setup({
        global_cd = true,
        sort = true,
        notify_info = true,

        hooks = {
            open = { "Neotree", "Telescope find_files" },
        },
    })
    require("telescope").load_extension("workspaces")
end

function config.vim_vista()
    vim.g["vista#renderer#enable_icon"] = 1
    vim.g.vista_disable_statusline = 1

    vim.g.vista_default_executive = "nvim_lsp" -- ctag
    vim.g.vista_echo_cursor_strategy = "floating_win"
    vim.g.vista_vimwiki_executive = "markdown"
    vim.g.vista_executive_for = {
        vimwiki = "markdown",
        pandoc = "markdown",
        markdown = "toc",
        typescript = "nvim_lsp",
        typescriptreact = "nvim_lsp",
        go = "nvim_lsp",
        lua = "nvim_lsp",
    }

    -- vim.g['vista#renderer#icons'] = {['function'] = "", ['method'] = "ℱ", variable = "כֿ"}
end

function config.spellcheck()
    vim.cmd("highlight def link SpelunkerSpellBad SpellBad")
    vim.cmd("highlight def link SpelunkerComplexOrCompoundWord Rare")

    vim.fn["spelunker#check"]()
end

function config.grammcheck()
    vim.cmd([[GrammarousCheck]])
end

function config.markdown()
    vim.g.vim_markdown_frontmatter = 1
    vim.g.vim_markdown_strikethrough = 1
    vim.g.vim_markdown_folding_level = 6
    vim.g.vim_markdown_override_foldtext = 1
    vim.g.vim_markdown_folding_style_pythonic = 1
    vim.g.vim_markdown_conceal = 1
    vim.g.vim_markdown_conceal_code_blocks = 1
    vim.g.vim_markdown_new_list_item_indent = 0
    vim.g.vim_markdown_toc_autofit = 0
    vim.g.vim_markdown_edit_url_in = "vsplit"
    vim.g.vim_markdown_strikethrough = 1
    vim.g.vim_markdown_fenced_languages = {
        "c++=javascript",
        "js=javascript",
        "json=javascript",
        "jsx=javascript",
        "tsx=javascript",
    }
end

function config.mkdp()
    -- print("mkdp")
    vim.g.mkdp_command_for_global = 1
    vim.cmd(
        [[let g:mkdp_preview_options = { 'mkit': {}, 'katex': {}, 'uml': {}, 'maid': {}, 'disable_sync_scroll': 0, 'sync_scroll_type': 'middle', 'hide_yaml_meta': 1, 'sequence_diagrams': {}, 'flowchart_diagrams': {}, 'content_editable': v:true, 'disable_filename': 0 }]]
    )
end

return config
