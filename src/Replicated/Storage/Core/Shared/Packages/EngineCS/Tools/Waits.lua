--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ECS = require(script.Parent.ECS)
local Components = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Components)
local Entities = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Entities)
local Types = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Types)


local WaitsComponent: Types.ComponentWithType<number>  = Components.new("Waits")



local module = {}

function module.new()
    return Entities.new("Wait")
end

function module.give(entity: Types.Entity, waitEntity: Types.Entity, timeToWait: number)
    Entities:give(entity, {[ECS.pair(WaitsComponent, waitEntity)] = timeToWait})
end

--[[
    @param world : ```Types.World```

    Internally used by the Wait system to decrementally reduce each waiting time using the current frame's delta time. \
    Uses WaitsComponent and Wildcard to find related Wait entities and their 'host' entity. \
    Hopefully this works... 
]]
function module.__GetWaitingEntities(world: Types.World)
    return  -- Entity, WaitEntity?
end

function module.check(waitEntity: Types.Entity)
    return ECS.pair(WaitsComponent, waitEntity)
end

return setmetatable(module, {
    __call = function(self, waitEntity)
        return ECS.pair(WaitsComponent, waitEntity)
    end
})