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
	opened = true,
	info = false,
	transparency = 0.12,
})
```
**tag**
```luau
window:AddTag({
    title = "Tester",
    canclicked = true,
    callback = function()
        
    end
})
```
**notification**
```lua
library:Addnotification({
    title = "Warning",
    desc = "Low health!",
    duration = 5
})
```
---
# utility
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
**set moving text**
```lua
window:SetMovingText("wave ui v1.6")
```
---
# element
**button**
```luau
leftGroup:CreateButton("Teleport to Base", function()
	print("Teleporting...")
end)
```
**sub button**
```luau
local sub = leftGroup:CreateButton("Teleport to Base", function()
	print("Teleporting...")
end)

sub:CreateButton("Teleport to player", function()
	print("Teleporting...")
end)
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
**paragraph**
```lua
rightGroup:CreateParagraph({
    title = "just a paragraph",
    desc = "new element in the library",
})
```
**label**
```lua
rightGroup:CreateLabel("test label")
```
**keybind**
```lua
rightGroup:CreateKeybind("G", function()
end)
```
**color picker**
```lua
leftGroup:CreateColorpicker("Accent", Color3.fromRGB(0,140,255), function() end)
```
**divider**
```luau
leftGroup:CreateDivider("divider") -- or () simple
```
---
# tutorial
place load library on top and window in down load library
place tag or not If not, the search bar will still be there. If you add a tag, the search bar will not be there.
place tab and group box or tabbox first the new element
