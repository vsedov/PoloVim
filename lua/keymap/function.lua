local bind = require("keymap.bind")
local map_cmd = bind.map_cmd
local plug_map = {
    -- Show syntax highlighting groups for word under cursor
    ["n|<localleader>c["] = map_cmd(function()
        local c = vim.api.nvim_win_get_cursor(0)
        local stack = vim.fn.synstack(c[1], c[2] + 1)
        for i, l in ipairs(stack) do
            stack[i] = vim.fn.synIDattr(l, "name")
        end
    end, "Debug / Inspect"):with_silent(),

    -- Scuffed way of doing this, but this works .

    ["n|<Leader>gr"] = map_cmd(function()
        return ":IncRename " .. vim.fn.expand("<cword>")
    end, "rename"):with_expr(),

    ["n|D"] = map_cmd(function()
            return ":Lspsaga show_line_diagnostics<cr>"
        end, "Diagnostic")
        :with_noremap()
        :with_expr()
        :with_silent(),

    ["n|}"] = map_cmd(function()
        return ":lua vim.diagnostic.goto_next({ float = false })<cr>:DiagWindowShow" .. "<cr>"
    end, "Diag show next"):with_expr(),

    ["n|{"] = map_cmd(function()
        return ":lua vim.diagnostic.goto_prev({ float = false })<cr>:DiagWindowShow" .. "<cr>"
    end, "Diag show Prev"):with_expr(),

    ["n|;R"] = map_cmd(function()
        return ":NeoRoot<cr>"
    end, "root switch"):with_expr(),

    -- ["n|\\\\<leader>"] = map_cmd(function()
    --     return ":NoNeckPain"
    -- end, "NoNeckPain"):with_expr(),

    -- Annoying mapping
    ["v|D"] = map_cmd(function()
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
