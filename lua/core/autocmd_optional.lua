local vim = vim
local fn = vim.fn
local api = vim.api
local fmt = string.format

if vim.env.TERM == "xterm-kitty" then
    lambda.augroup("VimrcIncSearchHighlight", {
        {
            event = "UIEnter",
            pattern = "*",
            command = [[if v:event.chan ==# 0 | call chansend(v:stderr, "\x1b[>1u") | endif]],
        },
        {
            event = "UILeave",
            pattern = "*",
            command = [[if v:event.chan ==# 0 | call chansend(v:stderr, "\x1b[<1u") | endif]],
        },
    })
end

if lambda.config.neorg_auto_commit then
    lambda.augroup("NeorgAutoCommit", {
        {
            event = { "VimLeavePre", "VimSuspend" },
            pattern = "/home/viv/neorg/*",
            command = function()
                -- it might be enabled at teh start: but what happens when i dont what this to occour ?
                -- best way is to have another check - as there will be a toggle for neorg_auto_commit
                if lambda.config.neorg_auto_commit then
                    require("utils.custom_neorg_save").start()
                end
            end,
        },
    })
end

if lambda.config.loaded_confirm_quit then
    require("utils.exit")
end

vim.api.nvim_create_user_command("SwitchBar", function()
    if lambda.config.tabby_or_bufferline then
        package.loaded["bufferline"] = nil
        lambda.config.tabby_or_bufferline = false
        require("packer").loader("tabby.nvim")
        require("modules.ui.config").tabby()
    else
        package.loaded["tabby"] = nil
        lambda.config.tabby_or_bufferline = true
        vim.cmd([[packadd bufferline]])
        require("modules.ui.config").nvim_bufferline()
    end
    require("modules.editor.hydra.buffer").buffer()
end, { force = true })
