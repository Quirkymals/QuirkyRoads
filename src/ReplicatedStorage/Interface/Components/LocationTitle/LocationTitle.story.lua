local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Roact = require(ReplicatedStorage.Packages.Roact)

local Rodux = require(ReplicatedStorage.Packages.Rodux)
local RoactRodux = require(ReplicatedStorage.Packages.RoactRodux)

local createElement = Roact.createElement

local Container = require(script.Parent)

return function(target)
	local ContainerUI = Roact.mount(createElement(Container), target)

	return function()
		Roact.unmount(ContainerUI)
	end
end
