# Fluriore UI Documentation

## Loading the Library
```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Mc4121ban/Fluriore-UI/main/source.lua"))()
```

## Creating a Window
```lua
local Window = Library:MakeGui({
    NameHub = "Example Hub",
    Description = "Example Description",
    Color = Color3.fromRGB(255,0,255)
})

--[[
NameHub = <string> - The main title displayed at the top of the UI.
Description = <string> - Smaller description text displayed under the title.
Color = <Color3> - Accent/theme color of the entire UI.
]]
```

## Creating a Tab
```lua
local Tab = Window:CreateTab({
    Name = "Main",
    Icon = "rbxassetid://16932740082"
})

--[[
Name = <string> - The text label of the tab.
Icon = <string> - Icon displayed beside the tab name (rbxassetid).
]]
```

## Creating a Section
```lua
local Section = Tab:AddSection("Main Features")

--[[
"title" = <string> - The label shown as a section header.
]]
```

## Paragraph
```lua
Section:AddParagraph({
    Title = "Information",
    Content = "This is a paragraph."
})

--[[
Title = <string> - Bold title text.
Content = <string> - The main body text under the paragraph title.
]]
```

## Button
```lua
Section:AddButton({
    Title = "Click Me",
    Content = "Runs a function",
    Callback = function()
        print("Button clicked")
    end
})

--[[
Title = <string> - Button text.
Content = <string> - Description under the button.
Callback = <function> - Function that runs when the button is pressed.
]]
```

## Toggle
```lua
Section:AddToggle({
    Title = "Toggle Option",
    Content = "Enable or disable",
    Default = false,
    Callback = function(value)
        print("Toggle:", value)
    end
})

--[[
Title = <string> - Toggle label.
Content = <string> - Description text.
Default = <bool> - Initial toggle state.
Callback = <function(bool)> - Called every time the toggle changes.
]]
```

## Slider
```lua
Section:AddSlider({
    Title = "WalkSpeed",
    Content = "Adjust your speed",
    Min = 10,
    Max = 50,
    Default = 16,
    Callback = function(value)
        print("Slider:", value)
    end
})

--[[
Title = <string> - Slider name.
Content = <string> - Description text.
Min = <number> - Minimum allowed value.
Max = <number> - Maximum allowed value.
Default = <number> - Starting value.
Callback = <function(number)> - Called whenever the slider value changes.
]]
```

## Input Field
```lua
Section:AddInput({
    Title = "Enter Text",
    Content = "Type something",
    Placeholder = "Write here...",
    Callback = function(text)
        print("Text:", text)
    end
})

--[[
Title = <string> - Input field label.
Content = <string> - Description text.
Placeholder = <string> - Gray placeholder text when empty.
Callback = <function(string)> - Called when text is entered.
]]
```

## Dropdown
```lua
Section:AddDropdown({
    Title = "Select Mode",
    Content = "Choose an option",
    Multi = false,
    Options = {"Easy", "Medium", "Hard"},
    Default = {},
    Callback = function(selected)
        print("Selected:", selected)
    end
})

--[[
Title = <string> - Dropdown name.
Content = <string> - Description text.
Multi = <bool> - If true, user can select multiple options.
Options = <table> - List of selectable values.
Default = <table> - Default selected values.
Callback = <function> - Returns selection:
    - <string> if Multi = false
    - <table> if Multi = true
]]
```

## Notification
```lua
Library:MakeNotify({
    Title = "Notification",
    Description = "Alert",
    Content = "This is a message",
    Color = Color3.fromRGB(255,100,100),
    Delay = 3
})

--[[
Title = <string> - Notification title.
Description = <string> - Small subtitle.
Content = <string> - Main text message.
Color = <Color3> - Notification highlight color.
Delay = <number> - Duration in seconds before disappearing.
]]
```
