local exit = { nil, { exit = true, desc = "EXIT" } }
local bracket = { "<cr>", "lc", "cc", "rc", "aa" }
local leader = "<leader>C"
--  ──────────────────────────────────────────────────────────────────────
-- local cbii= require("comment-box")
function data()
    return {
        ll = { label = "[L] Aligned Box With [L]", fn = require("comment-box").llbox },
        lc = { label = "[L] Aligned Box With [C]", fn = require("comment-box").lcbox },
        lr = { label = "[L] Aligned Box With [R]", fn = require("comment-box").lrbox },

        cl = { label = "[C] Box With [L]", fn = require("comment-box").clbox },
        cc = { label = "[C] Box With [C]", fn = require("comment-box").ccbox },
        cr = { label = "[C] Box With [R]", fn = require("comment-box").crbox },

        rl = { label = "[R] Aligned Box With [L]", fn = require("comment-box").rlbox },
        rc = { label = "[R] Aligned Box With [C]", fn = require("comment-box").rcbox },
        rr = { label = "[R] Aligned Box With [R] ", fn = require("comment-box").rrbox },

        aa = { label = "[L] Aligned adapted box", fn = require("comment-box").albox },
        ac = { label = "[C] Adapted Box", fn = require("comment-box").acbox },
        ar = { label = "[R] Aligned adapted box", fn = require("comment-box").arbox },

        L = { label = "[L] Line", fn = require("comment-box").line },
        C = { label = "[C] Centered Line", fn = require("comment-box").cline },
        R = { label = "[R] Right Aligned Line", fn = require("comment-box").rline },
    }
end
--
--  ╔══════════════════════════════════════╗
--  ║             BOXES & LINES            ║
--  ╚══════════════════════════════════════╝
--
local ascii_number_extraction = function(str)
    local number = string.match(str, "%d+")
    if number == nil then
        return 0
    end
    return tonumber(number)
end

local boxes = {
    [[
 1 - Rounded (Default)
 ╭──────────────────────────────────────╮
 │ Lorem ipsumdolor sit amet,           │
 │  consectetur adipiscing elit, sed    │
 │  do eiusmod tempor incididunt...     │
 ╰──────────────────────────────────────╯
]],
    [[
 2 - Classic
 ┌──────────────────────────────────────┐
 │ Lorem ipsumdolor sit amet,           │
 │  consectetur adipiscing elit, sed    │
 │  do eiusmod tempor incididunt...     │
 └──────────────────────────────────────┘
]],
    [[
 3 - Classic Heavy
 ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
 ┃ Lorem ipsumdolor sit amet,           ┃
 ┃  consectetur adipiscing elit, sed    ┃
 ┃  do eiusmod tempor incididunt...     ┃
 ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
]],
    [[
 4 - Dashed
 ┌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┐
 ╎ Lorem ipsumdolor sit amet,           ╎
 ╎  consectetur adipiscing elit, sed    ╎
 ╎  do eiusmod tempor incididunt...     ╎
 └╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┘
]],
    [[
 5 - Dashed Heavy
 ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
 ╏ Lorem ipsumdolor sit amet,           ╏
 ╏  consectetur adipiscing elit, sed    ╏
 ╏  do eiusmod tempor incididunt...     ╏
 ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛
]],

    [[
 6 - Mix Heavy/Light
┍━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┑
│ Lorem ipsumdolor sit amet,           │
│  consectetur adipiscing elit, sed    │
│  do eiusmod tempor incididunt...     │
┕━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┙
]],
    [[,
7 - Double
╔══════════════════════════════════════╗
║ Lorem ipsumdolor sit amet,           ║
║  consectetur adipiscing elit, sed    ║
║  do eiusmod tempor incididunt...     ║
╚══════════════════════════════════════╝
]],
    [[
8 - Mix Double/Single A
╒══════════════════════════════════════╕
│ Lorem ipsumdolor sit amet,           │
│  consectetur adipiscing elit, sed    │
│  do eiusmod tempor incididunt...     │
╘══════════════════════════════════════╛
]],

    [[
9 - Mix Double/Single B
╓──────────────────────────────────────╖
║ Lorem ipsumdolor sit amet,           ║
║  consectetur adipiscing elit, sed    ║
║  do eiusmod tempor incididunt...     ║
╙──────────────────────────────────────╜
    ]],
    [[
10 - ASCII
+--------------------------------------+
| Lorem ipsumdolor sit amet,           |
|  consectetur adipiscing elit, sed    |
|  do eiusmod tempor incididunt...     |
+--------------------------------------+
]],
    [[
11 - Quote A
▲
█ Lorem ipsumdolor sit amet,
█  consectetur adipiscing elit, sed
█  do eiusmod tempor incididunt...
▼
]],

    [[
12 - Quote B
┌
│ Lorem ipsumdolor sit amet,
│  consectetur adipiscing elit, sed
│  do eiusmod tempor incididunt...
└
]],

    [[
13 - Quote C
╓
║ Lorem ipsumdolor sit amet,
║  consectetur adipiscing elit, sed
║  do eiusmod tempor incididunt...
╙
]],

    [[
14 - Marked A
                                        ▲
    Lorem ipsumdolor sit amet,          █
    consectetur adipiscing elit, sed    █
    do eiusmod tempor incididunt...     █
                                        ▼
]],

    [[
15 - Marked B
                                        ┐
    Lorem ipsumdolor sit amet,          │
    consectetur adipiscing elit, sed    │
    do eiusmod tempor incididunt...     │
                                        ┘
]],

    [[
16 - Marked C
                                        ╖
    Lorem ipsumdolor sit amet,          ║
    consectetur adipiscing elit, sed    ║
    do eiusmod tempor incididunt...     ║
                                        ╜
]],

    [[
17 - Vertically Enclosed A
▲                                      ▲
█ Lorem ipsumdolor sit amet,           █
█  consectetur adipiscing elit, sed    █
█  do eiusmod tempor incididunt...     █
▼                                      ▼
]],

    [[
18 - Vertically Enclosed B
┌                                      ┐
│ Lorem ipsumdolor sit amet,           │
│  consectetur adipiscing elit, sed    │
│  do eiusmod tempor incididunt...     │
└                                      ┘
]],

    [[
19 - Vertically Enclosed C
╓                                      ╖
║ Lorem ipsumdolor sit amet,           ║
║  consectetur adipiscing elit, sed    ║
║  do eiusmod tempor incididunt...     ║
╙                                      ╜
]],

    [[
20 - Horizontally Enclosed A
┌──────────────────────────────────────┐
    Lorem ipsumdolor sit amet,
    consectetur adipiscing elit, sed
    do eiusmod tempor incididunt...
└──────────────────────────────────────┘
]],

    [[
21 - Horizontally Enclosed B
╒══════════════════════════════════════╕
    Lorem ipsumdolor sit amet,
    consectetur adipiscing elit, sed
    do eiusmod tempor incididunt...
╘══════════════════════════════════════╛
]],

    [[
22 - Horizontally Enclosed C
╒══════════════════════════════════════╕
    Lorem ipsumdolor sit amet,
    consectetur adipiscing elit, sed
    do eiusmod tempor incididunt...
└──────────────────────────────────────┘
]],
}
local line = {
    [[
    1 - Simple (Default)
    ─── title ──────────────────────────────
    ]],

    [[
    2 - Simple - Rounded corner down
    ╭── title ─────────────────────────────╮
    ]],

    [[
    3 - Simple - Rounded corner up
    ╰── title ─────────────────────────────╯
    ]],

    [[
    4 - Simple - Squared corner down
    ┌── title ─────────────────────────────┐
    ]],

    [[
    5 - Simple - Squared corner up
    └── title ─────────────────────────────┘
    ]],

    [[
    6 - Simple - Squared title
    ──[ title ]─────────────────────────────
    ]],

    [[
    7 - Simple - Rounded title
    ──( title )─────────────────────────────
    ]],

    [[
    8 - Simple - Spiked title
    ──< title >─────────────────────────────
    ]],

    [[
    9 - Simple Heavy
    ━━━ title ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    ]],

    [[
    10 - Confined
    ├──┤ title ├───────────────────────────┤
    ]],

    [[
    11 - Confined Heavy
    ┣━━┫ title ┣━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
    ]],

    [[
    12 - Simple Weighted
    ╾──╼ title ╾───────────────────────────╼
    ]],

    [[
    13 - Double
    ════ title ═════════════════════════════
    ]],

    [[
    14 - Double Confined
    ╞══╡ title ╞═══════════════════════════╡
    ]],

    [[
    15 - ASCII A
    ---- title -----------------------------
    ]],

    [[
    16 - ASCII B
    ____ title _____________________________
    ]],

    [[
    17 - ASCII C
    +--+ title +---------------------------+
    ]],
}
local choice = {
    ["line"] = function()
        return line
    end,
    ["box"] = function()
        return boxes
    end,
}

-- This does not work in visual mode
--  TODO: (vsedov) (13:35:16 - 02/03/24): need to fix this once i get the time.
local function selectCommentStyle()
    local function executeCommand(style, alignment)
        local data = function()
            data()[alignment].fn(style)
        end
        local esc = vim.api.nvim_replace_termcodes("<Esc>", true, true, true)
        vim.api.nvim_feedkeys(esc, "x", false)
        data()
    end

    vim.ui.select({ "box", "line" }, { prompt = "Choose a type (box/line):" }, function(choiceType)
        if choiceType then
            local styles = choice[choiceType]()
            local styleLabels = {}
            for i, style in ipairs(styles) do
                table.insert(styleLabels, tostring(i) .. " - " .. style:match("^%s*(.-)%s*$")) -- Extracting the first line as label
            end

            vim.ui.select(styleLabels, { prompt = "Choose a style:" }, function(choiceStyle)
                local styleIndex = tonumber(choiceStyle:match("^%d+"))
                local selectedStyle = styles[styleIndex]

                local alignments =
                    { "ll", "lc", "lr", "cl", "cc", "cr", "rl", "rc", "rr", "aa", "ac", "ar", "L", "C", "R" }
                vim.ui.select(alignments, { prompt = "Choose an alignment:" }, function(choiceAlignment)
                    if choiceAlignment then
                        -- Execute the chosen command
                        executeCommand(selectedStyle, choiceAlignment)
                    end
                end)
            end)
        end
    end)
end

-- Function to apply the selected style and alignment to the text
local function executeCommand(style, alignment, selectedText)
    -- Here we assume the 'fn' in data()takes style and selected text as parameters
    data()[alignment].fn(style, selectedText)
end

local config = {
    Box = {
        color = "red",
        body = leader,
        mode = { "n", "v", "x", "o" },
        ["<ESC>"] = { nil, { exit = true } },
        ["<cr>"] = {
            function()
                selectCommentStyle()
            end,
            { nowait = true, silent = true, desc = "All Options", exit = true },
        },
        ["L"] = {
            function()
                data()["L"].fn()
            end,
            { desc = data()["L"].label, nowait = true, silent = true },
        },
        ["C"] = {
            function()
                data()["C"].fn()
            end,
            { desc = data()["C"].label, nowait = true, silent = true },
        },
        ["R"] = {
            function()
                data()["R"].fn()
            end,
            { desc = data()["R"].label, nowait = true, silent = true },
        },

        ["ll"] = {
            function()
                data()["ll"].fn(18)
            end,
            { desc = data()["ll"].label, nowait = true, silent = true },
        },
        ["lc"] = {
            function()
                data()["lc"].fn(18)
            end,
            { desc = data()["lc"].label, nowait = true, silent = true },
        },
        ["lr"] = {
            function()
                data()["lr"].fn(18)
            end,
            { desc = data()["lr"].label, nowait = true, silent = true },
        },

        ["cl"] = {
            function()
                data()["cl"].fn(18)
            end,
            { desc = data()["cl"].label, nowait = true, silent = true },
        },
        ["cc"] = {
            function()
                data()["cc"].fn(18)
            end,
            { desc = data()["cc"].label, nowait = true, silent = true },
        },
        ["cr"] = {
            function()
                data()["cr"].fn(18)
            end,
            { desc = data()["cr"].label, nowait = true, silent = true },
        },

        ["rl"] = {
            function()
                data()["rl"].fn(18)
            end,
            { desc = data()["rl"].label, nowait = true, silent = true },
        },
        ["rc"] = {
            function()
                data()["rc"].fn(18)
            end,
            { desc = data()["rc"].label, nowait = true, silent = true },
        },
        ["rr"] = {
            function()
                data()["rr"].fn(18)
            end,
            { desc = data()["rr"].label, nowait = true, silent = true },
        },

        ["aa"] = {
            function()
                data()["aa"].fn(18)
            end,
            { desc = data()["aa"].label, nowait = true, silent = true },
        },
        ["ac"] = {
            function()
                data()["ac"].fn(18)
            end,
            { desc = data()["ac"].label, nowait = true, silent = true },
        },
        ["ar"] = {
            function()
                data()["ar"].fn(18)
            end,
            { desc = data()["ar"].label, nowait = true, silent = true },
        },
    },
}
return {
    config,
    "Box",
    { { "ll", "lr" }, { "cl", "cr" }, { "rl", "rr" }, { "ac", "ar" }, { "L", "C", "R" } },
    bracket,
    6,
    3,
}
