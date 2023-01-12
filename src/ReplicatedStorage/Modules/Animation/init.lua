--[[
Animation

    A short description of the module.

SYNOPSIS

    -- Lua code that showcases an overview of the API.
    local foobar = Animation.TopLevel('foo')
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

-- Implementation of Animation.

--// Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Variables
local Animations = require(script.Animations)

local AnimationPrefix = "rbxassetid://"

--// module
local Animation = {}
local Cache = {}

function Animation.GetAnimations(Animal, QueriedAnimationName: string): Animation | Folder
	local CurrentDictionary = Animations[Animal]

	if not Cache[Animal] then
		Cache[Animal] = {}
	end

	if QueriedAnimationName then
		local QueriedAnimation = CurrentDictionary[QueriedAnimationName]
		if not QueriedAnimation then
			return warn(QueriedAnimationName .. " animation does not exist")
		else
			if not Cache[Animal][QueriedAnimationName] then
				Cache[Animal][QueriedAnimationName] = Instance.new("Animation")
				Cache[Animal][QueriedAnimationName].AnimationId = AnimationPrefix .. QueriedAnimation
			end
			return Cache[Animal][QueriedAnimationName]
		end
	else
		return CurrentDictionary
	end
end

return Animation
