local config = {}

function config.telescope()
    require("utils.telescope").setup()
end

function config.fzf()
    require("fzf-lua").setup({
        lsp = {
            -- make lsp requests synchronous so they work with null-ls
            async_or_timeout = 3000,
        },
    })
    vim.api.nvim_set_keymap("n", "<C-p>", ":FzfLua git_files<CR>", { silent = true })
    vim.api.nvim_create_user_command("GF", "FzfLua git_status", {})
    vim.api.nvim_create_user_command("Gf", "FzfLua git_status", {})
    vim.api.nvim_create_user_command("B", "FzfLua buffers", { bang = true })
    vim.api.nvim_create_user_command("Com", "FzfLua commands", { bang = true })
    vim.api.nvim_create_user_command("Col", "FzfLua colorschemems", { bang = true })
    vim.api.nvim_create_user_command("RG", "FzfLua grep", { bang = true })
end
function config.spectre()
    local spectre = require("spectre")

    local sed_args = nil
    if vim.fn.has("mac") == 1 then
        sed_args = { "-I", "" }
    end

    spectre.setup({

        color_devicons = true,
        highlight = {
            ui = "String",
            search = "DiffChange",
            replace = "DiffDelete",
        },
        mapping = {
            ["toggle_line"] = {
                map = "t",
                cmd = "<cmd>lua require('spectre').toggle_line()<CR>",
                desc = "toggle current item",
            },
            ["enter_file"] = {
                map = "<cr>",
                cmd = "<cmd>lua require('spectre.actions').select_entry()<CR>",
                desc = "goto current file",
            },
            ["send_to_qf"] = {
                map = "Q",
                cmd = "<cmd>lua require('spectre.actions').send_to_qf()<CR>",
                desc = "send all item to quickfix",
            },
            ["replace_cmd"] = {
                map = "c",
                cmd = "<cmd>lua require('spectre.actions').replace_cmd()<CR>",
                desc = "input replace vim command",
            },
            ["show_option_menu"] = {
                map = "o",
                cmd = "<cmd>lua require('spectre').show_options()<CR>",
                desc = "show option",
            },
            ["run_replace"] = {
                map = "R",
                cmd = "<cmd>lua require('spectre.actions').run_replace()<CR>",
                desc = "replace all",
            },
            ["change_view_mode"] = {
                map = "m",
                cmd = "<cmd>lua require('spectre').change_view()<CR>",
                desc = "change result view mode",
            },
            ["toggle_ignore_case"] = {
                map = "I",
                cmd = "<cmd>lua require('spectre').change_options('ignore-case')<CR>",
                desc = "toggle ignore case",
            },
            ["toggle_ignore_hidden"] = {
                map = "H",
                cmd = "<cmd>lua require('spectre').change_options('hidden')<CR>",
                desc = "toggle search hidden",
            },
        },
        find_engine = {
            ["rg"] = {
                cmd = "rg",
                args = {
                    "--color=never",
                    "--no-heading",
                    "--with-filename",
                    "--line-number",
                    "--column",
                },
                options = {
                    ["ignore-case"] = {
                        value = "--ignore-case",
                        icon = "[I]",
                        desc = "ignore case",
                    },
                    ["hidden"] = {
                        value = "--hidden",
                        desc = "hidden file",
                        icon = "[H]",
                    },
                },
            },
            ["ag"] = {
                cmd = "ag",
                args = {
                    "--vimgrep",
                    "-s",
                },
                options = {
                    ["ignore-case"] = {
                        value = "-i",
                        icon = "[I]",
                        desc = "ignore case",
                    },
                    ["hidden"] = {
                        value = "--hidden",
                        desc = "hidden file",
                        icon = "[H]",
                    },
                },
            },
        },
        replace_engine = {
            ["sed"] = {
                cmd = "sed",
                args = sed_args,
            },
            options = {
                ["ignore-case"] = {
                    value = "--ignore-case",
                    icon = "[I]",
                    desc = "ignore case",
                },
            },
        },
        default = {
            find = {
                cmd = "rg",
                options = { "ignore-case" },
            },
            replace = {
                cmd = "sed",
            },
        },
        replace_vim_cmd = "cdo",
        is_open_target_win = true, --open file on opener window
        is_insert_mode = false, -- start open panel on is_insert_mode
    })

    vim.keymap.set("n", ";e", "<cmd>lua require('spectre').open()<cr>", { desc = "spectre", noremap = true })
    vim.keymap.set(
        "n",
        ";W",
        "<cmd>lua require('spectre').open_visual({select_word=true})<cr>",
        { desc = "current word spectre", noremap = true }
    )
    vim.keymap.set(
        "x",
        ";v",
        "<cmd>lua require('spectre').open_visual()<cr>",
        { desc = "Spectre visual", noremap = true }
    )
    vim.keymap.set(
        "x",
        ";c",
        "<cmd>lua require('spectre').open_file_search()<cr>",
        { desc = "Spectre file search", noremap = true }
    )
end

function config.sad()
    vim.cmd([[packadd guihua.lua]])
    require("sad").setup({
        diff = "diff-so-fancy", -- you can use `diff`, `diff-so-fancy`
        ls_file = "fd", -- also git ls_file
        exact = false, -- exact match
    })
end
return config
