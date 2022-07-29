return {
    cmd = { "juliacli", "server" },
    settings = {
        julia = {
            usePlotPane = false,
            symbolCacheDownload = false,
            runtimeCompletions = true,
            singleFileSupport = false,
            useRevise = true,
            lint = {
                NumThreads = 16,
                missingrefs = "all",
                iter = true,
                lazy = true,
                modname = true,
            },
        },
    },
}
