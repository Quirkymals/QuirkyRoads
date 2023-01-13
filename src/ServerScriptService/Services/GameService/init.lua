--// Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Modules
local LevelClass = require(script.Level)

--// Knit
local Knit = require(ReplicatedStorage.Packages.Knit)

--// Service
local GameService = Knit.CreateService({
	Name = "GameService",
	Client = {
		CreateObstacle = Knit.CreateSignal(),
	},
})

local function CreateLevelsTable()
	local Levels = ReplicatedStorage:FindFirstChild("Levels") or error('Levels is not a member of "ReplicatedStorage"')
	local LevelOccupancies = {}
	for i, Level: Folder in pairs(Levels:GetChildren()) do
		LevelOccupancies[tonumber(Level.Name)] = {}
	end

	return LevelOccupancies
end

function GameService:KnitInit()
	self.LevelClasses = {}
	self.ObservedPlayers = {}
	self.LevelOccupancies = CreateLevelsTable()
end

function GameService:KnitStart()
	-------------Variables-----------
	self.PlayerService = Knit.GetService("PlayerService")
	-------------Variables-----------
	-------------Classes-------------

	-------------Classes-------------
	-----------Initialize------------
	Players.PlayerAdded:Connect(function(Player)
		self:ObservePlayer(Player)
	end)

	for _, Player in pairs(Players:GetChildren()) do
		self:ObservePlayer(Player)
	end
	-----------Initialize------------
end

function GameService:GetLevelOccupancyCount(...)
	local n = 0
	for _ in pairs(...) do
		n += 1
	end
	return n
end

function GameService:CreatePlayerListFromOccupancy(LevelOccupancy)
	local PlayerList = {}

	for Key in pairs(LevelOccupancy) do
		table.insert(PlayerList, Key)
	end

	return PlayerList
end

function GameService:UpdateLevelClass(CurrentLevelClass: number, LevelOccupancy: number)
	CurrentLevelClass.Players = self:CreatePlayerListFromOccupancy(LevelOccupancy)
end

function GameService:CreateLevelClass(Level: number, LevelOccupancy: { [Player]: boolean })
	local CurrentLevelClass = self.LevelClasses[Level]

	if CurrentLevelClass then
		return self:UpdateLevelClass(CurrentLevelClass, LevelOccupancy)
	end

	self.LevelClasses[Level] = LevelClass.new(self, Level)
	self:UpdateLevelClass(self.LevelClasses[Level], LevelOccupancy)

	self.LevelClasses[Level]:Init()
end

function GameService:RemoveLevelClass(Level: number)
	local CurrentLevelClass = self.LevelClasses[Level]

	if not CurrentLevelClass then
		return
	end

	CurrentLevelClass:Destroy()
end

function GameService:UpdateLevels(...)
	for _, Level: number in pairs({ ... }) do
		local LevelOccupancy = self.LevelOccupancies[Level]

		if not LevelOccupancy then
			continue
		end

		if self:GetLevelOccupancyCount(LevelOccupancy) > 0 then
			self:CreateLevelClass(Level, LevelOccupancy)
		else
			self:RemoveLevelClass(Level)
		end
	end
end

function GameService:ObservePlayer(Player: Player)
	if self.ObservedPlayers[Player] then
		return
	end

	self.ObservedPlayers[Player] = true

	local PlayerState = self.PlayerService:GetPlayerState(Player)
	local Connections = PlayerState:Get("Connections")

	Connections["LevelObserver"] = PlayerState:GetChangedSignal("Level"):Connect(function(CurrentLevel, PreviousLevel)
		self:ManageLevelOccupancy(Player, CurrentLevel, PreviousLevel)
	end)

	PlayerState:Set("Connections", Connections)
	PlayerState:Set("Level", 1)
end

function GameService:ManageLevelOccupancy(Player: Player, CurrentLevel: number, PreviousLevel: number)
	local LevelOccupancies = self.LevelOccupancies

	if CurrentLevel > 1 then
		LevelOccupancies[PreviousLevel][Player] = nil
	end

	LevelOccupancies[CurrentLevel][Player] = true

	self:UpdateLevels(CurrentLevel, PreviousLevel)
end

return GameService
