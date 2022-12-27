--[[
Trade

    A short description of the module.

SYNOPSIS

    -- Lua code that showcases an overview of the API.
    local foobar = Trade.TopLevel('foo')
    print(foobar.Thing)

DESCRIPTION

    A detailed description of the module.

API

    -- Describes each API item using Luau type declarations.

    -- Top-level functions use the function declaration syntax.
    function ModuleName.TopLevel(thing: string): Foobar

    -- A description of Foobar.
    type Foobar = {

        -- A description of the Thing member.
        Thing: string,

        -- Each distinct item in the API is separated by \n\n.
        Member: string,

    }
]]

-- Implementation of Trade.

--// Types
type Trade = {
	key: Player,
	Host: Player,
	Recipient: Player,
	RecipientAccepted: boolean,

	HostInfo: TraderInfo,
	RecipientInfo: TraderInfo,
}

type TraderInfo = {
	Coins: number,
	Gems: number,
	Items: {},
}

--// Services
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Knit
local Knit = require(ReplicatedStorage.Packages.Knit)

--// Module
local Trade = {}

--// TemplateInfo
local TraderTemplate: TraderInfo = {
	Coins = 0,
	Gems = 0,
	Items = {},
}

local function Checker(TradeObject)
	if type(TradeObject) ~= "table" and type(TradeObject) ~= "string" then
		error("First arg needs to be a table or string")
	end

	if type(TradeObject) == "string" then
		TradeObject = Trade[TradeObject]
	end

	return TradeObject
end

local function FindPlayerInTrade(Player: Player)
	if Trade[Player] then
		Trade.CancelTrade(Player)
	end

	for Index, CurrentTrade: Trade in pairs(Trade) do
		if type(CurrentTrade) == "function" then
			continue
		end

		if CurrentTrade.Recipient == Player then
			Trade.CancelTrade(CurrentTrade.Host)
		end
	end
end

local function AuthenticateTrade(Owner: Player, Recipient: Player)
	local RecipientName = (Recipient.DisplayName or Recipient.Name)
	if FindPlayerInTrade(Owner) then
		return true, "You are already trading"
	elseif FindPlayerInTrade(Recipient) then
		return true, RecipientName .. " is already trading"
	end
end

Players.PlayerRemoving:Connect(FindPlayerInTrade)

--// CREATE
function Trade.new(key: Player, Recipient: Player): Trade | nil
	local RequestService = Knit.GetService("RequestService")
	local AuthenticationFailed, WarnMessage = AuthenticateTrade(key, Recipient)

	if AuthenticationFailed then
		RequestService.Client.ObjectTrade:Fire(key, WarnMessage)
		return nil
	end

	local self = {
		key = key,
		Host = key,
		Recipient = Recipient,

		RecipientAccepted = false,

		HostInfo = TraderTemplate,
		RecipientInfo = TraderTemplate,
	}

	Trade[key] = self

	return self
end

--// READ

-- Participants
function Trade.GetUpdater(key: string | {}, Updater: Player)
	local self = Checker(key)

	if Updater == self.Host then
		return "Host"
	elseif Updater == self.Recipient then
		return "Recipient"
	end

	return nil
end

-- Item Information
function Trade.GetItemFromInventory(key: string | {}, Updater: Player, Id: string)
	local self = Checker(key)
	local InventoryService = Knit.GetService("InventoryService")
	return InventoryService:ItemDoesExist(Updater, Id)
end

function Trade.GetItemFromList(key: string | {}, TraderInfo: table, ValueId: string)
	local self = Checker(key)

	for ItemIndex, Item in pairs(TraderInfo.Items) do
		if Item.Id == ValueId then
			return ItemIndex
		end
	end

	return nil
end

--// UPDATE
function Trade.RequestAccepted(key: string | {})
	local self = Checker(key)
	self.RecipientAccepted = true
end

function Trade.AddItem(key: string | {}, Updater: Player, TraderInfo: table, ValueId: string | number)
	local self = Checker(key)
	-- Check to see if item exist in players inventory
	local OwnsItem, ItemInformation = Trade.GetItemFromInventory(self, Updater, ValueId)

	if OwnsItem then
		TraderInfo[ItemInformation.Id] = ItemInformation
	else
		warn(Updater .. " does not own " .. ItemInformation.Name)
	end
end

function Trade.Update(
	key: string | {},
	Updater: Player,
	UpdateType: string,
	ValueToUpdate: string | number,
	UpdatedValue: string | number
)
	local self = Checker(key)
	local IdService = Knit.GetService("IdService")

	local UpdaterLabel = Trade.GetUpdater(self, Updater)

	if UpdaterLabel then
		local TradeInfoListToUpdate = self[UpdaterLabel .. "Items"]

		if UpdateType == "Remove" then
			Trade.RemoveItem(self, Updater, TradeInfoListToUpdate, ValueToUpdate)
		elseif UpdateType == "AddItem" then
			Trade.AddItem(self, Updater, TradeInfoListToUpdate, ValueToUpdate)
		elseif UpdateType == "Coins" or UpdateType == "Gems" then
			TradeInfoListToUpdate[UpdateType] = UpdatedValue
		end
	end
end

-- // DELETE
function Trade.RemoveItem(key: string | {}, Updater: Player, TraderInfo: table, ValueId: string)
	local self = Checker(key)
	local ValueIndex = Trade.GetItemFromList(self, TraderInfo, ValueId)
	local UpdaterOwnsItem, ItemInformation = Trade.GetItemFromInventory(self, Updater, ValueId)

	if ValueIndex then
		table.remove(TraderInfo, ValueIndex)
	else
		warn("Index does not exist and cannot be removed from" .. Updater .. "'s Traderinfo table")
	end
end

function Trade.CancelTrade(key: string | {})
	local self = Checker(key)
	local TradeService = Knit:GetService("TradeService")
	Trade[self.Host] = nil

	TradeService.Client.Trade.CancelTrade:Fire(self.Host)
	TradeService.Client.Trade.CancelTrade:Fire(self.Recipient)
end

return Trade
