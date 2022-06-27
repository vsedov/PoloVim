local bind = require("keymap.bind")
local map_cr = bind.map_cr
local map_cu = bind.map_cu
local map_cmd = bind.map_cmd
local map_args = bind.map_args

local plug_map = {
    ["n|<Leader>U"] = map_cmd('<cmd>lua require"utils.telescope".find_updir()<CR>', "Up dir")
        :with_noremap()
        :with_silent(),
    ["n|<leader>hW"] = map_cmd('<cmd>lua require"utils.telescope".help_tags()<CR>', "Help tag")
        :with_noremap()
        :with_silent(),

    ["n|<Leader>hwd"] = map_cmd('<cmd>lua require"utils.telescope".howdoi()<CR>', "Howdoi search")
        :with_noremap()
        :with_silent(),
    ["n|<Leader>gw"] = map_cmd('<cmd>lua require"utils.telescope".grep_last_search()<CR>', "Grep last word")
        :with_noremap()
        :with_silent(),
    ["n|<Leader>cb"] = map_cmd('<cmd>lua require"utils.telescope".curbuf()<CR>', "Show current buffer")
        :with_noremap()
        :with_silent(),

    ["n|<Leader>ip"] = map_cmd('<cmd>lua require"utils.telescope".installed_plugins()<CR>', "Show installed plguins")
        :with_noremap()
        :with_silent(),
    ["n|<Leader>ch"] = map_cmd('<cmd>lua require"utils.telescope".command_history()<CR>', "Command History")
        :with_noremap()
        :with_silent(),

    ["n|<Leader>ir"] = map_cmd('<cmd>lua require"utils.telescope".lsp_references()<CR>', "Tel lsp_references")
        :with_noremap()
        :with_silent(),

    ["v|<Leader>ga"] = map_cmd("<cmd>lua require('utils.telescope').code_actions()<CR>", "Tel code_actions ")
        :with_noremap()
        :with_silent(),
    ["n|<Leader>bb"] = map_cu("Telescope buffers", "all buffers"):with_noremap():with_silent(),

    ["n|<Leader>yy"] = map_cmd('<cmd>lua require"utils.telescope".neoclip()<CR>', "NeoClip")
        :with_noremap()
        :with_silent(),
}

return plug_map
