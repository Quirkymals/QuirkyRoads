--// Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Modules
-- What Im thinking of doing, is getting the animation tracks of near

--// Knit
local Knit = require(ReplicatedStorage.Packages.Knit)

--// Service
local PlayerService = Knit.CreateService({
	Name = "PlayerService",
	Client = {},
})

function PlayerService:KnitInit() 
	local CharactersFolder = Instance.new('Folder')
	CharactersFolder.Name = "Players"

	self.CharactersFolder = CharactersFolder
end

function PlayerService:KnitStart()
	-------------Variables-----------

	-------------Variables-----------
	-------------Classes-------------

	-------------Classes-------------
	-----------Initialize------------
	Players.PlayerAdded:Connect(function(player)
		
	end)
	-----------Initialize------------
end

return PlayerService
