# Structure 

```

return {
	# NEW HYDRA, CONFIG For HYDRA GOES HERE
    {
        name = "SAD",
        config = {
            hint = {
                position = "middle-right",
                border = lambda.style.border.type_0,
            },
            timeout = false,
            invoke_on_body = true,
        },
        heads = {},
    },
    # BINDS : 
    {
        color = "pink",
        body = "L",
        mode = { "n", "v", "x", "o" },
        L = {
            function()
                require("substitute").operator()
            end,
            { nowait = true, desc = "Operator Sub", exit = true },
        },

        l = {
            function()
                require("substitute").line()
            end,
            { nowait = true, desc = "Operator line", exit = true },
        },
        ----------------------------------------------------------

        o = {
            function()
                require("substitute").eol()
            end,
            { nowait = true, desc = "Operator eol", exit = true },
        },
        ----------------------------------------------------------

        K = {
            function()
                require("substitute.range").operator({ motion1 = "iW" })
            end,
            { nowait = true, desc = "range Sub", exit = true },
        },

        k = {
            function()
                require("substitute.range").word()
            end,
            { nowait = true, desc = "range word", exit = true },
        },

        a = {
            function()
                require("substitute.range").operator({ motion1 = "iw", motion2 = "ap" })
            end,
            { nowait = true, desc = "range word", exit = true },
        },

        ----------------------------------------------------------
        Q = {
            function()
                require("substitute.exchange").operator()
            end,
            { nowait = true, desc = "Exchange Sub", exit = true },
        },

        q = {
            function()
                require("substitute.exchange").word()
            end,
            { nowait = true, desc = "Exchange Sub", exit = true },
        },

        C = {
            function()
                require("substitute.exchange").cancel()
            end,
            { desc = "Exchange Sub", nowait = true, exit = true },
        },

        ----------------------------------------------------------
        s = {
            function()
                require("ssr").open()
            end,

            { nowait = true, desc = "SSR Rep", exit = true },
        },
        S = {
            function()
                vim.cmd([[Sad]])
            end,

            { nowait = true, desc = "Sad SSR", exit = true },
        },

        -----------------------------------------------------------
        Xo = {
            function()
                require("spectre").open()
            end,

            { nowait = true, desc = "Spectre Open", exit = true },
        },
        Xv = {
            function()
                require("spectre").open_visual({ select_word = true })
            end,

            { nowait = true, desc = "Specre Word", exit = true },
        },
        Xc = {
            function()
                require("spectre").open_visual()
            end,

            { nowait = true, desc = "Spectre V", exit = true },
        },
        Xf = {
            function()
                require("spectre").open_file_search()
            end,
            { nowait = true, desc = "Spectre FS", exit = true },
        },

        -----------------------------
        w = {
            mx("<leader><leader>Sc"),
            { nowait = true, desc = "Rep All", exit = true },
        },

        E = {
            mx("<leader><leader>Sr"),
            { nowait = true, desc = "Rep Word", exit = false },
        },

        W = {
            mx("<leader><leader>Sl"),
            { nowait = true, desc = "Rep Word[C]", exit = true },
        },
    },

    # WHAT BINDS DO YOU WANT ON TOP / IGNORE LIST
    { "s", "W", "w", "S", "E" },
    
    # ORDER OF WHICH YOU WANT YOUR BINDS TO BE SHOWN
    {
        { 1, { "k", "K", "a" } },
        { 1, { "L", "l", "o" } },
        { 1, { "Q", "q", "C" } },
        { 2, nil },
    },
}
```