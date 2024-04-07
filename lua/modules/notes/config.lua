local config = {}

function config.neorg()
    require("modules.notes.neorg")
end

function config.femaco()
    require("femaco").setup()
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
