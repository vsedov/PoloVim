local add_cmd = vim.api.nvim_create_user_command
local api, fn, fs = vim.api, vim.fn, vim.fs
local fmt = string.format

add_cmd("DebugOpen", function()
    require("modules.lang.dap").prepare()
end, { force = true })

add_cmd("HarpoonClear", function()
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

    local extension = fn.expand("%:e")

    if shells[extension] then
        local hb = shells[extension]
        hb[#hb + 1] = ""
        api.nvim_buf_set_lines(0, 0, 0, false, hb)
        api.nvim_create_autocmd("BufWritePost", {
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

add_cmd("ColourScheme", function()
    require("utils.telescope").colorscheme()
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
    local wv = fn.winsaveview()
    vim.opt_local.expandtab = true
    vim.cmd("silent execute '%!expand -it" .. args.args .. "'")
    fn.winrestview(wv)
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
vim.cmd([[command! -nargs=+ F execute 'silent grep!' <q-args> | cw | redraw!]])

add_cmd("CursorNodes", function()
    local node = require("nvim-treesitter.ts_utils").get_node_at_cursor()
    while node do
        lambda.dump(node:type())
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
    vim.cmd("Neorg export to-file " .. fn.expand("%:t:r") .. ".md")
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
ini_config:gsub("MNAME", fn.expand("%:p:h:t"))
local Path = require("plenary.path")
local scan = require("plenary.scandir")

local function findPoetry()
    local cwd = fn.getcwd()
    local current_path = vim.api.nvim_exec(":echo @%", 1)

    local parents = Path:new(current_path):parents()
    for _, parent in pairs(parents) do
        local files = scan.scan_dir(parent, { hidden = false, depth = 1 })
        for _, file in pairs(files) do
            if file == parent .. "/" .. "pyproject.toml" then
                local file_write = io.open("tox.ini", "w")
                file_write:write(ini_config:gsub("MNAME", fn.expand("%:p:h:t")))
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

local function read_file(file, line_handler)
    for line in io.lines(file) do
        line_handler(line)
    end
end

add_cmd("DotEnv", function()
    local files = fs.find(".env", {
        upward = true,
        stop = fn.fnamemodify(fn.getcwd(), ":p:h:h"),
        path = fn.expand("%:p:h"),
    })
    if vim.tbl_isempty(files) then
        return
    end
    local filename = files[1]
    local lines = {}
    read_file(filename, function(line)
        if #line > 0 then
            table.insert(lines, line)
        end
        if not vim.startswith(line, "#") then
            local name, value = unpack(vim.split(line, "="))
            fn.setenv(name, value)
        end
    end)
    local markdown = table.concat(vim.tbl_flatten({ "", "```sh", lines, "```", "" }), "\n")
    vim.notify(fmt("Read **%s**\n", filename) .. markdown, "info", {
        title = "Nvim Env",
        on_open = function(win)
            local buf = api.nvim_win_get_buf(win)
            if not api.nvim_buf_is_valid(buf) then
                return
            end
            api.nvim_buf_set_option(buf, "filetype", "markdown")
        end,
    })
end, {})

-----------------------------------------------------------------------------//
-- Autoresize
-----------------------------------------------------------------------------//
-- Auto resize Vim splits to active split to 70% -
-- https://stackoverflow.com/questions/11634804/vim-auto-resize-focused-window

local auto_resize = function()
    local auto_resize_on = false
    return function(args)
        if not auto_resize_on then
            local factor = args and tonumber(args) or 70
            local fraction = factor / 10
            -- NOTE: mutating &winheight/&winwidth are key to how
            -- this functionality works, the API fn equivalents do
            -- not work the same way
            vim.cmd(fmt("let &winheight=&lines * %d / 10 ", fraction))
            vim.cmd(fmt("let &winwidth=&columns * %d / 10 ", fraction))
            auto_resize_on = true
            vim.notify("Auto resize ON")
        else
            vim.cmd([[
      let &winheight=30
      let &winwidth=30
      wincmd =
      ]])
            auto_resize_on = false
            vim.notify("Auto resize OFF")
        end
    end
end

add_cmd("AutoResize", auto_resize(), { nargs = "?" })

add_cmd("LspSagaToggle", function()
    lambda.config.use_saga_diagnostic_jump = not lambda.config.use_saga_diagnostic_jump
end, { force = true })

add_cmd("NeorgAutoCommitToggle", function()
    lambda.config.neorg_auto_commit = not lambda.config.neorg_auto_commit
end, { force = true })

add_cmd("ToggleSaveOnExit", function()
    lambda.config.save_clipboard_on_exit = not lambda.config.save_clipboard_on_exit
end, { force = true })

add_cmd("StartCoffee", function()
    require("utils.plugins.coffee")
end, { force = true })

-- vim.diagnostic.setqflist()
add_cmd("CopilotUnload", function()
    if lambda.config.sell_your_soul then
        vim.cmd([[Copilot disable]])
        lambda.dynamic_unload("_copilot", false)
        lambda.config.sell_your_soul = false
    else
        vim.notify("Copilot is not loaded")
    end
end, { force = true })

add_cmd("CopilotEnable", function()
    lambda.config.sell_your_soul = true

    vim.cmd([[Copilot enable]])
end, { force = true })

add_cmd("PullCustom", function()
    require("utils.plugins.git_pull_personal")()
end, { force = true })

add_cmd("Reverse", "<line1>,<line2>g/^/m<line1>-1", {
    range = "%",
    bar = true,
})

add_cmd("DiagnosticGetAll", function()
    vim.diagnostic.get()
end, { desc = "Get all the available diagnostics" })
add_cmd("DiagnosticGetNext", function()
    vim.diagnostic.get_next()
end, { desc = "Get the next diagnostic" })
add_cmd("DiagnosticGetPrev", function()
    vim.diagnostic.get_prev()
end, { desc = "Get the previous diagnostic" })

-- Goto diagnostic
add_cmd("DiagnosticGotoNext", function()
    vim.diagnostic.goto_next()
end, { desc = "Go to the next diagnostic" })
add_cmd("DiagnosticGotoPrev", function()
    vim.diagnostic.goto_prev()
end, { desc = "Go to the previous diagnostic" })

-- Location list
add_cmd("DiagnosticPopulateLocList", function()
    vim.diagnostic.set_loclist({ open_loclist = false })
end, { desc = "Populate the location list with the available diagnostics" })

add_cmd("ShowHydraBinds", function()
    binds = {
        buffer = "<leader>b",
        git = "<leader>h",
        harpoon = "<CR>",
        parenth = "H",
        treesitter = "\\<leader>",
        runner = ";r",
        docs = "<leader>d",
        tele = "<leader>f",
        swap = "<c-w>]",
        windows = "<c-w>[",
        grapple = "<leader>i",
        dap = "<localleader>b",
        extra_search = ";A",
        lsp = "\\l",
        neotest = "<leader>u",
        refactoring = "<leader>r",
        text_case = "gaa gae",
        word_motion = "<localleader>w",
        subsitute = "L",
    }

    -- local sorted_binds = {}
    -- for k, v in pairs(binds) do
    --     table.insert(sorted_binds, { k, v })
    -- end
    -- table.sort(binds, function(a, b)
    --     return a[1] < b[1]
    -- end)
    -- local str = "" .. "\n"
    -- for _, v in ipairs(sorted_binds) do
    --     str = str .. fmt("**%s** - `%s`" .. "\n", v[1], v[2])
    -- end

    -- Show them in that order
    local str = "" .. "\n"
    for k, v in pairs(binds) do
        str = str .. fmt("**%s** - `%s`" .. "\n", k, v)
    end

    vim.notify(str, "info", {
        title = "Hydra binds",
        on_open = function(win)
            local buf = api.nvim_win_get_buf(win)
            if not api.nvim_buf_is_valid(buf) then
                return
            end
            api.nvim_buf_set_option(buf, "filetype", "markdown")
        end,
        timeout = 30000,
    })
end, {})
