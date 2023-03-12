-- local conditions = require("heirline.conditions")
local wpm = require("wpm")
local utils = require("heirline.utils")
local conditions = require("heirline.conditions")

local uv = vim.loop
local cava_text = "OK"

local wpm_clicked = false
local handle_pid = nil

vim.api.nvim_create_augroup("Heirline", { clear = true })
local complete_pkill = function()
    if handle_pid then
        os.execute("pkill -P " .. handle_pid)
    end
end

local cava_config = lambda.config.ui.heirline.cava
local active = false

local function cava_run()
    local cava_path = vim.fn.expand("$HOME/.config/polybar/scripts/cava.py")
    -- local cava_path = "/user/bin/cat"
    local stdin = uv.new_pipe(false)
    local stdout = uv.new_pipe(false)
    local stderr = uv.new_pipe(false)

    local handle = uv.spawn(cava_path, {
        args = { "-f", cava_config.fps, "-b", cava_config.bars, "-c", cava_config.audio },
        -- args = { "/tmp/nvim_pipe" },
        stdio = { stdin, stdout, stderr },
    }, function()
        _G._cava_stop()
    end)

    handle_pid = tostring(handle:get_pid())

    uv.read_start(
        stdout,
        vim.schedule_wrap(function(err, data)
            if data then
                cava_text = data:gsub("[\n\r]", " ")
            end
        end)
    )
    _G._cava_stop = function()
        vim.defer_fn(function()
            uv.close(handle, function()
                uv.close(stdin)
                uv.close(stdout)
                uv.close(stderr)
            end)
            vim.schedule_wrap(function()
                complete_pkill()
                handle_pid = nil
            end)

            vim.notify(" . " .. tostring(handle:is_active()) .. " PID : " .. tostring(handle:get_pid()))
        end, 0)
    end
end

vim.api.nvim_create_autocmd({ "ExitPre" }, {
    callback = function()
        if cava_config.use_cava and active then
            complete_pkill()
            if _G._cava_stop then
                _G._cava_stop()
            end
        end
    end,
    group = "Heirline",
    once = true,
})

--- Blend two rgb colors using alpha
---@param color1 string | number first color = false = false
---@param color2 string | number second color
---@param alpha number (0, 1) float determining the weighted average
---@return string color hex string of the blended color
local function blend(color1, color2, alpha)
    color1 = type(color1) == "number" and string.format("#%06x", color1) or color1
    color2 = type(color2) == "number" and string.format("#%06x", color2) or color2
    local r1, g1, b1 = color1:match("#(%x%x)(%x%x)(%x%x)")
    local r2, g2, b2 = color2:match("#(%x%x)(%x%x)(%x%x)")
    local r = tonumber(r1, 16) * alpha + tonumber(r2, 16) * (1 - alpha)
    local g = tonumber(g1, 16) * alpha + tonumber(g2, 16) * (1 - alpha)
    local b = tonumber(b1, 16) * alpha + tonumber(b2, 16) * (1 - alpha)
    return "#"
        .. string.format("%02x", math.min(255, math.max(r, 0)))
        .. string.format("%02x", math.min(255, math.max(g, 0)))
        .. string.format("%02x", math.min(255, math.max(b, 0)))
end

local function dim(color, n)
    return blend(color, "#000000", n)
end

local function run_file(ht)
    local fts = {
        rust = "cargo run",
        python = "python %",
        javascript = "npm start",
        c = "make",
        cpp = "make",
        java = "java %",
    }

    local cmd = fts[vim.bo.ft]
    vim.cmd(cmd and ("w | " .. (ht or "") .. "sp | term " .. cmd) or "echo 'No command for this filetype'")
end

function Bruh(id)
    ({ run_file, require("mpv").toggle_player })[id]()
end

local function setup_colors()
    return {
        bright_bg = utils.get_highlight("Folded").bg or utils.get_highlight("Folded").fg,
        bright_fg = utils.get_highlight("Folded").fg,
        red = utils.get_highlight("DiagnosticError").fg,
        dark_red = utils.get_highlight("DiffDelete").bg,
        green = utils.get_highlight("String").fg,
        blue = utils.get_highlight("Function").fg,
        gray = utils.get_highlight("NonText").fg,
        orange = utils.get_highlight("Constant").fg,
        purple = utils.get_highlight("Statement").fg,
        cyan = utils.get_highlight("Special").fg,
        diag_warn = utils.get_highlight("DiagnosticWarn").fg,
        diag_error = utils.get_highlight("DiagnosticError").fg,
        diag_hint = utils.get_highlight("DiagnosticHint").fg,
        diag_info = utils.get_highlight("DiagnosticInfo").fg,
        -- git_del = utils.get_highlight("diffDeleted").fg,
        -- git_add = utils.get_highlight("diffAdded").fg,
        -- git_change = utils.get_highlight("diffChanged").fg,
    }
end

require("heirline").load_colors(setup_colors())

local cava = {
    condition = function()
        return true
    end,
    on_click = {
        name = "Cava",

        callback = function()
            if cava_config.use_cava then
                if not active then
                    cava_run()
                    active = true
                    vim.notify("Activating Cava")
                else
                    _G._cava_stop() -- stop Cava
                    active = false
                    vim.notify("Disabling Cava")
                    cava_text = " Cava |"
                end
            end
        end,
    },
    provider = function(self)
        if active and cava_config.use_cava then
            -- if tostring(vim.fn.mode()) == "n" then
            if vim.tbl_contains({ "n", "v" }, vim.fn.mode()) then
                new_container = {}
                for _, char in require("utf8").codes(cava_text) do
                    table.insert(new_container, char)
                end
                return table.concat(new_container)
                -- return cava_text
            end
        end
        return "Cava"
    end,
    hl = function(self)
        local color = self:mode_color()
        return { fg = color }
    end,
}

local mpv = {
    condition = function()
        return true
    end,
    on_click = {
        name = "mpv_commands",
        callback = function()
            vim.defer_fn(function()
                vim.notify("Mpv Toggle")
                vim.cmd([[MpvToggle]])
            end, 100)
        end,
    },
    provider = function()
        if vim.g.mpv_visualizer then
            return vim.g.mpv_visualizer .. " | "
        end
        return "MPV"
    end,
    hl = function(self)
        local color = self:mode_color()
        return { fg = color }
    end,
}

local wpm_input = {
    condition = function()
        return true
    end,
    on_click = {
        name = "Wpm",
        callback = function()
            wpm_clicked = not wpm_clicked
        end,
    },
    provider = function(self)
        data = require("wpm").wpm()
        if wpm_clicked then
            data = data .. " | " .. require("wpm").historic_graph()
        end
        return data
    end,
    hl = { fg = "blue" },
}
local possession = {
    condition = function()
        return require("nvim-possession").status() ~= nil or false
    end,
    provider = function(self)
        return require("nvim-possession").status()
    end,
    hl = { fg = "red" },
}
local ViMode = {
    init = function(self)
        self.mode = vim.fn.mode(1)
        if not self.once then
            vim.cmd("au ModeChanged *:*o redrawstatus")
        end
        self.once = true
    end,
    static = {
        mode_names = {
            n = "N",
            no = "N?",
            nov = "N?",
            noV = "N?",
            ["no\22"] = "N?",
            niI = "Ni",
            niR = "Nr",
            niV = "Nv",
            nt = "Nt",
            v = "V",
            vs = "Vs",
            V = "V_",
            Vs = "Vs",
            ["\22"] = "^V",
            ["\22s"] = "^V",
            s = "S",
            S = "S_",
            ["\19"] = "^S",
            i = "I",
            ic = "Ic",
            ix = "Ix",
            R = "R",
            Rc = "Rc",
            Rx = "Rx",
            Rv = "Rv",
            Rvc = "Rv",
            Rvx = "Rv",
            c = "C",
            cv = "Ex",
            r = "...",
            rm = "M",
            ["r?"] = "?",
            ["!"] = "!",
            t = "T",
        },
    },
    provider = function(self)
        return " %2(" .. self.mode_names[self.mode] .. "%)"
    end,
    hl = function(self)
        local color = self:mode_color()
        return { fg = color, bold = true }
    end,

    update = {
        "ModeChanged",
    },
}

local FileNameBlock = {
    init = function(self)
        self.filename = vim.api.nvim_buf_get_name(0)
    end,
}

local FileIcon = {
    init = function(self)
        local filename = self.filename
        local extension = vim.fn.fnamemodify(filename, ":e")
        self.icon, self.icon_color =
            require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
    end,
    provider = function(self)
        return self.icon and (self.icon .. " ")
    end,
    hl = function(self)
        return { fg = self.icon_color }
    end,
}

local FileName = {
    init = function(self)
        self.lfilename = vim.fn.fnamemodify(self.filename, ":.")
        if self.lfilename == "" then
            self.lfilename = "[No Name]"
        end
        if not conditions.width_percent_below(#self.lfilename, 0.27) then
            self.lfilename = vim.fn.pathshorten(self.lfilename)
        end
    end,
    hl = "Directory",
    flexible = 2,
    {
        provider = function(self)
            return self.lfilename
        end,
    },
    {
        provider = function(self)
            return vim.fn.pathshorten(self.lfilename)
        end,
    },
}

local FileFlags = {
    {
        condition = function()
            return vim.bo.modified
        end,
        provider = "[+]",
        hl = { fg = "green" },
    },
    {
        condition = function()
            return not vim.bo.modifiable or vim.bo.readonly
        end,
        provider = "",
        hl = { fg = "orange" },
    },
}

local FileNameModifer = {
    hl = function()
        if vim.bo.modified then
            return { fg = "cyan", bold = true, force = true }
        end
    end,
}

FileNameBlock = utils.insert(FileNameBlock, FileIcon, utils.insert(FileNameModifer, FileName), unpack(FileFlags))

local FileType = {
    provider = function()
        return string.upper(vim.bo.filetype)
    end,
    hl = "Type",
}

local FileEncoding = {
    provider = function()
        local enc = (vim.bo.fenc ~= "" and vim.bo.fenc) or vim.o.enc -- :h 'enc'
        return enc ~= "utf-8" and enc:upper()
    end,
}

local FileFormat = {
    provider = function()
        local fmt = vim.bo.fileformat
        return fmt ~= "unix" and fmt:upper()
    end,
}

local FileSize = {
    provider = function()
        -- stackoverflow, compute human readable file size
        local suffix = { "b", "k", "M", "G", "T", "P", "E" }
        local fsize = vim.fn.getfsize(vim.api.nvim_buf_get_name(0))
        fsize = (fsize < 0 and 0) or fsize
        if fsize <= 0 then
            return "0" .. suffix[1]
        end
        local i = math.floor((math.log(fsize) / math.log(1024)))
        return string.format("%.2g%s", fsize / math.pow(1024, i), suffix[i])
    end,
}

local FileLastModified = {
    provider = function()
        local ftime = vim.fn.getftime(vim.api.nvim_buf_get_name(0))
        return (ftime > 0) and os.date("%c", ftime)
    end,
}

local Ruler = {
    -- %l = current line number
    -- %L = number of lines in the buffer
    -- %c = column number
    -- %P = percentage through file of displayed window
    provider = "%7(%l/%3L%):%2c %P",
}

local ScrollBar = {
    static = {
        -- sbar = { "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█" },
        sbar = { "🭶", "🭷", "🭸", "🭹", "🭺", "🭻" },
    },
    provider = function(self)
        local curr_line = vim.api.nvim_win_get_cursor(0)[1]
        local lines = vim.api.nvim_buf_line_count(0)
        local i = math.floor(curr_line / lines * (#self.sbar - 1)) + 1
        return string.rep(self.sbar[i], 2)
    end,
    hl = { fg = "blue", bg = "bright_bg" },
}

local LSPActive = {
    condition = conditions.lsp_attached,
    update = { "LspAttach", "LspDetach", "WinEnter" },

    provider = " [LSP]",

    -- Or complicate things a bit and get the servers names
    -- provider  = function(self)
    --     local names = {}
    --     for i, server in pairs(vim.lsp.buf_get_active_clients({ bufnr = 0 })) do
    --         table.insert(names, server.name)
    --     end
    --     return " [" .. table.concat(names, " ") .. "]"
    -- end,
    hl = { fg = "green", bold = true },
    on_click = {
        name = "heirline_LSP",
        callback = function()
            vim.schedule(function()
                vim.cmd("LspInfo")
            end)
        end,
    },
}

local Diagnostics = {

    condition = conditions.has_diagnostics,
    update = { "DiagnosticChanged", "BufEnter" },
    on_click = {
        callback = function()
            require("trouble").toggle({ mode = "document_diagnostics" })
        end,
        name = "heirline_diagnostics",
    },

    static = {
        error_icon = vim.fn.sign_getdefined("DiagnosticSignError")[1].text,
        warn_icon = vim.fn.sign_getdefined("DiagnosticSignWarn")[1].text,
        info_icon = vim.fn.sign_getdefined("DiagnosticSignInfo")[1].text,
        hint_icon = vim.fn.sign_getdefined("DiagnosticSignHint")[1].text,
    },

    init = function(self)
        self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
        self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
        self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
        self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
    end,

    {
        provider = function(self)
            return self.errors > 0 and (self.error_icon .. self.errors .. " ")
        end,
        hl = "DiagnosticError",
    },
    {
        provider = function(self)
            return self.warnings > 0 and (self.warn_icon .. self.warnings .. " ")
        end,
        hl = "DiagnosticWarn",
    },
    {
        provider = function(self)
            return self.info > 0 and (self.info_icon .. self.info .. " ")
        end,
        hl = "DiagnosticInfo",
    },
    {
        provider = function(self)
            return self.hints > 0 and (self.hint_icon .. self.hints)
        end,
        hl = "DiagnosticHint",
    },
}

local Git = {
    condition = conditions.is_git_repo,

    init = function(self)
        self.status_dict = vim.b.gitsigns_status_dict
        self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
    end,

    on_click = {
        callback = function(self, minwid, nclicks, button)
            vim.defer_fn(function()
                vim.cmd("Lazygit %:p:h")
            end, 100)
        end,
        name = "heirline_git",
        update = false,
    },

    hl = { fg = "orange" },

    {
        provider = function(self)
            return " " .. self.status_dict.head
        end,
        hl = { bold = true },
    },
    {
        condition = function(self)
            return self.has_changes
        end,
        provider = "(",
    },
    {
        provider = function(self)
            local count = self.status_dict.added or 0
            return count > 0 and ("+" .. count)
        end,
        hl = green,
    },
    {
        provider = function(self)
            local count = self.status_dict.removed or 0
            return count > 0 and ("-" .. count)
        end,
        hl = red,
    },
    {
        provider = function(self)
            local count = self.status_dict.changed or 0
            return count > 0 and ("~" .. count)
        end,
        hl = orange,
    },
    {
        condition = function(self)
            return self.has_changes
        end,
        provider = ")",
    },
}

local DAPMessages = {
    condition = function()
        local session = require("dap").session()
        return session ~= nil
    end,
    provider = function()
        return " " .. require("dap").status() .. " "
    end,
    hl = "Debug",
    {
        provider = " ",
        on_click = {
            callback = function()
                require("dap").step_into()
            end,
            name = "heirline_dap_step_into",
        },
    },
    { provider = " " },
    {
        provider = " ",
        on_click = {
            callback = function()
                require("dap").step_out()
            end,
            name = "heirline_dap_step_out",
        },
    },
    { provider = " " },
    {
        provider = " ",
        on_click = {
            callback = function()
                require("dap").step_over()
            end,
            name = "heirline_dap_step_over",
        },
    },
    { provider = " " },
    {
        provider = " ",
        hl = { fg = "green" },
        on_click = {
            callback = function()
                require("dap").run_last()
            end,
            name = "heirline_dap_run_last",
        },
    },
    { provider = " " },
    {
        provider = " ",
        hl = { fg = "red" },
        on_click = {
            callback = function()
                require("dap").terminate()
                require("dapui").close({})
            end,
            name = "heirline_dap_close",
        },
    },
    { provider = " " },
    --       ﰇ  
}

local WorkDir = {
    init = function(self)
        self.icon = (vim.fn.haslocaldir(0) == 1 and "l" or "g") .. " " .. " "
        local cwd = vim.fn.getcwd(0)
        self.cwd = vim.fn.fnamemodify(cwd, ":~")
        if not conditions.width_percent_below(#self.cwd, 0.27) then
            self.cwd = vim.fn.pathshorten(self.cwd)
        end
    end,
    hl = { fg = "blue", bold = true },
    on_click = {
        callback = function()
            vim.cmd("NeoTreeFocusToggle")
        end,
        name = "heirline_workdir",
    },

    flexible = 1,
    {
        provider = function(self)
            local trail = self.cwd:sub(-1) == "/" and "" or "/"
            return self.icon .. self.cwd .. trail .. " "
        end,
    },
    {
        provider = function(self)
            local cwd = vim.fn.pathshorten(self.cwd)
            local trail = self.cwd:sub(-1) == "/" and "" or "/"
            return self.icon .. cwd .. trail .. " "
        end,
    },
    {
        provider = "",
    },
}

local HelpFilename = {
    condition = function()
        return vim.bo.filetype == "help"
    end,
    provider = function()
        local filename = vim.api.nvim_buf_get_name(0)
        return vim.fn.fnamemodify(filename, ":t")
    end,
    hl = "Directory",
}

local TerminalName = {
    -- icon = ' ', -- 
    {
        provider = function()
            local tname, _ = vim.api.nvim_buf_get_name(0):gsub(".*:", "")
            return " " .. tname
        end,
        hl = { fg = "blue", bold = true },
    },
    { provider = " - " },
    {
        provider = function()
            return vim.b.term_title
        end,
    },
    {
        provider = function()
            return " "
        end,
        hl = { bold = true, fg = "blue" },
    },
}

local Spell = {
    condition = function()
        return vim.wo.spell
    end,
    provider = "SPELL ",
    hl = { bold = true, fg = "orange" },
}

local SearchCount = {
    condition = function()
        return vim.v.hlsearch ~= 0 and vim.o.cmdheight == 0
    end,
    init = function(self)
        local ok, search = pcall(vim.fn.searchcount)
        if ok and search.total then
            self.search = search
        end
    end,
    provider = function(self)
        local search = self.search
        return string.format("[%d/%d]", search.current, math.min(search.total, search.maxcount))
    end,
}

local MacroRec = {
    condition = function()
        return vim.fn.reg_recording() ~= "" and vim.o.cmdheight == 0
    end,
    provider = " ",
    hl = { fg = "orange", bold = true },
    utils.surround({ "[", "]" }, nil, {
        provider = function()
            return vim.fn.reg_recording()
        end,
        hl = { fg = "green", bold = true },
    }),
}

ViMode = utils.surround({ "", "" }, "bright_bg", { ViMode })

local Align = { provider = "%=" }
local Space = { provider = " " }

local DefaultStatusline = {
    ViMode,
    SearchCount,
    MacroRec,
    Space,
    Spell,
    WorkDir,
    FileNameBlock,
    { provider = "%<" },
    Space,
    Git,
    Space,
    Diagnostics,
    Space,
    wpm_input,
    Align,
    DAPMessages,
    Space,
    cava,
    Space,
    mpv,
    Space,
    -- { flexible = 3, { cava, mpv }, { provider = "" } },
    LSPActive,
    Space,
    FileType,
    { flexible = 3, { Space, FileEncoding }, { provider = "" } },
    Space,
    Ruler,
    Space,
    ScrollBar,
    Space,
    possession,
    {
        condition = vim.g.codeium_enabled,
        provider = function()
            if vim.g.codeium_enabled then
                return vim.fn["codeium#GetStatusString"]()
            else
                return " CMP[ON]"
            end
        end,
    },
}

local InactiveStatusline = {
    condition = conditions.is_not_active,
    { hl = { fg = "gray", force = true }, WorkDir },
    FileNameBlock,
    { provider = "%<" },
    Align,
}

local SpecialStatusline = {
    condition = function()
        return conditions.buffer_matches({
            buftype = { "nofile", "prompt", "help", "quickfix" },
            filetype = { "^git.*", "fugitive" },
        })
    end,
    FileType,
    { provider = "%q" },
    Space,
    HelpFilename,
    Align,
}

local GitStatusline = {
    condition = function()
        return conditions.buffer_matches({
            filetype = { "^git.*", "fugitive" },
        })
    end,
    FileType,
    Space,
    {
        provider = function()
            return vim.fn.FugitiveStatusline()
        end,
    },
    Space,
    Align,
}

local TerminalStatusline = {
    condition = function()
        return conditions.buffer_matches({ buftype = { "terminal" } })
    end,
    hl = { bg = "dark_red" },
    { condition = conditions.is_active, ViMode, Space },
    FileType,
    Space,
    TerminalName,
    Align,
}

local StatusLines = {

    hl = function()
        return "StatusLineNC"
    end,
    static = {
        mode_colors = {
            n = "red",
            i = "green",
            v = "cyan",
            V = "cyan",
            ["\22"] = "cyan", -- this is an actual ^V, type <C-v><C-v> in insert mode
            c = "orange",
            s = "purple",
            S = "purple",
            ["\19"] = "purple", -- this is an actual ^S, type <C-v><C-s> in insert mode
            R = "orange",
            r = "orange",
            ["!"] = "red",
            t = "green",
        },
        mode_color = function(self)
            local mode = conditions.is_active() and vim.fn.mode() or "n"
            return self.mode_colors[mode]
        end,
    },
    --
    -- fallthrough = false,
    --
    GitStatusline,
    SpecialStatusline,
    TerminalStatusline,
    InactiveStatusline,
    DefaultStatusline,
}

require("heirline").setup({ statusline = StatusLines })

vim.cmd([[au Heirline FileType * if index(['wipe', 'delete'], &bufhidden) >= 0 | set nobuflisted | endif]])
vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
        local colors = setup_colors()
        utils.on_colorscheme(colors)
    end,
    group = "Heirline",
})
