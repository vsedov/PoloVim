local match = lambda.lib.match
local when = lambda.lib.when

local function cmd_parser(command_list)
    for _, command in ipairs(command_list) do
        vim.fn.system(command)
    end
end
local M = {}
M.is_dirty = function()
    -- vim.api.nvim_set_current_dir(folder)
    local is_dirty = vim.fn.systemlist("git status --porcelain")
    local commit_message = "Auto Neovim Exit Commit " .. vim.fn.strftime("%Y-%m-%d %H:%M:%S") .. ":"

    return when(not vim.tbl_isempty(is_dirty), function()
        print("Folder is not clean : pushes needed")
        vim.ui.input({ prompt = "Do you want to add more to this commit ?" }, function(input)
            local valid_answers = { "y", "yes", "Y", "Yes", "YES", "YES!" }
            if vim.tbl_contains(valid_answers, input) then
                vim.ui.input({ prompt = "Enter commit message" }, function(commit)
                    commit_message = commit_message .. "\n" .. commit
                end)
            else
                print("Commiting:")
            end
        end)

        for i, v in ipairs(is_dirty) do
            if string.sub(v, 1, 1) == "?" then
                is_dirty[i] = " A" .. string.sub(v, 3)
            end
            if string.len(is_dirty[i]) > 50 then
                is_dirty[i] = string.sub(is_dirty[i], 1, 50) .. "..."
            end
            commit_message = commit_message .. "\n" .. is_dirty[i]
        end
        cmd_parser({
            "git add .",
            "git commit -m '" .. vim.fn.escape(commit_message, "\\") .. "'",
            "git push",
        })

        print("Folder is dirty and pushed")
    end, function()
        print("No changes were made")
    end)
end

M.work_tree_check = function()
    return when(vim.fn.systemlist("git rev-parse --is-inside-work-tree")[1] == "true", function()
        print("Inside worktree")
        M.is_dirty()
    end, function()
        print("Folder is not a git repo")
    end)
end

M.is_in_git = function()
    local folder = "/home/viv/neorg/"
    return match(string.sub(vim.fs.find(".git", { upward = true })[1], 1, #folder))({
        [folder] = function()
            M.work_tree_check()
        end,
    })
end

M.start = function()
    vim.ui.input({ prompt = "Do you want to auto Commit ?" }, function(input)
        local valid_answers = { "y", "yes", "Y", "Yes", "YES", "YES!" }
        if vim.tbl_contains(valid_answers, input) then
            M.is_in_git()
        else
            print("No changes were made")
        end
    end)
end

return M
