local clipsub = require("core.pack").package
local conf = require("modules.clipboard.config")
--  ╭────────────────────────────────────────────────────────────────────╮
--  │ VeryLazy                                                           │
--  ╰────────────────────────────────────────────────────────────────────╯

clipsub({
    "gbprod/yanky.nvim",
    lazy = true,
    config = conf.config_yanky,
    dependencies = {

        "nvim-telescope/telescope.nvim",
        "kkharji/sqlite.lua",
        {
            "ibhagwan/smartyank.nvim",
            config = conf.smart_yank,
        },
    },
})

clipsub({
    "gbprod/substitute.nvim",
    lazy = true,
    dependencies = "gbprod/yanky.nvim",
    config = conf.substitute,
})

clipsub({
    "chrisgrieser/nvim-alt-substitute",
    opts = {
        showNotification = true, -- whether to show the "x replacements made" notification
    },
    event = "CmdlineEnter",
})

--  ──────────────────────────────────────────────────────────────────────

-- start = "gm", -- Mark word / region
-- start_and_edit = "gM", -- Mark word / region and also edit
-- start_and_edit_word = "g!M", -- Mark word / region and also edit.  Edit only full word.
-- start_word = "g!m", -- Mark word / region. Edit only full word
-- apply_substitute_and_next = "\\m", -- Start substitution / Go to next substitution
-- apply_substitute_and_prev = "\p", -- same as M but backwards
-- apply_substitute_all = "\l", -- Substitute all
clipsub({
    "otavioschwanck/cool-substitute.nvim",
    lazy = true,
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
    config = conf.cool_sub,
})
clipsub({
    "johmsalas/text-case.nvim",
    lazy = true,
    config = conf.text_case,
})

clipsub({
    "nicwest/vim-camelsnek",
    lazy = true,
    cmd = { "Snek", "Camel", "CamelB", "Kebab" },
})

clipsub({
    "mbbill/undotree",
    lazy = true,
    keys = {
        {
            "<f2>",
            vim.cmd.UndotreeToggle,
            desc = "UndoTree toggle",
        },
    },
    cmd = { "UndotreeToggle", "UndotreeHide", "UndotreeFocus", "UndotreeShow" },
})

clipsub({
    "HakonHarnes/img-clip.nvim",
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
})

clipsub({
    "AckslD/nvim-neoclip.lua",
    lazy = true,
    dependencies = { "kkharji/sqlite.lua" },
    config = conf.neoclip,
})

clipsub({
    "smoka7/multicursors.nvim",
    lazy = true,
    cmd = {
        "MCstart",
        "MCvisual",
        "MCpattern",
        "MCvisualPattern",
        "MCunderCursor",
        "MCclear",
    },
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
    },
    opts = function()
        local N = require("multicursors.normal_mode")
        local I = require("multicursors.insert_mode")

        return {
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
    end,
})

clipsub({
    "RomanoZumbe/yanki.nvim",
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

    config = function()
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
})
