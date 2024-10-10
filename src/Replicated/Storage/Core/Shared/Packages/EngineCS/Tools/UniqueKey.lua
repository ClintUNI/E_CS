--!strict
local HttpService = game:GetService("HttpService")
local uk = {}

local uniqueKeys = {}

function uk.create()
    local key = HttpService:GenerateGUID()

    if not table.find(uniqueKeys, key) then
        table.insert(uniqueKeys, key)
        return key
    else
        return uk.create()
    end
end

return uk