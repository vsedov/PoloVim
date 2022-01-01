local bind = require("keymap.bind")
local map_cr = bind.map_cr
local map_cu = bind.map_cu
local map_cmd = bind.map_cmd

-- default map
local def_map = {
  -- Vim map
  ["n|<C-x>k"] = map_cr("Sayonara"):with_noremap():with_silent(),
  ["n|Y"] = map_cmd("y$"),
  ["n|]w"] = map_cu("WhitespaceNext"):with_noremap(),
  ["n|[w"] = map_cu("WhitespacePrev"):with_noremap(),
  ["n|]b"] = map_cu("bp"):with_noremap(),
  ["n|[b"] = map_cu("bn"):with_noremap(),

  ["n|<Leader>w"] = map_cu("write"):with_noremap(),
  ["n|<Leader>q"] = map_cr("Sayonara"):with_noremap(),

  ["n|<Space>cw"] = map_cu([[silent! keeppatterns %substitute/\s\+$//e]]):with_noremap():with_silent(),

  ["n|<C-h>"] = map_cmd("<C-w>h"):with_noremap(),
  ["n|<C-l>"] = map_cmd("<C-w>l"):with_noremap(),
  ["n|<C-j>"] = map_cmd("<C-w>j"):with_noremap(),
  ["n|<C-k>"] = map_cmd("<C-w>k"):with_noremap(),

  ["n|<A-[>"] = map_cr("vertical resize -5"):with_silent(),
  ["n|<A-]>"] = map_cr("vertical resize +5"):with_silent(),
  ["n|<C-q>"] = map_cmd(":wq<CR>"),

  ["n|<Leader>ss"] = map_cu("SessionSave"):with_noremap(),
  ["n|<Leader>sl"] = map_cu("SessionLoad"):with_noremap(),

  -- Insert
  ["i|<C-w>"] = map_cmd("<C-[>diwa"):with_noremap(),
  ["i|<C-h>"] = map_cmd("<BS>"):with_noremap(),
  ["i|<C-d>"] = map_cmd("<Del>"):with_noremap(),
  ["i|<C-u>"] = map_cmd("<C-G>u<C-U>"):with_noremap(),
  ["i|<C-b>"] = map_cmd("<Left>"):with_noremap(),
  ["i|<C-f>"] = map_cmd("<Right>"):with_noremap(),

  -- ["i|<C-s>"] = map_cmd("<Esc>:w<!CR>"),
  -- ["i|<C-q>"] = map_cmd("<Esc>:wq<CR>"),

  ["i|<C-e>"] = map_cmd([[pumvisible() ? "\<C-e>" : "\<End>"]]):with_noremap():with_expr(),

  -- command line
  ["c|<C-b>"] = map_cmd("<Left>"):with_noremap(),
  ["c|<C-f>"] = map_cmd("<Right>"):with_noremap(),
  ["c|<C-a>"] = map_cmd("<Home>"):with_noremap(),
  ["c|<C-e>"] = map_cmd("<End>"):with_noremap(),
  ["c|<C-d>"] = map_cmd("<Del>"):with_noremap(),
  ["c|<C-h>"] = map_cmd("<BS>"):with_noremap(),
  ["c|<C-t>"] = map_cmd([[<C-R>=expand("%:p:h") . "/" <CR>]]):with_noremap(),

  -- Nice animation
  ["n|<Up>"] = map_cmd("<cmd> call animate#window_delta_height(10)<CR>"):with_noremap():with_silent(),
  ["n|<Down>"] = map_cmd("<cmd> call animate#window_delta_height(-10)<CR>"):with_noremap():with_silent(),
  ["n|<Left>"] = map_cmd("<cmd> call animate#window_delta_width(10)<CR>"):with_noremap():with_silent(),
  ["n|<Right>"] = map_cmd("<cmd> call animate#window_delta_width(-10)<CR>"):with_noremap():with_silent(),
}

local os_map = {
  ["n|<c-s>"] = map_cu("write"):with_noremap(),
  ["i|<c-s>"] = map_cu('"normal :w"'):with_noremap():with_silent(),
  ["v|<c-s>"] = map_cu('"normal :w"'):with_noremap():with_silent(),
  ["i|<C-q>"] = map_cmd("<Esc>:wq<CR>"),
}

local global = require("core.global")
if global.is_mac then
  os_map = {
    ["n|<d-s>"] = map_cu("w"):with_silent(),
    ["i|<d-s>"] = map_cu('"normal :w"'):with_noremap():with_silent(),
    ["v|<d-s>"] = map_cu('"normal :w"'):with_noremap():with_silent(),

    ["n|<d-w>"] = map_cu("wqa!"):with_silent(),
    ["i|<d-w>"] = map_cu('"normal :wqa!"'):with_noremap():with_silent(),
    ["v|<d-w>"] = map_cu('"normal :wqa!"'):with_noremap():with_silent(),
  }
end

-- def_map = vim.list_extend(def_map, os_map)
def_map = vim.tbl_extend("keep", def_map, os_map)

bind.nvim_load_mapping(def_map)
