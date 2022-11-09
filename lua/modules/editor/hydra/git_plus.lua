local Hydra = require("hydra")
local loader = require("packer").loader
local gitrepo = vim.fn.isdirectory(".git/index")
local cmd = require("hydra.keymap-util").cmd

if gitrepo then
    local hint = [[
 ^^^^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▕ ▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^^^^
 ^^^^                     GH command                   ^^^^
 ^^^^                                                  ^^^^
 ^^^^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▕ ▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^^^^
                     _cc_ : GHCloseCommit
                     _co_ : GHPopOutCommit
  _E_ : GHExpandCommit           _O_ : GHOpenToCommit
  _R_ : GHRefreshComments        _C_ : GhCollapseCommit
  _tt_ : GHToggleThreads         _tc_ : GHCreateThread
                     _tn_ : GHNextThread
  _po_ : GHOpenPR                _re_ : GHExpandReview
  _pc_ : GHClosePR               _rs_ : GHSubmitReview
  _pr_ : GHRefreshPR             _rd_ : GHDeleteReview
  _pO_ : GHOpenToPR              _rc_ : GHCloseReview
  _pP_ : GHPopOutPR              _rS_ : GHStartReview
  _pn_ : GHPRDetails             _rp_ : GHPreviewIssue
  _pC_ : GHCollapsePR            _la_ : GHADDLabel
]]
    Hydra({
        name = "Git Mode",
        hint = hint,
        config = {
            hint = {
                position = "middle-right",
                border = lambda.style.border.type_0,
            },
            timeout = false,
            invoke_on_body = true,
        },
        mode = { "n", "x" },
        body = "<leader>H",
        heads = {
            { "cc", cmd("GHCloseCommit"), { exit = false, silent = true } },
            { "co", cmd("GHPopOutCommit"), { exit = true, silent = true } },
            { "E", cmd("GHExpandCommit"), { exit = true, silent = true } },
            { "R", cmd("GHRefreshComments"), { exit = true, silent = true } },
            { "tt", cmd("GHToggleThreads"), { exit = true, silent = true } },
            { "O", cmd("GHOpenToCommit"), { exit = true, silent = true } },
            { "C", cmd("GhCollapseCommit"), { exit = true, silent = true } },
            { "tc", cmd("GHCreateThread"), { exit = true, silent = true } },
            { "tn", cmd("GHNextThread"), { exit = true, silent = true } },

            { "po", cmd("GHOpenPR"), { exit = true, silent = true } },
            { "pc", cmd("GHClosePR"), { exit = true, silent = true } },
            { "pr", cmd("GHRefreshPR"), { exit = true, silent = true } },
            { "pO", cmd("GHOpenToPR"), { exit = true, silent = true } },
            { "pP", cmd("GHPopOutPR"), { exit = true, silent = true } },
            { "pn", cmd("GHPRDetails"), { exit = true, silent = true } },
            { "pC", cmd("GHCollapsePR"), { exit = true, silent = true } },

            { "re", cmd("GHExpandReview"), { exit = true, silent = true } },
            { "rs", cmd("GHSubmitReview"), { exit = true, silent = true } },
            { "rd", cmd("GHDeleteReview"), { exit = true, silent = true } },
            { "rc", cmd("GHCloseReview"), { exit = true, silent = true } },
            { "rS", cmd("GHStartReview"), { exit = true, silent = true } },
            { "rp", cmd("GHPreviewIssue"), { exit = true, silent = true } },
            { "la", cmd("GHADDLabel"), { exit = true, silent = true } },
            { "<Esc>", nil, { exit = true, desc = false } },
        },
    })
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
