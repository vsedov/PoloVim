KM = {}

KM.genleader = function(leader, f)
    if f == nil then
        local function ret(s)
            return table.concat({ leader, s })
        end

        return ret
    else
        local function ret(s)
            return table.concat(f({ leader, s }))
        end

        return ret
    end
end

local special = function(t)
    return { "<", t[1], "-", t[2], ">" }
end

KM.leader = KM.genleader("<Leader>")
KM.localleader = KM.genleader("<LocalLeader>")
KM.l1leader = KM.genleader(";")
KM.l2leader = KM.genleader("_")

KM.ctrl = KM.genleader("c", special)
KM.alt = KM.genleader("a", special)
KM.shift = KM.genleader("s", special)

function KM.extendleader(f, k)
    return KM.genleader(f(k))
end

function KM.extendlocalleader(k)
    return KM.genleader(KM.localleader(k))
end

function KM.keymap(mode, lhs, rhs, opts, desc)
    if desc ~= nil then
        opts.desc = desc
    end
    vim.keymap.set(mode, lhs, rhs, opts)
end

function KM.rhs_surrounder(lhs, rhs)
    return function(s)
        return table.concat({ lhs, s, rhs })
    end
end

KM.cmd = KM.genleader("", "")
KM.cmd_cr = KM.rhs_surrounder("<cmd>", "<cr>")
KM.luacmd = KM.rhs_surrounder("<cmd>lua ", "<cr>")
KM.cr = KM.genleader(":", "<CR>")

KM.plugmapping = KM.genleader("<Plug>")
KM.args = KM.rhs_surrounder(":", "<Space>")
KM.cu = KM.rhs_surrounder(":<C-u>", "<CR>")

function plan_binds(plan, t)
    if t == nil then
        return plan or {}
    end
end

function KM.setup(plan, f)
    if f == nil then
        for _, value in pairs(plan) do
            KM.keymap(table.unpack(value))
        end
    else
        KM.setup(f(plan))
    end
end

return KM
