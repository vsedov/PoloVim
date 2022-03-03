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


function autocmd.load_autocmds()
  local definitions = {
    packer = {
      { "BufWritePost", "plugins.lua", "lua require('core.pack').auto_compile()" },
    },
    bufs = {
      { { "BufRead", "BufNewFile" }, "*.norg", "setlocal filetype=norg" },
      -- Reload vim config automatically
      {
        "BufWritePost",
        [[$VIM_PATH/{*.vim,*.yaml,vimrc}]],
        [[source $MYVIMRC | redraw]],
        true,
      },
      -- Reload Vim script automatically if setlocal autoread
      {
        { "BufWritePost", "FileWritePost" },
        "*.vim",
        [[if &l:autoread > 0 | source <afile> | echo 'source ' . bufname('%') | endif]],
        true,
      },
      { "BufWritePre", "/tmp/*", "setlocal noundofile" },
      { "BufWritePre", "COMMIT_EDITMSG", "setlocal noundofile" },
      { "BufWritePre", "MERGE_MSG", "setlocal noundofile" },
      { "BufWritePre", "*.tmp", "setlocal noundofile" },
      { "BufWritePre", "*.bak", "setlocal noundofile" },
      -- { "BufEnter", "*", [[lcd `=expand('%:p:h')`]] }, -- Not requried atm
    },

    wins = {
      -- Highlight current line only on focused window
      {
        { "WinEnter", "BufEnter", "InsertLeave" },
        "*",
        [[if ! &cursorline && &filetype !~# '^\(dashboard\|clap_\)' && ! &pvw | setlocal cursorline | endif]],
      },
      {
        { "WinLeave", "BufLeave", "InsertEnter" },
        "*",
        [[if &cursorline && &filetype !~# '^\(dashboard\|clap_\|NvimTree\)' && ! &pvw | setlocal nocursorline | endif]],
      },
      {
        { "WinLeave", "BufLeave", "InsertEnter" },
        "*",
        [[if &cursorline && &filetype !~# '^\(dashboard\|clap_\|NvimTree\)' && ! &pvw | setlocal nocursorcolumn | endif]],
      },
      { "BufEnter", "NvimTree", [[setlocal cursorline]] },
      { "CmdLineEnter", "*", [[set nosmartcase]] },
      { "CmdLineLeave", "*", [[set smartcase]] },
      -- Equalize window dimensions when resizing vim window
      { "VimResized", "*", [[tabdo wincmd =]] },
      -- Force write shada on leaving nvim
      {
        "VimLeave",
        "*",
        [[if has('nvim') | wshada! | else | wviminfo! | endif]],
      },

      -- Check if file changed when its window is focus, more eager than 'autoread'
      { "FocusGained", "*", "checktime" },
      -- -- {"CmdwinEnter,CmdwinLeave", "*", "lua require'wlfloatline'.toggle()"};
      -- {"CmdlineEnter,CmdlineLeave", "*", "echom 'kkk'"};
    },

    ft = {
      {
        "FileType",
        { "qf", "help", "man", "ls:pinfo" },
        "nnoremap <silent> <buffer> q :close<CR>",
      },
      {
        "FileType",
        "dashboard",
        "set showtabline=0 | autocmd WinLeave <buffer> set showtabline=2",
      },
      { { "BufNewFile", "BufRead" }, "*.toml", " setf toml" },
    },
    yank = {
      {
        "TextYankPost",
        "*",
        [[lua vim.highlight.on_yank({ higroup = "IncSearch", timeout = 400, on_macro = true, on_visual = true })]],
      },
    },
  }
  autocmd.nvim_create_augroups(definitions)
end

autocmd.load_autocmds()
return autocmd
