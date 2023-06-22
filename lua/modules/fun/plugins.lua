local fun = require("core.pack").package

-- PetsNew {name}: creates a pet with the style and type defined by the configuration, and name {name}
-- PetsNewCustom {type} {style} {name}: creates a new pet with type, style and name specified in the command
-- PetsList: prints the names of all the pets that are currently alive
-- PetsKill {name}: kills the pet with given name, which will immediately blink out of existence. Forever.
-- PetsKillAll: kills all the pets, poor creatures. Works just as PetsKill but for every pet.
-- PetsPauseToggle: pause/resume animations for all pets, leaving them on screen as cute little statues
-- PetsHideToggle: pause the animation for all pets and hide them / show all the pets again and resume animations
-- PetsIdleToggle/PetsSleepToggle: basically a do-not-disturb mode, pets are still animated but do not move around
fun({
    "giusgad/pets.nvim",
    lazy = true,
    cmd = {
        "PetsNew",
        "PetsNewCustom",
        "PetsList",
        "PetsKill",
        "PetsKillAll",
        "PetsPauseToggle",
        "PetsHideToggle",
        "PetsIdleToggle",
        "PetsSleepToggle",
    },
    dependencies = { "MunifTanjim/nui.nvim", "giusgad/hologram.nvim" },
    config = true,
})

fun({
    "samuzora/pet.nvim",
    lazy = true,
    cond = lambda.config.fun.use_pet,
    config = function()
        require("pet-nvim")
    end,
})

fun({
    "tamton-aquib/duck.nvim",
    cmd = {
        "DuckUse",
        "DuckStop",
    },
    config = function()
        require("duck").setup({
            height = 5,
            width = 5,
        })
        lambda.command("DuckUse", function()
            require("duck").hatch("🐼")
        end, {})
        lambda.command("DuckStop", function()
            require("duck").cook()
        end, {})
    end,
})

-- True emotional Support
fun({ "rtakasuke/vim-neko", cmd = "Neko", lazy = true })

fun({
    "tjdevries/sPoNGe-BoB.NvIm",
    cmd = "SpOnGeBoBtOgGlE",
})
