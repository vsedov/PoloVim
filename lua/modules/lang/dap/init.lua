-- require('telescope').load_extension('dap')
local M = {}
local bind = require("keymap.bind")
local map_cr = bind.map_cr
-- local map_cu = bind.map_cu
-- local map_cmd = bind.map_cmd
-- local map_args = bind.map_args

local HOME = os.getenv("HOME")
local api = vim.api

-- TODO
-- need to fix debug files and binds, such that when i stop  i get my olds binds back ,
local function keybind()
    local keys = {
        -- DAP --

        ["n|<leader><F5>"] = map_cr('<cmd>lua require"dap".continue()'):with_noremap():with_silent(),
        ["n|<leader><F10>"] = map_cr('<cmd>lua require"dap".step_over()'):with_noremap():with_silent(),
        ["n|<leader><F11>"] = map_cr('<cmd>lua require"dap".step_into()'):with_noremap():with_silent(),
        ["n|<leader><F12>"] = map_cr('<cmd>lua require"dap".step_out()'):with_noremap():with_silent(),
        ["n|<leader>ds"] = map_cr('<cmd>lua require"dap".close()'):with_noremap():with_silent(),
        ["n|<leader>dk"] = map_cr('<cmd>lua require"dap".up()'):with_noremap():with_silent(),
        ["n|<leader>dj"] = map_cr('<cmd>lua require"dap".down()'):with_noremap():with_silent(),
        ["n|<leader><F9>"] = map_cr('<cmd>lua require"dap".toggle_breakpoint()'):with_noremap():with_silent(),
        ["n|<leader>dsbr"] = map_cr('<cmd>lua require"dap".set_breakpoint(vim.fn.input("Breakpoint condition: "))')
            :with_noremap()
            :with_silent(),
        ["n|<leader>b"] = map_cr('<cmd>lua require"dap".set_breakpoint(nil, nil, vim.fn.input("Log point message: "))')
            :with_noremap()
            :with_silent(),
        ["n|<leader>dro"] = map_cr("<cmd>:"):with_noremap():with_silent(),
        ["n|<leader>drl"] = map_cr('<cmd>lua require"dap".repl.run_last()'):with_noremap():with_silent(),
        -- ["n|[t"] = map_cr("lua require'nvim-treesitter-refactor.navigation'.goto_previous_usage(0)"):with_noremap():with_silent(),
        -- ["n|]t"] = map_cr("lua require'nvim-treesitter-refactor.navigation'.goto_next_usage(0)"):with_noremap():with_silent(),
        ["n|<leader>dcc"] = map_cr('<cmd>lua require"telescope".extensions.dap.commands{}')
            :with_noremap()
            :with_silent(),
        ["n|<leader>dco"] = map_cr('<cmd>lua require"telescope".extensions.dap.configurations{}')
            :with_noremap()
            :with_silent(),
        ["n|<leader>dl"] = map_cr('<cmd>lua require"telescope".extensions.dap.list_breakpoints{}')
            :with_noremap()
            :with_silent(),
        ["n|<leader>dv"] = map_cr('<cmd>lua require"telescope".extensions.dap.variables{}')
            :with_noremap()
            :with_silent(),
        ["n|<leader>df"] = map_cr('<cmd>lua require"telescope".extensions.dap.frames{}'):with_noremap():with_silent(),
        --
    }

    bind.nvim_load_mapping(keys)
    local dap_keys = {
        -- DAP --
        -- run
        -- ["n|r"] = map_cr('<cmd>lua require"go.dap".run()<CR>'):with_noremap():with_silent(),
        ["n|c"] = map_cr('<cmd>lua require"dap".continue()<CR>'):with_noremap():with_silent(),
        ["n|n"] = map_cr('<cmd>lua require"dap".step_over()<CR>'):with_noremap():with_silent(),
        ["n|s"] = map_cr('<cmd>lua require"dap".step_into()<CR>'):with_noremap():with_silent(),
        -- ["n|o"] = map_cr('<cmd>lua require"dap".step_out()<CR>'):with_noremap():with_silent(),
        ["n|S"] = map_cr('<cmd>lua require"dap".stop()<CR>'):with_noremap():with_silent(),
        ["n|u"] = map_cr('<cmd>lua require"dap".up()<CR>'):with_noremap():with_silent(),
        ["n|D"] = map_cr('<cmd>lua require"dap".down()<CR>'):with_noremap():with_silent(),
        ["n|C"] = map_cr('<cmd>lua require"dap".run_to_cursor()<CR>'):with_noremap():with_silent(),
        ["n|b"] = map_cr('<cmd>lua require"dap".toggle_breakpoint()<CR>'):with_noremap():with_silent(),
        ["n|P"] = map_cr('<cmd>lua require"dap".pause()<CR>'):with_noremap():with_silent(),
        ["n|p"] = map_cr('<cmd>lua require"dap.ui.widgets".hover()<CR>'):with_noremap():with_silent(),
        ["v|p"] = map_cr('<cmd>lua require"dap.ui.variables".visual_hover()<CR>'):with_noremap():with_silent(),
        --
    }

    bind.nvim_load_mapping(dap_keys)
end

local loader = require("packer").loader

if ft == "go" then
    require("modules.lang.dap.go")
end

M.prepare = function()
    loader("nvim-dap")
    loader("telescope-dap.nvim")
    loader("nvim-dap-ui")
    loader("nvim-dap-virtual-text")

    require("dapui").setup({
        icons = { expanded = "▾", collapsed = "▸" },
        mappings = {
            -- Use a table to apply multiple mappings
            expand = { "<CR>", "<2-LeftMouse>" },
            open = "o",
            remove = "d",
            edit = "e",
            repl = "r",
        },
        sidebar = {
            -- You can change the order of elements in the sidebar
            elements = {
                -- Provide as ID strings or tables with "id" and "size" keys
                {
                    id = "scopes",
                    size = 0.25, -- Can be float or integer > 1
                },
                { id = "breakpoints", size = 0.25 },
                { id = "stacks", size = 0.25 },
                { id = "watches", size = 00.25 },
            },
            size = 40,
            position = "left", -- Can be "left", "right", "top", "bottom"
        },
        tray = {
            elements = { "repl" },
            size = 10,
            position = "bottom", -- Can be "left", "right", "top", "bottom"
        },
        floating = {
            max_height = nil, -- These can be integers or a float between 0 and 1.
            max_width = nil, -- Floats will be treated as percentage of your screen.
            mappings = {
                close = { "q", "<Esc>" },
            },
        },
        windows = { indent = 1 },
    })

    local dap, dapui = require("dap"), require("dapui")
    dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
    end

    require("nvim-dap-virtual-text").setup({
        enabled = true, -- enable this plugin (the default)
        enabled_commands = true, -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did notify its termination)
        highlight_changed_variables = true, -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
        highlight_new_as_changed = false, -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
        show_stop_reason = true, -- show stop reason when stopped for exceptions
        commented = false, -- prefix virtual text with comment string
        -- experimental features:
        virt_text_pos = "eol", -- position of virtual text, see :h nvim_buf_set_extmark()
        all_frames = true, -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
        virt_lines = false, -- show virtual lines instead of virtual text (will flicker!)
        virt_text_win_col = nil, -- position the virtual text at a fixed window column (starting from the first text column) ,
        -- e.g. 80 to position at column 80 see :h nvim_buf_set_extmark()
    })

    if vim.bo.filetype == "python" then
        loader("nvim-dap-python")
        require("dap-python").setup("/bin/python") -- might use whch python here not sure
        require("dap-python").test_runner = "pytest"
    end

    local ft = vim.bo.filetype
    print(ft)

    if ft == "lua" then
        local keys = {
            ["n|<F5>"] = map_cr('<cmd>lua require"osv".launch()'):with_noremap():with_silent(),
            ["n|<F4>"] = map_cr('<cmd>lua require"dap".continue()'):with_noremap():with_silent(),
        }
        bind.nvim_load_mapping(keys)
        require("modules.lang.dap.lua")
    end
    if ft == "rust" then
        require("modules.lang.dap.lua")
    end

    if ft == "typescript" or ft == "javascript" then
        print("debug prepare for js")
        -- vim.cmd([[command! -nargs=*  Debug lua require"modules.lang.dap.jest".attach()]])
        vim.cmd([[command! -nargs=*  DebugTest lua require"modules.lang.dap.jest".run(<f-args>)]])
        require("modules.lang.dap.js")
    end

    vim.cmd([[command! BPToggle lua require"dap".toggle_breakpoint()]])

    vim.cmd([[command! Debug lua require"modules.lang.dap".StartDbg()]])
    vim.cmd([[command! StopDebug lua require"modules.lang.dap".StopDbg()]])

    require("dapui").setup()
    require("dapui").open()
end

M.StartDbg = function()
    -- body
    keybind()
    require("dap").continue()
end

M.StopDbg = function()
    local keys = { "c", "n", "s", "o", "u", "D", "C", "b", "P", "p" }
    for _, value in pairs(keys) do
        local cmd = "unmap " .. value
        vim.cmd(cmd)
    end
    -- rebind everything back to normal -_-

    vim.cmd([[uvmap p]])
    require("dap").disconnect()
    require("dap").stop()
    require("dap").repl.close()
    require("dapui").close()
end

return M
