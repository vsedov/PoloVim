require("utils.plugins.profiler")
require("core")
require("overwrite")
local test = 10
print("DEBUGPRINT[2]: init.lua:4 (after local test = 10)")
print("DEBUGPRINT[1]: init.lua:4: test=" .. vim.inspect(test))
