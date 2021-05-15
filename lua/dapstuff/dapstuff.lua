local dap = require('dap');    
local api = vim.api
local HOME = os.getenv('HOME')
-- Need to figure out how to do java 


require('dap-python').setup('/usr/bin/python3')
-- require('dap-python').test_runner = 'pytest'
dap.configurations.python = {
    cwd = vim.fn.getcwd(),
    pathMappings = {
        {
            localRoot = vim.fn.getcwd(), -- Wherever your Python code lives locally.
        };
    };
}


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



dap.adapters.cpp = {
    type = 'executable',
    attach = {
        pidProperty = "pid",
        pidSelect = "ask"
    },
    command = 'lldb',
    env = {
        LLDB_LAUNCH_FLAG_LAUNCH_IN_TTY = "YES"
    },
    name = "lldb"
}

dap.configurations.cpp = {
{
  name = "Launch",
  type = "cpp",
  request = "launch",
  program = function()
    return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
  end,
  cwd = '${workspaceFolder}',
  env = function()
    local variables = {}
    for k, v in pairs(vim.fn.environ()) do
      table.insert(variables, string.format("%s=%s", k, v))
    end
    return variables
  end,
  stopOnEntry = false,
  args = {}
},
}


-- need final one for java and then i should be good with lsp . 


-- I also need a rust debugger as well considering that im learning rust . 




-- Rust 
-- Java
-- Double Check C 
-- Memory control  
-- Lua debugger as well and lsp , just to be sure . 

dap.adapters.rust = {
    type = 'executable',
    attach = {
        pidProperty = "pid",
        pidSelect = "ask"
    },
    command = 'lldb-vscode', -- my binary was called 'lldb-vscode-11'
    env = {
        LLDB_LAUNCH_FLAG_LAUNCH_IN_TTY = "YES"
    },
    name = "lldb"
}
dap.configurations.rust = {
    {
        type = "rust",
        name = "Debug",
        request = "launch",
        program= ""
    }
}


