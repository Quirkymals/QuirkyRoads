local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

-- Load core module:
local Knit = require(ReplicatedStorage.Packages.Knit)

--// Systems
local States = ReplicatedStorage.State

Knit.Player = Players.LocalPlayer
Knit.Modules = ReplicatedStorage.Modules
Knit.Classes = ReplicatedStorage.Classes

local function AddState(StateModule: ModuleScript | Folder)
	if StateModule.Name:lower():find("server") then
		return
	end

	if StateModule:IsA("Folder") then
		for _, v in StateModule:GetChildren() do
			AddState(v)
		end

		return
	end

	Knit[StateModule.Name] = require(StateModule)

	if Knit[StateModule.Name].new and Knit[StateModule.Name].Init then
		Knit[StateModule.Name] = Knit[StateModule.Name].new()
		Knit[StateModule.Name]:Init()
	end
end

AddState(States)

--// Adding Conrollers
Knit.AddControllersDeep(ReplicatedStorage.Controllers)

-- Start Knit:
Knit.Start():catch(warn)
