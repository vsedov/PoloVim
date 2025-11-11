lambda.event = {}
lambda.event.default = { "BufReadPost", "BufNewFile" }

lambda.event.read = {
    pre = "BufReadPre",
    post = "BufReadPost",
}

lambda.event.lazy = {
    very_lazy = "VeryLazy",
    filepost = "FilePost",
}

lambda.event.new = "WinNew"

lambda.event.attach = "LspAttach"

lambda.event.enter = {
    insert = "InsertEnter",
    vim = "VimEnter",
    ui = "UIEnter",
    cmd = "CmdlineEnter",
}

lambda.event.leave = {
    insert = "InsertLeave",
    cmd = "CmdlineLeave",
}
