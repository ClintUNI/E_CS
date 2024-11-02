--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Alerts = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Alerts)
local Settings = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Settings)
local module = {}

local remoteFunction = Instance.new("RemoteFunction")
remoteFunction.Parent = ReplicatedStorage
remoteFunction.Name = "__Router"

Alerts.Unstable("[Router]")

local domains = {}

local domainNamesAndIds = {}

function module:register(domainName: string, register: () -> ({ [string]: { (Player) -> () } })): number
    table.insert(domains, register())
    domainNamesAndIds[#domains] = domainName

    return #domains
end

local function recieveServer(player: Player, domainId, route: string, ...)
    local s, e = pcall(function(...)  
        assert(route, "Route was not passed to the server.")
        assert(domains[domainId], "Domain does not exist on the server.")
        local domain = domains[domainId]
        for _, callbacks in domain[route] do
            callbacks(player, ...)
        end
    end)
    
    if e then
        warn(player, domainId, route, "had", e)
    end

    return s
end

local function recieveClient(domainId: number, route: string, ...)
    
end

local c
local function reg()
    if Settings.Game.IsServer then
        remoteFunction.OnServerInvoke = recieveServer
    else
        remoteFunction.OnClientInvoke = recieveClient
    end
end

return module