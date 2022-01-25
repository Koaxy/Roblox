--[[ Variables ]]--

local Mercury = loadstring(game:HttpGet("https://raw.githubusercontent.com/deeeity/mercury-lib/master/src.lua"))()

local player = game:GetService("Players").LocalPlayer
local root

local event = game:GetService("ReplicatedStorage").Networking.Hoops


--[[ ]]
local locations = {
    ["1000 Steps"] = CFrame.new(149, 104, 939),
    ["900 Steps"] = CFrame.new(224, 104, 573),
    ["600 Steps"] = CFrame.new(-6977, 15, 4203),
    ["150 Steps"] = CFrame.new(-111, 104, 544),
    ["Infer City"] = CFrame.new(-1088, 22, -6591),
    ["1500 Steps"] = CFrame.new(8217, 283, 707),
    ["1250 Steps"] = CFrame.new(7570, 283, 710),
    ["2000 Steps"] = CFrame.new(8594, 377, 1651),
    ["Space City"] = CFrame.new(7982, 283, 1132),
    ["Speed Desert"] = CFrame.new(453, -821, 738)
}

local settings = {
    farming = false,
    collecting = false
}

--[[ Functions ]]--

local function charadded(char)
    root = char:WaitForChild("HumanoidRootPart")
    char:WaitForChild("Humanoid").Died:Connect(function()
        root = nil
    end)
end



local root = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart


local function collect()
    repeat task.wait()
        for i, v in next, workspace.ballsFolder.Zone1:GetDescendants() do
            if settings.collecting == false then
                break
            elseif root and v:FindFirstChildOfClass("TouchTransmitter") then
                root.CFrame = v.CFrame
                task.wait(0.25)
            end
        end
	until settings.collecting == false
end

local function farm()
    repeat task.wait()
        for i, v in next, workspace.Rings:GetChildren() do
            if settings.farming == false then
                break
            elseif root and string.find(v.hoopGui.rewardLabel.Text, "Steps") then
                workspace.Gravity = 0
                root.CFrame = v.CFrame * CFrame.new(0, 0, 10)
                game:GetService("TweenService"):Create(root, TweenInfo.new(1), {
                    CFrame = v.CFrame * CFrame.new(0, 0, -10)
                }):Play()
                task.wait(0.5)
                event:FireServer(v.Name)
                workspace.Gravity = 196.2
            end
        end
    until settings.farming == false
end

local function keytoarray(tab)
	local array = {}
	for i, v in next, tab do
		array[#array + 1] = i
	end
	return array
end

--[[ Setup ]]--

if player.Character then
    charadded(player.Character)
end

player.CharacterAdded:Connect(charadded)

--[[ GUI ]]--

local GUI = Mercury:Create({
    Name = "Speed",
    Size = UDim2.fromOffset(600, 400),
    Theme = Mercury.Themes.Dark,
    Link = "https://github.com/deeeity/mercury-lib"
})


local TeleportsTab = GUI:Tab({
    Name = "Teleports",
    Icon = "rbxassetid://8621820051"
})




local Tab = GUI:Tab({
    Name = "Auto Farm",
    Icon = "rbxassetid://8621820275"
})


--[[ Auto Farm Toggle ]]
Tab:Toggle({
    Name = "Auto Collect",
    StartingState = false,
    Description = "Collects and Crystals and Diamonds",
    Callback = function(state) 
    settings.collecting = state
		if state then
			collect()
		end
    end
})



Tab:Toggle({
    Name = "Auto Farm Hoops",
    StartingState = false,
    Description = "Goes around each hoop collecting the values",
    Callback = function(state)
        settings.farming = state
        if state then
            farm()
        end
    end
})
--[[ Auto Farm Toggle end ]]

TeleportsTab:Dropdown({
    Name = "Teleports",
    StartingText = "Location",
    Description = "Teleport to a location",
    Items = keytoarray(locations),
    Callback = function(item)
		if root then
			root.CFrame = locations[item]
		end
	end
})
