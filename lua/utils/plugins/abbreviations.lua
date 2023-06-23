local utils = require("utils.abbreviations.utils")
local abbrevs = require("utils.abbreviations.dictionary")
local M = {}

M.load_cmd = function() end

M.setup = function(opts)
    opts = opts or {}
    if lambda.config.abbrev.coding_support then
        for _, abbrev in ipairs(abbrevs.global_abbrevs.iabbrevs) do
            utils.inoreabbrev(abbrev[1], abbrev[2])
        end

        -- these break so cannot really use these now
        for _, cabbrev in ipairs(abbrevs.global_abbrevs.cabbrevs) do
            utils.cnoreabbrev(cabbrev[1], cabbrev[2])
        end
    end

    for item, value in pairs(lambda.config.abbrev.globals) do
        if value == true then
            utils.load_dict(abbrevs[item])
        end
    end
    utils.load_filetypes()
end
return M
