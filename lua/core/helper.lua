_G = _G or {}
return {
    init = function()
        _G.plugin_folder = function()
            if Plugin_folder then
                return Plugin_folder
            end
            local host = os.getenv("HOST_NAME")
            if host and host:find("vsedov") then
                Plugin_folder = [[~/github/]] -- vim.fn.expand("$HOME") .. '/github/'
            else
                Plugin_folder = [[vsedov/]]
            end
            return Plugin_folder
        end

        -- https://www.reddit.com/r/neovim/comments/sg919r/diff_with_clipboard/
        _G.compare_to_clipboard = function()
            local ftype = vim.api.nvim_eval("&filetype")
            vim.cmd(string.format(
                [[
          vsplit
          enew
          normal! P
          setlocal buftype=nowrite
          set filetype=%s
          diffthis
          bprevious
          execute "normal! \<C-w>\<C-w>"
          diffthis
        ]],
                ftype
            ))
        end

        _G.plugin_debug = function()
            if Plugin_debug ~= nil then
                return Plugin_debug
            end
            local host = os.getenv("HOST_NAME")
            if host and host:find("vsedov") then
                Plugin_debug = true -- enable debug here, will be slow
            else
                Plugin_debug = false
            end
            return Plugin_debug
        end

        _G.load_coq = function()
            if vim.o.ft == "sql" or vim.o.ft == "vim" then
                return true
            end
            return false
        end

        _G.use_nulls = function()
            -- Remove this for norg files
            if vim.bo.filetype == "norg" or vim.bo.filetype == "json" then
                return false
            end

            return true
        end

        _G.preserve = function(cmd)
            cmd = string.format("keepjumps keeppatterns execute %q", cmd)
            local original_cursor = vim.fn.winsaveview()
            vim.api.nvim_command(cmd)
            vim.fn.winrestview(original_cursor)
        end

        -- convert word to Snake case
        _G.Snake = function(s)
            if s == nil then
                s = vim.fn.expand("<cword>")
            end
            lprint("replace: ", s)
            local n = s
                :gsub("%f[^%l]%u", "_%1")
                :gsub("%f[^%a]%d", "_%1")
                :gsub("%f[^%d]%a", "_%1")
                :gsub("(%u)(%u%l)", "%1_%2")
                :lower()
            vim.fn.setreg("s", n)
            vim.cmd([[exe "norm! ciw\<C-R>s"]])
            lprint("newstr", n)
        end

        -- convert to camel case
        _G.Camel = function()
            local s
            if s == nil then
                s = vim.fn.expand("<cword>")
            end
            local n = string.gsub(s, "_%a+", function(word)
                local first = string.sub(word, 2, 2)
                local rest = string.sub(word, 3)
                return string.upper(first) .. rest
            end)
            vim.fn.setreg("s", n)
            vim.cmd([[exe "norm! ciw\<C-R>s"]])
        end

        -- reformat file by remove \n\t and pretty if it is json
        _G.Format = function(json)
            pcall(vim.cmd, [[%s/\\n/\r/g]])
            pcall(vim.cmd, [[%s/\\t/  /g]])
            pcall(vim.cmd, [[%s/\\"/"/g]])

            -- again
            vim.cmd([[nohl]])
            -- for json run

            if json then
                vim.cmd([[Jsonformat]]) -- :%!jq .
            end
        end
    end,
}
