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

--// Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// module
local Obstacle = {}

function Obstacle.new(CurrentLevelFolderName, SetName, MarkerName, ObstacleName: string, Time: number)
	local CurrentLevelFolder = workspace:FindFirstChild(CurrentLevelFolderName)
	local ObstacleMarkerSet = CurrentLevelFolder:FindFirstChild(SetName..'Markers')
    local Marker = ObstacleMarkerSet:FindFirstChild(MarkerName)


    print(Marker)
end

return Obstacle
