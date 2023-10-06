-- local global = require("core.global")
local config = {}

function config.cmp()
    require("modules.completion.cmp")
end

function config.luasnip()
    require("modules.completion.snippets")
end

function config.snip_genie()
    local genie = require("SnippetGenie")
    genie.setup({
        regex = [[-\+ Snippets goes here]],
        snippets_directory = "/home/viv/.config/nvim/snippets/",
        file_name = "generated",
        snippet_skeleton = [[
        s(
            "{trigger}",
            fmt([=[
        {body}
        ]=], {{
                {nodes}
            }})
        ),
        ]],
    })

    lambda.command("SnipCreate", function()
        vim.notify("<cr> to start and ;<cr> to add the variables")
    end, { force = true })
end

function config.vim_sonictemplate()
    vim.g.sonictemplate_postfix_key = "<C-,>"
    vim.g.sonictemplate_vim_template_dir = os.getenv("HOME") .. "/.config/nvim/template"
end

return config
