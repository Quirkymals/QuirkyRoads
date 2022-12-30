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

--// Animations.
local Animation = {
    Cat = require(script.Cat),
    Chick = require(script.Chick),
    Dog = require(script.Dog),
    Dove = require(script.Dove),
}


function Animation.findById(string)
    
end


return Animation