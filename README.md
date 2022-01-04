
# IMPORTANT NOTE:

I did not create this, all credit for the majority goes to ray-x as this setup is forked from his, i have merely added / removed certain aspects to fit my own programming needs, such as using ale, dap install and so on, i will continue to lazy load things if I can.


Again all credit to ray-x, if this setup is currently not working - ive most likely screwed something up : please just refer to his setup as it works : )



This neovim configure file is highly optimized for the impatient. Packer lazy loading + After syntax highlight rendering. Maybe the
only nvim setup in github that can render multiple files with treesitter in less than 80ms with ~200 plugins installed
(e.g. Open both util.lua(1686 loc) and lsp.lua(1538 loc) from neovim source code in 60.6ms)

- nvim+kitty configured with pop menu:


## Why this config ?

1. Im a plugin hoe, i love having extra stuff, find a list of plugins in my stared if you want some random ones .
2. I mainly code in python, C, Java : I have yet to setup java correctly as its too much of a hastle and mavent is not
   avaliable for it : This setup is made for C++ / C / Lua / Python / Bash / Golang
3. My binds: Still a few things left to do, but i made sure that everything is easy to reach in some sense .

## Previews


## Battery included

About 200 plugins and 1600 lines of lua and vim code.


## Neovim Plugins

There are lots of amazing plugins,
I used following plugin a lots

- `Plug` -> `Dein` -> `Lua-Packer`
  Change to Lua-Packer does not
  decrease startup time as Plug -> Dein. But still about 80ms faster for Golang codes loading.

  I followed Raphael(a.k.a glepnir) https://github.com/glepnir/nvim dotfiles. He provides a good wrapper for
  Packer. I have an `overwrite` folder which will override the settings. Also, lots of changes in modules/plugins.
  luarock setup
  A.T.M. nvim-compe/cmp as a completion engine with LSP, LSP saga. vim-multi-cursor, clap/telescope. treesitter,
  lazy load vim-go. So, other than module folder, I could copy/paste everything else from glepnir's configure file,
  which make my life easier.

- Telescope + Vim-Clap

  One of the best plugin for search anything. I used it to replace fzf, leaderF, leaderP, defx, Ag/Ack/Rg, yank(ring), project management. undolist and many more. Telescope is awesome, only issue is performance.

- nvim-lsp

- nvim-tree: file-explorer (lightweight and fast)
- hrsh7th/nvim-cmp: auto-complete
- vsnip: code snipts(Load snippet from VSCode extension). It is a full featured IDE.
- ALE -> Efm

Lint and format moved to efm-server


- Debug:

  dlv, nvim-dap

- Theme, look&feel:

  home cooked Aurora, windline (lua), devicons(lua), blankline(indent), bufferline

- Color:

  Primary with treesitter from nvim nightly (nvim-lsp and this make it hard for me to turn back to vim), log-highlight, limelight, interestingwords,
  hexokinase as a replacement for colorizer (display hex and color in highlight)

- Git:

  fugitive, nvimtree, gitsigns.nvim, VGit.nvim

- Format:

  tabular, lsp based code formating (or, sometimes prettier), auto-pair

- Menu and tab:

  - quickui(created a menu for the function/keybind I used less often. I can not remember all the commands and keybinds....)
    But Damn, I spend lots of time configuring it, however, it was used rarely. So I end up delete the plugin.
  - nvim-bufferline.lua: Yes, with lua and neovim only

- Tools: floatterm, scrollview

- Move and Edit:

  easymotion -> hop&lightspeed, vim-multi-cursor, navigator.lua (better treesitter folding), Sad for complex find and replace

## Install

Note: I tested it on Mac and linux, not sure about window

Clone the repo

Link nvim to $HOME/.config/

e.g.

```
ls ~/.config/nvim

~/.config/nvim -> /Users/rayx/github/dotfiles/nvim

```

On windows the config path is
`C:\Users\your_user_name\AppData\Local\nvim`
You need to link or replace above folder

Please install Nerd Fonts(I am using VictorMono) and kitty so font setting in GUI will work as expected

Startup nvim

If you saw error message "Error in packer_compiled: ..." Please press `Enter`, that will allow packer install the plugins.
After all plugins install restart the nvim.

Note:
The packages and data will be install to
`~/.local/share/nvim`

Please backup this folder if necessary

The setup should work with nvim0.5.1+ or nvim0.6+. A patched nerd font is needed. Also if you start nvim from terminal,
make sure it support nerdfont and emoji

## Configure

If you would like to sync to my branch. You can add you own setup in lua/overwrite folder

You can put your own plugins setup in `modules/user` folder

## Shell

- OhMyZshell with kitty


## Parking lots

Main Tools i use are the following

### Python :
 - Ale - loaded only for python files - formats and has a nice auto import
 - use java language server with null-ls as my flake8 service : Ale linting is disabled i only use it for vim-nayvy .
 - All refactor and referencing plugins are used

### C:
- Just use toggle term mate

### Debuging
- It is a pain in the ass to set up every debugger, i used to use dapinstall, but for now im just working off some
custom ones that i can make. GDB is teh main one for C - please refer to the debugging section .

## References
