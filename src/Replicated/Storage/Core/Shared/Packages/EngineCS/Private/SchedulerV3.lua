local ReplicatedStorage = game:GetService("ReplicatedStorage")
local runservice = game:GetService("RunService")

local root = script.Parent.Parent
local Settings = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Settings)
local Systems = require(root.Systems)
local Worlds = require(root.Worlds)


local scheduler = {}

type Service = { [number]: ModuleScript }

local cache = {
    ModuleScripts = {} :: { [number]: { [number]: ModuleScript } },
    Events = {}
}

function scheduler:service(service: { [number]: ModuleScript })
    table.insert(cache.ModuleScripts, service)
end

function scheduler:services(services: { [number]: { [number]: ModuleScript } })
    for runPriority: number, service: Service in ipairs(services) do
        scheduler:service(service)
    end
end

function scheduler:require()
    local required = {
        ["Heartbeat"] = {},
        ["RenderStepped"] = {}
    }

    for _: number, service: { [number]: ModuleScript } in cache.ModuleScripts do
        for _, moduleScript in service do
            local system = require(moduleScript)

            if not required[system.Event] then
                required[system.Event] = {}
            end
            if not required[system.Event][system.Priority] then
                required[system.Event][system.Priority] = {}
            end

            table.insert(required[system.Event][system.Priority], { system = system.Update, event = system.Event, priority = system.Priority })
        end
    end

    local sorted = {}
    for event, services in required do
        sorted[event] = {}
        for serviceRunPriority: number, service in services do
            for sysRunPriority: number, system in service do
                table.insert(sorted[event], system)
            end
        end
    end

    cache.Events = {
        ["Heartbeat"] = sorted["Heartbeat"],
        ["RenderStepped"] = sorted["RenderStepped"]
    }
end

function scheduler:start()
    local events = {
        Heartbeat = runservice.Heartbeat,
        RenderStepped = if Settings.Game.IsServer then nil else runservice.RenderStepped
    }
    Worlds.Loop:begin(events)

    for eventName, _ in events do
        local systems = cache.Events[eventName]

        Worlds.Loop:scheduleSystems(systems)
    end
end

return scheduler