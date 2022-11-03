local conditions = require("heirline.conditions")
local utils = require("heirline.utils")

local function setup_colors()
    -- i just have this to shut this thing up tbh
    require("utils.ui.highlights").plugin("heirline", {
        { diffAdded = { link = "DiffAdd" } },
        { diffChanged = { link = "DiffChange" } },
        { diffRemoved = { link = "DiffDelete" } },
        { diffDeleted = { link = "DiffDelete" } },
    })

    local values = {

        bright_bg = utils.get_highlight("Folded").bg,
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
        git_del = utils.get_highlight("diffDeleted").fg,
        git_add = utils.get_highlight("diffAdded").fg,
        git_change = utils.get_highlight("diffChanged").fg,
    }
    for k, v in pairs(values) do
        if v == nil then
            values[k] = utils.get_highlight("NonText").fg
        end
    end

    return values
end

require("heirline").load_colors(setup_colors())
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

    utils.make_flexible_component(2, {
        provider = function(self)
            return self.lfilename
        end,
    }, {
        provider = function(self)
            return vim.fn.pathshorten(self.lfilename)
        end,
    }),
}

local FileFlags = {
    {
        provider = function()
            if vim.bo.modified then
                return "[+]"
            end
        end,
        hl = { fg = "green" },
    },
    {
        provider = function()
            if not vim.bo.modifiable or vim.bo.readonly then
                return ""
            end
        end,
        hl = "Constant",
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

local Ruler = {
    -- %l = current line number
    -- %L = number of lines in the buffer
    -- %c = column number
    -- %P = percentage through file of displayed window
    provider = "%7(%l/%3L%):%2c %P",
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

local LSPActive = {
    condition = conditions.lsp_attached,
    update = { "LspAttach", "LspDetach", "WinEnter" },

    provider = " [LSP]",

    -- Or complicate things a bit and get the servers names
    -- provider  = function(self)
    --     local names = {}
    --     for i, server in pairs(vim.lsp.buf_get_clients(0)) do
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

local get_sub_fg = function()
    local ok, msg = pcall(require, "cool-substitute.status")
    if ok then
        return msg.status_color()
    else
        return
    end
end

local cool_substitute = {
    condition = function()
        return package.loaded["cool-substitute"] ~= nil
    end,
    provider = function()
        return require("cool-substitute.status").status_with_icons()
    end,
    hl = {

        fg = get_sub_fg(),
    },
}

-- local plugin_watcher = {
--     condition = function()
--         return package.loaded["plugwatch"] ~= nil
--     end,
--     provider = function()
--         return " " ..require("plugwatch").get_statusline_indicator()
--     end,
-- }
-- -- local Gps2 = {
--     condition = require("nvim-navic").is_available,
--     provider = require("nvim-navic").get_location,
--     hl = { fg = "gray" },
-- }
-- local Gps = {
--     condition = conditions.lsp_attached,
--     provider = function(self)
--         return current_function() .. current_signature()
--     end,
--     hl = { fg = "gray" },
-- }
local Navic = {
    condition = require("nvim-navic").is_available,
    static = {
        type_hl = {
            File = "Directory",
            Module = "Include",
            Namespace = "@namespace",
            Package = "Include",
            --[[ Class = "Struct", ]]
            Method = "Method",
            Property = "@property",
            Field = "@feild",
            Constructor = "@constructor",
            Enum = "@field",
            Interface = "Type",
            Function = "Function",
            Variable = "TSVariable",
            Constant = "Constant",
            String = "String",
            Number = "Number",
            Boolean = "Boolean",
            Array = "@feild",
            Object = "Type",
            Key = "@keyword",
            Null = "Comment",
            EnumMember = "@feild",
            Struct = "@struct",
            Event = "Keyword",
            Operator = "Operator",
            TypeParameter = "Type",
        },
    },
    init = function(self)
        local data = require("nvim-navic").get_data() or {}
        local children = {}
        for i, d in ipairs(data) do
            local child = {
                {
                    provider = d.icon .. " ",
                    hl = self.type_hl[d.type],
                },
                {
                    provider = d.name,
                    -- hl = self.type_hl[d.type],
                },
            }
            if #data > 1 and i < #data then
                table.insert(child, {
                    provider = " > ",
                    hl = { fg = "bright_fg" },
                })
            end
            table.insert(children, child)
        end
        self[1] = self:new(children, 1)
    end,
    hl = { fg = "gray" },
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
        hl = "diffAdded",
    },
    {
        provider = function(self)
            local count = self.status_dict.removed or 0
            return count > 0 and ("-" .. count)
        end,

        hl = "diffRemoved",
    },
    {
        provider = function(self)
            local count = self.status_dict.changed or 0
            return count > 0 and ("~" .. count)
        end,
        hl = "diffChanged",
    },
    {
        condition = function(self)
            return self.has_changes
        end,
        provider = ")",
    },
}

local Snippets = {
    -- check that we are in insert or select mode
    condition = function()
        return vim.tbl_contains({ "s", "i" }, vim.fn.mode())
    end,
    provider = function()
        local luasnip = require("luasnip")
        local forward = luasnip.jumpable(1) and "  " or ""
        local backward = luasnip.jumpable(-1) and "  " or ""
        return backward .. forward
    end,
    hl = { fg = "red", bold = true },
}

local DAPMessages = {
    condition = function()
        local session = require("dap").session()
        if session then
            local filename = vim.api.nvim_buf_get_name(0)
            if session.config then
                local progname = session.config.program
                return filename == progname
            end
        end
        return false
    end,
    provider = function()
        return " " .. require("dap").status()
    end,
    hl = "Debug",
    --       ﰇ  
}

local WorkDir = {
    provider = function(self)
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
            vim.cmd("NvimTreeToggle")
        end,
        name = "heirline_workdir",
    },
    utils.make_flexible_component(1, {
        provider = function(self)
            local trail = self.cwd:sub(-1) == "/" and "" or "/"
            return self.icon .. self.cwd .. trail .. " "
        end,
    }, {
        provider = function(self)
            local cwd = vim.fn.pathshorten(self.cwd)
            local trail = self.cwd:sub(-1) == "/" and "" or "/"
            return self.icon .. cwd .. trail .. " "
        end,
    }, {
        provider = "",
    }),
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

ViMode = utils.surround({ "", "" }, "bright_bg", { ViMode, Snippets })

local Align = { provider = "%=" }
local Space = { provider = " " }

local hydra = require("hydra.statusline")
local HydraActive = {
    condition = hydra.is_active,
    utils.surround({ "", "" }, function() -- color
        return "orange"
    end, {
        {
            fallthrough = false,
            Space,
            { provider = "" },
        },
        Space,
        {
            provider = function()
                return " " .. hydra.get_name() .. "  " or "HYDRA"
            end,
        },
        hl = { fg = "red", force = true },
    }),
}

local DefaultStatusline = {
    ViMode,
    Space,
    Spell,
    WorkDir,
    FileNameBlock,
    { provider = "%<" },
    Space,
    Git,
    Space,
    Diagnostics,
    Align,
    utils.make_flexible_component(3, cool_substitute, { provider = "" }),
    utils.make_flexible_component(3, HydraActive, { provider = "" }),
    -- space,
    DAPMessages,
    Align,
    LSPActive,
    Space,
    FileType,
    utils.make_flexible_component(3, { Space, FileEncoding }, { provider = "" }),
    Space,
    Ruler,
    Space,
    ScrollBar,
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
            vim.cmd([[packadd vim-fugitive]])
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
    hl = { fg = "gray" },
    { condition = conditions.is_active, ViMode, Space },
    FileType,
    Space,
    TerminalName,
    Align,
}

local StatusLines = {

    hl = function()
        if conditions.is_active() then
            return "StatusLine"
        else
            return "StatusLineNC"
        end
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

    fallthrough = false,

    GitStatusline,
    SpecialStatusline,
    TerminalStatusline,
    InactiveStatusline,
    DefaultStatusline,
}

local CloseButton = {
    condition = function(self)
        return not vim.bo.modified
    end,
    -- update = 'BufEnter',
    update = { "WinNew", "WinClosed", "BufEnter" },
    { provider = " " },
    {
        provider = "",
        hl = { fg = "gray" },
        on_click = {
            callback = function(_, winid)
                vim.api.nvim_win_close(winid, true)
            end,
            name = function(self)
                return "heirline_close_button_" .. self.winnr
            end,
            update = true,
        },
    },
}

local WinBar = {
    fallthrough = false,
    {
        condition = function()
            return conditions.buffer_matches({
                buftype = { "nofile", "prompt", "help", "quickfix" },
                filetype = { "^git.*", "fugitive" },
            })
        end,
        init = function()
            vim.opt_local.winbar = nil
        end,
    },

    {
        condition = function()
            return conditions.buffer_matches({ buftype = { "terminal" } })
        end,
        utils.surround({ "", "" }, "dark_red", {
            FileType,
            Space,
            TerminalName,
            CloseButton,
        }),
    },

    utils.surround({ "", "" }, "bright_bg", {
        hl = function()
            if conditions.is_not_active() then
                return { fg = "gray", force = true }
            end
        end,
        FileNameBlock,
        CloseButton,
        Space,
        Navic,
    }),
}

--require("heirline").setup(StatusLines)
-- /home/viv/.local/share/nvim/site/pack/packer/opt/heirline.nvim/lua/heirline
-- Line 42 : modification
-- style = vim.tbl_filter(function(value) return value ~= true end, style)
require("heirline").setup(StatusLines, WinBar)

vim.api.nvim_create_augroup("Heirline", { clear = true })
vim.api.nvim_create_autocmd("User", {
    pattern = "HeirlineInitWinbar",
    callback = function(args)
        local buf = args.buf
        if
            vim.tbl_contains({
                "terminal",
                "prompt",
                "nofile",
                "help",
                "quickfix",
            }, vim.bo[buf].buftype)
            or vim.tbl_contains({
                "gitcommit",
                "fugitive",
                "toggleterm",
                "NvimTree",
            }, vim.bo[buf].filetype)
            or not vim.bo[buf].buflisted
        then
            vim.opt_local.winbar = nil
        end
    end,
    group = "Heirline",
})

local colour_change = function()
    require("heirline").reset_highlights()
    require("heirline").clear_colors()
    require("heirline").load_colors(setup_colors())
    require("heirline").statusline:broadcast(function(self)
        self._win_stl = nil
    end)
    require("utils.ui.highlights")
    require("lightspeed").init_highlight(true)
end

lambda.augroup("Colourscheme", {
    {
        event = "FileType",
        pattern = "*",
        command = [[if index(['wipe', 'delete', 'unload'], &bufhidden) >= 0 | set nobuflisted | endif]],
    },
    {
        event = "User",
        pattern = "HeirlineInitWinbar",
        command = function(args)
            local buf = args.buf
            local buftype = vim.tbl_contains({ "prompt", "nofile", "help", "quickfix" }, vim.bo[buf].buftype)
            local filetype = vim.tbl_contains({ "gitcommit", "fugitive", "Trouble", "packer" }, vim.bo[buf].filetype)
            if buftype or filetype then
                vim.opt_local.winbar = nil
            end
        end,
    },
    {
        event = "ColorScheme",
        command = function()
            colour_change()
        end,
    },
})
