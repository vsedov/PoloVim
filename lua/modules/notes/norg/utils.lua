local M = {}

---@class ExportFileOpts
---@field open_file boolean? # Whether to open dst file in a new buffer
---@field open_markdown_preview boolean? # Whether to run `:MarkdownPreview` after opening the file
---@field only_overwrite boolean? # Exit without doing anything if dst file does not exist

---@param suffix string # suffix for the target file to be exported
---@param opts ExportFileOpts # options
M.export_file = function(suffix, opts)
    local dst = vim.fn.fnamemodify(vim.fn.expand("%"), ":~:.:r") .. suffix -- same name with suffix
    if opts.only_overwrite and not vim.g.personal_module.exists(dst) then
        return
    end
    vim.cmd(string.format([[Neorg export to-file %s]], string.gsub(dst, " ", [[\ ]])))
    if opts.open_file then
        vim.schedule(function()
            vim.cmd.edit(dst)
            if opts.open_markdown_preview then
                vim.cmd([[MarkdownPreview]])
            end
        end)
    end
end

return M
