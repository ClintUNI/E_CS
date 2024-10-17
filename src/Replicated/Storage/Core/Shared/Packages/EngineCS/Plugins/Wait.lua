local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Components = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Components)
local Entities = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Entities)
local Systems = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Systems)
local ECS = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Tools.ECS)
local Waits = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Tools.Waits)
local Types = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Types)

local system = Systems.new("Heartbeat", script.Name, 1)

local PlayerComponent: Types.ComponentWithType<Player> = Components.new("Player")
local WaitsComponent: Types.ComponentWithType<number> = Components.new("Waits")

local wait5Seconds = Waits.new()

local os: typeof(os) = os

local lastFrameTime: number;
local deltaTime: number = 0

Systems:on_update(system, function(world: Types.World)
    local currentFrameTime: number = os.clock()
    deltaTime = currentFrameTime - (lastFrameTime or currentFrameTime)
    lastFrameTime = currentFrameTime

    for playerEntity: Types.Entity, player: Player in world:query(PlayerComponent):without(Waits(wait5Seconds)):iter() do
        Waits.give(playerEntity, wait5Seconds, 5)

        print(player)
    end


    for pairId: Types.Entity in world:query(ECS.pair(WaitsComponent, ECS.Wildcard)):iter() do
        local pairedWait = world:target(pairId, WaitsComponent)
        local waitPair = ECS.pair(WaitsComponent, pairedWait)
        for host: Types.Entity in world:query(waitPair):iter() do
            local timeToWait: number = world:get(host, waitPair) or 0

            if timeToWait - deltaTime > 0 then
                Entities:give(host, { [waitPair] = timeToWait - deltaTime })
            else
                Entities:rid(host, waitPair)
            end
        end
    end

    -- for entity: Types.Entity, amountToWait: number in world:query(WaitComponent):iter() do
    --     local newTimeToWait: number = amountToWait - deltaTime

    --     if newTimeToWait <= 0 then
    --         Entities:rid(WaitComponent, entity)
    --     else
    --         Entities:give(WaitComponent, {
    --             [entity] = newTimeToWait
    --         })
    --     end
    -- end
end)


return system