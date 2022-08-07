local utils = require("utils.abbreviations.utils")
local abbrevs = require("utils.abbreviations.abbrev")

if lambda.config.abbrev.coding_support then
    for _, abbrev in ipairs(abbrevs.global_abbrevs.iabbrevs) do
        utils.inoreabbrev(abbrev[1], abbrev[2])
    end

    for _, cabbrev in ipairs(abbrevs.global_abbrevs.cabbrevs) do
        utils.cnoreabbrev(cabbrev[1], cabbrev[2])
    end
    for _, cabbrev in ipairs(abbrevs.global_abbrevs.cnoremapbrevs) do
        utils.cnoremap(cabbrev[1], cabbrev[2])
    end
end

for _, value in ipairs(lambda.config.abbrev.globals) do
    if abbrevs[value] ~= nil then
        utils.load_dict(abbrevs[value])
    end
end

for _, value in ipairs(lambda.config.abbrev.languages) do
    if abbrevs[value] ~= nil then
        utils.load_dict(abbrevs[value])
    end
end

-- Load specific abreviations

-- require("utils.abbreviations.utils").load_dict(require("utils.abbreviations.abbrev").python_support)
