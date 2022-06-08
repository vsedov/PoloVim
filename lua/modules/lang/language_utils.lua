local M = {}
-- local HOME = os.getenv("HOME")
-- local api = vim.api
-- local async = require("plenary.async")
-- local notify = require("notify").async

local bind = require("keymap.bind")

local map_cr = bind.map_cr
local map_cu = bind.map_cu
-- local map_cmd = bind.map_cmd
-- local map_args = bind.map_args
vim.notify = require("notify")
local loader = require("packer").loader

local function snip_run_binds()
    local keys = {
        ["v|<Leader>sr"] = map_cu("'<,'>SnipRun<cr>"):with_noremap():with_silent(),
        ["n|<Leader>sr"] = map_cu("SnipRun<cr>"):with_noremap():with_silent(),
    }
    bind.nvim_load_mapping(keys)
end

local function magma_binds()
    local keys = {
        ["n|<leader>a"] = map_cr("<cmd>MagmaEvaluateOperator<CR>"):with_noremap():with_silent():with_expr(),
        ["n|<leader>ar"] = map_cr("<cmd>MagmaEvaluateLine<cr>"):with_noremap():with_silent(),
        ["n|<leader>ad"] = map_cr("<cmd>MagmaDelete<cr>"):with_noremap():with_silent(),
        ["n|<leader>ao"] = map_cr("<cmd>MagmaShowOutput<cr>"):with_noremap():with_silent(),
        ["n|<leader>ac"] = map_cr("<cmd><cmd>MagmaReevaluateCell<cr>"):with_noremap():with_silent(),
        ["v|<leader>ar"] = map_cr("<cmd>MagmaEvaluateVisual<cr>"):with_noremap():with_silent(),
    }
    bind.nvim_load_mapping(keys)
end

M.load_snip_run = function()
    vim.notify("SnipRun Loaded")
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
    })
    snip_run_binds()
end

M.python_repl = function()
    vim.notify("Python REPL Plugins Loaded")
    vim.cmd([[packadd magma-nvim]])
    vim.cmd([[UpdateRemotePlugins]])
    vim.cmd([[MagmaInit python3]])
    magma_binds()
end

return M
