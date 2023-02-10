local bind = require("keymap.bind")
local map_cr = bind.map_cr
local map_cu = bind.map_cu
local map_cmd = bind.map_cmd
local map_args = bind.map_args

local plug_map = {
    ["n|<Leader>U"] = map_cmd('<cmd>lua require"utils.telescope".find_updir()<CR>', "Up dir")
        :with_noremap()
        :with_silent(),
    ["n|<leader>xW"] = map_cmd('<cmd>lua require"utils.telescope".help_tags()<CR>', "Help tag")
        :with_noremap()
        :with_silent(),

    ["n|<Leader>gw"] = map_cmd('<cmd>lua require"utils.telescope".grep_last_search()<CR>', "Grep last word")
        :with_noremap()
        :with_silent(),

    ["v|<Leader>gw"] = map_cmd('<cmd>lua require"utils.telescope".grep_string_visual()<CR>', "Grep last word")
        :with_noremap()
        :with_silent(),

    ["n|<Leader>ch"] = map_cmd('<cmd>lua require"utils.telescope".command_history()<CR>', "Command History")
        :with_noremap()
        :with_silent(),

    -- this is broken - fix later
    -- ["v|<Leader>ga"] = map_cmd("<cmd>lua require('utils.telescope').code_actions()<CR>", "Tel code_actions ")
    --     :with_noremap()
    --     :with_silent(),

    ["n|<Leader>yy"] = map_cmd('<cmd>lua require"utils.telescope".neoclip()<CR>', "NeoClip")
        :with_noremap()
        :with_silent(),

    ["n|<Leader>J"] = map_cmd(":TSJJoin<Cr>", "TSJJoin"):with_noremap():with_silent(),
    ["n|<Leader>j"] = map_cmd(":TSJToggle<cr>", "TSJToggle"):with_noremap():with_silent(),
}
-- vim.keymap.set("n", "<leader>J", function()
--     vim.cmd([[TSJJoin]])
-- end, { noremap = true, desc = "Spread: Expand" })
--
-- vim.keymap.set("n", "<leader>j", function()
--     vim.cmd([[TSJToggle]])
-- end, { noremap = true, desc = "Spread: Combine" })

return plug_map
