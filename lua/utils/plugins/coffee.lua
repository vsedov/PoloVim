local notify = require("notify")
local t = os.date("*t")
local time_left = 30 - t.min % 30
local function min(m)
    return m * 60 * 1000
end

local function drink_coffee()
    local timer = vim.loop.new_timer()
    timer:start(min(30), 0, function()
        notify({ "Drink Coffee", "☕" }, "info", {
            title = "Drink Coffee",
            timeout = min(1),
        })
    end)
end

drink_coffee()
