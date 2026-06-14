# load ui
```luau
loadstring(game:HttpGet("https://raw.githubusercontent.com/SCRIPTHUB-dev-god/wave-ui/refs/heads/main/main.lua"))()
```

```luau
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/SCRIPTHUB-dev-god/wave-ui/refs/heads/main/main.lua"))()

library:SetTopTags({"MAIN", "VIP", "7D"})

local window = library:CreateWindow({
	title = "New Premium Hub",
	desc = "VVIP Client Version",
	footer = "wave ui: v1.4 patched",
	open = true
})

local mainTab = library:CreateTab("Main Features")

local leftGroup = mainTab:CreateGroupBox("Left Frame", "left", "open")
local rightGroup = mainTab:CreateGroupBox("Right Frame", "right", "open")
local allsideGroup = mainTab:CreateGroupBox("Full Frame", "allside", "open")

local groupTabs = allsideGroup:CreateTabs()
local subTab1 = groupTabs:CreateTab("Combat")
local subTab2 = groupTabs:CreateTab("Visuals")

subTab1:CreateButton("Kill All Players", function()
	print("Executing Kill All...")
end)

subTab1:CreateToggle("Aimbot", false, function(state)
	print("Aimbot status:", state)
end)

subTab2:CreateToggle("Player ESP", false, function(state)
	print("ESP status:", state)
end)

subTab2:CreateColorPicker("ESP Color", Color3.fromRGB(0, 255, 120), function(color)
	print("Color changed")
end)

leftGroup:CreateSlider("Walkspeed", 16, 250, 16, function(value)
	print("Speed changed to:", value)
end)

rightGroup:CreateDropdown("Teleport to", {"Spawn", "Shop", "Arena"}, "Spawn", function(selected)
	print("Teleporting to:", selected)
end)

```
