local bind = require("keymap.bind")

bind.nvim_load_mapping(require("keymap.core"))
bind.nvim_load_mapping(require("keymap.function"))
bind.nvim_load_mapping(require("keymap.misc"))
bind.nvim_load_mapping(require("keymap.telescope"))
bind.nvim_load_mapping(require("keymap.overwrite"))
bind.nvim_load_mapping(require("keymap.useful"))
