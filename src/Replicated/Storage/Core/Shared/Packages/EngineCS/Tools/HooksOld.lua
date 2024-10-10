--!strict
local listeners = {}
return setmetatable({
    shouldHook = true,


    set = function(self: typeof(setmetatable({}, {})), key: string, newValue: any)
        if key == "set" or key == "listen" then return end
        self["Last_" .. key] = self[key]
        self[key] = newValue
        

        for _, listener in listeners[key] or {} do
            listener(newValue)
        end
    end,

    listen = function(key: string, callback: (newValue: any) -> ())
        local index: number = 1
        if listeners[key] then
            index = table.insert(listeners[key], callback)
        else
            listeners[key] = { callback }
        end

        return {
            keyString = key,
            keyIndex = index,
            disconnect = function(self)
                table.remove(listeners[self.keyString], self.keyIndex)
            end
        }
    end
}, {
    __newindex = function(self, index, value)
        rawset(self, index, value)
    end,
})