# wave ui library
**get library**
```luau
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/SCRIPTHUB-dev-god/User-Interface/refs/heads/main/library/wave-ui.lua"))()
```
**window**
```luau
local window = library:CreateWindow({
	title = "Tester",
	desc = "this a good ui library",
	footer = "wave ui: v1.3",
	open = true
})
```
**tag**
```luau
library:SetTopTags({"MAIN", "VIP"})
```
**tab**
```luau
local Tab = library:CreateTab("Combat Frame")
```
**group box**
```luau
local leftGroup = Tab:CreateGroupBox("Self Options", "left", "open")
local rightGroup = Tab:CreateGroupBox("Target Setup", "right", "open")
local allsideGroup = Tab:CreateGroupBox("Subsystem Router", "allside", "open")
```
**tabbox**
```luau
local subTab1 = leftGroup:tabbox("Main Frame")
local subTab2 = leftGroup:tabbox("Secondary Frame")
```
# ================
# element
**button**
```luau
leftGroup:CreateButton("Teleport to Base", function()
	print("Teleporting...")
end)
```
**dual button**
```luau
leftGroup:CreateDualButton({
	Button1 = {
		Text = "Kill All",
		Callback = function()
			print("Kill All Triggered")
		end
	},
	Button2 = {
		Text = "Bring All",
		Callback = function()
			print("Bring All Triggered")
		end
	}
})
```
**toggle**
```luau
leftGroup:CreateToggle("Fly System", false, function(state)
	print("Fly state updated:", state)
end)
```
**check box**
```luau
leftGroup:CreateCheckbox("Silent Aim", true, function(state)
	print("Silent Aim status:", state)
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
rightGroup:CreateDropdown({
	text = "Hit Priority",
	list = {"Head", "HumanoidRootPart", "Torso"},
	multi = true,
	callback = function(selection)
		print("Selected priorities:")
		for i, v in pairs(selection) do
			print(i, v)
		end
	end
})
```
**divider**
```luau
leftGroup:CreateDivider()
```
