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
    local t = function(str)
        return vim.api.nvim_replace_termcodes(str, true, true, true)
    end
    lambda.augroup("NeorgAutoCommit", {
        {
            event = { "VimLeavePre" },
            pattern = { "/home/viv/neorg/*" },
            command = function()
                lambda.dynamic_unload("dressing", false)
                t([[<cmd>tcd %:p:h<cr><cmd>pwd<cr>]])
                require("utils.plugins.custom_neorg_save").start()
            end,
        },
    })
end

if lambda.config.save_clipboard_on_exit then
    lambda.augroup("save_clipboard_on_exit", {
        {
            event = { "VimLeave" },
            attern = "*",
            command = function()
                if lambda.config.save_clipboard_on_exit then
                    require("utils.plugins.save_clipboard_on_exit").save()
                end
            end,
            once = false,
        },
    })
end

vim.defer_fn(function()
    if lambda.config.loaded_confirm_quit then
        require("utils.plugins.exit")
    end

    -- tbh, this can stay here, nothing changes with this
    if lambda.config.abbrev.enable then
        require("utils.abbreviations").setup()
    end

    -------------------------
    -- COMMANDS
    -------------------------
    vim.api.nvim_create_user_command("SwitchBar", function()
        if lambda.config.tabby_or_bufferline then
            lambda.unload("bufferline")
            lambda.config.tabby_or_bufferline = false
            require("packer").loader("tabby.nvim")
            require("modules.ui.config").tabby()
        else
            lambda.unload("tabby")
            lambda.config.tabby_or_bufferline = true
            require("packer").loader("bufferline.nvim")
            require("modules.ui.config").nvim_bufferline()
        end
        require("modules.editor.hydra.buffer").buffer()
    end, { force = true })
end, 100)
