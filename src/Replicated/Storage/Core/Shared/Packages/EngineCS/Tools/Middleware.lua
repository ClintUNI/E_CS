--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Types = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Types)
local MessageBus = require(script.Parent.MessageBus) :: Types.MessageBus
local UniqueKey = require(script.Parent.UniqueKey)


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