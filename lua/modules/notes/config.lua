local config = {}

function config.neorg()
    require("modules.notes.neorg")
end

function config.femaco()
    require("femaco").setup()
end

function config.jot()
    require("jot").setup({
        search_dir = "~/neorg/",
        search_depth = 10,
        hide_search_dir = false,
        post_open_hook = function() end,
    })
end

function config.mdeval()
    require("mdeval").setup({
        -- Don't ask before executing code blocks
        require_confirmation = false,
        -- Change code blocks evaluation options.
        eval_options = {
            python = {
                command = { "python" }, -- Command to run interpreter
                language_code = "python", -- Markdown language code
                extension = "py", -- File extension for temporary files
            },
        },
    })
    vim.g.markdown_fenced_languages = { "python", "cpp" }

    lambda.command("RunBlock", function()
        require("mdeval").eval_code_block()
    end, {})
end

function config.vimtex()
    vim.g.vimtex_view_method = "sioyek" -- sioyek
    vim.g.vimtex_compiler_method = "latexmk"
    vim.g.vimtex_compiler_latexmk = {
        build_dir = "build",
        callback = 1,
        continuous = 1,
        executable = "latexmk",
        hooks = {},
        options = {
            "-pdf",
            "-shell-escape",
            "-verbose",
            "-file-line-error",
            "-synctex=1",
            "-pvc",
            "-interaction=nonstopmode",
        },
    }
    vim.g.vimtex_imaps_enabled = true
    -- TOC settings
    vim.g.vimtex_toc_config = {
        name = "TOC",
        layers = "['content', 'todo']",
        resize = 1,
        split_width = 50,
        todo_sorted = 0,
        show_help = 1,
        show_numbers = 1,
        mode = 2,
    }

    -- Ignore undesired errors and warnings
    vim.g.vimtex_quickfix_ignore_filters = {
        "Underfull",
        "Overfull",
        "undefined references",
        "(re)run Biber",
        "Unused global option(s)",
    }

    vim.g.vimtex_quickfix_autoclose_after_keystrokes = 1
    vim.g.vimtex_quickfix_open_on_warning = 0
    vim.g.vimtext_quickfix_mode = 1
    -- QuickFix is just annoying
    vim.g.vimtex_quickfix_enabled = 0
end
function config.table()
    vim.g.table_mode_corner = "|"
    vim.cmd([[
function! s:isAtStartOfLine(mapping)
  let text_before_cursor = getline('.')[0 : col('.')-1]
  let mapping_pattern = '\V' . escape(a:mapping, '\')
  let comment_pattern = '\V' . escape(substitute(&l:commentstring, '%s.*$', '', ''), '\')
  return (text_before_cursor =~? '^' . ('\v(' . comment_pattern . '\v)?') . '\s*\v' . mapping_pattern . '\v$')
endfunction

inoreabbrev <expr> <bar><bar>
          \ <SID>isAtStartOfLine('\|\|') ?
          \ '<c-o>:TableModeEnable<cr><bar><space><bar><left><left>' : '<bar><bar>'
inoreabbrev <expr> __
          \ <SID>isAtStartOfLine('__') ?
          \ '<c-o>:silent! TableModeDisable<cr>' : '__'w
        ]])
end

function config.hologram()
    lambda.command("Hologram", function()
        vim.cmd([[ Lazy load hologram.nvim]])
    end, {})
    require("hologram").setup({
        auto_display = true, -- WIP automatic markdown image display, may be prone to breaking
    })
end
return config
