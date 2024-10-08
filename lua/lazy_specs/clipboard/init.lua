local clipsub = require("core.pack").package

return {

    --  ╭────────────────────────────────────────────────────────────────────╮
    --  │ VeryLazy                                                           │
    --  ╰────────────────────────────────────────────────────────────────────╯
    {
        "yanky.nvim",
        event = "CursorMoved",
        after = function()
            local mapping = require("yanky.telescope.mapping")
            require("yanky").setup({
                ring = {
                    history_length = 100000,
                    storage = "sqlite",
                    sync_with_numbered_registers = true,
                    cancel_event = "update",
                },
                picker = {
                    telescope = {
                        mappings = {
                            default = mapping.put("p"),
                            i = {
                                ["<c-p>"] = mapping.put("p"),
                                ["<c-k>"] = mapping.put("P"),
                                ["<c-x>"] = mapping.delete(),
                            },
                            n = {
                                p = mapping.put("p"),
                                P = mapping.put("P"),
                                d = mapping.delete(),
                            },
                        },
                    },
                },
                system_clipboard = {
                    sync_with_ring = true,
                },
                highlight = {
                    on_put = true,
                    on_yank = true,
                    timer = 200,
                },
                preserve_cursor_position = {
                    enabled = true,
                },
            })
            local default_keymaps = {
                { "n", "y", "<Plug>(YankyYank)" },
                { "x", "y", "<Plug>(YankyYank)" },
            }
            for _, m in ipairs(default_keymaps) do
                vim.keymap.set(m[1], m[2], m[3], {})
            end

            require("telescope").load_extension("yank_history")
            --
            vim.keymap.set("n", "<leader>yu", "<cmd>Telescope yank_history<cr>", { desc = "Yank History" })
            vim.keymap.set(
                "n",
                "<leader>yy",
                "<cmd>:lua require'utils.telescope'.neoclip()<CR>",
                { desc = "NeoClip", silent = true }
            )
        end,
    },

    {
        "smartyank.nvim",
        opt = true,
        after = function()
            require("smartyank").setup({
                highlight = {
                    enabled = true, -- highlight yanked text
                    higroup = "IncSearch", -- highlight group of yanked text
                    timeout = 200, -- timeout for clearing the highlight
                },
                osc52 = {
                    enabled = true,
                    ssh_only = false, -- false to OSC52 yank also in local sessions
                    silent = false, -- true to disable the "n chars copied" echo
                    echo_hl = "Directory", -- highlight group of the OSC52 echo message
                },
            })
        end,
    },

    {
        "substitute.nvim",
        after = function()
            require("substitute").setup({
                on_substitute = require("yanky.integration").substitute(),
                yank_substituted_text = true,
            })
        end,
    },

    {
        "nvim-rip-substitute",
        cmd = "RipSubstitute",
        keys = {
            {
                "<leader>S",
                function()
                    require("rip-substitute").sub()
                end,
                mode = { "n", "x" },
                desc = " rip substitute",
            },
        },
    },

    --  ──────────────────────────────────────────────────────────────────────

    -- start = "gm", -- Mark word / region
    -- start_and_edit = "gM", -- Mark word / region and also edit
    -- start_and_edit_word = "g!M", -- Mark word / region and also edit.  Edit only full word.
    -- start_word = "g!m", -- Mark word / region. Edit only full word
    -- apply_substitute_and_next = "\\m", -- Start substitution / Go to next substitution
    -- apply_substitute_and_prev = "\p", -- same as M but backwards
    -- apply_substitute_all = "\l", -- Substitute all
    {
        "cool-substitute.nvim",
        keys = {
            { "gm", mode = { "n", "v" } },
            "gM",
            "g!M",
            "g!m",
            "\\m",
            "\\p",
            "\\\\a",
            "g!!",
        },
        after = function()
            require("cool-substitute").setup({
                setup_keybindings = true,
                mappings = {
                    start = "gm", -- Mark word / region
                    start_and_edit = "gM", -- Mark word / region and also edit
                    start_and_edit_word = "g!M", -- Mark word / region and also edit.  Edit only full word.
                    start_word = "g!m", -- Mark word / region. Edit only full word
                    apply_substitute_and_next = "\\m", -- Start substitution / Go to next substitution
                    apply_substitute_and_prev = "\\p", -- same as M but backwards
                    apply_substitute_all = "\\\\a", -- Substitute all
                    force_terminate_substitute = "g!!",
                },
                -- reg_char = "o", -- letter to save macro (Dont use number or uppercase here)
                -- mark_char = "t", -- mark the position at start of macro
            })
        end,
    },
    {
        "text-case.nvim",
        opt = true,
    },

    {
        "vim-camelsnek",
        opt = true,
        cmd = { "Snek", "Camel", "CamelB", "Kebab" },
    },

    {
        "undotree",
        keys = {
            {
                "<f2>",
                vim.cmd.UndotreeToggle,
                desc = "UndoTree toggle",
            },
        },
        cmd = { "UndotreeToggle", "UndotreeHide", "UndotreeFocus", "UndotreeShow" },
    },

    {
        "img-clip.nvim",
        cmd = { "PasteImage" },
        opts = {
            default = {
                debug = false, -- enable debug mode
                dir_path = "assets", -- directory path to save images to, can be relative (cwd or current file) or absolute
                file_name = "%Y-%m-%d-%H-%M-%S", -- file name format (see lua.org/pil/22.1.html)
                url_encode_path = false, -- encode spaces and special characters in file path
                use_absolute_path = false, -- expands dir_path to an absolute path
                relative_to_current_file = false, -- make dir_path relative to current file rather than the cwd
                prompt_for_file_name = true, -- ask user for file name before saving, leave empty to use default
                show_dir_path_in_prompt = false, -- show dir_path in prompt when prompting for file name
                use_cursor_in_template = true, -- jump to cursor position in template after pasting
                insert_mode_after_paste = true, -- enter insert mode after pasting the markup code
                embed_image_as_base64 = false, -- paste image as base64 string instead of saving to file
                max_base64_size = 10, -- max size of base64 string in KB
                template = "$FILE_PATH", -- default template

                drag_and_drop = {
                    enabled = true, -- enable drag and drop mode
                    insert_mode = false, -- enable drag and drop in insert mode
                    copy_images = false, -- copy images instead of using the original file
                    download_images = true, -- download images and save them to dir_path instead of using the URL
                },
            },

            -- file-type specific options
            -- any options that are passed here will override the default config
            -- for instance, setting use_absolute_path = true for markdown will
            -- only enable that for this particular file type
            -- the key (e.g. "markdown") is the filetype (output of "set filetype?")

            markdown = {
                url_encode_path = true,
                template = "![$CURSOR]($FILE_PATH)",

                drag_and_drop = {
                    download_images = false,
                },
            },

            html = {
                template = '<img src="$FILE_PATH" alt="$CURSOR">',
            },

            tex = {
                template = [[
\begin{figure}[h]
  \centering
  \includegraphics[width=0.8\textwidth]{$FILE_PATH}
  \caption{$CURSOR}
  \label{fig:$LABEL}
\end{figure}
    ]],
            },

            typst = {
                template = [[
#figure(
  image("$FILE_PATH", width: 80%),
  caption: [$CURSOR],
) <fig-$LABEL>
    ]],
            },

            rst = {
                template = [[
.. image:: $FILE_PATH
   :alt: $CURSOR
   :width: 80%
    ]],
            },

            asciidoc = {
                template = 'image::$FILE_PATH[width=80%, alt="$CURSOR"]',
            },

            org = {
                template = [=[
#+BEGIN_FIGURE
[[file:$FILE_PATH]]
#+CAPTION: $CURSOR
#+NAME: fig:$LABEL
#+END_FIGURE
    ]=],
            },
            norg = {
                template = [=[
        .image $FILE_PATH $CURSOR
        ]=],
            },
        },
        keys = {
            -- suggested keymap
            { "<leader>P", "<cmd>PasteImage<cr>", desc = "Paste clipboard image" },
        },
    },

    {
        "nvim-neoclip.lua",
        after = function()
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
        end,
    },

    {
        "multicursors.nvim",
        cmd = {
            "MCstart",
            "MCvisual",
            "MCpattern",
            "MCvisualPattern",
            "MCunderCursor",
            "MCclear",
        },
        after = function()
            local N = require("multicursors.normal_mode")
            local I = require("multicursors.insert_mode")

            local opt = {
                normal_keys = {
                    -- to change default lhs of key mapping change the key
                    [","] = {
                        -- assigning nil to method exits from multi cursor mode
                        method = N.clear_others,
                        -- you can pass :map-arguments here
                        opts = { desc = "Clear others" },
                    },
                },
                insert_keys = {
                    -- to change default lhs of key mapping change the key
                    ["<CR>"] = {
                        -- assigning nil to method exits from multi cursor mode
                        method = I.Cr_method,
                        -- you can pass :map-arguments here
                        opts = { desc = "New line" },
                    },
                },
                generate_hints = {
                    normal = true,
                    insert = true,
                    extend = true,
                },
            }
            require("multicursors").setup(opts)
        end,
    },
    {
        "yanki.nvim",
        keys = {
            {
                "<leader>p",
                vim.cmd.PutNextLine,
                desc = "PutNextLine",
            },
            {
                "<leader>yl",
                vim.cmd.ShowYankHistory,
                desc = "ShowYankHistory",
            },
            {
                "<leader>yc",
                vim.cmd.CleanYankHistory,
                desc = "CleanYankHistory",
            },
            {
                "<leader>yt",
                vim.cmd.ShowTransformers,
                desc = "ShowTransformers",
            },
        },

        after = function()
            require("yanki").setup({
                transformer = {
                    {
                        name = "Split by new line",
                        action = function(text)
                            return vim.fn.split(text, "\n")
                        end,
                        active = true,
                    },
                    {
                        name = "Surround with register a",
                        action = function(text)
                            local closings = {
                                ["("] = ")",
                                ["["] = "]",
                                ["{"] = "}",
                                ["<"] = ">",
                            }
                            local surroundWith = vim.fn.getreg("a", 1)
                            local surroundEnd = closings[surroundWith] or surroundWith

                            text = surroundWith .. text .. surroundEnd
                            return text
                        end,
                        active = false,
                    },
                    {
                        name = "Add to table in register b",
                        action = function(text)
                            local tableName = vim.fn.getreg("b", 1)
                            return "table.insert(" .. tableName .. "," .. text .. ")"
                        end,
                        active = false,
                    },
                    {
                        name = "Replace placeholder(reg c) in template (reg d)",
                        action = function(text)
                            local placeholder = vim.fn.getreg("c", 1)
                            local template = vim.fn.getreg("d", 1)
                            return string.gsub(template, placeholder, text)
                        end,
                        active = false,
                    },
                },
            })
        end,
    },
}
