local config = {}

function config.telescope()
    require("modules.search.telescope.telescope").setup()

    local plugins = {
        "telescope-live-grep-args.nvim",
        "telescope-frecency.nvim",
        "telescope-file-browser.nvim",
        "telescope-conda.nvim",
        "telescope-bookmarks.nvim",
        "telescope-sg",
        "telescope-egrepify.nvim",
    }
    for _, v in ipairs(plugins) do
        require("lazy").load({ plugins = { v } })
    end
    require("telescope").setup({
        extensions = {
            conda = { anaconda_path = "/home/viv/.conda/" },
            bookmarks = {
                selected_browser = "firefox",
                url_open_command = "open",
                profile_name = "default-nightly-1",
                url_open_plugin = nil,
                full_path = true,
                buku_include_tags = false,
                debug = false,
            },
        },
    })
    require("telescope").load_extension("fzf")
    require("telescope").load_extension("file_browser")
    require("telescope").load_extension("egrepify")
end

function config.fzf()
    local fzf = require("fzf-lua")

    fzf.setup({
        fzf_opts = {
            ["--info"] = "default", -- hidden OR inline:⏐
            ["--reverse"] = false,
            ["--layout"] = "default",
            ["--scrollbar"] = "▓",
        },
        fzf_colors = {
            ["fg"] = { "fg", "CursorLine" },
            ["bg"] = { "bg", "Normal" },
            ["hl"] = { "fg", "Comment" },
            ["fg+"] = { "fg", "Normal" },
            ["bg+"] = { "bg", "PmenuSel" },
            ["hl+"] = { "fg", "Statement", "italic" },
            ["info"] = { "fg", "Comment", "italic" },
            ["prompt"] = { "fg", "Underlined" },
            ["pointer"] = { "fg", "Exception" },
            ["marker"] = { "fg", "@character" },
            ["spinner"] = { "fg", "DiagnosticOk" },
            ["header"] = { "fg", "Comment" },
            ["gutter"] = { "bg", "Normal" },
            ["separator"] = { "fg", "Comment" },
        },
        previewers = {
            builtin = { toggle_behavior = "extend" },
        },
        winopts = {
            hl = { border = "PickerBorder" },
        },
        keymap = {
            builtin = {
                ["<c-/>"] = "toggle-help",
                ["<c-e>"] = "toggle-preview",
                ["<c-=>"] = "toggle-fullscreen",
                ["<c-f>"] = "preview-page-down",
                ["<c-b>"] = "preview-page-up",
            },
            fzf = {
                ["esc"] = "abort",
            },
        },
    })

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
    vim.api.nvim_create_user_command("Spectre", "lua require('spectre').open()", {})
    vim.api.nvim_create_user_command("SpectreToggleLine", "lua require('spectre').toggle_line()", {})
    vim.api.nvim_create_user_command("SpectreSelectEntry", "lua require('spectre.actions').select_entry()", {})
    vim.api.nvim_create_user_command(
        "SpectreRunCurrentReplace",
        "lua require('spectre.actions').run_current_replace()",
        {}
    )
    vim.api.nvim_create_user_command("SpectreRunReplace", "lua require('spectre.actions').run_replace()", {})
    vim.api.nvim_create_user_command("SpectreSendToQF", "lua require('spectre.actions').send_to_qf()", {})
    vim.api.nvim_create_user_command("SpectreReplaceCommand", "lua require('spectre.actions').replace_cmd()", {})
    vim.api.nvim_create_user_command("SpectreToggleLiveUpdate", "lua require('spectre').toggle_live_update()", {})
    vim.api.nvim_create_user_command("SpectreChangeView", "lua require('spectre').change_view()", {})
    vim.api.nvim_create_user_command("SpectreResumeLastSearch", "lua require('spectre').resume_last_search()", {})
    vim.api.nvim_create_user_command("SpectreIgnoreCase", "lua require('spectre').change_options('ignore-case')", {})
    vim.api.nvim_create_user_command("SpectreHidden", "lua require('spectre').change_options('hidden')", {})
    vim.api.nvim_create_user_command("SpectreShowOptions", "lua require('spectre').show_options()", {})

    vim.keymap.set("n", "<A-s>", function()
        vim.cmd("Spectre")
    end, { noremap = true, silent = true, desc = "Spectre" })
end

function config.sad()
    vim.cmd([[Lazy load guihua.lua]])
    require("sad").setup({
        diff = "diff-so-fancy", -- you can use `diff`, `diff-so-fancy`
        ls_file = "fd", -- also git ls_file
        exact = false, -- exact match
    })
end

function config.easypick()
    local easypick = require("easypick")
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")
    local base_branch = "main"
    local list = [[
    << EOF
    :Easypick changed_files
    :Easypick conflicts
    :Easypick config_files
    EOF
    ]]
    local custom_pickers = {
        {
            name = "ls",
            command = "ls",
            previewer = easypick.previewers.default(),
        },
        {
            name = "changed_files",
            command = "git diff --name-only $(git merge-base HEAD " .. base_branch .. " )",
            previewer = easypick.previewers.branch_diff({ base_branch = base_branch }),
        },
        {
            name = "conflicts",
            command = "git diff --name-only --diff-filter=U --relative",
            previewer = easypick.previewers.file_diff(),
        },
        {
            name = "config_files",
            command = "fd -i -t=f --search-path=" .. vim.fn.expand("$NVIM_CONFIG"),
            previewer = easypick.previewers.default(),
        },
        {
            name = "command_palette",
            command = "cat " .. list,
            action = easypick.actions.run_nvim_command,
            opts = require("telescope.themes").get_dropdown({}),
        },
    }

    easypick.setup({ pickers = custom_pickers })
end

function config.vmulti()
    vim.g.VM_mouse_mappings = 1
    -- mission control takes <C-up/down> so remap <M-up/down> to <C-Up/Down>
    -- vim.api.nvim_set_keymap("n", "<M-n>", "<C-n>", {silent = true})
    -- vim.api.nvim_set_keymap("n", "<M-Down>", "<C-Down>", {silent = true})
    -- vim.api.nvim_set_keymap("n", "<M-Up>", "<C-Up>", {silent = true})
    -- for mac C-L/R was mapped to mission control
    -- print('vmulti')
    vim.g.VM_silent_exit = 1
    vim.g.VM_show_warnings = 0
    vim.g.VM_default_mappings = 1
    vim.g.VM_highlight_matches = "underline"
    vim.g.VM_theme = "codedark"
    vim.cmd([[
      let g:VM_maps = {}
      let g:VM_maps['Find Under'] = '<C-n>'
      let g:VM_maps['Find Subword Under'] = '<C-n>'
      let g:VM_maps['Select All'] = '<C-n>a'
      let g:VM_maps['Seek Next'] = 'n'
      let g:VM_maps['Seek Prev'] = 'N'
      let g:VM_maps["Undo"] = 'u'
      let g:VM_maps["Redo"] = '<C-r>'
      let g:VM_maps["Remove Region"] = '<cr>'
      let g:VM_maps["Add Cursor Down"] = '<M-Down>'
      let g:VM_maps["Add Cursor Up"] = "<M-Up>"

      let g:VM_maps["Mouse Cursor"] = "<c-LeftMouse>"
      let g:VM_maps["Mouse Word"] = "<c-RightMouse>"

      let g:VM_maps["Add Cursor At Pos"] = '<M-i>'

    aug VMlens
        au!
        au User visual_multi_start lua require('vmlens').start()
        au User visual_multi_exit lua require('vmlens').exit()
    aug END

  ]])
end

return config
