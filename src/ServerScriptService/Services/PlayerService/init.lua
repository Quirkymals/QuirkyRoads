--// Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

--// Modules
local PlayerState = require(ReplicatedStorage.State.Player.Server)
local CharacterManager = require(script.CharacterManager)

--// Knit
local Knit = require(ReplicatedStorage.Packages.Knit)
Knit.States = {}

--// Service
local PlayerService = Knit.CreateService({
	Name = "PlayerService",
	Client = {

		Spawned = Knit.CreateSignal(),
	},
})

--// Variables

--// Private Functions
local function PlayerStateExist(Player: Player)
	if Knit.States[Player] then
		return true
	else
		return false
	end
end

local function AddState(Player: Player)
	if Player then
		if PlayerStateExist(Player) then
			return
		end

		Knit.States[Player] = PlayerState.new(Player)
	else
		for _, _Player in pairs(Players:GetChildren()) do
			if PlayerStateExist(_Player) then
				return
			end

			Knit.States[_Player] = PlayerState.new(_Player)
		end
	end
end

local function RemoveState(Player: Player)
	Knit.States[Player]:Destroy()
end

local function GetPlayerState(Player)
	local Attempts = 0
	local MaxAttempts = 30

	repeat
		Attempts += 1
		task.wait(0.25)
	until Knit.States[Player] or Attempts == MaxAttempts

	if Attempts == MaxAttempts then
		print("States: ", Knit.States)
		return error("Cannot find state after " .. MaxAttempts .. " attempts.")
	end

	return Knit.States[Player]
end

--// Knit Starting
function PlayerService:KnitInit()
	local CharactersFolder = Instance.new("Folder")
	CharactersFolder.Parent = workspace
	CharactersFolder.Name = "Players"

	self.CharactersFolder = CharactersFolder
end

function PlayerService:KnitStart()
	-------------Variables-----------
	local DataService = Knit.GetService("DataService")

	self.DataService = Knit.GetService("DataService")
	-------------Variables-----------
	-------------Classes-------------

	-------------Classes-------------
	-----------Initialize------------
	Players.PlayerAdded:Connect(function(player)
		--// Private
		AddState(player)

		--// Methods
		self:ListenToState(player)
		self:AddInfoToState(player)
	end)
	Players.PlayerRemoving:Connect(RemoveState)

	AddState()
	-----------Initialize------------
end

--// Methods
function PlayerService:ListenToState(Player: Player)
	local StateMachine = GetPlayerState(Player)
	local Profile = self.DataService:GetData(Player)

	StateMachine:GetChangedSignal("Character"):Connect(function(Character: Model)
		local Animal = StateMachine:Get("Animal")

		CharacterManager.AddAnimations(Character, Animal)
		CharacterManager.Died(StateMachine, Character, Animal)

		Character.AncestryChanged:Wait()
		PlayerService.Client.Spawned:FireAll(Player, Character, Animal)
	end)

	StateMachine:GetChangedSignal("Animal"):Connect(function(NewAnimal)
		local Animal: Model = ServerStorage:FindFirstChild(NewAnimal):Clone()
		Player.Character = Animal

		CharacterManager.Spawn(Animal)
	end)
end

function PlayerService:AddInfoToState(Player)
	local StateMachine = GetPlayerState(Player)
	local Profile = self.DataService:GetData(Player)

	local Animal = Profile["Animal"] or "Parrot"
	StateMachine:Set("Animal", Animal)
end

return PlayerService
