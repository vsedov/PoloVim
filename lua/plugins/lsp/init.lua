local config = lambda.config.lsp.null_ls

require("lspconfig.ui.windows").default_options.border = lambda.style.border.type_0
require("lspconfig")
local keys = {
    {
        "<leader>ip",
        function()
            return vim.bo.filetype == "AvanteInput" and require("avante.clipboard").paste_image()
                or require("img-clip").paste_image()
        end,
        desc = "clip: paste image",
    },
    {
        "<leader>as",
        function()
            local function AvanteSwitchProvider()
                local providers = { "Claude", "OpenAI", "Azure", "Gemini", "Cohere", "Copilot", "Perplexity" }
                vim.ui.select(providers, {
                    prompt = "Select Avante Provider:",
                    format_item = function(item)
                        return item
                    end,
                }, function(choice)
                    if choice then
                        vim.cmd("AvanteSwitchProvider " .. choice)
                        vim.notify("Avante provider switched to " .. choice, vim.log.levels.INFO)
                    end
                end)
            end
            AvanteSwitchProvider()
        end,
        desc = "Switch Avante Provider",
    },
}
for _, key in ipairs(keys) do
    vim.keymap.set("n", key[1], key[2], { desc = key[3], noremap = true })
end
rocks.safe_force_packadd({ "nvim-web-devicons", "plenary.nvim", "render-markdown.nvim" })

local opts = {
    provider = "claude", -- Recommend using Claude
    auto_suggestions_provider = "claude", -- Since auto-suggestions are a high-frequency operation and therefore expensive, it is recommended to specify an inexpensive provider or even a free provider: copilot
    claude = {
        endpoint = "https://api.anthropic.com",
        model = "claude-3-5-sonnet-20240620",
        temperature = 0,
        -- max_tokens = 10096,
    },
    dual_boost = {
        enabled = false,
        first_provider = "openai",
        second_provider = "claude",
        prompt = "Based on the two reference outputs below, generate a response that incorporates elements from both but reflects your own judgment and unique perspective. Do not provide any explanation, just give the response directly. Reference Output 1: [{{provider1_output}}], Reference Output 2: [{{provider2_output}}]",
        timeout = 60000, -- Timeout in milliseconds
    },
    behaviour = {
        auto_suggestions = false, -- Experimental stage
        auto_set_highlight_group = true,
        auto_set_keymaps = true,
        auto_apply_diff_after_generation = true,
        support_paste_from_clipboard = true,
    },
    mappings = {
        diff = {
            ours = "co",
            theirs = "ct",
            all_theirs = "ca",
            both = "cb",
            cursor = "cc",
            next = "]x",
            prev = "[x",
        },
        suggestion = {
            accept = "<c-l>",
            next = "<c-]>",
            prev = "<c-[>",
            dismiss = "<C-e>",
        },
        jump = {
            next = "]]",
            prev = "[[",
        },
        submit = {
            normal = "<CR>",
            insert = "<C-s>",
        },
    },
}
local opt2 = {
    file_types = { "markdown", "Avante" },
}
require("render-markdown").setup(opt2)
require("avante_lib").load()
require("avante").setup(opt)
