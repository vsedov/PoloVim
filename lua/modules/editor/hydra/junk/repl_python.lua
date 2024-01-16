local leader = ";<leader>"

local config = {
    Repl = {
        color = "blue",
        body = leader,
        mode = { "n", "v", "x" },
        w = {
            function()
                vim.cmd("call jukit#send#section(0)")
            end,
            {
                desc = "Send code within the current cell to output split (also saves the output if ipython is used and `g:jukit_save_output==1`). Argument: if 1, will move the cursor to the next cell below after sending the code to the split, otherwise cursor position stays the same.",
                exit = true,
                mode = { "v" },
            },
        },
        W = {
            function()
                vim.cmd("call jukit#send#line()")
            end,
            { desc = "Send current line to output split", exit = true, mode = { "v" } },
            ["<leader>"] = {
                function()
                    vim.cmd("call jukit#send#selection()")
                end,
                { desc = "Send visually selected code to output split", exit = true },
            },
        },

        os = {
            function()
                vim.cmd("call jukit#splits#output()")
            end,
            { desc = "New output window", exit = true },
        },
        ts = {
            function()
                vim.cmd("call jukit#splits#term()")
            end,
            { desc = "New output window without executing any command", exit = true },
        },
        hs = {
            function()
                vim.cmd("call jukit#splits#history()")
            end,
            { desc = "New output-history window, where saved ipython outputs are displayed", exit = true },
        },
        oS = {
            function()
                vim.cmd("call jukit#splits#output_and_history()")
            end,
            { desc = "Shortcut for opening output terminal and output-history", exit = true },
        },
        hd = {
            function()
                vim.cmd("call jukit#splits#close_history()")
            end,
            { desc = "Close output-history window", exit = true },
        },
        oC = {
            function()
                vim.cmd("call jukit#splits#close_output_split()")
            end,
            { desc = "Close output window", exit = true },
        },
        od = {
            function()
                vim.cmd("call jukit#splits#close_output_and_history(1)")
            end,
            {
                desc = "Close both windows. Argument: Whether or not to ask you to confirm before closing.",
                exit = true,
            },
        },
        so = {
            function()
                vim.cmd("call jukit#splits#show_last_cell_output(1)")
            end,
            {
                desc = "Show output of current cell (determined by current cursor position) in output-history window. Argument: Whether or not to reload outputs if cell id of outputs to display is the same as the last cell id for which outputs were displayed",
                exit = true,
            },
        },
        j = {
            function()
                vim.cmd("call jukit#splits#out_hist_scroll(1)")
            end,
            {
                desc = "Scroll down in output-history window. Argument: whether to scroll down (1) or up (0)",
                exit = true,
            },
        },
        k = {
            function()
                vim.cmd("call jukit#splits#out_hist_scroll(0)")
            end,
            {
                desc = "Scroll up in output-history window. Argument: whether to scroll down (1) or up (0)",
                exit = true,
            },
        },
        ah = {
            function()
                vim.cmd("call jukit#splits#toggle_auto_hist()")
            end,
            {
                desc = "Create/delete autocmd for displaying saved output on CursorHold. Also, see explanation for `g:jukit_auto_output_hist`",
                exit = true,
            },
        },
        sl = {
            function()
                vim.cmd("call jukit#layouts#set_layout()")
            end,
            {
                desc = "Apply layout (see `g:jukit_layout`) to current splits - NOTE: it is expected that this function is called from the main file buffer/split",
                exit = true,
            },
        },
        co = {
            function()
                vim.cmd("call jukit#cells#create_below(0)")
            end,
            {
                desc = "Create new code cell below. Argument: Whether to create code cell (0) or markdown cell (1)",
                exit = true,
            },
        },
        cO = {
            function()
                vim.cmd("call jukit#cells#create_above(0)")
            end,
            {
                desc = "Create new code cell above. Argument: Whether to create code cell (0) or markdown cell (1)",
                exit = true,
            },
        },
        ct = {
            function()
                vim.cmd("call jukit#cells#create_below(1)")
            end,
            {
                desc = "Create new textcell below. Argument: Whether to create code cell (0) or markdown cell (1)",
                exit = true,
            },
        },
        cT = {
            function()
                vim.cmd("call jukit#cells#create_above(1)")
            end,
            {
                desc = "Create new textcell above. Argument: Whether to create code cell (0) or markdown cell (1)",
                exit = true,
            },
        },
        cd = {
            function()
                vim.cmd("call jukit#cells#delete()")
            end,
            { desc = "Delete current cell", exit = true },
        },
        cs = {
            function()
                vim.cmd("call jukit#cells#split()")
            end,
            {
                desc = "Split current cell (saved output will then be assigned to the resulting cell above)",
                exit = true,
            },
        },
        cM = {
            function()
                vim.cmd("call jukit#cells#merge_above()")
            end,
            { desc = "Merge current cell with the cell above", exit = true },
        },
        cm = {
            function()
                vim.cmd("call jukit#cells#merge_below()")
            end,
            { desc = "Merge current cell with the cell below", exit = true },
        },
        ck = {
            function()
                vim.cmd("call jukit#cells#move_up()")
            end,
            { desc = "Move current cell up", exit = true },
        },
        cj = {
            function()
                vim.cmd("call jukit#cells#move_down()")
            end,
            { desc = "Move current cell down", exit = true },
        },
        J = {
            function()
                vim.cmd("call jukit#cells#jump_to_next_cell()")
            end,
            { desc = "Jump to the next cell below", exit = true },
        },
        K = {
            function()
                vim.cmd("call jukit#cells#jump_to_previous_cell()")
            end,
            { desc = "Jump to the previous cell above", exit = true },
        },
        dO = {
            function()
                vim.cmd("call jukit#cells#delete_outputs(0)")
            end,
            {
                desc = "Delete saved output of current cell. Argument: Whether to delete all saved outputs (1) or only saved output of current cell (0)",
                exit = true,
            },
        },
        da = {
            function()
                vim.cmd("call jukit#cells#delete_outputs(1)")
            end,
            {
                desc = "Delete saved outputs of all cells. Argument: Whether to delete all saved outputs (1) or only saved output of current cell (0)",
                exit = true,
            },
        },

        -- nnoremap ;<leader>np :call jukit#convert#notebook_convert("jupyter-notebook")<cr>
        -- "   - Convert from ipynb to py or vice versa. Argument: Optional. If an argument is specified, then its value is used to open the resulting ipynb file after converting script.
        -- nnoremap ;<leader>ht :call jukit#convert#save_nb_to_file(0,1,'html')<cr>
        -- "   - Convert file to html (including all saved outputs) and open it using the command specified in `g:jukit_html_viewer'. If `g:jukit_html_viewer` is not defined, then will default to `g:jukit_html_viewer='xdg-open'`. Arguments: 1.: Whether to rerun all cells when converting 2.: Whether to open it after converting 3.: filetype to convert to
        -- nnoremap ;<leader>rht :call jukit#convert#save_nb_to_file(1,1,'html')<cr>
        -- "   - same as above, but will (re-)run all cells when converting to html
        -- nnoremap ;<leader>pd :call jukit#convert#save_nb_to_file(0,1,'pdf')<cr>
        -- "   - Convert file to pdf (including all saved outputs) and open it using the command specified in `g:jukit_pdf_viewer'. If `g:jukit_pdf_viewer` is not defined, then will default to `g:jukit_pdf_viewer='xdg-open'`. Arguments: 1.: Whether to rerun all cells when converting 2.: Whether to open it after converting 3.: filetype to convert to. NOTE: If the function doesn't work there may be issues with your nbconvert or latex version - to debug, try converting to pdf using `jupyter nbconvert --to pdf --allow-errors --log-level='ERROR' --HTMLExporter.theme=dark </abs/path/to/ipynb> && xdg-open </abs/path/to/pdf>` in your terminal and check the output for possible issues.
        -- nnoremap ;<leader>rpd :call jukit#convert#save_nb_to_file(1,1,'pdf')<cr>
        -- "   - same as above, but will (re-)run all cells when converting to pdf. NOTE: If the function doesn't work there may be issues with your nbconvert or latex version - to debug, try converting to pdf using `jupyter nbconvert --to pdf --allow-errors --log-level='ERROR' --HTMLExporter.theme=dark </abs/path/to/ipynb> && xdg-open </abs/path/to/pdf>` in your terminal and check the output for possible issues.
        np = {
            function()
                vim.cmd("call jukit#convert#notebook_convert('jupyter-notebook')")
            end,
            {
                desc = "Convert from ipynb to py or vice versa. Argument: Optional. If an argument is specified, then its value is used to open the resulting ipynb file after converting script.",
                exit = true,
            },
        },
        ht = {
            function()
                vim.cmd("call jukit#convert#save_nb_to_file(0,1,'html')")
            end,
            {
                desc = "Convert file to html (including all saved outputs) and open it using the command specified in `g:jukit_html_viewer'. If `g:jukit_html_viewer` is not defined, then will default to `g:jukit_html_viewer='xdg-open'`. Arguments: 1.: Whether to rerun all cells when converting 2.: Whether to open it after converting 3.: filetype to convert to",
                exit = true,
            },
        },
        rh = {
            function()
                vim.cmd("call jukit#convert#save_nb_to_file(1,1,'html')")
            end,
            { desc = "same as above, but will (re-)run all cells when converting to html", exit = true },
        },
        pd = {
            function()
                vim.cmd("call jukit#convert#save_nb_to_file(0,1,'pdf')")
            end,
            {
                desc = "Convert file to pdf (including all saved outputs) and open it using the command specified in `g:jukit_pdf_viewer'. If `g:jukit_pdf_viewer` is not defined, then will default to `g:jukit_pdf_viewer='xdg-open'`. Arguments: 1.: Whether to rerun all cells when converting 2.: Whether to open it after converting 3.: filetype to convert to. NOTE: If the function doesn't work there may be issues with your nbconvert or latex version - to debug, try converting to pdf using `jupyter nbconvert --to pdf --allow-errors --log-level='ERROR' --HTMLExporter.theme=dark </abs/path/to/ipynb> && xdg-open </abs/path/to/pdf>` in your terminal and check the output for possible issues.",
                exit = true,
            },
        },
        rp = {
            function()
                vim.cmd("call jukit#convert#save_nb_to_file(1,1,'pdf')")
            end,
            {
                desc = "same as above, but will (re-)run all cells when converting to pdf. NOTE: If the function doesn't work there may be issues with your nbconvert or latex version - to debug, try converting to pdf using `jupyter nbconvert --to pdf --allow-errors --log-level='ERROR' --HTMLExporter.theme=dark </abs/path/to/ipynb> && xdg-open </abs/path/to/pdf>` in your terminal and check the output for possible issues.",
                exit = true,
            },
        },
    },
}

local map = {}

for k, _ in pairs(config.Repl) do
    if k ~= "color" and k ~= "body" and k ~= "mode" then
        table.insert(map, k)
    end
end
-- sort map, in the order that config.repl is
table.sort(map, function(a, b)
    return config.Repl[a][2].desc < config.Repl[b][2].desc
end)

table_slice = function(tbl, first, last)
    local sliced = {}
    for i = first or 1, last or #tbl do
        sliced[#sliced + 1] = tbl[i]
    end
    return sliced
end

return {
    config,
    "Repl",
    {
        -- { "os", "ts", "hs", "ohs", "od", "ohd", "so", "ah", "sl" },
        -- everything from the first 13 items
        table_slice(map, 1, 13),
    },
    table_slice(map, 14, #map),
    6,
    3,
    2,
}
