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
	local Name = StateModule.Name == 'Client' and StateModule.Parent.Name..'State' or StateModule.Name
	
	if StateModule.Name:lower():find("server") then
		return
	end

	if StateModule:IsA("Folder") then
		for _, v in StateModule:GetChildren() do
			AddState(v)
		end

		return
	end

	Knit[Name] = require(StateModule)

	if Knit[Name].new and Knit[Name].Init then
		Knit[Name] = Knit[Name].new()
		Knit[Name]:Init()
	end
end

AddState(States)
print(Knit)

--// Adding Conrollers
Knit.AddControllersDeep(ReplicatedStorage.Controllers)

-- Start Knit:
Knit.Start():catch(warn)
