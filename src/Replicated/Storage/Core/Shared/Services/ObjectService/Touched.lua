local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Components = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Components)
local Entities = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Entities)
local Systems = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Systems)
local Types = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Types)

local System = Systems.new("Heartbeat", script.Name, 4)

local CharacterComponent: Types.ComponentWithType<Model> = Components.new("Character")

--[[ Setup ]]

do
    local function areProjectionsOverlapping(cf1: CFrame, size1: Vector3, cf2: CFrame, size2: Vector3, projectionVector: Vector3): boolean
        local posCoord1: number = cf1.Position:Dot(projectionVector)
        local halfLength1: number = .5 * Vector3.new(cf1.XVector:Dot(projectionVector), cf1.YVector:Dot(projectionVector), cf1.ZVector:Dot(projectionVector)):Abs():Dot(size1)
        local minCoord1: number, maxCoord1: number = posCoord1 - halfLength1, posCoord1 + halfLength1
    
        local posCoord2: number = cf2.Position:Dot(projectionVector)
        local halfLength2: number = .5 * Vector3.new(cf2.XVector:Dot(projectionVector), cf2.YVector:Dot(projectionVector), cf2.ZVector:Dot(projectionVector)):Abs():Dot(size2)
        local minCoord2: number, maxCoord2: number = posCoord2 - halfLength2, posCoord2 + halfLength2
    
        return maxCoord1 > minCoord2 and minCoord1 < maxCoord2
    end

    function doBoxesIntersect(cf1: CFrame, size1: Vector3, cf2: CFrame, size2: Vector3): boolean
        local axes: {Enum.Axis} = Enum.Axis:GetEnumItems()
        local rot1: CFrame, rot2: CFrame = cf1.Rotation, cf2.Rotation
        for _, axis: Enum.Axis in axes do
            local axisVector: Vector3 = Vector3.FromAxis(axis)
    
            local box1Normal: Vector3 = rot1 * axisVector
            if not areProjectionsOverlapping(cf1, size1, cf2, size2, box1Normal) then
                return false
            end
    
            local box2Normal: Vector3 = rot2 * axisVector
            if not areProjectionsOverlapping(cf1, size1, cf2, size2, box2Normal) then
                return false
            end
    
            for _, otherAxis: Enum.Axis in axes do
                local otherAxisVector: Vector3 = Vector3.FromAxis(otherAxis)
    
                local box2OtherNormal: Vector3 = rot2 * otherAxisVector
                local crossProduct: Vector3 = box1Normal:Cross(box2OtherNormal)
                if math.abs(crossProduct:Dot(crossProduct)) < 1e-4 then
                    continue
                end
                if not areProjectionsOverlapping(cf1, size1, cf2, size2, crossProduct) then
                    return false
                end
            end
        end
        return true
    end
end

--[[ Update ]]

Systems:on_update(System, function(world: Types.World)
    for entity: Types.Entity, character: Model in Components:for_each(CharacterComponent) do
        local primaryPart: BasePart? = character.PrimaryPart
        if primaryPart and workspace:FindFirstChild("Part") and doBoxesIntersect(workspace.Part.CFrame, workspace.Part.Size, primaryPart.CFrame, primaryPart.Size) then
            workspace.Part.Color = Color3.new(0.627451, 1.000000, 0.678431)
        else
            workspace.Part.Color = Color3.new(0.352941, 0.341176, 0.392157)
        end
    end
end)

return System