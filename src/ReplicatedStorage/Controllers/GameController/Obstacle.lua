--[[
Obstacle

    A short description of the module.

SYNOPSIS

    -- Lua code that showcases an overview of the API.
    local foobar = Obstacle.TopLevel('foo')
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

-- Implementation of Obstacle.

--// Types
export type MarkerSet = { Start: Part, End: Part }

--// Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Required
local Knit = require(ReplicatedStorage.Packages.Knit)
local Feel = require(ReplicatedStorage.Modules.Feel)
local Lerp = Feel.Lerp

--// Variables
local PlayerState = Knit.PlayerState

--// module
local Obstacle = {}

function Obstacle.new(CurrentLevelFolderName, SetName, MarkerName, ObstacleName: string, Time: number)
	if not PlayerState:Get("LevelMap") then
		return
	end

	local CurrentLevelFolder: Folder = PlayerState:Get("LevelMap")
	local ObstacleInstance: MeshPart = CurrentLevelFolder.Obstacles[SetName .. "s"]:FindFirstChild(ObstacleName)

	local ObstacleMarkerSet: Folder = CurrentLevelFolder:FindFirstChild(SetName .. "Markers")
	local MarkerSet: MarkerSet = ObstacleMarkerSet:FindFirstChild(MarkerName)

	Obstacle.CastObstacle(CurrentLevelFolder.Debris, ObstacleInstance:Clone(), MarkerSet, Time)
end

function Obstacle.GetCFrame(ObstacleInstance: MeshPart, Marker: Part)
	return Marker.CFrame
		* CFrame.new(0, ObstacleInstance.Size.Y / 2 - Marker.Size.Y / 2, 0)
		* CFrame.fromEulerAnglesXYZ(0, -math.pi / 2, 0)
end

function Obstacle.CastObstacle(Debris: Folder, ObstacleInstance: MeshPart, MarkerSet: MarkerSet, Time: number)
	local Start = MarkerSet.Start
	local End = MarkerSet.End

	ObstacleInstance.CFrame = Obstacle.GetCFrame(ObstacleInstance, Start)
	ObstacleInstance.Parent = Debris

	Lerp.CFrame(ObstacleInstance, Obstacle.GetCFrame(ObstacleInstance, End), Time)

	ObstacleInstance:Destroy()
end

return Obstacle
