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
