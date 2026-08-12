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
    icon = "terminal",
    theme = "neon",
    autoshow = true,
    addbacksound = true
})
```
**theme**

`dark`,`neon`,`ocean`
`golden`,`light`,`fire`

**icon support**

`apple`,`clipboard`,`code`,`copy`,`eye`
`folder`,`globe`,`home`,`info`,`key`
`laptop`,`rocket`,`search`,`server`
`settings`,`shield`,`sprout`,`star`
`sword`,`swords`,`terminal`,`user`

**tag**
```luau
window:AddTag({
    title = "Click Me",
    icon = "globe",
    color = Color3.fromRGB(180, 30, 30),
    getclick = true,
    callback = function()
        print("hello world")
    end
})
```
**tab**
```luau
local tabMain = window:AddTab("Main", "code")
```
# utility
**Tabbox**
```luau
local tab = tabMain:AddTabbox()
local Mainbox = tab:AddTab("Main")
```
**notification**
```luau
library:Notification({
    title = "Premium Mobile Hub Loaded",
    desc = "hello world",
    duration = 5
})
```
**divider**
```luau
window:AddDivider() -- for tab
Tab:AddDivider() -- for main tab and section
```
# element
**button**
```luau
Tab:Addbutton({
    title = "button",
    desc = "click button",
    callback = function()
        print("hello world")
    end
})
```
**toggle**
```luau
Tab:Addtoggle({
    title = "Auto Farm Gold",
    desc = "Mengaktifkan fungsi perulangan otomatis",
    value = false,
    callback = function(state)
        print("Status Auto Farm:", state)
    end
})
```
**slider**
```luau
Tab:AddSlider({
    Title = "Kecepatan Karakter",
    Desc = "Mengatur WalkSpeed pemain",
    Step = 1,
    Value = {Min = 16, Max = 250, Default = 16},
    Callback = function(value)
        print("hello world")
    end
})
```
**dropdown**
```luau
Tab:AddDropdown({
    Title = "mode",
    Desc = "choose value",
    Values = {"Lobby", "Farm Zone", "VIP Room", "Shop"},
    Value = {"Lobby"},
    Multi = false,
    Search = true,
    Callback = function(selected)
        print("hello world")
    end
})
```
**paragraph**
```luau
Tab:AddParagraph({
    Title = "this a paragraph",
    Desc = "set this element as you like",
    Color = "Red"
})
```
**input**
```luau
Tab:AddInput({
    Title = "Custom Teleport Speed",
    Desc = "Masukkan angka delay perpindahan",
    Value = "0.5",
    Callback = function(text)
        print("Delay diubah menjadi:", text)
    end
})
```
**keybind**
```luau
Tab:AddKeybind({
    Title = "choose Keybind",
    Desc = "what your selected keybind",
    Value = "E",
    Callback = function(key)
        print("hello world")
    end
})
```
**Color picker**
```luau
Tab:AddColorpicker({
    Title = "choose color",
    Desc = "blue is best color",
    Default = Color3.fromRGB(0, 255, 204),
    Callback = function(color)
        print("hello world", tostring(color))
    end
})
```
