local bind = require("keymap.bind")
local map_cr = bind.map_cr
local map_cu = bind.map_cu
local map_cmd = bind.map_cmd
local map_args = bind.map_args

local plug_map = {
    ["n|<Leader>up"] = map_cmd('<cmd>lua require"utils.telescope".find_updir()<CR>'):with_noremap():with_silent(),
    ["n|<Leader>ff"] = map_cmd('<cmd>lua require"utils.telescope".find_files()<CR>'):with_noremap():with_silent(),
    ["n|<Leader>fF"] = map_cmd('<cmd>lua require"utils.telescope".files()<CR>'):with_noremap():with_silent(),
    ["n|<Leader>fn"] = map_cmd('<cmd>lua require"utils.telescope".find_notes()<CR>'):with_noremap():with_silent(),
    ["n|<Leader>fs"] = map_cmd('<cmd>lua require"utils.telescope".find_string()<CR>'):with_noremap():with_silent(),
    ["n|<Leader>ft"] = map_cmd('<cmd>lua require"utils.telescope".search_only_certain_files()<CR>')
        :with_noremap()
        :with_silent(),
    ["n|<leader>hW"] = map_cmd('<cmd>lua require"utils.telescope".help_tags()<CR>'):with_noremap():with_silent(),
    -- grep
    ["n|<Leader>fW"] = map_cmd([['<cmd>lua require"telescope.builtin".live_grep()<cr>' . expand('<cword>')]])
        :with_expr()
        :with_silent(),
    ["n|<Leader>fw"] = map_cu("Telescope grep_string"):with_noremap():with_silent(),
    ["n|<Leader>gw"] = map_cmd('<cmd>lua require"utils.telescope".grep_last_search()<CR>'):with_noremap():with_silent(),
    ["n|<Leader>cb"] = map_cmd('<cmd>lua require"utils.telescope".curbuf()<CR>'):with_noremap():with_silent(),
    ["n|<Leader>gv"] = map_cmd('<cmd>lua require"utils.telescope".grep_string_visual()<CR>')
        :with_noremap()
        :with_silent(),
    -- git
    ["n|<Leader>fg"] = map_cu("Telescope git_files"):with_noremap():with_silent(),
    ["n|<Leader>fu"] = map_cmd('<cmd>lua require"utils.telescope".git_diff()<CR>'):with_noremap():with_silent(),
    ["n|<Leader>fb"] = map_cmd('<cmd>lua require("utils.telescope").file_browser()<cr>'):with_noremap():with_silent(),
    ["n|<Leader>ip"] = map_cmd('<cmd>lua require"utils.telescope".installed_plugins()<CR>')
        :with_noremap()
        :with_silent(),
    ["n|<Leader>ch"] = map_cmd('<cmd>lua require"utils.telescope".command_history()<CR>'):with_noremap():with_silent(),
    -- Dot files
    ["n|<Leader>fd"] = map_cmd('<cmd>lua require"utils.telescope".load_dotfiles()<CR>'):with_noremap():with_silent(),
    -- Jump
    ["n|<Leader>fj"] = map_cmd('<cmd>lua require"utils.telescope".jump()<CR>'):with_noremap():with_silent(),
    -- lsp implmentation with telescope
    ["n|<Leader>ir"] = map_cmd('<cmd>lua require"utils.telescope".lsp_references()<CR>'):with_noremap():with_silent(),

    ["v|<Leader>ga"] = map_cmd("<cmd>lua require('utils.telescope').code_actions()<CR>"):with_noremap():with_silent(),
    ["n|<Leader>bb"] = map_cu("Telescope buffers"):with_noremap():with_silent(),
    ["n|<Leader><C-r>"] = map_cu("Telescope registers"):with_noremap():with_silent(),
    ["n|<Leader>fr"] = map_cmd("<cmd>Telescope registers<cr>"):with_noremap():with_silent(),
    ["n|<Leader>fZ"] = map_cr('<cmd>lua require("telescope").extensions.zoxide.list()'):with_silent(),
    -- ["n|<Leader>fp"] = map_cr('<cmd>lua require("telescope").extensions.projects.projects()'):with_silent(),
    ["n|<Leader>fl"] = map_cu("Telescope loclist"):with_noremap():with_silent(),
    ["n|<Leader>fc"] = map_cu("Telescope git_commits"):with_noremap():with_silent(),
    ["n|<Leader>vv"] = map_cu("Telescope treesitter"):with_noremap():with_silent(),
    ["n|<Leader>y"] = map_cmd('<cmd>lua require"utils.telescope".neoclip()<CR>'):with_noremap():with_silent(),
}

return plug_map
