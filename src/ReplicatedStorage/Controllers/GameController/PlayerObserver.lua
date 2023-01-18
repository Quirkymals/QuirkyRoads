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
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Knit = require(ReplicatedStorage.Packages.Knit)

--// Variables
local Player = Players.LocalPlayer
local PlayerState = Knit.PlayerState

local Camera: Camera = workspace.CurrentCamera
local Levels = ReplicatedStorage.Levels

local CameraConnection: RBXScriptConnection

--// module
local PlayerObserver = {}

function PlayerObserver.SpawnPlayer()
	local LevelFolder = PlayerState:Get("LevelMap")
	local Character: Model = PlayerState:Get("Character")

	local Spawns = LevelFolder.Spawns:GetChildren()

	local RandomSpawn = Spawns[math.random(1, #Spawns)]

	Character:PivotTo(RandomSpawn.CFrame * CFrame.new(0, 5, 0))

	PlayerObserver.Camera(Player.Character or Player.CharacterAdded:Wait())
end

function PlayerObserver.new()
	PlayerState:GetChangedSignal("Level"):Connect(function(CurrentLevel, PreviousLevel)
		local CurrentLevelFolder = PlayerState:Get("LevelMap")
		local NextLevelFolder = Levels:FindFirstChild(CurrentLevel):Clone()

		print("Test")

		NextLevelFolder.Parent = workspace
		PlayerState:Set("LevelMap", NextLevelFolder)

		PlayerObserver.SpawnPlayer()

		if CurrentLevelFolder then
			CurrentLevelFolder:Destroy()
		end
	end)

	PlayerState:GetChangedSignal("Character"):Connect(function(Character)
		PlayerObserver.SpawnPlayer()
	end)
end

function PlayerObserver.Camera(Character: { PrimaryPart: MeshPart })
	if CameraConnection then
		CameraConnection:Disconnect()
	end

	Camera = workspace.CurrentCamera
	Camera.CameraType = Enum.CameraType.Scriptable

	local Max = 20
	local LevelFolder: Folder = PlayerState:Get("LevelMap")

	local GoalLocation: Part = LevelFolder.Goal:FindFirstChildOfClass("Part")
	local SpawnLocation: SpawnLocation = LevelFolder.Spawns:FindFirstChildOfClass("SpawnLocation")

	local Forward = math.clamp((GoalLocation.Position - SpawnLocation.Position).Magnitude, -1, 1)
	local SpawnLocationCFrame = SpawnLocation.CFrame

	local Distance = 10

	CameraConnection = RunService.RenderStepped:Connect(function(deltaTime)
		Camera.CameraType = Enum.CameraType.Scriptable

		local CharacterPosition = Character.PrimaryPart.Position
		local CharXPos = CharacterPosition.X

		local OriginX = math.clamp(CharXPos, CharXPos - Max, CharXPos + Max)

		local Origin =
			CFrame.new(OriginX + (-Forward * Distance), SpawnLocationCFrame.Y + Distance, CharacterPosition.Z)

		-- local LookAt = CFrame.new(
		--     OriginX,
		-- )

		local Desired: CFrame = CFrame.new(Origin.Position, CharacterPosition)

		Camera.CFrame = Camera.CFrame:Lerp(Desired, 0.1)
	end)
end

return PlayerObserver
