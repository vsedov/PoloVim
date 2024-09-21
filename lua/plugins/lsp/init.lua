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
local util = require("navigator.util")
local log = util.log
local trace = util.trace
local api = vim.api

if vim.lsp.buf.format == nil then
    vim.lsp.buf.format = vim.lsp.buf.formatting
end

if vim.diagnostic == nil then
    util.error("Please update nvim to 0.6.1+")
end

local function fallback_keymap(key)
    -- when handler failed fallback to key
    vim.schedule(function()
        print("fallback to key", key)
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), "n", true)
    end)
end

local function fallback_fn(key)
    return function()
        fallback_keymap(key)
    end
end

local double = { "╔", "═", "╗", "║", "╝", "═", "╚", "║" }
local single = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }
local remap = util.binding_remap

local key_maps = {}

require("navigator").setup({
    mason = true,
    default_mapping = false, -- set to false if you will remap every key
    -- please check mapping.lua for all keymaps
    debug = true,
    keymaps = keymaps,
    -- keymaps = {
    --     { key = "gD", func = "declaration()" },
    --     { key = "gd", func = "definition()" },
    --     { key = "", func = "hover()" },
    --     { key = "gi", func = "implementation()" },
    --     { key = "<C-k>", func = "signature_help()" },
    --     { key = "<space>wa", func = "add_workspace_folder()" },
    --     { key = "<space>wr", func = "remove_workspace_folder()" },
    --     { key = "gr", func = "references()" },
    --     { key = "[d", func = "goto_prev()" },
    --     { key = "]d", func = "goto_next()" },
    --     { key = ";ff", func = "format_buffer()" },
    --     { key = ";ff", func = "format_selection_range()" },
    -- },

    treesitter_analysis = true, -- treesitter variable context
    treesitter_navigation = true, -- bool|table false: use lsp to navigate between symbol ']r/[r', table: a list of
    --lang using TS navigation
    treesitter_analysis_max_num = 100, -- how many items to run treesitter analysis
    treesitter_analysis_condense = true, -- condense form for treesitter analysis
    -- this value prevent slow in large projects, e.g. found 100000 reference in a project
    transparency = 50, -- 0 ~ 100 blur the main window, 100: fully transparent, 0: opaque,  set to nil or 100 to disable it

    lsp_signature_help = false, -- if you would like to hook ray-x/lsp_signature plugin in navigator
    -- setup here. if it is nil, navigator will not init signature help
    signature_help_cfg = nil, -- if you would like to init ray-x/lsp_signature plugin in navigator, and pass in your own config to signature help
    icons = { -- refer to lua/navigator.lua for more icons config
        -- requires nerd fonts or nvim-web-devicons
        icons = false,
        -- Code action
        code_action_icon = "🏏", -- note: need terminal support, for those not support unicode, might crash
        -- Diagnostics
        diagnostic_head = "🐛",
        diagnostic_head_severity_1 = "🈲",
        fold = {
            prefix = "⚡", -- icon to show before the folding need to be 2 spaces in display width
            separator = "", -- e.g. shows   3 lines 
        },
    },
    mason = true, -- set to true if you would like use the lsp installed by williamboman/mason
    lsp = {
        enable = true, -- skip lsp setup, and only use treesitter in navigator.
        disable_lsp = { "ruff", "ruff_lsp", "sourcery", "ts_ls", "ts_ls.", "none_ls", "null_ls", "sourcery" },
        -- Use this if you are not using LSP servers, and only want to enable treesitter support.
        -- If you only want to prevent navigator from touching your LSP server configs,
        -- use `disable_lsp = "all"` instead.
        -- If disabled, make sure add require('navigator.lspclient.mapping').setup({bufnr=bufnr, client=client}) in your
        -- own on_attach
        code_action = { enable = false },

        code_lens_action = { enable = true, sign = true, sign_priority = 40, virtual_text = true },
        document_highlight = true, -- LSP reference highlight,
        -- it might already supported by you setup, e.g. LunarVim
        format_on_save = false, -- {true|false} set to false to disasble lsp code format on save (if you are using prettier/efm/formater etc)
        -- table: {enable = {'lua', 'go'}, disable = {'javascript', 'typescript'}} to enable/disable specific language
        -- enable: a whitelist of language that will be formatted on save
        -- disable: a blacklist of language that will not be formatted on save
        -- function: function(bufnr) return true end to enable/disable lsp format on save
        format_options = { async = false }, -- async: disable by default, the option used in vim.lsp.buf.format({async={true|false}, name = 'xxx'})
        disable_format_cap = { "sqlls", "lua_ls", "gopls" }, -- a list of lsp disable format capacity (e.g. if you using efm or vim-codeformat etc), empty {} by default
        diagnostic = {
            underline = true,
            virtual_text = false, -- show virtual for diagnostic message
            update_in_insert = false, -- update diagnostic message in insert mode
            float = { -- setup for floating windows style
                focusable = false,
                sytle = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        },

        diagnostic_scrollbar_sign = { "▃", "▆", "█" }, -- experimental:  diagnostic status in scroll bar area; set to false to disable the diagnostic sign,
        --                for other style, set to {'╍', 'ﮆ'} or {'-', '='}
        diagnostic_virtual_text = false, -- show virtual for diagnostic message
        diagnostic_update_in_insert = false, -- update diagnostic message in insert mode
        display_diagnostic_qf = false, -- always show quickfix if there are diagnostic errors, set to false if you want to ignore it
    },
})
keys = {
    {
        "<leader>ip",
        function()
            return vim.bo.filetype == "AvanteInput" and require("avante.clipboard").paste_image()
                or require("img-clip").paste_image()
        end,
        desc = "clip: paste image",
    },
    {
        "<leader>as",
        function()
            local function AvanteSwitchProvider()
                local providers = { "Claude", "OpenAI", "Azure", "Gemini", "Cohere", "Copilot", "Perplexity" }
                vim.ui.select(providers, {
                    prompt = "Select Avante Provider:",
                    format_item = function(item)
                        return item
                    end,
                }, function(choice)
                    if choice then
                        vim.cmd("AvanteSwitchProvider " .. choice)
                        vim.notify("Avante provider switched to " .. choice, vim.log.levels.INFO)
                    end
                end)
            end
            AvanteSwitchProvider()
        end,
        desc = "Switch Avante Provider",
    },
}
for _, key in ipairs(keys) do
    vim.keymap.set("n", key[1], key[2], { desc = key[3], noremap = true })
end
rocks.safe_force_packadd({ "nvim-web-devicons", "plenary.nvim", "render-markdown.nvim" })

local opts = {
    provider = "claude", -- Recommend using Claude
    auto_suggestions_provider = "claude", -- Since auto-suggestions are a high-frequency operation and therefore expensive, it is recommended to specify an inexpensive provider or even a free provider: copilot
    claude = {
        endpoint = "https://api.anthropic.com",
        model = "claude-3-5-sonnet-20240620",
        temperature = 0,
        -- max_tokens = 10096,
    },

    behaviour = {
        auto_suggestions = true, -- Experimental stage
        auto_set_highlight_group = true,
        auto_set_keymaps = true,
        auto_apply_diff_after_generation = true,
        support_paste_from_clipboard = true,
    },
    mappings = {
        diff = {
            ours = "co",
            theirs = "ct",
            all_theirs = "ca",
            both = "cb",
            cursor = "cc",
            next = "]x",
            prev = "[x",
        },
        suggestion = {
            accept = "<c-l>",
            -- next = "<c-]>",
            -- prev = "<c-[>",
            -- dismiss = "<C-e>",
        },
        jump = {
            next = "]]",
            prev = "[[",
        },
        submit = {
            normal = "<CR>",
            insert = "<C-s>",
        },
    },
}
local opt2 = {
    file_types = { "markdown", "Avante" },
}
require("render-markdown").setup(opt2)
require("avante_lib").load()
require("avante").setup(opt)
