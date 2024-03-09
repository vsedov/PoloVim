local Path = require("plenary.path")
local fidget = require("fidget")
local harpoon = require("harpoon")
-- Taken from https://github.com/willothy/nvim-config/blob/57c5caf34ee89887c3108602b99335af93d03242/lua/configs/navigation/harpoon.lua#L115
-- TODO: Clean up
local tmux = {
    automated = true,
    encode = false,
    prepopulate = function(cb)
        vim.system({
            "tmux",
            "list-sessions",
        }, { text = true }, function(out)
            if out.code ~= 0 then
                return {}
            end
            local sessions = out.stdout or ""
            local lines = {}
            for s in sessions:gmatch("[^\r\n]+") do
                table.insert(lines, { value = s, context = { row = 1, col = 1 } })
            end
            cb(lines)
        end)
    end,
    ---@diagnostic disable-next-line: unused-local
    select = function(list_item, _list, _option)
        local sessionName = string.match(list_item.value, "([^:]+)")
        vim.system({ "tmux", "switch-client", "-t", sessionName }, {}, function() end)
    end,
    ---@diagnostic disable-next-line: unused-local
    remove = function(list_item, list)
        local sessionName = string.match(list_item.value, "([^:]+)")
        vim.system({ "tmux", "kill-session", "-t", sessionName }, {}, function()
            list:remove()
        end)
    end,
}

local titles = {
    ADD = "added",
    REMOVE = "removed",
}

local function notify(event, cx)
    if not cx then
        return
    end
    local path = Path:new(cx.item.value) --[[@as Path]]

    local display = path:make_relative(vim.uv.cwd()) --[[@as string]]
        or path:make_relative(vim.env.HOME)
        or path:normalize()

    fidget.progress.handle.create({
        lsp_client = {
            name = "harpoon",
        },
        title = titles[event],
        message = display,
        level = vim.log.levels.ERROR,
    })
end

local terminals = {
    automated = true,
    encode = false,
    prepopulate = function()
        local bufs = vim.api.nvim_list_bufs()
        return vim.iter(bufs)
            :filter(function(buf)
                return vim.bo[buf].buftype == "terminal"
            end)
            :map(function(buf)
                return {
                    value = vim.api.nvim_buf_get_name(buf),
                    context = {
                        bufnr = buf,
                    },
                }
            end)
            :totable()
    end,
    ---@diagnostic disable-next-line, unused-local: 212
    remove = function(list_item, _list)
        if vim.api.nvim_buf_is_valid(list_item.context.bufnr) then
            require("bufdelete").bufdelete(list_item.context.bufnr, true)
        end
    end,
    ---@diagnostic disable-next-line: unused-local
    select = function(list_item, _list, _opts)
        local wins = vim.api.nvim_tabpage_list_wins(0)

        -- jump to existing window containing the buffer
        for _, win in ipairs(wins) do
            local buf = vim.api.nvim_win_get_buf(win)
            if buf == list_item.context.bufnr then
                vim.api.nvim_set_current_win(win)
                return
            end
        end

        -- switch to the buffer if no window was found
        vim.api.nvim_set_current_buf(list_item.context.bufnr)
    end,
}

---@param list HarpoonList
local function prepopulate(list)
    ---@diagnostic disable-next-line: undefined-field
    if list.config.prepopulate and list:length() == 0 then
        -- async via callback, or sync via return value
        local sync_items =
            ---@diagnostic disable-next-line: undefined-field
            list.config.prepopulate(vim.schedule_wrap(function(items)
                for _, item in ipairs(items or {}) do
                    list:append(item)
                end
                -- if ui is open, buffer needs to be updated
                -- so that items aren't removed immediately after being added
                local ui_buf = require("harpoon").ui.bufnr
                if ui_buf and vim.api.nvim_buf_is_valid(ui_buf) then
                    local lines = list:display()
                    vim.api.nvim_buf_set_lines(ui_buf, 0, -1, false, lines)
                end
            end))
        if sync_items then
            for _, item in ipairs(sync_items) do
                list:append(item)
            end
        end
    end
end

local function handler(evt)
    return function(...)
        notify(evt, ...)
    end
end

function update_config(win, fn)
    local config = vim.api.nvim_win_get_config(win)
    local res = fn(config)
    if res ~= nil then
        config = res
    end
    vim.api.nvim_win_set_config(win, config)
end
local oqt = require("oqt")
harpoon:setup({
    oqt = oqt.harppon_list_config,
    settings = {
        save_on_toggle = true,
        -- sync_on_ui_close = true,
        key = function()
            return vim.uv.cwd() --[[@as string]]
        end,
    },
    tmux = tmux,
    terminals = terminals,
    default = {},
    yeet = {
        select = function(list_item, _, _)
            require("yeet").execute(list_item.value)
        end,
    },
    menu = {
        width = vim.api.nvim_win_get_width(0) - 4,
    },
})
-- Pick a file from the harpoon list to open using number
harpoon:extend({
    LIST_READ = function(list)
        ---@diagnostic disable-next-line: undefined-field
        if list.config.automated then
            list:clear()
            prepopulate(list)
        end
    end,
    LIST_CREATED = prepopulate,
    ADD = handler("ADD"),
    REMOVE = handler("REMOVE"),
    UI_CREATE = function(cx)
        vim.keymap.set("n", "<C-v>", function()
            harpoon.ui:select_menu_item({ vsplit = true })
        end, { buffer = cx.bufnr })
        vim.keymap.set("n", "<C-x>", function()
            harpoon.ui:select_menu_item({ split = true })
        end, { buffer = cx.bufnr })

        vim.keymap.set("n", "<C-t>", function()
            harpoon.ui:select_menu_item({ tabedit = true })
        end, { buffer = cx.bufnr })

        for i = 1, 9 do
            vim.keymap.set("n", "" .. i, function()
                harpoon:list():select(i)
            end, { buffer = cx.bufnr })
        end
    end,
})
