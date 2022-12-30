--// Services
local Players = game:GetService("Players")
local MessagingService = game:GetService("MessagingService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Modules
local PersonalMessage = require(script.PersonalMessage)
local FriendRequest = require(script.FriendRequest)
local CrossServer = require(script.CrossServer)
local Trade = require(script.Trade)

--// Knit
local Knit = require(ReplicatedStorage.Packages.Knit)

--// Service
local NetworkService = Knit.CreateService({
	Name = "NetworkService",
	Client = {
		Invite = Knit.CreateSignal(),

		FriendRequest = Knit.CreateSignal(),
		AcceptFriendRequest = Knit.CreateSignal(),
		ObjectFriendRequest = Knit.CreateSignal(),
		RecievedFriendRequest = Knit.CreateSignal(),

		PersonalMessage = Knit.CreateSignal(),
		PersonalMessageObjected = Knit.CreateSignal(),

		Purchase = Knit.CreateSignal(),
		Sell = Knit.CreateSignal(),

		Update = Knit.CreateSignal(),
		Delete = Knit.CreateSignal(),

		Notifiy = Knit.CreateSignal(),

		CreateTrade = Knit.CreateSignal(),
		AcceptTrade = Knit.CreateSignal(),
		CancelTrade = Knit.CreateSignal(),
		UpdateTrade = Knit.CreateSignal(),
		ObjectTrade = Knit.CreateSignal(),

		TradeError = Knit.CreateSignal(),
	},
})

function NetworkService:KnitInit()
	Players.PlayerAdded:Connect(CrossServer.PlayerAdded)
end

function NetworkService:KnitStart()
	-------------Variables-----------
	local Signals = self.Client

	-------------Variables-----------
	-------------Classes-------------

	-------------Classes-------------
	-----------Initialize------------
	--// Cross Server Friends
	Signals.Invite:Connect(CrossServer.Invite)

	--// Trade Events
	Signals.CreateTrade:Connect(Trade.new)
	Signals.AcceptTrade:Connect(Trade.RequestAccepted)
	Signals.UpdateTrade:Connect(Trade.Update)
	Signals.CancelTrade:Connect(Trade.CancelTrade)

	--// Friend Request
	Signals.FriendRequest:Connect(FriendRequest.new)
	Signals.AcceptFriendRequest:Connect(FriendRequest.Accept)

	--// Personal Messages
	Signals.PersonalMessage:Connect(PersonalMessage.new)
	Signals.PersonalMessageObjected:Connect(PersonalMessage.Objected)
	-----------Initialize------------
end

return NetworkService
