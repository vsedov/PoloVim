local function install_plugins()
    local files_path = vim.fn.stdpath("config") .. "/plugin_names.txt" 
    local file = io.open(files_path,"r") 
    if not file then 
        return
    end

    for line in file:lines() do 
        if line ~= "" then 
            local command = "Rocks install " .. line
            vim.cmd(command)
        end
    end
    file:close()

end
install_plugins()
