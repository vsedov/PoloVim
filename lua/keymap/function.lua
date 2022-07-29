local bind = require("keymap.bind")
local map_cr = bind.map_cr
local map_cu = bind.map_cu
local map_cmd = bind.map_cmd
local map_args = bind.map_args

local plug_map = {
    -- Show syntax highlighting groups for word under cursor
    ["n|<localleader>c["] = map_cmd(function()
        local c = vim.api.nvim_win_get_cursor(0)
        local stack = vim.fn.synstack(c[1], c[2] + 1)
        for i, l in ipairs(stack) do
            stack[i] = vim.fn.synIDattr(l, "name")
        end
    end, "Debug / Inspect"):with_silent(),

    ["n|<leader>hw"] = map_cmd(function()
            if require("dynamic_help.extras.statusline").available() ~= "" then
                require("dynamic_help").float_help(vim.fn.expand("<cword>"))
            else
                local help = vim.fn.input("Help Tag> ")
                require("dynamic_help").float_help(help)
            end
        end, "Dynamic Help")
        :with_noremap()
        :with_silent(),
    -- Scuffed way of doing this, but this works .

    ["n|<Leader>gr"] = map_cmd(function()
        return ":IncRename " .. vim.fn.expand("<cword>")
    end, "rename"):with_expr(),

    ["n|dd"] = map_cmd(function()
            if vim.api.nvim_get_current_line():match("^%s*$") then
                return '"_dd'
            else
                return "dd"
            end
        end, "smard dd")
        :with_noremap()
        :with_expr(),

    ["n|LK"] = map_cmd(function()
            return ":DD " .. vim.fn.expand("<cword>") .. "<CR>"
        end, "Dev Docs search")
        :with_expr()
        :with_noremap(),

    ["n|LM"] = map_cmd(function()
            return ":Zeavim<CR>"
        end, "Zeal search")
        :with_expr()
        :with_noremap(),

    ["n|}"] = map_cmd(function()
        return ":lua vim.diagnostic.goto_next({ float = false })<cr>:DiagWindowShow" .. "<cr>"
    end, "Diag show next"):with_expr(),

    ["n|{"] = map_cmd(function()
        return ":lua vim.diagnostic.goto_prev({ float = false })<cr>:DiagWindowShow" .. "<cr>"
    end, "Diag show Prev"):with_expr(),

    ["v|d"] = map_cmd(function()
            local l, c = unpack(vim.api.nvim_win_get_cursor(0))
            for _, line in ipairs(vim.api.nvim_buf_get_lines(0, l - 1, l, true)) do
                if line:match("^%s*$") then
                    return '"_d'
                end
            end
            return "d"
        end, "visual smart d")
        :with_noremap()
        :with_expr(),
}

return plug_map
