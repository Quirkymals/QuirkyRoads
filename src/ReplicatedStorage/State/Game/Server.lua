-- May be obsolete

--// Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Basic State
local BasicState = require(ReplicatedStorage.Packages.BasicState)

local Mode = BasicState.new({
	Index = nil,
})

return Mode
