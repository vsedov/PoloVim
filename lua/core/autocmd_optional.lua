local vim = vim
local fn = vim.fn
local api = vim.api
local fmt = string.format

kitty_env = function()
    if string.find(os.getenv("TERM"), "kitty") ~= nil then
        return true
    else
        return false
    end
end
if lambda.config.colourscheme.change_kitty_bg and kitty_env() then
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
            event = { "BufEnter" },
            pattern = { "/home/viv/neorg/*", "/home/viv/GitHub/personal/year_3/*" },
            command = function()
                vim.api.nvim_create_user_command("NeorgCommit", function()
                    require("utils.plugins.custom_neorg_save").start()
                end, { bang = true })
                vim.keymap.set("n", [[;']], "<cmd>NeorgCommit<cr>", {})
            end,
        },
    })
end
vim.defer_fn(function()
    local all_plugins = require("core.helper").get_config_path() .. "/lua/utils/plugins/"
    local path_list = vim.split(vim.fn.glob(all_plugins .. "*.lua", true), "\n")
    local exclude_table = {
        "custom_neorg_save",
        "git_pull_personal",
        "coffee",
    }
    for _, path in ipairs(path_list) do
        local name = vim.fn.fnamemodify(path, ":t:r")
        local f = "utils.plugins." .. name
        local enable = true
        local config_options = {
            ["save_clipboard_on_exit"] = lambda.config.custom.custom_save_clipboard,
            ["abbreviations"] = lambda.config.abbrev.enable,
            ["exit"] = lambda.config.loaded_confirm_quit,
            ["icecream"] = false,
        }

        if config_options[name] ~= nil then
            enable = config_options[name]
        end

        lambda.lib.when(not vim.tbl_contains(exclude_table, name), function()
            if enable then
                if name == "auto_normal" then
                    require(f).setup(20000)
                else
                    require(f).setup()
                end
            end
        end)
    end
end, 4000)
