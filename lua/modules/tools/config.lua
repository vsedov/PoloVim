local config = {}

local function load_env_file()
  local env_file = os.getenv("HOME")..'/.env'
  local env_contents = {}
  if vim.fn.filereadable(env_file) ~= 1 then
    print('.env file does not exist')
    return
  end
  local contents = vim.fn.readfile(env_file)
  for _,item in pairs(contents) do
    local line_content = vim.fn.split(item,"=")
    env_contents[line_content[1]] = line_content[2]
  end
  return env_contents
end

local function load_dbs()
  local env_contents = load_env_file()
  local dbs = {}
  for key,value in pairs(env_contents) do
    if vim.fn.stridx(key,"DB_CONNECTION_") >= 0 then
      local db_name = vim.fn.split(key,"_")[3]:lower()
      dbs[db_name] = value
    end
  end
  return dbs
end

function config.vim_dadbod_ui()
  if packer_plugins['vim-dadbod'] and not packer_plugins['vim-dadbod'].loaded then
    vim.cmd [[packadd vim-dadbod]]
  end
  vim.g.db_ui_show_help = 0
  vim.g.db_ui_win_position = 'left'
  vim.g.db_ui_use_nerd_fonts = 1
  vim.g.db_ui_winwidth = 35
  vim.g.db_ui_save_location = os.getenv("HOME") .. '/.cache/vim/db_ui_queries'
  vim.g.dbs = load_dbs()
end

function  config.sybolsoutline()
  vim.g.symbols_outline = {
      highlight_hovered_item = false,
      show_guides = true,
      auto_preview = true,
      position = 'right',
      show_numbers = false,
      show_relative_numbers = false,
      show_symbol_details = true,
      keymaps = {
          close = "<Esc>",
          goto_location = "<Cr>",
          focus_location = "o",
          hover_symbol = "<C-space>",
          rename_symbol = "r",
          code_actions = "a",
      },
      lsp_blacklist = {},
  }
end

function config.vim_vista()
  vim.g['vista#renderer#enable_icon'] = 1
  vim.g.vista_disable_statusline = 1
  vim.g.vista_default_executive = 'nvim_lsp'
  vim.g.vista_echo_cursor_strategy = 'floating_win'
  vim.g.vista_vimwiki_executive = 'markdown'
  vim.g.vista_executive_for = {
    vimwiki =  'markdown',
    pandoc = 'markdown',
    markdown = 'toc',
    typescript = 'nvim_lsp',
    python =  'nvim_lsp',
    c = 'nvim_lsp',
  }
end

function config.SymbolsOutline()

  vim.g.symbols_outline = {
      highlight_hovered_item = true,
      show_guides = true,
      auto_preview = true,
      position = 'right',
      show_numbers = false,
      show_relative_numbers = false,
      show_symbol_details = true,
      keymaps = {
          close = "<Esc>",
          goto_location = "<Cr>",
          focus_location = "o",
          hover_symbol = "<C-space>",
          rename_symbol = "r",
          code_actions = "a",
      },
      lsp_blacklist = {},
  }
end




return config
