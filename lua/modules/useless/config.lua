local config = {}
function config.duck_type()
    require("duckytype").setup({})
    vim.api.nvim_create_user_command("DuckType", function()
        local valid_types = {
            default = "english_common",
            lua = "lua_keywords",
            python = "python_keywords",
            rust = "rust_keywords",
            go = "go_keywords",
            cpp = "cpp_keywords",
            c = "cpp_keywords",
        }
        require("duckytype").Start(valid_types[vim.fn.input("Enter a Type >> ")] or "default")
    end, {
        force = true,
    })
end

function config.launch_duck()
    require("duck").setup({
        winblend = 100, -- 0 to 100
        speed = 1, -- optimal: 1 to 99
        width = 10,
    })
    add_cmd("DuckStart", function()
        require("duck").hatch("🐼")
    end, { force = true })
    add_cmd("DuckKill", function()
        require("duck").cook("🐼")
    end, { force = true })
end

return config
