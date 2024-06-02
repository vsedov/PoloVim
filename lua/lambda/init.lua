require("lambda.options")
require("lambda.helper")
require("lambda.styles")
require("lambda.highlights")
require("lambda.fzf")
require("lambda.event")

local distro, v = lambda.distro()
if distro then
    if distro:find("Ubuntu") then
        lambda.config.use_kitty = false
        lambda.config.lsp.use_sg = false
    end
end
