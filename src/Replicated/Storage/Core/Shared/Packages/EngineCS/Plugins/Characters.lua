--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Components = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Components)
local Entities =  require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Entities)
local Systems =  require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Systems)
local Hooks = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Tools.Hooks)
local Input = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Tools.Input)
local MessageBus = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Tools.MessageBus)

local Types = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Types)

local System = Systems.new("Heartbeat", script.Name, 3)

local PlayerComponent: Types.ComponentWithType<Player> = Components.get("Player")
local CharacterComponent: Types.ComponentWithType<{
    Character: Model,
    CharacterAdded: RBXScriptConnection,
    CharacterRemoving: RBXScriptConnection,
}> = Components.new("Character")

local CharacterComponentQueue = MessageBus.new("CharacterComponent")



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
        setRespawning(player, true)
        Entities:give(playerEntity, {
            [CharacterComponent] = {
                ["Character"] = player.Character :: Model,

                ["CharacterRemoving"] = player.CharacterRemoving:Once(function(): ()
                    setRespawning(player, true)
                    Entities:rid(playerEntity, CharacterComponent)
                end)
            }
        })

        setRespawning(player, false)
    end
end

--[[ Update ]]

Systems:on_update(System, function(world: Types.World)
    for playerEntity: Types.Entity, player: Player in world:query(PlayerComponent):without(CharacterComponent):iter() do
        if player.Character then
            createCharacterComponentFor(playerEntity, player)
        end
    end
end)

return System