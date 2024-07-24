local actions = require("telescope.actions")
local previewers = require("telescope.previewers")
local state = require("telescope.state")
local action_set = require("telescope.actions.set")
local action_layout = require("telescope.actions.layout")
local actions_layout = require("telescope.actions.layout")
local action_state = require("telescope.actions.state")

local function flash(prompt_bufnr)
    if lambda.config.movement.movement_type == "flash" then
        require("flash").jump({
            pattern = "^",
            highlight = { label = { after = { 0, 0 } } },
            search = {
                mode = "search",
                exclude = {
                    function(win)
                        return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "TelescopeResults"
                    end,
                },
            },
            action = function(match)
                local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
                picker:set_selection(match.pos[1] - 1)
            end,
        })
    else
        vim.notify(
            "you have reverted back to leap , but you =did not code this up yet, please insert the codeed version of this search"
        )
    end
end
local function rectangular_border(opts)
    return vim.tbl_deep_extend("force", opts or {}, {
        borderchars = {
            prompt = { "─", "│", " ", "│", "┌", "┐", "│", "│" },
            results = { "─", "│", "─", "│", "├", "┤", "┘", "└" },
            preview = { "▔", "▕", "▁", "▏", "🭽", "🭾", "🭿", "🭼" },
        },
    })
end
function dropdown(opts)
    return require("telescope.themes").get_dropdown(rectangular_border(opts))
end

function ivy(opts)
    return require("telescope.themes").get_ivy(vim.tbl_deep_extend("keep", opts or {}, {
        borderchars = {
            preview = { "▔", "▕", "▁", "▏", "🭽", "🭾", "🭿", "🭼" },
        },
    }))
end
local custom_actions = {}

function custom_actions.send_to_qflist(prompt_bufnr)
    require("telescope.actions").send_to_qflist(prompt_bufnr)
    require("user").qflist.open()
end

function custom_actions.smart_send_to_qflist(prompt_bufnr)
    require("telescope.actions").smart_send_to_qflist(prompt_bufnr)
    require("user").qflist.open()
end

function custom_actions.fzf_multi_select(prompt_bufnr)
    local picker = action_state.get_current_picker(prompt_bufnr)
    local num_selections = table.getn(picker:get_multi_selection())

    if num_selections > 1 then
        -- actions.file_edit throws - context of picker seems to change
        -- actions.file_edit(prompt_bufnr)
        actions.send_selected_to_qflist(prompt_bufnr)
        actions.open_qflist()
    else
        actions.file_edit(prompt_bufnr)
    end
end

-- Amazing Layout taken from https://github.com/max397574/NeovimConfig/blob/2267d7dfa8a30148516e2f5a6bb0e5ecc5de2c3c/lua/configs/telescope.lua
local set_prompt_to_entry_value = function(prompt_bufnr)
    local entry = action_state.get_selected_entry()
    if not entry or not type(entry) == "table" then
        return
    end

    action_state.get_current_picker(prompt_bufnr):reset_prompt(entry.ordinal)
end

local Job = require("plenary.job")
local new_maker = function(filepath, bufnr, opts)
    filepath = vim.fn.expand(filepath)
    Job:new({
        command = "file",
        args = { "--mime-type", "-b", filepath },
        on_exit = function(j)
            local mime_class = vim.split(j:result()[1], "/")[1]
            local mime_type = j:result()[1]
            if
                mime_class == "text"
                or (mime_class == "application" and mime_type ~= "application/x-pie-executable")
            then
                previewers.buffer_previewer_maker(filepath, bufnr, opts)
            else
                -- maybe we want to write something to the buffer here
                vim.schedule(function()
                    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "BINARY" })
                end)
            end
        end,
    }):sync()
end

local M = {}
M.multi_selection_open_vsplit = function(prompt_bufnr)
    M._multiopen(prompt_bufnr, "vsplit")
end
M.multi_selection_open_split = function(prompt_bufnr)
    M._multiopen(prompt_bufnr, "split")
end
M.multi_selection_open_tab = function(prompt_bufnr)
    M._multiopen(prompt_bufnr, "tabe")
end
M.multi_selection_open = function(prompt_bufnr)
    M._multiopen(prompt_bufnr, "edit")
end

M.setup = function()
    local icons = lambda.style.icons
    require("telescope").setup({
        defaults = {
            borderchars = {
                prompt = { " ", "▕", "▁", "▏", "▏", "▕", "🭿", "🭼" },
                results = { "▔", "▕", "▁", "▏", "🭽", "🭾", "🭿", "🭼" },
                preview = { "▔", "▕", "▁", "▏", "🭽", "🭾", "🭿", "🭼" },
            },
            preview = {
                hide_on_startup = true,
            },
            buffer_previewer_maker = new_maker,
            dynamic_preview_title = fa,
            prompt_prefix = icons.misc.telescope .. " ",
            selection_caret = icons.misc.chevron_right .. " ",
            cycle_layout_list = { "flex", "horizontal", "vertical", "bottom_pane", "center" },
            mappings = {
                n = {
                    s = flash,
                    ["q"] = actions.close,
                    ["<C-j>"] = actions.move_selection_next,
                    ["<C-k>"] = actions.move_selection_previous,
                    ["<C-o>"] = actions.select_vertical,
                    ["<C-Q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                    ["<C-a>"] = actions.send_to_qflist + actions.open_qflist,
                    ["<C-h>"] = "which_key",
                    ["<C-l>"] = actions_layout.toggle_preview,
                    -- ["<C-y>"] = set_prompt_to_entry_value,
                    ["<C-u>"] = actions.preview_scrolling_up,
                    ["<C-d>"] = actions.preview_scrolling_down,
                    ["<C-f>"] = require("telescope.actions").cycle_history_prev,

                    ["<c-v>"] = custom_actions.multi_selection_open_vsplit,
                    ["<c-S>"] = custom_actions.multi_selection_open_split,
                    ["<c-t>"] = custom_actions.multi_selection_open_tab,

                    ["<C-n>"] = function(prompt_bufnr)
                        local results_win = state.get_status(prompt_bufnr).results_win
                        local height = vim.api.nvim_win_get_height(results_win)
                        action_set.shift_selection(prompt_bufnr, math.floor(height / 2))
                    end,

                    ["<C-s>"] = function(prompt_bufnr)
                        local results_win = state.get_status(prompt_bufnr).results_win
                        local height = vim.api.nvim_win_get_height(results_win)
                        action_set.shift_selection(prompt_bufnr, -math.floor(height / 2))
                    end,

                    ["<cr>"] = custom_actions.multi_selection_open,
                },

                i = {
                    ["<c-v>"] = custom_actions.multi_selection_open_vsplit,
                    ["<c-s>"] = custom_actions.multi_selection_open_split,
                    ["<c-t>"] = custom_actions.multi_selection_open_tab,
                    ["<C-j>"] = actions.move_selection_next,
                    ["<c-o>"] = action_layout.toggle_prompt_position,
                    ["<C-k>"] = actions.move_selection_previous,
                    ["<C-y>"] = set_prompt_to_entry_value,
                    ["<C-o>"] = actions.select_vertical,
                    ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                    ["<C-a>"] = actions.send_to_qflist + actions.open_qflist,
                    ["<c-l>"] = flash,
                    ["<C-w>"] = "which_key",
                    ["<C-l>"] = actions_layout.toggle_preview,

                    ["<C-d>"] = actions.preview_scrolling_down,
                    ["<C-u>"] = actions.preview_scrolling_up,

                    ["<C-n>"] = function(prompt_bufnr)
                        local results_win = state.get_status(prompt_bufnr).results_win
                        local height = vim.api.nvim_win_get_height(results_win)
                        action_set.shift_selection(prompt_bufnr, math.floor(height / 2))
                    end,
                    ["<C-p>"] = function(prompt_bufnr)
                        local results_win = state.get_status(prompt_bufnr).results_win
                        local height = vim.api.nvim_win_get_height(results_win)
                        action_set.shift_selection(prompt_bufnr, -math.floor(height / 2))
                    end,
                },
            },
            file_ignore_patterns = {
                "%.jpg",
                "%.jpeg",
                "%.png",
                "%.otf",
                "%.ttf",
                "%.DS_Store",
                "^.git/",
                "^node_modules/",
                "^site-packages/",
                "^abbreviations/",
                "abbreviations/",
                "abbreviations",
            },
            history = {
                path = vim.fn.stdpath("data") .. "/telescope_history.sqlite3",
            },
            layout_strategy = "flex",
            layout_config = {
                horizontal = {
                    preview_width = 0.55,
                },
            },
            extensions = {

                file_browser = {
                    -- theme = "ivy",
                    mappings = {
                        ["i"] = {},
                        ["n"] = {},
                    },
                },
                ast_grep = {
                    command = {
                        "ast-grep",
                        "--json=stream",
                    }, -- must have --json and -p
                    grep_open_files = false, -- search in opened files
                    lang = nil, -- string value, specify language for ast-grep `nil` for default
                },
                frecency = {
                    default_workspace = "CWD",
                    show_unindexed = false, -- Show all files or only those that have been indexed
                    ignore_patterns = { "*.git/*", "*/tmp/*", "*node_modules/*", "*vendor/*" },
                    workspaces = {
                        conf = vim.env.DOTFILES,
                        project = vim.env.PROJECTS_DIR,
                    },
                },
                fzf = {
                    fuzzy = true, -- false will only do exact matching
                    override_generic_sorter = true, -- override the generic sorter
                    override_file_sorter = true, -- override the file sorter
                    case_mode = "smart_case", -- or "ignore_case" or "respect_case"
                    -- the default case_mode is "smart_case"
                },
                egrepify = {
                    prefixes = {
                        ["!"] = {
                            flag = "invert-match",
                        },
                    },
                },
            },
            pickers = {

                buffers = {
                    sort_mru = true,
                    sort_lastused = true,
                    show_all_buffers = true,
                    ignore_current_buffer = true,
                    previewer = false,
                    mappings = {
                        i = { ["<c-x>"] = "delete_buffer" },
                        n = { ["<c-x>"] = "delete_buffer" },
                    },
                },
                oldfiles = dropdown(),
                live_grep = {
                    file_ignore_patterns = { ".git/", "%.svg", "%.lock" },
                    max_results = 2000,
                },
                current_buffer_fuzzy_find = {
                    previewer = false,
                    shorten_path = false,
                },
                colorscheme = {
                    enable_preview = true,
                },
                find_files = {
                    hidden = true,
                },
                keymaps = {
                    layout_config = {
                        height = 18,
                        width = 0.5,
                    },
                },
                git_branches = dropdown(),
                git_bcommits = {
                    layout_config = {
                        horizontal = {
                            preview_width = 0.55,
                        },
                    },
                },
                git_commits = {
                    layout_config = {
                        horizontal = {
                            preview_width = 0.55,
                        },
                    },
                },
                reloader = dropdown(),
            },
            --
        },
    })
end

return M
