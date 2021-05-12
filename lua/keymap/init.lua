local bind = require('keymap.bind')
local map_cr = bind.map_cr
local map_cu = bind.map_cu
local map_cmd = bind.map_cmd
local map_args = bind.map_args
require('keymap.config')

local plug_map = {
    ["i|<TAB>"]      = map_cmd('v:lua.tab_complete()'):with_expr():with_silent(),
    ["i|<S-TAB>"]    = map_cmd('v:lua.s_tab_complete()'):with_silent():with_expr(),
    ["i|<CR>"]       = map_cmd([[compe#confirm('<CR>')]]):with_noremap():with_expr():with_nowait(),
    
    -- I rely on utilssnips decently , this is required 
  --   ["n|<CR>"]      = map_cmd('g:UltiSnipsExpandTrigger'):with_noremap():with_expr():with_nowait(),
  --   ["n|<Tab>"]      = map_cmd('g:UltiSnipsJumpForwardTrigger'):with_expr():with_silent(),
  --   ["n|<s-tab>"]      = map_cmd('g:UltiSnipsJumpBackwardTrigger'):with_expr():with_silent(),
  -- -- vim.g.UltiSnipsExpandTrigger = "<CR>"      
  -- -- vim.g.UltiSnipsJumpForwardTrigger = "<Tab>" 
  -- -- vim.g.UltiSnipsJumpBackwardTrigger = "<S_Tab>"

    ["n|<F1>"]           = map_cr("DogeGenerate"):with_noremap():with_silent(),

    -- person keymap
    ["n|mf"]             = map_cr("<cmd>lua require('internal.fsevent').file_event()<CR>"):with_silent():with_nowait():with_noremap();
    ["n|gb"]             = map_cr("BufferLinePick"):with_noremap():with_silent(),
    -- Packer
    ["n|<leader>pu"]     = map_cr("PackerUpdate"):with_silent():with_noremap():with_nowait();
    ["n|<leader>pi"]     = map_cr("PackerInstall"):with_silent():with_noremap():with_nowait();
    ["n|<leader>pc"]     = map_cr("PackerCompile"):with_silent():with_noremap():with_nowait();
    

    -- Lsp mapp work when insertenter and lsp start
    ["n|<leader>li"]     = map_cr("LspInfo"):with_noremap():with_silent():with_nowait(),
    ["n|<leader>ll"]     = map_cr("LspLog"):with_noremap():with_silent():with_nowait(),
    ["n|<leader>lr"]     = map_cr("LspRestart"):with_noremap():with_silent():with_nowait(),
    ["n|<C-f>"]          = map_cmd("<cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>"):with_silent():with_noremap():with_nowait(),
    ["n|<C-b>"]          = map_cmd("<cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>"):with_silent():with_noremap():with_nowait(),
    ["n|[e"]             = map_cr('Lspsaga diagnostic_jump_next'):with_noremap():with_silent(),
    ["n|]e"]             = map_cr('Lspsaga diagnostic_jump_prev'):with_noremap():with_silent(),
    ["n|K"]              = map_cr("Lspsaga hover_doc"):with_noremap():with_silent(),
    ["n|ga"]             = map_cr("Lspsaga code_action"):with_noremap():with_silent(),
    ["v|ga"]             = map_cu("Lspsaga range_code_action"):with_noremap():with_silent(),
    ["n|gd"]             = map_cr('Lspsaga preview_definition'):with_noremap():with_silent(),
    ["n|gD"]             = map_cmd("<cmd>lua vim.lsp.buf.implementation()<CR>"):with_noremap():with_silent(),
    ["n|gs"]             = map_cr('Lspsaga signature_help'):with_noremap():with_silent(),
    ["n|gr"]             = map_cr('Lspsaga rename'):with_noremap():with_silent(),
    ["n|gh"]             = map_cr('Lspsaga lsp_finder'):with_noremap():with_silent(),
    ["n|gt"]             = map_cmd("<cmd>lua vim.lsp.buf.type_definition()<CR>"):with_noremap():with_silent(),
    ["n|<Leader>cw"]     = map_cmd("<cmd>lua vim.lsp.buf.workspace_symbol()<CR>"):with_noremap():with_silent(),
    ["n|<Leader>ce"]     = map_cr('Lspsaga show_line_diagnostics'):with_noremap():with_silent(),
    ["n|<C-]>"]          = map_args("Template"),
    ["n|<Leader>tf"]     = map_cu('DashboardNewFile'):with_noremap():with_silent(),
   
    -- I used code action decent sometimes it doesnt work 

    ["n|<Leader>ca"]     = map_cmd("<cmd>lua vim.lsp.buf.code_action()<CR>"):with_noremap():with_silent(),


    -- Plugin nvim-tree
    ["n|<Leader>e"]      = map_cr('NvimTreeToggle'):with_noremap():with_silent(),
    ["n|<Leader>FF"]     = map_cr('NvimTreeFindFile'):with_noremap():with_silent(),
  
    -- Plugin MarkdownPreview
    ["n|<Leader>om"]     = map_cu('MarkdownPreview'):with_noremap():with_silent(),
  
    -- Plugin DadbodUI
    ["n|<Leader>od"]     = map_cr('DBUIToggle'):with_noremap():with_silent(),
  
    -- Plugin Floaterm
    ["n|<A-d>"]          = map_cu('Lspsaga open_floaterm'):with_noremap():with_silent(),
    ["t|<A-d>"]          = map_cu([[<C-\><C-n>:Lspsaga close_floaterm<CR>]]):with_noremap():with_silent(),
    ["n|<Leader>g"]      = map_cu("Lspsaga open_floaterm lazygit"):with_noremap():with_silent(),
    

    ["n|<Leader>1"]      = map_cu("Lspsaga open_floaterm lazygit"):with_noremap():with_silent(),


    -- Far.vim
    ["n|<Leader>fz"]     = map_cr('Farf'):with_noremap():with_silent();
    ["v|<Leader>fz"]     = map_cr('Farf'):with_noremap():with_silent();
  
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
    ["n|<Leader>fs"]     = map_cu('Telescope gosource'):with_noremap():with_silent(),
    ["n|<Leader>qf"]     = map_cu("Telescope quickfix"):with_noremap():with_silent(),

    -- Plugin acceleratedjk
    ["n|j"]              = map_cmd('v:lua.enhance_jk_move("j")'):with_silent():with_expr(),
    ["n|k"]              = map_cmd('v:lua.enhance_jk_move("k")'):with_silent():with_expr(),
    -- Plugin QuickRun
    ["n|<Leader>r"]      = map_cr("<cmd> lua require'internal.quickrun'.run_command()"):with_noremap():with_silent(),
    -- Plugin Vista
    ["n|<Leader>v"]      = map_cu('Vista'):with_noremap():with_silent(),
    -- Plugin vim-operator-surround
    ["n|sa"]             = map_cmd("<Plug>(operator-surround-append)"):with_silent(),
    ["n|sd"]             = map_cmd("<Plug>(operator-surround-delete)"):with_silent(),
    ["n|sr"]             = map_cmd("<Plug>(operator-surround-replace)"):with_silent(),
    -- Plugin hrsh7th/vim-eft
    ["n|;"]              = map_cmd("v:lua.enhance_ft_move(';')"):with_expr(),
    ["x|;"]              = map_cmd("v:lua.enhance_ft_move(';')"):with_expr(),
    ["n|f"]              = map_cmd("v:lua.enhance_ft_move('f')"):with_expr(),
    ["x|f"]              = map_cmd("v:lua.enhance_ft_move('f')"):with_expr(),
    ["o|f"]              = map_cmd("v:lua.enhance_ft_move('f')"):with_expr(),
    ["n|F"]              = map_cmd("v:lua.enhance_ft_move('F')"):with_expr(),
    ["x|F"]              = map_cmd("v:lua.enhance_ft_move('F')"):with_expr(),
    ["o|F"]              = map_cmd("v:lua.enhance_ft_move('F')"):with_expr(),
    -- Plugin vim_niceblock
    ["x|I"]              = map_cmd("v:lua.enhance_nice_block('I')"):with_expr(),
    ["x|gI"]             = map_cmd("v:lua.enhance_nice_block('gI')"):with_expr(),
    ["x|A"]              = map_cmd("v:lua.enhance_nice_block('A')"):with_expr(),

    -- Plugin for debugigng 
    ["n|<F4>"]          = map_cu('Telescope dap commands'):with_noremap():with_silent(),
    ["n|<Leader>dd"]    = map_cu("Telescope dap configurations"):with_noremap():with_silent(),
    ["n|<Leader>vv"]    = map_cu("Telescope treesitter"):with_noremap():with_silent(),
  
    ["n|<Leader>do"]    = map_cu("lua require'dap'.step_over()<CR>"):with_noremap():with_silent(),
    ["n|<Leader>di"]    = map_cu("lua require'dap'.step_into()<CR>"):with_noremap():with_silent(),
    ["n|<Leader>dO"]    = map_cu("lua require'dap'.step_out()<CR>"):with_noremap():with_silent(),

    ["n|<Leader>b"]     = map_cu("lua require'dap'.toggle_breakpoint()<CR>"):with_noremap():with_silent(),
    ["n|<Leader>B"]     = map_cu("lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>"):with_noremap():with_silent(),
    ["n|<Leader>lp"]    = map_cu("lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>"):with_noremap():with_silent(),

    ["n|<Leader>dr"]    = map_cu("lua require'dap'.repl.open()<CR>"):with_noremap():with_silent(),
    ["n|<Leader>drr"]   = map_cu('lua require"dap".repl.toggle({width = 50}, "belowright vsplit")<cr>'):with_noremap():with_silent(),


    ["n|<Leader>dl"]    = map_cu("lua require'dap'.repl.run_last()<CR>"):with_noremap():with_silent(),

    ["n|<Leader>dn"]    = map_cu("lua require('dap-python').test_method()<CR>"):with_noremap():with_silent(),
    ["i|<Leader>ds"]    = map_cu("lua require('dap-python').debug_selection()<CR>"):with_noremap():with_silent(),


    -- Unit Testing  


    -- Black formating 
    ["n|<F3>"]      = map_cu('Black'):with_noremap():with_silent(),


    --sniprun

    ["v|f"]                      = map_cmd("<Plug>SnipRun"):with_silent(),
    ["n|<Leader>fr"]             = map_cmd("<Plug>SnipRunOperator"):with_silent(),
    ["n|<Leader>ff"]             = map_cmd("<Plug>SnipRun"):with_silent(),


    -- Alternate togller

    ["n|<Leader>ta"]            = map_cr("ToggleAlternate"):with_noremap():with_silent(),



    -- TZAtaraxis
    ["n|<F9>"]                  = map_cu("TZAtaraxis<CR>"):with_noremap():with_silent(),


    -- Moving nice animation . 

    ["n|<Up>"]       = map_cmd("<cmd> call animate#window_delta_height(10)<CR>"):with_noremap():with_silent(),
    ["n|<Down>"]     = map_cmd("<cmd> call animate#window_delta_height(-10)<CR>"):with_noremap():with_silent(),
    ["n|<Left>"]     = map_cmd("<cmd> call animate#window_delta_width(10)<CR>"):with_noremap():with_silent(),
    ["n|<Right>"]    = map_cmd("<cmd> call animate#window_delta_width(-10)<CR>"):with_noremap():with_silent(),



    -- Code runner python C c++ support using two neovim and code runner 
    -- might get rid of this , Depending on the other uses . i like the fact that 
    -- this stays when you finish teh code . 
    ["n|<F5>"]     = map_cr("Run"):with_noremap():with_silent(),
    -- Window Code runner . 
    ["n|<F6>"]    = map_cu('FRunCode'):with_noremap():with_silent(),
    -- Native terminal 
    ["n|<F7>"]    = map_cu("RunCode"):with_noremap():with_silent(),
    --NeoRunner
    ["n|<F8>"]    = map_cu("NeoRunner"):with_noremap():with_silent(),


    -- nice little thing to take some quick notes ina  file in latex .
    -- I like this . 
    ["n|<Leader><F9>"]    = map_cu('lua require("nabla").place_inline()<CR>'):with_noremap():with_silent(),
    -- $ ... $ : inline form
    -- $$ ... $$ : wrapped form



};

bind.nvim_load_mapping(plug_map)
