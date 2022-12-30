--[[
EntityCompression

	A short description of the module.

SYNOPSIS

	-- Lua code that showcases an overview of the API.
	local foobar = EntityCompression.TopLevel('foo')
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

-- Implementation of EntityCompression.

--// Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Modules
local Math = ReplicatedStorage.Modules.Math
local Quaternion = require(Math.Quaternion)

--// Class
local EntityCompressor = {}
EntityCompressor.__index = EntityCompressor

function EntityCompressor.new()
	local self = setmetatable({}, EntityCompressor)
	return self
end

function EntityCompressor:compress(entity)
	local data = {}

	data.x = entity.Position.X
	data.y = entity.Position.Y
	data.z = entity.Position.Z
	data.vx = entity.LinearVelocity.X
	data.vy = entity.LinearVelocity.Y
	data.vz = entity.LinearVelocity.Z
	data.rx = entity.Orientation.X
	data.ry = entity.Orientation.Y
	data.rz = entity.Orientation.Z
	-- data.rw = entity.Rotation.W
	data.animation = entity.Animation
	return data
end

function EntityCompressor:decompress(data)
	local entity = {}
	entity.Position = Vector3.new(data.x, data.y, data.z)
	entity.Velocity = Vector3.new(data.vx, data.vy, data.vz)
	-- entity.Rotation = Quaternion.new(data.rx, data.ry, data.rz, data.rw)
	entity.Animation = data.animation
	return entity
end

return EntityCompressor
