--[[
Npc

    A short description of the module.

SYNOPSIS

    -- Lua code that showcases an overview of the API.
    local foobar = Npc.TopLevel('foo')
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

-- Implementation of Npc.

--// Services
local ReplicatedStorage = game:GetService('ReplicatedStorage')


--// Basic State
local BasicState = require(ReplicatedStorage.Packages.BasicState)

--// Class
local Npc = {}
Npc.__index = Npc


function Npc.new()
    local info = {}

    info.State = BasicState.new({
        
    })    

    setmetatable(info, Npc)
    return info
end

function Npc:Init()
    
end


return Npc