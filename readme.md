# load ui
```luau
loadstring(game:HttpGet("https://raw.githubusercontent.com/SCRIPTHUB-dev-god/wave-ui/refs/heads/main/main.lua"))()
```

```
local Icarus = loadstring(game:HttpGet("https://raw.githubusercontent.com/SCRIPTHUB-dev-god/wave-ui/refs/heads/main/main.lua"))()
local win = Icarus:SetWindows({
    text = "My GUI",
    theme = "Dark",
    transparent = true,
    settransparent = 0.3,
    loadinggui = true
})
local tab = win:AddTab({text = "Main", icon = "rbxassetid://..."})
tab:AddButton({text = "Click", callback = function() end})
```
