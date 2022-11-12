--  TODO: (vsedov) (17:12:35 - 09/11/22): Add this into harpoon module later downthe line
if lambda.config.use_lightspeed then
    local Hydra = require("hydra")
    local match = lambda.lib.match
    local when = lambda.lib.when
    local loader = require("packer").loader
    local cmd = require("hydra.keymap-util").cmd
    loader("portal.nvim")
    local hint = [[
^ ^ _n_: Jump Forward   ^ ^
^ ^ _p_: Jump Backward  ^ ^
^ ^ _k_: Toggle         ^ ^
^ ^ _l_: Popup          ^ ^
^ ^ _s_: Create Name    ^ ^
^ ^ _S_: Select Name    ^ ^
^ ^ _m_: Tag            ^ ^
^ ^ _M_: UnTag          ^ ^
^ ^ _R_: Rest           ^ ^
]]
    Hydra({
        name = "Grapple",
        hint = hint,
        config = {
            color = "pink",
            invoke_on_body = true,
            hint = {
                position = "middle-right",
                border = lambda.style.border.type_0,
            },
        },
        mode = { "n" },
        body = "<leader>l",
        heads = {
            {
                "n",
                function()
                    require("portal").jump_forward()
                end,
                { exit = true },
            },
            {
                "p",
                function()
                    require("portal").jump_backward()
                end,
                { exit = true },
            },
            {
                "k",
                function()
                    require("grapple").toggle()
                end,
                { exit = false },
            },
            {
                "m",
                function()
                    require("grapple").tag()
                end,
                { exit = true },
            },
            {
                "M",
                function()
                    require("grapple").untag()
                end,
                { exit = true },
            },
            {
                "l",
                function()
                    require("grapple").popup_tags("global")
                end,
                { exit = true },
            },

            {
                "s",
                function()
                    require("grapple").select({ key = "{name}" })
                end,
                { exit = true },
            },
            {
                "S",
                function()
                    require("grapple").toggle({ key = "{name}" })
                end,
                { exit = true },
            },
            {
                "R",
                function()
                    require("grapple").reset()
                end,
                { exit = true },
            },
            { "<Esc>", nil, { exit = true, desc = false } },
        },
    })
end
