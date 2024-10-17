--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Types = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Types)
local JECS = require(ReplicatedStorage.Core.Shared.Packages.JECS)
local jecsUtilities = {
    pair = JECS.pair :: <R, T>(pred: number & { __T: R }, obj: number & { __T: T }) -> number & Types.Component,
    OnAdd = JECS.OnAdd,
    OnRemove = JECS.OnRemove,
    OnSet = JECS.OnSet,
    OnDeleteTarget = JECS.OnDeleteTarget,
    Wildcard = JECS.Wildcard,
    Tag = JECS.Tag,
    Rest = JECS.Rest,
    ChildOf = JECS.ChildOf,
    _W = JECS.w
}

return jecsUtilities :: typeof(jecsUtilities)