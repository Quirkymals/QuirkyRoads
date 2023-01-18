--// Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Variables
local Player = Players.LocalPlayer

--// Basic State
local BasicState = require(ReplicatedStorage.Packages.BasicState)

local Connections = {}

local PlayerState = BasicState.new({

	Player = Player,
	Character = Player.Character or Player.CharacterAdded:Wait(),

	Level = 0,
	LevelMap = nil,

	Connections = {},
})

Connections["CharacterAdded"] = Player.CharacterAdded:Connect(function(character)
	PlayerState:Set("Character", character)
end)

PlayerState:Set("Connections", Connections)

function PlayerState:Disconnect()
	for _, c: RBXScriptConnection in pairs(PlayerState:Get("Connections")) do
		c:Disconnect()
	end
end

function PlayerState:Destroy()
	self:Disconnect()

	setmetatable(self, nil)
	table.clear(self)
	table.freeze(self)
end

return PlayerState
