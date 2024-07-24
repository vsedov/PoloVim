local enhance_attach = require("modules.lsp.lsp.config").enhance_attach
local clangd_defaults = require("lspconfig.server_configurations.clangd")
local clangd_configs = vim.tbl_deep_extend(
    "force",
    clangd_defaults["default_config"],
    enhance_attach({
        cmd = {
            "clangd",
            "-j=16",
            "--background-index",
            "--clang-tidy",
            "--fallback-style=llvm",
            "--all-scopes-completion",
            "--completion-style=detailed",
            "--header-insertion=iwyu",
            "--header-insertion-decorators",
            "--pch-storage=memory",
        },
    })
)
require("clangd_extensions").setup({
    server = clangd_configs,
    extensions = {
        autoSetHints = true,
        hover_with_actions = true,
        -- These apply to the default ClangdSetInlayHints command
        inlay_hints = {

            -- Only show inlay hints for the current line
            only_current_line = true,
            -- Event which triggers a refersh of the inlay hints.
            -- You can make this "CursorMoved" or "CursorMoved,CursorMovedI" but
            -- not that this may cause  higher CPU usage.
            -- This option is only respected when only_current_line and
            -- autoSetHints both are true.
            only_current_line_autocmd = "CursorHold",
            -- whether to show parameter hints with the inlay hints or not
            show_parameter_hints = true,
            -- prefix for parameter hints
            parameter_hints_prefix = "<- ",
            -- prefix for all the other hints (type, chaining)
            other_hints_prefix = "=> ",
            -- whether to align to the length of the longest line in the file
            max_len_align = false,
            -- padding from the left if max_len_align is true
            max_len_align_padding = 1,
            -- whether to align to the extreme right or not
            right_align = false,
            -- padding from the right if right_align is true
            right_align_padding = 7,
            -- The color of the hints
            highlight = "Comment",
        },
    },
})
