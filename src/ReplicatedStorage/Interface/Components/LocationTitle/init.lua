local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage.Packages

local Primitive = ReplicatedStorage.Interface.Components.Primitive

local Roact = require(Packages.Roact)
local RoactRodux = require(Packages.RoactRodux)

local RoactHooks = require(Packages.RoactHooks)
local RoactSpring = require(Packages.RoactSpring)

local Children = Roact.Children

local e = Roact.createElement
local LocationTitle = Roact.Component:extend("LocationTitle")

local TextStroke = require(Primitive.TextStroke)

function LocationTitle:init()
	self:setState({
		toggle = false,
		activated = false,
	})

	local toggle = self.state.toggle

	self.styles, self.api = RoactSpring.Controller.new({
		Size = UDim2.fromScale(0, 0),
		Rotation = -45,
		config = { tension = 100, friction = 8 },
	})
end

function LocationTitle:render()
	return e("Frame", {
		AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.fromScale(0.5, 0.05),
		Size = UDim2.fromScale(0.2, 0.1),

		BackgroundTransparency = 1,

		Active = self.state.activated,

		[Roact.Event.Changed] = function() end,

		[Children] = {
			e("UIAspectRatioConstraint", {
				AspectRatio = 4,
			}),

			e("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Rotation = self.styles.Rotation,
				Size = self.styles.Size,

				BackgroundTransparency = 1,

				[Children] = {
					e("TextLabel", {
						BackgroundTransparency = 1,
						Font = Enum.Font.FredokaOne,
						Size = UDim2.fromScale(1, 1),
						TextScaled = true,

						Text = self.props.Text or "QUIRKY ISLAND",
						TextColor3 = Color3.new(1, 1, 1),

						[Children] = {
							e(TextStroke, {
								Thickness = 6,
								Color = Color3.fromHex("47bcff"),
							}),
						},
					}),
				},
			}),
		},
	})
end

function LocationTitle:didMount()
	self.api:start({
		Size = UDim2.fromScale(1, 1),
		Rotation = 0,
	})
end

return LocationTitle
