--// Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Knit
local Knit = require(ReplicatedStorage.Packages.Knit)

--// State Machines
local PlayerState = Knit.PlayerState

--// Controller
local PlayerController = Knit.CreateController({ Name = "PlayerController" })

--// Variables
function PlayerController:KnitInit() end

function PlayerController:KnitStart()
	-------------Variables-----------
	print(PlayerState)
	-------------Variables-----------
	-------------Classes-------------

	-------------Classes-------------
	-----------Initialize------------

	-----------Initialize------------
end

return PlayerController
