local function run_cmd_with_count(cmd)
    return function()
        vim.notify(string.format("%d%s", vim.v.count, cmd))
        vim.cmd(string.format("%d%s", vim.v.count, cmd))
    end
end

local function send_a_code_chunk()
    local leader = vim.g.mapleader
    local localleader = vim.g.maplocalleader
    -- NOTE: in an expr mapping, <Leader> and <LocalLeader>
    -- cannot be translated. You must use their literal value
    -- in the returned string.

    if vim.bo.filetype == "r" or vim.bo.filetype == "python" then
        return localleader .. "si" .. leader .. "c"
    elseif vim.bo.filetype == "rmd" or vim.bo.filetype == "quarto" or vim.bo.filetype == "markdown" then
        return localleader .. "sic"
    end
end
local ft_to_repl = {
    r = "radian",
    rmd = "radian",
    quarto = "radian",
    markdown = "radian",
    ["markdown.pandoc"] = "radian",
    python = "ipython",
    sh = "bash",
    REPL = "",
}

return {
    run_cmd_with_count = run_cmd_with_count,
    send_a_code_chunk = send_a_code_chunk,
    ft_to_repl = ft_to_repl,
}
