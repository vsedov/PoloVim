local bind = require("keymap.bind")
local map_cr = bind.map_cr
local map_cu = bind.map_cu
local map_cmd = bind.map_cmd
-- local map_args = bind.map_args
local add_cmd = vim.api.nvim_create_user_command
local loader = require("packer").loader
local K = {}

local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local keys = { --
    ["n|<Leader>r"] = map_cmd("v:lua.run_or_test()"):with_expr(),
    ["n|<F5>"] = map_cmd("v:lua.run_or_test(v:true)"):with_expr(),
    ["n|<F6>"] = map_cu("Jaq qf"):with_noremap():with_silent(),

    ["n|<Leader>di"] = map_cr("<cmd>lua require'dap.ui.variables'.hover()"):with_expr(),
    ["n|<Leader>dw"] = map_cr("<cmd>lua require'dap.ui.widgets'.hover()"):with_expr(), -- TODO: another key?
    ["v|<Leader>di"] = map_cr("<cmd>lua require'dap.ui.variables'.visual_hover()"):with_expr(),

    -- Plugin Vista
    ["n|<Leader>v]"] = map_cu("Vista!!"):with_noremap():with_silent(),
    -- tshit
    ["o|m"] = map_cmd(":<C-U>lua require('tsht').nodes()<CR>"):with_silent(),
    ["v|M"] = map_cmd(":<C-U>lua require('tsht').nodes()<CR>"):with_noremap():with_silent(),

    ["n|;a"] = map_cmd([[<cmd> lua require("harpoon.mark").add_file()<CR>]]):with_noremap(),
    ["n|;n"] = map_cmd([[<cmd> lua require("harpoon.mark").toggle_file()<CR>]]):with_noremap(),

    ["n|;1"] = map_cmd([[<cmd> lua require("harpoon.ui").nav_file(1)<CR>]]):with_noremap():with_silent(),
    ["n|;2"] = map_cmd([[<cmd> lua require("harpoon.ui").nav_file(2)<CR>]]):with_noremap():with_silent(),
    ["n|;3"] = map_cmd([[<cmd> lua require("harpoon.ui").nav_file(3)<CR>]]):with_noremap():with_silent(),
    ["n|;4"] = map_cmd([[<cmd> lua require("harpoon.ui").nav_file(4)<CR>]]):with_noremap():with_silent(),
    ["n|;5"] = map_cmd([[<cmd> lua require("harpoon.ui").nav_file(5)<CR>]]):with_noremap():with_silent(),
    ["n|;6"] = map_cmd([[<cmd> lua require("harpoon.ui").nav_file(6)<CR>]]):with_noremap():with_silent(),
    ["n|;7"] = map_cmd([[<cmd> lua require("harpoon.ui").nav_file(7)<CR>]]):with_noremap():with_silent(),
    ["n|;8"] = map_cmd([[<cmd> lua require("harpoon.ui").nav_file(8)<CR>]]):with_noremap():with_silent(),
    ["n|;9"] = map_cmd([[<cmd> lua require("harpoon.ui").nav_file(9)<CR>]]):with_noremap():with_silent(),

    ["n|;t"] = map_cmd([[Telescope harpoon marks]]):with_noremap():with_silent(),
    ["n|;;"] = map_cmd([[<cmd> lua require("harpoon.ui").toggle_quick_menu()<CR>]]):with_noremap():with_silent(),
    ["n|<Leader>n;"] = map_cmd([[<cmd> lua require('harpoon.cmd-ui').toggle_quick_menu()<Cr>]])
        :with_noremap()
        :with_silent(),

    --- Refactoring
    ["v|<Leader>re"] = map_cmd([[<Esc><Cmd>lua require('refactoring').refactor('Extract Function')<CR>]])
        :with_noremap()
        :with_silent()
        :with_expr(),
    ["v|<Leader>rf"] = map_cmd([[<Esc><Cmd>lua require('refactoring').refactor('Extract Function To File')<CR>]])
        :with_noremap()
        :with_silent()
        :with_expr(),
    ["v|<Leader>rv"] = map_cmd([[<Esc><Cmd>lua require('refactoring').refactor('Extract Variable')<CR>]])
        :with_noremap()
        :with_silent()
        :with_expr(),
    ["v|<Leader>ri"] = map_cmd([[<Esc><Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]])
        :with_noremap()
        :with_silent()
        :with_expr(),
    ["n|<Leader>ri"] = map_cmd([[<Esc><Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]])
        :with_noremap()
        :with_silent()
        :with_expr(),

    ["v|<Leader>rr"] = map_cmd([[<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>]]):with_noremap(),
    ["n|<Leader>rp"] = map_cmd([[<cmd>lua require('refactoring').debug.printf({below = false})<CR>]]):with_noremap(),

    ["v|<Leader>ro"] = map_cmd([[<cmd> lua require('refactoring').debug.print_var({})<CR>]]):with_noremap(),
    ["n|<Leader>rc"] = map_cmd([[<cmd> lua require('refactoring').debug.cleanup({})<CR>]]):with_noremap(),

    ["v|<Leader>gs"] = map_cmd("<cmd>lua require('utils.git').qf_add()<cr>"),
}

--
vim.cmd([[vnoremap  <leader>y  "+y]])
vim.cmd([[nnoremap  <leader>Y  "+yg_]])
-- vim.cmd([[vnoremap  <M-c>  "+y]])
-- vim.cmd([[nnoremap  <M-c>  "+yg_]])

vim.cmd([[vnoremap  <localleader>c  *+y]])
vim.cmd([[nnoremap  <localleader>c  *+yg_]])
-- No need to use local leader in insert mode
-- vim.cmd([[inoremap  <localleader>v <C-r>*]])

--
bind.nvim_load_mapping(keys)

_G.run_or_test = function(debug)
    local ft = vim.bo.filetype
    local fn = vim.fn.expand("%")
    fn = string.lower(fn)
    if fn == "[nvim-lua]" then
        if not packer_plugins["nvim-luadev"].loaded then
            loader("nvim-luadev")
        end
        return t("<Plug>(Luadev-Run)")
    end
    if ft == "lua" then
        local f = string.find(fn, "spec")
        if f == nil then
            -- let run lua test
            return t("<cmd>luafile %<CR>")
        end
        return t("<Plug>PlenaryTestFile")
    elseif ft == "go" then
        local f = string.find(fn, "test.go")
        if f == nil then
            -- let run lua test
            if debug then
                return t("<cmd>GoDebug <CR>")
            else
                return t("<cmd>GoRun <CR>")
            end
        end

        if debug then
            return t("<cmd>GoDebug nearest<CR>")
        else
            return t("<cmd>GoTestFile <CR>")
        end
    else
        return t("<cmd>Jaq<CR>")
    end
end

add_cmd("AbbrivGodMode", function()
    vim.cmd([[packadd vim-abbrev]])
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

add_cmd("NeorgToMd", function()
    -- File name without extension .
    vim.cmd("Neorg export to-file " .. vim.fn.expand("%:t:r") .. ".md")
end, { force = true })
