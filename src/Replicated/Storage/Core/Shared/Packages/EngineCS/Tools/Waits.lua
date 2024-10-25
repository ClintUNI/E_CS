--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ECS = require(script.Parent.ECS)
local Components = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Components)
local Entities = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Entities)
local Types = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Types)

local CooldownFor = Entities.tag("Waiting")
local CooldownComponent: Types.ComponentWithType<number>  = Components.new("Waits")

local waitTimeCache = {}

--[[
    ```lua
    local fiveSeconds = Waits(5)

    --Inside a system on_update callback
    for entity: Types.Entity, _: any in world:query(_):without(Waits(fiveSeconds)):iter() do
        Waits(entity, fiveSeconds)

        print(_)
    end
    ```
]]
local module = {}

--[[
    @param entity : `Types.Entity` The host which the wait entity will be related to.
    @param waitEntity : `Types.Entity` The entity which will be used to track time in the relationship with the host.

    Give an entity a specific type of wait entity usable by each different system. \
    Most useful for use in querying the world for entities, for example, without cool downs.
    Here is an example.

    ```lua
    local fiveSeconds = Waits(5)

    --Inside a system on_update callback
    for entity: Types.Entity, _: any in world:query(_):without(Waits(fiveSeconds)):iter() do
        Waits(entity, fiveSeconds)

        print(_)
    end
    --
    ```
]]
function module:give(entity: Types.Entity, waitEntity: Types.Entity): ()
    Entities:give(waitEntity, {
        [CooldownComponent] = waitTimeCache[waitEntity],
    })
    Entities:give(entity, {[ self.pair(waitEntity) ] = Entities.NULL})
end

function module.DeltaTime(set: number?): (number)
    if set then
        module.__DeltaTime = set
    end

    return module.__DeltaTime
end

function module.pair(waitEntity: Types.Entity)
    return ECS.pair(CooldownFor, waitEntity)
end

function module.tag()
    return CooldownFor
end

function module.component()
    return CooldownComponent
end

module.__DeltaTime = 0

return setmetatable(module, {
    __call = function(self, waitTime: number)
        local e = Entities.new("Wait")
        waitTimeCache[e] = waitTime

        return e
    end
})