local Loop = require(script.Parent.Private.Loop)
local JECS = require(script.Parent.Parent.JECS)

local module = {} :: { World: JECS.World, Loop: Loop.Loopable, new: (...any) -> () }

function module.new(...)
    module.World = JECS.World.new()
    module.Loop = Loop.new(module.World, ...)
    return module.World
end

function module.get()
    return module.World
end

function module.loop()
    return module.Loop
end

return module 