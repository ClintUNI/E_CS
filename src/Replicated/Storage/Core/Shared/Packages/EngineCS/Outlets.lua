--!strict
local module = {
    __connected = false
}

local cache = {} :: { [RBXScriptSignal]: {(any) -> ()} }
local connections: { RBXScriptSignal: RBXScriptConnection }  = {} :: { RBXScriptSignal: RBXScriptConnection } 

--[[
    Cannot be individually disconnected, look into Signals for that.
]]
function module:plug<T>(event: RBXScriptSignal, callback: (T) -> ())
    if not cache[event] then
        cache[event] = {}
    end

    table.insert(cache[event], callback)
end

function module:start(): { RBXScriptSignal: RBXScriptConnection }
    self.__connected = true

    for event: RBXScriptSignal, callbacks in cache do
        connections[event] = event:Connect(function()
            for _, callback in callbacks do
                callback()
            end
        end)
    end

    return connections
end

return module