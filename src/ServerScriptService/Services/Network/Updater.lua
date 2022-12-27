--[[
Updater

    A short description of the module.

SYNOPSIS

    -- Lua code that showcases an overview of the API.
    local foobar = Updater.TopLevel('foo')
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

-- Implementation of Updater.

--// Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Module
local Updater = {}

local function Checker(UpdaterObject)
	if type(UpdaterObject) ~= "table" and type(UpdaterObject) ~= "string" then
		error("First arg needs to be a table or string")
	end

	if type(UpdaterObject) == "string" then
		UpdaterObject = Updater[UpdaterObject]
	end

	return UpdaterObject
end

function Updater.new(key: string)
	local self = {
		key = key,
	}

	Updater[key] = self
	return self
end

return Updater
