local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage.Packages

local Roact = require(Packages.Roact)
local RoactRodux = require(Packages.RoactRodux)

local RoactHooks = require(Packages.RoactHooks)
local RoactSpring = require(Packages.RoactSpring)

local createElement = Roact.createElement
local TextStroke = Roact.Component:extend("TextStroke")

local STUDIO_SCREEN_SIZE = Vector2.new(1366, 767) -- change 0, 0 to your studio resolution
local camera = workspace.CurrentCamera
local instanceAddedSignal = nil -- stores a connection

local function GetAverage(vector: Vector2): number
	return (vector.X + vector.Y) / 2
end

local studioAverage = GetAverage(STUDIO_SCREEN_SIZE)
local currentScreenAverage = GetAverage(camera.ViewportSize)

local function AdjustThickness(OriginalThickness: number)
	local ratio = OriginalThickness / studioAverage
	return currentScreenAverage * ratio
end

local function ModifyUiStrokes(...)
	currentScreenAverage = GetAverage(camera.ViewportSize) -- re-calculate the screen average as it could've changed
	return AdjustThickness(...)
end

-- ModifyUiStrokes()
-- camera:GetPropertyChangedSignal('ViewportSize'):Connect(ModifyUiStrokes)

function TextStroke:init(props)
	local ratio = (props.Thickness or 1) / studioAverage
	local Thickness = currentScreenAverage * ratio

	self:setState({
		Thickness = Thickness,
	})
end

function TextStroke:render()
	return createElement("UIStroke", {
		Color = self.props.Color or Color3.new(0, 0, 0),
		Thickness = self.state.Thickness or 1,
	})
end

function TextStroke:didMount()
	camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
		self:setState({
			Thickness = ModifyUiStrokes(self.props.Thickness or 1),
		})
	end)
end

return TextStroke
