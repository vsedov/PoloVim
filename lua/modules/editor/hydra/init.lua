local loader = require("packer").loader
loader("keymap-layer.nvim vgit.nvim gitsigns.nvim")

require("modules.editor.hydra.window")
require("modules.editor.hydra.git")
require("modules.editor.hydra.tele")
require("modules.editor.hydra.buffer")
