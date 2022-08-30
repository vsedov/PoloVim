local config = {}

function config.telescope()
    require("utils.telescope")
end
function config.bookmark()
    require("telescope").load_extension("bookmarks")
end
return config
