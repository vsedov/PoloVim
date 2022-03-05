local vim = vim

local autocmd = {}

function autocmd.nvim_create_augroups(defs)
    for group_name, definition in pairs(defs) do
        vim.api.nvim_create_augroup(group_name, { clear = true })
        for _, def in ipairs(definition) do
            event = def[1]
            arg = {
                group = group_name,
                pattern = def[2],
                command = def[3],
                nested = def[4],
            }
            vim.api.nvim_create_autocmd(event, arg)
        end
    end
end
-- "*.v, *.go, *.json, *.js, *.jsx, *.php, *.c, *.h, *.cpp, *.cxx, *.java, *.tml, *.tsx, *.lua, *.ts, *.py, *.sh, *.zsh, *.css, *.html. *.dart"
function autocmd.load_autocmds()
    local definitions = {
        bufs = {
            { "BufWritePost", "*.json", ":silent :JqxList" },
            { "BufWritePost", "*.sum,", ":silent :GoModTidy" },
            { "BufWritePost", "*.mod", ":silent :GoModTidy" },

            {
                "TextYankPost",
                "*",
                ":silent! :lua vim.highlight.on_yank {higroup='IncSearch', timeout=1500, on_visual=false}",
            },
            { "FileType", "css,scss", "let b:prettier_exec_cmd = 'prettier-stylelint'" },
            -- {"FileType","lua","nmap <leader><leader>t <Plug>PlenaryTestFile"};
            {
                "FileType",
                "markdown",
                "let b:prettier_exec_cmd = 'prettier' | let g:prettier#exec_cmd_path = '/usr/local/bin/prettier' | let g:spelunker_check_type = 1",
            },
            {
                "BufReadPre",
                "*",
                'if getfsize(expand("%")) > 1000000 | ownsyntax off | endif',
            },
            { "BufWritePost", "plugins.lua", "PackerCompile" },
            -- {"UIEnter", "*", ":silent! :lua require('modules.lang.config').syntax_folding()"},
            { "BufReadPre", "*", ":silent! :lua require('modules.lang.config').nvim_treesitter()" },
            -- {"BufWritePre", "*.js,*.rs,*.lua", ":FormatWrite"},
            -- {"BufWritePre", "*.go", ":silent! :lua require('go.format').gofmt()"}
            -- {"InsertEnter", "*", ":silent! :lua require('modules.editor.config').pears_setup()"}
        },
    }

    autocmd.nvim_create_augroups(definitions)
end

autocmd.load_autocmds()
return autocmd
