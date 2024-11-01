local Components = require(script.Parent.Components)
local Entities = require(script.Parent.Entities)
local SchematicMethods = require(script.SchematicMethods)

return {
    Create = SchematicMethods.create,
    New = SchematicMethods.new,
    Set = SchematicMethods.set,
    Class = SchematicMethods.getClassIdFromName,
    Entity = SchematicMethods.entity,
    Is = SchematicMethods.is,
    Identify = SchematicMethods.identify,
    Super = SchematicMethods.super,
    With = SchematicMethods.with,
    Props = SchematicMethods.props :: SchematicMethods.Props,
    WithProps = SchematicMethods.with :: (propList: {[string]: any}) -> (),

    Get = {
        Property = Components.get,

        Field = Entities.tag,

        Flag = Entities.tag,

        Type = SchematicMethods.classType,
    },

}
