local config = {}

function config.telescope()
    require("utils.telescope").setup()
    require("telescope").load_extension("fzf")
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

    lambda.command("GF", "FzfLua git_status", {})
    lambda.command("Gf", "FzfLua git_status", {})
    lambda.command("B", "FzfLua buffers", { bang = true })
    lambda.command("Com", "FzfLua commands", { bang = true })
    lambda.command("Col", "FzfLua colorschemems", { bang = true })
    lambda.command("RG", "FzfLua grep", { bang = true })
end

function config.spectre()
    local spectre = require("spectre")

    spectre.setup({
        color_devicons = true,
        highlight = {
            ui = "String",
            search = "DiffChange",
            replace = "DiffDelete",
        },
    })

    lambda.command("Spectre", "lua require('spectre').open()", {})
    lambda.command("SpectreToggleLine", "lua require('spectre').toggle_line()", {})
    lambda.command("SpectreSelectEntry", "lua require('spectre.actions').select_entry()", {})

    lambda.command("SpectreRunCurrentReplace", "lua require('spectre.actions').run_current_replace()", {})
    lambda.command("SpectreRunReplace", "lua require('spectre.actions').run_replace()", {})
    lambda.command("SpectreSendToQF", "lua require('spectre.actions').send_to_qf()", {})
    lambda.command("SpectreReplaceCommand", "lua require('spectre.actions').replace_cmd()", {})
    lambda.command("SpectreToggleLiveUpdate", "lua require('spectre').toggle_live_update()", {})
    lambda.command("SpectreChangeView", "lua require('spectre').change_view()", {})
    lambda.command("SpectreResumeLastSearch", "lua require('spectre').resume_last_search()", {})
    lambda.command("SpectreIgnoreCase", "lua require('spectre').change_options('ignore-case')", {})
    lambda.command("SpectreHidden", "lua require('spectre').change_options('hidden')", {})
    lambda.command("SpectreShowOptions", "lua require('spectre').show_options()", {})

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

return config
