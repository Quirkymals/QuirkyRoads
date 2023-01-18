--[[
PlayerObserver

    A short description of the module.

SYNOPSIS

    -- Lua code that showcases an overview of the API.
    local foobar = PlayerObserver.TopLevel('foo')
    print(foobar.Thing)

DESCRIPTION

    A detailed description of the module.

API

    -- Describes each API item using Luau type declarations.

    -- Top-level functions use the function declaration syntax.
    function ModuleName.TopLevel(thing: string): Foobar

    -- A description of Foobar.
    type Foobar = {

        -- A description of the Thing member.
        Thing: string,

        -- Each distinct item in the API is separated by \n\n.
        Member: string,

    }
]]

-- Implementation of PlayerObserver.

--// Services
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local Knit = require(ReplicatedStorage.Packages.Knit)

--// Variables
local PlayerState = Knit.PlayerState
local Player: Player = Players.LocalPlayer

local Camera: Camera = workspace.CurrentCamera
local Levels: Folder = ReplicatedStorage.Levels

local Function: RBXScriptConnection
local Function2: RBXScriptConnection
local CameraConnection: RBXScriptConnection

local CollisionSFX: { Sound } = SoundService.Collisions:GetChildren()

--// module
local PlayerObserver = {}

function PlayerObserver.SpawnPlayer(_Character: Model?)
	local LevelFolder = PlayerState:Get("LevelMap")
	local Character: Model = _Character or PlayerState:Get("Character")

	local Spawns = LevelFolder.Spawns:GetChildren()
	local RandomSpawn = Spawns[math.random(1, #Spawns)]

	Character:PivotTo(RandomSpawn.CFrame * CFrame.new(0, 5, 0))

	PlayerObserver.Camera(Character)
	PlayerObserver.WalkOnLog(Character)
	PlayerObserver.ListenForCollisions(Character)
end

function PlayerObserver.new()
	PlayerState:GetChangedSignal("Level"):Connect(function(CurrentLevel, PreviousLevel)
		local CurrentLevelFolder = PlayerState:Get("LevelMap")
		local NextLevelFolder = Levels:FindFirstChild(CurrentLevel):Clone()

		NextLevelFolder.Parent = workspace
		PlayerState:Set("LevelMap", NextLevelFolder)

		if CurrentLevelFolder then
			CurrentLevelFolder:Destroy()
		end
		PlayerObserver.SpawnPlayer()
	end)

	PlayerState:GetChangedSignal("Character"):Connect(function(Character)
		PlayerObserver.SpawnPlayer(Character)
	end)
end

function PlayerObserver.ListenForCollisions(Character)
	local Collision, Death

	local PlayerService = Knit.GetService("PlayerService")

	local PrimaryPart: MeshPart = Character:WaitForChild("HumanoidRootPart")
	local Humanoid: Humanoid = Character:WaitForChild("Humanoid")

	Collision = PrimaryPart.Touched:Connect(function(otherPart)
		if CollectionService:HasTag(otherPart, "Obstacle") then
			CollisionSFX[math.random(1, #CollisionSFX)]:Play()
			PlayerService.Kill:Fire()
			Collision:Disconnect()
		end
	end)
end

function PlayerObserver.Camera(Character: { PrimaryPart: MeshPart })
	if CameraConnection then
		CameraConnection:Disconnect()
	end

	Camera = workspace.CurrentCamera

	local Max = 20
	local Distance = 10

	local LevelFolder: Folder = PlayerState:Get("LevelMap")
	local GoalLocation: Part = LevelFolder.Goal:FindFirstChildOfClass("Part")
	local SpawnLocation: SpawnLocation = LevelFolder.Spawns:FindFirstChildOfClass("SpawnLocation")

	local Forward = math.clamp((GoalLocation.Position - SpawnLocation.Position).Magnitude, -1, 1)
	local SpawnLocationCFrame = SpawnLocation.CFrame

	CameraConnection = RunService.RenderStepped:Connect(function(deltaTime)
		if not Character or not Character:FindFirstChild("HumanoidRootPart") then
			CameraConnection:Disconnect()
		end

		Camera.CameraType = Enum.CameraType.Scriptable

		local CharacterPosition = Character.PrimaryPart.Position
		local CharXPos = CharacterPosition.X

		local OriginX = math.clamp(CharXPos, CharXPos - Max, CharXPos + Max)
		local Origin =
			CFrame.new(OriginX + (-Forward * Distance), SpawnLocationCFrame.Y + (Distance * 0.5), CharacterPosition.Z)

		local Desired: CFrame = CFrame.new(Origin.Position, CharacterPosition)

		Camera.CFrame = Camera.CFrame:Lerp(Desired, 0.1)
	end)
end

function PlayerObserver.WalkOnLog(Character)
	local LastLogCF

	Function = RunService.RenderStepped:Connect(function()
		--------------------------------------------------------------- CHECK PLATFORM BELOW

		local Ignore = Character
		local RootPart = Character.PrimaryPart

		local ray = Ray.new(RootPart.CFrame.p, Vector3.new(0, -50, 0))
		local Hit, Position, Normal, Material = workspace:FindPartOnRay(ray, Ignore)

		if Hit and Hit.Name == "Log" then
			local Log = Hit

			if LastLogCF == nil then
				LastLogCF = Log.CFrame
			end

			local LogCF = Log.CFrame
			local Rel = LogCF * LastLogCF:Inverse()
			RootPart.CFrame = Rel * RootPart.CFrame

			LastLogCF = Log.CFrame
		else
			LastLogCF = nil
		end

		Function2 = Character.Humanoid.Died:Connect(function()
			Function:Disconnect()
			Function2:Disconnect()
		end)
	end)
end

return PlayerObserver
