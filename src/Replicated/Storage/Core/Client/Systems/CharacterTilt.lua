local runService = game:GetService("RunService")

local MOMENTUM_FACTOR = 0.008
local MIN_MOMENTUM = 0.285
local MAX_MOMENTUM = 0.285
local SPEED = 15

local player = game.Players.LocalPlayer
local character = player.Character
local humanoid = character.Humanoid
local humanoidRootPart = character:WaitForChild('HumanoidRootPart',60);

local m6d = nil
local originalM6dC0 = nil

if not character:FindFirstChild("LowerTorso") and not humanoidRootPart:FindFirstChild("RootJoint") then return end

if humanoid.RigType == Enum.HumanoidRigType.R15 then
	local lowerTorso = character.LowerTorso
	m6d = lowerTorso.Root
else
	m6d = humanoidRootPart.RootJoint
end
originalM6dC0 = m6d.C0

local angles = {0, 0, 0}

local timeSinceUpdate = os.clock() + 0.2
runService.PreSimulation:Connect(function(dt)
	timeSinceUpdate = os.clock()

	local direction = humanoidRootPart.CFrame:VectorToObjectSpace(humanoid.MoveDirection)
	local momentum = humanoidRootPart.CFrame:VectorToObjectSpace(humanoidRootPart.Velocity)*MOMENTUM_FACTOR
	momentum = Vector3.new(
		math.clamp(math.abs(momentum.X), MIN_MOMENTUM, MAX_MOMENTUM),
		0,
		math.clamp(math.abs(momentum.Z), MIN_MOMENTUM, MAX_MOMENTUM)
	)

	local x = direction.X*momentum.X
	local z = (direction.Z*momentum.Z) / 2

	if humanoid.RigType == Enum.HumanoidRigType.R15 then
		angles = {z, 0, -x}
	else
		angles = {-z, -x, 0}
	end

	
	if not humanoidRootPart:FindFirstChild("BodyGyro") then
		m6d.C0 = m6d.C0:Lerp(originalM6dC0*CFrame.Angles(unpack(angles)), dt*SPEED)
	end
end)