local dap = require('dap');    
local api = vim.api
local HOME = os.getenv('HOME')
-- Need to figure out how to do java 



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
}dap.configurations.rust = {
    {
        type = "rust",
        name = "Debug",
        request = "launch",
        program= ""
    }
}

