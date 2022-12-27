--[[
PersonalMessage

    A short description of the module.

SYNOPSIS

    -- Lua code that showcases an overview of the API.
    local foobar = PersonalMessage.TopLevel('foo')
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

-- Implementation of PersonalMessage.

--// Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Knit
local Knit = require(ReplicatedStorage.Packages.Knit)

--// module
local PersonalMessage = {}

function PersonalMessage.new(Author: Player, Recipient: Player, Message: string)
	local RequestService = Knit.GetService("RequestService")
	RequestService.PersonalMessage:Fire(Recipient, Author, Message)
end

function PersonalMessage.Objected(Recipient: Player, Author: Player, Message: string)
	local RequestService = Knit.GetService("RequestService")
	RequestService.PersonalMessageObjected:Fire(Author, Recipient, Message)
end

return PersonalMessage
