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
local Animations = ReplicatedStorage.Animations

--// module
local Animation = {}

function Animation.GetAnimations(Animal, QueriedAnimationName: string): Animation | Folder
	local CurrentFolder = Animations[Animal]

	if QueriedAnimationName then
		local QueriedAnimation = CurrentFolder:FindFirstChild(QueriedAnimationName)
		if not QueriedAnimation then
			return warn(QueriedAnimationName .. " animation does not exist")
		else
			return QueriedAnimation:Clone()
		end
	else
		return CurrentFolder
	end
end

return Animation
