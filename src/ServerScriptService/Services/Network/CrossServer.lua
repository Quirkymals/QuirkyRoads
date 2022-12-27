--[[
CrossServer

    A short description of the module.

SYNOPSIS

    -- Lua code that showcases an overview of the API.
    local foobar = CrossServer.TopLevel('foo')
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

-- Implementation of CrossServer.

--// Services
local MessagingService = game:GetService("MessagingService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Knit
local Knit = require(ReplicatedStorage.Packages.Knit)

--// module
local CrossServer = {}

--// Variables
local MESSAGING_TOPICS = {
	Invite = "InviteFriend",
}

function CrossServer.GetUserNameFromId(UserId: number)
	return Players:GetNameFromUserIdAsync(UserId)
end

function CrossServer.Subscriptions(player: Player)
	local subscribeSuccess, subscribeConnection = pcall(function()
		return MessagingService:SubscribeAsync(MESSAGING_TOPICS.Invite, function(message)
			local targetUserId = tonumber(message.data)

			if targetUserId == player.UserId then
				CrossServer.Service.Client.Invite:Fire(player, CrossServer.GetUserNameFromId(targetUserId))
			end
		end)
	end)
	if subscribeSuccess then
		player.AncestryChanged:Connect(function()
			subscribeConnection:Disconnect()
		end)
	else
		print(subscribeConnection)
	end
end

function CrossServer.Invite(player: Player, friend: number)
	local publishSuccess, publishResult = pcall(function()
		local message = tostring(player.UserId)
		MessagingService:PublishAsync(MESSAGING_TOPICS.Invite, message)
	end)
	if not publishSuccess then
		print(publishResult)
	end
end

function CrossServer.PlayerAdded(player: Player)
	CrossServer.Subscriptions(player)
end

return CrossServer
