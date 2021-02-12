local gl = require('galaxyline')
local gls=gl.section
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

local buffer_not_empty = function()
  if vim.fn.empty(vim.fn.expand('%:t')) ~= 1 then
    return true
  end
  return false
end

gls.left[1] = {
  ViMode = {
    provider = function()
      -- auto change color according the vim mode
      local mode_color = {n = colors.magenta, i = colors.green,v=colors.blue,[''] = colors.blue,V=colors.blue,
                          c = colors.red,no = colors.magenta,s = colors.orange,S=colors.orange,
                          [''] = colors.orange,ic = colors.yellow,R = colors.purple,Rv = colors.purple,
                          cv = colors.red,ce=colors.red, r = colors.cyan,rm = colors.cyan, ['r?'] = colors.cyan,
                          ['!']  = colors.red,t = colors.red}
      vim.api.nvim_command('hi GalaxyViMode guifg='..mode_color[vim.fn.mode()])
      return '▊ '
    end,
    highlight = {colors.red,colors.line_bg,'bold'},
  },
}
gls.left[2] ={
  FileIcon = {
    provider = 'FileIcon',
    condition = buffer_not_empty,
    highlight = {require('galaxyline.provider_fileinfo').get_file_icon_color,colors.line_bg},
  },
}
gls.left[3] = {
  FileName = {
    provider = {'FileName','FileSize'},
    condition = buffer_not_empty,
		separator = ' ',
    separator_highlight = {colors.fg,colors.line_bg},
    highlight = {colors.fg,colors.line_bg,'bold'}
  }
}
gls.left[4] = {
  DiagnosticError = {
    provider = 'DiagnosticError',
    icon = '  ',
    highlight = {colors.red,colors.line_bg}
  }
}
gls.left[5] = {
  DiagnosticWarn = {
    provider = 'DiagnosticWarn',
    icon = '  ',
    highlight = {colors.blue,colors.line_bg},
  }
}
gls.left[6] = {
  LeftEnd = {
    provider = function() return ' ' end,
		separator = '',
    highlight = {colors.line_bg,colors.line_bg},
    separator_highlight = {colors.line_bg,colors.bg},
  }
}
gls.right[1]= {
  BeginRight = {
    provider = function() return ' ' end,
    separator = '',
    separator_highlight = {colors.line_bg,colors.bg},
    highlight = {colors.fg,colors.line_bg},
  }
}
gls.right[2]= {
  FileFormat = {
    provider = 'FileFormat',
    separator = '',
    separator_highlight = {colors.line_bg,colors.bg},
    highlight = {colors.fg,colors.line_bg},
  }
}
gls.right[3] = {
  LineInfo = {
    provider = 'LineColumn',
    separator = ' | ',
    separator_highlight = {colors.blue,colors.line_bg},
    highlight = {colors.fg,colors.line_bg},
  },
}
gls.right[4] = {
  PerCent = {
    provider = 'LinePercent',
    separator = ' ',
    separator_highlight = {colors.line_bg,colors.line_bg},
    highlight = {colors.fg,colors.line_bg},
  }
}

gls.short_line_left[1] = {
  BufferType = {
    provider = 'FileTypeName',
		separator = '',
    separator_highlight = {colors.purple,colors.bg},
    highlight = {colors.fg,colors.purple}
  }
}


gls.short_line_right[1] = {
  BufferIcon = {
    provider= 'BufferIcon',
    separator = '',
    separator_highlight = {colors.purple,colors.bg},
    highlight = {colors.fg,colors.purple}
  }
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
