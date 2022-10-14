local Pkg = require("mason-core.package")
local lsp_util = require("vim.lsp.util")
local path = require("mason-core.path")
local util = require("lspconfig.util")
local index = require("mason-registry.index")

index["pylance"] = "modules.lsp.lsp.mason.foo"

local function installer(ctx)
    local script = [[
    curl -s -c cookies.txt 'https://marketplace.visualstudio.com/items?itemName=ms-python.vscode-pylance' > /dev/null &&
    curl -s "https://marketplace.visualstudio.com/_apis/public/gallery/publishers/ms-python/vsextensions/vscode-pylance/latest/vspackage"
         -j -b cookies.txt --compressed --output "pylance.vsix"
    ]]
    ctx.receipt:with_primary_source(ctx.receipt.unmanaged)
    ctx.spawn.bash({ "-c", script:gsub("\n", " ") })
    ctx.spawn.unzip({ "pylance.vsix" })
    ctx.spawn.bash({
        "-c",
        [[sed -i "0,/\(if(\!process\[[^] ]*\]\[[^] ]*\])return\!0x\)1/ s//\10/" extension/dist/server.bundle.js]],
    })
    ctx:link_bin(
        "pylance",
        ctx:write_node_exec_wrapper("pylance", path.concat({ "extension", "dist", "server.bundle.js" }))
    )
end
return Pkg.new({
    name = "pylance",
    desc = [[Fast, feature-rich language support for Python]],
    homepage = "https://github.com/microsoft/pylance",
    languages = { Pkg.Lang.Python },
    categories = { Pkg.Cat.LSP },
    install = installer,
})
