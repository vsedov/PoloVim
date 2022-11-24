local Hydra = require("hydra")
local cmd = require("hydra.keymap-util").cmd

local fixer = function()
    -- vim.cmd[[ls]]
    -- Run ruff --fix current file
    local current_path = vim.fn.expand("%:p")
    local current_dir = vim.fn.expand("%:p:h")
    local current_file = vim.fn.expand("%:t")
    local ruff_cmd = "cd " .. current_dir .. " && ruff --fix " .. current_file
    vim.fn.system(ruff_cmd)
end

local ts_utils = require("nvim-treesitter.ts_utils")

local toggle_fstring = function()
    local winnr = 0
    local cursor = vim.api.nvim_win_get_cursor(winnr)
    local node = ts_utils.get_node_at_cursor()

    while (node ~= nil) and (node:type() ~= "string") do
        node = node:parent()
    end
    if node == nil then
        print("f-string: not in string node :(")
        return
    end

    local srow, scol, ecol, erow = ts_utils.get_vim_range({ node:range() })
    vim.fn.setcursorcharpos(srow, scol)
    local char = vim.api.nvim_get_current_line():sub(scol, scol)
    local is_fstring = (char == "f")

    if is_fstring then
        vim.cmd("normal mzx")
        -- if cursor is in the same line as text change
        if srow == cursor[1] then
            cursor[2] = cursor[2] - 1 -- negative offset to cursor
        end
    else
        vim.cmd("normal mzif")
        -- if cursor is in the same line as text change
        if srow == cursor[1] then
            cursor[2] = cursor[2] + 1 -- positive offset to cursor
        end
    end
    vim.api.nvim_win_set_cursor(winnr, cursor)
end

local navy = function()
    current_path = vim.fn.expand("%:p")
    vim.fn.system("cd " .. current_path)
    vim.cmd([[NayvyImports]])
end

local python_hints = [[
^ ^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^ ^
^ ^          Nice to Have          ^ ^
^ ^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^ ^
^ ^ _<enter>_ : Ruff Fixer         ^ ^
^ ^ _i_ : Navy                     ^ ^
^ ^ _f_ : f-string                 ^ ^
^ ^ _e_ : VenvFind                 ^ ^
^ ^ _E_ : GetVenv                  ^ ^
^ ^                                ^ ^
^ ^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^ ^
^ ^        Poetry poetry           ^ ^
^ ^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^ ^
^ ^ _a_ : inputDependency          ^ ^
^ ^ _d_ : showPackage              ^ ^
^ ^                                ^ ^
^ ^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^ ^
^ ^        Poetry Taskipy          ^ ^
^ ^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^ ^
^ ^ _w_ : runTasks                 ^ ^
^ ^ _W_ : runTaskInput             ^ ^
^ ^                                ^ ^
^ ^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^ ^
^ ^        Poetry Pytests          ^ ^
^ ^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^ ^
^ ^ _t_ : launchPytest             ^ ^
^ ^ _r_ : showPytestResult         ^ ^
^ ^                                ^ ^
^ ^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^ ^
^ ^        Poetry IPython          ^ ^
^ ^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^ ^
^ ^ _I_ : toggleIPython            ^ ^
^ ^ _S_ : sendObjectsToIPython     ^ ^
^ ^ _O_ : f-sendHighlightsToIPython^ ^
^ ^ _B_ : f-sendIPythonToBuffer    ^ ^
^ ^                                ^ ^
^ ^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^ ^
^ ^ <Esc> : Exit                   ^ ^
]]
local python_hints = {
    name = "python",
    hint = python_hints,

    config = {
        color = "pink",
        invoke_on_body = true,
        hint = {
            position = "bottom-right",
            border = lambda.style.border.type_0,
        },
    },

    mode = { "n", "x" },
    body = ";l",
    heads = {
        { "<enter>", fixer, { nowait = true } },
        { "i", navy, { exit = true } },
        { "f", toggle_fstring, { exit = true } },

        { "I", cmd("lua require('py.ipython').toggleIPython()"), { exit = true } },
        { "S", cmd("lua require('py.ipython').sendObjectsToIPython()"), { exit = true } },
        { "O", cmd("lua require('py.ipython').sendHighlightsToIPython()"), { exit = true } },
        { "B", cmd("lua require('py.ipython').sendIPythonToBuffer()"), { exit = true } },

        { "t", cmd("lua require('py.pytest').launchPytest()"), { exit = true } },
        { "r", cmd("lua require('py.pytest').showPytestResult()"), { exit = true } },

        { "a", cmd("lua require('py.poetry').inputDependency()"), { exit = true } },
        { "d", cmd("lua require('py.poetry').showPackage()"), { exit = true } },

        { "w", cmd("lua require('py.taskipy').runTasks()"), { exit = true } },
        { "W", cmd("lua require('py.taskipy').runTaskInput()"), { exit = true } },

        { "e", cmd("VenvFind"), { exit = true } },
        { "E", cmd("GetVenv"), { exit = true } },

        { "<Esc>", nil, { nowait = true, exit = true, desc = false } },
    },
}

magma = [[
^ ^ _i_: MagmaInit       ^ ^
^ ^ _v_: MagmaEvalVisual ^ ^
^ ^ _R_: MagmaReevalCell ^ ^
^ ^ _o_: MagmaShowOutput ^ ^
^ ^ _O_: MagmaEnterOutput^ ^
^ ^ _c_: MagmaInterrupt  ^ ^
^ ^ _r_: MagmaRestart    ^ ^
^ ^ _d_: MagmaDelete     ^ ^
^ ^ _q_: MagmaDeinit     ^ ^
]]

local magma = {
    name = "magma",
    hint = magma,
    config = {
        color = "pink",
        invoke_on_body = true,
        hint = {
            position = "bottom-right",
            border = lambda.style.border.type_0,
        },
    },
    mode = { "n", "x" },
    body = "<leader>I",
    heads = {

        { "i", cmd("MagmaInit Python3"), { exit = true } },
        { "v", cmd("MagmaEvaluateVisual"), { exit = true } },
        { "R", cmd("MagmaReevaluateCell"), { exit = true } },
        { "o", cmd("MagmaShowOutput"), { exit = true } },
        { "O", cmd("MagmaEnterOutput"), exit = true },
        { "c", cmd("MagmaInterrupt"), exit = true },
        { "r", cmd("MagmaRestart"), exit = true },
        { "d", cmd("MagmaDelete"), exit = true },
        { "q", cmd("MagmaDeinit"), exit = true },

        { "<Esc>", nil, { nowait = true, exit = true, desc = false } },
    },
}
Hydra(python_hints)
Hydra(magma)
