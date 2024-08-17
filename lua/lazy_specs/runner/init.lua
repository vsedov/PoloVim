local conf = require("modules.runner.config")
return {
    {
        "overseer.nvim",
        event = "DeferredUIEnter",
        config = conf.overseer,
    },
    { -- This plugin
        "compiler.nvim",
        cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
        dependencies = { "stevearc/overseer.nvim" },
        opts = {
            task_list = {
                direction = "bottom",
                min_height = 25,
                max_height = 25,
                default_detail = 1,
            },
        },
    },
    {
        "compiler-explorer.nvim",
        cmd = {
            "CECompile",
            "CECompileLive",
            "CEFormat",
            "CEAddLibrary",
            "CELoadExample",
            "CEOpenWebsite",
            "CEDeleteCache",
            "CEShowTooltip",
            "CEGotoLabel",
        },
    },
}
