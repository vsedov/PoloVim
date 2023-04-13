local Hydra = require("hydra")
local cmd = require("hydra.keymap-util").cmd

local fixer = function()
    local current_path = vim.fn.expand("%:p")
    local current_dir = vim.fn.expand("%:p:h")
    local current_file = vim.fn.expand("%:t")
    local ruff_cmd = "cd " .. current_dir .. " && ruff --fix " .. current_file
    vim.fn.system(ruff_cmd)
end

local python_hints = [[
^ ^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^ ^
^ ^        Documentation           ^ ^
^ ^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^ ^
^ ^ _a_ : CopyReferenceDotted      ^ ^
^ ^ _s_ : CopyReferencePytest      ^ ^
^ ^ _d_ : CopyReferenceImport      ^ ^
^ ^                                ^ ^
^ ^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^ ^
^ ^        Poetry poetry           ^ ^
^ ^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^ ^
^ ^ _i_ : inputDependency          ^ ^
^ ^ _D_ : showPackage              ^ ^
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
^ ^          Nice to Have          ^ ^
^ ^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^ ^
^ ^ _<enter>_ : Ruff Fixer         ^ ^
^ ^ _e_ : VenvFind                 ^ ^
^ ^ _E_ : GetVenv                  ^ ^
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
    body = "<leader>p",
    heads = {
        { "<enter>", fixer, { nowait = true } },

        {
            "a",
            cmd("PythonCopyReferenceDotted"),
            { nowait = true, silent = true, desc = "Python Dotted", exit = true },
        },
        {
            "s",
            cmd("PythonCopyReferencePytest"),
            { nowait = true, silent = true, desc = "Python Pytest", exit = true },
        },
        {
            "d",
            cmd("PythonCopyReferenceImport"),
            { nowait = true, silent = true, desc = "Python import", exit = true },
        },

        { "I", cmd("lua require('py.ipython').toggleIPython()"), { exit = true } },
        { "S", cmd("lua require('py.ipython').sendObjectsToIPython()"), { exit = true } },
        { "O", cmd("lua require('py.ipython').sendHighlightsToIPython()"), { exit = true } },
        { "B", cmd("lua require('py.ipython').sendIPythonToBuffer()"), { exit = true } },

        { "t", cmd("lua require('py.pytest').launchPytest()"), { exit = true } },
        { "r", cmd("lua require('py.pytest').showPytestResult()"), { exit = true } },

        { "i", cmd("lua require('py.poetry').inputDependency()"), { exit = true } },
        { "D", cmd("lua require('py.poetry').showPackage()"), { exit = true } },

        { "w", cmd("lua require('py.taskipy').runTasks()"), { exit = true } },
        { "W", cmd("lua require('py.taskipy').runTaskInput()"), { exit = true } },

        { "e", cmd("VenvFind"), { exit = true } },
        { "E", cmd("GetVenv"), { exit = true } },

        { "<Esc>", nil, { nowait = true, exit = true, desc = false } },
    },
}
