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

if lambda.config.colourscheme.change_kitty_bg then
    local fn = vim.fn
    vim.g.ORIGINAL_KITTY_BG_COLOR = nil

    local split = function(str)
        local tokens = {}
        for s in string.gmatch(str, "%S+") do
            table.insert(tokens, s)
        end

        return tokens
    end

    local get_kitty_background = function()
        local Job = require("plenary.job")

        if vim.g.ORIGINAL_KITTY_BG_COLOR == nil then
            -- HACK: getting background color
            Job:new({
                command = "kitty",
                args = { "@", "get-colors" },
                cwd = "/usr/bin/",
                on_exit = function(j, _)
                    local color = split(j:result()[4])[2]
                    vim.g.ORIGINAL_KITTY_BG_COLOR = color
                end,
            }):start()
        end
    end

    local function get_color(group, attr)
        return fn.synIDattr(fn.synIDtrans(fn.hlID(group)), attr)
    end

    local change_background = function(color)
        local arg = 'background="' .. color .. '"'
        local command = "kitty @ set-colors " .. arg
        local handle = io.popen(command)
        if handle ~= nil then
            handle:close()
        end
    end

    local autocmd = vim.api.nvim_create_autocmd
    local autogroup = vim.api.nvim_create_augroup
    local bg_change = autogroup("BackgroundChange", { clear = true })

    autocmd("ColorScheme", {
        pattern = "*",
        co = function()
            get_kitty_background()
            local color = get_color("Normal", "bg")
            change_background(color)
        end,
        group = bg_change,
    })

    lambda.augroup("Background", {
        {
            event = "VimLeavePre",
            command = function()
                if vim.g.ORIGINAL_KITTY_BG_COLOR ~= nil then
                    change_background(vim.g.ORIGINAL_KITTY_BG_COLOR)
                end
            end,
        },
        {
            event = "ColorScheme",
            pattern = "*",
            command = function()
                get_kitty_background()
                local color = get_color("Normal", "bg")
                change_background(color)
            end,
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

-------------------------
-- COMMANDS
-------------------------
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
