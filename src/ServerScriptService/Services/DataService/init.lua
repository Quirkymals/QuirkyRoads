--// Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Modules

--// ProfileService
local ProfileService = require(ReplicatedStorage.Packages.ProfileService)

--// Knit
local Knit = require(ReplicatedStorage.Packages.Knit)
Knit.Profiles = {}

--// Service
local DataService = Knit.CreateService({
	Name = "DataService",
	Client = {},
})

--// Variables
local ProfileTemplate = {
	Animal = "Dove",
	EquippedPets = {},
	EquippedSkin = "",

	QuirkyCoins = 0,

	Equipped = {
		Skin = "",
		Pets = {},
	},

	Notifications = {
		PersonalMessages = 0,
		FriendRequest = 0,
	},

	Inventory = {
		Characters = {
			["Pigeon"] = true,
			["Dove"] = true,
			["Cat"] = true,
			["Dog"] = true,
		},

		Skins = {},

		Pets = {},
	},

	Friends = {},
}

local ProfileStore = ProfileService.GetProfileStore("PlayerData", ProfileTemplate)
local Profiles = {}

--// Local Functions
local function PlayerAdded(player)
	local profile = ProfileStore:LoadProfileAsync("Player_" .. player.UserId)
	print(profile)
	if profile ~= nil then
		profile:AddUserId(player.UserId) -- GDPR compliance
		profile:Reconcile() -- Fill in missing variables from ProfileTemplate (optional)
		profile:ListenToRelease(function()
			Profiles[player] = nil
			Knit.Profiles[player] = nil
			-- The profile could've been loaded on another Roblox server:
			player:Kick()
		end)
		if player:IsDescendantOf(Players) == true then
			Profiles[player] = profile
			Knit.Profiles[player] = profile
			-- A profile has been successfully loaded:
			-- DoSomethingWithALoadedProfile(player, profile)
		else
			-- Player left before the profile loaded:
			profile:Release()
		end
	else
		-- The profile couldn't be loaded possibly due to other
		--   Roblox servers trying to load this profile at the same time:
		player:Kick()
	end
end

local function PlayerRemoving(player)
	local profile = Profiles[player]
	if profile ~= nil then
		profile:Release()
	end
end

function DataService:GetProfile(Player)
	if Player == nil then
		error('"Player" arg is nil')
	end

	print(Player)
	repeat
		task.wait()
	until Profiles[Player] ~= nil

	if Profiles[Player] then
		return Profiles[Player]
	else
		error("profile is nil")
	end
end

function DataService:GetData(Player)
	return self:GetProfile(Player).Data
end

Players.PlayerAdded:Connect(PlayerAdded)
Players.PlayerRemoving:Connect(PlayerRemoving)
-- // CREATE

function DataService:UnlockAnimal(Player, Animal)
	self:GetData(Player).Inventory.Characters[Animal] = true
	self.Client.RefreshGrid:Fire(Player)
end

function DataService:UnlockPet(Player, Pet)
	self:GetData(Player).Inventory.Pets[Pet] = true
	self.Client.RefreshGrid:Fire(Player, "PetGrid")
end

function DataService:UnlockSkin(Player, Skin)
	self:GetData(Player).Inventory.Skins[Skin] = true
	self.Client.RefreshGrid:Fire(Player, "PetGrid")
end

-- // READ

function DataService:GetEquippedSkin(Player)
	return self:GetData(Player).Equipped.Skin
end

function DataService:GetUnlockedCharacters(Player)
	return self:GetData(Player).Inventory.Characters
end

function DataService:GetUnlockedSkins(Player)
	return self:GetData(Player).Inventory.Skins
end

function DataService:GetUnlockedPets(Player)
	return self:GetData(Player).Inventory.Pets
end

function DataService:GetEquippedPets(Player)
	return self:GetData(Player).Equipped.Pets
end

function DataService:GetFriends(Player)
	return self:GetData(Player).Friends
end

--// UPDATE

function DataService:EquipPet(Player, Pet)
	self:GetData(Player).Equipped.Pets = { Pet }
end

function DataService:EquipSkin(Player, Skin)
	self:GetData(Player).Equipped.Skin = Skin
end

function DataService:ResetSkin(Player)
	self:GetData(Player).Equipped.Skin = ""
end

function DataService:AddCoins(Player, Amount)
	self:GetData(Player).QuirkyCoins += Amount
	return self:GetCoins(Player)
end

function DataService:GetCoins(Player)
	return self:GetData(Player).QuirkyCoins
end

function DataService:KnitInit()
	-- game.Players.PlayerAdded:Connect(PlayerAdded)
end

function DataService:KnitStart()
	-------------Variables-----------

	-------------Variables-----------
	-------------Classes-------------

	-------------Classes-------------
	-----------Initialize------------
	-----------Initialize------------
end

function DataService.Client:GetData(Player)
	return DataService:GetData(Player)
end

function DataService.Client:GetCoins(Player)
	return self:GetData(Player).QuirkyCoins
end

function DataService.Client:EquipPet(Player, Pet)
	self:GetData(Player).Equipped.Pets = { Pet }
end

function DataService.Client:GetUnlockedSkins(Player)
	return self:GetData(Player).Inventory.Skins
end

function DataService.Client:GetUnlockedPets(Player)
	return self:GetData(Player).Inventory.Pets
end

function DataService.Client:GetUnlockedCharacters(Player)
	return self:GetData(Player).Inventory.Characters
end

return DataService
