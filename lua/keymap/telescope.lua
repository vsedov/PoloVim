local bind = require("keymap.bind")
local map_cr = bind.map_cr
local map_cu = bind.map_cu
local map_cmd = bind.map_cmd
local map_args = bind.map_args

local plug_map = {
    ["n|<Leader>U"] = map_cmd('<cmd>lua require"utils.telescope".find_updir()<CR>',"Up dir"):with_noremap():with_silent(),
    ["n|<Leader>ff"] = map_cmd('<cmd>lua require"utils.telescope".find_files()<CR>', "Find Files"):with_noremap():with_silent(),
    ["n|<Leader>fF"] = map_cmd('<cmd>lua require"utils.telescope".files()<CR>',"Current dir files"):with_noremap():with_silent(),
    ["n|<Leader>fn"] = map_cmd('<cmd>lua require"utils.telescope".find_notes()<CR>',"My notes"):with_noremap():with_silent(),
    ["n|<Leader>fs"] = map_cmd('<cmd>lua require"utils.telescope".find_string()<CR>', "Find a string"):with_noremap():with_silent(),
    ["n|<Leader>ft"] = map_cmd('<cmd>lua require"utils.telescope".search_only_certain_files()<CR>',"Certain File search")
        :with_noremap()
        :with_silent(),
    ["n|<leader>hW"] = map_cmd('<cmd>lua require"utils.telescope".help_tags()<CR>', "Help tag"):with_noremap():with_silent(),
    -- grep
    ["n|<Leader>fW"] = map_cmd([['<cmd>lua require"telescope.builtin".live_grep()<cr>' . expand('<cword>')]], "Live grep")
        :with_expr()
        :with_silent(),
    ["n|<Leader>hwd"] = map_cmd('<cmd>lua require"utils.telescope".howdoi()<CR>',"Howdoi search"):with_noremap():with_silent(),

    ["n|<Leader>fw"] = map_cu("Telescope grep_string", "Basic Tele grep"):with_noremap():with_silent(),
    ["n|<Leader>gw"] = map_cmd('<cmd>lua require"utils.telescope".grep_last_search()<CR>',"Grep last word"):with_noremap():with_silent(),
    ["n|<Leader>cb"] = map_cmd('<cmd>lua require"utils.telescope".curbuf()<CR>', "Show current buffer"):with_noremap():with_silent(),
    ["n|<Leader>gv"] = map_cmd('<cmd>lua require"utils.telescope".grep_string_visual()<CR>', "Grep string visual")
        :with_noremap()
        :with_silent(),

    -- git
    ["n|<Leader>fg"] = map_cu("Telescope git_files","git files"):with_noremap():with_silent(),
    ["n|<Leader>fu"] = map_cmd('<cmd>lua require"utils.telescope".git_diff()<CR>',"show git diff"):with_noremap():with_silent(),
    ["n|<Leader>fb"] = map_cmd('<cmd>lua require("utils.telescope").file_browser()<cr>',"file browser"):with_noremap():with_silent(),
    ["n|<Leader>ip"] = map_cmd('<cmd>lua require"utils.telescope".installed_plugins()<CR>', "Show installed plguins")
        :with_noremap()
        :with_silent(),
    ["n|<Leader>ch"] = map_cmd('<cmd>lua require"utils.telescope".command_history()<CR>',"Command History"):with_noremap():with_silent(),
    -- Dot files
    ["n|<Leader>fd"] = map_cmd('<cmd>lua require"utils.telescope".load_dotfiles()<CR>',"Dotfiles"):with_noremap():with_silent(),
    -- Jump
    ["n|<Leader>fj"] = map_cmd('<cmd>lua require"utils.telescope".jump()<CR>', "Mark jump list"):with_noremap():with_silent(),
    -- lsp implmentation with telescope
    ["n|<Leader>ir"] = map_cmd('<cmd>lua require"utils.telescope".lsp_references()<CR>',"Tel lsp_references"):with_noremap():with_silent(),

    ["v|<Leader>ga"] = map_cmd("<cmd>lua require('utils.telescope').code_actions()<CR>","Tel code_actions "):with_noremap():with_silent(),
    ["n|<Leader>bb"] = map_cu("Telescope buffers","all buffers"):with_noremap():with_silent(),
    ["n|<Leader>fr"] = map_cmd("<cmd>Telescope registers<cr>"):with_noremap():with_silent(),
    ["n|<Leader>fZ"] = map_cr('<cmd>lua require("telescope").extensions.zoxide.list()',"Zoxide List"):with_silent(),

    ["n|<Leader>fl"] = map_cu("Telescope loclist","tel loclist"):with_noremap():with_silent(),
    ["n|<Leader>fc"] = map_cu("Telescope git_commits", "tel git commits"):with_noremap():with_silent(),
    ["n|<Leader>vv"] = map_cu("Telescope treesitter", "tel treesitter"):with_noremap():with_silent(),

    ["n|<Leader>yy"] = map_cmd('<cmd>lua require"utils.telescope".neoclip()<CR>', "NeoClip"):with_noremap():with_silent(),
}

return plug_map
