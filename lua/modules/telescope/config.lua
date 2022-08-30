local config = {}

function config.telescope()
    require("utils.telescope").setup()
end
function config.bookmark()
    require("telescope").load_extension("bookmarks")
end
return config
