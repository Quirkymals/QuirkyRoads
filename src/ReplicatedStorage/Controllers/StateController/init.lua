--// Services
local ReplicatedStorage = game:GetService('ReplicatedStorage')

--// Modules

--// Knit
local Knit = require(ReplicatedStorage.Packages.Knit)

--// Controller
local StateController = Knit.CreateController { Name = "StateController" }

--// Variables
function StateController:KnitInit()
    
end

function StateController:KnitStart()
    -------------Variables-----------
    local StateManager = script:GetChildren()
    -------------Variables-----------
    -----------Initialize------------
    
    -----------Initialize------------
end

return StateController