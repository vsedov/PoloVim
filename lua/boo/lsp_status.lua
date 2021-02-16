

local lsp_status = require("lsp-status")

local status = {}

status.select_symbol = function(cursor_pos, symbol)
  if symbol.valueRange then
    local value_range = {
      ["start"] = {character = 0, line = vim.fn.byte2line(symbol.valueRange[1])},
      ["end"] = {character = 0, line = vim.fn.byte2line(symbol.valueRange[2])},
    }

    return require("lsp-status.util").in_range(cursor_pos, value_range)
  end
end

status.activate = function()
  lsp_status.config {select_symbol = status.select_symbol}

  lsp_status.register_progress()
end

return status

