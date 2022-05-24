local config = {}

function config.syntax_surfer()
    local default_keymaps = {
        { "n", "vd", '<cmd>lua require("syntax-tree-surfer").move("n", false)<cr>' },
        { "n", "vu", '<cmd>lua require("syntax-tree-surfer").move("n", true)<cr>' },
        -- .select() will show you what you will be swapping with .move(), you'll get used to .select() and .move() behavior quite soon!
        { "n", "vx", '<cmd>lua require("syntax-tree-surfer").select()<cr>' },
        -- .select_current_node() will select the current node at your cursor
        { "n", "vn", '<cmd>lua require("syntax-tree-surfer").select_current_node()<cr>' },

        { "x", "J", '<cmd>lua require("syntax-tree-surfer").surf("next", "visual")<cr>' },
        { "x", "K", '<cmd>lua require("syntax-tree-surfer").surf("prev", "visual")<cr>' },
        { "x", "H", '<cmd>lua require("syntax-tree-surfer").surf("parent", "visual")<cr>' },
        { "x", "L", '<cmd>lua require("syntax-tree-surfer").surf("child", "visual")<cr>' },

        { "x", "<A-j>", '<cmd>lua require("syntax-tree-surfer").surf("next", "visual", true)<cr>' },
        { "x", "<A-k>", '<cmd>lua require("syntax-tree-surfer").surf("prev", "visual", true)<cr>' },
    }
    for _, m in ipairs(default_keymaps) do
        vim.keymap.set(m[1], m[2], m[3], { noremap = true, silent = true })
    end
end

function config.hexokinase()
    vim.g.Hexokinase_optInPatterns = {
        "full_hex",
        "triple_hex",
        "rgb",
        "rgba",
        "hsl",
        "hsla",
        "colour_names",
    }
    vim.g.Hexokinase_highlighters = {
        "virtual",
        "sign_column", -- 'background',
        "backgroundfull",
        -- 'foreground',
        -- 'foregroundfull'
    }
end

-- use normal config for now
function config.gomove()
    require("gomove").setup({
        -- whether or not to map default key bindings, (true/false)
        map_defaults = true,
        -- what method to use for reindenting, ("vim-move" / "simple" / ("none"/nil))
        reindent_mode = "vim-move",
        -- whether to not to move past end column when moving blocks horizontally, (true/false)
        move_past_end_col = false,
        -- whether or not to ignore indent when duplicating lines horizontally, (true/false)
        ignore_indent_lh_dup = true,
    })
end

-- Exit                  <Esc>       quit VM
-- Find Under            <C-n>       select the word under cursor
-- Find Subword Under    <C-n>       from visual mode, without word boundaries
-- Add Cursor Down       <M-Down>    create cursors vertically
-- Add Cursor Up         <M-Up>      ,,       ,,      ,,
-- Select All            \\A         select all occurrences of a word
-- Start Regex Search    \\/         create a selection with regex search
-- Add Cursor At Pos     \\\         add a single cursor at current position
-- Reselect Last         \\gS        reselect set of regions of last VM session

-- Mouse Cursor    <C-LeftMouse>     create a cursor where clicked
-- Mouse Word      <C-RightMouse>    select a word where clicked
-- Mouse Column    <M-C-RightMouse>  create a column, from current cursor to
--                                   clicked position
function config.vmulti()
    vim.g.VM_mouse_mappings = 1
    -- mission control takes <C-up/down> so remap <M-up/down> to <C-Up/Down>
    -- vim.api.nvim_set_keymap("n", "<M-n>", "<C-n>", {silent = true})
    -- vim.api.nvim_set_keymap("n", "<M-Down>", "<C-Down>", {silent = true})
    -- vim.api.nvim_set_keymap("n", "<M-Up>", "<C-Up>", {silent = true})
    -- for mac C-L/R was mapped to mission control
    -- print('vmulti')
    vim.g.VM_silent_exit = 1
    vim.g.VM_show_warnings = 0
    vim.g.VM_default_mappings = 1
    vim.cmd([[
      let g:VM_maps = {}
      let g:VM_maps['Find Under'] = '<C-n>'
      let g:VM_maps['Find Subword Under'] = '<C-n>'
      let g:VM_maps['Select All'] = '<C-n>a'
      let g:VM_maps['Seek Next'] = 'n'
      let g:VM_maps['Seek Prev'] = 'N'
      let g:VM_maps["Undo"] = 'u'
      let g:VM_maps["Redo"] = '<C-r>'
      let g:VM_maps["Remove Region"] = '<cr>'
      let g:VM_maps["Add Cursor Down"] = '<M-Down>'
      let g:VM_maps["Add Cursor Up"] = "<M-Up>"
      let g:VM_maps["Mouse Cursor"] = "<M-LeftMouse>"
      let g:VM_maps["Mouse Word"] = "<M-RightMouse>"
      let g:VM_maps["Add Cursor At Pos"] = '<M-i>'
  ]])
end

return config
