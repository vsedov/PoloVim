local dap = require("dap")
local HOME = os.getenv("HOME")
local dap_install = require("dap-install")
local api = vim.api

-- Dap Ui  + Virtual Text stuff
require("dapui").setup()
vim.g.dap_virtual_text = true

--
-- require('dap-python').setup('~/.virtualenvs/debugpy/bin/python')
require("dap-python").setup("/bin/python")
require("dap-python").test_runner = "pytest"

-- Dap Installer

dap_install.setup({
	installation_path = vim.fn.stdpath("data") .. "/dapinstall/",
})
