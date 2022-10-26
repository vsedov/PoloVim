-- Make an auto generated hint table for the refactor menu, but it needs to be smart so it must
-- account for the size of the de1scription and the length of the keybinds. so its the perfect
-- size.

local function get_hint_table_sizes(hints)
    local hint_table
    local max_length_desc = 0
    local max_length_keybind = 0
    for _, hint in ipairs(hints) do
        if #hint[3].desc > max_length_desc then
            max_length_desc = #hint[3].desc
        end
        if #hint[1] > max_length_keybind then
            max_length_keybind = #hint[1]
        end
    end
    return max_length_desc, max_length_keybind
end
local function create_hint(hints, bind_count, title_padding)
    local header = hints
    bind_count = bind_count or 3
    local max_length_desc, max_length_keybind = get_hint_table_sizes(hints)
    local hint_table = {}
    for _, hint in ipairs(hints) do
        local desc = hint[3].desc
        local keybind = hint[1]
        local topic = hint.topic
        -- add topic = {leybind, desc}
        if not hint_table[topic] then
            hint_table[topic] = {}
        end
        table.insert(hint_table[topic], { keybind, desc })
    end
    local per_topic_count = {}
    for topic, binds in pairs(hint_table) do
        if not per_topic_count[topic] then
            per_topic_count[topic] = {}
        end
        local prev_count = 0
        for _, data in ipairs(binds) do
            desc = data[2]
            keybind = data[1]
            total_length = #desc + #keybind + 3
            prev_count = prev_count + total_length
            vim.list_extend(per_topic_count[topic], { total_length / bind_count })
        end
    end
    -- get max value from per_topic_count
    local max_topic_count = 0
    for _, count in pairs(per_topic_count) do
        local total = 0
        for _, value in ipairs(count) do
            total = total + value
        end
        if total > max_topic_count then
            max_topic_count = total
        end
    end

    local hint = " " .. string.rep(" ", max_topic_count + bind_count) .. "\n"

    hint = hint .. " " .. string.rep("▔", max_topic_count + bind_count) .. "\n"
    middle_of_line = math.floor(max_topic_count / 2)

    for topic, binds in pairs(hint_table) do
        local topic_length = #topic
        hint_middle = math.floor(max_topic_count / 2)
        hint = hint
            .. ""
            .. string.rep(" ", hint_middle - math.floor(topic_length / 2))
            .. string.rep(" ", title_padding)
            .. topic
            .. string.rep(" ", hint_middle - math.floor(topic_length / 2))
            .. string.rep(" ", max_topic_count - hint_middle - math.floor(topic_length / 2))
            .. "\n"

        hint = hint .. " " .. string.rep("▔", max_topic_count + bind_count) .. "\n"
        local count = 0
        local topic_binds = ""
        for _, data in ipairs(binds) do
            desc = data[2]
            keybind = data[1]
            total_length = #desc + #keybind + 3

            topic_binds = topic_binds
                .. " "
                .. string.rep(" ", bind_count)
                .. "_"
                .. keybind
                .. "_"
                .. " "
                .. desc
                .. string.rep(" ", max_length_desc - #desc + 1)
                .. "\n"
        end

        hint = hint .. topic_binds

        hint = hint .. " " .. string.rep("▔", max_topic_count + bind_count) .. "\n"
    end
    return hint
end
