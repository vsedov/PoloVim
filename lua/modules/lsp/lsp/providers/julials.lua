-- return {
--     cmd = {
--         "julia",
--         "--project=@nvim-lspconfig",
--         "-J" .. vim.fn.getenv("HOME") .. "/.julia/environments/nvim-lspconfig/languageserver.so",
--         "-J" .. vim.fn.getenv("HOME") .. "/.julia/environments/nvim-lspconfig/juliaformatter.so",
--         "-J" .. vim.fn.getenv("HOME") .. "/.julia/environments/nvim-lspconfig/revise.so",
--         "--sysimage-native-code=yes",
--         "--startup-file=no",
--         "--history-file=no",
--         "-e",
--         [[
--             ls_install_path = joinpath(get(DEPOT_PATH, 1, joinpath(homedir(), ".julia")), "environments", "nvim-lspconfig");
--             pushfirst!(LOAD_PATH, ls_install_path);
--             using LanguageServer;
--             using JuliaFormatter;
--             using Revise;
--             popfirst!(LOAD_PATH);
--             depot_path = get(ENV, "JULIA_DEPOT_PATH", "");
--             project_path = let
--                 dirname(something(
--                     Base.load_path_expand((
--                         p = get(ENV, "JULIA_PROJECT", nothing);
--                         p === nothing ? nothing : isempty(p) ? nothing : p)),
--                     Base.current_project(),
--                     get(Base.load_path(), 1, nothing),
--                     Base.load_path_expand("@v#.#"),))
--             end
--             @info "Running language server" VERSION pwd() project_path depot_path
--             server = LanguageServer.LanguageServerInstance(stdin, stdout, project_path, depot_path)
--             server.runlinter = true
--             run(server)
--             ]],
--     },
--     settings = {
--         julia = {
--             usePlotPane = false,
--             symbolCacheDownload = true,
--             runtimeCompletions = true,
--             lint = {
--                 NumThreads = 16,
--                 missingrefs = "all",
--                 iter = true,
--                 lazy = true,
--                 modname = true,
--             },
--         },
--     },
--     single_file_support = true,
--     filetypes = { "julia" },
-- }

return {
    cmd = { "julials" },
    settings = {
        julia = {
            symbolCacheDownload = true,
            runtimeCompletions = true,
            singleFileSupport = true,
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
    single_file_support = true,
}
