local Components = require(script.Parent.Components)
local Entities = require(script.Parent.Entities)
local Types = require(script.Parent.Types)
local Creation = require(script.Schematics.Creation)
local Declaration = require(script.Schematics.Declaration)

return {
    Declaration = Declaration,
    Creation = Creation,

    Get = {
        Property = Components.get,

        Field = Entities.tag,

        Flag = Entities.tag,

        Type = function(name: string): Types.Entity
        return Entities.tag(name:upper())
    end
    },

}
