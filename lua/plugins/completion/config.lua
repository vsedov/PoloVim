-- local global = require("core.global")
local config = {}
function config.luasnip()
if lambda.config.use_adv_snip then
    require("modules.completion.snippets")
    require("luasnip_snippets.common.snip_utils").setup()
    require("luasnip").setup({
	-- Required to automatically include base snippets, like "c" snippets for "cpp"
	load_ft_func = require("luasnip_snippets.common.snip_utils").load_ft_func,
	ft_func = require("luasnip_snippets.common.snip_utils").ft_func,
	-- To enable auto expansin
	enable_autosnippets = true,
	-- Uncomment to enable visual snippets triggered using <c-x>
	-- store_selection_keys = '<c-x>',
    })
end
require("luasnip.loaders.from_vscode").lazy_load({
    paths = { vim.fn.stdpath("config") .. "/snippets" },
})
end
function config.neotab()
	require("neotab").setup({})
end

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
function config.tabnine_cmp()
    local tabnine = require("cmp_tabnine.config")
    tabnine:setup({
        max_lines = 1000,
        max_num_results = 10,
        sort = true,
        run_on_every_keystroke = true,
        snippet_placeholder = lambda.style.icons.misc.ellipsis,
        ignored_file_types = {
            norg = true,
        },
        show_prediction_strength = true,
    })
end

return config
