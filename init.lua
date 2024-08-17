vim.deprecate = function() end
require("core")
-- -- We might be loading this twice
require("lz.n").register_handler(require("rocks_utils.rocks"))
require("lzn-auto-require.loader").register_loader()
