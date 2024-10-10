local runService: RunService = game:GetService("RunService")

local player: Player = game:GetService("Players").LocalPlayer
local character: Model = player.Character or player.CharacterAdded:Wait()

local Camera: Camera = workspace.CurrentCamera

local Dampening = 1000 -- Higher number makes it take longer to reach its destination
local Power = 10000 -- Higher number means more power
local MaxForce = Vector3.one * 4000 -- Max amount of power that can be applied on each axis

local fovAmount = 30
local offsetMultiplyer = 2
local cameraOffsetVector = Vector3.new(25 * offsetMultiplyer, 37 * offsetMultiplyer, -25 * offsetMultiplyer)

function UpdateCameraPosition()
	character.CameraPositionPart.BodyPosition.Position = character.PrimaryPart.Position + cameraOffsetVector
	Camera.CFrame = CFrame.new(character.CameraPositionPart.Position, character.CameraPositionPart.Position - cameraOffsetVector)
end

function CreateCameraPositionPart()
	local CameraPositionPart = Instance.new("Part")
	CameraPositionPart.Position = Vector3.new(0, 0, 0)
	CameraPositionPart.CanCollide = false
	CameraPositionPart.Transparency = 1
	CameraPositionPart.Name = "CameraPositionPart"
	CameraPositionPart.Parent = character

	local CameraBodyPosition = Instance.new("BodyPosition")
	CameraBodyPosition.D = Dampening
	CameraBodyPosition.P = Power
	CameraBodyPosition.MaxForce = MaxForce
	CameraBodyPosition.Parent = CameraPositionPart
end

Camera.CameraType = Enum.CameraType.Scriptable
Camera.FieldOfView = fovAmount

CreateCameraPositionPart()

runService:BindToRenderStep("Camera", Enum.RenderPriority.Camera.Value, UpdateCameraPosition)