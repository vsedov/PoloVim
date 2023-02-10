local api, fn, fs = vim.api, vim.fn, vim.fs
local fmt = string.format
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

lambda.command("DebugOpen", function()
    require("modules.lang.dap").prepare()
end, { force = true })

lambda.command("HarpoonClear", function()
    require("harpoon.mark").clear_all()
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
lambda.command("TodoLocal", "botright silent! lvimgrep /\\v\\CTODO|FIXME|HACK|PERF/", {})
lambda.command("Todo", "botright silent! vimgrep /\\v\\CTODO|FIXME|HACK|PERF/ *<CR>", {})
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

lambda.command("NeorgToMd", function()
    vim.cmd("Neorg export to-file " .. fn.expand("%:t:r") .. ".md")
end, { force = true })

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

lambda.command("AutoResize", auto_resize(), { nargs = "?" })

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

-- vim.diagnostic.setqflist()
lambda.command("CopilotUnload", function()
    if lambda.config.sell_your_soul then
        vim.cmd([[Copilot disable]])
        lambda.dynamic_unload("_copilot", false)
        lambda.config.sell_your_soul = false
    else
        vim.notify("Copilot is not loaded")
    end
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

local fmt = string.format
local api, fn, fs = vim.api, vim.fn, vim.fs

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

lambda.command("ExtraHLToggle", function()
    lambda.config.better_ts_highlights = not lambda.config.better_ts_highlights
    require("nvim-treesitter.configs").setup({
        markid = { enable = lambda.config.better_ts_highlights },
    })
    vim.cmd([[bufdo! %]])
end, {})

vim.cmd("imap <C-V> <C-R>*")
vim.cmd('vmap <LeftRelease> "*ygv')

vim.cmd("imap <C-V> <C-R>*")
vim.cmd('vmap <LeftRelease> "*ygv')

function _G.toggle_tabline()
    local value = vim.api.nvim_get_option_value("showtabline", {})
    if value == 2 then
        value = 1
    else
        value = 2
    end
    vim.opt.showtabline = value
end
