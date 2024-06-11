require("lambda.options")
require("lambda.helper")
require("lambda.styles")
require("lambda.highlights")
require("lambda.fzf")
require("lambda.event")

local distro, v = lambda.distro()
if distro then
    if distro == false then
        lambda.config.lsp.use_sg = false
    else
        lambda.config.lsp.use_sg = true
    end
end
