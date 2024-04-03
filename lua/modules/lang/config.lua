local config = {}

function config.refactor()
    local refactor = require("refactoring")

    refactor.setup({
        prompt_func_return_type = {
            go = true,
            java = true,

            cpp = false,
            c = false,
            h = false,
            hpp = false,
            cxx = false,
        },
        prompt_func_param_type = {
            go = false,
            java = false,
            cpp = false,
            c = false,
            h = false,
            hpp = false,
            cxx = false,
        },

        print_var_statements = {
            python = {
                'ic(f"{ %s }")',
            },
        },
    })

    -- lprint("refactor")
    _G.ts_refactors = function()
        -- telescope refactoring helper
        local function _refactor(prompt_bufnr)
            local content = require("telescope.actions.state").get_selected_entry(prompt_bufnr)
            require("telescope.actions").close(prompt_bufnr)
            require("refactoring").refactor(content.value)
        end

        require("telescope.pickers")
            .new({}, {
                prompt_title = "refactors",
                finder = require("telescope.finders").new_table({
                    results = require("refactoring").get_refactors(),
                }),
                sorter = require("telescope.config").values.generic_sorter({}),
                attach_mappings = function(_, map)
                    map("i", "<CR>", _refactor)
                    map("n", "<CR>", _refactor)
                    return true
                end,
            })
            :find()
    end
end

function config.dev_comments()
    require("dev_comments").setup({
        -- Enables vim.notify messages
        debug = false,
        -- Creates <Plug> mappings
        default_mappings = true,
        -- Create user commands
        default_commands = true,
        -- Each call of dev-comments is cached
        -- Play around with the reset autocommands for more aggressive caching
        cache = {
            enabled = true,
            reset_autocommands = { "BufWritePost", "BufWinEnter" },
        },
        -- Improves performance when searching in a large directory
        -- Requires ripgrep or grep
        pre_filter = {
            -- If search fails, uses plenary scandir (very slow)
            fallback_to_plenary = true,
        },
        -- Highlight for the tag in picker (not in buffer)
        highlight = {
            tags = {
                ["TODO"] = "TSWarning",
                ["NOTE"] = "TSWarning",
                ["PERF"] = "TSWarning",
                ["HACK"] = "TSWarning",
                ["WARNING"] = "TSWarning",
                ["OPTIM"] = "TSWarning",
                ["TRIAL"] = "TSWarning",
                ["REVISIT"] = "TSDanger",
                ["FIXME"] = "TSDanger",
                ["XXX"] = "TSDanger",
                ["BUG"] = "TSDanger",
            },
            -- Used if lookup fails for a given tag
            fallback = "TSNote",
        },
    })

    -- <Plug> keymaps
    vim.keymap.set("n", "<Plug>DevCommentsTelescopeCurrent", function()
        require("telecope").extensions.dev_comments.current({})
    end, { silent = true })
    vim.keymap.set("n", "<Plug>DevCommentsTelescopeOpen", function()
        require("telecope").extensions.dev_comments.open({})
    end, { silent = true })
    vim.keymap.set("n", "<Plug>DevCommentsTelescopeAll", function()
        require("telecope").extensions.dev_comments.open({})
    end, { silent = true })
    vim.keymap.set("n", "<Plug>DevCommentsCyclePrev", function()
        require("dev_comments.cycle").goto_prev()
    end, { silent = true })
    vim.keymap.set("n", "<Plug>DevCommentsCycleNext", function()
        require("dev_comments.cycle").goto_next()
    end, { silent = true })

    -- Keybinds
    vim.keymap.set("n", "[w", "<Plug>DevCommentsCyclePrev")
    vim.keymap.set("n", "]w", "<Plug>DevCommentsCycleNext")
end

function config.luadev()
    vim.cmd([[vmap <leader><leader>lr <Plug>(Luadev-Run)]])
end

function config.luapad()
    require("luapad").setup({
        count_limit = 150000,
        error_indicator = true,
        eval_on_move = true,
        error_highlight = "WarningMsg",
        on_init = function()
            print("Hello from Luapad!")
        end,
        context = {
            the_answer = 42,
            shout = function(str)
                return (string.upper(str) .. "!")
            end,
        },
    })
end

function config.dap_config()
    require("dap.ext.vscode").json_decode = require("overseer.json").decode
    require("modules.lang.dap.init").config()
    require("cmp").setup({
        enabled = function()
            return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt" or require("cmp_dap").is_dap_buffer()
        end,
    })

    require("cmp").setup.filetype({ "dap-repl", "dapui_watches", "dapui_hsver" }, {
        sources = {
            { name = "dap" },
        },
    })
    require("overseer").patch_dap(true)
end

return config
