require('bufferline').setup{
  options = {
    numbers = "buffer_id",
    number_style = "",
    mappings = true,
    modified_icon = '●',
    close_icon = '',
    left_trunc_marker = '',
    right_trunc_marker = '',
    max_name_length = 18,
    tab_size = 18,
    show_buffer_close_icons = false,
    -- can also be a table containing 2 custom separators
    -- [focused and unfocused]. eg: { '|', '|' }
    separator_style = { '', '' },
    -- enforce_regular_tabs = false | true,
    always_show_bufferline = true,
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
        }
    }
}





