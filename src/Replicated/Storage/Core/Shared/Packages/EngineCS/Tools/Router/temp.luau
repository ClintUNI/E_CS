
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Settings = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Settings)

local isServer = Settings.Game.IsServer

local module = {}

local hashOfNames = {}

local remoteEvents = {}

local reliableEvents = {}

local remoteFunctions = {}

local function createEvent(e: "Remote" | "Unreliable" | "RemoteFunction", name: string)
    assert(hashOfNames[name] == true, "Network events cannot both share the same name.")
    local eventClassName = if (e == "Remote") then "RemoteEvent" elseif (e == "Unreliable") then "UnreliableRemoteEvent" else e
    local newEvent = Instance.new(eventClassName)
    newEvent.Name = name
    hashOfNames[name] = true
    table.insert(remoteEvents, newEvent)
    newEvent.Parent = ReplicatedStorage

    return newEvent
end

local function getEvent(name: string)
    assert(hashOfNames[name] == true, "In order to get a network event, it must first be created.")

    return ReplicatedStorage:FindFirstChild(name)
end

local send;

if isServer then
    send = function(networkName: string, ...)
        local package: {any} = { ... }
        local fireAll: boolean = not (typeof(package[1]) == "Player")

        local e: CustomEvent = getEvent(networkName)

        if fireAll then
            e:FireAllClients(...)
        elseif typeof(e) == "RemoteFunction" then
            e:InvokeClient(...)
        else
            e:FireCleint(...)
        end
    end
else
    send = function(networkName: string, ...)
        local package: {any} = { ... }

        local e: CustomEvent = getEvent(networkName)

        if typeof(e) == "RemoteFunction" then
            e:Invoke(...)
        else
            e:Fire(...)
        end
    end
end


local recieve = function()
    --recieve invoked functions, and normal remote events
end

return {
    send = send :: (networkName: string, ...any) -> () 
        | (networkName: string, player: Player, ...any) -> ()
            | (networkName: string, ...any) -> (boolean),
    recieve = recieve,
}