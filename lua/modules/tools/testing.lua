local M = {}
local HOME = os.getenv("HOME")
local api = vim.api

local loader = require("packer").loader

M.testStart = function()
  loader("vim-test")
  loader("vim-ultest")

  vim.g["test#python#pytest#executable"] = "pytest"
  vim.g["test#strategy"] = { nearest = "neovim", file = "neovim", suite = "neovim" }
  vim.g["test#neovim#term_position"] = "vert botright 60"
  vim.g["test#go#runner"] = "ginkgo"

  require("ultest").setup({
    builders = {
      ["python#pytest"] = function(cmd)
        local non_modules = { "python", "pipenv", "poetry" }
        -- Index of the python module to run the test.
        local module
        if vim.tbl_contains(non_modules, cmd[1]) then
          module = cmd[3]
        else
          module = cmd[1]
        end
        -- Remaining elements are arguments to the module
        return {
          dap = {
            type = "python",
            request = "launch",
            module = module,
            args = args,
            cwd = vim.fn.getcwd(),

            pathMappings = {
              {
                localRoot = vim.fn.getcwd(), -- Wherever your Python code lives locally.
              },
            },
          },
        }
      end,
    },
  })

  -- Auto attach, very nice to have around .
  vim.api.nvim_exec(
    [[
augroup UltestRunner
    au!
    au BufWritePost * UltestNearest
augroup END
]],
    false
  )
end

return M
