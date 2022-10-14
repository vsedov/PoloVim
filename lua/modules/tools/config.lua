local config = {}

function config.nvimdev()
    vim.g.nvimdev_auto_ctags = 1
    vim.g.nvimdev_auto_lint = 1
end

function config.fm()
    require("fm-nvim").setup({

        ui = {
            float = {
                border = lambda.style.border.type_0,
            },
        },
    })
end

function config.harpoon()
    require("harpoon").setup({

        global_settings = {
            save_on_toggle = true,
            save_on_change = true,
            enter_on_sendcmd = true,
            tmux_autoclose_windows = false,
            excluded_filetypes = { "harpoon" },
            mark_branch = false,
        },
    })
    require("telescope").load_extension("harpoon")
end

function config.workspace()
    require("workspaces").setup({
        global_cd = true,
        sort = true,
        notify_info = true,

        hooks = {
            open = { "Neotree", "Telescope find_files" },
        },
    })
    require("telescope").load_extension("workspaces")
end

function config.paperplanes()
    require("paperplanes").setup({
        register = "+",
        provider = "ix.io",
    })
end

function config.vim_vista()
    vim.g["vista#renderer#enable_icon"] = 1
    vim.g.vista_disable_statusline = 1

    vim.g.vista_default_executive = "nvim_lsp" -- ctag
    vim.g.vista_echo_cursor_strategy = "floating_win"
    vim.g.vista_vimwiki_executive = "markdown"
    vim.g.vista_executive_for = {
        vimwiki = "markdown",
        pandoc = "markdown",
        markdown = "toc",
        typescript = "nvim_lsp",
        typescriptreact = "nvim_lsp",
        go = "nvim_lsp",
        lua = "nvim_lsp",
    }

    -- vim.g['vista#renderer#icons'] = {['function'] = "", ['method'] = "ℱ", variable = "כֿ"}
end

function config.spelunker()
    -- vim.cmd("command! Spell call spelunker#check()")
    vim.g.enable_spelunker_vim_on_readonly = 0
    vim.g.spelunker_target_min_char_len = 5
    vim.g.spelunker_check_type = 2
    vim.g.spelunker_highlight_type = 2
    vim.g.spelunker_disable_uri_checking = 1
    vim.g.spelunker_disable_account_name_checking = 1
    vim.g.spelunker_disable_email_checking = 1
    -- vim.cmd("highlight SpelunkerSpellBad cterm=underline ctermfg=247 gui=undercurl guifg=#F3206e guisp=#EF3050")
    -- vim.cmd("highlight SpelunkerComplexOrCompoundWord cterm=underline gui=undercurl guisp=#EF3050")
    vim.cmd("highlight def link SpelunkerSpellBad SpellBad")
    vim.cmd("highlight def link SpelunkerComplexOrCompoundWord Rare")
end

function config.spellcheck()
    vim.cmd("highlight def link SpelunkerSpellBad SpellBad")
    vim.cmd("highlight def link SpelunkerComplexOrCompoundWord Rare")

    vim.fn["spelunker#check"]()
end

function config.grammcheck()
    -- body
    if not packer_plugins["rhysd/vim-grammarous"] or not packer_plugins["rhysd/vim-grammarous"].loaded then
        require("packer").loader("vim-grammarous")
    end
    vim.cmd([[GrammarousCheck]])
end

function config.markdown()
    vim.g.vim_markdown_frontmatter = 1
    vim.g.vim_markdown_strikethrough = 1
    vim.g.vim_markdown_folding_level = 6
    vim.g.vim_markdown_override_foldtext = 1
    vim.g.vim_markdown_folding_style_pythonic = 1
    vim.g.vim_markdown_conceal = 1
    vim.g.vim_markdown_conceal_code_blocks = 1
    vim.g.vim_markdown_new_list_item_indent = 0
    vim.g.vim_markdown_toc_autofit = 0
    vim.g.vim_markdown_edit_url_in = "vsplit"
    vim.g.vim_markdown_strikethrough = 1
    vim.g.vim_markdown_fenced_languages = {
        "c++=javascript",
        "js=javascript",
        "json=javascript",
        "jsx=javascript",
        "tsx=javascript",
    }
end

function config.clipboardimage()
    require("clipboard-image").setup({
        default = {
            img_name = function()
                vim.fn.inputsave()
                local name = vim.fn.input("Name: ")
                vim.fn.inputrestore()

                if name == nil or name == "" then
                    return os.date("%y-%m-%d-%H-%M-%S")
                end
                return name
            end,
        },
    })
end

function config.mkdp()
    -- print("mkdp")
    vim.g.mkdp_command_for_global = 1
    vim.cmd(
        [[let g:mkdp_preview_options = { 'mkit': {}, 'katex': {}, 'uml': {}, 'maid': {}, 'disable_sync_scroll': 0, 'sync_scroll_type': 'middle', 'hide_yaml_meta': 1, 'sequence_diagrams': {}, 'flowchart_diagrams': {}, 'content_editable': v:true, 'disable_filename': 0 }]]
    )
end
function config.wakatime()
    vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "*",
        callback = function()
            if lambda.config.record_your_self then
                require("packer").loader("vim-wakatime")
            end
        end,
        once = true,
    })
end

function config.bqf()
    local fn = vim.fn

    function _G.qftf(info)
        local items
        local ret = {}
        if info.quickfix == 1 then
            items = fn.getqflist({ id = info.id, items = 0 }).items
        else
            items = fn.getloclist(info.winid, { id = info.id, items = 0 }).items
        end
        local limit = 31
        local fnameFmt1, fnameFmt2 = "%-" .. limit .. "s", "…%." .. (limit - 1) .. "s"
        local validFmt = "%s │%5d:%-3d│%s %s"
        for i = info.start_idx, info.end_idx do
            local e = items[i]
            local fname = ""
            local str
            if e.valid == 1 then
                if e.bufnr > 0 then
                    fname = fn.bufname(e.bufnr)
                    if fname == "" then
                        fname = "[No Name]"
                    else
                        fname = fname:gsub("^" .. vim.env.HOME, "~")
                    end
                    -- char in fname may occur more than 1 width, ignore this issue in order to keep performance
                    if #fname <= limit then
                        fname = fnameFmt1:format(fname)
                    else
                        fname = fnameFmt2:format(fname:sub(1 - limit))
                    end
                end
                local lnum = e.lnum > 99999 and -1 or e.lnum
                local col = e.col > 999 and -1 or e.col
                local qtype = e.type == "" and "" or " " .. e.type:sub(1, 1):upper()
                str = validFmt:format(fname, lnum, col, qtype, e.text)
            else
                str = e.text
            end
            table.insert(ret, str)
        end
        return ret
    end

    vim.o.qftf = "{info -> v:lua._G.qftf(info)}"

    require("bqf").setup({
        auto_enable = true,
        auto_resize_height = true,
        preview = {
            win_height = 12,
            win_vheight = 12,
            delay_syntax = 80,
            border_chars = { "┃", "┃", "━", "━", "┏", "┓", "┗", "┛", "█" },
        },
        func_map = { vsplit = "", ptogglemode = "z,", stoggleup = "" },
        filter = {
            fzf = {
                action_for = { ["ctrl-s"] = "split" },
                extra_opts = { "--bind", "ctrl-o:toggle-all", "--prompt", "> " },
            },
        },
    })
    local function tabDropHandler()
        require("bqf.qfwin.handler").open(true, "TabDrop")
    end

    local function setItemMappings()
        vim.keymap.set("n", "<2-LeftMouse>", tabDropHandler, { buffer = true })
    end

    vim.api.nvim_create_augroup("BqfMappings", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
        group = "BqfMappings",
        pattern = "qf",
        callback = setItemMappings,
    })

    require("utils.ui.highlights").plugin("bqf", { { BqfPreviewBorder = { link = "WinSeparator" } } })
end

function config.neoclip()
    require("neoclip").setup({
        history = 2000,
        enable_persistent_history = true,
        db_path = vim.fn.stdpath("data") .. "/databases/neoclip.sqlite3",
        filter = nil,
        preview = true,
        default_register = "a extra=star,plus,unnamed,b",
        default_register_macros = "q",
        enable_macro_history = true,
        content_spec_column = true,
        on_paste = {
            set_reg = false,
        },
        on_replay = {
            set_reg = false,
        },
        keys = {
            telescope = {
                i = {
                    select = "<cr>",
                    paste = "<c-p>",
                    paste_behind = "<c-k>",
                    replay = "<c-q>",
                    custom = {},
                },
                n = {
                    select = "<cr>",
                    paste = "p",
                    paste_behind = "P",
                    replay = "q",
                    custom = {},
                },
            },
        },
    })
end

function config.live_command()
    require("live-command").setup({
        commands = {
            Reg = {
                cmd = "norm",
                -- This will transform ":5Reg a" into ":norm 5@a"
                args = function(opts)
                    return (opts.count == -1 and "" or opts.count) .. "@" .. opts.args
                end,
                range = "",
            },
            Norm = { cmd = "norm" },
        },
    })
end

return config
