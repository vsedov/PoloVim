local utils = require("modules.notes.norg.utils")

local M = {
    neorg_aug = vim.api.nvim_create_augroup("NeorgWritePre", { clear = true }),
}

local function format_on_save(_)
    vim.api.nvim_create_autocmd("BufWritePre", {
        group = M.neorg_aug,
        pattern = "*.norg",
        desc = "Neorg: format current file on save",
        callback = function()
            vim.cmd([[
      normal m`=gG``
      ]])
        end,
    })
end

local function export_to_markdown(_)
    vim.api.nvim_create_autocmd("BufWritePost", {
        group = M.neorg_aug,
        pattern = "*.norg",
        desc = "Neorg: export to markdown file if file already exists",
        callback = function()
            utils.export_file(".md", { only_overwrite = true, open_file = false })
        end,
    })
end

local function rename_file_with_spaces(_)
    vim.api.nvim_create_autocmd("BufWinEnter", {
        group = M.neorg_aug,
        pattern = "*.norg",
        desc = "Neorg: rename file if filename contains whitespace to underscore",
        callback = function()
            local file = vim.fn.expand("<afile>")
            local dir, file_name = vim.fn.fnamemodify(file, ":p:h"), vim.fn.fnamemodify(file, ":p:t")
            local new_name = string.gsub(file_name, " ", "_")
            if file_name == new_name then
                return
            end
            local res, err = os.rename(dir .. "/" .. file_name, dir .. "/" .. new_name)
            if not res then
                vim.notify(
                    err or string.format("Failed to rename: `%s` -> `%s`", file_name, new_name),
                    vim.log.levels.ERROR
                )
                return
            end
            vim.schedule(function()
                vim.api.nvim_buf_delete(0, {})
                vim.cmd.edit(dir .. "/" .. new_name)
            end)
        end,
    })
    vim.api.nvim_create_autocmd("FileType", { pattern = "norg", command = "set awa" })
end

M.setup = function(opts)
    format_on_save(opts)
    export_to_markdown(opts)
    rename_file_with_spaces(opts)
end

return M
