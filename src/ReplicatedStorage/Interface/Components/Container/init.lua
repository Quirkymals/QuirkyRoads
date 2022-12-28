local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage.Packages

local Roact = require(Packages.Roact)
local RoactRodux = require(Packages.RoactRodux)

local RoactHooks = require(Packages.RoactHooks)
local RoactSpring = require(Packages.RoactSpring)

local createElement = Roact.createElement
local Container = Roact.Component:extend("MainContainer")

function Container:render()
	return createElement("Frame", {
		Size = UDim2.new(0, 400, 0, 300),
	})
end

return Container
