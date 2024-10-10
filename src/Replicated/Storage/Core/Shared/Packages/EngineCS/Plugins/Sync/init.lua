--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Components = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Components)
local Settings = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Settings)
local Systems = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Systems)
local Types = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Types)

local EntityMap = require(script.EntityMap)
local RemoteEvents = require(script.RemoteEvents)

local SyncComponent = Components.new("Sync")

local system = Systems.new("Heartbeat", "Sync", 1)

do
    if Settings.Game.IsServer then
        
    else
        RemoteEvents.Transform.OnClientEvent:Connect(function()

        end)
    end
end

Systems:on_update(system, function(world: Types.World)
    --take data from an entities sync component, network it across the network and then remove the component.
end)


--! replaced

return system