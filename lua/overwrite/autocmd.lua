local aucmd = vim.api.nvim_create_autocmd
aucmd("CmdLineEnter", {
    once = true,
    callback = function()
        require("modules.misc.normal_cmdline").setup()
    end,
    desc = "Set up normal_cmdline",
})

aucmd("User", {
    once = true,
    callback = function()
        vim.api.nvim_chan_send(vim.v.stderr, "\027]99;i=1:d=0;Neorg\027\\")
        vim.api.nvim_chan_send(vim.v.stderr, "\027]99;i=1:d=1:p=body;Finished Loading\027\\")
    end,
    pattern = "NeorgStarted",
    desc = "Send desktop notification",
})

aucmd("BufReadPre", {
    pattern = "*",
    command = "silent! :lua require('modules.lang.config').nvim_treesitter()",
})
