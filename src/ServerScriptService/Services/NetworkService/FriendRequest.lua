--[[
FriendRequest

    A short description of the module.

SYNOPSIS

    -- Lua code that showcases an overview of the API.
    local foobar = FriendRequest.TopLevel('foo')
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

-- Implementation of FriendRequest.

type FriendRequest = {
	key: string,
	Creator: Player,
	Recipient: Player,
}

--// Services
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Knit
local Knit = require(ReplicatedStorage.Packages.Knit)

--// Module
local FriendRequest = {}

local function Checker(FriendRequestObject)
	if type(FriendRequestObject) ~= "table" and type(FriendRequestObject) ~= "string" then
		error("First arg needs to be a table or string")
	end

	if type(FriendRequestObject) == "string" then
		FriendRequestObject = FriendRequest[FriendRequestObject]
	end

	return FriendRequestObject
end

local function AuthenticateRequest(Creator: Player, Recipient: Player)
	local DataService = Knit.GetService("DataService")
	local Friends = DataService:GetFriends(Creator)

	if table.find(Friends, Recipient.UserId) or Creator:IsFriendsWith(Recipient.UserId) then
		return true, Creator.Name .. " is already friends with " .. Recipient.Name
	else
		return false
	end
end

function FriendRequest.new(Creator: Player, Recipient: Player): FriendRequest | nil
	local NetworkService = Knit.GetService("NetworkService")

	local OwnerIsFriendsWithRecipient: boolean, WarnMessage: string = AuthenticateRequest(Creator, Recipient)
	local RecipientName = (Recipient.DisplayName or Recipient.Name)
	local ReverseKey: string = Recipient.Name .. Creator.Name

	local self: FriendRequest = {
		key = Creator.Name .. Recipient.Name,
		Creator = Creator,
		Recipient = Recipient,
	}

	if FriendRequest[self.key] then
		NetworkService.Client.ObjectFriendRequest:Fire(
			Creator,
			"You already sent " .. RecipientName .. " a friend request."
		)
		return nil
	elseif FriendRequest[ReverseKey] then
		NetworkService.Client.ObjectFriendRequest:Fire(Creator, RecipientName .. " already sent you a friend request")
		return nil
	elseif OwnerIsFriendsWithRecipient then
		NetworkService.Client.ObjectFriendRequest:Fire(Creator, "You are already friends with" .. RecipientName)
		return nil
	end

	FriendRequest[self.key] = self
	NetworkService.Client.RecievedFriendRequest:Fire(
		Recipient,
		(Creator.DisplayName or Creator.Name) .. " sent you a friend request!"
	)
end

function FriendRequest.Confirm(key: string | {})
	local self: FriendRequest = Checker(key)

	local DataService = Knit.GetService("DataService")
	local Friends = DataService:GetFriends(self.Creator)

	table.insert(Friends, self.Recipient.UserId)
end

function FriendRequest.Accept(Recipient: Player, Creator: Player)
	local key = Creator.Name .. Recipient.Name
	FriendRequest.Confirm(Checker(key))
end

return FriendRequest
