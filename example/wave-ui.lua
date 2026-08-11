local library = loadstring(game:HttpGet("https://github.com/SCRIPTHUB-dev-god/User-Interface/releases/latest/download/wave-ui.lua"))()

local window = library:CreateWindow({
	title = "example hub",
	desc = "this a good ui library",
	footer = "wave ui: v1.6",
	opened = true,
	info = false,
	transparency = 0.12,
})

window:SetMovingText("example hub v1.6")

window:AddTag({
    title = "can click",
    canclicked = true,
    callback = function()
        library:Addnotification({
            title = "test notif",
            desc = "working",
            duration = 3
        })
    end
})

window:AddTag({
    title = "dont clicked",
    canclicked = false,
})


local Tab1 = library:CreateTab("main")
local Tab2 = library:CreateTab("misc")
local Tab3 = library:CreateTab("esp")

local leftGroup1 = Tab1:CreateGroupBox("main farm", "left", "open")
local rightGroup1 = Tab1:CreateGroupBox("Setup farm", "right", "close")
local allsideGroup1 = Tab1:CreateGroupBox("stats", "allside", "open")

local leftGroup2 = Tab2:CreateGroupBox("setting", "left", "open")
local rightGroup2 = Tab2:CreateGroupBox("Target Setup", "right", "open")
local allsideGroup2 = Tab2:CreateGroupBox("Subsystem Router", "allside", "open")

local leftGroup3 = Tab3:CreateGroupBox("Self Options", "left", "open")
local rightGroup3 = Tab3:CreateGroupBox("Target Setup", "right", "open")
local allsideGroup3 = Tab3:CreateGroupBox("Subsystem Router", "allside", "open")

local subTab1 = allsideGroup1:tabbox("view stats")
local subTab2 = allsideGroup1:tabbox("Set stats")

local subTab3 = leftGroup2:tabbox("perfomance")
local subTab4 = leftGroup2:tabbox("ui")

leftGroup1:CreateButton("reset", function()
	print("Teleporting...")
end)

leftGroup1:CreateDivider()
leftGroup1:CreateLabel("start farm")

leftGroup1:CreateToggle("level farm", false, function(state)
	library:Addnotification({
	    title = "level farm on",
        desc = "tween the target",
        duration = 3
    })
end)

leftGroup1:CreateDivider("warning")

leftGroup1:CreateParagraph({
    title = "you can baned roblox",
    desc = "dont use this script in public server",
})

rightGroup1:CreateLabel("setting farm")

rightGroup1:CreateDropdown({
	text = "fly mode farm",
	list = {"tween", "Teleport", "cframe"},
	multi = false,
	callback = function(selection)
		print("Selected priorities:")
		for i, v in pairs(selection) do
			print(i, v)
		end
	end
})

rightGroup1:CreateSlider("tween speed", 16, 500, 16, function(value)
	
end)

rightGroup1:CreateInput("bring npc", "min bring npc", function(text, enter)
	print("Input submitted:", text, "Enter key:", enter)
end)

subTab1:CreateParagraph({
    title = "your stats",
    desc = "fps : 60A\nplayer : 10",
})

local sub1 = subTab1:CreateButton("refrest", function()
	print("refresing...")
end)

sub1:CreateButton("anti lag set", function()
	print("loaded")
end)

subTab2:CreateCheckbox("no fog", true, function(state)
	print("deleting fog:")
end)

subTab2:CreateCheckbox("no animation player", false, function(state)
	print("deleting animation")
end)

subTab2:CreateDropdown({
	text = "select npc",
	list = {"dummy", "which", "monster"},
	multi = true,
	callback = function(selection)
		print("Selected priorities:")
		for i, v in pairs(selection) do
			print(i, v)
		end
	end
})

subTab4:CreateColorpicker("ui color", Color3.fromRGB(0,140,255), function() end)
subTab4:CreateKeybind("G", function()
end)
