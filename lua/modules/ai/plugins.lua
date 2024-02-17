local ai = require("core.pack").package

local conf = require("modules.ai.config")

local ai_conf = lambda.config.ai
local IS_DEV = false
--- Get all the changes in the git repository
---@param staged? boolean
---@return string
local function get_git_diff(staged)
    local cmd = staged and "git diff --staged" or "git diff"
    local handle = io.popen(cmd)
    if not handle then
        return ""
    end

    local result = handle:read("*a")
    handle:close()
    return result
end

local prompts = {
    -- Code related prompts
    Explain = "Please explain how the following code works.",
    Review = "Please review the following code and provide suggestions for improvement.",
    Tests = "Please explain how the selected code works, then generate unit tests for it.",
    Refactor = "Please refactor the following code to improve its clarity and readability.",
    FixCode = "Please fix the following code to make it work as intended.",
    BetterNamings = "Please provide better names for the following variables and functions.",
    Documentation = "Please provide documentation for the following code.",
    SwaggerApiDocs = "Please provide documentation for the following API using Swagger.",
    SwaggerJsDocs = "Please write JSDoc for the following API using Swagger.",
    -- Text related prompts
    Summarize = "Please summarize the following text.",
    Spelling = "Please correct any grammar and spelling errors in the following text.",
    Wording = "Please improve the grammar and wording of the following text.",
    Concise = "Please rewrite the following text to make it more concise.",
}

ai({
    "jackMort/ChatGPT.nvim",
    lazy = true,
    cmd = { "ChatGPT", "ChatGPTRun", "ChatGPTActAs", "ChatGPTCompleteCode", "ChatGPTEditWithInstructions" },
    dependencies = {
        "MunifTanjim/nui.nvim",
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
    },
    config = conf.chatgpt,
})

ai({
    "mikesoylu/ai.vim",
    cmd = { "AI" },
    init = function()
        vim.g.ai_completions_model = "gpt-4"
        vim.g.ai_no_mappings = 1 -- disbale default mappings
    end,
})

ai({
    "james1236/backseat.nvim",
    lazy = true,
    cmd = { "Backseat", "BackseatAsk", "BackseatClear", "BackseatClearLine" },
    config = conf.backseat,
})

ai({
    "tzachar/cmp-tabnine",
    lazy = true,
    cond = (ai_conf.tabnine.use_tabnine and ai_conf.tabnine.use_tabnine_cmp),
    event = "VeryLazy",
    build = "bash ./install.sh",
    dependencies = {
        "hrsh7th/nvim-cmp",
    },
    config = conf.tabnine_cmp,
})

ai({
    "codota/tabnine-nvim",
    lazy = true,
    cond = (ai_conf.tabnine.use_tabnine and ai_conf.tabnine.use_tabnine_insert),
    event = "VeryLazy",
    build = "bash ./dl_binaries.sh",
    config = conf.tabnine,
})
-- another module

ai({
    "Exafunction/codeium.vim",
    lazy = true,
    cond = (ai_conf.codeium.use_codeium and ai_conf.codeium.use_codium_insert),
    event = "VeryLazy",
    init = function()
        vim.g.codeium_disable_bindings = 1
        vim.g.codeium_enabled = lambda.config.ai.use_codium_insert
    end,
    config = conf.codium,
})

ai({
    "jcdickinson/codeium.nvim",
    cond = (ai_conf.codeium.use_codeium and ai_conf.codeium.use_codeium_cmp),
    lazy = true,
    event = "VeryLazy",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
    },
    config = true,
})

-- <C-c> to close chat window.
-- <C-u> scroll up chat window.
-- <C-d> scroll down chat window.
-- <C-y> to copy/yank last answer.
-- <C-o> Toggle settings window.
-- <C-n> Start new session.
-- <Tab> Cycle over windows.tr
-- <C-i> [Edit Window] use response as input.

-- ai({
--     "zbirenbaum/copilot.lua",
--     -- init = conf.sell_your_soul,
--     cond = ai_conf.sell_your_soul,
--     event = "InsertEnter",
--     dependencies = { "nvim-cmp" },
--     opts = {
--         panel = {
--             enabled = true,
--             auto_refresh = true,
--             keymap = { open = "<M-CR>" },
--             layout = { position = "right", ratio = 0.4 },
--         },
--         suggestion = {
--             auto_trigger = lambda.config.ai.copilot.autotrigger,
--             -- keymap = { accept = "<c-l>", accept_word = "<c-l>", accept_line = "<c-l>" },
--             keymap = {
--                 accept_word = false,
--                 accept_line = false,
--                 next = "<M-]>",
--                 prev = "<M-[>",
--                 dismiss = "<C-]>",
--             },
--         },
--
--         filetypes = {
--             gitcommit = false,
--             NeogitCommitMessage = false,
--             DressingInput = false,
--             TelescopePrompt = false,
--             ["neo-tree-popup"] = false,
--             ["dap-repl"] = false,
--         },
--     },
-- })
--  TODO: (vsedov) (14:41:51 - 12/02/24): Create a hydra for this
--  Something like <leader>A -> C All binds ?
--  or perhaps <leader>cc Hydra could also work
ai({
    "CopilotC-Nvim/CopilotChat.nvim",
    build = function()
        vim.notify("Please update the remote plugins by running ':UpdateRemotePlugins', then restart Neovim.")
    end,
    event = "VeryLazy",
                opts = {
                    show_help = "yes",
                    prompts = prompts,
                    debug = false, -- Set to true to see response from Github Copilot API. The log file will be in ~/.local/state/nvim/CopilotChat.nvim.log.
                    disable_extra_info = "no", -- Disable extra information (e.g: system prompt, token count) in the response.
                },
                keys = {
                    -- Code related commands
                    { "<leader>cce", "<cmd>CopilotChatExplain<cr>", desc = "CopilotChat - Explain code" },
                    { "<leader>cct", "<cmd>CopilotChatTests<cr>", desc = "CopilotChat - Generate tests" },
                    { "<leader>ccr", "<cmd>CopilotChatReview<cr>", desc = "CopilotChat - Review code" },
                    { "<leader>ccR", "<cmd>CopilotChatRefactor<cr>", desc = "CopilotChat - Refactor code" },
                    { "<leader>ccf", "<cmd>CopilotChatFixCode<cr>", desc = "CopilotChat - Fix code" },
                    { "<leader>ccb", "<cmd>CopilotChatBetterNamings<cr>", desc = "CopilotChat - Better Name" },
        { "<leader>ccd", "<cmd>CopilotChatDocumentation<cr>", desc = "CopilotChat - Add documentation for code" },
        { "<leader>cca", "<cmd>CopilotChatSwaggerApiDocs<cr>", desc = "CopilotChat - Add Swagger API documentation" },
                    {
                        "<leader>ccA",
                        "<cmd>CopilotChatSwaggerJsDocs<cr>",
                        desc = "CopilotChat - Add Swagger API with Js Documentation",
                    },
                    -- Text related commands
                    { "<leader>ccs", "<cmd>CopilotChatSummarize<cr>", desc = "CopilotChat - Summarize text" },
                    { "<leader>ccS", "<cmd>CopilotChatSpelling<cr>", desc = "CopilotChat - Correct spelling" },
                    { "<leader>ccw", "<cmd>CopilotChatWording<cr>", desc = "CopilotChat - Improve wording" },
                    { "<leader>ccc", "<cmd>CopilotChatConcise<cr>", desc = "CopilotChat - Make text concise" },
                    -- Chat with Copilot in visual mode
                    {
                        "<leader>ccv",
                        ":CopilotChatVisual",
                        mode = "x",
                        desc = "CopilotChat - Open in vertical split",
                    },
                    {
                        "<leader>ccx",
                        ":CopilotChatInPlace<cr>",
                        mode = "x",
                        desc = "CopilotChat - Run in-place code",
                    },
                    -- Custom input for CopilotChat
                    {
                        "<leader>cci",
                        function()
                            local input = vim.fn.input("Ask Copilot: ")
                            if input ~= "" then
                                vim.cmd("CopilotChat " .. input)
                            end
                        end,
                        desc = "CopilotChat - Ask input",
                    },
                    -- Generate commit message base on the git diff
                    {
                        "<leader>ccm",
                        function()
                            local diff = get_git_diff()
                            if diff ~= "" then
                                vim.fn.setreg('"', diff)
                                vim.cmd("CopilotChat Write commit message for the change with commitizen convention.")
                            end
                        end,
                        desc = "CopilotChat - Generate commit message for all changes",
                    },
                    {
                        "<leader>ccM",
                        function()
                            local diff = get_git_diff(true)
                            if diff ~= "" then
                                vim.fn.setreg('"', diff)
                                vim.cmd("CopilotChat Write commit message for the change with commitizen convention.")
                            end
                        end,
                        desc = "CopilotChat - Generate commit message for staged changes",
                    },
                    -- Debug
                    { "<leader>ccD", "<cmd>CopilotChatDebugInfo<cr>", desc = "CopilotChat - Debug Info" },
                },
})
ai({
    "sourcegraph/sg.nvim",
    cond = lambda.config.lsp.use_sg,
    event = "VeryLazy",
    build = "nvim -l build/init.lua",
    dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim" },
    cmd = {
        "SourcegraphBuild",
        "SourcegraphDownloadBinaries",
        "SourcegraphInfo",
        "SourcegraphLink",
        "SourcegraphLogin",
        "SourcegraphSearch",
        "CodyDo",
        "CodyChat",
        "CodyToggle",
        "CodyTaskNext",
        "CodyTaskView",
        "CodyAsk",
        "CodyTask",
        "CodyRestart",
        "CodyTaskPrev",
        "CodyTaskAccept",
    },
    config = function()
        -- nnoremap <space>ss <cmd>lua require('sg.extensions.telescope').fuzzy_search_results()<CR>
        vim.keymap.set(
            "n",
            "<leader>ss",
            "<cmd>lua require('sg.extensions.telescope').fuzzy_search_results()<cr>",
            { desc = "Cody Fuzzy results" }
        )

        -- Toggle cody chat
        vim.keymap.set("n", "<leader>sc", function()
            require("sg.cody.commands").toggle()
        end, { desc = "Cody Commands" })

        vim.keymap.set("n", "<leader>sn", function()
            local name = vim.fn.input("chat name: ")
            require("sg.cody.commands").chat(name)
        end, { desc = "Cody Commands" })

        --  TODO: (vsedov) (23:39:52 - 15/02/24): Create a hydra for this

        -- vim.keymap.set({ "v", "n" }, ";cd", "<cmd>CodyTask<CR>", { noremap = true, silent = true })
        -- vim.keymap.set("n", ";cc", "<cmd>CodyChat<CR>", { noremap = true, silent = true })
        -- vim.keymap.set("n", ";ct", "<cmd>CodyToggle<CR>", { noremap = true, silent = true })
        --
        -- vim.keymap.set("n", ";cn", "<cmd>CodyTaskNext<CR>", { noremap = true, silent = true })
        -- vim.keymap.set("n", ";cv", "<cmd>CodyTaskView<CR>", { noremap = true, silent = true })
        --
        -- vim.keymap.set("n", ";ca", "<cmd>CodyAsk<CR>", { noremap = true, silent = true })
        -- vim.keymap.set("n", ";cr", "<cmd>CodyRestart<CR>", { noremap = true, silent = true })
        -- vim.keymap.set("n", ";cp", "<cmd>CodyTaskPrev<CR>", { noremap = true, silent = true })
        -- vim.keymap.set("n", ";cy", "<cmd>CodyTaskAccept<CR>", { noremap = true, silent = true })
    end,
    keys = {

        {
            ";ai",
            ":CodyChat<CR>",
            mode = "n",
            desc = "AI Assistant",
        },

        {
            ";ad",
            function()
                local line = vim.fn.getline(".")
                local start = vim.fn.col(".")
                local finish = vim.fn.col("$")
                local text = line:sub(start, finish)
                vim.fn.setreg('"', text)
                vim.cmd([[CodyTask 'Write document for current context']])
            end,
            mode = "n",
            desc = "Generate Document with AI",
        },

        {
            ";ac",
            ':CodyTask ""<Left>',
            mode = "n",
            desc = "Let AI Write Code",
        },

        {
            ";aa",
            ":CodyTaskAccept<CR>",
            mode = "n",
            desc = "Confirm AI work",
        },

        {
            ";as",
            "<cmd> lua require('sg.extensions.telescope').fuzzy_search_results()<CR>",
            mode = "n",
            desc = "AI Search",
        },

        {
            ";ai",
            "y:CodyChat<CR><ESC>pG$a<CR>",
            mode = {"v","V"},
            desc = "Chat Selected Code",
        },

        {
          ";ad",
          ":CodyTask 'Write document for current context<CR>'",
          mode = {"v","V"},
          desc = "Generate Document with AI",
        },

        {
            ";ar",
            -- "y:CodyChat<CR>refactor following code:<CR><ESC>p<CR>",
            ":CodyAsk refactor following code<CR>",
            mode = {"v","V"},
            desc = "Request Refactoring",
        },

        {
            ";ae",
            -- "y:CodyChat<CR>explain following code:<CR><ESC>p<CR>",
            ":CodyAsk explain following code<CR>",

            mode = {"v","V"},
            desc = "Request Explanation",
        },

        {
            ";af",
            ":CodyAsk find potential vulnerabilities from following code<CR>",
            mode = {"v","V"},
            desc = "Request Potential Vulnerabilities",
        },

        {
            ";at",
            ":CodyAsk rewrite following code more idiomatically<CR>",
            mode = {"v","V"},
            desc = "Request Idiomatic Rewrite",
        },
    },
})

ai({
    "github/copilot.vim",
    lazy = true,
    cond = ai_conf.sell_your_soul,
    event = "InsertEnter",
    init = function()
        --[[ vim.opt.completeopt = "menuone,noselect" ]]
        vim.g.copilot_enabled = lambda.config.sell_your_soul
        -- Have copilot play nice with nvim-cmp.
        vim.g.copilot_no_tab_map = true
        vim.g.copilot_assume_mapped = true
        vim.g.copilot_tab_fallback = ""
        local excluded_filetypes = { "norg", "nofile", "prompt" }
        local copilot_filetypes = {}
        for _, ft in pairs(excluded_filetypes) do
            copilot_filetypes[ft] = false
        end
        vim.g["copilot_filetypes"] = copilot_filetypes
    end,
})

--  TODO: (vsedov) (16:03:47 - 10/12/23): Make this intoa hydra implementation
ai({
    "David-Kunz/gen.nvim",
    cmd = "Gen",
    opts = {
        model = "deepseek-coder",
        display_mode = "split", -- The display mode. Can be "float" or "split".
        show_prompt = true, -- Shows the Prompt submitted to Ollama.
        show_model = true, -- Displays which model you are using at the beginning of your chat session.
        no_auto_close = true, -- Never closes the window automatically.
        init = function(options)
            pcall(io.popen, "ollama serve > /dev/null 2>&1 &")
        end,
        -- Function to initialize Ollama
        command = "curl --silent --no-buffer -X POST http://localhost:11434/api/generate -d $body",
    },
    config = conf.gen,
})
