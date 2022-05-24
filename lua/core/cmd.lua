local add_cmd = vim.api.nvim_create_user_command
local loader = require("packer").loader

vim.cmd([[vnoremap  <leader>y  "+y]])
vim.cmd([[nnoremap  <leader>Y  "+yg_]])
-- vim.cmd([[vnoremap  <M-c>  "+y]])
-- vim.cmd([[nnoremap  <M-c>  "+yg_]])

vim.cmd([[vnoremap  <localleader>c  *+y]])
vim.cmd([[nnoremap  <localleader>c  *+yg_]])

add_cmd("AbbrivGodMode", function()
    vim.cmd([[packadd vim-abbrev]])
end, { force = true })

add_cmd("DuckStart", function()
    require("modules.useless.config").launch_duck()
end, { force = true })

add_cmd("TestStart", function()
    require("modules.lang.language_utils").testStart()
end, { force = true })

add_cmd("DebugOpen", function()
    require("modules.lang.dap").prepare()
end, { force = true })

add_cmd("HpoonClear", function()
    require("harpoon.mark").clear_all()
end, { force = true })

add_cmd("Hashbang", function()
    local shells = {
        sh = { "#! /usr/bin/env bash" },
        py = { "#! /usr/bin/env python3" },
        scala = { "#! /usr/bin/env scala" },
        tcl = { "#! /usr/bin/env tclsh" },
        lua = {
            "#! /bin/sh",
            "_=[[",
            'exec lua "$0" "$@"',
            "]]",
        },
    }

    local extension = vim.fn.expand("%:e")

    if shells[extension] then
        local hb = shells[extension]
        hb[#hb + 1] = ""
        vim.api.nvim_buf_set_lines(0, 0, 0, false, hb)
        vim.api.nvim_create_autocmd("BufWritePost", {
            buffer = 0,
            once = true,
            command = "silent !chmod u+x %",
        })
    end
end, { force = true })

add_cmd("Tags", function()
    vim.cmd(
        [[!ctags -R -I EXTERN -I INIT --exclude='build*' --exclude='.vim-src/**' --exclude='node_modules/**' --exclude='venv/**' --exclude='**/site-packages/**' --exclude='data/**' --exclude='dist/**' --exclude='notebooks/**' --exclude='Notebooks/**' --exclude='*graphhopper_data/*.json' --exclude='*graphhopper/*.json' --exclude='*.json' --exclude='qgis/**' *]]
    )
end, { force = true })

add_cmd("Keymaps", function()
    require("overwrite.mapping").get_keymaps()
end, { force = true })

add_cmd("ColourScheme", function()
    require("utils.telescope").colorscheme()
end, { force = true })

add_cmd("BL", function()
    require("utils.selfunc").blameVirtualText()
end, { force = true })

add_cmd("BLR", function()
    require("utils.selfunc").clearBlameVirtualText()
end, { force = true })

add_cmd("Diagnostics", function()
    vim.cmd("silent lmake! %")
    if #vim.fn.getloclist(0) == 0 then
        vim.cmd("lopen")
    else
        vim.cmd("lclose")
    end
end, {
    force = true,
})
add_cmd("Format", "silent normal! mxgggqG`x<CR>", {
    force = true,
})

-- Adjust Spacing:
add_cmd("Spaces", function(args)
    local wv = vim.fn.winsaveview()
    vim.opt_local.expandtab = true
    vim.cmd("silent execute '%!expand -it" .. args.args .. "'")
    vim.fn.winrestview(wv)
    vim.cmd("setlocal ts? sw? sts? et?")
end, {
    force = true,
    nargs = 1,
})
add_cmd("Tabs", function(args)
    local wv = vim.fn.winsaveview()
    vim.opt_local.expandtab = false
    vim.cmd("silent execute '%!unexpand -t" .. args.args .. "'")
    vim.fn.winrestview(wv)
    vim.cmd("setlocal ts? sw? sts? et?")
end, {
    force = true,
    nargs = 1,
})

add_cmd("NvimEditInit", function(args)
    vim.cmd("split | edit $MYVIMRC")
end, {
    force = true,
    nargs = "*",
})
add_cmd("NvimSourceInit", function(args)
    vim.cmd("luafile $MYVIMRC")
end, {
    force = true,
    nargs = "*",
})
add_cmd("TodoLocal", "botright silent! lvimgrep /\\v\\CTODO|FIXME|HACK|PERF/", {})
add_cmd("Todo", "botright silent! vimgrep /\\v\\CTODO|FIXME|HACK|PERF/ *<CR>", {})

add_cmd("CursorNodes", function()
    local node = require("nvim-treesitter.ts_utils").get_node_at_cursor()
    while node do
        dump(node:type())
        node = node:parent()
    end
end, {})

local function ShowLangTree(langtree, indent)
    local ts = vim.treesitter
    langtree = langtree or ts.get_parser()
    indent = indent or ""

    print(indent .. langtree:lang())
    for _, region in pairs(langtree:included_regions()) do
        if type(region[1]) == "table" then
            print(indent .. "  " .. vim.inspect(region))
        else
            print(indent .. "  " .. vim.inspect({ region[1]:range() }))
        end
    end
    for lang, child in pairs(langtree._children) do
        ShowLangTree(child, indent .. "  ")
    end
end

add_cmd("LangTree", function()
    ShowLangTree()
end, {})

add_cmd("ReloadModule", function(args)
    require("plenary.reload").reload_module(args)
end, { nargs = 1 })

add_cmd("ClearUndo", function()
    local old = vim.opt.undolevels
    vim.opt.undolevels = -1
    vim.cmd([[exe "normal a \<BS>\<Esc>"]])
    vim.opt.undolevels = old
end, {})

vim.cmd("command! -nargs=+ -complete=file Grep " .. "lua vim.api.nvim_exec([[grep! <args> | redraw! | copen]], true)")
vim.cmd("command! -nargs=+ -complete=file LGrep " .. "lua vim.api.nvim_exec([[lgrep! <args> | redraw! | lopen]], true)")
