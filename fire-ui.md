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
`golden`,`light`,`fire`

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
local tab = window:AddTab("main")
```
# utility
**section**
```luau
local mainBox = home:AddSection({
    title = "Main Status",
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
**set theme**
```luau
dark = {
        MainBG = Color3.fromRGB(24, 24, 26),
        HeaderBG = Color3.fromRGB(15, 15, 15),
        Stroke = Color3.fromRGB(55, 55, 60),
        ButtonBG = Color3.fromRGB(36, 36, 40),
        GroupBG = Color3.fromRGB(30, 30, 33),
        Accent = Color3.fromRGB(140, 140, 140)
    }
```
# element
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
    Callback = function(selected)
        print("hello world")
    end
})
```
**paragraph**
```luau
Tab:AddParagraph({
    Title = "Peringatan Sistem",
    Desc = "Berhati-hatilah saat mengubah pengaturan sensitif.",
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
    Title = "Keybind Serangan",
    Desc = "Ganti tombol eksekusi skill",
    Value = "E",
    Callback = function(key)
        print("Tombol serangan baru:", key)
    end
})
```
**Color picker**
```luau
Tab:AddColorpicker({
    Title = "Warna ESP Target",
    Desc = "Mengubah warna visualisasi musuh",
    Default = Color3.fromRGB(0, 255, 204),
    Callback = function(color)
        print("Warna baru yang dipilih:", tostring(color))
    end
})
```
