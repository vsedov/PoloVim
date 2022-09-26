local km = require("core.keymap")
local hm = require("harpoon.mark")

local function harpoon_notify(f)
    return function()
        f()
        E.notify("harpoon", true)
    end
end

M = {}

local leader = km.leader
local Alt = km.alt
local Ctrl = km.ctrl
-- TODO: Merge these two things
local cmd = km.cmd
local luacmd = km.luacmd

local scope = km.extendleader(leader, "f")
local bufl = km.extendleader(leader, "b")
local repl = km.extendleader(leader, "g")
local tabl = km.extendleader(leader, "t")
local cx = km.genleader(Ctrl("x"))
-- local cj = keymap.genleader(Ctrl("j"))
local cxc_ = function(s)
    return cx(Ctrl(s))
end
-- local cjc_ = function (s)
--     return cj(Ctrl(s))
-- end
local g = km.genleader("g")
-- local bufl = leader_suffix("b")
-- local repl = leader_suffix("g")
-- local tabl = leader_suffix("t")

local clever_tcd = function()
    local root = require("lspconfig").util.root_pattern("Project.toml", ".git")(vim.api.nvim_buf_get_name(0))
    if root == nil then
        root = " %:p:h"
    end
    vim.cmd("tcd " .. root)
    vim.cmd("pwd")
end

M.config = {
    general = {
        normal = {
            -- [" "] = { "<Nop>", "" },
            [g("h")] = { cmd("DocsViewToggle"), "docs view" },
            [Ctrl("c")] = { cmd("noh"), "clear highlight search" },
            ["0"] = { "^", "start of line" },
            ["_"] = { Ctrl("^"), "last buffer" },
            ["cl"] = { "s", "delete and insert" },
            [leader("F")] = { cmd("Lex 30"), "Netrw" },
            [leader("w")] = { cmd("w!"), "save" },
            [leader("cc")] = { cmd("tcd %:p:h<cr><cmd>pwd"), "cd to current file" },
            [leader("cd")] = { harpoon_notify(clever_tcd), "cd to current project or file" },
            [Alt("Up")] = { cmd("resize +2"), "Increase window size horizontal" },
            [Alt("Left")] = { cmd("vertical resize -2"), "Decrease window size vertical" },
            [Alt("Right")] = { cmd("vertical resize +2"), "Increase window size vertical" },
            [Alt("Down")] = { cmd("resize -2"), "Decrease window size horizontal" },
            [Ctrl(".")] = { cmd("bp"), "Previous buffer" },
            [Ctrl(",")] = { cmd("bn"), "next buffer" },
            [g("G")] = { cmd("Neogit"), "Git" },
            [cxc_("h")] = { harpoon_notify(hm.add_file), "harpoon mark" },
            [cx("h")] = { harpoon_notify(hm.add_file), "harpoon mark" },
            [cx("x")] = { harpoon_notify(hm.add_file), "harpoon mark" },
            [cxc_("x")] = { harpoon_notify(hm.add_file), "harpoon mark" },
            ["<Right>"] = { harpoon_notify(require("harpoon.ui").nav_next), "harpoon next" },
            ["<Left>"] = { harpoon_notify(require("harpoon.ui").nav_prev), "harpoon prev" },
            [cxc_("n")] = { harpoon_notify(require("harpoon.ui").nav_next), "harpoon next" },
            [cx("n")] = { harpoon_notify(require("harpoon.ui").nav_next), "harpoon next" },
            [cxc_("p")] = { harpoon_notify(require("harpoon.ui").nav_prev), "harpoon prev" },
            [cx("p")] = { harpoon_notify(require("harpoon.ui").nav_prev), "harpoon prev" },
            [cxc_("m")] = { harpoon_notify(require("harpoon.cmd-ui").toggle_quick_menu), "harpoon command menu" },
            [cx("m")] = { harpoon_notify(require("harpoon.cmd-ui").toggle_quick_menu), "harpoon command menu" },
            [cxc_("f")] = { harpoon_notify(require("harpoon.ui").toggle_quick_menu), "harpoon menu" },
            [cx("f")] = { harpoon_notify(require("harpoon.ui").toggle_quick_menu), "harpoon menu" },
            [cxc_("o")] = { harpoon_notify(require("harpoon.ui").toggle_quick_menu), "harpoon menu" },
            [cx("o")] = { harpoon_notify(require("harpoon.ui").toggle_quick_menu), "harpoon menu" },
        },
        terminal = {
            ["<Esc>"] = { "<C-\\><C-n>", "Terminal escape" },
        },
        visual = {
            ["<"] = { "<gv", "Move text left" },
            [">"] = { ">gv", "Move text right" },
            ["p"] = { '"_dP', "paste in place" },
            ["K"] = { ":move '>-2<CR>gv-gv", "Move text up (broken)" },
            ["J"] = { ":move '>+1<CR>gv-gv", "Move text down" },
        },
        xmode = {
            ["p"] = { '"_dP', "paste in place" },
            ["K"] = { ":move '>-2<CR>gv-gv", "Move text up (broken)" },
            ["J"] = { ":move '>+1<CR>gv-gv", "Move text down" },
        },
        omni = {},
        insert = {
            [Ctrl("j")] = { "<Plug>(TaboutMulti)", "" },
            [Ctrl("k")] = { "<Plug>(TaboutBackMulti)", "" },
        },
    },
    telescope = {
        normal = {
            [scope(" ")] = {
                cmd("Telescope current_buffer_fuzzy_find theme=ivy previewer=false"),
                "current buffer find",
            },
            [scope("F")] = { cmd("FzfLua files"), "find files" },
            [scope("n")] = { cmd("Telescope ghn"), "find notifications" },
            [scope("h")] = { cmd("Telescope harpoon marks"), "harpoon" },
            [scope("f")] = { cmd("Telescope fd theme=ivy"), "find files" },
            [scope("R")] = { cmd("FzfLua resume"), "resume" },
            [scope("r")] = { cmd("Telescope resume"), "resume" },
            [scope("G")] = { cmd("FzfLua live_grep_native"), "live grep" },
            [scope("g")] = { cmd("Telescope live_grep theme=ivy"), "live grep" },
            [scope("o")] = { cmd("Telescope oldfiles theme=ivy"), "find oldfiles" },
            -- [scope("B")] = { cmd("BufferLinePick"), "find buffers" },
            [scope("b")] = { cmd("Telescope buffers theme=ivy"), "find buffers" },
            [scope("t")] = { cmd("TodoTelescope theme=ivy"), "find todos" },
            ["z="] = { cmd("Telescope spell_suggest theme=ivy"), "spell suggest" },
            -- [scope("T")] = { cmd("TodoTelescope"), "find tabs" },
            [scope("i")] = { cmd("Octo issue list"), "Search issues" },
            [scope("p")] = { cmd("Octo pr list"), "Search prs" },
            [scope("M")] = { cmd("Telescope marks theme=ivy"), "find marks" },
            [scope("m")] = { cmd("Telescope harpoon marks theme=ivy"), "find harpoon marks" },
            [scope("j")] = { cmd("Telescope jumplist theme=ivy"), "find jumps" },
            [scope("e")] = { cmd("Telescope symbols theme=ivy"), "find symbols" },
            [scope("r")] = { cmd("Telescope reloader theme=ivy"), "reload" },
            [scope("d")] = { cmd("Telescope lsp_definitions theme=ivy"), "find lsp definitions" },
            [scope("D")] = { cmd("Telescope lsp_type_definitions theme=ivy"), "find lsp type definitions" },
            -- [scope("r")] = { cmd("Telescope lsp_references theme=ivy"), "find lsp references" },
            [Ctrl("p")] = { cmd("Telescope oldfiles theme=ivy"), "find oldfiles" },
            [Ctrl("f")] = { cmd("Telescope live_grep theme=ivy"), "live_grep" },
            -- [Ctrl("s")] = { cmd("Telescope fd theme=ivy previewer=false"), "find oldfiles" },
            -- [scope(" ")] = { cmd("Telescope frecency"), "find frecency" }
        },
    },
}

for k, value in pairs({ left = "h", down = "j", up = "k", right = "l" }) do
    M.config.general.normal[Ctrl(value)] = { Ctrl("w") .. value, "Window " .. k }
    M.config.general.terminal[Ctrl(value)] = { "<C-\\><C-N><C-w>" .. value, "Window " .. k }
    M.config.general.terminal[Alt(value)] = { "<C-\\><C-N><C-w>" .. value, "Window " .. k }
end

M.config.buffer = {
    normal = {
        [bufl("n")] = { cmd("bnext"), "next buffer" },
        [bufl("p")] = { cmd("bprevious"), "previous buffer" },
        [bufl("l")] = { cmd("bprevious"), "previous buffer" },
        [bufl(" ")] = { cmd("bnext"), "next buffer" },
        [bufl("b")] = { cmd("bnext"), "next buffer" },
        [bufl("x")] = { cmd("bdelete"), "close buffer" },
        [bufl("s")] = { cmd("Telescope buffers theme=ivy"), "select buffer" },
        [bufl("S")] = { cmd("BufferLinePick"), "select buffer" },
        [bufl("f")] = { cmd("Telescope buffers theme=ivy"), "select buffer" },
        [bufl("1")] = { cmd("bfirst"), "first buffer" },
        [bufl("0")] = { cmd("blast"), "last buffer" },
    },
}

M.config.tab = {
    normal = {
        [tabl("n")] = { cmd("tabnext"), "next tab" },
        [tabl("N")] = { cmd("tabnew"), "new tab" },
        [tabl("o")] = { cmd("tabonly"), "close all tabs but current" },
        [tabl(" ")] = { cmd("tabnext"), "next tab" },
        [tabl("e")] = { ":tabedit ", "edit new file in new tab" },
        [tabl("m")] = { ":tabmove ", "move tabs" },
        [tabl("l")] = { cmd("exe 'tabn '.g:lasttab"), "previos tab" },
    },
}

M.config.repl = {}
M.config.repl.normal = {
    [repl("g")] = { km.plugmapping("SendLine"), "Send to repl (line)" },
    [repl(" ")] = { km.plugmapping("SendLine"), "Send to repl (line)" },
    [repl("")] = { km.plugmapping("Send"), "Send to repl" },
}
M.config.repl.visual = {
    [repl("")] = { km.plugmapping("Send"), "Send to repl" },
}

local addmap = function(key, t, mode)
    return function(lhs, rhs)
        t[key][mode][lhs] = rhs
    end
end

local nmap = addmap("general", M.config, "normal")
local vmap = addmap("general", M.config, "visual")
local xmap = addmap("general", M.config, "xmode")
local asterisk = { "*", "#" }
for _, star in ipairs(asterisk) do
    nmap(star, { km.plugmapping("(asterisk-z" .. star .. ")"), "" })
    nmap(g(star), { km.plugmapping("(asterisk-gz" .. star .. ")"), "" })
    vmap(star, { km.plugmapping("(asterisk-z" .. star .. ")"), "" })
    vmap(g(star), { km.plugmapping("(asterisk-gz" .. star .. ")"), "" })
    nmap("z" .. star, { km.plugmapping("(asterisk-" .. star .. ")"), "" })
    nmap(g("z" .. star), { km.plugmapping("(asterisk-g" .. star .. ")"), "" })
    vmap("z" .. star, { km.plugmapping("(asterisk-" .. star .. ")"), "" })
    vmap(g("z" .. star), { km.plugmapping("(asterisk-g" .. star .. ")"), "" })
end

local function _zz(s)
    return table.concat({ s, "zz" })
end

local function zz_(s)
    return table.concat({ "zz", s })
end

-- center everything
for _, jumps in ipairs({
    "G",
    "n",
    "N",
    "%",
    "(",
    ")",
    "[[",
    "]]",
    "{",
    "}",
    "L",
    "H",
    Ctrl("u"),
    Ctrl("d"),
    Ctrl("i"),
    Ctrl("o"),
    Ctrl("t"),
}) do
    nmap(jumps, { _zz(jumps), "" })
    vmap(jumps, { _zz(jumps), "" })
end

for loc in ipairs({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }) do
    nmap(g(loc), { luacmd("require('harpoon.ui').nav_file(" .. loc .. ")") })
end

local mode_map = { normal = "n", visual = "v", terminal = "t", insert = "t", xmode = "x", omni = "o" }

M.setup = function(config)
    for _, v in pairs(config) do
        for mode, def in pairs(v) do
            local modestr = mode_map[mode]
            for lhs, rhs in pairs(def) do
                km.keymap(modestr, lhs, rhs[1], { noremap = true, silent = true }, rhs[2])
            end
        end
    end
end

return M
