--[[
Prediction

    Class to predict movement on objects for smooth replication

SYNOPSIS

    -- Lua code that showcases an overview of the API.
    local foobar = Prediction.TopLevel('foo')
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

-- Implementation of Prediction.

--// Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// module
local Prediction = {}

function Prediction.Part(Part: Part)
	local CF = Part.CFrame
	local Direction = Part.CFrame.LookVector
	local Velocity = Part.AssemblyLinearVelocity
end

return Prediction
