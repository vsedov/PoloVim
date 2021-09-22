local config = {}

function config.nvim_lsp()
    require("modules.completion.lspconfig")
end

function config.cmp()
  local cmp = require("cmp")
    local t = function(str)
      return vim.api.nvim_replace_termcodes(str, true, true, true)
    end

    local check_back_space = function()
      local col = vim.fn.col(".") - 1
      return col == 0 or vim.fn.getline("."):sub(col, col):match("%s") ~= nil
    end


    local sources = {
        {name = "nvim_lsp"},
        {name = "cmp_tabnine"},
        {name = "treesitter", keyword_length = 2},
        {name = "ultisnips"},
        {name = "look", keyword_length = 4},
        {name = "nvim_lua"},
        {name = "buffer"},
        {name = "path"},
        {name = "spell"},
        {name = "tmux"},
        {name = "calc"}
    }

    local cmp = require("cmp")
    if vim.o.ft == "sql" then
        table.insert(sources, {name = "vim-dadbod-completion"})
    end
    if vim.o.ft == "markdown" then
        table.insert(sources, {name = "spell"})
        table.insert(sources, {name = "look"})
    end



    cmp.setup({
      snippet = {
        expand = function(args)
          vim.fn["UltiSnips#Anon"](args.body)
        end,
      },
  
      -- Configure for <TAB> people
      -- - <TAB> and <S-TAB>: cycle forward and backward through autocompletion items
      -- - <TAB> and <S-TAB>: cycle forward and backward through snippets tabstops and placeholders
      -- - <TAB> to expand snippet when no completion item selected (you don't need to select the snippet from completion item to expand)
      -- - <C-space> to expand the selected snippet from completion menu
      mapping = {
        ["<C-Space>"] = cmp.mapping(function(fallback)
          if vim.fn.pumvisible() == 1 then
            if vim.fn["UltiSnips#CanExpandSnippet"]() == 1 then
              return vim.fn.feedkeys(t("<C-R>=UltiSnips#ExpandSnippet()<CR>"))
            end

            vim.fn.feedkeys(t("<C-n>"), "n")
          elseif check_back_space() then
            vim.fn.feedkeys(t("<cr>"), "n")
          else
            fallback()
          end
        end, {
          "i",
          "s",
        }),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if vim.fn.complete_info()["selected"] == -1 and vim.fn["UltiSnips#CanExpandSnippet"]() == 1 then
            vim.fn.feedkeys(t("<C-R>=UltiSnips#ExpandSnippet()<CR>"))
          elseif vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
            vim.fn.feedkeys(t("<ESC>:call UltiSnips#JumpForwards()<CR>"))
          elseif vim.fn.pumvisible() == 1 then
            vim.fn.feedkeys(t("<C-n>"), "n")
          elseif check_back_space() then
            vim.fn.feedkeys(t("<tab>"), "n")
          else
            fallback()
          end
        end, {
          "i",
          "s",
        }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
            return vim.fn.feedkeys(t("<C-R>=UltiSnips#JumpBackwards()<CR>"))
          elseif vim.fn.pumvisible() == 1 then
            vim.fn.feedkeys(t("<C-p>"), "n")
          else
            fallback()
          end
        end, {
          "i",
          "s",
        }),
      },
        sources = sources
    })
  end






function config.tabnine()
    local tabnine = require("cmp_tabnine.config")
    tabnine:setup({max_line = 1000, max_num_results = 20, sort = true})
end









function config.bqf()
    require("bqf").setup(
        {
            auto_enable = true,
            preview = {
                auto_preview = false,
                win_height = 12,
                win_vheight = 12,
                delay_syntax = 80,
                border_chars = {"┃", "┃", "━", "━", "┏", "┓", "┗", "┛", "█"}
            },
            func_map = {
                vsplit = "",
                ptogglemode = "z,",
                stoggleup = ""
            }
        }
    )
end

function config.jdtls()
    require("modules.completion.jdtls")
end

function config.telescope()
    if not packer_plugins["plenary.nvim"].loaded then
        vim.cmd [[packadd plenary.nvim]]
        vim.cmd [[packadd popup.nvim]]
        vim.cmd [[packadd telescope-fzy-native.nvim]]
    end
    require("telescope.main")
end

function config.vim_sonictemplate()
    vim.g.sonictemplate_postfix_key = "<C-,>"
    vim.g.sonictemplate_vim_template_dir = os.getenv("HOME") .. "/.config/nvim/template"
end

-- function config.smart_input()
--   require('smartinput').setup {
--     ['go'] = { ';',':=',';' }
--   }
-- end

function config.emmet()
    vim.g.user_emmet_complete_tag = 0
    vim.g.user_emmet_install_global = 0
    vim.g.user_emmet_install_command = 0
    vim.g.user_emmet_mode = "i"
end

function config.neorunner()
    vim.g.runner_c_compiler = "gcc"
    vim.g.runner_cpp_compiler = "g++"
    vim.g.runner_c_options = "-Wall"
    vim.g.runner_cpp_options = "-std=c++11 -Wall"
end

function config.sniprun()
    require "sniprun".setup(
        {
            selected_interpreters = {}, --" use those instead of the default for the current filetype
            repl_enable = {}, --" enable REPL-like behavior for the given interpreters
            repl_disable = {}, --" disable REPL-like behavior for the given interpreters
            interpreter_options = {}, --" intepreter-specific options, consult docs / :SnipInfo <name>
            --" you can combo different display modes as desired
            display = {
                "Classic", -- "display results in the command-line  area
                "VirtualTextOk", -- "display ok results as virtual text (multiline is shortened)
                "VirtualTextErr", -- "display error results as virtual text
                -- "TempFloatingWindow",      -- "display results in a floating window
                -- "LongTempFloatingWindow",  -- "same as above, but only long results. To use with VirtualText__
                "Terminal" -- "display results in a vertical split
            },
            --" miscellaneous compatibility/adjustement settings
            inline_messages = 0, --" inline_message (0/1) is a one-line way to display messages
            --" to workaround sniprun not being able to display anything

            borders = "single" --" display borders around floating windows
            --" possible values are 'none', 'single', 'double', or 'shadow'
        }
    )
end

function config.doge()
    vim.g.doge_doc_standard_python = "numpy"
end

function config.vimtex()
    vim.g.tex_conceal = "abdgm"

    vim.g.vimtex_fold_enabled = true
    vim.g.vimtex_indent_enabled = true
    vim.g.vimtex_complete_recursive_bib = false
    vim.g.vimtex_view_method = "zathura"
    vim.g.vimtex_complete_close_braces = true
    vim.g.vimtex_quickfix_mode = 2
    vim.g.vimtex_quickfix_open_on_warning = false

    vim.g.vimtex_view_general_options = "-reuse-instance @pdf"

    vim.g.vimtex_delim_changemath_autoformat = true
end

--py - put brackets .
function config.todo_comments()
    if not packer_plugins["plenary.nvim"].loaded then
        vim.cmd [[packadd plenary.nvim]]
    end

    require("todo-comments").setup {
        signs = true, -- show icons in the signs column
        -- keywords recognized as todo comments
        keywords = {
            FIX = {
                icon = " ", -- icon used for the sign, and in search results
                color = "error", -- can be a hex color, or a named color (see below)
                alt = {"FIXME", "BUG", "FIXIT", "FIX", "ISSUE"} -- a set of other keywords that all map to this FIX keywords
                -- signs = false, -- configure signs for some keywords individually
            },
            TODO = {icon = " ", color = "info"},
            HACK = {icon = " ", color = "warning"},
            WARN = {icon = " ", color = "warning", alt = {"WARNING", "XXX"}},
            PERF = {icon = " ", alt = {"OPTIM", "PERFORMANCE", "OPTIMIZE"}},
            NOTE = {icon = " ", color = "hint", alt = {"INFO"}}
        },
        -- highlighting of the line containing the todo comment
        -- * before: highlights before the keyword (typically comment characters)
        -- * keyword: highlights of the keyword
        -- * after: highlights after the keyword (todo text)
        highlight = {
            before = "", -- "fg" or "bg" or empty
            keyword = "wide", -- "fg", "bg", "wide" or empty. (wide is the same as bg, but will also highlight surrounding characters)
            after = "fg", -- "fg" or "bg" or empty
            pattern = [[.*<(KEYWORDS)\s*:]], -- pattern used for highlightng (vim regex)
            comments_only = true -- this applies the pattern only inside comments using `commentstring` option
        },
        -- list of named colors where we try to extract the guifg from the
        -- list of hilight groups or use the hex color if hl not found as a fallback
        colors = {
            error = {"LspDiagnosticsDefaultError", "ErrorMsg", "#DC2626"},
            warning = {"LspDiagnosticsDefaultWarning", "WarningMsg", "#FBBF24"},
            info = {"LspDiagnosticsDefaultInformation", "#2563EB"},
            hint = {"LspDiagnosticsDefaultHint", "#10B981"},
            default = {"Identifier", "#7C3AED"}
        },
        search = {
            command = "rg",
            args = {
                "--color=never",
                "--no-heading",
                "--with-filename",
                "--line-number",
                "--column"
            },
            -- regex that will be used to match keywords.
            -- don't replace the (KEYWORDS) placeholder
            pattern = [[\b(KEYWORDS):]] -- ripgrep regex
            -- pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
        }
    }
end

-- FUCKING DOG SHIT PLUGIN IS BROKEN , GET THIS PRICK TO FIX THE FUCKING SHIT
-- HONESTLY , FUCK THIS
function config.trouble()
    require("trouble").setup {
        position = "bottom", -- position of the list can be: bottom, top, left, right
        height = 4, -- height of the trouble list when position is top or bottom
        width = 90, -- width of the list when position is left or right
        icons = true, -- use devicons for filenames
        mode = "lsp_document_diagnostics", -- "lsp_workspace_diagnostics", "lsp_document_diagnostics", "quickfix", "lsp_references", "loclist"
        fold_open = "", -- icon used for open folds
        fold_closed = "", -- icon used for closed folds
        action_keys = {
            -- key mappings for actions in the trouble list
            close = "q", -- close the list
            cancel = "<esc>", -- cancel the preview and get back to your last window / buffer / cursor
            refresh = "r", -- manually refresh
            jump = {"<cr>", "<tab>"}, -- jump to the diagnostic or open / close folds
            jump_close = {"o"}, -- jump to the diagnostic and close the list
            toggle_mode = "m", -- toggle between "workspace" and "document" diagnostics mode
            toggle_preview = "P", -- toggle auto_preview
            hover = "K", -- opens a small poup with the full multiline message
            preview = "p", -- preview the diagnostic location
            close_folds = {"zM", "zm"}, -- close all folds
            open_folds = {"zR", "zr"}, -- open all folds
            toggle_fold = {"zA", "za"}, -- toggle fold of current file
            previous = "k", -- preview item
            next = "j" -- next item
        },
        indent_lines = true, -- add an indent guide below the fold icons
        auto_open = false, -- automatically open the list when you have diagnostics
        auto_close = false, -- automatically close the list when you have no diagnostics
        auto_preview = true, -- automatyically preview the location of the diagnostic. <esc> to close preview and go back to last window
        auto_fold = false, -- automatically fold a file trouble list at creation
        signs = {
            -- icons / text used for a diagnostic
            error = "",
            warning = "",
            hint = "",
            information = "",
            other = "﫠"
        },
        use_lsp_diagnostic_signs = false -- enabling this will use the signs defined in your lsp client
    }
end

function config.ale()
    vim.g.ale_completion_enabled = 0
    vim.g.ale_python_mypy_options = ""
    vim.g.ale_list_window_size = 4
    vim.g.ale_sign_column_always = 0
    vim.g.ale_open_list = 0

    vim.g.ale_set_loclist = 0

    vim.g.ale_set_quickfix = 1
    vim.g.ale_keep_list_window_open = 1
    vim.g.ale_list_vertical = 0

    vim.g.ale_disable_lsp = 1

    vim.g.ale_lint_on_save = 1

    vim.g.ale_sign_error = ""
    vim.g.ale_sign_warning = ""
    vim.g.ale_lint_on_text_changed = 1

    vim.g.ale_echo_msg_format = "[%linter%] %s [%severity%]"

    vim.g.ale_lint_on_insert_leave = 0
    vim.g.ale_lint_on_enter = 0

    vim.g.ale_set_balloons = 1
    vim.g.ale_hover_cursor = 1
    vim.g.ale_hover_to_preview = 1
    vim.g.ale_float_preview = 1
    vim.g.ale_virtualtext_cursor = 1

    vim.g.ale_fix_on_save = 1
    vim.g.ale_fix_on_insert_leave = 0
    vim.g.ale_fix_on_text_changed = "never"
end

function config.AbbrevMan()
    require("abbrev-man").setup(
        {
            load_natural_dictionaries_at_startup = true,
            load_programming_dictionaries_at_startup = true,
            natural_dictionaries = {
                -- Common mistakes i make .
                ["nt_en"] = {
                    ["adn"] = "and",
                    ["THe"] = "The",
                    ["my_email"] = "viv.sedov@hotmail.com",
                    ["maek"] = "make",
                    ["meake"] = "make"
                }
            },
            programming_dictionaries = {
                ["pr_py"] = {
                    ["printt"] = "print",
                    ["teh"] = "the"
                }
            }
        }
    )
end

function config.autopairs()
    require("nvim-autopairs").setup {fast_wrap = {}}
    require("nvim-autopairs.completion.cmp").setup(
        {
            map_cr = true,
            map_complete = true,
            auto_select = true
        }
    )
end

return config

-- function config.cmp()
--     local t = function(str)
--         return vim.api.nvim_replace_termcodes(str, true, true, true)
--     end

--     local cmp = require('cmp')
--     cmp.setup {
--         formatting = {
--             format = function(entry, vim_item)
--                 local lspkind_icons = {
--                     Text = "",
--                     Method = "",
--                     Function = "",
--                     Constructor = "",
--                     Field = "ﰠ",
--                     Variable = "",
--                     Class = "ﴯ",
--                     Interface = "",
--                     Module = "",
--                     Property = "ﰠ",
--                     Unit = "塞",
--                     Value = "",
--                     Enum = "",
--                     Keyword = "",
--                     Snippet = "",
--                     Color = "",
--                     File = "",
--                     Reference = "",
--                     Folder = "",
--                     EnumMember = "",
--                     Constant = "",
--                     Struct = "פּ",
--                     Event = "",
--                     Operator = "",
--                     TypeParameter = ""
--                 }
--                 -- load lspkind icons
--                 vim_item.kind = string.format("%s %s",
--                                               lspkind_icons[vim_item.kind],
--                                               vim_item.kind)

--                 vim_item.menu = ({
--                     cmp_tabnine = "[TN]",
--                     nvim_lsp = "[LSP]",
--                     nvim_lua = "[Lua]",
--                     buffer = "[BUF]",
--                     path = "[PATH]",
--                     tmux = "[TMUX]",
--                     luasnip = "[SNIP]",
--                     spell = "[SPELL]"
--                 })[entry.source.name]

--                 return vim_item
--             end
--         },
--         -- You can set mappings if you want
--         mapping = {
--             ['<C-p>'] = cmp.mapping.select_prev_item(),
--             ['<C-n>'] = cmp.mapping.select_next_item(),
--             ['<C-d>'] = cmp.mapping.scroll_docs(-4),
--             ['<C-f>'] = cmp.mapping.scroll_docs(4),
--             ['<C-e>'] = cmp.mapping.close(),
--             ["<Tab>"] = function(fallback)
--                 if vim.fn.pumvisible() == 1 then
--                     vim.fn.feedkeys(t("<C-n>"), "n")
--                 else
--                     fallback()
--                 end
--             end,
--             ["<S-Tab>"] = function(fallback)
--                 if vim.fn.pumvisible() == 1 then
--                     vim.fn.feedkeys(t("<C-p>"), "n")
--                 else
--                     fallback()
--                 end
--             end,
--             ["<C-h>"] = function(fallback)
--                 if require("luasnip").jumpable(-1) then
--                     vim.fn.feedkeys(t("<Plug>luasnip-jump-prev"), "")
--                 else
--                     fallback()
--                 end
--             end,
--             ["<C-l>"] = function(fallback)
--                 if require("luasnip").expand_or_jumpable() then
--                     vim.fn.feedkeys(t("<Plug>luasnip-expand-or-jump"), "")
--                 else
--                     fallback()
--                 end
--             end
--         },

--         snippet = {
--             expand = function(args)
--                 require("luasnip").lsp_expand(args.body)
--             end
--         },

--         -- You should specify your *installed* sources.
--         sources = {
--             {name = 'nvim_lsp'}, {name = 'nvim_lua'}, {name = 'luasnip'},
--             {name = 'buffer'}, {name = 'path'}, {name = 'spell'},
--             {name = 'tmux'},
--           {name = 'cmp_tabnine'},
--         }
--     }
-- end

-- function config.luasnip()
--     require('luasnip').config.set_config {
--         history = true,
--         updateevents = "TextChanged,TextChangedI"
--     }
--     require("luasnip/loaders/from_vscode").load()
-- end

-- function config.tabnine()
--     local tabnine = require('cmp_tabnine.config')
--     tabnine:setup({max_line = 1000, max_num_results = 20, sort = true})
-- end
