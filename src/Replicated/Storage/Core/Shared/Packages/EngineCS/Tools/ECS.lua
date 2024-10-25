--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Types = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Types)
local JECS = require(ReplicatedStorage.Core.Shared.Packages.JECS)
local jecsUtilities = {
    pair = JECS.pair :: (pred: number | Types.Component, obj: number | Types.Entity) -> number & Types.Entity,
    is_pair = JECS.IS_PAIR,
    OnAdd = JECS.OnAdd,
    OnRemove = JECS.OnRemove,
    OnSet = JECS.OnSet,
    OnDeleteTarget = JECS.OnDeleteTarget,
    Delete = JECS.Delete,
    Remove = JECS.Remove,
    Wildcard = JECS.Wildcard,
    Name = JECS.Name,
    Rest = JECS.Rest,
    ChildOf = JECS.ChildOf,
    _W = JECS.w
}

return jecsUtilities :: typeof(jecsUtilities)