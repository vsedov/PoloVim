local config = {}

function config.nvim_lsp()
  require('modules.completion.lspconfig')
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
        -- buffer = {kind = "  "},
        calc = {kind = "  "},
        vsnip = {kind = "  "},
        nvim_lsp = {kind = "  "},
        -- nvim_lua = {kind = "  "},
        nvim_lua = false,
        -- spell = {kind = "  "},
        tags = false,
        vim_dadbod_completion = false,
        tabnine = {kind = "TN "},
        -- snippets_nvim N= {kind = "  "},
        latex_symbols = true,
        -- zsh = true,
        ultisnips = {kind = "  "},
        --treesitter = {kind = "  "},
        emoji = {kind = " ﲃ ", filetypes={"markdown", "text"}}
        -- for emoji press : (idk if that in compe tho)
    }
  }
end


function config.ultisnipsconf()
vim.g.UltiSnipsExpandTrigger = "<C-s>"      
vim.g.UltiSnipsJumpForwardTrigger = "<C-j>" 
vim.g.UltiSnipsJumpBackwardTrigger = "<C-k>"
end


-- function config.run()
--   vim.g.run_split = 'right'
-- end




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


function config.vim_vsnip()
  vim.g.vsnip_snippet_dir = os.getenv('HOME') .. '/.config/nvim/snippets'
end
function config.sniprun()

    require'sniprun'.setup({
    selected_interpreters = {},     --" use those instead of the default for the current filetype
    repl_enable = {},               --" enable REPL-like behavior for the given interpreters
    repl_disable = {},              --" disable REPL-like behavior for the given interpreters

    inline_messages = 0,             --" inline_message (0/1) is a one-line way to display messages
                                    --" to workaround sniprun not being able to display anything

    -- " you can combo different display modes as desired
    display = {
      "Classic",                    -- "display results in the command-line  area
      "VirtualTextOk",              -- "display ok results as virtual text (multiline is shortened)
      -- "VirtualTextErr",          -- "display error results as virtual text
      "TempFloatingWindow",      -- "display results in a floating window
      -- "LongTempFloatingWindow",  -- "same as above, but only long results. To use with VirtualText__
      "Terminal"                 -- "display results in a vertical split
      },
      


  })

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

--/bin/sh: line 1: ./home/viv/Anothertest/cstuffpointer: No such file or directory



-- function config.debug_ui()
--   require("dapui").setup({
--     icons = {
--       expanded = "⯆",
--       collapsed = "⯈",
--       circular = "↺"
--     },
--     mappings = {
--       expand = "<CR>",
--       open = "o",
--       remove = "d"
--     },
--     sidebar = {
--       elements = {
--         -- You can change the order of elements in the sidebar
--         "scopes",
--         "stacks",
--         "watches"
--       },
--       width = 40,
--       position = "left" -- Can be "left" or "right"
--     },
--     tray = {
--       elements = {
--         "repl"
--       },
--       height = 10,
--       position = "bottom" -- Can be "bottom" or "top"
--     },
--     floating = {
--       max_height = nil, -- These can be integers or a float between 0 and 1.
--       max_width = nil   -- Floats will be treated as percentage of your screen.
--     },
--   })


-- end


function config.vim_sonictemplate()
  vim.g.sonictemplate_postfix_key = '<C-,>'
  vim.g.sonictemplate_vim_template_dir = os.getenv("HOME").. '/.config/nvim/template'
end

function config.emmet()
  vim.g.user_emmet_complete_tag = 0
  vim.g.user_emmet_install_global = 0
  vim.g.user_emmet_install_command = 0
  vim.g.user_emmet_mode = 'i'
end

function config.doge()
  vim.g.doge_doc_standard_python = 'numpy'
end 

return config
