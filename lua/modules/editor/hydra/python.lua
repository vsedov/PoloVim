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
    body = ";a",
    heads = {
        { "<enter>", fixer, { nowait = true } },
        -- { "i", navy, { exit = true } },
        -- { "f", toggle_fstring, { exit = true } },

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

lambda.augroup("PythonHydra", {
    {
        event = "FileType",
        pattern = "python",
        command = function()
            Hydra(python_hints)
            Hydra(magma)
        end,
        once = true,
    },
})
