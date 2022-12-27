--// Services
local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

--// Core Modules
local Knit = require(ReplicatedStorage.Packages.Knit)

Knit.Shared = ReplicatedStorage.Shared
Knit.Modules = ReplicatedStorage.Modules
Knit.Classes = ReplicatedStorage.Classes

--// Knit Stuff
local Services = ServerScriptService.Services

--// Knit Shared Variables
Knit.Modules = ReplicatedStorage.Modules

Knit.AddServices(Services)
Knit.Start():catch(warn)