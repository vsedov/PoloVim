local add_cmd = vim.api.nvim_create_user_command

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

add_cmd("LangTree", ShowLangTree, {})

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

local ini_config = [[
[tox]
skipsdist = true
envlist =  py310,pre-commit

[testenv]
whitelist_externals = poetry
setenv = PYTHONPATH = ""
commands =
    poetry install
    poetry run task test

[testenv:generate-badge]
whitelist_externals =
    poetry
    interrogate
commands =
    poetry install
    interrogate --config {toxinidir}/pyproject.toml --generate-badge {toxinidir}/docs/_static

[testenv:pre-commit]
deps = pre-commit
whitelist_externals = pre-commit
commands =
    pre-commit run --all-files

[pytest]
addopts = -v --cov=interrogate --cov-report=xml:coverage.xml --cov-report=term-missing
testpaths = tests

[flake8]
max-line-length=120
docstring-convention=all
import-order-style=pycharm
application_import_names= MNAME,tests
exclude=.cache,.venv,.git,constants.py
ignore=
    B311,W503,E226,S311,T000,E731
    # Missing Docstrings
    D100,D104,D105,D107,
    # Docstring Whitespace
    D203,D212,D214,D215,D107
    # Docstring Quotes
    D301,D302,
    # Docstring Content
    D400,D401,D402,D404,D405,D406,D407,D408,D409,D410,D411,D412,D413,D414,D416,D417,P103,E124
    # Type Annotations
    ANN002,ANN003,ANN101,ANN102,ANN204,ANN206
per-file-ignores=tests/*:D,ANN]]
ini_config:gsub("MNAME", vim.fn.expand("%:p:h:t"))
local Path = require("plenary.path")
local scan = require("plenary.scandir")

local function findPoetry()
    local cwd = vim.fn.getcwd()
    local current_path = vim.api.nvim_exec(":echo @%", 1)

    local parents = Path:new(current_path):parents()
    for _, parent in pairs(parents) do
        local files = scan.scan_dir(parent, { hidden = false, depth = 1 })
        for _, file in pairs(files) do
            if file == parent .. "/" .. "pyproject.toml" then
                local file_write = io.open("tox.ini", "w")
                file_write:write(ini_config:gsub("MNAME", vim.fn.expand("%:p:h:t")))
                file_write:close()
                return true
            end
        end

        if parent == cwd then
            break
        end
    end

    vim.notify("Poetry Environment Not Found", "error", { title = "py.nvim" })
end

add_cmd("ToxSetup", findPoetry, { force = true })