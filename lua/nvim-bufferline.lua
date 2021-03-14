local bufferline = require('bufferline')
local colors = {
    bg='#232629',
    line_bg='#31363b',
    fg='#eff0f1',
    yellow = '#f67400',
  cyan = '#1abc9c',
  darkblue = '#1d99f3',
  green = '#afd700',
  orange = '#FF8800',
  purple = '#5d4d7a',
  magenta = '#c678dd',
  blue = '#3daee9';
  red = '#ec5f67'
}



require('nvim-web-devicons').setup{
 -- your personnal icons can go here (to override)
 -- DevIcon will be appended to `name`
 -- globally enable default icons (default to false)
 -- will get overriden by `get_icons` option
 default = true;
}

require('bufferline').setup{
  options = {
    numbers = "buffer_id",
    number_style = "",
    mappings = false,
    modified_icon = '●',
    close_icon = '',
    left_trunc_marker = '',
    right_trunc_marker = '',
    max_name_length = 18,
    tab_size = 15,
    show_buffer_close_icons = false,
    -- can also be a table containing 2 custom separators
    -- [focused and unfocused]. eg: { '|', '|' }
    separator_style = { '', ''},
    -- enforce_regular_tabs = false | true,

    -- New test . 
    always_show_bufferline = true,

    always_show_bufferline = false,
    diagnostics = "nvim_lsp",
    diagnostics_indicator = function(count, level)
      local icon = level:match("error") and " " or ""
      return " " .. icon .. count
    end

    -- sort_by = 'extension' | 'directory' | function(buffer_a, buffer_b)
    --   -- add custom logic
    --   return buffer_a.modified > buffer_b.modified
    -- end
  },
    highlight = {
        bufferline_selected_indicator = {
            guibg = "none",
        },
        modified_selected = {
            guifg = '#ff5555',
            guibg = '#ffb86c'
        }

    }
}





