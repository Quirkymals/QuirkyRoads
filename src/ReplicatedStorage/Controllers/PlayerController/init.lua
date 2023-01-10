--// Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Modules
local Animation = require(ReplicatedStorage.Modules.Animation)
local AnimTrack = require(ReplicatedStorage.Util.AnimTrack)

--// Knit
local Knit = require(ReplicatedStorage.Packages.Knit)
local Player: Player = Knit.Player

--// State Machines
local PlayerState = Knit.PlayerState

--// Controller
local PlayerController = Knit.CreateController({ Name = "PlayerController" })

--// Modules

--// Classes
local Classes = ReplicatedStorage.Classes
local CharacterClass = require(Classes.Character)

--// Variables

--// Private Functions
local function AddDeathAnimation(Character: Model, Animal: string)
	local Humanoid: Humanoid = Character:WaitForChild("Humanoid")
	local Connection

	local DeathAnimation = AnimTrack.new(Humanoid, Animation.GetAnimations(Animal, "Death"))

	Connection = Humanoid.Died:Connect(function()
		DeathAnimation:PlayOnce()
		Connection:Disconnect()
	end)
end

function PlayerController:KnitInit() end

function PlayerController:KnitStart()
	-------------Variables-----------
	self.PlayerService = Knit.GetService("PlayerService")
	-------------Variables-----------
	-------------Classes-------------

	-------------Classes-------------
	-----------Initialize------------

	self.PlayerService.Spawned:Connect(function(_Player, ...)
		if _Player == Player then
			AddDeathAnimation(...)
		end
		CharacterClass.new(_Player, ...):Init()
	end)

	-----------Initialize------------
end

return PlayerController
