# fire ui library
**get library**
```luau
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/SCRIPTHUB-dev-god/User-Interface/refs/heads/main/library/fire-ui.lua"))()
```
**window**
```luau
local window = library:window({
    title = "Premium Hub Mobile",
    desc = "v1.2.5",
    transparent = 0.15,
    theme = "neon"
})
```
**theme**
`dark`,`neon`,`ocean`
`golden`,`light`
**tag**
```luau
window:AddTag({
    title = "Click Me",
    color = Color3.fromRGB(180, 30, 30),
    getclick = true,
    callback = function()
        print("hello world")
    end
})
```
**tab**
```luau
local home = window:AddTab("Home")
```
# utility
**group box**
```luau
local mainBox = home:AddGroupBox({
    title = "Main Status",
    side = "left",
    open = true
})
```
**notification**
```luau
library:Notification({
    title = "Premium Mobile Hub Loaded",
    desc = "hello world",
    duration = 5
})
```
