-- Get the default dict of patterns
local patterns = require"nrpattern.default"

-- The dict uses the pattern as key, and has a dict of options as value.
-- To add a new pattern, for example the VHDL x"aabb" format.
patterns['()x"(%x+)"'] = {
  base = 16, -- Hexadecimal
  format = '%sx"%s"', -- Output format
  priority = 15, -- Determines order in pattern matching
}

-- Change a default setting:
patterns["(%d*)'h([%x_]+)"].separator.group = 8

-- Remove a pattern
patterns["(%d*)'h([%x_]+)"] = nil

-- Call the setup to enable the patterns
require"nrpattern".setup(patterns)


-- <ctrl-a> and <ctrl-x>