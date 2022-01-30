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

  -- vim.api.nvim_set_keymap("v", "<Leader>re", [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function')<CR>]], {noremap = true, silent = true, expr = false})
  -- vim.api.nvim_set_keymap("v", "<Leader>rf", [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function To File')<CR>]], {noremap = true, silent = true, expr = false})
  -- vim.api.nvim_set_keymap("v", "<Leader>rt", [[ <Esc><Cmd>lua M.refactors()<CR>]], {noremap = true, silent = true, expr = false})
end

function config.neorunner()
  vim.g.runner_c_compiler = "gcc"
  vim.g.runner_cpp_compiler = "g++"
  vim.g.runner_c_options = "-Wall"
  vim.g.runner_cpp_options = "-std=c++11 -Wall"
end

function config.jaq()
  require("jaq-nvim").setup({
    -- Commands used with 'Jaq'
    cmds = {
      -- Default UI used (see `Usage` for options)
      default = "float",

      -- Uses external commands such as 'g++' and 'cargo'
      external = {
        javascript = "node",
        java = "cd $dir && javac $file && java $fileBase",
        c = "gcc $file -o $fileBase && ./$fileBase",
        cpp = "cd $dir && g++ $fileName -o $fileNameWithoutExt && ./$fileNameWithoutExt",
        python = "python -u %",
        shellscript = "bash",
        csharp = "cd $dir && mcs $fileName && mono $fileNameWithoutExt.exe",
        typescript = "deno run",
        rust = "cd $dir && rustc $fileName && $dir$fileNameWithoutExt",
        dart = "dart",
      },
      -- Uses internal commands such as 'source' and 'luafile'
      internal = {
        lua = "luafile %",
        vim = "source %",
      },
    },

    -- UI settings
    ui = {
      -- Start in insert mode
      startinsert = false,

      -- Floating Window settings
      float = {
        -- Floating window border (see ':h nvim_open_win')
        border = "none",

        -- Num from `0 - 1` for measurements
        height = 0.8,
        width = 0.8,

        -- Highlight group for floating window/border (see ':h winhl')
        border_hl = "FloatBorder",
        float_hl = "Normal",

        -- Floating Window Transparency (see ':h winblend')
        blend = 0,
      },

      terminal = {
        -- Position of terminal
        position = "bot",

        -- Size of terminal
        size = 10,
      },

      quickfix = {
        -- Position of quickfix window
        position = "bot",

        -- Size of quickfix window
        size = 10,
      },
    },
  })
end

function config.doge()
  vim.g.doge_doc_standard_python = "numpy"
  vim.g.doge_mapping_comment_jump_forward = "<C-n>"
  vim.g.doge_mapping_comment_jump_backward = "C-p>"
end

function config.goto_preview()
  vim.cmd([[command! -nargs=* GotoPrev lua require('goto-preview').goto_preview_definition()]])
  vim.cmd([[command! -nargs=* GotoImp lua require('goto-preview').goto_preview_implementation()]])
  vim.cmd([[command! -nargs=* GotoTel lua require('goto-preview').goto_preview_references()]])

  require("goto-preview").setup({
    width = 120, -- Width of the floating window
    height = 15, -- Height of the floating window
    border = { "↖", "─", "┐", "│", "┘", "─", "└", "│" }, -- Border characters of the floating window
    default_mappings = false, -- Bind default mappings
    debug = false, -- Print debug information
    opacity = nil, -- 0-100 opacity level of the floating window where 100 is fully transparent.
    resizing_mappings = false, -- Binds arrow keys to resizing the floating window.
    post_open_hook = nil, -- A function taking two arguments, a buffer and a window to be ran as a hook.
    -- These two configs can also be passed down to the goto-preview definition and implementation calls for one off "peak" functionality.
    focus_on_open = true, -- Focus the floating window when opening it.
    dismiss_on_move = false, -- Dismiss the floating window when moving the cursor.
    force_close = true, -- passed into vim.api.nvim_win_close's second argument. See :h nvim_win_close
    bufhidden = "wipe", -- the bufhidden option to set on the floating window. See :h bufhidden
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

function config.ultest()
  require("modules.lang.language_utils").testStart()
end

function config.magma()
  vim.g.magma_automatically_open_output = false
end

function config.sniprun()
  require("modules.lang.language_utils").load_snip_run()
end

function config.aerial()
  require("aerial").setup({
    -- Priority list of preferred backends for aerial.
    -- This can be a filetype map (see :help aerial-filetype-map)
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

    -- Enum: prefer_right, prefer_left, right, left, float
    -- Determines the default direction to open the aerial window. The 'prefer'
    -- options will open the window in the other direction *if* there is a
    -- different buffer in the way of the preferred direction
    default_direction = "prefer_right",

    -- Disable aerial on files with this many lines
    disable_max_lines = 10000,

    -- A list of all symbols to display. Set to false to display all symbols.
    -- This can be a filetype map (see :help aerial-filetype-map)
    -- To see all available values, see :help SymbolKind
    filter_kind = {
      "Class",
      "Constructor",
      "Enum",
      "Function",
      "Interface",
      "Module",
      "Method",
      "Struct",
    },

    -- Enum: split_width, full_width, last, none
    -- Determines line highlighting mode when multiple splits are visible
    -- split_width   Each open window will have its cursor location marked in the
    --               aerial buffer. Each line will only be partially highlighted
    --               to indicate which window is at that location.
    -- full_width    Each open window will have its cursor location marked as a
    --               full-width highlight in the aerial buffer.
    -- last          Only the most-recently focused window will have its location
    --               marked in the aerial buffer.
    -- none          Do not show the cursor locations in the aerial window.
    highlight_mode = "split_width",

    -- When jumping to a symbol, highlight the line for this many ms.
    -- Set to false to disable
    highlight_on_jump = 300,

    -- Define symbol icons. You can also specify "<Symbol>Collapsed" to change the
    -- icon when the tree is collapsed at that symbol, or "Collapsed" to specify a
    -- default collapsed icon. The default icon set is determined by the
    -- "nerd_font" option below.
    -- If you have lspkind-nvim installed, aerial will use it for icons.
    icons = {},

    -- When you fold code with za, zo, or zc, update the aerial tree as well.
    -- Only works when manage_folds = true
    link_folds_to_tree = false,

    -- Fold code when you open/collapse symbols in the tree.
    -- Only works when manage_folds = true
    link_tree_to_folds = true,

    -- Use symbol tree for folding. Set to true or false to enable/disable
    -- 'auto' will manage folds if your previous foldmethod was 'manual'
    manage_folds = false,

    -- The maximum width of the aerial window
    max_width = 40,

    -- The minimum width of the aerial window.
    -- To disable dynamic resizing, set this to be equal to max_width
    min_width = 10,

    -- Set default symbol icons to use patched font icons (see https://www.nerdfonts.com/)
    -- "auto" will set it to true if nvim-web-devicons or lspkind-nvim is installed.
    nerd_font = "auto",

    -- Call this function when aerial attaches to a buffer.
    -- Useful for setting keymaps. Takes a single `bufnr` argument.
    on_attach = nil,

    -- Automatically open aerial when entering supported buffers.
    -- This can be a function (see :help aerial-open-automatic)
    open_automatic = false,

    -- Set to true to only open aerial at the far right/left of the editor
    -- Default behavior opens aerial relative to current window
    placement_editor_edge = false,

    -- Run this command after jumping to a symbol (false will disable)
    post_jump_cmd = "normal! zz",

    -- When true, aerial will automatically close after jumping to a symbol
    close_on_select = false,

    -- Show box drawing characters for the tree hierarchy
    show_guides = false,

    -- Options for opening aerial in a floating win
    float = {
      -- Controls border appearance. Passed to nvim_open_win
      border = "rounded",

      -- Controls row offset from cursor. Passed to nvim_open_win
      row = 1,

      -- Controls col offset from cursor. Passed to nvim_open_win
      col = 0,

      -- The maximum height of the floating aerial window
      max_height = 100,

      -- The minimum height of the floating aerial window
      -- To disable dynamic resizing, set this to be equal to max_height
      min_height = 4,
    },

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
  })
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

function config.context()
  require("treesitter-context.config").setup({
    enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
  })
end

-- function config.treehopper() end

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
  vim.cmd([[vmap <leader><leader>lr <Plug>(Luadev-Run)]])
end

function config.lua_dev()
  -- local sumneko_root_path = vim.fn.expand("$HOME") .. "/GitHub/lua-language-server"
  -- local sumneko_binary = vim.fn.expand("$HOME") .. "/GitHub/lua-language-server/bin/lua-language-server"
  local runtime_path = vim.split(package.path, ";")
  table.insert(runtime_path, "lua/?.lua")
  table.insert(runtime_path, "lua/?/init.lua")

  local sumneko_lua_server = {
    -- cmd = { sumneko_binary, "-E", sumneko_root_path .. "/main.lua" },
    cmd = { "lua-language-server" },
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      Lua = {
        runtime = {
          runtime = {
            path = runtime_path,
          },
          diagnostics = {
            globals = { "vim", "dump", "hs", "lvim" },
          },
          workspace = {
            library = {
              vim.api.nvim_get_runtime_file("", true),
              [table.concat({ vim.fn.stdpath("data"), "lua" }, "/")] = false,
              vim.api.nvim_get_runtime_file("", false),
              [vim.fn.expand("~") .. "/.config/nvim/lua"] = false,
              [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = false,
              [vim.fn.expand("$VIMRUNTIME/lua")] = false,
            },
            maxPreload = 100000,
            preloadFileSize = 1000,
          },
        },
      },
    },
  }

  local lspconfig = require("lspconfig")
  local luadev = require("lua-dev").setup({
    library = {
      vimruntime = true,
      types = true,
      -- makes everything lag
      plugins = false, -- toggle this to get completion for require of all plugins
      -- plugins = {nvim-notify, telescope}
    },
    lspconfig = sumneko_lua_server,
  })

  lspconfig.sumneko_lua.setup(luadev)
end

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
