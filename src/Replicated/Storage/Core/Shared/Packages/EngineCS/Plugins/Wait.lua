local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Components = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Components)
local Entities = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Entities)
local Systems = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Systems)
local ECS = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Tools.ECS)
local Waits = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Tools.Waits)
local Types = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Types)

local system = Systems.new("Heartbeat", script.Name, 1)

local CooldownComponent: Types.ComponentWithType<number> = Components.new("Cooldown")
local CooldownFor = Entities.tag("CooldownFor")

local oS: typeof(os) = os

local lastFrameClock: number;
local deltaTime: number = 0

Systems:on_update(system, function(world: Types.World): ()
    local currentFrameClock: number = oS.clock()
    deltaTime = currentFrameClock - (lastFrameClock or currentFrameClock)
    lastFrameClock = currentFrameClock

    Waits.DeltaTime(deltaTime)

    for waitEntity: Types.Entity, timeToWait: number in world:query(CooldownComponent):iter() do
        local waitTarget = world:target(waitEntity, CooldownFor)
        print(waitTarget, waitEntity, timeToWait)
        if timeToWait - deltaTime > 0 then
            Entities:give(waitEntity, { [CooldownComponent] = timeToWait - deltaTime })
        else
            error('removed')
            Entities:rid(waitTarget, Waits.pair(waitEntity))
        end

        --//
    end

    --/
end)


return system