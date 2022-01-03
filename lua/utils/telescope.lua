local a = vim.api

local loader = require("packer").loader
if not packer_plugins["telescope.nvim"].loaded then
  loader("telescope.nvim")
end
local telescope = require("telescope")
local actions = require("telescope.actions")
local conf = require("telescope.config").values

local layout = require("telescope.pickers.layout_strategies")
local resolve = require("telescope.config.resolve")
local make_entry = require("telescope.make_entry")
local previewers = require("telescope.previewers")
local sorters = require("telescope.sorters")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local builtin = require("telescope.builtin")
local state = require("telescope.state")
local action_set = require("telescope.actions.set")
local themes = require("telescope.themes")

local actions = require("telescope.actions")
local actions_layout = require("telescope.actions.layout")
local action_state = require("telescope.actions.state")

M = {}

-- lua require("utils.telescope").find_dots()
M.find_dots = function(opts)
  opts = opts or {}

  opts.cwd = require("core.global").home
  -- By creating the entry maker after the cwd options,
  -- we ensure the maker uses the cwd options when being created.
  opts.entry_maker = opts.entry_maker or make_entry.gen_from_file(opts)

  pickers.new(opts, {
    prompt_title = "~~ Dotfiles ~~",
    finder = finders.new_oneshot_job({
      "git",
      "--git-dir=" .. require("core.global").home .. "/.dots/",
      "--work-tree=" .. require("core.global").home,
      "ls-tree",
      "--full-tree",
      "-r",
      "--name-only",
      "HEAD",
    }, opts),
    previewer = previewers.cat.new(opts),
    sorter = conf.file_sorter(opts),
  }):find()
end

-- lua require("utils.telescope").files()
M.files = function(opts)
  opts = opts or {}

  vim.fn.system("git status")
  local is_not_git = vim.v.shell_error > 0
  if is_not_git then
    require("telescope.builtin").find_files(opts)
    return
  end

  if opts.cwd then
    opts.cwd = vim.fn.expand(opts.cwd)
  else
    --- Find root of git directory and remove trailing newline characters
    opts.cwd = string.gsub(vim.fn.system("git rev-parse --show-toplevel"), "[\n\r]+", "")
  end

  -- By creating the entry maker after the cwd options,
  -- we ensure the maker uses the cwd options when being created.
  opts.entry_maker = opts.entry_maker or make_entry.gen_from_file(opts)

  pickers.new(opts, {
    prompt_title = "Git File",
    finder = finders.new_oneshot_job({ "git", "ls-files", "--recurse-submodules" }, opts),
    previewer = previewers.cat.new(opts),
    sorter = conf.file_sorter(opts),
  }):find()
end

-- nnoremap <Leader>o <Cmd>lua require'telescope_config'.files{}<CR>
-- nnoremap <Leader>d <Cmd>lua require'telescope_config'.find_dots{}<CR>

vim.api.nvim_command([[ command! -nargs=1 Rg call luaeval('require('telescope.builtin').grep_string(
        require("config.telescope").theme({
            search = _A
        })
    )', expand('<args>'))
    ]])

--[[
    +-------------------------------------+
    | Prompt                              |
    +--------------------+----------------+
    | Results            | Preview        |
    |                    |                |
    |                    |                |
    +--------------------+----------------+
--]]
-- Currently Broken ....
layout.custom = function(self, columns, lines)
  local initial_options = self:get_initial_window_options()
  local preview = initial_options.preview
  local results = initial_options.results
  local prompt = initial_options.prompt

  -- This sets the height/width for the whole layout
  local height = resolve.resolve_height(self.window.results_height)(self, columns, lines)
  local width = resolve.resolve_width(self.window.width)(self, columns, lines)

  local max_results = (height > lines and lines or height)
  local max_width = (width > columns and columns or width)

  local has_preview = self.previewer

  -- border size
  local bs = self.window.border and 1 or 0

  prompt.height = 1
  results.height = max_results
  preview.height = max_results
  preview.width = width - math.floor(width * self.window.results_width)

  prompt.width = max_width
  results.width = max_width - (has_preview and (preview.width + bs) or 0)

  prompt.line = (lines / 2) - ((max_results + (bs * 2)) / 2)
  results.line = prompt.line + 1 + bs
  preview.line = results.line

  if not self.previewer or columns < self.preview_cutoff then
    if self.window.border and self.window.borderchars then
      self.window.borderchars.results[6] = self.window.borderchars.preview[6]
      self.window.borderchars.results[7] = self.window.borderchars.preview[7]
    end

    preview.height = 0
  end

  results.col = math.ceil((columns / 2) - (width / 2) - bs)
  prompt.col = results.col
  preview.col = results.col + results.width + bs

  return { preview = has_preview and preview, results = results, prompt = prompt }
end

-- lua require("utils.telescope").jump() -- working
M.jump = function()
  require("telescope.builtin").jumplist({ layout_strategy = "vertical" })
end

-- lua require("utils.telescope").installed_plugins() -- working
function M.installed_plugins()
  require("telescope.builtin").find_files({
    cwd = "/home/viv/local/share/nvim/site/pack/packer/start/",
  })
end

-- lua require("utils.telescope").project_search()
function M.project_search()
  require("telescope.builtin").find_files({
    previewer = false,
    layout_strategy = "vertical",
    cwd = require("nvim_lsp").root_pattern(".git")(vim.fn.expand("%:p")), -- change this
  })
end

-- lua require("utils.telescope").theme()
M.theme = function(opts)
  return vim.tbl_deep_extend("force", {
    sorting_strategy = "ascending",
    layout_strategy = "flex",
    results_title = false,
    preview_title = false,
    preview = false,
    winblend = 30,
    width = 100,
    results_height = 15,
    results_width = 0.37,
    border = true,
    borderchars = {
      { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
      prompt = { "─", "│", " ", "│", "╭", "╮", "│", "│" },
      results = { "─", "│", "─", "│", "├", "┬", "┴", "╰" },
      preview = { "─", "│", "─", "│", "╭", "┤", "╯", "╰" },
    },
  }, opts or {})
end

-- lua require("utils.telescope").command_history()
function M.command_history()
  builtin.command_history(M.theme())
end

-- lua require("utils.telescope").load_dotfiles()
function M.load_dotfiles()
  local has_telescope = pcall(require, "telescope.builtin")
  if has_telescope then
    local themes = require("telescope.themes")

    local results = {}
    local dotfiles = require("core.global").home .. "/.dotfiles"
    for file in io.popen('find "' .. dotfiles .. '" -type f'):lines() do
      if not file:find("fonts") then
        table.insert(results, file)
      end
    end

    local global = require("core.global")
    for file in io.popen('find "' .. global.vim_path .. '" -type f'):lines() do
      table.insert(results, file)
    end

    builtin.dotfiles = function(opts)
      opts = themes.get_dropdown({})
      pickers.new(opts, {
        prompt = "dotfiles",
        finder = finders.new_table({ results = results }),
        previewer = previewers.cat.new(opts),
        sorter = sorters.get_generic_fuzzy_sorter(),
      }):find()
    end
  end
  builtin.dotfiles()
end
-- lua require("utils.telescope").file_browser()
function M.file_browser()
  require("telescope").load_extension("file_browser")
  local opts

  opts = {
    --   sorting_strategy = "ascending",
    --   scroll_strategy = "cycle",
    --   prompt_prefix = "  ",
    --   layout_config = {
    --     prompt_position = "top",
    --   },
  }
  require("telescope").extensions.file_browser.file_browser(opts)
end

-- lua require("utils.telescope").help_tags()
function M.help_tags()
  local opts = themes.get_ivy({
    initial_mode = "insert",
    sorting_strategy = "ascending",
    layout_config = {
      prompt_position = "top",
      preview_width = 0.75,
      -- horizontal = {
      --   preview_width = 0.55,
      --   results_width = 0.8,
      -- },
      -- vertical = {
      --   mirror = false,
      -- },
      -- width = 0.87,
      height = 0.6,
    },
    preview = {
      preview_cutoff = 120,
      preview_width = 80,
      hide_on_startup = false,
    },
  })
  builtin.help_tags(opts)
end

-- lua require("utils.telescope").find_string()
function M.find_string()
  local opts = themes.get_ivy({
    border = true,
    shorten_path = false,
    -- layout_strategy = "flex",
    layout_config = {
      width = 0.99,
      height = 0.5,
      prompt_position = "top",
      -- horizontal = { width = { padding = 0.05 } },
      -- vertical = { preview_height = 0.75 },
    },
    file_ignore_patterns = {
      "vendor/*",
      "node_modules",
      "%.jpg",
      "%.jpeg",
      "%.png",
      "%.svg",
      "%.otf",
      "%.ttf",
    },
    preview = {
      hide_on_startup = false,
    },
  })
  -- winblend = 15,
  builtin.live_grep(opts)
end

-- lua require("utils.telescope").grep_last_search()
function M.grep_last_search(opts)
  opts = opts or {}

  -- \<getreg\>\C
  -- -> Subs out the search things
  local register = vim.fn.getreg("/"):gsub("\\<", ""):gsub("\\>", ""):gsub("\\C", "")

  opts.path_display = { "shorten" }
  opts.word_match = "-w"
  opts.search = register

  require("telescope.builtin").grep_string(opts)
end

-- lua require("utils.telescope").curbuf()
function M.curbuf()
  local opts = themes.get_ivy({
    -- winblend = 10,
    -- border = false,
    -- previewer = false,
    shorten_path = false,
    prompt_position = "top",
    layout_config = { prompt_position = "top", height = 0.4 },
  })
  require("telescope.builtin").current_buffer_fuzzy_find(opts)
end

-- lua require("utils.telescope").git_diff()
function M.git_diff()
  local opts = {
    layout_strategy = "horizontal",
    border = true,
    prompt_title = "~ Git Diff ~",
    layout_config = {
      width = 0.99,
      height = 0.69,
      preview_width = 0.7,
      prompt_position = "top",
    },
    preview = {
      hide_on_startup = false,
    },
  }
  require("telescope.builtin").git_status(opts)
end

-- https://github.com/AshineFoster/nvim/blob/master/lua/plugins/telescope.lua
local horizontal_preview_width = function(_, cols, _)
  if cols > 200 then
    return math.floor(cols * 0.6)
  else
    return math.floor(cols * 0.5)
  end
end

local width_for_nopreview = function(_, cols, _)
  if cols > 200 then
    return math.floor(cols * 0.5)
  elseif cols > 110 then
    return math.floor(cols * 0.6)
  else
    return math.floor(cols * 0.75)
  end
end

local height_dropdown_nopreview = function(_, _, rows)
  return math.floor(rows * 0.7)
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

function custom_actions.page_up(prompt_bufnr)
  require("telescope.actions.set").shift_selection(prompt_bufnr, -5)
end

function custom_actions.page_down(prompt_bufnr)
  require("telescope.actions.set").shift_selection(prompt_bufnr, 5)
end

function custom_actions.change_directory(prompt_bufnr)
  local entry = require("telescope.actions.state").get_selected_entry()
  require("telescope.actions").close(prompt_bufnr)
  vim.cmd("lcd " .. entry.path)
end

-- https://github.com/nvim-telescope/telescope.nvim/issues/416#issuecomment-841273053

local action_state = require("telescope.actions.state")

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

M.setup = function()
  telescope.setup({
    defaults = {
      vimgrep_arguments = {
        "rg",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
      },
      shorten_path = true,
      prompt_prefix = "   ",
      layout_strategy = "flex",
      entry_prefix = "  ",
      initial_mode = "insert",
      layout_config = {
        prompt_position = "top",
        width = 0.8,
        horizontal = {
          -- width_padding = 0.1,
          -- height_padding = 0.1,
          -- preview_cutoff = 60,
          -- width = width_for_nopreview,
        },
        vertical = {
          -- width_padding = 0.05,
          -- height_padding = 1,
          width = 0.75,
          height = 0.85,
          preview_height = 0.4,
          mirror = true,
        },
        flex = {
          -- change to horizontal after 120 cols
          flip_columns = 120,
        },
      },

      preview_width = horizontal_preview_width,

      file_sorter = require("telescope.sorters").get_fuzzy_file,
      file_ignore_patterns = { "node_modules" },
      generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
      path_display = { "truncate" },
      winblend = 0,

      border = true,
      borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
      color_devicons = true,
      use_less = true,
      set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,

      sorting_strategy = "ascending",
      selection_strategy = "reset", -- closest
      scroll_strategy = "cycle",
      file_previewer = require("telescope.previewers").vim_buffer_cat.new,
      grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
      qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
      extensions = { fzy_native = { override_generic_sorter = false, override_file_sorter = true } },
      buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
      -- check telescoe/mappings.lua
      -- n<C-u/d> pageup/down in preview
      -- i <C-_> help keymap
      -- n ? which key
      mappings = {
        n = {
          ["<esc>"] = actions.close,
          -- ["<tab>"] = actions.toggle_selection + actions.move_selection_next, -- this is default
          -- ["<s-tab>"] = actions.toggle_selection + actions.move_selection_previous,
          -- ["<cr>"] = custom_actions.fzf_multi_select,
          ["<C-n>"] = function(prompt_bufnr)
            local results_win = state.get_status(prompt_bufnr).results_win
            local height = vim.api.nvim_win_get_height(results_win)
            action_set.shift_selection(prompt_bufnr, math.floor(height / 2))
          end,
          ["<localleader>"] = {
            actions.toggle_selection,
            type = "action",
            -- See https://github.com/nvim-telescope/telescope.nvim/pull/890
            keymap_opts = { nowait = true },
          },
          ["<C-p>"] = function(prompt_bufnr)
            local results_win = state.get_status(prompt_bufnr).results_win
            local height = vim.api.nvim_win_get_height(results_win)
            action_set.shift_selection(prompt_bufnr, -math.floor(height / 2))
          end,
          ["<C-q>"] = custom_actions.smart_send_to_qflist,

          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
          ["<C-o>"] = actions.select_vertical,
          ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
          ["<C-a>"] = actions.send_to_qflist + actions.open_qflist,
          ["<C-h>"] = "which_key",
          ["<C-l>"] = actions_layout.toggle_preview,
        },
        i = {
          ["<S-Down>"] = actions.cycle_history_next,
          ["<S-Up>"] = actions.cycle_history_prev,
          -- ['<Down>'] = actions.move_selection_next,
          -- ['<Up>'] = actions.move_selection_previous,
          ["<C-q>"] = custom_actions.smart_send_to_qflist,
          -- ['w'] = myactions.smart_send_to_qflist,
          -- ['e'] = myactions.send_to_qflist,
          ["<c-j>"] = actions.toggle_selection + actions.move_selection_next,
          ["<c-k>"] = actions.toggle_selection + actions.move_selection_previous,
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

          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
          ["<C-o>"] = actions.select_vertical,
          ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
          ["<C-a>"] = actions.send_to_qflist + actions.open_qflist,
          ["<C-h>"] = "which_key",
          ["<C-l>"] = actions_layout.toggle_preview,
        },
      },
    },
  })

  telescope.load_extension("dotfiles")
  telescope.load_extension("gosource")

  loader("telescope-fzy-native.nvim telescope-fzf-native.nvim telescope-live-grep-raw.nvim") --
  loader("sqlite.lua")
  loader("telescope-frecency.nvim project.nvim telescope-zoxide nvim-neoclip.lua nvim-notify")
  loader("sqlite.lua")

  telescope.load_extension("notify")

  telescope.setup({
    extensions = {
      fzf = {
        fuzzy = true, -- false will only do exact matching
        override_generic_sorter = true, -- override the generic sorter
        override_file_sorter = true, -- override the file sorter
        case_mode = "smart_case", -- or "ignore_case" or "respect_case"
        -- the default case_mode is "smart_case"
      },
    },
  })

  telescope.load_extension("fzf")
  telescope.setup({
    extensions = {
      fzy_native = {
        override_generic_sorter = false,
        override_file_sorter = true,
      },
    },
  })
  telescope.load_extension("fzy_native")

  ----
  require("packer").loader("neorg-telescope")

  local neorg_callbacks = require("neorg.callbacks")

  neorg_callbacks.on_event("core.keybinds.events.enable_keybinds", function(_, keybinds)
    -- Map all the below keybinds only when the "norg" mode is active
    keybinds.map_event_to_mode("norg", {
      n = { -- Bind keys in normal mode
        { "<c-s>", "core.integrations.telescope.find_linkable" },
        { "<c-i>", "core.integrations.telescope.search_headings" },
      },
      i = { -- Bind in insert mode
        { "<c-k>", "core.integrations.telescope.insert_link" },
      },
    }, { silent = true, noremap = true })
  end)
end
return M
