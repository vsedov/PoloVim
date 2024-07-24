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

function config.spellcheck()
    vim.cmd("highlight def link SpelunkerSpellBad SpellBad")
    vim.cmd("highlight def link SpelunkerComplexOrCompoundWord Rare")

    vim.fn["spelunker#check"]()
end

function config.grammcheck()
    vim.cmd([[GrammarousCheck]])
end

function config.markdown()
    -- keybindings
    -- zr: reduces fold level throughout the buffer
    -- zR: opens all folds
    -- zm: increases fold level throughout the buffer
    -- zM: folds everything all the way
    -- za: open a fold your cursor is on
    -- zA: open a fold your cursor is on recursively
    -- zc: close a fold your cursor is on
    -- zC: close a fold your cursor is on recursively

    -- item indent set to 2
    vim.g.vim_markdown_new_list_item_indent = 2
    vim.g.vim_markdown_auto_insert_bullets = 1

    vim.g.vim_markdown_folding_disabled = 1
    vim.g.vim_markdown_conceal_code_blocks = 0
    vim.g.vim_markdown_strikethrough = 1
    vim.g.vim_markdown_conceal = 0
    vim.g.tex_conceal = ""
    vim.g.vim_markdown_math = 1

    vim.g.vim_markdown_frontmatter = 1
    vim.g.vim_markdown_toml_frontmatter = 1
    vim.g.vim_markdown_json_frontmatter = 1
    vim.g.vim_json_syntax_conceal = 0

    -- [link text](link-url) -(keybind: ge)-> create `link-url.md` file
    vim.g.vim_markdown_no_extensions_in_markdown = 1
    vim.g.vim_markdown_autowrite = 1

    -- ===== MarkdownPreview =====
    -- Config ref: https://github.com/iamcco/markdown-preview.nvim

    -- set to 1, nvim will open the preview window after entering the markdown buffer
    vim.g.mkdp_auto_start = 0

    -- set to 1, the nvim will auto close current preview window when change
    -- from markdown buffer to another buffer
    vim.g.mkdp_auto_close = 0

    -- set to 1, the vim will refresh markdown when save the buffer or
    -- leave from insert mode, default 0 is auto refresh markdown as you edit or
    -- move the cursor
    vim.g.mkdp_refresh_slow = 1

    -- set to 1, the MarkdownPreview command can be use for all files,
    -- by default it can be use in markdown file
    vim.g.mkdp_command_for_global = 1

    -- set to 1, preview server available to others in your network
    -- by default, the server listens on localhost (127.0.0.1)
    vim.g.mkdp_open_to_the_world = 0

    -- options for markdown render
    -- mkit: markdown-it options for render
    -- katex: katex options for math
    -- uml: markdown-it-plantuml options
    -- maid: mermaid options
    -- disable_sync_scroll: if disable sync scroll, default 0
    -- sync_scroll_type: 'middle', 'top' or 'relative', default value is 'middle'
    --   middle: mean the cursor position alway show at the middle of the preview page
    --   top: mean the vim top viewport alway show at the top of the preview page
    --   relative: mean the cursor position alway show at the relative positon of the preview page
    -- hide_yaml_meta: if hide yaml metadata, default is 1
    -- sequence_diagrams: js-sequence-diagrams options
    -- content_editable: if enable content editable for preview page, default: v:false
    -- disable_filename: if disable filename header for preview page, default: 0
    vim.g.mkdp_preview_options = {
        mkit = {},
        katex = {},
        uml = {},
        maid = {},
        disable_sync_scroll = 0,
        sync_scroll_type = "middle",
        hide_yaml_meta = 1,
        sequence_diagrams = {},
        flowchart_diagrams = {},
        content_editable = false,
        disable_filename = 0,
    }

    -- use a custom markdown style must be absolute path
    -- like '/Users/username/markdown.css' or expand('~/markdown.css')
    vim.g.mkdp_markdown_css = ""

    -- use a custom highlight style must absolute path
    -- like '/Users/username/highlight.css' or expand('~/highlight.css')
    vim.g.mkdp_highlight_css = ""

    -- preview page title
    -- ${name} will be replace with the file name
    vim.g.mkdp_page_title = "「${name}」"

    -- recognized filetypes
    -- these filetypes will have MarkdownPreview... commands
    vim.g.mkdp_filetypes = { "markdown" }
end

return config
