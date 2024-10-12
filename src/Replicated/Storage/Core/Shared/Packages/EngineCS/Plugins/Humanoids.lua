--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Components = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Components)
local Entities =  require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Entities)
local Systems =  require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Systems)

local Types = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Types)

local System = Systems.new("Heartbeat", script.Name, 4)

local CharacterComponent: Types.ComponentWithType<Model> = Components.new("Character")
local HumanoidComponent: Types.ComponentWithType<Humanoid> = Components.new("Humanoid")

--[[ Update ]]

Systems:on_update(System, function(world: Types.World)
    for playerEntity: Types.Entity, character: Model in world:query(CharacterComponent):without(HumanoidComponent):iter() do
        print("hia char without humanoid")
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            Entities:give(playerEntity, {[HumanoidComponent] = humanoid})
        end
    end
end)

return System