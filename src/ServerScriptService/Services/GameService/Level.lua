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

--// Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

--// Variables
local Levels = ReplicatedStorage:FindFirstChild("Levels")

local Index = { "Logs", "Trains", "Vehicles" }

--// Class
local Level = {}
Level.__index = Level

function Level.new(GameService, CurrentLevel: number)
	local info = {
		GameService = GameService,
		CreateObstacleSignal = GameService.Client.CreateObstacle,

		CurrentLevel = CurrentLevel,
		CurrentLevelFolder = Levels:FindFirstChild(tostring(CurrentLevel)),

		Players = {},

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

function Level:CreateObstacle(SetName: string, Marker: Model)
	local MarkerObserverSet = self.Spawned[SetName]
	local MarkerObstacleObserver = MarkerObserverSet[tonumber(Marker.Name)]

	if MarkerObstacleObserver == false then
		MarkerObserverSet[tonumber(Marker.Name)] = false

		for _, Player: Player in pairs(self.Players) do
			self.CreateObstacleSignal:Fire(Player, self.CurrentLevelFolder.Name, string.sub(SetName, -#SetName, -2)..'Markers', Marker.Name)
		end

		task.delay(math.random(3, 5), function()
			MarkerObserverSet[tonumber(Marker.Name)] = true
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
			self:CreateObstacle(MarkerSetName, Marker)
		end
	end
end

function Level:Init()
	self:GetAllMarkers()

	local desiredInterval = 2.5 --fire every 2.5 seconds
	local counter = 0

	self.Connections['Update'] = RunService.Heartbeat:Connect(function(step)
		counter = counter + step
		if counter >= desiredInterval then
			counter = counter - desiredInterval

			self:Update()
		end
	end)
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
