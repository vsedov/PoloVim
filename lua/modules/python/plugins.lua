local conf = require("modules.python.config")
local python = require("core.pack").package

python({
    "ranelpadon/python-copy-reference.vim",
    event = "BufReadPre *.py",
    lazy = true,
    cmd = {
        "PythonCopyReferenceDotted",
        "PythonCopyReferencePytest",
        "PythonCopyReferenceImport",
    },
})

python({
    "direnv/direnv.vim",
    event = "BufReadPre *.py",
    lazy = true,
})

python({
    "linux-cultist/venv-selector.nvim",
    dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim" },
    cmd = { "VenvSelect", "VenvSelectCached" },
    config = true,
})

python({
    "Vimjas/vim-python-pep8-indent",
    event = "BufReadPre *.py",
})

python({
    "purpleP/python-syntax",
    event = "BufReadPre *.py",
})

python({
    "luk400/vim-jukit",
    cond = false,
    ft = { "python", "julia" },
    lazy = true,
    config = function()
        vim.g.jukit_terminal = "kitty"
        vim.cmd([[
        fun! DFColumns()
            let visual_selection = jukit#util#get_visual_selection()
            let cmd = visual_selection . '.columns'
            call jukit#send#send_to_split(cmd)
        endfun

        fun! PythonHelp()
            let visual_selection = jukit#util#get_visual_selection()
            let cmd = 'help(' . visual_selection . ')'
            call jukit#send#send_to_split(cmd)
        endfun
        
        vnoremap ;H :call PythonHelp()<cr>
        vnoremap ;C :call DFColumns()<cr>

            nnoremap ;<leader>os :call jukit#splits#output()<cr>
            "   - Opens a new output window and executes the command specified in `g:jukit_shell_cmd`
            nnoremap ;<leader>ts :call jukit#splits#term()<cr>
            "   - Opens a new output window without executing any command
            nnoremap ;<leader>hs :call jukit#splits#history()<cr>
            "   - Opens a new output-history window, where saved ipython outputs are displayed
            nnoremap ;<leader>ohs :call jukit#splits#output_and_history()<cr>
            "   - Shortcut for opening output terminal and output-history
            nnoremap ;<leader>hd :call jukit#splits#close_history()<cr>
            "   - Close output-history window
            nnoremap ;<leader>od :call jukit#splits#close_output_split()<cr>
            "   - Close output window
            nnoremap ;<leader>ohd :call jukit#splits#close_output_and_history(1)<cr>
            "   - Close both windows. Argument: Whether or not to ask you to confirm before closing.
            nnoremap ;<leader>so :call jukit#splits#show_last_cell_output(1)<cr>
            "   - Show output of current cell (determined by current cursor position) in output-history window. Argument: Whether or not to reload outputs if cell id of outputs to display is the same as the last cell id for which outputs were displayed
            nnoremap ;<leader>j :call jukit#splits#out_hist_scroll(1)<cr>
            "   - Scroll down in output-history window. Argument: whether to scroll down (1) or up (0)
            nnoremap ;<leader>k :call jukit#splits#out_hist_scroll(0)<cr>
            "   - Scroll up in output-history window. Argument: whether to scroll down (1) or up (0)
            nnoremap ;<leader>ah :call jukit#splits#toggle_auto_hist()<cr>
            "   - Create/delete autocmd for displaying saved output on CursorHold. Also, see explanation for `g:jukit_auto_output_hist`
            nnoremap ;<leader>sl :call jukit#layouts#set_layout()<cr>
            "   - Apply layout (see `g:jukit_layout`) to current splits - NOTE: it is expected that this function is called from the main file buffer/split


            nnoremap ;<leader><space> :call jukit#send#section(0)<cr>
            "   - Send code within the current cell to output split (also saves the output if ipython is used and `g:jukit_save_output==1`). Argument: if 1, will move the cursor to the next cell below after sending the code to the split, otherwise cursor position stays the same.
            nnoremap <leader><cr> :call jukit#send#line()<cr>
            "   - Send current line to output split
            vnoremap <leader><cr> :<C-U>call jukit#send#selection()<cr>
            "   - Send visually selected code to output split
            nnoremap ;<leader>cc :call jukit#send#until_current_section()<cr>
            "   - Execute all cells until the current cell
            nnoremap ;<leader>all :call jukit#send#all()<cr>
            "   - Execute all 

            nnoremap ;<leader>co :call jukit#cells#create_below(0)<cr>
            "   - Create new code cell below. Argument: Whether to create code cell (0) or markdown cell (1)
            nnoremap ;<leader>cO :call jukit#cells#create_above(0)<cr>
            "   - Create new code cell above. Argument: Whether to create code cell (0) or markdown cell (1)
            nnoremap ;<leader>ct :call jukit#cells#create_below(1)<cr>
            "   - Create new textcell below. Argument: Whether to create code cell (0) or markdown cell (1)
            nnoremap ;<leader>cT :call jukit#cells#create_above(1)<cr>
            "   - Create new textcell above. Argument: Whether to create code cell (0) or markdown cell (1)
            nnoremap ;<leader>cd :call jukit#cells#delete()<cr>
            "   - Delete current cell
            nnoremap ;<leader>cs :call jukit#cells#split()<cr>
            "   - Split current cell (saved output will then be assigned to the resulting cell above)
            nnoremap ;<leader>cM :call jukit#cells#merge_above()<cr>
            "   - Merge current cell with the cell above
            nnoremap ;<leader>cm :call jukit#cells#merge_below()<cr>
            "   - Merge current cell with the cell below
            nnoremap ;<leader>ck :call jukit#cells#move_up()<cr>
            "   - Move current cell up
            nnoremap ;<leader>cj :call jukit#cells#move_down()<cr>
            "   - Move current cell down
            nnoremap ;<leader>J :call jukit#cells#jump_to_next_cell()<cr>
            "   - Jump to the next cell below
            nnoremap ;<leader>K :call jukit#cells#jump_to_previous_cell()<cr>
            "   - Jump to the previous cell above
            nnoremap ;<leader>ddo :call jukit#cells#delete_outputs(0)<cr>
            "   - Delete saved output of current cell. Argument: Whether to delete all saved outputs (1) or only saved output of current cell (0)
            nnoremap ;<leader>dda :call jukit#cells#delete_outputs(1)<cr>
            "   - Delete saved outputs of all cells. Argument: Whether to delete all saved outputs (1) or only saved output of current cell (0)


            nnoremap ;<leader>np :call jukit#convert#notebook_convert("jupyter-notebook")<cr>
            "   - Convert from ipynb to py or vice versa. Argument: Optional. If an argument is specified, then its value is used to open the resulting ipynb file after converting script.
            nnoremap ;<leader>ht :call jukit#convert#save_nb_to_file(0,1,'html')<cr>
            "   - Convert file to html (including all saved outputs) and open it using the command specified in `g:jukit_html_viewer'. If `g:jukit_html_viewer` is not defined, then will default to `g:jukit_html_viewer='xdg-open'`. Arguments: 1.: Whether to rerun all cells when converting 2.: Whether to open it after converting 3.: filetype to convert to 
            nnoremap ;<leader>rht :call jukit#convert#save_nb_to_file(1,1,'html')<cr>
            "   - same as above, but will (re-)run all cells when converting to html
            nnoremap ;<leader>pd :call jukit#convert#save_nb_to_file(0,1,'pdf')<cr>
            "   - Convert file to pdf (including all saved outputs) and open it using the command specified in `g:jukit_pdf_viewer'. If `g:jukit_pdf_viewer` is not defined, then will default to `g:jukit_pdf_viewer='xdg-open'`. Arguments: 1.: Whether to rerun all cells when converting 2.: Whether to open it after converting 3.: filetype to convert to. NOTE: If the function doesn't work there may be issues with your nbconvert or latex version - to debug, try converting to pdf using `jupyter nbconvert --to pdf --allow-errors --log-level='ERROR' --HTMLExporter.theme=dark </abs/path/to/ipynb> && xdg-open </abs/path/to/pdf>` in your terminal and check the output for possible issues.
            nnoremap ;<leader>rpd :call jukit#convert#save_nb_to_file(1,1,'pdf')<cr>
            "   - same as above, but will (re-)run all cells when converting to pdf. NOTE: If the function doesn't work there may be issues with your nbconvert or latex version - to debug, try converting to pdf using `jupyter nbconvert --to pdf --allow-errors --log-level='ERROR' --HTMLExporter.theme=dark </abs/path/to/ipynb> && xdg-open </abs/path/to/pdf>` in your terminal and check the output for possible issues.
        ]])
    end,
})

--  TODO: (vsedov) (08:12:27 - 04/06/23): I am not sure if this is even viable
-- Will need to come back to this
python({
    "kiyoon/jupynium.nvim",
    build = "pip3 install --user .",
    ft = { "python" },
    config = true,
})
-- I forget this existed

python({
    "milanglacier/yarepl.nvim",
    lazy = true,
    cmd = {
        "REPLStart",
        "REPLAttachBufferToREPL",
        "REPLDetachBufferToREPL",
        "REPLCleanup",
        "REPLFocus",
        "REPLHide",
        "REPLClose",
        "REPLSwap",
        "REPLSendVisual",
        "REPLSendLine",
        "REPLSendMotion",
    },
    init = function()
        lambda.augroup("REPL", {
            {
                event = { "FileType" },
                pattern = { "quarto", "markdown", "markdown.pandoc", "rmd", "python", "sh", "REPL" },
                desc = "set up REPL keymap",
                command = function()
                    local utils = require("modules.editor.hydra.repl_utils")
                    vim.keymap.set("n", "<localleader>r", function()
                        vim.schedule_wrap(require("hydra")(require("modules.editor.hydra.normal.repl")):activate())
                    end, { desc = "Start an REPL", buffer = 0 })
                    vim.keymap.set("n", "<localleader>sc", utils.send_a_code_chunk, {
                        desc = "send a code chunk",
                        expr = true,
                        buffer = 0,
                    })
                end,
            },
        })
    end,
    config = function()
        vim.g.REPL_use_floatwin = 0
        require("yarepl").setup({
            wincmd = function(bufnr, name)
                if vim.g.REPL_use_floatwin == 1 then
                    vim.api.nvim_open_win(bufnr, true, {
                        relative = "editor",
                        row = math.floor(vim.o.lines * 0.25),
                        col = math.floor(vim.o.columns * 0.25),
                        width = math.floor(vim.o.columns * 0.5),
                        height = math.floor(vim.o.lines * 0.5),
                        style = "minimal",
                        title = name,
                        border = "rounded",
                        title_pos = "center",
                    })
                else
                    vim.cmd([[belowright 15 split]])
                    vim.api.nvim_set_current_buf(bufnr)
                end
            end,
        })
    end,
})

python({
    "raimon49/requirements.txt.vim",
    event = "BufReadPre requirements*.txt",
})
