--[[
Level

    A short description of the module.

SYNOPSIS

    -- Lua code that showcases an overview of the API.
    local foobar = Level.TopLevel('foo')
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

-- Implementation of Level.

--// Types
export type TimeRange = { Min: number, Max: number }

--// Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

--// Required Modules
local LevelsInfo = require(ReplicatedStorage.Info.Levels)

--// Variables
local Levels = ReplicatedStorage:FindFirstChild("Levels")

local Index = { "Logs", "Trains", "Vehicles" }

--// Class
local Level = {}
Level.__index = Level

function Level.new(GameService, CurrentLevel: number)
	local LevelInfo = LevelsInfo[CurrentLevel]

	local info = {
		GameService = GameService,
		PlayerService = GameService.PlayerService,

		CreateObstacleSignal = GameService.Client.CreateObstacle,

		CurrentLevel = CurrentLevel,
		CurrentLevelFolder = Levels:FindFirstChild(tostring(CurrentLevel)),

		Players = {},

		DelayRanges = LevelInfo.DelayRanges,
		TimeRanges = LevelInfo.TimeRanges,

		Markers = {
			Logs = {},
			Trains = {},
			Vehicles = {},
		},

		Spawned = {
			Logs = {},
			Trains = {},
			Vehicles = {},
		},

		Obstacles = {
			Logs = {},
			Trains = {},
			Vehicles = {},
		},

		Connections = {},
	}

	setmetatable(info, Level)
	return info
end

function Level:GetMarkerSet(SetName: string)
	local CurrentLevelFolder = self.CurrentLevelFolder
	local MarkersSet = CurrentLevelFolder:FindFirstChild(SetName .. "Markers"):GetChildren()

	for _, Marker: Model in pairs(MarkersSet) do
		table.insert(self.Markers[SetName .. "s"], Marker)
		self.Spawned[SetName .. "s"][tonumber(Marker.Name)] = false
	end
end

function Level:AddMillisecondsToTime(Time, TimeRange: TimeRange)
	local MS = math.random(0, 100) / 100 * 2

	if Time + MS < TimeRange.Max then
		return Time + MS
	end

	return Time - MS
end

function Level:CreateObstacle(SetName: string, Marker: Model)
	local MarkerObserverSet = self.Spawned[SetName]
	local SetNameSingular = string.sub(SetName, -#SetName, -2)
	local MarkerObstacleObserver = MarkerObserverSet[tonumber(Marker.Name)]
	local SetNameObstacleFolderChildren = self.CurrentLevelFolder.Obstacles:FindFirstChild(SetName):GetChildren()

	local TimeRange: TimeRange = self.TimeRanges[SetName]
	local Time = self:AddMillisecondsToTime(math.random(TimeRange.Min, TimeRange.Max), TimeRange)

	local DelayRange: TimeRange = self.DelayRanges[SetName] or nil
	local DelayTime = DelayRange and math.random(DelayRange.Min, DelayRange.Max) or nil
	local Obstacle = SetNameObstacleFolderChildren[math.random(1, #SetNameObstacleFolderChildren)]

	if MarkerObstacleObserver == false then
		MarkerObserverSet[tonumber(Marker.Name)] = true

		for _, Player: Player in pairs(self.Players) do
			self.CreateObstacleSignal:Fire(
				Player,
				self.CurrentLevelFolder.Name,
				SetNameSingular,
				Marker.Name,
				Obstacle.Name,
				Time
			)
		end

		task.delay(DelayTime or (Time / 4), function()
			MarkerObserverSet[tonumber(Marker.Name)] = false
		end)
	else
		return
	end
end

function Level:GetAllMarkers()
	for _, SetName: string in pairs({ "Log", "Train", "Vehicle" }) do
		self:GetMarkerSet(SetName)
	end
end

function Level:Update(deltaTime)
	for MarkerSetName: string, MarkerSet: { Model } in pairs(self.Markers) do
		for MarkersSetID, Marker: Model in pairs(MarkerSet) do
			if not self then
				break
			end
			self:CreateObstacle(MarkerSetName, Marker)
		end
	end
end

function Level:Init()
	self:GetAllMarkers()

	local desiredInterval = 0.5 --fire every .5 seconds
	local counter = 0

	self.Connections["Update"] = RunService.Heartbeat:Connect(function(step)
		counter = counter + step
		if counter >= desiredInterval then
			counter = counter - desiredInterval
			self:Update()
		end
	end)

	-- self.Connections['UpdateHitBoxes'] = RunService.Heartbeat:Connect(function(step)

end

function Level:Disconnect()
	for _, c: RBXScriptConnection in pairs(self.Connections) do
		c:Disconnect()
	end
end

function Level:Destroy()
	self:Disconnect()

	setmetatable(self, nil)
	table.clear(self)
	table.freeze(self)
end

return Level
