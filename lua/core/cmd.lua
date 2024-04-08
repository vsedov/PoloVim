local api, fn, fs = vim.api, vim.fn, vim.fs
local uv = vim.loop
local fmt = string.format

-----------------------------------------------------------------------------//
-- Autoresize
-----------------------------------------------------------------------------//
-- Auto resize Vim splits to active split to 70% -
-- https://stackoverflow.com/questions/11634804/vim-auto-resize-focused-window

lambda.command("DebugOpen", function()
    require("modules.lang.dap").prepare()
end, { force = true })

lambda.command("Hashbang", function()
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

lambda.command("Tags", function()
    vim.cmd(
        [[!ctags -R -I EXTERN -I INIT --exclude='build*' --exclude='.vim-src/**' --exclude='node_modules/**' --exclude='venv/**' --exclude='**/site-packages/**' --exclude='data/**' --exclude='dist/**' --exclude='notebooks/**' --exclude='Notebooks/**' --exclude='*graphhopper_data/*.json' --exclude='*graphhopper/*.json' --exclude='*.json' --exclude='qgis/**' *]]
    )
end, { force = true })

lambda.command("ColourScheme", function()
    require("utils.telescope").colorscheme()
end, { force = true })

lambda.command("Diagnostics", function()
    vim.cmd("silent lmake! %")
    if #vim.fn.getloclist(0) == 0 then
        vim.cmd("lopen")
    else
        vim.cmd("lclose")
    end
end, {
    force = true,
})
lambda.command("Format", "silent normal! mxgggqG`x<CR>", {
    force = true,
})

-- Adjust Spacing:
lambda.command("Spaces", function(args)
    local wv = fn.winsaveview()
    vim.opt_local.expandtab = true
    vim.cmd("silent execute '%!expand -it" .. args.args .. "'")
    fn.winrestview(wv)
    vim.cmd("setlocal ts? sw? sts? et?")
end, {
    force = true,
    nargs = 1,
})
lambda.command("Tabs", function(args)
    local wv = vim.fn.winsaveview()
    vim.opt_local.expandtab = false
    vim.cmd("silent execute '%!unexpand -t" .. args.args .. "'")
    vim.fn.winrestview(wv)
    vim.cmd("setlocal ts? sw? sts? et?")
end, {
    force = true,
    nargs = 1,
})

lambda.command("NvimEditInit", function(args)
    vim.cmd("split | edit $MYVIMRC")
end, {
    force = true,
    nargs = "*",
})
lambda.command("NvimSourceInit", function(args)
    vim.cmd("luafile $MYVIMRC")
end, {
    force = true,
    nargs = "*",
})
vim.cmd([[command! -nargs=+ F execute 'silent grep!' <q-args> | cw | redraw!]])

lambda.command("CursorNodes", function()
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

lambda.command("LangTree", ShowLangTree, {})

lambda.command("ReloadModule", function(args)
    require("plenary.reload").reload_module(args)
end, { nargs = 1 })

lambda.command("ClearUndo", function()
    local old = vim.opt.undolevels
    vim.opt.undolevels = -1
    vim.cmd([[exe "normal a \<BS>\<Esc>"]])
    vim.opt.undolevels = old
end, {})

local function read_file(file, line_handler)
    for line in io.lines(file) do
        line_handler(line)
    end
end

lambda.command("DotEnv", function()
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

lambda.command("LspSagaToggle", function()
    lambda.config.use_saga_diagnostic_jump = not lambda.config.use_saga_diagnostic_jump
end, { force = true })

lambda.command("NeorgAutoCommitToggle", function()
    lambda.config.neorg_auto_commit = not lambda.config.neorg_auto_commit
end, { force = true })

lambda.command("ToggleSaveOnExit", function()
    lambda.config.save_clipboard_on_exit = not lambda.config.save_clipboard_on_exit
end, { force = true })

lambda.command("StartCoffee", function()
    require("utils.plugins.coffee")
end, { force = true })

lambda.command("CopilotEnable", function()
    lambda.config.sell_your_soul = true

    vim.cmd([[Copilot enable]])
end, { force = true })

lambda.command("PullCustom", function()
    require("utils.plugins.git_pull_personal")()
end, { force = true })

lambda.command("Reverse", "<line1>,<line2>g/^/m<line1>-1", {
    range = "%",
    bar = true,
})

lambda.command("DiagnosticGetAll", function()
    vim.diagnostic.get()
end, { desc = "Get all the available diagnostics" })
lambda.command("DiagnosticGetNext", function()
    vim.diagnostic.get_next()
end, { desc = "Get the next diagnostic" })
lambda.command("DiagnosticGetPrev", function()
    vim.diagnostic.get_prev()
end, { desc = "Get the previous diagnostic" })

-- Goto diagnostic
lambda.command("DiagnosticGotoNext", function()
    vim.diagnostic.goto_next()
end, { desc = "Go to the next diagnostic" })
lambda.command("DiagnosticGotoPrev", function()
    vim.diagnostic.goto_prev()
end, { desc = "Go to the previous diagnostic" })

-- Location list
lambda.command("DiagnosticPopulateLocList", function()
    vim.diagnostic.set_loclist({ open_loclist = false })
end, { desc = "Populate the location list with the available diagnostics" })
lambda.command("LeapJumpCommands", function()
    local hints = {
        ["ca[r][R]b"] = "ca[r][R]b<leap> |Change around remote block",
        zfarp = "zfarp<leap> | Delete/fold/comment/etc. paragraphs without leaving your position",
        yaRp = "yaRp<leap> | Clone text object from another window and self",
        cimw = "cimw<leap>[correction] | fix typo",
        drr = "drr<leap> | work on distant lines",
        y3rr = "y3rr<leap> | yank 3 lines sam as 3yy",
        ["yrr or yRR"] = "yrr<leap> Line yank",
        ["ymm or yMM"] = "ymm<leap> Line Yank",
        defaults = [[
'iw', 'iW', 'is', 'ip', 'i[', 'i]', 'i(', 'i)', 'ib',
'i>', 'i<', 'it', 'i{', 'i}', 'iB', 'i"', 'i\'', 'i`',
'aw', 'aW', 'as', 'ap', 'a[', 'a]', 'a(', 'a)', 'ab',
'a>', 'a<', 'at', 'a{', 'a}', 'aB', 'a"', 'a\'', 'a`',
        ]],
    }

    local str = "" .. "\n"
    for k, v in pairs(hints) do
        str = str .. fmt("**%s** - `%s`" .. "\n", k, v)
    end

    vim.notify(str, "info", {
        title = "Leap Spooky binds",
        on_open = function(win)
            local buf = api.nvim_win_get_buf(win)
            if not api.nvim_buf_is_valid(buf) then
                return
            end
            api.nvim_buf_set_option(buf, "filetype", "markdown")
        end,
        timeout = 10000,
    })
end, {})

-- source https://superuser.com/a/540519
-- write the visual selection to the filename passed in as a command argument then delete the
-- selection placing into the black hole register
lambda.command("MoveWrite", [[<line1>,<line2>write<bang> <args> | <line1>,<line2>delete _]], {
    nargs = 1,
    bang = true,
    range = true,
    complete = "file",
})
lambda.command("MoveAppend", [[<line1>,<line2>write<bang> >> <args> | <line1>,<line2>delete _]], {
    nargs = 1,
    bang = true,
    range = true,
    complete = "file",
})
lambda.command("TreeInspect", function()
    vim.treesitter.show_tree()
end)
lambda.command("Todo", [[noautocmd silent! grep! 'TODO\|FIXME\|BUG\|HACK' | copen]])

lambda.command("Vimrc", function(opts)
    if opts.args == "" then
        vim.cmd("edit $MYVIMRC")
    else
        local path = vim.fs.find({ opts.args .. ".lua" }, {
            path = vim.fn.stdpath("config") .. "/lua",
        })[1]

        if not path then
            vim.api.nvim_err_writeln(string.format("[Vimrc]: File %s.lua not found.", opts.args))
            return
        end
        vim.cmd("edit " .. path)
    end

    vim.cmd("lcd " .. vim.fn.stdpath("config"))
end, {
    nargs = "?",
    complete = function(line)
        local paths = vim.fn.globpath(vim.fn.stdpath("config") .. "/lua", "**/*.lua")
        local files = {}
        for file in paths:gmatch("([^\n]+)") do
            table.insert(files, file:match("^.+/(.+)%."))
        end

        return vim.tbl_filter(function(value)
            return vim.startswith(value, line)
        end, files)
    end,
})

vim.cmd([[ command! NeorgStart execute 'tabe ~/neorg/index.norg' ]])

vim.cmd("imap <C-V> <C-R>*")
vim.cmd('vmap <LeftRelease> "*ygv')

lambda.command("LOC", function(_)
    local bufnr = api.nvim_get_current_buf()
    local ft = vim.bo[bufnr].ft
    vim.cmd.lcd(fn.expand("%:p:h"))
    vim.cmd(("!tokei -t %s %%"):format(ft))
end, { nargs = 0, desc = "Tokei current file" })

lambda.command("Exrc", function()
    local cwd = fn.getcwd()
    local p1, p2 = ("%s/.nvim.lua"):format(cwd), ("%s/.nvimrc"):format(cwd)
    local path = uv.fs_stat(p1) and p1 or uv.fs_stat(p2) and p2
    if not path then
        local _, err = io.open(p1, "w")
        assert(err == nil, err)
        path = p1
    end
    if not path then
        return
    end
    local ok, err = pcall(vim.cmd.edit, path)
    if not ok then
        vim.notify(err, "error", { title = "Exrc Opener" })
    end
end)

lambda.command("Cd", function()
    vim.cmd([[tcd %:h]])
    vim.notify("Changed directory to " .. fn.getcwd(), "info", { title = "Cd" })
end, { force = true })

lambda.command("Bonly", function()
    vim.cmd([[.+,$bwipeout]])
end, { force = true })

lambda.command("Squeeze", function()
    vim.cmd([[s/\v(\n\n)\n+/\1/e]])
end, { force = true })

lambda.command("DiffOrig", function()
    vim.cmd([[vert new | set bt=nofile | r ++edit | wincmd p | diffthis]])
end, { force = true })

lambda.command("Stylua", function()
    vim.cmd([[silent! write !stylua --search-parent-directories %]])
end, { force = true })

lambda.command("TodoLocal", "botright silent! lvimgrep /\\v\\CTODO|FIXME|HACK|PERF/", {})
lambda.command("Todo", "botright silent! vimgrep /\\v\\CTODO|FIXME|HACK|PERF/ *<CR>", {})
lambda.command("NorgSpec", function()
    if vim.loop.fs_stat("./specs.norg") then
        vim.fn.delete("./specs.norg")
    end
    vim.fn.system({
        "curl",
        "https://raw.githubusercontent.com/nvim-neorg/norg-specs/main/1.0-specification.norg",
        "-o",
        "./specs.norg",
    })
    vim.cmd.e("./specs.norg")
    vim.keymap.set("n", "q", function()
        vim.cmd.bdelete()
        if vim.loop.fs_stat("./specs.norg") then
            vim.fn.delete("./specs.norg")
        end
    end, { buffer = true })
end, { desc = "View Norg Specification" })
