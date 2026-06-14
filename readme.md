# wave ui library
**get library**
```luau
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/SCRIPTHUB-dev-god/wave-ui/refs/heads/main/library/wave-ui.lua"))()
```
**window**
```luau
local window = library:CreateWindow({
	title = "Premium Hub Tester",
	desc = "Full API Integration Framework Inside Mobile Screen",
	footer = "wave ui: v1.3 loaded",
	open = true
})
```
**tag**
```luau
library:SetTopTags({"MAIN", "VIP"})
```
**tab**
```luau
local combatTab = library:CreateTab("Combat Frame")
```
**group box**
```luau
local leftGroup = combatTab:CreateGroupBox("Self Options", "left", "open")
local rightGroup = combatTab:CreateGroupBox("Target Setup", "right", "open")
local allsideGroup = combatTab:CreateGroupBox("Subsystem Router", "allside", "open")
```
**tabbox**
```luau
local subTab1 = allsideGroup:tabbox("Main Frame")
local subTab2 = allsideGroup:tabbox("Secondary Frame")
```
# ==========
# element
**button**
```luau
leftGroup:CreateButton("Teleport to Base", function()
	print("Teleporting...")
end)
```
**toggle**
```luau
leftGroup:CreateToggle("Fly System", false, function(state)
	print("Fly state updated:", state)
end)
```
**slider**
```luau
leftGroup:CreateSlider("Walkspeed Multiplier", 16, 500, 16, function(value)
	print("Walkspeed adjusted:", value)
end)
```
**input**
```luau
rightGroup:CreateInput("Target Player", "Username here...", function(text, enter)
	print("Input submitted:", text, "Enter key:", enter)
end)
```
**dropdown**
```luau
rightGroup:CreateDropdown("Hit Priority", {"Head", "HumanoidRootPart", "Torso"}, function(selection)
	print("Dropdown selection:", selection)
end)
```
**divider**
```luau
leftGroup:CreateDivider()
```
