local config = {}

function config.treesitter_init()
    local function is_inner(x, y)
        if x[1] < y[1] then
            return false
        end
        if (x[1] == y[1]) and (x[2] < y[2]) then
            return false
        end
        if x[3] > y[3] then
            return false
        end
        if (x[3] == y[3]) and (x[4] > y[4]) then
            return false
        end
        return true
    end

    local function is_same(x, y)
        for i, v in pairs(x) do
            if v ~= y[i] then
                return false
            end
        end
        return true
    end

    local function get_node_range(node)
        return { vim.treesitter.get_node_range(node) }
    end

    local function get_curpos()
        local p = vim.api.nvim_win_get_cursor(0)
        return p[1] - 1, p[2] + 1
    end

    local function get_vrange()
        local r1, c1 = get_curpos()
        vim.cmd("normal! o")
        local r2, c2 = get_curpos()
        vim.cmd("normal! o")
        if (r1 == r2) and (c1 == c2) then
            return { r1, c1, r2, c2 }
        end
        if (r1 < r2) or ((r1 == r2) and (c1 < c2)) then
            return { r1, c1 - 1, r2, c2 }
        end
        return { r2, c2 - 1, r1, c1 }
    end

    vim.keymap.set("x", "v", function()
        local ts_utils = require("nvim-treesitter.ts_utils")
        local vrange = get_vrange()
        local node = ts_utils.get_node_at_cursor()
        local nrange = get_node_range(node)

        local parent
        while true do
            if is_inner(vrange, nrange) and not is_same(vrange, nrange) then
                break
            end
            parent = node:parent()
            if parent == nil then
                break
            end
            node = parent
            nrange = get_node_range(node)
        end
        ts_utils.update_selection(0, node)
    end, { desc = "node incremental selection" })
end

function config.nvim_treesitter()
    require("modules.treesitter.treesitter").treesitter()
end

function config.endwise()
    require("modules.treesitter.treesitter").endwise()
end

function config.treesitter_obj()
    require("modules.treesitter.treesitter").treesitter_obj()
end
function config.treesitter_textsubjects()
    require("modules.treesitter.treesitter").textsubjects()
end

function config.treesitter_ref()
    require("modules.treesitter.treesitter").treesitter_ref()
end

function config.playground()
    require("nvim-treesitter.configs").setup({
        playground = {
            enable = true,
            disable = {},
            updatetime = 50, -- Debounced time for highlighting nodes in the playground from source code
            persist_queries = true, -- Whether the query persists across vim sessions
        },
    })
end

function config.hlargs()
    require("hlargs").setup({
        color = "#ef9062",
        highlight = {},
        excluded_filetypes = {
            "oil",
            "trouble",
            "vim",
            "help",
            "dashboard",
            "packer",
            "lazy",
            "config",
            "nofile",
        },
        paint_arg_declarations = true,
        paint_arg_usages = true,
        paint_catch_blocks = {
            declarations = true,
            usages = true,
        },
        extras = {
            named_parameters = true,
        },
        hl_priority = 10000,
        excluded_argnames = {
            declarations = {},
            usages = {
                python = { "self", "cls" },
                lua = { "self" },
            },
        },
        performance = {
            parse_delay = 1,
            slow_parse_delay = 50,
            max_iterations = 400,
            max_concurrent_partial_parses = 30,
            debounce = {
                partial_parse = 3,
                partial_insert_mode = 100,
                total_parse = 700,
                slow_parse = 5000,
            },
        },
    })
    lambda.command("HlargsEnable", function()
        require("hlargs").enable()
    end, {})
    lambda.command("HlargsDisable", function()
        require("hlargs").disable()
    end, {})
    lambda.command("HlargsToggle", function()
        require("hlargs").toggle()
    end, {})
end

function config.matchup_setup()
    vim.g.matchup_matchparen_offscreen = { method = "popup" }
end

function config.hi_pairs()
    function setkey(k)
        local function out(kk, v)
            vim[k][kk] = v
        end

        return out
    end

    setglobal = setkey("g")
    setglobal("hiPairs_hl_matchPair", {
        term = "underline,bold",
        cterm = "underline,bold",
        ctermfg = "0",
        ctermbg = "180",
        gui = "underline,bold,italic",
        guifg = "#fb94ff",
        guibg = "NONE",
    })
end

function config.guess_indent()
    require("guess-indent").setup({
        auto_cmd = true, -- Set to false to disable automatic execution
        filetype_exclude = { -- A list of filetypes for which the auto command gets disabled
            "netrw",
            "neo-tree",
            "tutor",
        },
        buftype_exclude = { -- A list of buffer types for which the auto command gets disabled
            "help",
            "nofile",
            "terminal",
            "prompt",
        },
    })
end

return config
