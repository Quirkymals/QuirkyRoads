--// Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Basic State
local BasicState = require(ReplicatedStorage.Packages.BasicState)

local Player = BasicState.new({
	Exp = 0,
})

return Player
