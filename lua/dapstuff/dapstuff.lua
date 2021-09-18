local dap = require('dap');    
local api = vim.api
local HOME = os.getenv('HOME')




vim.g.dap_virtual_text = false
vim.g.dap_virtual_text = true
vim.g.dap_virtual_text = 'all frames'

vim.g['test#python#pytest#executable'] = 'pytest'


require("ultest").setup({
    builders = {
        ['python#pytest'] = function(cmd)

			local non_modules = {'python', 'pipenv', 'poetry'}
			-- Index of the python module to run the test.
			local module
			if vim.tbl_contains(non_modules, cmd[1]) then
			module = cmd[3]
			else
			module = cmd[1]
			end
			-- Remaining elements are arguments to the module

            return {
                dap = {
			      type = 'python',
			      request = 'launch',
			      module = module,
			      args = args,
			      cwd = vim.fn.getcwd(),

			   	  pathMappings = {
                        {
                            localRoot = vim.fn.getcwd(), -- Wherever your Python code lives locally.
                        }
                    }

                }
            }
        end
    }
})

dap.adapters.lldb = {
    type = 'executable',
    command = '/usr/bin/lldb-vscode',
    name = 'lldb'
}

dap.configurations.cpp = {
    {
        name = "Launch",
        type = "lldb",
        request = "launch",
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/',
                                'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        args = {},

        runInTerminal = false
    }
}

dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp
