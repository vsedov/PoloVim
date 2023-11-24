local ui = require("core.pack").package
local conf = require("modules.ui.config")
local highlight, foo, falsy, augroup = lambda.highlight, lambda.style, lambda.falsy, lambda.augroup
local border, rect = foo.border.type_0, foo.border.type_0
local icons = lambda.style.icons
ui({
    "rcarriga/nvim-notify",
    dependencies = {
        {
            "j-hui/fidget.nvim",
            cond = lambda.config.ui.use_fidgit,
            event = "VeryLazy",
            opts = {
                notification = {
                    override_vim_notify = true,
                },
            },
        },
    },
})

ui({
    "glepnir/nerdicons.nvim",
    cmd = "NerdIcons",
    config = true,
})

ui({
    "rebelot/heirline.nvim",
    cond = lambda.config.ui.heirline.use_heirline,
    event = "VeryLazy",
    config = function()
        local conditions = require("heirline.conditions")
        local utils = require("heirline.utils")

        --- Blend two rgb colors using alpha
        ---@param color1 string | number first color
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

        local icons = {
            -- ✗   󰅖 󰅘 󰅚 󰅙 󱎘 
            close = "󰅙 ",
            dir = "󰉋 ",
            lsp = " ", --   
            vim = " ",
            debug = " ",
            err = vim.fn.sign_getdefined("DiagnosticSignError")[1].text,
            warn = vim.fn.sign_getdefined("DiagnosticSignWarn")[1].text,
            info = vim.fn.sign_getdefined("DiagnosticSignInfo")[1].text,
            hint = vim.fn.sign_getdefined("DiagnosticSignHint")[1].text,
        }

        local separators = {
            rounded_left = "",
            rounded_right = "",
            rounded_left_hollow = "",
            rounded_right_hollow = "",
            powerline_left = "",
            powerline_right = "",
            powerline_right_hollow = "",
            powerline_left_hollow = "",
            slant_left = "",
            slant_right = "",
            inverted_slant_left = "",
            inverted_slant_right = "",
            slant_ur = "",
            slant_br = "",
            vert = "│",
            vert_thick = "┃",
            block = "█",
            double_vert = "║",
            dotted_vert = "┊",
        }

        local function setup_colors()
            return {
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
        end

        local ViMode = {
            init = function(self)
                self.mode = vim.fn.mode(1)
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
                return icons.vim .. "%2(" .. self.mode_names[self.mode] .. "%)"
            end,
            --    
            hl = function(self)
                local color = self:mode_color()
                return { fg = color, bold = true }
            end,
            update = {
                "ModeChanged",
                pattern = "*:*",
                callback = vim.schedule_wrap(function()
                    vim.cmd("redrawstatus")
                end),
            },
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
            hl = function()
                if vim.bo.modified then
                    return { fg = utils.get_highlight("Directory").fg, bold = true, italic = true }
                end
                return "Directory"
            end,
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
                provider = " ● ", --[+]",
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

        local FileNameBlock = {
            init = function(self)
                self.filename = vim.api.nvim_buf_get_name(0)
            end,
            FileIcon,
            FileName,
            unpack(FileFlags),
        }

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
            provider = icons.lsp .. "LSP",
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

        local Navic = {
            condition = function()
                return require("nvim-navic").is_available()
            end,
            static = {
                type_hl = {
                    File = dim(utils.get_highlight("Directory").fg, 0.75),
                    Module = dim(utils.get_highlight("@include").fg, 0.75),
                    Namespace = dim(utils.get_highlight("@namespace").fg, 0.75),
                    Package = dim(utils.get_highlight("@include").fg, 0.75),
                    Class = dim(utils.get_highlight("@type").fg, 0.75),
                    Method = dim(utils.get_highlight("@method").fg, 0.75),
                    Property = dim(utils.get_highlight("@property").fg, 0.75),
                    Field = dim(utils.get_highlight("@field").fg, 0.75),
                    Constructor = dim(utils.get_highlight("@constructor").fg, 0.75),
                    Enum = dim(utils.get_highlight("@type").fg, 0.75),
                    Interface = dim(utils.get_highlight("@type").fg, 0.75),
                    Function = dim(utils.get_highlight("@function").fg, 0.75),
                    Variable = dim(utils.get_highlight("@variable").fg, 0.75),
                    Constant = dim(utils.get_highlight("@constant").fg, 0.75),
                    String = dim(utils.get_highlight("@string").fg, 0.75),
                    Number = dim(utils.get_highlight("@number").fg, 0.75),
                    Boolean = dim(utils.get_highlight("@boolean").fg, 0.75),
                    Array = dim(utils.get_highlight("@field").fg, 0.75),
                    Object = dim(utils.get_highlight("@type").fg, 0.75),
                    Key = dim(utils.get_highlight("@keyword").fg, 0.75),
                    Null = dim(utils.get_highlight("@comment").fg, 0.75),
                    EnumMember = dim(utils.get_highlight("@constant").fg, 0.75),
                    Struct = dim(utils.get_highlight("@type").fg, 0.75),
                    Event = dim(utils.get_highlight("@type").fg, 0.75),
                    Operator = dim(utils.get_highlight("@operator").fg, 0.75),
                    TypeParameter = dim(utils.get_highlight("@type").fg, 0.75),
                },
                -- line: 16 bit (65536); col: 10 bit (1024); winnr: 6 bit (64)
                -- local encdec = function(a,b,c) return dec(enc(a,b,c)) end; vim.pretty_print(encdec(2^16 - 1, 2^10 - 1, 2^6 - 1))
                enc = function(line, col, winnr)
                    return bit.bor(bit.lshift(line, 16), bit.lshift(col, 6), winnr)
                end,
                dec = function(c)
                    local line = bit.rshift(c, 16)
                    local col = bit.band(bit.rshift(c, 6), 1023)
                    local winnr = bit.band(c, 63)
                    return line, col, winnr
                end,
            },
            init = function(self)
                local data = require("nvim-navic").get_data() or {}
                local children = {}
                for i, d in ipairs(data) do
                    local pos = self.enc(d.scope.start.line, d.scope.start.character, self.winnr)
                    local child = {
                        {
                            provider = d.icon,
                            hl = { fg = self.type_hl[d.type] },
                        },
                        {
                            provider = d.name:gsub("%%", "%%%%"):gsub("%s*->%s*", ""),
                            hl = { fg = self.type_hl[d.type] },
                            -- hl = self.type_hl[d.type],
                            on_click = {
                                callback = function(_, minwid)
                                    local line, col, winnr = self.dec(minwid)
                                    vim.api.nvim_win_set_cursor(vim.fn.win_getid(winnr), { line, col })
                                end,
                                minwid = pos,
                                name = "heirline_navic",
                            },
                        },
                    }
                    if i < #data then
                        table.insert(child, {
                            provider = " → ",
                            hl = { fg = "bright_fg" },
                        })
                    end
                    table.insert(children, child)
                end
                self[1] = self:new(children, 1)
            end,
            update = "CursorMoved",
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
            static = {},
            init = function(self)
                self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
                self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
                self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
                self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
            end,
            {
                provider = function(self)
                    return self.errors > 0 and (icons.err .. self.errors .. " ")
                end,
                hl = "DiagnosticError",
            },
            {
                provider = function(self)
                    return self.warnings > 0 and (icons.warn .. self.warnings .. " ")
                end,
                hl = "DiagnosticWarn",
            },
            {
                provider = function(self)
                    return self.info > 0 and (icons.info .. self.info .. " ")
                end,
                hl = "DiagnosticInfo",
            },
            {
                provider = function(self)
                    return self.hints > 0 and (icons.hint .. self.hints)
                end,
                hl = "DiagnosticHint",
            },
        }

        local Git = {
            condition = conditions.is_git_repo,
            init = function(self)
                self.status_dict = vim.b.gitsigns_status_dict
                self.has_changes = self.status_dict.added ~= 0
                    or self.status_dict.removed ~= 0
                    or self.status_dict.changed ~= 0
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
                hl = "diffDeleted",
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
            condition = function()
                return vim.tbl_contains({ "s", "i" }, vim.fn.mode())
            end,
            provider = function()
                local forward = (vim.fn["UltiSnips#CanJumpForwards"]() == 1) and " " or ""
                local backward = (vim.fn["UltiSnips#CanJumpBackwards"]() == 1) and " " or ""
                return backward .. forward
            end,
            hl = { fg = "red", bold = true },
        }

        local DAPMessages = {
            condition = function()
                local session = require("dap").session()
                return session ~= nil
            end,
            provider = function()
                return icons.debug .. require("dap").status() .. " "
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
                self.icon = (vim.fn.haslocaldir(0) == 1 and "l" or "g") .. " " .. icons.dir
                local cwd = vim.fn.getcwd(0)
                self.cwd = vim.fn.fnamemodify(cwd, ":~")
                if not conditions.width_percent_below(#self.cwd, 0.27) then
                    self.cwd = vim.fn.pathshorten(self.cwd)
                end
            end,
            hl = { fg = "blue", bold = true },
            on_click = {
                callback = function()
                    vim.cmd("Neotree toggle")
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
                    local id = require("terminal"):current_term_index()
                    return " " .. (id or "Exited")
                end,
                hl = { bold = true, fg = "blue" },
            },
        }

        local Spell = {
            condition = function()
                return vim.wo.spell
            end,
            provider = function()
                return "󰓆 " .. vim.o.spelllang .. " "
            end,
            hl = { bold = true, fg = "green" },
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
                return string.format(" %d/%d", search.current, math.min(search.total, search.maxcount))
            end,
            hl = { fg = "purple", bold = true },
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
            update = {
                "RecordingEnter",
                "RecordingLeave",
            },
            { provider = " " },
        }

        -- WIP
        local VisualRange = {
            condition = function()
                return vim.tbl_containsvim({ "V", "v" }, vim.fn.mode())
            end,
            provider = function()
                local start = vim.fn.getpos("'<")
                local stop = vim.fn.getpos("'>")
            end,
        }

        local ShowCmd = {
            condition = function()
                return vim.o.cmdheight == 0
            end,
            provider = ":%3.5(%S%)",
            hl = function(self)
                return { bold = true, fg = self:mode_color() }
            end,
        }

        -- local VirtualEnv = {
        --     init = function(self)
        --         if not self.timer then
        --             self.timer = vim.loop.new_timer()
        --             self.timer:start(0, 5000, function()
        --                 vim.schedule_wrap(function()
        --                     local path = vim.fn.split(vim.fn.system("which python"), "/")
        --                     vim.notify(path)
        --                     self.pythonpath = path[#path - 2]
        --                 end)
        --             end)
        --         end
        --     end,
        --     provider = function(self)
        --         return self.pythonpath
        --     end,
        -- }

        local Align = { provider = "%=" }
        local Space = { provider = " " }

        ViMode = utils.surround({ "", "" }, "bright_bg", { MacroRec, ViMode, Snippets, ShowCmd })

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
            -- { flexible = 3,   { Navic, Space }, { provider = "" } },
            Align,
            DAPMessages,
            LSPActive,
            -- VirtualEnv,
            Space,
            FileType,
            { flexible = 3, { FileEncoding, Space }, { provider = "" } },
            Space,
            Ruler,
            SearchCount,
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
            -- GitStatusline,
            SpecialStatusline,
            TerminalStatusline,
            InactiveStatusline,
            DefaultStatusline,
        }

        local CloseButton = {
            condition = function(self)
                return not vim.bo.modified
            end,
            update = { "WinNew", "WinClosed", "BufEnter" },
            { provider = " " },
            {
                provider = icons.close,
                hl = { fg = "gray" },
                on_click = {
                    callback = function(_, minwid)
                        vim.api.nvim_win_close(minwid, true)
                    end,
                    minwid = function()
                        return vim.api.nvim_get_current_win()
                    end,
                    name = "heirline_winbar_close_button",
                },
            },
        }

        local WinBar = {
            fallthrough = false,
            -- {
            --     condition = function()
            --         return conditions.buffer_matches({
            --             buftype = { "nofile", "prompt", "help", "quickfix" },
            --             filetype = { "^git.*", "fugitive" },
            --         })
            --     end,
            --     init = function()
            --         vim.opt_local.winbar = nil
            --     end,
            -- },
            {
                condition = function()
                    return conditions.buffer_matches({ buftype = { "terminal" } })
                end,
                utils.surround({ "", "" }, "dark_red", {
                    FileType,
                    Space,
                    TerminalName,
                    CloseButton,
                }),
            },
            utils.surround({ "", "" }, "bright_bg", {
                fallthrough = false,
                {
                    condition = conditions.is_not_active,
                    {
                        hl = { fg = "bright_fg", force = true },
                        FileNameBlock,
                    },
                    CloseButton,
                },
                {
                    -- provider = "      ",
                    Navic,
                    { provider = "%<" },
                    Align,
                    FileNameBlock,
                    CloseButton,
                },
            }),
        }

        local TablineBufnr = {
            provider = function(self)
                return tostring(self.bufnr) .. ". "
            end,
            hl = "Comment",
        }

        local TablineFileName = {
            provider = function(self)
                local filename = vim.fn.fnamemodify(self.filename, ":t")
                if self.dupes and self.dupes[filename] then
                    filename = vim.fn.fnamemodify(self.filename, ":h:t") .. "/" .. filename
                end
                filename = filename == "" and "[No Name]" or filename
                return filename
            end,
            hl = function(self)
                return { bold = self.is_active or self.is_visible, italic = true }
            end,
        }

        local TablineFileFlags = {
            {
                condition = function(self)
                    return vim.api.nvim_buf_get_option(self.bufnr, "modified")
                end,
                provider = " ● ", --"[+]",
                hl = { fg = "green" },
            },
            {
                condition = function(self)
                    return not vim.api.nvim_buf_get_option(self.bufnr, "modifiable")
                        or vim.api.nvim_buf_get_option(self.bufnr, "readonly")
                end,
                provider = function(self)
                    if vim.api.nvim_buf_get_option(self.bufnr, "buftype") == "terminal" then
                        return "  "
                    else
                        return ""
                    end
                end,
                hl = { fg = "orange" },
            },
            {
                condition = function(self)
                    return not vim.api.nvim_buf_is_loaded(self.bufnr)
                end,
                -- a downright arrow
                provider = " 󰘓 ", --󰕁 
                hl = { fg = "gray" },
            },
        }

        local TablineFileNameBlock = {
            init = function(self)
                self.filename = vim.api.nvim_buf_get_name(self.bufnr)
            end,
            hl = function(self)
                if self.is_active then
                    return "TabLineSel"
                elseif not vim.api.nvim_buf_is_loaded(self.bufnr) then
                    return { fg = "gray" }
                else
                    return "TabLine"
                end
            end,
            on_click = {
                callback = function(self, minwid, nclicks)
                    if nclicks == 1 then
                        vim.api.nvim_win_set_buf(0, minwid)
                    elseif nclicks == 2 then
                        if vim.t.winrestcmd then
                            vim.cmd(vim.t.winrestcmd)
                            vim.t.winrestcmd = nil
                        else
                            vim.t.winrestcmd = vim.fn.winrestcmd()
                            vim.cmd.wincmd("|")
                            vim.cmd.wincmd("_")
                        end
                    end
                end,
                minwid = function(self)
                    return self.bufnr
                end,
                name = "heirline_tabline_buffer_callback",
            },
            TablineBufnr,
            FileIcon,
            TablineFileName,
            TablineFileFlags,
        }

        local TablineCloseButton = {
            condition = function(self)
                -- return not vim.bo[self.bufnr].modified
                return not vim.api.nvim_buf_get_option(self.bufnr, "modified")
            end,
            { provider = " " },
            {
                provider = icons.close,
                hl = { fg = "gray" },
                on_click = {
                    callback = function(_, minwid)
                        vim.schedule(function()
                            vim.api.nvim_buf_delete(minwid, { force = false })
                            vim.cmd.redrawtabline()
                        end)
                    end,
                    minwid = function(self)
                        return self.bufnr
                    end,
                    name = "heirline_tabline_close_buffer_callback",
                },
            },
        }

        local TablinePicker = {
            condition = function(self)
                return self._show_picker
            end,
            init = function(self)
                local bufname = vim.api.nvim_buf_get_name(self.bufnr)
                bufname = vim.fn.fnamemodify(bufname, ":t")
                local label = bufname:sub(1, 1)
                local i = 2
                while self._picker_labels[label] do
                    label = bufname:sub(i, i)
                    if i > #bufname then
                        break
                    end
                    i = i + 1
                end
                self._picker_labels[label] = self.bufnr
                self.label = label
            end,
            provider = function(self)
                return self.label
            end,
            hl = { fg = "red", bold = true },
        }

        vim.keymap.set("n", "gbp", function()
            local tabline = require("heirline").tabline
            local buflist = tabline._buflist[1]
            buflist._picker_labels = {}
            buflist._show_picker = true
            vim.cmd.redrawtabline()
            local char = vim.fn.getcharstr()
            local bufnr = buflist._picker_labels[char]
            if bufnr then
                vim.api.nvim_win_set_buf(0, bufnr)
            end
            buflist._show_picker = false
            vim.cmd.redrawtabline()
        end)

        local TablineBufferBlock = utils.surround({ "", "" }, function(self)
            if self.is_active then
                return utils.get_highlight("TabLineSel").bg
            else
                return utils.get_highlight("TabLine").bg
            end
        end, { TablinePicker, TablineFileNameBlock, TablineCloseButton })

        local get_bufs = function()
            return vim.tbl_filter(function(bufnr)
                return vim.api.nvim_buf_get_option(bufnr, "buflisted")
            end, vim.api.nvim_list_bufs())
        end

        local buflist_cache = {}

        vim.api.nvim_create_autocmd({ "VimEnter", "UIEnter", "BufAdd", "BufDelete" }, {
            callback = function(args)
                vim.schedule(function()
                    local buffers = get_bufs()
                    for i, v in ipairs(buffers) do
                        buflist_cache[i] = v
                    end
                    for i = #buffers + 1, #buflist_cache do
                        buflist_cache[i] = nil
                    end

                    if #buflist_cache > 1 then
                        vim.o.showtabline = 2
                    else
                        vim.o.showtabline = 1
                    end
                end)
            end,
        })

        local BufferLine = utils.make_buflist(
            TablineBufferBlock,
            { provider = " ", hl = { fg = "gray" } },
            { provider = " ", hl = { fg = "gray" } },
            function()
                return buflist_cache
            end,
            false
        )

        local Tabpage = {
            {
                provider = function(self)
                    return " %" .. self.tabnr .. "T" .. self.tabnr .. " "
                end,
                hl = { bold = true },
            },
            {
                provider = function(self)
                    local n = #vim.api.nvim_tabpage_list_wins(self.tabpage)
                    return n .. "%T "
                end,
                hl = { fg = "gray" },
            },
            hl = function(self)
                if not self.is_active then
                    return "TabLine"
                else
                    return "TabLineSel"
                end
            end,
            update = { "TabNew", "TabClosed", "TabEnter", "TabLeave", "WinNew", "WinClosed" },
        }

        local TabpageClose = {
            provider = " %999X" .. icons.close .. "%X",
            hl = "TabLine",
        }

        local TabPages = {
            condition = function()
                return #vim.api.nvim_list_tabpages() >= 2
            end,
            {
                provider = "%=",
            },
            utils.make_tablist(Tabpage),
            TabpageClose,
        }

        local TabLineOffset = {
            condition = function(self)
                local win = vim.api.nvim_tabpage_list_wins(0)[1]
                local bufnr = vim.api.nvim_win_get_buf(win)
                self.winid = win

                if vim.api.nvim_buf_get_option(bufnr, "filetype") == "neo-tree" then
                    self.title = "NeoTree"
                    return true
                end
            end,
            provider = function(self)
                local title = self.title
                local width = vim.api.nvim_win_get_width(self.winid)
                local pad = math.ceil((width - #title) / 2)
                return string.rep(" ", pad) .. title .. string.rep(" ", pad)
            end,
            hl = function(self)
                if vim.api.nvim_get_current_win() == self.winid then
                    return "TablineSel"
                else
                    return "Tabline"
                end
            end,
        }

        vim.api.nvim_create_autocmd({ "VimEnter", "UIEnter", "BufAdd", "BufDelete" }, {
            callback = function(args)
                local counts = {}
                local dupes = {}
                local names = vim.tbl_map(function(bufnr)
                    return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":t")
                end, get_bufs())
                for _, name in ipairs(names) do
                    counts[name] = (counts[name] or 0) + 1
                end
                for name, count in pairs(counts) do
                    if count > 1 then
                        dupes[name] = true
                    end
                end
                require("heirline").tabline.dupes = dupes
            end,
        })

        local TabLine = {
            TabLineOffset,
            BufferLine,
            TabPages,
        }

        local Stc = {
            static = {
                ---@return {name:string, text:string, texthl:string}[]
                get_signs = function()
                    -- local buf = vim.api.nvim_get_current_buf()
                    local buf = vim.fn.expand("%")
                    return vim.tbl_map(function(sign)
                        return vim.fn.sign_getdefined(sign.name)[1]
                    end, vim.fn.sign_getplaced(buf, { group = "*", lnum = vim.v.lnum })[1].signs)
                end,
                resolve = function(self, name)
                    for pat, cb in pairs(self.handlers) do
                        if name:match(pat) then
                            return cb
                        end
                    end
                end,
                handlers = {
                    ["GitSigns.*"] = function(args)
                        require("gitsigns").preview_hunk_inline()
                    end,
                    ["Dap.*"] = function(args)
                        require("dap").toggle_breakpoint()
                    end,
                    ["Diagnostic.*"] = function(args)
                        vim.diagnostic.open_float() -- { pos = args.mousepos.line - 1, relative = "mouse" })
                    end,
                },
            },
            -- init = function(self)
            --     local signs = {}
            --     for _, s in ipairs(self.get_signs()) do
            --         if s.name:find("GitSign") then
            --             self.git_sign = s
            --         else
            --             table.insert(signs, s)
            --         end
            --     end
            --     self.signs = signs
            -- end,
            {
                provider = "%s",
                -- provider = function(self)
                --     -- return vim.inspect({ self.signs, self.git_sign })
                --     local children = {}
                --     for _, sign in ipairs(self.signs) do
                --         table.insert(children, {
                --             provider = sign.text,
                --             hl = sign.texthl,
                --         })
                --     end
                --     self[1] = self:new(children, 1)
                -- end,

                on_click = {
                    callback = function(self, ...)
                        local mousepos = vim.fn.getmousepos()
                        vim.api.nvim_win_set_cursor(0, { mousepos.line, mousepos.column })
                        local sign_at_cursor = vim.fn.screenstring(mousepos.screenrow, mousepos.screencol)
                        if sign_at_cursor ~= "" then
                            local args = {
                                mousepos = mousepos,
                            }
                            local signs = vim.fn.sign_getdefined()
                            for _, sign in ipairs(signs) do
                                local glyph = sign.text:gsub(" ", "")
                                if sign_at_cursor == glyph then
                                    vim.defer_fn(function()
                                        self:resolve(sign.name)(args)
                                    end, 10)
                                    return
                                end
                            end
                        end
                    end,
                    name = "heirline_signcol_callback",
                    update = true,
                },
            },
            {
                provider = "%=%4{v:virtnum ? '' : &nu ? (&rnu && v:relnum ? v:relnum : v:lnum) . ' ' : ''}",
            },
            {
                provider = "%{% &fdc ? '%C ' : '' %}",
            },
            -- {
            --     provider = function(self)
            --         return self.git_sign and self.git_sign.text
            --     end,
            --     hl = function(self)
            --         return self.git_sign and self.git_sign.texthl
            --     end,
            -- },
        }

        vim.o.laststatus = 3
        vim.o.showcmdloc = "statusline"
        -- vim.o.showtabline = 2

        require("heirline").setup({
            statusline = StatusLines,
            winbar = WinBar,
            tabline = TabLine,
            statuscolumn = Stc,
            opts = {
                disable_winbar_cb = function(args)
                    if vim.bo[args.buf].filetype == "neo-tree" then
                        return
                    end
                    return conditions.buffer_matches({
                        buftype = { "nofile", "prompt", "help", "quickfix" },
                        filetype = { "^git.*", "fugitive", "Trouble", "dashboard" },
                    }, args.buf)
                end,
                colors = setup_colors,
            },
        })

        vim.o.statuscolumn = require("heirline").eval_statuscolumn()

        vim.api.nvim_create_augroup("Heirline", { clear = true })

        vim.cmd([[au Heirline FileType * if index(['wipe', 'delete'], &bufhidden) >= 0 | set nobuflisted | endif]])

        -- vim.cmd("au BufWinEnter * if &bt != '' | setl stc= | endif")

        vim.api.nvim_create_autocmd("ColorScheme", {
            callback = function()
                utils.on_colorscheme(setup_colors)
            end,
            group = "Heirline",
        })
    end,
})

ui({
    "stevearc/dressing.nvim",
    init = function()
        ---@diagnostic disable-next-line: duplicate-set-field
        vim.ui.select = function(...)
            require("lazy").load({ plugins = { "dressing.nvim" } })
            return vim.ui.select(...)
        end
        ---@diagnostic disable-next-line: duplicate-set-field
        vim.ui.input = function(...)
            require("lazy").load({ plugins = { "dressing.nvim" } })
            return vim.ui.input(...)
        end
    end,
    opts = {
        input = {
            enabled = true,
            border = lambda.style.border.type_0,
            default_prompt = "➤ ",
            win_options = { wrap = true, winhighlight = "Normal:Normal,NormalNC:Normal" },
            prefer_width = 100,
            min_width = 20,
            title_pos = "center",
            get_config = function()
                if vim.api.nvim_win_get_width(0) < 50 then
                    return {
                        relative = "editor",
                    }
                end
            end,
        },
        select = {
            backend = { "fzf_lua", "builtin" },
            builtin = {
                border = lambda.style.border.type_0,
                min_height = 10,
                win_options = { winblend = 10 },
                mappings = { n = { ["q"] = "Close", ["<esc>"] = "Close" } },
            },
            get_config = function(opts)
                opts.prompt = opts.prompt and opts.prompt:gsub(":", "")
                if opts.kind == "codeaction" then
                    return {
                        backend = "fzf_lua",
                        fzf_lua = lambda.fzf.cursor_dropdown({
                            winopts = { title = opts.prompt },
                        }),
                    }
                end
                if opts.kind == "norg" then
                    return {
                        backend = "nui",
                        nui = {
                            position = "97%",
                            border = { style = rect },
                            min_width = vim.o.columns - 2,
                        },
                    }
                end
                return {
                    backend = "telescope",
                }
            end,
            nui = {
                min_height = 10,
                win_options = {
                    winhighlight = table.concat({
                        "Normal:Italic",
                        "FloatBorder:PickerBorder",
                        "FloatTitle:Title",
                        "CursorLine:Visual",
                    }, ","),
                },
            },
        },
    },
    config = function(_, opts)
        require("dressing").setup(opts)
        vim.keymap.set("n", "z=", function()
            local word = vim.fn.expand("<cword>")
            local suggestions = vim.fn.spellsuggest(word)
            vim.ui.select(
                suggestions,
                {},
                vim.schedule_wrap(function(selected)
                    if selected then
                        vim.cmd.normal({ args = { "ciw" .. selected }, bang = true })
                    end
                end)
            )
        end)
    end,
})
ui({ "MunifTanjim/nui.nvim", event = "VeryLazy", lazy = true })
--
-- --  ──────────────────────────────────────────────────────────────────────
-- -- Force Lazy
-- --  ──────────────────────────────────────────────────────────────────────
--
ui({
    "RRethy/vim-illuminate",
    lazy = true,
    cond = lambda.config.ui.use_illuminate,
    event = "VeryLazy",
    config = conf.illuminate,
})

--  ──────────────────────────────────────────────────────────────────────

ui({
    "nvim-tree/nvim-web-devicons",
    config = function()
        require("nvim-web-devicons").setup({
            override = {
                zsh = {
                    icon = "",
                    color = "#428850",
                    cterm_color = "65",
                    name = "Zsh",
                },
            },
            color_icons = true,
            default = true,
        })
    end,
})

ui({
    "nvim-neo-tree/neo-tree.nvim",
    event = "VeryLazy", -- No clue why, but this is required for my hydra to work o_o
    keys = {
        {
            "<leader>e",
            function()
                vim.cmd.Neotree("toggle")
            end,
            "NeoTree Focus Toggle",
        },
    },
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
        {
            -- only needed if you want to use the commands with "_with_window_picker" suffix
            "s1n7ax/nvim-window-picker",
            config = function()
                require("window-picker").setup({
                    hint = "floating-big-letter",
                    autoselect_one = true,
                    include_current = false,
                    filter_rules = {
                        bo = {
                            filetype = { "neo-tree-popup", "quickfix", "edgy", "neo-tree" },
                            buftype = { "terminal", "quickfix", "nofile" },
                        },
                    },
                })
            end,
        },
    },
    config = function()
        local symbols = require("lspkind").symbol_map
        local lsp_kinds = lambda.style.lsp.highlights

        require("neo-tree").setup({
            sources = { "filesystem", "git_status", "document_symbols" },
            source_selector = {
                winbar = true,
                separator_active = "",
                sources = {
                    { source = "filesystem" },
                    { source = "git_status" },
                    { source = "document_symbols" },
                },
            },
            enable_git_status = true,
            enable_normal_mode_for_inputs = true,
            git_status_async = true,
            nesting_rules = {
                ["dart"] = { "freezed.dart", "g.dart" },
                ["go"] = {
                    pattern = "(.*)%.go$",
                    files = { "%1_test.go" },
                },
                ["docker"] = {
                    pattern = "^dockerfile$",
                    ignore_case = true,
                    files = { ".dockerignore", "docker-compose.*", "dockerfile*" },
                },
            },
            event_handlers = {
                {
                    event = "neo_tree_buffer_enter",
                    handler = function()
                        highlight.set("Cursor", { blend = 100 })
                    end,
                },
                {
                    event = "neo_tree_popup_buffer_enter",
                    handler = function()
                        highlight.set("Cursor", { blend = 0 })
                    end,
                },
                {
                    event = "neo_tree_buffer_leave",
                    handler = function()
                        highlight.set("Cursor", { blend = 0 })
                    end,
                },
                {
                    event = "neo_tree_popup_buffer_leave",
                    handler = function()
                        highlight.set("Cursor", { blend = 100 })
                    end,
                },
                {
                    event = "neo_tree_window_after_close",
                    handler = function()
                        highlight.set("Cursor", { blend = 0 })
                    end,
                },
            },
            filesystem = {
                hijack_netrw_behavior = "open_current",
                use_libuv_file_watcher = true,
                group_empty_dirs = false,
                follow_current_file = {
                    enabled = true,
                    leave_dirs_open = true,
                },
                filtered_items = {
                    visible = true,
                    hide_dotfiles = false,
                    hide_gitignored = true,
                    never_show = { ".DS_Store" },
                },
                window = {
                    mappings = {
                        ["/"] = "noop",
                        ["g/"] = "fuzzy_finder",
                    },
                },
            },
            default_component_configs = {
                icon = { folder_empty = icons.documents.open_folder },
                name = { highlight_opened_files = true },
                document_symbols = {
                    follow_cursor = true,
                    kinds = vim.iter(symbols):fold({}, function(acc, k, v)
                        acc[k] = { icon = v, hl = lsp_kinds[k] }
                        return acc
                    end),
                },
                modified = { symbol = icons.misc.circle .. " " },
                git_status = {
                    symbols = {
                        added = icons.git.add,
                        deleted = icons.git.remove,
                        modified = icons.git.mod,
                        renamed = icons.git.rename,
                        untracked = icons.git.untracked,
                        ignored = icons.git.ignored,
                        unstaged = icons.git.unstaged,
                        staged = icons.git.staged,
                        conflict = icons.git.conflict,
                    },
                },
                file_size = {
                    required_width = 50,
                },
            },
            window = {
                mappings = {
                    ["o"] = "toggle_node",
                    ["<CR>"] = "open_with_window_picker",
                    ["<c-s>"] = "split_with_window_picker",
                    ["<c-v>"] = "vsplit_with_window_picker",
                    ["<esc>"] = "revert_preview",
                    ["P"] = { "toggle_preview", config = { use_float = false } },
                },
            },
        })
    end,
})
--
ui({
    "lukas-reineke/indent-blankline.nvim",
    lazy = true,
    cond = lambda.config.ui.indent_lines.use_indent_blankline,
    event = { "BufReadPost", "BufAdd", "BufNewFile" },
    opts = {
        filetype_exclude = {
            "glowpreview",
            "dbout",
            "neo-tree-popup",
            "log",
            "gitcommit",
            "txt",
            "help",
            "NvimTree",
            "git",
            "flutterToolsOutline",
            "undotree",
            "markdown",
            "norg",
            "org",
            "orgagenda",
            "neo-tree",
            "neo-tree-*",
            "help",
            "NvimTree",
            "Neotree",
            "vaffle",
        },
        buftype_exclude = { "terminal", "nofile", "NvimTree", "Neotree" },
        indent = {
            char = "│", -- ▏┆ ┊ 
            tab_char = "│",
        },
        scope = {
            char = "▎",
        },
    },
    config = function(_, opts)
        local highlight = {
            "RainbowRed",
            "RainbowYellow",
            "RainbowBlue",
            "RainbowOrange",
            "RainbowGreen",
            "RainbowViolet",
            "RainbowCyan",
        }
        local hooks = require("ibl.hooks")
        -- create the highlight groups in the highlight setup hook, so they are reset
        -- every time the colorscheme changes
        hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
            vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
            vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
            vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
            vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
            vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
            vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
            vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
        end)

        vim.g.rainbow_delimiters = { highlight = highlight }
        require("ibl").setup({ scope = { highlight = highlight } })

        hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
    end,
})
-- dropbar_menu
ui({
    "shell-Raining/hlchunk.nvim",
    cond = lambda.config.ui.indent_lines.use_hlchunk,
    event = { "UIEnter" },
    opts = {
        indent = {
            chars = { "│", "¦", "┆", "┊" }, -- more code can be found in https://unicodeplus.com/
        },
        chunk = {
            enable = true,
            use_treesitter = true,
            notify = true, -- notify if some situation(like disable chunk mod double time)
            exclude_filetypes = {
                glowpreview = true,
                harpoon = true,
                aerial = true,
                dropbar_menu = true,
                dashboard = true,
                sagaoutline = true,
                oil_preview = true,
                oil = true,
                ["neo-tree"] = true,
            },
        },
        blank = {
            enable = false,
        },
    },
})
--
ui({
    "levouh/tint.nvim",
    cond = lambda.config.ui.use_tint == "tint",
    event = "VeryLazy",
    opts = {
        tint = -15,
        highlight_ignore_patterns = {
            "WinSeparator",
            "St.*",
            "Comment",
            "Panel.*",
            "Telescope.*",
            "IndentBlankline.*",
            "Bqf.*",
            "VirtColumn",
            "Headline.*",
            "NeoTree.*",
            "LineNr",
            "NeoTree.*",
            "Telescope.*",
            "VisibleTab",
        },
        window_ignore_function = function(win_id)
            local win, buf = vim.wo[win_id], vim.bo[vim.api.nvim_win_get_buf(win_id)]
            if win.diff or not lambda.falsy(vim.fn.win_gettype(win_id)) then
                return true
            end
            local ignore_bt = lambda.p_table({ terminal = true, prompt = true, nofile = false })
            local ignore_ft = lambda.p_table({ ["Neogit.*"] = true, ["flutterTools.*"] = true, ["qf"] = true })
            return ignore_bt[buf.buftype] or ignore_ft[buf.filetype]
        end,
    },
})
--
ui({
    "kevinhwang91/promise-async",
    lazy = true,
})
ui({
    "luukvbaal/statuscol.nvim",
    cond = lambda.config.ui.use_statuscol,
    event = "UIEnter",
    config = function()
        local builtin = require("statuscol.builtin")
        require("statuscol").setup({
            ft_ignore = {
                "neotree",
                "OverseerList",
                "sagaoutline",
            }, -- lua table with filetypes for which 'statuscolumn' will be unset
            bt_ignore = {
                "nofile",
                "terminal",
            }, -- lua table with 'buftype' values for which 'statuscolumn' will be unset
            relculright = true,
            segments = {
                { text = { "%s" }, click = "v:lua.ScSa" },
                -- {
                --     --
                --
                --     -- Git Signs
                --     text = { "%s" },
                --     sign = { name = { "GitSigns" }, maxwidth = 1, colwidth = 1, auto = false },
                --     click = "v:lua.ScSa",
                -- },
                {
                    -- Line Numbers
                    text = { builtin.lnumfunc },
                    click = "v:lua.ScLa",
                },
                -- {
                --     -- Dap Breakpoints
                --     sign = {
                --         name = { "DapBreakpoint" },
                --         maxwidth = 1,
                --         colwidth = 1,
                --         auto = false,
                --         fillchars = "",
                --     },
                --     click = "v:lua.ScSa",
                -- },
                -- {
                --     -- Fold Markers
                --     text = { builtin.foldfunc },
                --     click = "v:lua.ScFa",
                -- },
                -- {
                --     -- Diagnostics
                --     sign = { name = { "Diagnostic" }, maxwidth = 1, colwidth = 1, auto = false, fillchars = "" },
                --     click = "v:lua.ScSa",
                -- },
                -- {
                --     -- All Other Signs
                --     sign = {
                --         name = { ".*" },
                --         fillchars = "",
                --
                --         auto = false,
                --     },
                --     click = "v:lua.ScSa",
                -- },

                { text = { "│" } },
            },
        })
    end,
})

ui({
    "kevinhwang91/nvim-ufo",
    lazy = true,
    cond = lambda.config.ui.use_ufo,
    event = "VeryLazy",
    dependencies = {
        "kevinhwang91/promise-async",
    },
    cmd = {
        "UfoAttach",
        "UfoDetach",
        "UfoEnable",
        "UfoDisable",
        "UfoInspect",
        "UfoEnableFold",
        "UfoDisableFold",
    },
    keys = {
        {
            "zR",
            function()
                require("ufo").openAllFolds()
            end,
            desc = "ufo: open all folds",
        },
        {
            "zM",
            function()
                require("ufo").closeAllFolds()
            end,
        },
        {
            "zr",
            function()
                require("ufo").openFoldsExceptKinds()
            end,
            desc = "ufo: open folds except kinds",
        },
        {
            "zm",
            function()
                require("ufo").closeFoldsWith()
            end,
            desc = "ufo: close folds with",
        },
    },
    config = conf.ufo,
})

ui({
    "Vonr/foldcus.nvim",
    lazy = true,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = "VeryLazy",
    cmd = { "Foldcus", "Unfoldcus" },
    config = conf.fold_focus,
})
ui({
    "jghauser/fold-cycle.nvim",
    event = "VeryLazy",
    config = true,
    keys = {
        {
            "<BS>",
            function()
                require("fold-cycle").open()
            end,
            desc = "fold-cycle: toggle",
            silent = true,
        },
        {
            "<C-BS>",
            function()
                require("fold-cycle").close()
            end,
            desc = "fold-cycle: toggle",
            silent = true,
        },
        {
            "zC",
            function()
                require("fold-cycle").close_all()
            end,
            desc = "fold-cycle: Close all ",
            remap = true,
        },
    },
})
ui({
    "uga-rosa/ccc.nvim",
    cmd = { "CccHighlighterToggle" },
    opts = function()
        local ccc = require("ccc")
        local p = ccc.picker
        p.hex.pattern = {
            [=[\v%(^|[^[:keyword:]])\zs#(\x\x)(\x\x)(\x\x)>]=],
            [=[\v%(^|[^[:keyword:]])\zs#(\x\x)(\x\x)(\x\x)(\x\x)>]=],
        }
        ccc.setup({
            win_opts = { border = lambda.style.border.type_0 },
            pickers = { p.hex, p.css_rgb, p.css_hsl, p.css_hwb, p.css_lab, p.css_lch, p.css_oklab, p.css_oklch },
            highlighter = {
                auto_enable = true,
                excludes = { "dart", "lazy", "orgagenda", "org", "NeogitStatus", "toggleterm" },
            },
        })
    end,
})
--  TODO: (vsedov) (13:12:54 - 30/05/23):@ Temp disable, want to test out akinshos autocmds,
--  i wonder if they are any better that what ive had before
ui({
    "glepnir/hlsearch.nvim",
    cond = lambda.config.ui.use_hlsearch,
    event = "CursorHold",
    config = true,
})
--
ui({
    "kevinhwang91/nvim-hlslens",
    cond = lambda.config.ui.use_hlslens,
    lazy = true,
    config = true,
    event = "VeryLazy",
})
--

ui({
    "yaocccc/nvim-foldsign",
    cond = true,
    event = "CursorHold",
    config = true,
})

ui({
    "karb94/neoscroll.nvim", -- NOTE: alternative: 'declancm/cinnamon.nvim'
    cond = lambda.config.ui.scroll_bar.use_scroll,
    event = "VeryLazy",
    config = function()
        require("neoscroll").setup({
            -- All these keys will be mapped to their corresponding default scrolling animation
            --mappings = {'<C-u>', '<C-d>', '<C-b>', '<C-f>',
            mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>" },
            hide_cursor = true, -- Hide cursor while scrolling
            stop_eof = false, -- Stop at <EOF> when scrolling downwards
            -- use_local_scrolloff = false, -- Use the local scope of scrolloff instead of the global scope
            -- respect_scrolloff = true, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
            -- cursor_scrolls_alone = false, -- The cursor will keep on scrolling even if the window cannot scroll further
        })
    end,
})

ui({
    "mvllow/modes.nvim",
    cond = false,
    event = "VeryLazy",
    config = true,
})
