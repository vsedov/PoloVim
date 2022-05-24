local cmp = require("cmp")
local kind = require("utils.kind")
local types = require("cmp.types")
local str = require("cmp.utils.str")
require("modules.completion.snippets")
-- https://github.com/wincent/wincent/blob/fba0bbb9a81e085f654253926138b6675d3a6ad2/aspects/nvim/files/.config/nvim/after/plugin/nvim-cmp.lua
-- local kind = cmp.lsp.CompletionItemKind
local rhs = function(rhs_str)
    return vim.api.nvim_replace_termcodes(rhs_str, true, true, true)
end

-- local kind = cmp.lsp.CompletionItemKind

local luasnip = require("luasnip")

-- Returns the current column number.
local column = function()
    local _line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col
end

-- Based on (private) function in LuaSnip/lua/luasnip/init.lua.
local in_snippet = function()
    local session = require("luasnip.session")
    local node = session.current_nodes[vim.api.nvim_get_current_buf()]
    if not node then
        return false
    end
    local snippet = node.parent.snippet
    local snip_begin_pos, snip_end_pos = snippet.mark:pos_begin_end()
    local pos = vim.api.nvim_win_get_cursor(0)
    if pos[1] - 1 >= snip_begin_pos[1] and pos[1] - 1 <= snip_end_pos[1] then
        return true
    end
end

-- Returns true if the cursor is in leftmost column or at a whitespace
-- character.
local in_whitespace = function()
    local col = column()
    return col == 0 or vim.api.nvim_get_current_line():sub(col, col):match("%s")
end

local shift_width = function()
    if vim.o.softtabstop <= 0 then
        return vim.fn.shiftwidth()
    else
        return vim.o.softtabstop
    end
end

-- Complement to `smart_tab()`.
--
-- When 'noexpandtab' is set (ie. hard tabs are in use), backspace:
--
--    - On the left (ie. in the indent) will delete a tab.
--    - On the right (when in trailing whitespace) will delete enough
--      spaces to get back to the previous tabstop.
--    - Everywhere else it will just delete the previous character.
--
-- For other buffers ('expandtab'), we let Neovim behave as standard and that
-- yields intuitive behavior.
local smart_bs = function()
    if vim.o.expandtab then
        return rhs("<BS>")
    else
        local col = column()
        local line = vim.api.nvim_get_current_line()
        local prefix = line:sub(1, col)
        local in_leading_indent = prefix:find("^%s*$")
        if in_leading_indent then
            return rhs("<BS>")
        end

        local previous_char = prefix:sub(#prefix, #prefix)
        if previous_char ~= " " then
            return rhs("<BS>")
        end

        --
        -- Originally I was calculating the number of <BS> to send, but
        -- Neovim has some special casing that causes one <BS> to delete
        -- multiple characters even when 'expandtab' is off (eg. if you hit
        -- <BS> after pressing <CR> on a line with trailing whitespace and
        -- Neovim inserts whitespace to match.
        --
        -- So, turn 'expandtab' on temporarily and let Neovim figure out
        -- what a single <BS> should do.
        --
        -- See `:h i_CTRL-\_CTRL-O`.
        return rhs("<C-\\><C-o>:set expandtab<CR><BS><C-\\><C-o>:set noexpandtab<CR>")
    end
end

-- In buffers where 'noexpandtab' is set (ie. hard tabs are in use), <Tab>:
--
--    - Inserts a tab on the left (for indentation).
--    - Inserts spaces everywhere else (for alignment).
--
-- For other buffers (ie. where 'expandtab' applies), we use spaces everywhere.
local smart_tab = function(opts)
    local keys = nil
    if vim.o.expandtab then
        keys = "<Tab>" -- Neovim will insert spaces.
    else
        local col = column()
        local line = vim.api.nvim_get_current_line()
        local prefix = line:sub(1, col)
        local in_leading_indent = prefix:find("^%s*$")
        if in_leading_indent then
            keys = "<Tab>" -- Neovim will insert a hard tab.
        else
            -- virtcol() returns last column occupied, so if cursor is on a
            -- tab it will report `actual column + tabstop` instead of `actual
            -- column`. So, get last column of previous character instead, and
            -- add 1 to it.
            local sw = shift_width()
            local previous_char = prefix:sub(#prefix, #prefix)
            local previous_column = #prefix - #previous_char + 1
            local current_column = vim.fn.virtcol({ vim.fn.line("."), previous_column }) + 1
            local remainder = (current_column - 1) % sw
            local move = remainder == 0 and sw or sw - remainder
            keys = (" "):rep(move)
        end
    end

    vim.api.nvim_feedkeys(rhs(keys), "nt", true)
end
local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

-- print("cmp setup")
-- local t = function(str)
-- return vim.api.nvim_replace_termcodes(str, true, true, true)
-- end

local check_backspace = function()
    local col = vim.fn.col(".") - 1
    return col == 0 or vim.fn.getline("."):sub(col, col):match("%s") ~= nil
end

local sources = {
    { name = "nvim_lsp_signature_help", priority = 10 },
    { name = "nvim_lsp", priority = 9 },
    { name = "luasnip", priority = 8 },
    {
        name = "buffer",
        priority = 7,
        keyword_length = 4,
        options = {
            get_bufnrs = function()
                local bufs = {}
                for _, win in ipairs(vim.api.nvim_list_wins()) do
                    bufs[vim.api.nvim_win_get_buf(win)] = true
                end
                return vim.tbl_keys(bufs)
            end,
        },
    },
    { name = "path", priority = 5 },
    { name = "calc", priority = 4 },
    { name = "cmdline", priority = 4 },
    { name = "treesitter", keyword_length = 2 },
    { name = "neorg", priority = 6 },
    { name = "latex_symbols", priority = 1 },
    { name = "Dictionary" },
}

-- todo make this better too many if statmenets
local function use_tabnine()
    local valid_file_type = { "python", "lua", "cpp", "c", "rust" }
    return (vim.tbl_contains(valid_file_type, vim.o.filetype))
end

if use_tabnine() then
    require("packer").loader("cmp-tabnine")
    table.insert(sources, { name = "cmp_tabnine", priority = 9 })
end

if vim.o.ft == "sql" then
    table.insert(sources, { name = "vim-dadbod-completion" })
end

if vim.o.ft == "norg" then
    table.insert(sources, { name = "latex_symbols" })
end
if vim.o.ft == "markdown" then
    table.insert(sources, { name = "spell" })
    table.insert(sources, { name = "look" })
    table.insert(sources, { name = "latex_symbols" })
end
if vim.o.ft == "gitcommit" then
    vim.cmd([[packadd cmp-git]])
    require("cmp_git").setup({
        remotes = { "upstream", "origin", "b0o" },
        github = {
            issues = {
                filter = "all",
                limit = 250,
                state = "all",
                sort_by = function(issue)
                    local kind_rank = issue.pull_request and 1 or 0
                    local state_rank = issue.state == "open" and 0 or 1
                    local age = os.difftime(os.time(), require("cmp_git.utils").parse_github_date(issue.updatedAt))
                    return string.format("%d%d%010d", kind_rank, state_rank, age)
                end,
                filter_fn = function(trigger_char, issue)
                    return string.format("%s %s %s", trigger_char, issue.number, issue.title)
                end,
            },
            mentions = {
                limit = 250,
                sort_by = nil,
                filter_fn = function(trigger_char, mention)
                    return string.format("%s %s %s", trigger_char, mention.username)
                end,
            },
            pull_requests = {
                limit = 250,
                state = "all",
                sort_by = function(pr)
                    local state_rank = pr.state == "open" and 0 or 1
                    local age = os.difftime(os.time(), require("cmp_git.utils").parse_github_date(pr.updatedAt))
                    return string.format("%d%010d", state_rank, age)
                end,
                filter_fn = function(trigger_char, pr)
                    return string.format("%s %s %s", trigger_char, pr.number, pr.title)
                end,
            },
        },
        trigger_actions = {
            {
                debug_name = "git_commits",
                trigger_character = ":",
                ---@diagnostic disable-next-line: unused-local
                action = function(sources, trigger_char, callback, params, git_info)
                    return sources.git:get_commits(callback, params, trigger_char)
                end,
            },
            {
                debug_name = "github_issues",
                trigger_character = "#",
                ---@diagnostic disable-next-line: unused-local
                action = function(sources, trigger_char, callback, params, git_info)
                    return sources.github:get_issues(
                        cmp_git_extend_gh_callback(callback, "issues"),
                        git_info,
                        trigger_char
                    )
                end,
            },
            {
                debug_name = "github_pulls",
                trigger_character = "!",
                ---@diagnostic disable-next-line: unused-local
                action = function(sources, trigger_char, callback, params, git_info)
                    return sources.github:get_pull_requests(
                        cmp_git_extend_gh_callback(callback, "pulls"),
                        git_info,
                        trigger_char
                    )
                end,
            },
            {
                debug_name = "github_mentions",
                trigger_character = "@",
                ---@diagnostic disable-next-line: unused-local
                action = function(sources, trigger_char, callback, params, git_info)
                    return sources.github:get_mentions(callback, git_info, trigger_char)
                end,
            },
            {
                debug_name = "gitlab_issues",
                trigger_character = "#",
                ---@diagnostic disable-next-line: unused-local
                action = function(sources, trigger_char, callback, params, git_info)
                    return sources.gitlab:get_issues(callback, git_info, trigger_char)
                end,
            },
            {
                debug_name = "gitlab_mentions",
                trigger_character = "@",
                ---@diagnostic disable-next-line: unused-local
                action = function(sources, trigger_char, callback, params, git_info)
                    return sources.gitlab:get_mentions(callback, git_info, trigger_char)
                end,
            },
            {
                debug_name = "gitlab_mrs",
                trigger_character = "!",
                ---@diagnostic disable-next-line: unused-local
                action = function(sources, trigger_char, callback, params, git_info)
                    return sources.gitlab:get_merge_requests(callback, git_info, trigger_char)
                end,
            },
        },
    })

    table.insert(sources, { name = "cmp_git" })
end
if vim.o.ft == "lua" then
    table.insert(sources, { name = "nvim_lua" })
end
if vim.o.ft == "zsh" or vim.o.ft == "sh" or vim.o.ft == "fish" or vim.o.ft == "proto" then
    table.insert(sources, { name = "path" })
    table.insert(sources, { name = "buffer", keyword_length = 3 })
    table.insert(sources, { name = "calc" })
end

local mappings = {

    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-e>"] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
    }),

    ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
    ["<C-' '>"] = cmp.mapping.confirm({ select = true }),

    ["<CR>"] = cmp.mapping.confirm({
        select = true,
        behavior = cmp.ConfirmBehavior.Insert,
    }),

    ["<C-f>"] = cmp.mapping(function(fallback)
        if luasnip.choice_active() then
            require("luasnip").change_choice(1)
        elseif cmp.visible() then
            cmp.scroll_docs(4)
        else
            fallback()
        end
    end, {
        "i",
        "s",
    }),
    ["<C-d>"] = cmp.mapping(function(fallback)
        if luasnip.choice_active() then
            require("luasnip").change_choice(-1)
        elseif cmp.visible() then
            cmp.scroll_docs(-4)
        else
            fallback()
        end
    end, {
        "i",
        "s",
    }),
    -- ["<BS>"] = cmp.mapping(function(_fallback)
    --     local keys = smart_bs()
    --     vim.api.nvim_feedkeys(keys, "nt", true)
    -- end, { "i", "s" }),

    ["<Tab>"] = cmp.mapping(function(core, fallback)
        if cmp.visible() then
            cmp.select_next_item()
        elseif luasnip.expandable() then
            luasnip.expand()
        elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
        elseif not check_backspace() then
            cmp.mapping.complete()(core, fallback)
        elseif has_words_before() then
            cmp.complete()
        else
            smart_tab()
            -- vim.cmd(":>")
        end
    end, {
        "i",
        "s",
        "c",
    }),

    -- Avoid full fallback as it acts retardedly
    ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
            cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
        else
            -- smart_bs()
            vim.cmd(":<")
        end
    end, {
        "i",
        "s",
        "c",
    }),

    ["<C-j>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
            cmp.mapping.abort()
            cmp.mapping.close()
        end
        if luasnip.expandable() then
            luasnip.expand()
        elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
        elseif check_backspace() then
            fallback()
        elseif has_words_before() then
            cmp.complete()
        else
            fallback()
        end
    end, {
        "i",
        "s",
    }),

    ["<C-k>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
            cmp.mapping.abort()
            cmp.mapping.close()
        end
        if luasnip.jumpable(-1) then
            luasnip.jump(-1)
        else
            fallback()
        end
    end, {
        "i",
        "s",
    }),
    ["<C-l>"] = cmp.mapping(function(fallback)
        local copilot_keys = vim.fn["copilot#Accept"]("")
        if copilot_keys ~= "" then
            vim.api.nvim_feedkeys(copilot_keys, "i", true)
        else
            fallback()
        end
    end, {
        "i",
        "s",
    }),
}

cmp.setup({
    preselect = cmp.PreselectMode.Item,
    window = {
        completion = {
            border = { "🭽", "▔", "🭾", "▕", "🭿", "▁", "🭼", "▏" },
            -- scrollbar = { "║" },
        },
        documentation = {
            border = { "🭽", "▔", "🭾", "▕", "🭿", "▁", "🭼", "▏" },
            -- scrollbar = { "║" },
        },
    },

    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },
    completion = {
        autocomplete = { require("cmp.types").cmp.TriggerEvent.TextChanged },
        completeopt = "menu,menuone,noselect",
    },
    formatting = {
        fields = {
            cmp.ItemField.Kind,
            cmp.ItemField.Abbr,
            cmp.ItemField.Menu,
        },
        format = kind.cmp_format({
            with_text = false,
            before = function(entry, vim_item)
                -- Get the full snippet (and only keep first line)
                local word = entry:get_insert_text()
                if
                    entry.completion_item.insertTextFormat
                    --[[  ]]
                    == types.lsp.InsertTextFormat.Snippet
                then
                    word = vim.lsp.util.parse_snippet(word)
                end
                word = str.oneline(word)

                -- concatenates the string
                local max = 50
                if string.len(word) >= max then
                    local before = string.sub(word, 1, math.floor((max - 3) / 2))
                    word = before .. "..."
                end

                if
                    entry.completion_item.insertTextFormat == types.lsp.InsertTextFormat.Snippet
                    and string.sub(vim_item.abbr, -1, -1) == "~"
                then
                    word = word .. "~"
                end
                vim_item.abbr = word

                vim_item.dup = ({
                    buffer = 1,
                    path = 1,
                    nvim_lsp = 0,
                })[entry.source.name] or 0

                return vim_item
            end,
        }),
        -- format = function(entry, vim_item)
        --   vim_item.kind = string.format(
        --     "%s %s",
        --     -- "%s",
        --     get_kind(vim_item.kind),
        --     vim_item.kind
        --   )

        -- end
    },
    -- You must set mapping if you want.
    mapping = mappings,
    -- You should specify your *installed* sources.
    sources = sources,
    sorting = {
        comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            function()
                if vim.o.filetype == "c" or vim.o.filetype == "cpp" then
                    require("clangd_extensions.cmp_scores")
                end
            end,

            function(entry1, entry2)
                local _, entry1_under = entry1.completion_item.label:find("^_+")
                local _, entry2_under = entry2.completion_item.label:find("^_+")
                entry1_under = entry1_under or 0
                entry2_under = entry2_under or 0
                if entry1_under > entry2_under then
                    return false
                elseif entry1_under < entry2_under then
                    return true
                end
            end,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
        },
    },

    enabled = function()
        -- if require"cmp.config.context".in_treesitter_capture("comment")==true or require"cmp.config.context".in_syntax_group("Comment") then
        --   return false
        -- else
        --   return true
        -- end
        if vim.bo.ft == "TelescopePrompt" then
            return false
        end
        if vim.bo.ft == "lua" then
            return true
        end
        local lnum, col = vim.fn.line("."), math.min(vim.fn.col("."), #vim.fn.getline("."))
        for _, syn_id in ipairs(vim.fn.synstack(lnum, col)) do
            syn_id = vim.fn.synIDtrans(syn_id) -- Resolve :highlight links
            if vim.fn.synIDattr(syn_id, "name") == "Comment" then
                return false
            end
        end
        if string.find(vim.api.nvim_buf_get_name(0), "neorg://") then
            return false
        end
        if string.find(vim.api.nvim_buf_get_name(0), "s_popup:/") then
            return false
        end
        return true
    end,

    confirm_opts = {
        behavior = cmp.ConfirmBehavior.Replace,
        select = false,
    },
    experimental = { ghost_text = true, native_menu = false },
})

require("packer").loader("nvim-autopairs")
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))

-- require'cmp'.setup.cmdline(':', {sources = {{name = 'cmdline'}}})
if vim.o.ft == "clap_input" or vim.o.ft == "guihua" or vim.o.ft == "guihua_rust" then
    cmp.setup.buffer({ completion = { enable = false } })
end

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "TelescopePrompt", "clap_input" },
    callback = function()
        cmp.setup.buffer({ enabled = false })
    end,
    once = false,
})

-- if vim.o.ft ~= 'sql' then
--   require'cmp'.setup.buffer { completion = {autocomplete = false} }
-- end
cmp.setup.cmdline(":", {
    window = {
        completion = {
            border = { "🭽", "▔", "🭾", "▕", "🭿", "▁", "🭼", "▏" },
            scrollbar = { "║" },
        },
        documentation = {
            border = { "🭽", "▔", "🭾", "▕", "🭿", "▁", "🭼", "▏" },
            scrollbar = { "║" },
        },
    },
    sources = cmp.config.sources({

        { name = "cmdline", group_index = 1 },
        -- { name = "cmdline_history", group_index = 2 },
    }),
    enabled = function()
        return true
    end,
})

cmp.setup.cmdline("/", {
    window = {
        completion = {
            border = { "🭽", "▔", "🭾", "▕", "🭿", "▁", "🭼", "▏" },
            scrollbar = { "║" },
        },
        documentation = {
            border = { "🭽", "▔", "🭾", "▕", "🭿", "▁", "🭼", "▏" },
            scrollbar = { "║" },
        },
    },
    sources = {
        -- { name = "cmdline_history" },
        { name = "buffer" },
        { name = "nvim_lsp_document_symbol" },
    },
})

local neorg = require("neorg")

local function load_completion()
    neorg.modules.load_module("core.norg.completion", nil, {
        engine = "nvim-cmp",
    })
end

if neorg.is_loaded() then
    load_completion()
else
    neorg.callbacks.on_event("core.started", load_completion)
end
-- TODO(vsedov) (18:06:44 - 17/04/22): Use vim.highlight to set this insterad
-- vim.cmd([[hi NormalFloat guibg=none]])
