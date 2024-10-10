local Camera = game.Workspace.CurrentCamera
local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()

local Angles = CFrame.Angles
local aSin = math.asin
local aTan = math.atan
local MseGuide = true
local TurnCharacterToMouse = true
local HeadHorFactor = 1.2
local HeadVertFactor = 0
local CharacterHorFactor = 0.6
local CharacterVertFactor = 0
local UpdateSpeed = 0.5

if TurnCharacterToMouse == true then
	MseGuide = true
	HeadHorFactor = 1.2
	CharacterHorFactor = 1.6
end

local Head = Character:WaitForChild("Head")
local Humanoid = Character:FindFirstChild("Humanoid")
local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
local IsR6 = (Humanoid.RigType.Value==0)
local Torso = (IsR6 and Character:FindFirstChild("Torso")) or Character:FindFirstChild("UpperTorso")
local Neck = (IsR6 and Torso:FindFirstChild("Neck")) or Head:FindFirstChild("Neck")
local Waist = (not IsR6 and Torso:FindFirstChild("Waist"))

local NeckOrgnC0 = Neck.C0
local WaistOrgnC0 = (not IsR6 and Waist.C0)
Neck.MaxVelocity = 1/3

return function (mousePosition: Vector3 | nil)
	local CameraCF = Camera.CFrame
	if ((IsR6 and Character["Torso"]) or Character["UpperTorso"]) ~= nil and Character["Head"] ~= nil then
		local TorsoLV = Torso.CFrame.LookVector
		local headPosition = Head.CFrame.Position
		if IsR6 and Neck or Neck and Waist then
			if Camera.CameraSubject:IsDescendantOf(Character) or Camera.CameraSubject:IsDescendantOf(Player) then
				local Dist = nil;
				local Diff = nil;

				if not MseGuide then
					Dist = (Head.CFrame.p-CameraCF.p).magnitude
					Diff = Head.CFrame.Y-CameraCF.Y
					if not IsR6 then
						Neck.C0 = Neck.C0:Lerp(NeckOrgnC0*Angles((aSin(Diff/Dist)*HeadVertFactor), -(((headPosition - CameraCF.Position).Unit):Cross(TorsoLV)).Y * HeadHorFactor, 0), UpdateSpeed / 2)
						Waist.C0 = Waist.C0:Lerp(WaistOrgnC0*Angles((aSin(Diff/Dist)*CharacterVertFactor), -(((headPosition - CameraCF.Position).Unit):Cross(TorsoLV)).Y*CharacterHorFactor, 0), UpdateSpeed / 2)
					else
						Neck.C0 = Neck.C0:Lerp(NeckOrgnC0*Angles(-(aSin(Diff/Dist)*HeadVertFactor), 0, -(((headPosition - CameraCF.Position).Unit):Cross(TorsoLV)).Y*HeadHorFactor),UpdateSpeed/2)
					end
				else
					local Point = mousePosition
					Dist = (Head.CFrame.p-Point).magnitude
					Diff = Head.CFrame.Y-Point.Y
					if not IsR6 then
						Neck.C0 = Neck.C0:Lerp(NeckOrgnC0*Angles(-(aTan(Diff/Dist)*HeadVertFactor), (((headPosition-Point).Unit):Cross(TorsoLV)).Y*HeadHorFactor, 0), UpdateSpeed / 3)
						Waist.C0 = Waist.C0:Lerp(WaistOrgnC0*Angles(-(aTan(Diff/Dist)*CharacterVertFactor), (((headPosition-Point).Unit):Cross(TorsoLV)).Y*CharacterHorFactor, 0), UpdateSpeed / 3)
					else
						Neck.C0 = Neck.C0:Lerp(NeckOrgnC0*Angles((aTan(Diff/Dist)*HeadVertFactor), 0, (((headPosition-Point).Unit):Cross(TorsoLV)).Y*HeadHorFactor), UpdateSpeed / 3)
					end
				end
			end
		end
	end
	if TurnCharacterToMouse == true then
		Humanoid.AutoRotate = false
		HumanoidRootPart.CFrame = HumanoidRootPart.CFrame:Lerp(CFrame.new(HumanoidRootPart.Position, Vector3.new(mousePosition.X, HumanoidRootPart.Position.Y, mousePosition.Z)), UpdateSpeed / 6)
	else
		Humanoid.AutoRotate = true
	end
end