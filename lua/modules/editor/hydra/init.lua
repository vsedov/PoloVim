local all_hydras = require("core.global").modules_dir .. "/editor/hydra/"
local loader = require("packer").loader
local when = lambda.lib.when
local test_active = false

loader("keymap-layer.nvim vgit.nvim gitsigns.nvim")
local exclude_table = {
    "init",
}

-- this is to check if tests are currently active or not
if not test_active then
    table.insert(exclude_table, "hydra_test")
    table.insert(exclude_table, "HydraAutoHint")
end

local path_list = vim.split(vim.fn.glob(all_hydras .. "*.lua", true), "\n")

for _, path in ipairs(path_list) do
    local name = vim.fn.fnamemodify(path, ":t:r")
    local f = "modules.editor.hydra." .. name
    when(not vim.tbl_contains(exclude_table, name), function()
        if name == "buffer" then
            require(f).buffer()
        end
        require(f)
    end)
end

vim.api.nvim_create_user_command("ShowHydraBinds", function()
    hints = {
        buffer = "<leader>b",
        colour = "<localleader>C",
        dap = "<localleader>b",
        docs = "<leader>d",
        extra_search = ";A",
        git = "<leader>h",
        git_plus = "<leader>H",
        grapple = "<leader>l",
        harpoon = "<cr>",
        lsp = "\\l",
        test = "<leader>u",
        parenth_mode = "\\k", -- Might change
        python = ";l",
        magma = "<leader>I",
        reach = ";;",
        refactoring = "<leader>r",
        runner = ";r",
        lab_runner = "<localleader>r",
        sad = ";e",
        sub = "L",
        swap = "\\s",
        tele = "<leader>f",
        text_case = "gaa and gae",
        treesitter = "\\<leader>",
        vim_options = "<leader>O",
        windows = "<c-w>[",
        word_motion = "<localleader>w",
    }

    local str = "" .. "\n"
    for k, v in pairs(hints) do
        str = str .. fmt("**%s** - `%s`" .. "\n", k, v)
    end

    vim.notify(str, "info", {
        title = "Hydra binds",
        on_open = function(win)
            local buf = api.nvim_win_get_buf(win)
            if not api.nvim_buf_is_valid(buf) then
                return
            end
            api.nvim_buf_set_option(buf, "filetype", "markdown")
        end,
        timeout = 3000,
    })
end, {})
