local M = {}

-- @param map {{mode, lhs, rhs, opts}, ..}
-- @param mode string 'n' | 'i' | 'v'
-- @param lhs string key to map
-- @param rhs string command to run
M.keymap = function(map)
  map = map or {}
  local opts = map[4] or {}
  return vim.api.nvim_set_keymap(map[1], map[2], map[3], opts)
end

-- @param maps list of keymaps
M.keymaps = function(maps)
  for _, m in ipairs(maps) do M.keymap(m) end
end

-- Skip these servers for formatting
local skip_formatting_lsp = {"diagnosticls", "sumneko_lua", "tsserver"}

-- Format the file using the lsp formatter
M.lsp_format = function()
  -- @param client lsp client
  local format = function(client)
    print(string.format("Formatting for attached client: %s", client.name))

    vim.lsp.buf.formatting_sync(nil, 1000)
  end

  -- Run the function if it passes all the checks
  -- @param client lsp client
  local once = function(client)
    return function(skip, f)
      for _, key in ipairs(skip) do if client.name == key then return end end

      f(client)
    end
  end

  -- Run our formatters
  for _, client in pairs(vim.lsp.buf_get_clients()) do once(client)(skip_formatting_lsp, format) end
end

return M