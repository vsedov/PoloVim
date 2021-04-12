local M = {}

function M.is_buffer_empty()
  -- Check whether the current buffer is empty
  return vim.fn.empty(vim.fn.expand('%:t')) == 1
end

function M.has_width_gt(cols)
  -- Check if the windows width is greater than a given number of columns
  return vim.fn.winwidth(0) / 2 > cols
end

return M


-- lua <<EOF
--   require("presence"):setup({
--     -- This config table shows all available config options with their default values
--     auto_update       = true,                       -- Update activity based on autocmd events (if `false`, map or manually execute `:lua Presence:update()`)
--     editing_text      = "Editing %s",               -- Editing format string (either string or function(filename, path): string)
--     workspace_text    = "Working on %s",            -- Workspace format string (either string or function(project_name, path): string)
--     neovim_image_text = "The One True Text Editor", -- Text displayed when hovered over the Neovim image
--     main_image        = "file",                   -- Main image display (either "neovim" or "file")
--     client_id         = "793271441293967371",       -- Use your own Discord application client id (not recommended)
--     log_level         = nil,                        -- Log messages at or above this level (one of the following: "debug", "info", "warn", "error")
-- })
-- EOF

