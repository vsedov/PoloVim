local M = {}
local HOME = os.getenv("HOME")
local api = vim.api
local async = require("plenary.async")
local notify = require("notify").async

local bind = require("keymap.bind")

local map_cr = bind.map_cr
local map_cu = bind.map_cu
local map_cmd = bind.map_cmd
local map_args = bind.map_args
vim.notify = require("notify")

local function snip_run_binds()
  local keys = {
    ["v|<Leader>sr"] = map_cu("'<,'>SnipRun<cr>"):with_noremap():with_silent(),
    ["n|<Leader>sr"] = map_cu("SnipRun<cr>"):with_noremap():with_silent(),
  }
  bind.nvim_load_mapping(keys)
end

local function magma_binds()
  local keys = {
    ["n|<leader>ai"] = map_cu("MagmaInit<cr>"):with_silent(),
    -- ["n|<leader>ar"] = map_cmd("nvim_exec('MagmaEvaluateOperator', v:true)"):with_silent():with_expr(),

    -- TODO GET THIS SETUP
    -- nnoremap <silent>       <Leader>ai :MagmaInit<CR>

    -- nnoremap <expr><silent> <Leader>a  nvim_exec('MagmaEvaluateOperator', v:true)
    -- nnoremap <silent>       <Leader>ar :MagmaEvaluateLine<CR>
    -- xnoremap <silent>       <Leader>a :<C-u>MagmaEvaluateVisual<CR>
    -- nnoremap <silent>       <Leader>ac :MagmaReevaluateCell<CR>

    -- nnoremap <silent> <Leader>ad :MagmaDelete<CR>
    -- nnoremap <silent> <Leader>ao :MagmaShowOutput<CR>
  }
  bind.nvim_load_mapping(keys)
end

M.SnipRun = function()
  vim.notify("SnipRun Loaded")
  loader("sniprun")
  snip_run_binds()
end

-- Call :TestStart on any test file for python
M.testStart = function()
  loader("vim-test")
  loader("vim-ultest")
  vim.g["test#python#pytest#executable"] = "pytest"
  vim.g["test#python#pytest#options"] = "--disable-warnings --color=yes"

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

M.python_repl = function()
  local loader = require("packer").loader

  vim.notify("Python REPL Plugins Loaded")
  loader("magma-nvim")
  vim.cmd([[UpdateRemotePlugins]])

  magma_binds()

  SnipRun()
end

return M
