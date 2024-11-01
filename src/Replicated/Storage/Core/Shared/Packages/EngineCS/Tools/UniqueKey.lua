--!strict
local HttpService = game:GetService("HttpService")
local uk = {}

local uniqueKeys = {}

--[[
    Creates and stores a unique key before returning it.

    There were reports of standard GenerateGUID() sometimes returning repeats, \ 
    hence this wrapper.

    @return string
]]
function uk.create(): string
    local key: string = HttpService:GenerateGUID()

    if not table.find(uniqueKeys, key) then
        table.insert(uniqueKeys, key)
        return key
    else
        return uk.create()
    end
end

return uk