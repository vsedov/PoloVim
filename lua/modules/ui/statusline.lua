local M = {}

local added = {}

local left_fn = function()
  return ""
end
local right_fn = function()
  return ""
end

M.left_components = { init = left_fn }
M.right_components = { init = right_fn }

M.add_component = function(name, comp, opts)
  opts = vim.tbl_deep_extend("keep", opts or {}, {
    dir = nil,
    left = true,
  })
  if added[name] then
    return
  end

  comp = vim.tbl_extend("keep", {}, comp)
  if opts.dir then
    local condition = comp.condition
    comp.condition = function(self)
      local cwd = vim.fn.getcwd()
      if cwd:sub(1, opts.dir:len()) ~= opts.dir then
        return false
      end
      if condition then
        return condition(self)
      else
        return true
      end
    end
  end
  if opts.left then
    comp = {
      condition = comp.condition,
      { provider = " " },
      comp,
    }
  else
    comp = {
      condition = comp.condition,
      comp,
      { provider = " " },
    }
  end

  added[name] = true

  if not package.loaded.heirline then
    if opts.left then
      table.insert(M.left_components, comp)
    else
      table.insert(M.right_components, comp)
    end
  else
    local statusline = require("heirline").statusline
    local parent = statusline:find(function(c)
      return (opts.left and c.init == left_fn) or (not opts.left and c.init == right_fn)
    end)
    local index = #parent + 1
    parent[index] = parent:new(comp, index)
  end
end

return M
