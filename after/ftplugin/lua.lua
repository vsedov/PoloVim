vim.treesitter.start()
local fn = vim.fn
local fmt = string.format

local function find(word, ...)
    for _, str in ipairs({ ... }) do
        local match_start, match_end = string.find(word, str)
        if match_start then
            return str, match_start, match_end
        end
    end
end

--- Stolen from nlua.nvim this function attempts to open
--- vim help docs if an api or vim.fn function otherwise it
--- shows the lsp hover doc
--- @param word string
--- @param callback function
local function keyword(word, callback)
    local original_iskeyword = vim.bo.iskeyword

    vim.bo.iskeyword = vim.bo.iskeyword .. ",."
    word = word or fn.expand("<cword>")

    vim.bo.iskeyword = original_iskeyword

    -- TODO: This is a sub par work around, since I usually rename `vim.api` -> `api` or similar
    -- consider maybe using treesitter in the future
    local api_match = find(word, "api", "vim.api")
    local fn_match = find(word, "fn", "vim.fn")
    if api_match then
        local _, finish = string.find(word, api_match .. ".")
        local api_function = string.sub(word, finish + 1)

        vim.cmd(string.format("help %s", api_function))
        return
    elseif fn_match then
        local _, finish = string.find(word, fn_match .. ".")
        if not finish then
            return
        end
        local api_function = string.sub(word, finish + 1) .. "()"

        vim.cmd(string.format("help %s", api_function))
        return
    elseif callback then
        callback()
    else
        vim.lsp.buf.hover()
    end
end

vim.keymap.set("n", "gK", keyword, { buffer = 0 })
vim.opt_local.textwidth = 100
vim.opt_local.formatoptions:remove("o")
vim.o.smarttab = true
vim.o.colorcolumn = "130"
