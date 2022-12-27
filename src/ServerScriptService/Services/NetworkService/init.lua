--// Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Modules

--// Knit
local Knit = require(ReplicatedStorage.Packages.Knit)

--// Service
local NetworkService = Knit.CreateService({
	Name = "NetworkService",
	Client = {},
})

function NetworkService:KnitInit() end

function NetworkService:KnitStart()
	-------------Variables-----------

	-------------Variables-----------
	-------------Classes-------------

	-------------Classes-------------
	-----------Initialize------------

	-----------Initialize------------
end

return NetworkService
