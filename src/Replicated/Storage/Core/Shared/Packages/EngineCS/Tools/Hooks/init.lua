--!strict
local debugMode = _G.E_DEBUG

local data = setmetatable({
    Listeners = {},
    SetCommands = {}
}, {})
local listenersObject = setmetatable({
    ["_"] = data,
    set = function(self, key: string, newValue: any): ()
        if not data.SetCommands[key] then
            data.SetCommands[key] = { }
        end
        table.insert(data.SetCommands[key], {Key = key, NewValue = newValue})
    end,

    listen = function(key: string, callback: (lastValue: any, newValue: any) -> ())
        print(key)
        local index: number = 1
        if data.Listeners[key] then
            index = table.insert(data.Listeners[key], callback)
        else
            if debugMode then
                warn("Creating hook", key)
            end
            data.Listeners[key] = { callback }
        end

        return {
            disconnect = function()
                table.remove(data.Listeners[key], index)
            end
        }
    end
}, {
    __newindex = function(self, index, value)
        rawset(self, index, value)
    end,
})

return listenersObject