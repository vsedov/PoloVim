local loader = require("packer").loader
local global = require("core.global").vim_path
loader("keymap-layer.nvim vgit.nvim gitsigns.nvim")

require("modules.editor.hydra.buffer").buffer()

require("modules.editor.hydra.window")
require("modules.editor.hydra.git")
require("modules.editor.hydra.tele")
require("modules.editor.hydra.dap")
require("modules.editor.hydra.vim_options")
require("modules.editor.hydra.word_motion")
require("modules.editor.hydra.venn")
