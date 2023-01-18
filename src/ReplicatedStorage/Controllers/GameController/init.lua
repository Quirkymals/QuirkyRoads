--// Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Modules
local Level = require(script.Level)
local Obstacle = require(script.Obstacle)
local PlayerObserver = require(script.PlayerObserver)

--// Knit
local Knit = require(ReplicatedStorage.Packages.Knit)

--// Controller
local GameController = Knit.CreateController({ Name = "GameController" })

--// Variables
local Player = Players.LocalPlayer

local Levels = ReplicatedStorage.Levels

function GameController:KnitInit() end

function GameController:KnitStart()
	-------------Variables-----------
	local GameService = Knit.GetService("GameService")
	-------------Variables-----------
	-------------Classes-------------
	PlayerObserver.new(GameService)
	-------------Classes-------------
	-----------Initialize------------
	GameService.CreateObstacle:Connect(Obstacle.new)
	GameService.ChangeLevel:Connect(function(CurrentLevel)
		Knit.PlayerState:Set("Level", CurrentLevel)
	end)
	-----------Initialize------------
end

return GameController
