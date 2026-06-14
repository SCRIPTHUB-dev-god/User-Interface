# load ui
```luau
loadstring(game:HttpGet("https://raw.githubusercontent.com/SCRIPTHUB-dev-god/wave-ui/refs/heads/main/main.lua"))()
```

```luau
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/SCRIPTHUB-dev-god/wave-ui/refs/heads/main/main.lua"))()

local window = library:CreateWindow({
	title = "New Premium Hub",
	desc = "VVIP Client Version",
	toggletitle = "Maximize UI",
	footer = "wave ui: v1.4 patched",
	open = true
})

library:SetTopTags({"MAIN", "VIP", "7D"})

local mainTab = window:CreateTab("Combat")
local miscTab = window:CreateTab("Misc")

local combatGroup = mainTab:CreateGroupBox("Main Frame", "allside", "open")
local subGroup = mainTab:CreateGroupBox("Sub Frame", "left", "close")

combatGroup:CreateLabel("Target Settings")
combatGroup:CreateParagraph("Pilih opsi di bawah ini untuk mengaktifkan fitur otomatisasi pada karakter.")
combatGroup:CreateDivider()

combatGroup:CreateButton("Kill All Players", function()
	print("Executing Kill All...")
end)

combatGroup:CreateToggle("Auto Farm Aura", false, function(state)
	print("Auto Farm status:", state)
end)

combatGroup:CreateSlider("Aimbot Smoothness", 1, 10, 5, function(value)
	print("Smoothness set to:", value)
end)

combatGroup:CreateDropdown("Target Bone", {"Head", "HumanoidRootPart", "Torso"}, function(selected)
	print("Targeting:", selected)
end)

combatGroup:CreateInput("Custom Speed Value", "Type speed...", function(text, enterPressed)
	print("Input submitted:", text, "Pressed Enter:", enterPressed)
end)

local multiTabBox = subGroup:tabbox()
local aimbotPage = multiTabBox:AddTab("Aimbot Config")
local espPage = multiTabBox:AddTab("ESP Config")

aimbotPage:CreateLabel("Aimbot Sub-Settings")
aimbotPage:CreateParagraph("Pengaturan sensitivitas tingkat lanjut.")
aimbotPage:CreateDivider()

aimbotPage:CreateButton("Reset Config", function()
	print("Config Reset!")
end)

aimbotPage:CreateToggle("Team Check", true, function(state)
	print("Team check:", state)
end)

aimbotPage:CreateSlider("FOV Radius", 30, 300, 100, function(value)
	print("FOV Radius:", value)
end)

aimbotPage:CreateDropdown("Prediction Mode", {"Low", "Medium", "High"}, function(mode)
	print("Prediction set to:", mode)
end)

aimbotPage:CreateInput("Blacklist User", "Username...", function(text)
	print("Blacklisted:", text)
end)

```
