-- Why ?
-- Well my dumbass kinda just deletes their hydra, not intentionally, it just seems to occur, an
-- unfortunate series of events, and due to how much i use hydra, i had two options, save the json
-- file where shit is stored, which honestly i should do, or create a quick work around, so for the
-- time, this will be good enough to be viable.
local local_path = [[]]

for _, dir in ipairs(vim.fn.globpath(require("core.helper").get_config_path() .. "/lua/modules", "*", true, true)) do
    local_path = local_path .. string.format("lua/modules/%s/plugins.lua", dir:match("lua/modules/(.*)")) .. "\n"
end
vim.notify(local_path)
