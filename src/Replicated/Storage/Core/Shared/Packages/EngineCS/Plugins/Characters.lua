--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Components = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Components)
local Entities =  require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Entities)
local Systems =  require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Systems)
local Hooks = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Tools.Hooks)
local Input = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Tools.Input)
local MessageBus = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Tools.MessageBus)
local Network = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Tools.Network)
local Types = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Types)

local System = Systems.new("Heartbeat", script.Name, 3)

local PlayerComponent: Types.ComponentWithType<Player> = Components.get("Player")
local CharacterComponent: Types.ComponentWithType<{
    Character: Model,
    CharacterAdded: RBXScriptConnection,
    CharacterRemoving: RBXScriptConnection,
}> = Components.new("Character")

local CharacterComponentQueue = MessageBus.new("CharacterComponent")

local event = Network.new("Networking")

--[[ Setup ]]

do
    function setRespawning(player: Player, status: boolean)
        if status then
            Entities:tag({player}, "Respawning")
        else
            Entities:untag({player}, "Respawning")
        end
    end

    function createCharacterComponentFor(playerEntity: Types.Entity, player: Player)
        Entities:give(playerEntity, {
            [CharacterComponent] = {
                ["Character"] = player.Character :: Model,

                ["CharacterAdded"] = player.CharacterAdded:Connect(function(character: Model)
                    Entities:insert(playerEntity, CharacterComponent, { 
                        ["Character"] = character 
                    })
                    setRespawning(player, false)
                end),

                ["CharacterRemoving"] = player.CharacterRemoving:Connect(function()
                    setRespawning(player, true)
                end)
            }
        })
    end
end

--[[ Update ]]

Systems:on_update(System, function(world: Types.World)
    for playerEntity: Types.Entity, player: Player in world:query(PlayerComponent):without(CharacterComponent):iter() do
        createCharacterComponentFor(playerEntity, player)
    end
end)

return System