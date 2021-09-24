# Setup
Yeah i couldnt care less about start up speeds, tbh, if it works, and its decent
for python and java, then all good.

The basic mapping for this setup was pretty much yoinked from glepnir setup.
with the options and pretty much everything else, though some extra stuff that
i have added.

Yes I use ale, ale provides two main features i cant really live without, decent
formating, aka python-black, while getting rid of stupid stuff on the side, and
nayvy, which was initially built for coc - though since the converison ive
realised i depend way way to much on it, such that i need it.

Lazy Load stuff, is not much of a priority as i said, speed doesnt matter all to
much to me.

Things that are unconventional:
  - Ale
  - Diagnostic Flake8- bunch of plugin support to match my linting style .
  - Debugging is still a bit broken

this setup tends to fail rather often due to updates or me being stupid, so
please be aware that this is not perfect.




# Mapping . lua

```lua
    ["n|<C-x>k"] = map_cr('bdelete'):with_noremap():with_silent(), : buffer delete
    ["n|<Leader>w"] = map_cu('write'):with_noremap(), : Easy Save
    ["n|<Leader>q"] = map_cmd(':q!<CR>'):with_noremap(), : Easy exit

    ["n|Y"] = map_cmd('y$'), :Yoink

    ["n|]w"] = map_cu('WhitespaceNext'):with_noremap(), : in the name
    ["n|[w"] = map_cu('WhitespacePrev'):with_noremap(), : in the name
    ["n|]b"] = map_cu('bp'):with_noremap(),
    ["n|[b"] = map_cu('bn'):with_noremap(),

    ive forgotten what these do tbh

    ["n|<Space>cw"] = map_cu([[silent! keeppatterns %substitute/\s\+$//e]]):with_noremap():with_silent(),

    ["n|<C-h>"] = map_cmd('<C-w>h'):with_noremap(),
    ["n|<C-l>"] = map_cmd('<C-w>l'):with_noremap(),
    ["n|<C-j>"] = map_cmd('<C-w>j'):with_noremap(),
    ["n|<C-k>"] = map_cmd('<C-w>k'):with_noremap(),

    ["n|<A-[>"] = map_cr('vertical resize -5'):with_silent(),
    ["n|<A-]>"] = map_cr('vertical resize +5'):with_silent(),
    ["n|<C-q>"] = map_cmd(':wq<CR>'),

    ["n|<Leader>ss"] = map_cu('SessionSave'):with_noremap(),
    ["n|<Leader>sl"] = map_cu('SessionLoad'):with_noremap(),
    -- Insert
    ["i|<C-w>"] = map_cmd('<C-[>diwa'):with_noremap(),
    ["i|<C-h>"] = map_cmd('<BS>'):with_noremap(),
    ["i|<C-d>"] = map_cmd('<Del>'):with_noremap(),
    ["i|<C-u>"] = map_cmd('<C-G>u<C-U>'):with_noremap(),
    ["i|<C-b>"] = map_cmd('<Left>'):with_noremap(),
    ["i|<C-f>"] = map_cmd('<Right>'):with_noremap(),

    ["i|<C-s>"] = map_cmd('<Esc>:w<!CR>'),
    ["i|<C-q>"] = map_cmd('<Esc>:wq<CR>'),
    ["i|<C-e>"] = map_cmd([[pumvisible() ? "\<C-e>" : "\<End>"]]):with_noremap():with_expr(),
    -- command line
    ["c|<C-b>"] = map_cmd('<Left>'):with_noremap(),
    ["c|<C-f>"] = map_cmd('<Right>'):with_noremap(),
    ["c|<C-a>"] = map_cmd('<Home>'):with_noremap(),
    ["c|<C-e>"] = map_cmd('<End>'):with_noremap(),
    ["c|<C-d>"] = map_cmd('<Del>'):with_noremap(),
    ["c|<C-h>"] = map_cmd('<BS>'):with_noremap(),
    ["c|<C-t>"] = map_cmd([[<C-R>=expand("%:p:h") . "/" <CR>]]):with_noremap(),

```

# Main Mapping


```lua

   ["n|<leader>pu"]     = map_cr("PackerUpdate"):with_silent():with_noremap():with_nowait();
    ["n|<leader>pi"]     = map_cr("PackerInstall"):with_silent():with_noremap():with_nowait();
    ["n|<leader>pc"]     = map_cr("PackerCompile"):with_silent():with_noremap():with_nowait();
   

    -- Lsp mapp work when insertenter and lsp start
    ["n|<leader>li"]     = map_cr("LspInfo"):with_noremap():with_silent():with_nowait(),
    ["n|<leader>ll"]     = map_cr("LspLog"):with_noremap():with_silent():with_nowait(),
    ["n|<leader>lr"]     = map_cr("LspRestart"):with_noremap():with_silent():with_nowait(),
   
    ["n|<Leader>cw"]     = map_cmd("<cmd>lua vim.lsp.buf.workspace_symbol()<CR>"):with_noremap():with_silent(),
    ["n|gD"]             = map_cmd("<cmd>lua vim.lsp.buf.implementation()<CR>"):with_noremap():with_silent(),


    ["n|<C-]>"]     = map_args("Template"),
    ["n|<Leader>tf"]     = map_cu('DashboardNewFile'):with_noremap():with_silent(),
   
    -- I used code action decent sometimes it doesnt work 

    -- All commands with leader 
    ["n|<Leader>gD"]     = map_cmd("<cmd>lua vim.lsp.buf.type_definition()<CR>"):with_noremap():with_silent(),
    ["n|<Leader>gr"]     = map_cmd("<cmd>lua vim.lsp.buf.rename()<CR>"):with_noremap():with_silent(),
    ["n|<Leader>ca"]     = map_cmd("<cmd>lua vim.lsp.buf.code_action()<CR>"):with_noremap():with_silent(),
    ["n|<Leader>g"]      = map_cu("LazyGit"):with_noremap():with_silent(),

    -- On n map commands 
    ["n|gD"]     = map_cmd("<cmd>lua vim.lsp.buf.declaration()<CR>"):with_noremap():with_silent(),
    ["n|gd"]     = map_cmd("<cmd>lua vim.lsp.buf.definition()<CR>"):with_noremap():with_silent(),

    ["n|K"]     = map_cmd("<cmd>lua vim.lsp.buf.hover()<CR>"):with_noremap():with_silent(),
    ["n|gi"]     = map_cmd("<cmd>lua vim.lsp.buf.implementation()<CR>"):with_noremap():with_silent(),

    ["n|<C-k>"]     = map_cmd("<cmd>lua vim.lsp.buf.signature_help()<CR>"):with_noremap():with_silent(),
    ["n|rn"]     = map_cmd("<cmd>lua vim.lsp.buf.references()<CR>"):with_noremap():with_silent(),
    
    ["n|[d"]     = map_cmd("<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>"):with_noremap():with_silent(),
    ["n|]d"]     = map_cmd("<cmd>lua vim.lsp.diagnostic.goto_next()<CR>"):with_noremap():with_silent(),

   -- doge
    ["n|<F1>"]           = map_cr("DogeGenerate"):with_noremap():with_silent(),
    ["n|<F2>"]           = map_cu("UndotreeToggle"):with_noremap():with_silent(),
    ["n|<F3>"]           = map_cu('Black'):with_noremap():with_silent(),

    --NeoRunner_Horizontal 
    ["n|<F6>"]           = map_cu("NeoRunner"):with_noremap():with_silent(),
    
    -- Plugin nvim-tree
    ["n|<Leader>e"]      = map_cr('NvimTreeToggle'):with_noremap():with_silent(),
    ["n|<Leader>FF"]     = map_cr('NvimTreeFindFile'):with_noremap():with_silent(),

    ["n|<Leader>ss"] = map_cu('SaveSession'):with_noremap(),
    ["n|<Leader>sl"] = map_cu('RestoreSession'):with_noremap(),
    ["n|<Leader>sd"] = map_cu('DeleteSession'):with_noremap(),


    
    -- Plugin MarkdownPreview
    ["n|<Leader>om"]     = map_cu('MarkdownPreview'):with_noremap():with_silent(),
    -- Plugin DadbodUI
    ["n|<Leader>od"]     = map_cr('DBUIToggle'):with_noremap():with_silent(),



    -- Far.vim
    ["n|<Leader>fz"]     = map_cr('Farf'):with_noremap():with_silent();
    ["v|<Leader>fz"]     = map_cr('Farr'):with_noremap():with_silent();
    ["n|<Leader>fzd"]     = map_cr('Fardo'):with_noremap():with_silent();
    ["n|<Leader>fzu"]     = map_cr('Farundo'):with_noremap():with_silent();

    -- Plugin Telescope
-- Plugin Telescope
    ["n|<Leader>bb"]     = map_cu('Telescope buffers'):with_noremap():with_silent(),
    ["n|<Leader>fa"]     = map_cu('DashboardFindWord'):with_noremap():with_silent(),
    ["n|<Leader>fb"]     = map_cu('Telescope file_browser'):with_noremap():with_silent(),
    ["n|<Leader>fff"]    = map_cu('DashboardFindFile'):with_noremap():with_silent(),
    ["n|<Leader>fg"]     = map_cu('Telescope git_files'):with_noremap():with_silent(),
    ["n|<Leader>fw"]     = map_cu('Telescope grep_string'):with_noremap():with_silent(),
    ["n|<Leader>fh"]     = map_cu('DashboardFindHistory'):with_noremap():with_silent(),
    ["n|<Leader>fl"]     = map_cu('Telescope loclist'):with_noremap():with_silent(),
    ["n|<Leader>fc"]     = map_cu('Telescope git_commits'):with_noremap():with_silent(),
    ["n|<Leader>ft"]     = map_cu('Telescope help_tags'):with_noremap():with_silent(),
    ["n|<Leader>fd"]     = map_cu('Telescope dotfiles path='..os.getenv("HOME")..'/.config/nvim'):with_noremap():with_silent(),
    ["n|<Leader>qf"]     = map_cu("Telescope lsp_workspace_diagnostics"):with_noremap():with_silent(),
    -- ["n|<Leader>fs"]     = map_cu("Telescope utilsnips"):with_noremap():with_silent(),

    -- Plugin acceleratedjk
    ["n|j"]              = map_cmd('v:lua.enhance_jk_move("j")'):with_silent():with_expr(),
    ["n|k"]              = map_cmd('v:lua.enhance_jk_move("k")'):with_silent():with_expr(),
    -- Plugin QuickRun
    -- ["n|<Leader>r"]     = map_cr("<cmd> lua require'internal.quickrun'.run_command()"):with_noremap():with_silent(),
    -- Plugin Vista or SymbolsOutline
    ["n|<Leader>v"]      = map_cu('SymbolsOutline'):with_noremap():with_silent(),


    ["n|<Leader><TAB>"]    = map_cr('<CMD>lua require("FTerm").toggle()<CR>'):with_noremap():with_silent(),
    
    ["t|<Leader><TAB>"]    = map_cr('<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>'):with_noremap():with_silent(),


    -- Plugin vim_niceblock
    ["x|I"]              = map_cmd("v:lua.enhance_nice_block('I')"):with_expr(),
    ["x|gI"]             = map_cmd("v:lua.enhance_nice_block('gI')"):with_expr(),
    ["x|A"]              = map_cmd("v:lua.enhance_nice_block('A')"):with_expr(),


    -- Plugin for debugigng 
    ["n|<F4>"]          = map_cu('Telescope dap commands'):with_noremap():with_silent(),
    ["n|<Leader>dd"]    = map_cu("lua require('dap').continue()"):with_noremap():with_silent(),
    ["n|<Leader>vv"]    = map_cu("Telescope treesitter"):with_noremap():with_silent(),

    --Nice finder 
    ["n|<Leader><Leader><Leader>"]    = map_cu("Telescope frecency"):with_noremap():with_silent(),

    -- git Blame 
    ["n|<Leader><Leader>tgb"]    = map_cu("ToggleBlameLine"):with_noremap():with_silent(),


    -- Nice command to list all breakpoints. .
    ["n|<Leader>lb"]    = map_cr("Telescope dap list_breakpoints"):with_noremap():with_silent(),

    ["n|<Leader>do"]    = map_cr("<cmd> lua require'dap'.step_over()<CR>"):with_noremap():with_silent(),
    ["n|<Leader>di"]    = map_cr("<cmd> lua require'dap'.step_into()<CR>"):with_noremap():with_silent(),
    ["n|<Leader>dO"]    = map_cr("<cmd> lua require'dap'.step_out()<CR>"):with_noremap():with_silent(),
    ["n|<Leader>b"]     = map_cr("<cmd> lua require'dap'.toggle_breakpoint()<CR>"):with_noremap():with_silent(),
    ["n|<Leader>dr"]    = map_cr("<cmd> lua require'dap'.repl.open()<CR>"):with_noremap():with_silent(),
    ["n|<Leader>drr"]   = map_cr('<cmd> lua require"dap".repl.toggle({width = 50}, "belowright vsplit")<cr>'):with_noremap():with_silent(),
    ["n|<Leader>dl"]    = map_cr("<cmd> lua require'dap'.repl.run_last()<CR>"):with_noremap():with_silent(),





    -- Nice animation
    ["n|<Up>"]         = map_cmd("<cmd> call animate#window_delta_height(10)<CR>"):with_noremap():with_silent(),
    ["n|<Down>"]       = map_cmd("<cmd> call animate#window_delta_height(-10)<CR>"):with_noremap():with_silent(),
    ["n|<Left>"]       = map_cmd("<cmd> call animate#window_delta_width(10)<CR>"):with_noremap():with_silent(),
    ["n|<Right>"]      = map_cmd("<cmd> call animate#window_delta_width(-10)<CR>"):with_noremap():with_silent(),


    -- Plugin hrsh7th/vim-eft
    ["n|;"]                 = map_cmd("v:lua.enhance_ft_move(';')"):with_expr(),
    ["x|;"]                 = map_cmd("v:lua.enhance_ft_move(';')"):with_expr(),
    -- Plugin EasyAlign
    ["n|ga"]                = map_cmd("v:lua.enhance_align('nga')"):with_expr(),
    ["x|ga"]                = map_cmd("v:lua.enhance_align('xga')"):with_expr(),
    --sniprun

    ["v|<Leader>fr"]    = map_cmd("<Plug>SnipRun"):with_silent(),
    ["n|<Leader>fr"]    = map_cmd("<Plug>SnipRunOperator"):with_silent(),
    ["n|<Leader>ff"]    = map_cmd("<Plug>SnipRun"):with_silent(),


    -- Alternate togller
    ["n|<Leader>ta"]    = map_cr("ToggleAlternate"):with_noremap():with_silent(),



    -- TZAtaraxis
    ["n|<Leader><Leader>1"]          = map_cu("ZenMode"):with_noremap():with_silent(),
    ["n|<Leader><leader>2"]          = map_cu("TZAtaraxis<CR>"):with_noremap():with_silent(),
    ["n|<Leader><Leader>3"]          = map_cu("TZMinimalist<CR>"):with_noremap():with_silent(),
    ["n|<Leader><Leader>4"]          = map_cu("TZFocus<CR>"):with_noremap():with_silent(),
    --- new 
    ["n|<Leader>vf"]             = map_cmd("<Plug>(ultest-run-file)"):with_silent(),
    ["n|<Leader>vn"]             = map_cmd("<Plug>(ultest-run-nearest)"):with_silent(),
    ["n|<Leader>vg"]             = map_cmd("<Plug>(ultest-output-jump)"):with_silent(),
    ["n|<Leader>vo"]             = map_cmd("<Plug>(ultest-output-show)"):with_silent(),
    ["n|<Leader>vs"]             = map_cmd("<Plug>(ultest-summary-toggle)"):with_silent(),
    ["n|<Leader>va"]             = map_cmd("<Plug>(ultest-attach)"):with_silent(),
    ["n|<Leader>vx"]             = map_cmd("<Plug>(ultest-stop-file)"):with_silent(),

    -- Quick Fix infomation and binds 
    ["n|<Leader>xx"]    = map_cr("<cmd>Trouble<CR>"):with_noremap():with_silent(),
    ["n|<Leader>xw"]    = map_cr("<cmd>Trouble lsp_workspace_diagnostics<CR>"):with_noremap():with_silent(),
    ["n|<Leader>xd"]    = map_cr("<cmd>Trouble lsp_document_diagnostics<CR>"):with_noremap():with_silent(),
    ["n|<Leader>xl"]    = map_cr("<cmd>Trouble loclist<CR>"):with_noremap():with_silent(),
    ["n|<Leader>xf"]    = map_cr("<cmd>Trouble quickfix<CR>"):with_noremap():with_silent(),
    ["n|<Leader>xR"]    = map_cr("<cmd>Trouble lsp_references<CR>"):with_noremap():with_silent(),


    -- Nice highlighting for latex when writing notes 
    ["n|<Leader><F9>"]    = map_cu('lua require("nabla").place_inline()<CR>'):with_noremap():with_silent(),
    -- $ ... $ : inline form
    -- $$ ... $$ : wrapped form
    ["v|<F3>"]    = map_cmd(":<c-u>HSHighlight 3<CR>"):with_noremap():with_silent(),
    --Remove highlight 
    ["v|<F4>"]    = map_cmd(":<c-u>HSRmHighlight<CR>"):with_noremap():with_silent(),


    
    -- Next other buffers with this one . 
    ["n|<Leader>bth"]    = map_cr("BDelete hidden"):with_silent():with_nowait():with_noremap();
    ["n|<Leader>btu"]    = map_cr("BDelete! nameless"):with_silent():with_nowait():with_noremap();
    ["n|<Leader>btc"]    = map_cr("BDelete! this"):with_silent():with_nowait():with_noremap();

    ["n|<Leader>bw"]    = map_cr("BWipeout! all"):with_silent():with_nowait():with_noremap();
    ["n|<Leader>bc"]    = map_cr("BWipeout!"):with_silent():with_nowait():with_noremap();

    --["n|<Leader>bc"]  = map_cr("Bdelete"):with_noremap():with_silent(),
    --["n|<Leader>bw"]  = map_cr("Bwipeout"):with_noremap():with_silent(),


    ["n|<Leader>bo"]     = map_cr("<cmd>lua require('internal.utils').only()<CR>"):with_silent():with_nowait():with_noremap();
    ["n|<Leader>bv"]     = map_cr("BufferLinePick"):with_noremap():with_silent(),
    ["n|<Leader>b["]     = map_cr("BufferLineMoveNext"):with_noremap():with_silent(),
    ["n|<Leader>b]"]     = map_cr("BufferLineMovePrev"):with_noremap():with_silent(),
    ["n|<Leader>bnn"]    = map_cr("BufferLineCycleNext"):with_noremap():with_silent(),
    ["n|<Leader>bmm"]    = map_cr("BufferLineCyclePrev"):with_noremap():with_silent(),
    ["n|gb"]             = map_cr("BufferLinePick"):with_noremap():with_silent(),

};


```

