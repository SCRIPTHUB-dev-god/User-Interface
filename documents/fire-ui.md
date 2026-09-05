# fire ui library
**get library**

**select version**
```luau
local version = "v1.0.1"
local library = loadstring(game:HttpGet("https://github.com/SCRIPTHUB-dev-god/User-Interface/releases/download/..version../fire-ui.lua"))()
```
**lastest**
```luau
local library = loadstring(game:HttpGet("https://github.com/SCRIPTHUB-dev-god/User-Interface/releases/latest/download/fire-ui.lua"))()
```
---
**window**
```luau
local window = library:window({
    title = "Premium Hub Mobile",
    desc = "v1.0.0",
    transparent = 0.15,
    icon = "terminal", -- or rbxassetid
    CanAutoSave = true,
    theme = "neon",
    fileName = "MyPremiumConfig",
    autoshow = true,
    addbacksound = true
})
```
**theme**

`dark`,`neon`,`ocean`
`golden`,`light`,`fire`
`crimson`

```luau
library:CreateTheme({
    name = "Ametis",
    MainBG = Color3.fromRGB(24,24,26),
    HeaderBG = Color3.fromRGB(15,15,15),
    Stroke = Color3.fromRGB(55,55,60),
    ButtonBG = Color3.fromRGB(36,36,40),
    SectionBG = Color3.fromRGB(30,30,33),
    Accent = Color3.fromRGB(140,140,140),
    IconCl = Color3.fromRGB(200,200,200)
})
```

**icon support**

**[lucide icon](https://lucide.dev/icons/)**

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
**toggle ui set**
```luau
window:SetToggleUi({
    title = "fire ui",
    icon = "snowflake"
})
```
**tab**
```luau
local tabMain = window:AddTab("Main", "code")
```
---
# utility
**section**
```luau
tabMain:section({
    title = "Combat",
    icon = "sword",
    opened = true
})
```
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
Tab:AddDivider("divider") -- for main tab and section
```
**title**
```luau
window:AddTitle({
     Title = "Combat",
     Size = 9
}) -- work in tab, section, tabbox


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
    Color = "Red" -White,Gray,Red,Blue,Green,Purple,Pink
     Button = {
        Title = "Click",
        Callback = function()
            
        end
    }
})
```
SetDesc
``prgf:SetDesc("halo")``
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
