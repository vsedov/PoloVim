local dap = require("dap")
local HOME = os.getenv("HOME")
local dap_install = require("dap-install")
local api = vim.api
local dbg_list = require("dap-install.api.debuggers").get_installed_debuggers()

--Virtual Text stuff
vim.g.dap_virtual_text = true

--
-- require('dap-python').setup('~/.virtualenvs/debugpy/bin/python')
require("dap-python").setup("/bin/python")
require("dap-python").test_runner = "pytest"

-- Dap Installer

dap_install.setup({
	installation_path = vim.fn.stdpath("data") .. "/dapinstall/",
})

-- get local debug on the gen list .

for _, debugger in ipairs(dbg_list) do
	dap_install.config(debugger)
end
-- Dap Ui
require("dapui").setup()
