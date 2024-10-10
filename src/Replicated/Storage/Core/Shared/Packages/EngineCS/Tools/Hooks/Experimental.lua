--!strict

local function ted()
    return setmetatable({
        values = {},
        callbacks = {}
    }, {___newindex = function(self, value, key)
        if value == "value" then
            self.values[key.Key] = key.Value
        else
            self.values[value] = key
        end
    end,
    __newindex = function(self, searchParams: { Key: string, Value: any? }, callback: (any) -> ()?)
        assert(typeof(searchParams) == "table", "Reactive indexing requires a dictionary key.")
        if searchParams.Value then
            self.values[searchParams.Key] = searchParams.Value
            return callback and callback(searchParams.Value)
        end
        return self.values[searchParams.Key]
    end
})
end

local teddy = ted() :: typeof(ted()) & typeof(setmetatable({} :: {  value: { ["Key"]: string, ["Value"]: number } }, {}) )



local updateWhenTreeGrows = function(newGrowth: number)
    print(newGrowth)
end

teddy.value[ { ["Key"] = "Tree", ["Value"] = 2 } ] = updateWhenTreeGrows