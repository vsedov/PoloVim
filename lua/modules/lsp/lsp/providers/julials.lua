return {
    cmd = {
        "julia",
        "--project=@nvim-lspconfig",
        "-J" .. vim.fn.getenv("HOME") .. "/.julia/environments/nvim-lspconfig/languageserver.so",
        "--sysimage-native-code=yes",
        "--startup-file=no",
        "--history-file=no",
        "-e",
        [[
        # just in case
        import Pkg;
        import JuliaFormatter;
        using JuliaFormatter; 
        format_file("]] .. vim.fn.expand("%:p") .. [[", remove_extra_newlines = true, style = "yas")

        function recurse_project_paths(path::AbstractString)
            isnothing(Base.current_project(path)) && return
            tmp = path
            CUSTOM_LOAD_PATH = []
            while !isnothing(Base.current_project(tmp))
                    pushfirst!(CUSTOM_LOAD_PATH, tmp)
                    tmp = dirname(tmp)
            end
            # push all to LOAD_PATHs
            pushfirst!(Base.LOAD_PATH, CUSTOM_LOAD_PATH...)
            return joinpath(CUSTOM_LOAD_PATH[1], "Project.toml")
    end
        buffer_file_path = "]] .. vim.fn.expand("%:p:h") .. '";' .. [[
    project_path = let 
            dirname(something(
                Base.load_path_expand((
                p = get(ENV, "JULIA_PROJECT", nothing);
                p === nothing ? nothing : isempty(p) ? nothing : p
        )),
                Base.current_project(strip(buffer_file_path)),
                Base.current_project(pwd()),
                Pkg.Types.Context().env.project_file,
                Base.active_project()
            ))
        end
    ls_install_path = joinpath(get(DEPOT_PATH, 1, joinpath(homedir(), ".julia")), "environments", "nvim-lspconfig");
    pushfirst!(LOAD_PATH, ls_install_path);
    using LanguageServer; using SymbolServer; using JuliaFormatter;
    popfirst!(LOAD_PATH);
        @info "LOAD_PATHS: $(Base.load_path())"
    depot_path = get(ENV, "JULIA_DEPOT_PATH", "");
    symbol_server_path = joinpath(homedir(), ".cache", "nvim", "julia_lsp_symbol_store")
    mkpath(symbol_server_path)
        @info "LanguageServer has started with buffer $project_path or $(pwd())"
    server = LanguageServer.LanguageServerInstance(stdin, stdout, project_path, depot_path, nothing, symbol_server_path, true);
    server.runlinter = true;
    run(server);
        ]],
    },
    settings = {
        julia = {
            usePlotPane = false,
            symbolCacheDownload = true,
            runtimeCompletions = true,
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
    filetypes = { "julia" },
}
