local function focus_me()
    if vim.g.neovide then
        lambda.pcall(vim.cmd.NeovideFocus)
    else
        require("kitty.current_win").focus()
    end
end
local function FNV_hash(s)
    local prime = 1099511628211
    local hash = 14695981039346656037
    for i = 1, #s do
        hash = require("bit").bxor(hash, s:byte(i))
        hash = hash * prime
    end
    return hash
end

local startup = require("core.pack").package
-- When you open a file in Vim but it was already open in another instance or not closed properly in a past edit, Vim will warn you, but it won't show you what the difference is between the hidden swap file and the regular saved file. Of all the actions you might want to do, the most obvious one is missing: compare, that is, see a diff.
-- enabled by default, will need to load on boot
startup({
    "chrisbra/Recover.vim",
    config = function()
        vim.g.RecoverPlugin_Edit_Unmodified = 1
    end,
})

startup({
    "lewis6991/fileline.nvim",
})

startup({
    "pteroctopus/faster.nvim",
    config = true,
})
startup({

    "willothy/flatten.nvim",
    lazy = false,
    priority = 1001,
    opts = {
        pipe_path = function()
            -- If running in a Kitty terminal, all tabs/windows/os-windows in the same instance of kitty will open in the first neovim instance
            if vim.env.NVIM then
                return vim.env.NVIM
            end

            local addr

            -- If running in a Kitty terminal, all tabs/windows/os-windows in the same instance of kitty will open in the first neovim instance
            if vim.env.KITTY_PID then
                addr = ("%s/kitty.nvim-%s"):format(vim.fn.stdpath("run"), vim.env.KITTY_PID)
            end

            if not addr then
                addr = ("%s/nvim-%s"):format(vim.fn.stdpath("run"), FNV_hash(vim.loop.cwd()))
            end

            if addr then
                local ok = pcall(vim.fn.serverstart, addr)
                return addr
            end
        end,
        -- <String, Bool> dictionary of filetypes that should be blocking
        block_for = {
            gitcommit = true,
        },
        -- Window options
        window = {
            open = "current",
            -- open = function(bufs, argv)
            --   if vim.tbl_contains(argv, "-s") then
            --   end
            --   vim.api.nvim_win_set_buf(0, bufs[1])
            -- end,
            focus = "first",
        },
        callbacks = {
            ---@param argv table a list of all the arguments in the nested session
            should_block = function(argv)
                -- Note that argv contains all the parts of the CLI command, including
                -- Neovim's path, commands, options and files.
                -- See: :help v:argv

                -- In this case, we would block if we find the `-b` flag
                -- This allows you to use `nvim -b file1` instead of `nvim --cmd 'let g:flatten_wait=1' file1`
                return vim.tbl_contains(argv, "-b")

                -- Alternatively, we can block if we find the diff-mode option
                -- return vim.tbl_contains(argv, "-d")
            end,

            no_files = function()
                -- TODO: this seems to open minifiles?
                pcall(function()
                    focus_me()
                end)
            end,
            -- Called when a request to edit file(s) is received
            pre_open = function() end,
            post_open = function(bufnr, winnr, filetype)
                -- Called after a file is opened
                -- Passed the buf id, win id, and filetype of the new window

                -- Switch kitty window
                focus_me()

                -- If the file is a git commit, create one-shot autocmd to delete its buffer on write
                -- If you just want the toggleable terminal integration, ignore this bit
                if ft == "gitcommit" or ft == "gitrebase" then
                    vim.api.nvim_create_autocmd("BufWritePost", {
                        buffer = bufnr,
                        once = true,
                        callback = vim.schedule_wrap(function()
                            vim.api.nvim_buf_delete(bufnr, {})
                        end),
                    })
                end
            end,
            block_end = function()
                -- Called when a file is open in blocking mode, after it's done blocking
                -- (after bufdelete, bufunload, or quitpre for the blocking buffer)
                -- TODO: refocus the preview window
            end,
        },
    },
})
