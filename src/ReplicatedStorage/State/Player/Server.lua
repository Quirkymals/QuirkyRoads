--[[
ServerPlayerState

    A short description of the module.

SYNOPSIS

    -- Lua code that showcases an overview of the API.
    local foobar = ServerPlayerState.TopLevel('foo')
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

-- Implementation of ServerPlayerState.

--// Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Basic State
local BasicState = require(ReplicatedStorage.Packages.BasicState)

--// Class
local ServerPlayerState = {}

function ServerPlayerState.new(Player: Player)
	local Config = Instance.new("Configuration", Player)

	local PlayerState = BasicState.new({

		Player = Player,
		Character = Player.Character,

		Config = Config,

		Animal = "",
        Animations = ""
	})

	Player.CharacterAdded:Connect(function(character)
		PlayerState:Set("Character", character)
	end)
	return PlayerState
end

return ServerPlayerState
