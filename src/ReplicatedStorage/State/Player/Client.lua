--// Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Basic State
local BasicState = require(ReplicatedStorage.Packages.BasicState)

local Player = BasicState.new({
	Level = 0,
	Map = nil,
})

return Player
