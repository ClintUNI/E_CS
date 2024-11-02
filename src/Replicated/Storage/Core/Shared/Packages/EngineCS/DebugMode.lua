local debug_mode = _G.E_DEBUG

local module = {}

function module.warn(...)
    if debug_mode then
        warn("\n", ..., "\n")
    end
end

function module.warnIf(conditional, ...)
    if debug_mode and conditional then
        warn("\n", ...)
    end
end

return module