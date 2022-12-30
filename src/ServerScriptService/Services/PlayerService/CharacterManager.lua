--[[
CharacterManager

    A short description of the module.

SYNOPSIS

    -- Lua code that showcases an overview of the API.
    local foobar = CharacterManager.TopLevel('foo')
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

-- Implementation of CharacterManager.

--// Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Module
local CharacterManager = {}

--// Spawns
local Spawns = workspace.Spawns or warn("No 'Spawns' folder in workspace")

function CharacterManager.Spawn(Model: Model) 
    local Spawn: SpawnLocation = Spawns:GetChildren()[math.random(1, #Spawns:GetChildren())]
    Model:PivotTo(Spawn.CFrame * CFrame.new(0, 5.5, 0))

    Model.Parent = workspace:WaitForChild('Players')
end

return CharacterManager
