--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local E_CS = ReplicatedStorage.Core.Shared.Packages.EngineCS

local Types = require(E_CS.Types)
local Alert = require(E_CS.Alert)

local MessageBus = require(E_CS.Tools.MessageBus) :: Types.MessageBus
local UniqueKey = require(E_CS.Tools.UniqueKey)

Alert.Unstable("[Middleware]")

local middleware = {}


function middleware.scoped(): ((<a...>(a...) -> boolean)?) -> ()

    local messageBus: number = MessageBus.new(UniqueKey.create())
    local queueMiddleware: ((<a...>(a...) -> boolean)?) -> (); queueMiddleware = function(callback: (<a...>(a...) -> boolean)?)
        if callback then
            MessageBus.queue(messageBus, callback)
            return
        else
            return MessageBus.read(messageBus)
        end
    end

    return queueMiddleware
end

return middleware