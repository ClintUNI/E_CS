--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Settings = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Settings)

local EVENT_NAME: string = "Transform"
local PATH_TO_EVENTS_FOLDER: Folder = ReplicatedStorage.Core.Shared.Events

local module = {}

if Settings.Game.IsServer then
    module.Transform = Instance.new("RemoteEvent")
    module.Transform.Name = EVENT_NAME
    module.Transform.Parent = PATH_TO_EVENTS_FOLDER
else
    local remoteEvent = PATH_TO_EVENTS_FOLDER:WaitForChild(EVENT_NAME, 60)

    if remoteEvent and typeof(remoteEvent) == "RemoteEvent" then
        module.Transform = remoteEvent
    else
        warn("The client was unable to locate the", EVENT_NAME, "remote event.")
    end
end

return module :: { Transform: RemoteEvent }