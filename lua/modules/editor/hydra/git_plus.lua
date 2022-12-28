local Hydra = require("hydra")
local gitrepo = vim.fn.isdirectory(".git/index")
local cmd = require("hydra.keymap-util").cmd

if gitrepo then
    local octo_hint = [[
^ Navigation
^ _g_: Gists
^ _i_: Issues
^ _p_: Pull Requests
^ _r_: Repos
^ _s_: Search
^ _C_: Card
^ _l_: label
^ _t_: thread
^ _q_: Quit
]]
    Hydra({
        name = "Octo",
        mode = "n",
        body = "<leader>o",
        hint = octo_hint,
        config = {
            hint = {
                position = "middle-right",
                border = lambda.style.border.type_0,
            },
            timeout = false,
            invoke_on_body = true,
        },
        heads = {
            {
                "g",
                cmd("Octo gist"),
                { exit = false },
            },
            {
                "i",
                cmd("Octo issue"),
                { exit = true },
            },
            {
                "p",
                cmd("Octo pr"),
                { exit = true },
            },
            {
                "r",
                cmd("Octo repo"),
                { exit = true },
            },
            {
                "s",
                cmd("Octo Search"),
                { exit = true },
            },

            {
                "C",
                cmd("Octo card"),
                { exit = true },
            },

            {
                "l",
                cmd("Octo label"),
                { exit = true },
            },

            {
                "t",
                cmd("Octo thread"),
                { exit = true },
            },

            { "q", nil, { exit = true } },
        },
    })
end
