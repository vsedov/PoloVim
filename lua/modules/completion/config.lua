local global = require("core.global")
local config = {}

function config.nvim_lsp()
  require("modules.completion.lsp")
end

local function is_prior_char_whitespace()
  local col = vim.fn.col(".") - 1
  if col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
    return true
  else
    return false
  end
end

function config.nvim_cmp()
  local cmp = require("cmp")

  vim.g.copilot_no_tab_map = true
  vim.g.copilot_assume_mapped = true
  vim.g.copilot_tab_fallback = ""

  local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
  end
  local luasnip = require("luasnip")
  local function tab(fallback)
    if cmp.visible() then
      cmp.select_next_item()
    elseif luasnip.expand_or_jumpable() then
      luasnip.expand_or_jump()
    elseif has_words_before() then
      cmp.complete()
    else
      -- F("<Tab>")
      fallback()
    end
  end

  if load_coq() then
    local sources = {}
    cmp.setup.buffer({ completion = { autocomplete = false } })
    return
  end
  -- print("cmp setup")
  local comp_kind = nil
  local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
  end
  local check_back_space = function()
    local col = vim.fn.col(".") - 1
    return col == 0 or vim.fn.getline("."):sub(col, col):match("%s") ~= nil
  end

  local sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "treesitter", keyword_length = 2 },
    { name = "look", keyword_length = 4 },
    -- {name = 'buffer', keyword_length = 4} {name = 'path'}, {name = 'look'},
    -- {name = 'calc'}, {name = 'ultisnips'} { name = 'snippy' }
  }
  if vim.o.ft == "sql" then
    table.insert(sources, { name = "vim-dadbod-completion" })
  end
  if vim.o.ft == "python" then
    table.insert(sources, { name = "cmp_tabnine" })
  end

  if vim.o.ft == "norg" then
    -- Get the current Neorg state
    local neorg = require("neorg")

    --- Loads the Neorg completion module
    local function load_completion()
      neorg.modules.load_module("core.norg.completion", nil, {
        engine = "nvim-cmp", -- Choose your completion engine here
      })
    end

    -- If Neorg is loaded already then don't hesitate and load the completion
    if neorg.is_loaded() then
      load_completion()
    else -- Otherwise wait until Neorg gets started and load the completion module then
      neorg.callbacks.on_event("core.started", load_completion)
    end

    table.insert(sources, { name = "neorg" })
  end

  if vim.o.ft == "markdown" then
    table.insert(sources, { name = "spell" })
    table.insert(sources, { name = "look" })
  end
  if vim.o.ft == "lua" then
    table.insert(sources, { name = "nvim_lua" })
  end
  if vim.o.ft == "zsh" or vim.o.ft == "sh" or vim.o.ft == "fish" or vim.o.ft == "proto" then
    table.insert(sources, { name = "path" })
    table.insert(sources, { name = "buffer", keyword_length = 3 })
    table.insert(sources, { name = "calc" })
  end
  cmp.setup({
    snippet = {
      expand = function(args)
        require("luasnip").lsp_expand(args.body)
        -- require 'snippy'.expand_snippet(args.body)
        -- vim.fn["UltiSnips#Anon"](args.body)
      end,
    },
    completion = {
      autocomplete = { require("cmp.types").cmp.TriggerEvent.TextChanged },
      completeopt = "menu,menuone,noselect",
    },
    formatting = {
      format = function(entry, vim_item)
        local lspkind_icons = {
          Text = "",
          Method = "",
          Function = "",
          Constructor = "",
          Field = "ﰠ",
          Variable = "",
          Class = "ﴯ",
          Interface = "",
          Module = "",
          Property = "ﰠ",
          Unit = "塞",
          Value = "",
          Enum = "",
          Keyword = "",
          Snippet = "",
          Color = "",
          File = "",
          Reference = "",
          Folder = "",
          EnumMember = "",
          Constant = "",
          Struct = "פּ",
          Event = "",
          Operator = "",
          TypeParameter = "",
        }
        -- load lspkind icons
        vim_item.kind = string.format("%s %s", lspkind_icons[vim_item.kind], vim_item.kind)

        vim_item.menu = ({
          cmp_tabnine = "[TN]",
          nvim_lsp = "[LSP]",
          nvim_lua = "[Lua]",
          buffer = "[BUF]",
          path = "[PATH]",
          tmux = "[TMUX]",
          luasnip = "[SNIP]",
          ultisnips = "[UltiSnips]",
          spell = "[SPELL]",
          neorg = "norg",
          -- rg = "[RG]",
        })[entry.source.name]

        return vim_item
      end,
    },
    -- documentation = {
    --   border = "rounded",
    -- },
    -- You must set mapping if you want.
    mapping = {
      ["<C-p>"] = cmp.mapping.select_prev_item(),
      ["<C-n>"] = cmp.mapping.select_next_item(),
      ["<C-d>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.close(),
      ["<CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
      -- ['<Tab>'] = cmp.mapping(tab, {'i', 's'}),

      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end, { "i", "s" }),

      ["<C-l>"] = cmp.mapping(function(fallback)
        local copilot_keys = vim.fn["copilot#Accept"]()
        if copilot_keys ~= "" then
          vim.api.nvim_feedkeys(copilot_keys, "i", true)
        else
          fallback()
        end
      end, {
        "i",
        "s",
      }),

      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { "i", "s" }),
    },

    -- You should specify your *installed* sources.
    sources = sources,

    experimental = { ghost_text = true },
  })
  require("packer").loader("nvim-autopairs")
  local cmp_autopairs = require("nvim-autopairs.completion.cmp")
  cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))

  -- require'cmp'.setup.cmdline(':', {sources = {{name = 'cmdline'}}})
  if vim.o.ft == "clap_input" or vim.o.ft == "guihua" or vim.o.ft == "guihua_rust" then
    require("cmp").setup.buffer({ completion = { enable = false } })
  end
  vim.cmd("autocmd FileType TelescopePrompt lua require('cmp').setup.buffer { enabled = false }")
  vim.cmd("autocmd FileType clap_input lua require('cmp').setup.buffer { enabled = false }")
  -- if vim.o.ft ~= 'sql' then
  --   require'cmp'.setup.buffer { completion = {autocomplete = false} }
  -- end
end

function config.vim_vsnip()
  vim.g.vsnip_snippet_dir = global.home .. "/.config/nvim/snippets"
end

function config.luasnip()
  local ls = require("luasnip")
  ls.config.set_config({ history = true, updateevents = "TextChanged,TextChangedI" })
  require("luasnip.loaders.from_vscode").load({})

  vim.api.nvim_set_keymap("i", "<C-E>", "<Plug>luasnip-next-choice", {})
  vim.api.nvim_set_keymap("s", "<C-E>", "<Plug>luasnip-next-choice", {})
end

function config.telescope_preload()
  if not packer_plugins["plenary.nvim"].loaded then
    require("packer").loader("plenary.nvim")
  end
  -- if not packer_plugins["telescope-fzy-native.nvim"].loaded then
  --   require"packer".loader("telescope-fzy-native.nvim")
  -- end
end

function config.telescope()
  require("utils.telescope").setup()
end

function config.emmet()
  vim.g.user_emmet_complete_tag = 1
  -- vim.g.user_emmet_install_global = 1
  vim.g.user_emmet_install_command = 0
  vim.g.user_emmet_mode = "a"
end
function config.vim_sonictemplate()
  vim.g.sonictemplate_postfix_key = "<C-,>"
  vim.g.sonictemplate_vim_template_dir = os.getenv("HOME") .. "/.config/nvim/template"
end

function config.tabnine()
  local tabnine = require("cmp_tabnine.config")
  tabnine:setup({

    max_line = 1000,
    max_num_results = 20,
    sort = true,
    run_on_every_keystroke = true,
  })
end

function config.ale()
  vim.g.ale_completion_enabled = 0
  vim.g.ale_python_mypy_options = ""
  vim.g.ale_list_window_size = 4
  vim.g.ale_sign_column_always = 0
  vim.g.ale_open_list = 0

  vim.g.ale_set_loclist = 0

  vim.g.ale_set_quickfix = 1
  vim.g.ale_keep_list_window_open = 1
  vim.g.ale_list_vertical = 0

  vim.g.ale_disable_lsp = 1

  vim.g.ale_lint_on_save = 1

  vim.g.ale_sign_error = ""
  vim.g.ale_sign_warning = ""
  vim.g.ale_lint_on_text_changed = 1

  vim.g.ale_echo_msg_format = "[%linter%] %s [%severity%]"

  vim.g.ale_lint_on_insert_leave = 0
  vim.g.ale_lint_on_enter = 0

  vim.g.ale_set_balloons = 1
  vim.g.ale_hover_cursor = 1
  vim.g.ale_hover_to_preview = 1
  vim.g.ale_float_preview = 1
  vim.g.ale_virtualtext_cursor = 1

  vim.g.ale_fix_on_save = 1
  vim.g.ale_fix_on_insert_leave = 0
  vim.g.ale_fix_on_text_changed = "never"
end

return config
