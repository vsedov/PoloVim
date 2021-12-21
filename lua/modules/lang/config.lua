local config = {}
-- local bind = require('keymap.bind')
-- local map_cr = bind.map_cr
-- local map_cu = bind.map_cu
-- local map_cmd = bind.map_cmd
-- local loader = require"packer".loader

function config.nvim_treesitter()
  require("modules.lang.treesitter").treesitter()
end

function config.treesitter_obj()
  require("modules.lang.treesitter").treesitter_obj()
end

function config.treesitter_ref()
  require("modules.lang.treesitter").treesitter_ref()
end

function config.pyfold()
  require("modules.lang.treesitter").pyfold()

end

function config.refactor()
  local refactor = require("refactoring")
  refactor.setup({})

  lprint("refactor")
  _G.ts_refactors = function()
    -- telescope refactoring helper
    local function _refactor(prompt_bufnr)
      local content = require("telescope.actions.state").get_selected_entry(prompt_bufnr)
      require("telescope.actions").close(prompt_bufnr)
      require("refactoring").refactor(content.value)
    end

    local opts = require("telescope.themes").get_cursor() -- set personal telescope options
    require("telescope.pickers").new(opts, {
      prompt_title = "refactors",
      finder = require("telescope.finders").new_table({
        results = require("refactoring").get_refactors(),
      }),
      sorter = require("telescope.config").values.generic_sorter(opts),
      attach_mappings = function(_, map)
        map("i", "<CR>", _refactor)
        map("n", "<CR>", _refactor)
        return true
      end,
    }):find()
  end
end

function config.neorunner()
  vim.g.runner_c_compiler = "gcc"
  vim.g.runner_cpp_compiler = "g++"
  vim.g.runner_c_options = "-Wall"
  vim.g.runner_cpp_options = "-std=c++11 -Wall"
end

function config.jaq()
  require('jaq-nvim').setup{
    -- Commands used with 'Jaq'
    cmds = {
      -- Default UI used (see `Usage` for options)
      default = "float",

      -- Uses external commands such as 'g++' and 'cargo'
      external = {
        typescript = "deno run %",
        javascript = "node %",
        markdown = "glow %",
        python = "python3 %",
        rust = "rustc % && ./$fileBase && rm $fileBase",
        cpp = "g++ % -o $fileBase && ./$fileBase",
        go = "go run %",
        sh = "sh %",
      },

      -- Uses internal commands such as 'source' and 'luafile'
      internal = {
        lua = "luafile %",
        vim = "source %"
      }
    },

    -- UI settings
    ui = {
      -- Start in insert mode
      startinsert = false,

      -- Floating Window settings
      float = {
        -- Floating window border (see ':h nvim_open_win')
        border    = "none",

        -- Num from `0 - 1` for measurements
        height    = 0.8,
        width     = 0.8,

        -- Highlight group for floating window/border (see ':h winhl')
        border_hl = "FloatBorder",
        float_hl  = "Normal",

        -- Floating Window Transparency (see ':h winblend')
        blend     = 0
      },

      terminal = {
        -- Position of terminal
        position = "bot",

        -- Size of terminal
        size     = 10
      },

      quickfix = {
        -- Position of quickfix window
        position = "bot",

        -- Size of quickfix window
        size     = 10
      }
    }
  }

end

function config.doge()
  vim.g.doge_doc_standard_python = "numpy"
  vim.g.doge_mapping_comment_jump_forward = "<C-n>"
  vim.g.doge_mapping_comment_jump_backward = "C-p>"
end

function config.goto_preview()
  require("goto-preview").setup({})
end

function config.nvim_notify()
  require("notify").setup({
    -- Animation style (see below for details)
    stages = "fade_in_slide_out",

    -- Default timeout for notifications
    timeout = 5000,

    -- For stages that change opacity this is treated as the highlight behind the window
    -- Set this to either a highlight group or an RGB hex value e.g. "#000000"
    background_colour = "#000000",

    -- Icons for the different levels
    icons = {
      ERROR = "",
      WARN = "",
      INFO = "",
      DEBUG = "",
      TRACE = "✎",
    },
  })
end

function config.tsubject()
  require("nvim-treesitter.configs").setup({
    textsubjects = {
      enable = true,
      keymaps = { ["<CR>"] = "textsubjects-smart", [";"] = "textsubjects-container-outer" },
    },
  })
end

function config.outline()
  vim.g.symbols_outline = {
    highlight_hovered_item = true,
    show_guides = true,
    auto_preview = true,
    position = "right",
    relative_width = true,
    width = 25,
    show_numbers = false,
    show_relative_numbers = false,
    show_symbol_details = true,
    preview_bg_highlight = "Pmenu",
    keymaps = { -- These keymaps can be a string or a table for multiple keys
      close = { "<Esc>", "q" },
      goto_location = "<Cr>",
      focus_location = "o",
      hover_symbol = "<C-space>",
      toggle_preview = "K",
      rename_symbol = "r",
      code_actions = "a",
    },
    lsp_blacklist = {},
    symbol_blacklist = {},
    symbols = {
      File = { icon = "", hl = "TSURI" },
      Module = { icon = "", hl = "TSNamespace" },
      Namespace = { icon = "", hl = "TSNamespace" },
      Package = { icon = "", hl = "TSNamespace" },
      Class = { icon = "𝓒", hl = "TSType" },
      Method = { icon = "ƒ", hl = "TSMethod" },
      Property = { icon = "", hl = "TSMethod" },
      Field = { icon = "", hl = "TSField" },
      Constructor = { icon = "", hl = "TSConstructor" },
      Enum = { icon = "ℰ", hl = "TSType" },
      Interface = { icon = "ﰮ", hl = "TSType" },
      Function = { icon = "", hl = "TSFunction" },
      Variable = { icon = "", hl = "TSConstant" },
      Constant = { icon = "", hl = "TSConstant" },
      String = { icon = "𝓐", hl = "TSString" },
      Number = { icon = "#", hl = "TSNumber" },
      Boolean = { icon = "⊨", hl = "TSBoolean" },
      Array = { icon = "", hl = "TSConstant" },
      Object = { icon = "⦿", hl = "TSType" },
      Key = { icon = "🔐", hl = "TSType" },
      Null = { icon = "NULL", hl = "TSType" },
      EnumMember = { icon = "", hl = "TSField" },
      Struct = { icon = "𝓢", hl = "TSType" },
      Event = { icon = "🗲", hl = "TSType" },
      Operator = { icon = "+", hl = "TSOperator" },
      TypeParameter = { icon = "𝙏", hl = "TSParameter" },
    },
  }
end

function config.sqls() end

function config.sniprun()
  require("sniprun").setup({
    selected_interpreters = {}, --# use those instead of the default for the current filetype
    repl_enable = {}, --# enable REPL-like behavior for the given interpreters
    repl_disable = {}, --# disable REPL-like behavior for the given interpreters

    interpreter_options = {}, --# intepreter-specific options, consult docs / :SnipInfo <name>

    --# you can combo different display modes as desired
    display = {
      -- "VirtualTextErr", --# display error results as virtual text
      "NvimNotify", --# display with the nvim-notify plugin
    },

    --# You can use the same keys to customize whether a sniprun producing
    --# no output should display nothing or '(no output)'
    show_no_output = {
      "Classic",
      "TempFloatingWindow", --# implies LongTempFloatingWindow, which has no effect on its own
    },

    --# miscellaneous compatibility/adjustement settings
    inline_messages = 0, --# inline_message (0/1) is a one-line way to display messages
    --# to workaround sniprun not being able to display anything

    borders = "single", --# display borders around floating windows
    --# possible values are 'none', 'single', 'double', or 'shadow'
  })
end

function config.aerial()
  vim.g.aerial = {
    -- Priority list of preferred backends for aerial
    backends = { "lsp", "treesitter", "markdown" },

    -- Enum: persist, close, auto, global
    --   persist - aerial window will stay open until closed
    --   close   - aerial window will close when original file is no longer visible
    --   auto    - aerial window will stay open as long as there is a visible
    --             buffer to attach to
    --   global  - same as 'persist', and will always show symbols for the current buffer
    close_behavior = "auto",

    -- Set to false to remove the default keybindings for the aerial buffer
    default_bindings = true,

    -- Enum: prefer_right, prefer_left, right, left
    -- Determines the default direction to open the aerial window. The 'prefer'
    -- options will open the window in the other direction *if* there is a
    -- different buffer in the way of the preferred direction
    default_direction = "prefer_right",

    -- A list of all symbols to display. Set to false to display all symbols.
    filter_kind = { "Class", "Constructor", "Enum", "Function", "Interface", "Method", "Struct" },

    -- Enum: split_width, full_width, last, none
    -- Determines line highlighting mode when multiple buffers are visible
    highlight_mode = "split_width",

    -- When jumping to a symbol, highlight the line for this many ms
    -- Set to 0 or false to disable
    highlight_on_jump = 300,

    -- Fold code when folding the tree. Only works when manage_folds is enabled
    link_tree_to_folds = true,

    -- Fold the tree when folding code. Only works when manage_folds is enabled
    link_folds_to_tree = false,

    -- Use symbol tree for folding. Set to true or false to enable/disable
    -- 'auto' will manage folds if your previous foldmethod was 'manual'
    manage_folds = "auto",

    -- The maximum width of the aerial window
    max_width = 40,

    -- The minimum width of the aerial window.
    -- To disable dynamic resizing, set this to be equal to max_width
    min_width = 10,

    -- Set default symbol icons to use Nerd Font icons (see https://www.nerdfonts.com/)
    nerd_font = "auto",

    -- Whether to open aerial automatically when entering a buffer.
    -- Can also be specified per-filetype as a map (see below)
    open_automatic = false,

    -- If open_automatic is true, only open aerial if the source buffer is at
    -- least this long
    open_automatic_min_lines = 0,

    -- If open_automatic is true, only open aerial if there are at least this many symbols
    open_automatic_min_symbols = 0,

    -- Set to true to only open aerial at the far right/left of the editor
    -- Default behavior opens aerial relative to current window
    placement_editor_edge = false,

    -- Run this command after jumping to a symbol (false will disable)
    post_jump_cmd = "normal! zz",

    -- If close_on_select is true, aerial will automatically close after jumping to a symbol
    close_on_select = false,

    lsp = {
      -- Fetch document symbols when LSP diagnostics change.
      -- If you set this to false, you will need to manually fetch symbols
      diagnostics_trigger_update = true,

      -- Set to false to not update the symbols when there are LSP errors
      update_when_errors = true,
    },

    treesitter = {
      -- How long to wait (in ms) after a buffer change before updating
      update_delay = 300,
    },

    markdown = {
      -- How long to wait (in ms) after a buffer change before updating
      update_delay = 300,
    },
  }

  -- Aerial does not set any mappings by default, so you'll want to set some up
end

function config.syntax_folding()
  local fname = vim.fn.expand("%:p:f")
  local fsize = vim.fn.getfsize(fname)
  if fsize > 1024 * 1024 then
    print("disable syntax_folding")
    vim.api.nvim_command("setlocal foldmethod=indent")
    return
  end
  vim.api.nvim_command("setlocal foldmethod=expr")
  vim.api.nvim_command("setlocal foldexpr=nvim_treesitter#foldexpr()")
end

-- https://gist.github.com/folke/fe5d28423ea5380929c3f7ce674c41d8

local path = vim.split(package.path, ";")

table.insert(path, "lua/?.lua")
table.insert(path, "lua/?/init.lua")

function config.playground()
  require("nvim-treesitter.configs").setup({
    playground = {
      enable = true,
      disable = {},
      updatetime = 50, -- Debounced time for highlighting nodes in the playground from source code
      persist_queries = true, -- Whether the query persists across vim sessions
    },
  })
end
function config.luadev()
  vim.cmd([[vmap <leader><leader>r <Plug>(Luadev-Run)]])
end
function config.lua_dev() end

function config.go()
  require("go").setup({
    verbose = plugin_debug(),
    -- goimport = 'goimports', -- 'gopls'
    filstruct = "gopls",
    log_path = vim.fn.expand("$HOME") .. "/tmp/gonvim.log",
    lsp_codelens = false, -- use navigator
    dap_debug = true,

    dap_debug_gui = true,
    test_runner = "richgo", -- richgo, go test, richgo, dlv, ginkgo
    -- run_in_floaterm = true, -- set to true to run in float window.
  })

  vim.cmd("augroup go")
  vim.cmd("autocmd!")
  vim.cmd("autocmd FileType go nmap <leader>gb  :GoBuild")
  --  Show by default 4 spaces for a tab')
  vim.cmd("autocmd BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 shiftwidth=4")
  --  :GoBuild and :GoTestCompile')
  -- vim.cmd('autocmd FileType go nmap <leader><leader>gb :<C-u>call <SID>build_go_files()<CR>')
  --  :GoTest')
  vim.cmd("autocmd FileType go nmap <leader>gt  GoTest")
  --  :GoRun

  vim.cmd("autocmd FileType go nmap <Leader><Leader>l GoLint")
  vim.cmd("autocmd FileType go nmap <Leader>gc :lua require('go.comment').gen()")

  vim.cmd("au FileType go command! Gtn :TestNearest -v -tags=integration")
  vim.cmd("au FileType go command! Gts :TestSuite -v -tags=integration")
  vim.cmd("augroup END")
end

function config.dap()
    require("modules.lang.dap.init")
end

return config
