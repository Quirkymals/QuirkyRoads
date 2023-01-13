--// Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Modules
local Obstacle = require(script.Obstacle)

--// Knit
local Knit = require(ReplicatedStorage.Packages.Knit)

--// Controller
local GameController = Knit.CreateController({ Name = "GameController" })

--// Variables
function GameController:KnitInit() end

function GameController:KnitStart()
	-------------Variables-----------
	local GameService = Knit.GetService("GameService")
	-------------Variables-----------
	-------------Classes-------------

	-------------Classes-------------
	-----------Initialize------------
	GameService.CreateObstacle:Connect(Obstacle.new)
	-----------Initialize------------
end

return GameController
