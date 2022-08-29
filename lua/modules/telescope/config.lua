local config = {}

function config.telescope()
    require("utils.telescope")
end
function config.bookmark()
    require("telescope").setup({
        extensions = {
            bookmarks = {
                -- Available: 'brave', 'buku', 'chrome', 'chrome_beta', 'edge', 'safari', 'firefox', 'vivaldi'
                selected_browser = "waterfox",

                -- Either provide a shell command to open the URL
                url_open_command = "open",

                -- Or provide the plugin name which is already installed
                -- Available: 'vim_external', 'open_browser'
                url_open_plugin = nil,

                -- Show the full path to the bookmark instead of just the bookmark name
                full_path = true,

                -- Provide a custom profile name for Firefox
                waterfox_profile_name = "default-default",

                -- Add a column which contains the tags for each bookmark for buku
                buku_include_tags = false,

                -- Provide debug messages
                debug = false,
            },
        },
    })
end
return config
