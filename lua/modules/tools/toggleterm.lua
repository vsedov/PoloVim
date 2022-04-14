local exp = vim.fn.expand
local nore_silent = { noremap = true, silent = true }
require("toggleterm").setup({
    -- size can be a number or function which is passed the current terminal
    size = 20,
    open_mapping = [[<c-t>]],
    hide_numbers = true, -- hide the number column in toggleterm buffers
    shade_filetypes = {},
    shade_terminals = true,
    shading_factor = 1, -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
    start_in_insert = true,
    insert_mappings = false, -- whether or not the open mapping applies in insert mode
    persist_size = true,
    direction = "horizontal", --  | 'horizontal' | 'window' | 'float',
    close_on_exit = true, -- close the terminal window when the process exits
    shell = vim.o.shell, -- change the default shell
    -- This field is only relevant if direction is set to 'float'
    float_opts = {
        -- The border key is *almost* the same as 'nvim_win_open'
        -- see :h nvim_win_open for details on borders however
        -- the 'curved' border is a custom border type
        -- not natively supported but implemented in this plugin.
        border = "single", --| 'double' | 'shadow' | 'curved' | ... other options supported by win open
        winblend = 3,
        highlights = {
            border = "Normal",
            background = "Normal",
        },
    },
})

vim.keymap.set("n", "<Leader>gh", function()
    require("toggleterm.terminal").Terminal:new({ cmd = "lazygit", hidden = true }):toggle()
end)

vim.keymap.set("n", "<leader>tf", "<cmd>ToggleTerm direction='vertical'<cr>")
vim.keymap.set("n", "<Leader>tv", "<cmd>ToggleTerm direction='float'<cr>")

local files = {
    python = "python3 -i " .. exp("%:t"),
    lua = "lua " .. exp("%:t"),
    applescript = "osascript " .. exp("%:t"),
    c = "gcc -o temp " .. exp("%:t") .. " && ./temp && rm ./temp",
    cpp = "clang++ -o temp " .. exp("%:t") .. " && ./temp && rm ./temp",
    java = "javac " .. exp("%:t") .. " && java " .. exp("%:t:r") .. " && rm *.class",
    rust = "cargo run",
    javascript = "node " .. exp("%:t"),
    typescript = "tsc " .. exp("%:t") .. " && node " .. exp("%:t:r") .. ".js",
}
local function Run_file()
    vim.cmd([[w]])
    local command = files[vim.bo.filetype]
    if command ~= nil then
        require("toggleterm.terminal").Terminal:new({ cmd = command, close_on_exit = false }):toggle()
        print("Running: " .. command)
    end
end

vim.keymap.set("n", "<leader>tr", Run_file, nore_silent)

local function toggleterm_winnr() end

_G.focus_toggleterm = function(count)
    local terms = require("toggleterm.terminal"):get_all()
    if vim.tbl_isempty(terms) then
        return
    end
    local pwin = _G.toggleterm_last_editor_winnr

    if count == 0 or not count then
        count = 1
    end

    local term_focused = vim.tbl_contains(
        (function(terms)
            return vim.tbl_map(function(term)
                return term.window
            end, terms)
        end)(terms),
        vim.api.nvim_get_current_win()
    )

    if term_focused then
        vim.api.nvim_set_current_win(pwin)
    else
        _G.toggleterm_last_editor_winnr = vim.api.nvim_get_current_win()
        local term = terms[count]
        if term:is_open() then
            local start_in_insert = require("toggleterm.config").get("start_in_insert")
            vim.api.nvim_set_current_win(term.window)
            if start_in_insert then
                vim.cmd("startinsert")
            end
        end
    end
end

_G.toggleterm_wrap = function(arg, count)
    _G.toggleterm_last_editor_winnr = vim.api.nvim_get_current_win()
    require("toggleterm").toggle_command(arg, count)
end

vim.cmd("command! -count FocusTerm lua focus_toggleterm(<count>)")
vim.cmd("command! -count -nargs=* ToggleTerm lua toggleterm_wrap(<q-args>, <count>)")

_G.toggleterm_exec = function(count)
    if count == 0 or not count then
        count = 1
    end

    local ft = vim.api.nvim_buf_get_option(0, "filetype")

    if not ft or ft == "" then
        vim.api.nvim_err_writeln("no file open")
        return
    end
    local choose = {
        python = "python",
    }

    local pre = choose[ft]
    if not pre then
        vim.api.nvim_err_writeln("can't find command for filetype: " .. ft .. "... edit plugin/toggleterm table")
        return
    end

    local cmd = ([[%sTermExec cmd='%s %s']]):format(count, pre, vim.fn.expand("%:p"))
    dump(cmd)
    vim.cmd(cmd)
end

_G.toggleterm_jump_traceback = function(count)
    print(" ---- NEW RUN ----")
    -- count here is the index of the traceback errmsg from top to bottom
    -- count isnt the count of toggleterm terminal, it always targets count 1
    local prompt = "❯"
    -- if count == 0 or not count then count = 1 end
    local term = require("toggleterm.terminal").get(1)
    -- if not term then return end
    local term_contents = vim.api.nvim_buf_get_lines(term.bufnr, 0, -1, true)
    dump(term_contents)
    -- parse each prompt into its own table {{}. {}. {}}
    local prompts = {}
    i = 0
    for _, line in ipairs(term_contents) do
        if line:match("^" .. prompt) then
            i = i + 1
            prompts[i] = {}
            table.insert(prompts[i], line)
        else
            if prompts[i] then
                table.insert(prompts[i], line)
            end
        end
    end

    -- for _, v in ipairs(prompts) do
    -- print(v)
    -- end

    -- validate (make sure last table of array of tables is a single > character
    if prompts[#prompts][1] ~= prompt then
        vim.api.nvim_err_writeln("parsing terminal buffer failed, end prompt is: " .. prompts[#prompts][1])
        return
    end

    -- callback function per filetype called for each line of the current prompt
    -- target formatting:
    --{ { "/home/f1/dev/dot/home-manager/config/qtile/scripts/test.py", "130" }, { "/nix/store/97w52ckcjnfiz89h3lh7zf1kysgfm2s8-python3-3.9.6/lib/python3.9/inspect.py", "340" }}
    local choose = {
        python = function(cprompt)
            local results = {}
            for _, line in ipairs(cprompt) do
                if line:match([[File%s".*"]]) then
                    local result = {}
                    result[1] = line:match([[File%s"(.*)"]])
                    if line:match("line%s%d+") then
                        result[2] = tonumber(line:match("line%s(%d+)"))
                    end
                    table.insert(results, result)
                end
            end
            return results
        end,
    }

    local cprompt = prompts[#prompts - 1]

    -- for _, v in ipairs(cprompt) do
    --   print(v)
    -- end

    local results = choose["python"](cprompt)

    if not results[count] then
        vim.api.nvim_err_writeln("err msg count " .. count .. " doesnt exist, stopping")
        return
    end
    local fp = results[count][1]
    local cline = results[count][2]

    -- find if fp/buf is already showing in a window
    local win_exists = false
    local all_windows = f.list_wins(true)
    for _, win in ipairs(all_windows) do
        if win.fp == fp then
            win_exists = true
            vim.api.nvim_set_current_win(win.winnr)
            vim.api.nvim_win_set_cursor(win.winnr, { cline, 1 })
            break
        end
    end

    if not win_exists then
        local rightmostwin = all_windows[#all_windows]
        vim.api.nvim_win_call(rightmostwin.winnr, function()
            vim.cmd("e " .. fp)
        end)
        vim.api.nvim_win_set_cursor(rightmostwin.winnr, { cline, 1 })
    end
    -- might change to splits:
    --local Split = require"nui.split"
    --("vsp %s"):format(results[count][1])
    -- local split = require("nui.split")({
    --   relative = "win",
    --   position = "right",
    --   size = "38%",
    -- })
    -- split:mount()
end
vim.cmd("command! -count FocusTerm lua focus_toggleterm(<count>)")
vim.cmd("command! -count TermTrace lua toggleterm_jump_traceback(<count>)")
vim.cmd("command! -count TermExec lua toggleterm_exec(<count>)")
vim.cmd("command! -count -nargs=* ToggleTerm lua toggleterm_wrap(<q-args>, <count>)")
