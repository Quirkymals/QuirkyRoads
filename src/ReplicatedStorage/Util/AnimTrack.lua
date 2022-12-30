--[[
AnimTrack

    A short description of the module.

SYNOPSIS

    -- Lua code that showcases an overview of the API.
    local foobar = AnimTrack.TopLevel('foo')
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

-- Implementation of AnimTrack.

--// Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Class
local AnimTrack = {}
AnimTrack.__index = AnimTrack

--// Variables
local AnimationPrefix = "rbxassetid://"

function AnimTrack.new(Animator: Animator, Animation: Animation | string)
    
    local CurrentAnimation: Animation
    local CurrentAnimationTrack: AnimationTrack
    local Created = false

    if Animation:IsA'Animation' then
        CurrentAnimation = Animation
    else
        Created = true
        if tonumber(CurrentAnimation) then
            CurrentAnimation = Instance.new("Animation")
            CurrentAnimation.AnimationId = AnimationPrefix..CurrentAnimation
        else
            CurrentAnimation = Instance.new("Animation")
            CurrentAnimation.AnimationId = CurrentAnimation
        end
    end

    CurrentAnimationTrack = Animator:LoadAnimation(CurrentAnimation)

    CurrentAnimationTrack.Stopped:Connect(function()
        CurrentAnimation:Destroy()
    end)

    function CurrentAnimationTrack:PlayOnce(fadeTime: number, weight: number, Speed: number)
        local AnimationTime = CurrentAnimationTrack.Length
        local AnimationSpeed = Speed or CurrentAnimationTrack.Speed

        local MaxTime = AnimationTime/AnimationSpeed
        local StopTime = MaxTime*.995

        CurrentAnimationTrack:Play(fadeTime, weight, Speed)

        

        task.wait(MaxTime)

        CurrentAnimationTrack:Stop()
        
    end

    return CurrentAnimationTrack
end

function AnimTrack.SyncPlay()
    
end


return AnimTrack