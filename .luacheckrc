-- Global objects
stds.nvim = {
  globals = {
    "vim",
    "lamda"

    },

  read_globals  = {
    "lamda"
    "packer_plugins",
    "_",
    "vim",
    "neorg",
    "RELOAD",
    "dump",
    "P",
    "plugin_folder",
    "compare_to_clipboard",
    "plugin_debug",
    "load_coq",
    "use_nulls",
    "use_gitsigns",
    "preserve",
    "Snake",
    "Camel",
    "overide_notify_desktop ",
    "PASTE",
    "PERF",
    "Format",
    "Log",
    "lprint"
  }
}
std = "lua51+nvim"

ignore = {
  "212/_.*",  -- unused argument, for vars with "_" prefix
}
