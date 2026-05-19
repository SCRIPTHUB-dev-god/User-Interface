# load ui
```luau
loadstring(game:HttpGet("https://raw.githubusercontent.com/SCRIPTHUB-dev-god/wave-ui/refs/heads/main/main.lua"))()
```

```luau
local Icarus = local Icarus = loadstring(game:HttpGet("https://raw.githubusercontent.com/SCRIPTHUB-dev-god/wave-ui/refs/heads/main/main.lua"))()

local win = Icarus:SetWindows({
    text = "My GUI",
    theme = "DeepBlue",
    size = UDim2.fromOffset(480, 300),
    settransparent = 0.2,
    autoshow = true,
    searchtopbar = true,
    loadinggui = true
})

local toggle1 = Icarus:AddToggleGui({
    text = "Main Toggle",
    geometry = "square"
})

local toggle2 = Icarus:AddToggleGui({
    text = "Secondary",
    geometry = "rectangle"
})

local tab = win:AddTab({text = "Home"})
local gb = tab:AddLeftGroupbox({text = "Settings"})
gb:AddTextbox({text = "Name", placeholder = "Enter name..."})
```
