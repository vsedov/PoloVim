local bind = require("keymap.bind")
local map_cr = bind.map_cr
local map_cu = bind.map_cu
local map_cmd = bind.map_cmd
local map_args = bind.map_args
-- local map_key = bind.map_key
-- local global = require("core.global")
local cur_buf = nil
local cur_cur = nil

local plug_map = {
    ["n|<M-w>"] = map_cmd("<cmd>NeoNoName<CR>", "NeoName Buffer"):with_noremap():with_silent():with_nowait(),

    ["n|<leader>cd"] = map_cmd(lambda.clever_tcd, "Cwd"):with_noremap():with_silent():with_nowait(),

    ["n|<RightMouse>"] = map_cmd("<RightMouse><cmd>lua vim.lsp.buf.definition()<CR>", "rightclick def")
        :with_noremap()
        :with_silent(),
}

if lambda.falsy(vim.fn.mapcheck("<ScrollWheelDown>")) then
    vim.keymap.set("n", "<ScrollWheelDown>", "<c-d>", { noremap = true, silent = true })
end
if lambda.falsy(vim.fn.mapcheck("<ScrollWheelUp>")) then
    vim.keymap.set("n", "<ScrollWheelUp>", "<c-u>", { noremap = true, silent = true })
end
local function open(path)
    vim.fn.jobstart({ "waterfox-g", path }, { detach = true })
    vim.notify(string.format("Opening %s", path))
end
vim.keymap.set({ "x", "n" }, "gx", function()
    local file = vim.fn.expand("<cfile>")
    if not file or vim.fn.isdirectory(file) > 0 then
        return vim.cmd.edit(file)
    end

    if file:match("http[s]?://") then
        return open(file)
    end

    -- consider anything that looks like string/string a github link
    local link = file:match("[%a%d%-%.%_]*%/[%a%d%-%.%_]*")
    if link then
        return open(string.format("https://www.github.com/%s", link))
    end
end, { noremap = true, silent = true })

return plug_map
