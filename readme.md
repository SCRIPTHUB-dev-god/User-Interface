# load ui
```luau
loadstring(game:HttpGet("https://raw.githubusercontent.com/SCRIPTHUB-dev-god/wave-ui/refs/heads/main/main.lua"))()
```

```luau
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/SCRIPTHUB-dev-god/wave-ui/refs/heads/main/main.lua"))()

library:toggleui({
	title = "Buka Menu"
})

local window = library:window({
	title = "HCL Hub",
	desc = "V7 Update Mobile",
	footer = "Developer Team v1.0"
})

local mainTab = window:createtab({
	title = "Utama"
})

local settingTab = window:createtab({
	title = "Pengaturan"
})

local leftGroup = mainTab:groupbox({
	title = "Fitur Player",
	show = true,
	position = "left"
})

local rightGroup = mainTab:groupbox({
	title = "Informasi",
	show = true,
	position = "right"
})

leftGroup:createtoggle({
	title = "Inf Jump",
	default = false,
	callback = function(val)
		print("Inf Jump:", val)
	end
})

leftGroup:createslider({
	title = "Speed",
	min = 16,
	max = 200,
	default = 16,
	callback = function(val)
		print("Speed set:", val)
	end
})

rightGroup:createlabel({
	title = "User: Premium"
})

rightGroup:createdivider()

rightGroup:createbutton({
	title = "Hancurkan UI",
	callback = function()
		print("Tombol keluar dipicu")
	end
})
```
