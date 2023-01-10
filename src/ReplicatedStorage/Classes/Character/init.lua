--[[
Character

    A short description of the module.

SYNOPSIS

    -- Lua code that showcases an overview of the API.
    local foobar = Character.TopLevel('foo')
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

-- Implementation of Character.

--// Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Modules
local Modules = ReplicatedStorage.Modules

--// Feel
local Feel = require(Modules.Feel)
local Particles = Feel.Particles

local Cloud = ReplicatedStorage.Assets:FindFirstChild("Cloud")

--// Types
export type Character = {
	_Player: Player,
	_Animal: string,
	_Character: Model,
	_Humanoid: Humanoid,
	_PrimaryPart: MeshPart | Part,

	Connections: { string: RBXScriptConnection },
}

--// Class
local Character = {}
Character.__index = Character

function Character.new(Player: Player, _Character: Model, Animal: string)
	local info = {
		_Player = Player,
		_Animal = Animal,
		_Character = _Character,
		_Humanoid = _Character:WaitForChild("Humanoid"),
		_PrimaryPart = _Character:WaitForChild("HumanoidRootPart"),

		Connections = {},
	}
	setmetatable(info, Character)
	return info
end

function Character:Listen()
	local Humanoid: Humanoid = self._Humanoid
	local PrimaryPart: MeshPart | Part = self._Character:WaitForChild("HumanoidRootPart")

	self.Connections["Died"] = Humanoid.Died:Connect(function()
		-- Particles.Died(self._Particles)
		Particles.Destroy(self._Particles)

		self:Destroy()
	end)
end

function Character:AddParticles()
	local _Particles: Particles.ParticleClass = Particles.new(self._Player, self._Humanoid, Cloud)
	self._Particles = _Particles

	Particles.Toggle(self._Particles, true)
end

function Character:Init()
	self:AddParticles()
	self:Listen()
end

function Character:Disconnect()
	for _, c: RBXScriptConnection in pairs(self.Connections) do
		c:Disconnect()
	end
end

function Character:Destroy()
	self:Disconnect()

	setmetatable(self, nil)
	table.clear(self)
	table.freeze(self)
end

return Character
