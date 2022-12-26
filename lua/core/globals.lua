_G = _G or {}
_G.lambda = {}
require('core.lambda')

P = vim.pretty_print

_G.dump = function(...)
  local objects = vim.tbl_map(vim.inspect, { ... })
  if #objects == 0 then
    print('nil')
  end
  print(unpack(objects))
  return ...
end

---Reloads a module
---@param module string Name of the module
_G.RELOAD = function(module)
  return require('plenary.reload').reload_module(module)
end
