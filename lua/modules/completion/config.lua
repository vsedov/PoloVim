local config = {}

function config.nvim_lsp()
  require('modules.completion.lspconfig')

end


function config.bqf()

  require('bqf').setup({
      auto_enable = true,
      preview = {
          auto_preview = false,
          win_height = 12,
          win_vheight = 12,
          delay_syntax = 80,
          border_chars = {'┃', '┃', '━', '━', '┏', '┓', '┗', '┛', '█'}
      },
      func_map = {
          vsplit = '',
          ptogglemode = 'z,',
          stoggleup = ''
      }
  })
end


function config.ultisnipsconf()
vim.g.UltiSnipsExpandTrigger = "<C-s>"      
vim.g.UltiSnipsJumpForwardTrigger = "<C-j>" 
vim.g.UltiSnipsJumpBackwardTrigger = "<C-k>"
end


function config.nvim_compe()

  require'compe'.setup {
    enabled = true;
    autocomplete = true,
    debug = false,
    min_length = 1,
    preselect = 'enable',
    throttle_time = 80,
    source_timeout = 200,
    incomplete_delay = 400,
    max_abbr_width = 100,
    max_kind_width = 100,
    max_menu_width = 100,
    documentation = true,
    source = {
        path = {kind = "  "},
        buffer = {kind = "  "},
        
        calc = {kind = "  "},
        vsnip = {kind = "  "},
        nvim_lsp = {priority = 1000,kind = "  "},
        -- nvim_lua = {kind = "  "},
        nvim_lua = false,
        spell = {kind = "  "},
        tags = true,
        vim_dadbod_completion = true,
        tabnine = {priority = 999,kind = "  ",max_line = 1000, show_prediction_strength = true},
        -- snippets_nvim N= {kind = "  "},
        latex_symbols = true,

        -- zsh = true,
        ultisnips = {kind = "  "},
        treesitter=false,
        -- treesitter = {kind = "  "},
        emoji = {kind = " ﲃ ", filetypes={"markdown", "text"}},
        neorg = {priority=1000,filetypes={"neorg","norg"}},
        -- for emoji press : (idk if that in compe tho)
    }
  }
end
function config.vim_vsnip()
  vim.g.vsnip_snippet_dir = os.getenv('HOME') .. '/.config/nvim/snippets'
end

function config.telescope()
  if not packer_plugins['plenary.nvim'].loaded then
    vim.cmd [[packadd plenary.nvim]]
    vim.cmd [[packadd popup.nvim]]
    vim.cmd [[packadd telescope-fzy-native.nvim]]
  end




  require('telescope.main')
  


  require('telescope').load_extension('fzy_native')
  require('telescope').load_extension('dotfiles')

end

function config.vim_sonictemplate()
  vim.g.sonictemplate_postfix_key = '<C-,>'
  vim.g.sonictemplate_vim_template_dir = os.getenv("HOME").. '/.config/nvim/template'
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
  vim.g.user_emmet_mode = 'i'
end


function config.neorunner()

  vim.g.runner_c_compiler = 'gcc'
  vim.g.runner_cpp_compiler = 'g++'
  vim.g.runner_c_options = '-std=c99 -Wall'
  vim.g.runner_cpp_options = '-std=c++11 -Wall'

end

function config.code_runner()
  require('code_runner').setup {
    term = {
      position = "vert",
      size = 60
    },
    fterm = {
      height = 0.7,
      width = 0.7
    }
  }
end

function config.sniprun()

require'sniprun'.setup({
  selected_interpreters = {},     --" use those instead of the default for the current filetype
  repl_enable = {},               --" enable REPL-like behavior for the given interpreters
  repl_disable = {},              --" disable REPL-like behavior for the given interpreters

  interpreter_options = {},       --" intepreter-specific options, consult docs / :SnipInfo <name>

  --" you can combo different display modes as desired
  display = {
    "Classic",                    -- "display results in the command-line  area
    "VirtualTextOk",              -- "display ok results as virtual text (multiline is shortened)

    "VirtualTextErr",          -- "display error results as virtual text
    -- "TempFloatingWindow",      -- "display results in a floating window
    -- "LongTempFloatingWindow",  -- "same as above, but only long results. To use with VirtualText__
    "Terminal"                 -- "display results in a vertical split
    },


  --" miscellaneous compatibility/adjustement settings
  inline_messages = 0,             --" inline_message (0/1) is a one-line way to display messages
           --" to workaround sniprun not being able to display anything

  borders = 'single'               --" display borders around floating windows
                                   --" possible values are 'none', 'single', 'double', or 'shadow'
})

end



function config.doge()
  vim.g.doge_doc_standard_python = 'numpy'
end 

function config.vimtex()

  vim.g.tex_conceal="abdgm"

  vim.g.vimtex_fold_enabled = true
  vim.g.vimtex_indent_enabled = true
  vim.g.vimtex_complete_recursive_bib = false
  vim.g.vimtex_view_method = 'zathura'
  vim.g.vimtex_complete_close_braces = true
  vim.g.vimtex_quickfix_mode = 2
  vim.g.vimtex_quickfix_open_on_warning = false

  vim.g.vimtex_view_general_options = '-reuse-instance @pdf'

  vim.g.vimtex_delim_changemath_autoformat = true

end


--py - put brackets . 
function config.todo_comments()
  if not packer_plugins['plenary.nvim'].loaded then
    vim.cmd [[packadd plenary.nvim]]
  end


  require("todo-comments").setup{
    signs = true, -- show icons in the signs column
    -- keywords recognized as todo comments
    keywords = {
      FIX = {
        icon = " ", -- icon used for the sign, and in search results
        color = "error", -- can be a hex color, or a named color (see below)
        alt = { "FIXME", "BUG", "FIXIT", "FIX", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
        -- signs = false, -- configure signs for some keywords individually
      },
      TODO = { icon = " ", color = "info" },
      HACK = { icon = " ", color = "warning" },
      WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
      PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
      NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
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
      comments_only = true, -- this applies the pattern only inside comments using `commentstring` option
    },
    -- list of named colors where we try to extract the guifg from the
    -- list of hilight groups or use the hex color if hl not found as a fallback
    colors = {
      error = { "LspDiagnosticsDefaultError", "ErrorMsg", "#DC2626" },
      warning = { "LspDiagnosticsDefaultWarning", "WarningMsg", "#FBBF24" },
      info = { "LspDiagnosticsDefaultInformation", "#2563EB" },
      hint = { "LspDiagnosticsDefaultHint", "#10B981" },
      default = { "Identifier", "#7C3AED" },
    },
    search = {
      command = "rg",
      args = {
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
      },
      -- regex that will be used to match keywords.
      -- don't replace the (KEYWORDS) placeholder
      pattern = [[\b(KEYWORDS):]], -- ripgrep regex
      -- pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
    },
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
          action_keys = { -- key mappings for actions in the trouble list
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
    vim.g.ale_python_pylint_options = '--rcfile ~/.config/pylintrc'
    vim.g.ale_python_mypy_options = ''
    vim.g.ale_list_window_size =  4
    vim.g.ale_sign_column_always = 0
    vim.g.ale_open_list = 0


    vim.g.ale_set_loclist = 0

    vim.g.ale_set_quickfix = 1
    vim.g.ale_keep_list_window_open = 1
    vim.g.ale_list_vertical = 0

    vim.g.ale_disable_lsp =1


    vim.g.ale_lint_on_save = 1

    vim.g.ale_sign_error = ''
    vim.g.ale_sign_warning = ''
    vim.g.ale_lint_on_text_changed = 1

    vim.g.ale_echo_msg_format = '[%linter%] %s [%severity%]'

    vim.g.ale_lint_on_insert_leave = 0
    vim.g.ale_lint_on_enter = 0


    vim.g.ale_set_balloons = 1
    vim.g.ale_hover_cursor = 1
    vim.g.ale_hover_to_preview = 1
    vim.g.ale_float_preview = 1
    vim.g.ale_virtualtext_cursor = 1

    vim.g.ale_fix_on_save = 1
    vim.g.ale_fix_on_insert_leave = 0
    vim.g.ale_fix_on_text_changed = 'never'
end

function config.AbbrevMan()
  require("abbrev-man").setup({
      load_natural_dictionaries_at_startup = true,
      load_programming_dictionaries_at_startup = true,
      natural_dictionaries = {

        -- Common mistakes i make . 
        ["nt_en"] = {
          ["adn"] = "and",
          ["THe"] = "The",
          ["my_email"] = "viv.sedov@hotmail.com",
          ["maek"] = "make",
          ["meake"] = "make",

        },

      },
      programming_dictionaries = {
        ["pr_py"] = {
          ["printt"]  = "print",
          ["teh"] = "the",
        }
      }

})

end 



return config
