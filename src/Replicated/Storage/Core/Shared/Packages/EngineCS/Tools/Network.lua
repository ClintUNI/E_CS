--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Byteblox = require(ReplicatedStorage.Core.Shared.Packages.Byteblox)
local MessageBus = require(script.Parent.MessageBus)
local Settings = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Settings)

print("pre Warp")

task.spawn(function()
    local Bytenet = Byteblox
    Bytenet:
    local Warp = require(ReplicatedStorage.Core.Shared.Packages.Warp)

    print("post task spawn")
end)

local Warp = require(ReplicatedStorage.Core.Shared.Packages.Warp)

print("post warp")

local NetworkEventCallbacksQueue = MessageBus.new("Network")

local remoteClient = if Settings.Game.IsServer then Warp.Client("Network") else nil
local remoteServer = if Settings.Game.IsServer then Warp.Server("Network") else nil

local networkEventsDataByIndexes = {}
local networkEventsByName = {}
local networkEventIndexesAndCallbacks = {} :: { [number]: {(any) -> ()} }

local eventCreationIndex = 999

local module = {}

function module.new(name: string): number
    print(name)
    if networkEventsByName[name] then
        return networkEventsByName[name]
    else
        table.insert(networkEventsDataByIndexes, name)
        networkEventsByName[name] = #networkEventsDataByIndexes
        networkEventIndexesAndCallbacks[#networkEventsDataByIndexes] = {}
        module.emit(eventCreationIndex, true, name)
        return #networkEventsDataByIndexes
    end
end

function module.emit(event: number, reliable: boolean, ...: any)
    print(networkEventsDataByIndexes)
    if remoteClient then
        remoteClient:Fire(reliable, event, ...)
    elseif remoteServer then
        remoteServer:Fires(reliable, event, ...)
    end
end

local function recieve(event: number, ...: any)
    print(event)
    if event == eventCreationIndex then
        module.new(...)

        return
    end

    MessageBus.queue(NetworkEventCallbacksQueue, networkEventIndexesAndCallbacks[event], ...)

    -- for _, callback: (any) -> () in networkEventIndexesAndCallbacks[event] do
    --     callback(...)
    -- end
end

local function recieveServer(player: Player, event: number, ...: any)
    recieve(event, player, ...) --TODO change later
end

print("network")

if remoteClient then
    remoteClient:Connect(recieve)
elseif remoteServer then
    remoteServer:Connect(recieveServer)
end

return module
