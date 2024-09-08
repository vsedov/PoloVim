local conf = require("plugins.lsp.config")
local config = lambda.config.lsp.null_ls
require("lspconfig.ui.windows").default_options.border = lambda.style.border.type_0
require("lspconfig")
require("mason").setup({
    ui = {
        border = lambda.style.border.type_0,
        height = 0.8,
    },
})

require("mason-lspconfig").setup({
    automatic_installation = true,
    handlers = {
        function(name)
            local config = require("plugins.lsp.lsp.mason.lsp_servers")(name)

            if config then
                config.on_attach = function(client, bufnr)
                    require("navigator.lspclient.mapping").setup({ client = client, bufnr = bufnr }) -- setup navigator keymaps here,
                    require("navigator.dochighlight").documentHighlight(bufnr)
                    require("navigator.codeAction").code_action_prompt(bufnr)
                end
                require("lspconfig")[name].setup(config)
            end
        end,
    },
})
-- Default keymaps
-- mode 	key 	function
-- n 	gr 	async references, definitions and context
-- n 	<Leader>gr 	show reference and context
-- i 	<m-k> 	signature help
-- n 	<c-k> 	signature help
-- n 	<C-]> 	go to definition (if multiple show listview)
-- n 	gp 	definition preview (show Preview)
-- n 	gP 	type definition preview (show Preview)
-- n 	<C-LeftMouse> 	definition
-- n 	g<LeftMouse> 	implementation
-- n 	<Leader>gt 	treesitter document symbol
-- n 	<Leader>gT 	treesitter symbol for all open buffers
-- n 	<Leader> ct 	ctags symbol search
-- n 	<Leader> cg 	ctags symbol generate
-- n 	K 	hover doc
-- n 	<Space>ca 	code action (when you see 🏏 )
-- n 	<Space>la 	code lens action (when you see a codelens indicator)
-- v 	<Space>ca 	range code action (when you see 🏏 )
-- n 	<Space>rn 	rename with floating window
-- n 	<Leader>re 	rename (lsp default)
-- n 	<Leader>gi 	hierarchy incoming calls
-- n 	<Leader>go 	hierarchy outgoing calls
-- n 	<Space>ff 	format buffer (LSP)
-- v 	<Space>ff 	format selection range (LSP)
-- n 	gi 	implementation
-- n 	<Space> D 	type definition
-- n 	gL 	show line diagnostic
-- n 	gG 	show diagnostic for all buffers
-- n 	]d 	next diagnostic error or fallback
-- n 	[d 	previous diagnostic error or fallback
-- n 	<Leader> dt 	diagnostic toggle(enable/disable)
-- n 	]r 	next treesitter reference/usage
-- n 	[r 	previous treesitter reference/usage
-- n 	<Space> wa 	add workspace folder
-- n 	<Space> wr 	remove workspace folder
-- n 	<Space> wl 	print workspace folder
-- n 	<Leader>k 	toggle reference highlight
-- i/n 	<C-p> 	previous item in list
-- i/n 	<C-n> 	next item in list
-- i/n 	number 1~9 	move to ith row/item in the list
-- i/n 	<Up> 	previous item in list
-- i/n 	<Down> 	next item in list
-- n 	<Ctrl-w>j 	move cursor to preview (windows move to bottom view point)
-- n 	<Ctrl-w>k 	move cursor to list (windows move to up view point)
-- i/n 	<C-o> 	open preview file in nvim/Apply action
-- n 	<C-v> 	open preview file in nvim with vsplit
-- n 	<C-s> 	open preview file in nvim with split
-- n 	<Enter> 	open preview file in nvim/Apply action
-- n 	<ESC> 	close listview of floating window

-- i/n 	<C-e> 	close listview of floating window
-- n 	<C-q> 	close listview and send results to quickfix
-- i/n 	<C-b> 	previous page in listview
-- i/n 	<C-f> 	next page in listview
-- i/n 	<C-s> 	save the modification to preview window to file
require("navigator").setup({
    mason = true,
    lsp = { disable_lsp = { "pylsp" } }, -- disable pylsp setup from navigator
    default_mapping = true, -- set to false if you will remap every key
    -- please check mapping.lua for all keymaps
    keymaps = {
        { key = "gD", func = "declaration()" },
        { key = "gd", func = "definition()" },
        { key = "", func = "hover()" },
        { key = "gi", func = "implementation()" },
        { key = "<C-k>", func = "signature_help()" },
        { key = "<space>wa", func = "add_workspace_folder()" },
        { key = "<space>wr", func = "remove_workspace_folder()" },
        { key = "gr", func = "references()" },
        { key = "[d", func = "goto_prev()" },
        { key = "]d", func = "goto_next()" },
        { key = ";ff", func = "format_buffer()" },
        { key = ";ff", func = "format_selection_range()" },
    },
})
local cfg = {
    bind = true,
    doc_lines = 10,
    floating_window = lambda.config.lsp.lsp_sig.use_floating_window, -- show hint in a floating window, set to false for virtual text only mode ]]
    floating_window_above_cur_line = lambda.config.lsp.lsp_sig.use_floating_window_above_cur_line,
    hint_enable = true, -- virtual hint enable
    fix_pos = lambda.config.lsp.lsp_sig.fix_pos, -- set to true, the floating window will not auto-close until finish all parameters
    hint_prefix = "🐼 ", -- Panda for parameter
    auto_close_after = 15, -- close after 15 seconds
    handler_opts = {
        border = "single",
    },
    zindex = 1002,
    timer_interval = 100,
    log_path = vim.fn.expand("$HOME") .. "/tmp/sig.log",
    padding = " ", -- character to pad on left and right of signature can be ' ', or '|'  etc
    toggle_key = [[<M-x>]], -- toggle signature on and off in insert mode,  e.g. '<M-x>'
    select_signature_key = [[<M-c>]], -- toggle signature on and off in insert mode,  e.g. '<M-x>'
}

require("lsp_signature").setup(cfg)
