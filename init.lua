require("utils.plugins.profiler")
require("core")
require("overwrite")
local test = 10
print("DEBUGPRINT[2]: init.lua:4 (after local test = 10)")
print("DEBUGPRINT[1]: init.lua:4: test=" .. vim.inspect(test))

local function parse_test(test)
    print('DEBUGPRINT[5]: init.lua:9 (before )')
    local test = test or {}

    print('DEBUGPRINT[4]: init.lua:10 (after local test = test or {})')

end
