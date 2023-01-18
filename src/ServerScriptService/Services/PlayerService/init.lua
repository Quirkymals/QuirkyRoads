--// Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local SoundService = game:GetService("SoundService")

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
		Kill = Knit.CreateSignal(),
		Spawned = Knit.CreateSignal(),
		SetSpawnPoints = Knit.CreateSignal(),
	},
})

--// Variables
local CollisionSFX: { Sound } = SoundService.Collisions:GetChildren()

--// Private Functions
local function PlayerStateExist(Player: Player)
	if Knit.States[Player] then
		return true
	else
		return false
	end
end

local function RemoveState(Player: Player)
	Knit.States[Player]:Destroy()
end

local function DeleteBones(PrimaryPart: Part | MeshPart)
	local RootBone: Bone = PrimaryPart:FindFirstChildOfClass("Bone")
	if RootBone then
		RootBone:Destroy()
	end
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
		self:AddState(player)

		--// Methods
		self:ListenToState(player)
		self:AddInfoToState(player)
	end)
	Players.PlayerRemoving:Connect(RemoveState)

	self.Client.Kill:Connect(function(Player)
		local Character = Player.Character

		local PrimaryPart: MeshPart = Character.PrimaryPart
		local Humanoid: Humanoid = Character.Humanoid

		local TireMarks = Instance.new("Decal")
		TireMarks.Texture = "rbxassetid://8696601744"
		TireMarks.Face = Enum.NormalId.Top
		TireMarks.Parent = PrimaryPart

		DeleteBones(PrimaryPart)

		PrimaryPart.Size = Vector3.new(PrimaryPart.Size.X, 0, PrimaryPart.Size.Z)
		-- PrimaryPart.Anchored = true

		Humanoid:TakeDamage(Humanoid.MaxHealth)
	end)

	self.Client.SetSpawnPoints:Connect(function(Player: Player, SpawnPointCFrames: { CFrame })
		local PlayerState = self:GetPlayerState(Player)
		PlayerState:Set("SpawnPointCFrames", SpawnPointCFrames)
	end)

	self:AddState()
	-----------Initialize------------
end

--// Methods
function PlayerService:AddState(Player: Player)
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

function PlayerService:GetPlayerState(Player)
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

function PlayerService:ListenToState(Player: Player)
	local StateMachine = self:GetPlayerState(Player)
	local Profile = self.DataService:GetData(Player)

	StateMachine:GetChangedSignal("Character"):Connect(function(Character: Model)
		local Animal = StateMachine:Get("Animal")
		local Humanoid: Humanoid = Character.Humanoid

		CharacterManager.AddAnimations(Character, Animal)
		CharacterManager.Died(StateMachine, Character, Animal)

		Character.AncestryChanged:Wait()
		PlayerService.Client.Spawned:FireAll(Player, Character, Animal)
	end)

	StateMachine:GetChangedSignal("Animal"):Connect(function(NewAnimal)
		local Animal: Model = ServerStorage:FindFirstChild(NewAnimal):Clone()
		Player.Character = Animal

		CharacterManager.Spawn(Player, Animal, StateMachine)
	end)
end

function PlayerService:AddInfoToState(Player)
	local StateMachine = self:GetPlayerState(Player)
	local Profile = self.DataService:GetData(Player)

	local Animal = "Dove" -- Profile["Animal"] or "Parrot"
	StateMachine:Set("Animal", Animal)
end

return PlayerService
