local debug_mode = _G.E_DEBUG

local module = {}

function module.warn(...): ()
    if debug_mode then
        warn("\n", ..., "\n")
    end
end

--[[
    TODO: Add else statement.
]]
function module.warnIf(conditional, ...): ()
    if debug_mode then
        if conditional then
            warn("\n", ...)
        end
    end
end

return module