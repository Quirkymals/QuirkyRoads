--// Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Modules

--// Knit
local Knit = require(ReplicatedStorage.Packages.Knit)

--// Controller
local Observer = Knit.CreateController({ Name = "Observer" })

--// Variables
function Observer:KnitInit() end

function Observer:KnitStart()
	-------------Variables-----------
	local StateManager = script:GetChildren()
	-------------Variables-----------
	-----------Initialize------------

	-----------Initialize------------
end

return Observer
