local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

local oldGui = PlayerGui:FindFirstChild("PremiumMobileGui")
if oldGui then oldGui:Destroy() end

local library = {}
library.CurrentTheme = nil

local themes = {
    dark = {
        MainBG = Color3.fromRGB(24, 24, 26),
        HeaderBG = Color3.fromRGB(15, 15, 15),
        Stroke = Color3.fromRGB(55, 55, 60),
        ButtonBG = Color3.fromRGB(36, 36, 40),
        GroupBG = Color3.fromRGB(30, 30, 33),
        Accent = Color3.fromRGB(140, 140, 140)
    },
    neon = {
        MainBG = Color3.fromRGB(15, 12, 22),
        HeaderBG = Color3.fromRGB(8, 6, 12),
        Stroke = Color3.fromRGB(0, 255, 204),
        ButtonBG = Color3.fromRGB(28, 22, 40),
        GroupBG = Color3.fromRGB(22, 17, 32),
        Accent = Color3.fromRGB(255, 0, 127)
    },
    ocean = {
        MainBG = Color3.fromRGB(12, 22, 32),
        HeaderBG = Color3.fromRGB(6, 12, 18),
        Stroke = Color3.fromRGB(0, 150, 255),
        ButtonBG = Color3.fromRGB(20, 36, 52),
        GroupBG = Color3.fromRGB(16, 28, 42),
        Accent = Color3.fromRGB(0, 200, 255)
    },
    crimson = {
        MainBG = Color3.fromRGB(24, 14, 14),
        HeaderBG = Color3.fromRGB(14, 6, 6),
        Stroke = Color3.fromRGB(180, 30, 30),
        ButtonBG = Color3.fromRGB(40, 20, 20),
        GroupBG = Color3.fromRGB(32, 16, 16),
        Accent = Color3.fromRGB(255, 50, 50)
    },
    golden = {
        MainBG = Color3.fromRGB(24, 22, 18),
        HeaderBG = Color3.fromRGB(16, 14, 12),
        Stroke = Color3.fromRGB(40, 35, 30),
        GroupBG = Color3.fromRGB(33, 28, 24),
        Accent = Color3.fromRGB(255, 215, 0)
    },
    light = {
        MainBG = Color3.fromRGB(125, 125, 130),
        HeaderBG = Color3.fromRGB(95, 95, 100),
        Stroke = Color3.fromRGB(180, 180, 185),
        ButtonBG = Color3.fromRGB(145, 145, 150),
        GroupBG = Color3.fromRGB(110, 110, 115),
        Accent = Color3.fromRGB(245, 245, 245)
    },
    fire = {
        MainBG = Color3.fromRGB(25, 10, 5),
        HeaderBG = Color3.fromRGB(15, 5, 2),
        Stroke = Color3.fromRGB(255, 69, 0),
        ButtonBG = Color3.fromRGB(45, 18, 10),
        GroupBG = Color3.fromRGB(35, 14, 8),
        Accent = Color3.fromRGB(255, 140, 0)
    }
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PremiumMobileGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = PlayerGui

local NotifContainer = Instance.new("Frame", ScreenGui)
NotifContainer.Name = "NotifContainer"
NotifContainer.Size = UDim2.new(0, 250, 1, -20)
NotifContainer.Position = UDim2.new(1, -260, 0, 10)
NotifContainer.BackgroundTransparency = 1

local notifLayout = Instance.new("UIListLayout", NotifContainer)
notifLayout.FillDirection = Enum.FillDirection.Vertical
notifLayout.SortOrder = Enum.SortOrder.LayoutOrder
notifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
notifLayout.Padding = UDim.new(0, 8)

function library:Notification(notifOptions)
    notifOptions = notifOptions or {}
    local title = notifOptions.title or "Notification"
    local desc = notifOptions.desc or ""
    local duration = notifOptions.duration or 5
    local currentTheme = library.CurrentTheme or themes.dark

    local notifFrame = Instance.new("Frame", NotifContainer)
    notifFrame.Name = "Notif"
    notifFrame.Size = UDim2.new(1, 0, 0, 0)
    notifFrame.BackgroundColor3 = currentTheme.MainBG
    notifFrame.BackgroundTransparency = 0.1
    notifFrame.BorderSizePixel = 0
    notifFrame.ClipsDescendants = true
    notifFrame.AutomaticSize = Enum.AutomaticSize.Y

    local nCorner = Instance.new("UICorner", notifFrame)
    nCorner.CornerRadius = UDim.new(0, 8)

    local nStroke = Instance.new("UIStroke", notifFrame)
    nStroke.Color = currentTheme.Stroke
    nStroke.Thickness = 1.5
    nStroke.Transparency = 1

    local nPad = Instance.new("UIPadding", notifFrame)
    nPad.PaddingLeft = UDim.new(0, 10)
    nPad.PaddingRight = UDim.new(0, 10)
    nPad.PaddingTop = UDim.new(0, 8)
    nPad.PaddingBottom = UDim.new(0, 8)

    local titleLabel = Instance.new("TextLabel", notifFrame)
    titleLabel.Size = UDim2.new(1, 0, 0, 18)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 13
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.TextTransparency = 1

    local descLabel = Instance.new("TextLabel", notifFrame)
    descLabel.Size = UDim2.new(1, 0, 0, 0)
    descLabel.Position = UDim2.new(0, 0, 0, 20)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = desc
    descLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextSize = 11
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.TextWrapped = true
    descLabel.AutomaticSize = Enum.AutomaticSize.Y
    descLabel.TextTransparency = 1

    local function tween(obj, info, prop)
        return TweenService:Create(obj, info, prop)
    end

    local infoIn = TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    tween(notifFrame, infoIn, {BackgroundTransparency = 0.1}):Play()
    tween(nStroke, infoIn, {Transparency = 0}):Play()
    tween(titleLabel, infoIn, {TextTransparency = 0}):Play()
    tween(descLabel, infoIn, {TextTransparency = 0}):Play()

    task.delay(duration, function()
        local infoOut = TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
        local t1 = tween(notifFrame, infoOut, {BackgroundTransparency = 1})
        tween(nStroke, infoOut, {Transparency = 1}):Play()
        tween(titleLabel, infoOut, {TextTransparency = 1}):Play()
        tween(descLabel, infoOut, {TextTransparency = 1}):Play()
        t1:Play()
        t1.Completed:Connect(function()
            notifFrame:Destroy()
        end)
    end)
end

function library:window(options)
    options = options or {}
    local windowTitle = options.title or "library ui"
    local windowDesc = options.desc or "Premium v1.0"
    local bgTrans = options.transparent or 0
    local selectedTheme = options.theme or "dark"
    local currentTheme = themes[selectedTheme:lower()] or themes.dark
    library.CurrentTheme = currentTheme

    local window = {}
    window.Tabs = {}
    window.CurrentTab = nil
    window.ToggleKey = Enum.KeyCode.G
    local totalTags = 0

    function window:SetToggleKey(key)
        window.ToggleKey = key
    end

    local MainUI = Instance.new("Frame")
    MainUI.Name = "MainUI"
    MainUI.Size = UDim2.new(0, 560, 0, 360)
    MainUI.AnchorPoint = Vector2.new(0.5, 0.5)
    MainUI.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainUI.BackgroundColor3 = currentTheme.MainBG
    MainUI.BackgroundTransparency = bgTrans
    MainUI.BorderSizePixel = 0
    MainUI.Parent = ScreenGui

    local UIScale = Instance.new("UIScale")
    UIScale.Scale = 0.80
    UIScale.Parent = MainUI

    Instance.new("UICorner", MainUI).CornerRadius = UDim.new(0, 12)
    local MainStroke = Instance.new("UIStroke", MainUI)
    MainStroke.Color = currentTheme.Stroke
    MainStroke.Thickness = 2.5

    local Header = Instance.new("Frame", MainUI)
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 40)
    Header.BackgroundColor3 = currentTheme.HeaderBG
    Header.BackgroundTransparency = bgTrans
    Header.BorderSizePixel = 0

    Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 12)

    local Fix = Instance.new("Frame", Header)
    Fix.Size = UDim2.new(1, 0, 0, 12)
    Fix.Position = UDim2.new(0, 0, 1, -12)
    Fix.BackgroundColor3 = currentTheme.HeaderBG
    Fix.BackgroundTransparency = bgTrans
    Fix.BorderSizePixel = 0

    local profile = Instance.new("ImageLabel", Header)
    profile.Name = "Profile"
    profile.Size = UDim2.new(0, 28, 0, 28)
    profile.Position = UDim2.new(0, 8, 0.5, -14)
    profile.BackgroundColor3 = currentTheme.GroupBG
    profile.BackgroundTransparency = bgTrans
    profile.Image = "https://www.roblox.com/headshot-thumbnail/image?userId="..LocalPlayer.UserId.."&width=420&height=420&format=png"
    profile.BorderSizePixel = 0
    Instance.new("UICorner", profile).CornerRadius = UDim.new(1,0)
    local profileStroke = Instance.new("UIStroke", profile)
    profileStroke.Color = currentTheme.Stroke
    profileStroke.Thickness = 1

    local nameLabel = Instance.new("TextLabel", Header)
    nameLabel.Name = "PlayerDisplayName"
    nameLabel.Size = UDim2.new(0, 80, 0, 28)
    nameLabel.Position = UDim2.new(0, 42, 0.5, -14)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = LocalPlayer.DisplayName
    nameLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    nameLabel.Font = Enum.Font.GothamMedium
    nameLabel.TextSize = 11
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left

    local tabLabel = Instance.new("TextLabel", Header)
    tabLabel.Name = "ActiveTabLabel"
    tabLabel.Size = UDim2.new(0, 72, 0, 28)
    tabLabel.Position = UDim2.new(0, 135, 0.5, -14)
    tabLabel.BackgroundTransparency = 1
    tabLabel.Text = ""
    tabLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    tabLabel.Font = Enum.Font.GothamBold
    tabLabel.TextSize = 14
    tabLabel.TextXAlignment = Enum.TextXAlignment.Left
    tabLabel.ClipsDescendants = false
    tabLabel.TextScaled = true
    
    local tabLabelConstraint = Instance.new("UITextSizeConstraint", tabLabel)
    tabLabelConstraint.MaxTextSize = 14

    local vLine = Instance.new("Frame", Header)
    vLine.Name = "ProfileLine"
    vLine.Size = UDim2.new(0, 2.5, 1, -3)
    vLine.Position = UDim2.new(0, 210, 0, 2)
    vLine.BackgroundColor3 = currentTheme.Stroke
    vLine.BorderSizePixel = 0
    vLine.ZIndex = 5

    local VLine = Instance.new("Frame", Header)
    VLine.Name = "ProfileLine"
    VLine.Size = UDim2.new(0, 2.5, 1, -3)
    VLine.Position = UDim2.new(0, 130, 0, 2)
    VLine.BackgroundColor3 = currentTheme.Stroke
    VLine.BorderSizePixel = 0
    VLine.ZIndex = 5
    
    local xLine = Instance.new("Frame", Header)
    xLine.Name = "ProfileLine"
    xLine.Size = UDim2.new(0, 2.5, 1, -3)
    xLine.Position = UDim2.new(0, 375, 0, 2)
    xLine.BackgroundColor3 = currentTheme.Stroke
    xLine.BackgroundTransparency = 1
    xLine.BorderSizePixel = 0
    xLine.ZIndex = 5
    
    local headerStroke = Instance.new("Frame", Header)
    headerStroke.Name = "HeaderStroke"
    headerStroke.Size = UDim2.new(1, 0, 0, 2.5)
    headerStroke.Position = UDim2.new(0, 0, 1, -1)
    headerStroke.BackgroundColor3 = currentTheme.Stroke
    headerStroke.BorderSizePixel = 0
    headerStroke.ZIndex = 5

    local TagContainer = Instance.new("ScrollingFrame", Header)
    TagContainer.Name = "TagContainer"
    TagContainer.Size = UDim2.new(0, 155, 0, 24)
    TagContainer.Position = UDim2.new(0, 215, 0.5, -12)
    TagContainer.BackgroundTransparency = 1
    TagContainer.BorderSizePixel = 0
    TagContainer.ScrollBarThickness = 0
    TagContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    TagContainer.AutomaticCanvasSize = Enum.AutomaticSize.X
    TagContainer.ScrollingDirection = Enum.ScrollingDirection.X
    TagContainer.ClipsDescendants = true

    local tagLayout = Instance.new("UIListLayout", TagContainer)
    tagLayout.FillDirection = Enum.FillDirection.Horizontal
    tagLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tagLayout.Padding = UDim.new(0, 6)
    tagLayout.VerticalAlignment = Enum.VerticalAlignment.Center

    local LeftTabBar = Instance.new("Frame", MainUI)
    LeftTabBar.Name = "LeftTabBar"
    LeftTabBar.Size = UDim2.new(0, 2.75, 1, -40)
    LeftTabBar.Position = UDim2.new(0, 90, 0, 40)
    LeftTabBar.BackgroundColor3 = currentTheme.Stroke
    LeftTabBar.BorderSizePixel = 0
    LeftTabBar.ZIndex = 5

    local Sidebar = Instance.new("Frame", MainUI)
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 90, 1, -40)
    Sidebar.Position = UDim2.new(0, 0, 0, 40)
    Sidebar.BackgroundTransparency = 1

    local sideTitle = Instance.new("TextLabel", Sidebar)
    sideTitle.Name = "SideTitle"
    sideTitle.Size = UDim2.new(1, -12, 0, 20)
    sideTitle.Position = UDim2.new(0, 6, 0, 5)
    sideTitle.BackgroundTransparency = 1
    sideTitle.Text = windowTitle
    sideTitle.TextColor3 = Color3.new(1,1,1)
    sideTitle.Font = Enum.Font.GothamBold
    sideTitle.TextSize = 16
    sideTitle.TextXAlignment = Enum.TextXAlignment.Left
    sideTitle.TextScaled = true
    local sideTitleConstraint = Instance.new("UITextSizeConstraint", sideTitle)
    sideTitleConstraint.MaxTextSize = 16

    local sideDesc = Instance.new("TextLabel", Sidebar)
    sideDesc.Name = "SideDesc"
    sideDesc.Size = UDim2.new(1, -12, 0, 16)
    sideDesc.Position = UDim2.new(0, 6, 0, 24)
    sideDesc.BackgroundTransparency = 1
    sideDesc.Text = windowDesc
    sideDesc.TextColor3 = Color3.fromRGB(150,150,150)
    sideDesc.Font = Enum.Font.Gotham
    sideDesc.TextSize = 12
    sideDesc.TextXAlignment = Enum.TextXAlignment.Left
    sideDesc.TextScaled = true
    local sideDescConstraint = Instance.new("UITextSizeConstraint", sideDesc)
    sideDescConstraint.MaxTextSize = 12

    local sideLine = Instance.new("Frame", Sidebar)
    sideLine.Name = "SideLine"
    sideLine.Size = UDim2.new(1, 0, 0, 2.5)
    sideLine.Position = UDim2.new(0, 0, 0, 44)
    sideLine.BackgroundColor3 = currentTheme.Stroke
    sideLine.BorderSizePixel = 0
    sideLine.ZIndex = 5

    local ContentHolder = Instance.new("Frame", MainUI)
    ContentHolder.Name = "ContentHolder"
    ContentHolder.Size = UDim2.new(1, -91, 1, -40)
    ContentHolder.Position = UDim2.new(0, 91, 0, 40)
    ContentHolder.BackgroundTransparency = 1
    ContentHolder.ClipsDescendants = true

    local dragging, dragInput, dragStart, startPos
    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainUI.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    Header.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            MainUI.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    local resizeBtn = Instance.new("TextButton", MainUI)
    resizeBtn.Name = "ResizeButton"
    resizeBtn.Size = UDim2.new(0, 25, 0, 25)
    resizeBtn.Position = UDim2.new(1, 0, 1, 0)
    resizeBtn.AnchorPoint = Vector2.new(1, 1)
    resizeBtn.BackgroundTransparency = 1
    resizeBtn.Text = ""
    resizeBtn.ZIndex = 15

    local resizing, resizeStart, startSize
    resizeBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            resizing = true
            resizeStart = input.Position
            startSize = MainUI.Size
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    resizing = false
                end
            end)
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - resizeStart
            local newX = math.max(450, startSize.X.Offset + delta.X)
            local newY = math.max(280, startSize.Y.Offset + delta.Y)
            MainUI.Size = UDim2.new(0, newX, 0, newY)
        end
    end)

    local ToggleUI = Instance.new("Frame")
    ToggleUI.Name = "ToggleUI"
    ToggleUI.Size = UDim2.new(0, 135, 0, 36)
    ToggleUI.Position = UDim2.new(0.05, 0, 0.05, 30)
    ToggleUI.BackgroundColor3 = currentTheme.MainBG
    ToggleUI.BackgroundTransparency = bgTrans
    ToggleUI.BorderSizePixel = 0
    ToggleUI.Visible = false
    ToggleUI.Parent = ScreenGui

    Instance.new("UICorner", ToggleUI).CornerRadius = UDim.new(0, 18)
    local ToggleStroke = Instance.new("UIStroke", ToggleUI)
    ToggleStroke.Color = currentTheme.Stroke
    ToggleStroke.Thickness = 2

    local dragIcon = Instance.new("ImageButton", ToggleUI)
    dragIcon.Name = "DragIcon"
    dragIcon.Size = UDim2.new(0, 19, 0, 19)
    dragIcon.Position = UDim2.new(0, 9, 0.5, -10)
    dragIcon.BackgroundTransparency = 1
    dragIcon.Image = "rbxassetid://10734900011"

    local toggleLine = Instance.new("Frame", ToggleUI)
    toggleLine.Size = UDim2.new(0, 2, 0, 18)
    toggleLine.Position = UDim2.new(0, 38, 0.5, -9)
    toggleLine.BackgroundColor3 = currentTheme.Stroke
    toggleLine.BorderSizePixel = 0

    local toggleLabel = Instance.new("TextLabel", ToggleUI)
    toggleLabel.Size = UDim2.new(1, -46, 1, 0)
    toggleLabel.Position = UDim2.new(0, 46, 0, 0)
    toggleLabel.BackgroundTransparency = 1
    toggleLabel.Text = "Open UI"
    toggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleLabel.Font = Enum.Font.GothamBold
    toggleLabel.TextSize = 13
    toggleLabel.TextXAlignment = Enum.TextXAlignment.Left

    local toggleClick = Instance.new("TextButton", ToggleUI)
    toggleClick.Size = UDim2.new(1, -38, 1, 0)
    toggleClick.Position = UDim2.new(0, 38, 0, 0)
    toggleClick.BackgroundTransparency = 1
    toggleClick.Text = ""

    toggleClick.MouseButton1Click:Connect(function()
        MainUI.Visible = true
        ToggleUI.Visible = false
    end)

    local tDragging, tDragInput, tDragStart, tStartPos
    dragIcon.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            tDragging = true
            tDragStart = input.Position
            tStartPos = ToggleUI.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    tDragging = false
                end
            end)
        end
    end)

    dragIcon.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            tDragInput = input
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if input == tDragInput and tDragging then
            local delta = input.Position - tDragStart
            ToggleUI.Position = UDim2.new(tStartPos.X.Scale, tStartPos.X.Offset + delta.X, tStartPos.Y.Scale, tStartPos.Y.Offset + delta.Y)
        end
    end)

    UIS.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == window.ToggleKey then
            if MainUI.Visible then
                MainUI.Visible = false
                ToggleUI.Visible = true
            else
                MainUI.Visible = true
                ToggleUI.Visible = false
            end
        end
    end)

    local DestroyDialog = Instance.new("Frame")
    DestroyDialog.Name = "DestroyDialog"
    DestroyDialog.Size = UDim2.new(0, 260, 0, 120)
    DestroyDialog.AnchorPoint = Vector2.new(0.5, 0.5)
    DestroyDialog.Position = UDim2.new(0.5, 0, 0.5, 0)
    DestroyDialog.BackgroundColor3 = currentTheme.GroupBG
    DestroyDialog.BorderSizePixel = 0
    DestroyDialog.Visible = false
    DestroyDialog.ZIndex = 20
    DestroyDialog.Parent = MainUI

    Instance.new("UICorner", DestroyDialog).CornerRadius = UDim.new(0, 10)
    local dialogStroke = Instance.new("UIStroke", DestroyDialog)
    dialogStroke.Color = currentTheme.Stroke
    dialogStroke.Thickness = 2

    local dialogText = Instance.new("TextLabel", DestroyDialog)
    dialogText.Size = UDim2.new(1, -20, 0, 40)
    dialogText.Position = UDim2.new(0, 10, 0, 15)
    dialogText.BackgroundTransparency = 1
    dialogText.Text = "Destroy UI Library?"
    dialogText.TextColor3 = Color3.fromRGB(255, 255, 255)
    dialogText.Font = Enum.Font.GothamBold
    dialogText.TextSize = 14
    dialogText.ZIndex = 21

    local yesBtn = Instance.new("TextButton", DestroyDialog)
    yesBtn.Size = UDim2.new(0.4, 0, 0, 32)
    yesBtn.Position = UDim2.new(0.08, 0, 1, -45)
    yesBtn.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
    yesBtn.Text = "Yes"
    yesBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    yesBtn.Font = Enum.Font.GothamMedium
    yesBtn.TextSize = 13
    yesBtn.ZIndex = 21
    Instance.new("UICorner", yesBtn).CornerRadius = UDim.new(0, 6)

    local noBtn = Instance.new("TextButton", DestroyDialog)
    noBtn.Size = UDim2.new(0.4, 0, 0, 32)
    noBtn.Position = UDim2.new(0.52, 0, 1, -45)
    noBtn.BackgroundColor3 = currentTheme.ButtonBG
    noBtn.Text = "No"
    noBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    noBtn.Font = Enum.Font.GothamMedium
    noBtn.TextSize = 13
    noBtn.ZIndex = 21
    Instance.new("UICorner", noBtn).CornerRadius = UDim.new(0, 6)
    local noStroke = Instance.new("UIStroke", noBtn)
    noStroke.Color = currentTheme.Stroke
    noStroke.Thickness = 1

    yesBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    noBtn.MouseButton1Click:Connect(function()
        DestroyDialog.Visible = false
    end)

    local redBtn = Instance.new("TextButton", Header)
    redBtn.Name = "DestroyButton"
    redBtn.Size = UDim2.new(0, 16, 0, 16)
    redBtn.Position = UDim2.new(1, -24, 0.5, -8)
    redBtn.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
    redBtn.Text = ""
    redBtn.ZIndex = 7
    Instance.new("UICorner", redBtn).CornerRadius = UDim.new(1, 0)

    local yellowBtn = Instance.new("TextButton", Header)
    yellowBtn.Name = "ToggleButton"
    yellowBtn.Size = UDim2.new(0, 16, 0, 16)
    yellowBtn.Position = UDim2.new(1, -46, 0.5, -8)
    yellowBtn.BackgroundColor3 = Color3.fromRGB(220, 180, 20)
    yellowBtn.Text = ""
    yellowBtn.ZIndex = 7
    Instance.new("UICorner", yellowBtn).CornerRadius = UDim.new(1, 0)

    yellowBtn.MouseButton1Click:Connect(function()
        MainUI.Visible = false
        ToggleUI.Visible = true
    end)

    redBtn.MouseButton1Click:Connect(function()
        DestroyDialog.Visible = true
    end)

    local function buatButton(nama, teks, posY)
        local btn = Instance.new("TextButton")
        btn.Name = nama
        btn.Size = UDim2.new(1, -12, 0, 34)
        btn.Position = UDim2.new(0, 6, 0, posY)
        btn.BackgroundColor3 = currentTheme.ButtonBG
        btn.BackgroundTransparency = bgTrans
        btn.Text = teks
        btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        btn.Font = Enum.Font.GothamMedium
        btn.TextSize = 14
        btn.AutoButtonColor = false
        btn.ZIndex = 6
        btn.Parent = Sidebar
        btn.TextScaled = true
        
        local btnConstraint = Instance.new("UITextSizeConstraint", btn)
        btnConstraint.MaxTextSize = 14
        
        local corner = Instance.new("UICorner", btn)
        corner.CornerRadius = UDim.new(0, 8)
        local stroke = Instance.new("UIStroke", btn)
        stroke.Color = currentTheme.Stroke
        stroke.Thickness = 1
        return btn
    end

    function window:AddTag(tagOptions)
        tagOptions = tagOptions or {}
        local tagTitle = tagOptions.title or "Tag"
        local tagColor = tagOptions.color or Color3.fromRGB(40, 40, 40)
        local canClick = tagOptions.getclick or false
        local callback = tagOptions.callback or function() end

        totalTags = totalTags + 1
        if totalTags > 0 then
            xLine.BackgroundTransparency = 0
        end

        local tagBtn = Instance.new("TextButton", TagContainer)
        tagBtn.Name = tagTitle .. "Tag"
        tagBtn.Size = UDim2.new(0, 0, 0, 22)
        tagBtn.AutomaticSize = Enum.AutomaticSize.X
        tagBtn.BackgroundColor3 = tagColor
        tagBtn.Text = tagTitle
        tagBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        tagBtn.Font = Enum.Font.GothamBold
        tagBtn.TextSize = 11

        local tagPadding = Instance.new("UIPadding", tagBtn)
        tagPadding.PaddingLeft = UDim.new(0, 8)
        tagPadding.PaddingRight = UDim.new(0, 8)

        local tagCorner = Instance.new("UICorner", tagBtn)
        tagCorner.CornerRadius = UDim.new(0, 6)

        local tagStroke = Instance.new("UIStroke", tagBtn)
        tagStroke.Color = currentTheme.Stroke
        tagStroke.Thickness = 1

        if canClick then
            tagBtn.MouseButton1Click:Connect(callback)
            tagBtn.AutoButtonColor = true
        else
            tagBtn.Active = false
            tagBtn.AutoButtonColor = false
        end

        return tagBtn
    end

    local function buatElementMethods(containerFrame)
        local methods = {}

        function methods:Addbutton(btnOptions)
            btnOptions = btnOptions or {}
            local title = btnOptions.title or "Button"
            local desc = btnOptions.desc or ""
            local callback = btnOptions.callback or function() end

            local btnFrame = Instance.new("Frame", containerFrame)
            btnFrame.Size = UDim2.new(1, 0, 0, 36)
            btnFrame.BackgroundColor3 = currentTheme.ButtonBG
            btnFrame.BackgroundTransparency = bgTrans
            Instance.new("UICorner", btnFrame).CornerRadius = UDim.new(0, 6)
            local bStroke = Instance.new("UIStroke", btnFrame)
            bStroke.Color = currentTheme.Stroke
            bStroke.Thickness = 1

            local textLabel = Instance.new("TextLabel", btnFrame)
            textLabel.Size = UDim2.new(0.7, 0, 1, 0)
            textLabel.Position = UDim2.new(0, 8, 0, 0)
            textLabel.BackgroundTransparency = 1
            textLabel.Text = title .. (desc ~= "" and " \n<font color='rgb(150,150,150)'>"..desc.."</font>" or "")
            textLabel.RichText = true
            textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            textLabel.Font = Enum.Font.GothamMedium
            textLabel.TextSize = 12
            textLabel.TextXAlignment = Enum.TextXAlignment.Left

            local icon = Instance.new("ImageLabel", btnFrame)
            icon.Name = "ButtonIcon"
            icon.Size = UDim2.new(0, 16, 0, 16)
            icon.Position = UDim2.new(1, -24, 0.5, -8)
            icon.BackgroundTransparency = 1
            icon.Image = "rbxassetid://10734898355"
            icon.ImageColor3 = Color3.fromRGB(255, 255, 255)

            local clickBtn = Instance.new("TextButton", btnFrame)
            clickBtn.Size = UDim2.new(1, 0, 1, 0)
            clickBtn.BackgroundTransparency = 1
            clickBtn.Text = ""

            clickBtn.MouseButton1Click:Connect(function()
                local oldColor = btnFrame.BackgroundColor3
                btnFrame.BackgroundColor3 = currentTheme.Accent
                task.delay(0.1, function() btnFrame.BackgroundColor3 = oldColor end)
                callback()
            end)
        end

        function methods:Addtoggle(tglOptions)
            tglOptions = tglOptions or {}
            local title = tglOptions.title or "Toggle"
            local desc = tglOptions.desc or ""
            local state = tglOptions.value or false
            local callback = tglOptions.callback or function() end

            local tglFrame = Instance.new("Frame", containerFrame)
            tglFrame.Size = UDim2.new(1, 0, 0, 36)
            tglFrame.BackgroundColor3 = currentTheme.ButtonBG
            tglFrame.BackgroundTransparency = bgTrans
            Instance.new("UICorner", tglFrame).CornerRadius = UDim.new(0, 6)
            local tStroke = Instance.new("UIStroke", tglFrame)
            tStroke.Color = currentTheme.Stroke
            tStroke.Thickness = 1

            local textLabel = Instance.new("TextLabel", tglFrame)
            textLabel.Size = UDim2.new(0.7, 0, 1, 0)
            textLabel.Position = UDim2.new(0, 8, 0, 0)
            textLabel.BackgroundTransparency = 1
            textLabel.Text = title .. (desc ~= "" and " \n<font color='rgb(150,150,150)'>"..desc.."</font>" or "")
            textLabel.RichText = true
            textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            textLabel.Font = Enum.Font.GothamMedium
            textLabel.TextSize = 12
            textLabel.TextXAlignment = Enum.TextXAlignment.Left

            local switch = Instance.new("Frame", tglFrame)
            switch.Size = UDim2.new(0, 34, 0, 18)
            switch.Position = UDim2.new(1, -42, 0.5, -9)
            switch.BackgroundColor3 = state and currentTheme.Accent or Color3.fromRGB(50, 50, 55)
            Instance.new("UICorner", switch).CornerRadius = UDim.new(1, 0)

            local dot = Instance.new("Frame", switch)
            dot.Size = UDim2.new(0, 14, 0, 14)
            dot.Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
            dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

            local clickBtn = Instance.new("TextButton", tglFrame)
            clickBtn.Size = UDim2.new(1, 0, 1, 0)
            clickBtn.BackgroundTransparency = 1
            clickBtn.Text = ""

            local function updateToggle()
                TweenService:Create(switch, TweenInfo.new(0.2), {BackgroundColor3 = state and currentTheme.Accent or Color3.fromRGB(50, 50, 55)}):Play()
                TweenService:Create(dot, TweenInfo.new(0.2), {Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)}):Play()
                callback(state)
            end

            clickBtn.MouseButton1Click:Connect(function()
                state = not state
                updateToggle()
            end)
        end

        function methods:AddDropdown(ddOptions)
            ddOptions = ddOptions or {}
            local title = ddOptions.Title or "Dropdown"
            local desc = ddOptions.Desc or ""
            local list = ddOptions.Values or {}
            local selected = ddOptions.Value or {}
            local isMulti = ddOptions.Multi or false
            local callback = ddOptions.Callback or function() end

            local ddFrame = Instance.new("Frame", containerFrame)
            ddFrame.Size = UDim2.new(1, 0, 0, 36)
            ddFrame.BackgroundColor3 = currentTheme.ButtonBG
            ddFrame.BackgroundTransparency = bgTrans
            ddFrame.ClipsDescendants = true
            Instance.new("UICorner", ddFrame).CornerRadius = UDim.new(0, 6)
            local dStroke = Instance.new("UIStroke", ddFrame)
            dStroke.Color = currentTheme.Stroke
            dStroke.Thickness = 1

            local top = Instance.new("TextButton", ddFrame)
            top.Size = UDim2.new(1, 0, 0, 36)
            top.BackgroundTransparency = 1
            top.Text = ""

            local textLabel = Instance.new("TextLabel", top)
            textLabel.Size = UDim2.new(0.6, 0, 1, 0)
            textLabel.Position = UDim2.new(0, 8, 0, 0)
            textLabel.BackgroundTransparency = 1
            textLabel.Text = title .. (desc ~= "" and " \n<font color='rgb(150,150,150)'>"..desc.."</font>" or "")
            textLabel.RichText = true
            textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            textLabel.Font = Enum.Font.GothamMedium
            textLabel.TextSize = 12
            textLabel.TextXAlignment = Enum.TextXAlignment.Left

            local choiceText = Instance.new("TextLabel", top)
            choiceText.Size = UDim2.new(0.35, 0, 1, 0)
            choiceText.Position = UDim2.new(0.65, -20, 0, 0)
            choiceText.BackgroundTransparency = 1
            choiceText.Text = table.concat(selected, ", ")
            choiceText.TextColor3 = currentTheme.Accent
            choiceText.Font = Enum.Font.Gotham
            choiceText.TextSize = 11
            choiceText.TextXAlignment = Enum.TextXAlignment.Right

            local arrow = Instance.new("TextLabel", top)
            arrow.Size = UDim2.new(0, 20, 1, 0)
            arrow.Position = UDim2.new(1, -20, 0, 0)
            arrow.BackgroundTransparency = 1
            arrow.Text = "v"
            arrow.TextColor3 = Color3.fromRGB(150, 150, 150)
            arrow.Font = Enum.Font.GothamBold
            arrow.TextSize = 12

            local dropList = Instance.new("Frame", ddFrame)
            dropList.Size = UDim2.new(1, 0, 0, #list * 28)
            dropList.Position = UDim2.new(0, 0, 0, 36)
            dropList.BackgroundTransparency = 1

            local dlLayout = Instance.new("UIListLayout", dropList)
            dlLayout.SortOrder = Enum.SortOrder.LayoutOrder

            local expanded = false

            local function refreshSelected()
                choiceText.Text = table.concat(selected, ", ")
                if isMulti then
                    callback(selected)
                else
                    callback(selected[1] or "")
                end
            end

            for i, val in ipairs(list) do
                local opt = Instance.new("TextButton", dropList)
                opt.Size = UDim2.new(1, 0, 0, 28)
                opt.BackgroundColor3 = table.find(selected, val) and currentTheme.GroupBG or currentTheme.ButtonBG
                opt.BackgroundTransparency = bgTrans
                opt.Text = "  " .. val
                opt.TextColor3 = table.find(selected, val) and currentTheme.Accent or Color3.fromRGB(200, 200, 200)
                opt.Font = Enum.Font.Gotham
                opt.TextSize = 12
                opt.TextXAlignment = Enum.TextXAlignment.Left
                opt.BorderSizePixel = 0

                opt.MouseButton1Click:Connect(function()
                    if isMulti then
                        local found = table.find(selected, val)
                        if found then
                            table.remove(selected, found)
                            opt.BackgroundColor3 = currentTheme.ButtonBG
                            opt.TextColor3 = Color3.fromRGB(200, 200, 200)
                        else
                            table.insert(selected, val)
                            opt.BackgroundColor3 = currentTheme.GroupBG
                            opt.TextColor3 = currentTheme.Accent
                        end
                    else
                        selected = {val}
                        for _, child in ipairs(dropList:GetChildren()) do
                            if child:IsA("TextButton") then
                                child.BackgroundColor3 = currentTheme.ButtonBG
                                child.TextColor3 = Color3.fromRGB(200, 200, 200)
                            end
                        end
                        opt.BackgroundColor3 = currentTheme.GroupBG
                        opt.TextColor3 = currentTheme.Accent
                        expanded = false
                        TweenService:Create(ddFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 36)}):Play()
                        arrow.Text = "v"
                    end
                    refreshSelected()
                end)
            end

            top.MouseButton1Click:Connect(function()
                expanded = not expanded
                local targetSize = expanded and UDim2.new(1, 0, 0, 36 + (#list * 28)) or UDim2.new(1, 0, 0, 36)
                TweenService:Create(ddFrame, TweenInfo.new(0.2), {Size = targetSize}):Play()
                arrow.Text = expanded and "^" or "v"
            end)

            local dropdownMethods = {}
            return dropdownMethods
        end

        function methods:AddSlider(sldOptions)
            sldOptions = sldOptions or {}
            local title = sldOptions.Title or "Slider"
            local desc = sldOptions.Desc or ""
            local step = sldOptions.Step or 1
            local min = sldOptions.Value and sldOptions.Value.Min or 0
            local max = sldOptions.Value and sldOptions.Value.Max or 100
            local default = sldOptions.Value and sldOptions.Value.Default or min
            local callback = sldOptions.Callback or function() end

            local sldFrame = Instance.new("Frame", containerFrame)
            sldFrame.Size = UDim2.new(1, 0, 0, 44)
            sldFrame.BackgroundColor3 = currentTheme.ButtonBG
            sldFrame.BackgroundTransparency = bgTrans
            Instance.new("UICorner", sldFrame).CornerRadius = UDim.new(0, 6)
            local sStroke = Instance.new("UIStroke", sldFrame)
            sStroke.Color = currentTheme.Stroke
            sStroke.Thickness = 1

            local textLabel = Instance.new("TextLabel", sldFrame)
            textLabel.Size = UDim2.new(0.6, 0, 0, 24)
            textLabel.Position = UDim2.new(0, 8, 0, 2)
            textLabel.BackgroundTransparency = 1
            textLabel.Text = title .. (desc ~= "" and " <font color='rgb(150,150,150)'>- "..desc.."</font>" or "")
            textLabel.RichText = true
            textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            textLabel.Font = Enum.Font.GothamMedium
            textLabel.TextSize = 12
            textLabel.TextXAlignment = Enum.TextXAlignment.Left

            local valLabel = Instance.new("TextLabel", sldFrame)
            valLabel.Size = UDim2.new(0.35, 0, 0, 24)
            valLabel.Position = UDim2.new(0.65, -8, 0, 2)
            valLabel.BackgroundTransparency = 1
            valLabel.Text = tostring(default)
            valLabel.TextColor3 = currentTheme.Accent
            valLabel.Font = Enum.Font.GothamBold
            valLabel.TextSize = 12
            valLabel.TextXAlignment = Enum.TextXAlignment.Right

            local lane = Instance.new("Frame", sldFrame)
            lane.Size = UDim2.new(1, -16, 0, 4)
            lane.Position = UDim2.new(0, 8, 1, -12)
            lane.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
            Instance.new("UICorner", lane)

            local fill = Instance.new("Frame", lane)
            fill.Size = UDim2.new(math.clamp((default - min) / (max - min), 0, 1), 0, 1, 0)
            fill.BackgroundColor3 = currentTheme.Accent
            Instance.new("UICorner", fill)

            local sliderBtn = Instance.new("TextButton", lane)
            sliderBtn.Size = UDim2.new(1, 0, 3, 0)
            sliderBtn.Position = UDim2.new(0, 0, -1, 0)
            sliderBtn.BackgroundTransparency = 1
            sliderBtn.Text = ""

            local sliding = false

            local function updateSlider(input)
                local currentX = input.Position.X
                local startX = lane.AbsolutePosition.X
                local width = lane.AbsoluteSize.X
                local ratio = math.clamp((currentX - startX) / width, 0, 1)
                local exactVal = min + (ratio * (max - min))
                local finalVal = math.round(exactVal / step) * step
                finalVal = math.clamp(finalVal, min, max)

                fill.Size = UDim2.new((finalVal - min) / (max - min), 0, 1, 0)
                valLabel.Text = tostring(finalVal)
                callback(finalVal)
            end

            sliderBtn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    sliding = true
                    updateSlider(input)
                end
            end)

            UIS.InputChanged:Connect(function(input)
                if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    updateSlider(input)
                end
            end)

            UIS.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    sliding = false
                end
            end)

            callback(default)
            local sliderMethods = {}
            return sliderMethods
        end

        function methods:AddParagraph(pOptions)
            pOptions = pOptions or {}
            local title = pOptions.Title or "Paragraph"
            local desc = pOptions.Desc or ""
            local colorStr = pOptions.Color or "White"

            local pFrame = Instance.new("Frame", containerFrame)
            pFrame.Size = UDim2.new(1, 0, 0, 0)
            pFrame.AutomaticSize = Enum.AutomaticSize.Y
            pFrame.BackgroundColor3 = currentTheme.ButtonBG
            pFrame.BackgroundTransparency = bgTrans
            Instance.new("UICorner", pFrame).CornerRadius = UDim.new(0, 6)
            local pStroke = Instance.new("UIStroke", pFrame)
            pStroke.Color = currentTheme.Stroke
            pStroke.Thickness = 1

            local pPad = Instance.new("UIPadding", pFrame)
            pPad.PaddingLeft = UDim.new(0, 8)
            pPad.PaddingRight = UDim.new(0, 8)
            pPad.PaddingTop = UDim.new(0, 6)
            pPad.PaddingBottom = UDim.new(0, 6)

            local pLayout = Instance.new("UIListLayout", pFrame)
            pLayout.SortOrder = Enum.SortOrder.LayoutOrder
            pLayout.Padding = UDim.new(0, 2)

            local titleLabel = Instance.new("TextLabel", pFrame)
            titleLabel.Size = UDim2.new(1, 0, 0, 16)
            titleLabel.BackgroundTransparency = 1
            titleLabel.Text = title
            titleLabel.TextColor3 = colorStr:lower() == "red" and Color3.fromRGB(255, 80, 80) or Color3.fromRGB(255, 255, 255)
            titleLabel.Font = Enum.Font.GothamBold
            titleLabel.TextSize = 12
            titleLabel.TextXAlignment = Enum.TextXAlignment.Left

            local descLabel = Instance.new("TextLabel", pFrame)
            descLabel.Size = UDim2.new(1, 0, 0, 0)
            descLabel.AutomaticSize = Enum.AutomaticSize.Y
            descLabel.BackgroundTransparency = 1
            descLabel.Text = desc
            descLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
            descLabel.Font = Enum.Font.Gotham
            descLabel.TextSize = 11
            descLabel.TextWrapped = true
            descLabel.TextXAlignment = Enum.TextXAlignment.Left

            return pFrame
        end

        function methods:AddKeybind(kbOptions)
            kbOptions = kbOptions or {}
            local title = kbOptions.title or kbOptions.Title or "Keybind"
            local desc = kbOptions.desc or kbOptions.Desc or ""
            local currentKey = kbOptions.Value or "G"
            local callback = kbOptions.Callback or kbOptions.callback or function() end

            local kbFrame = Instance.new("Frame", containerFrame)
            kbFrame.Size = UDim2.new(1, 0, 0, 36)
            kbFrame.BackgroundColor3 = currentTheme.ButtonBG
            kbFrame.BackgroundTransparency = bgTrans
            Instance.new("UICorner", kbFrame).CornerRadius = UDim.new(0, 6)
            local kStroke = Instance.new("UIStroke", kbFrame)
            kStroke.Color = currentTheme.Stroke
            kStroke.Thickness = 1

            local textLabel = Instance.new("TextLabel", kbFrame)
            textLabel.Size = UDim2.new(0.7, 0, 1, 0)
            textLabel.Position = UDim2.new(0, 8, 0, 0)
            textLabel.BackgroundTransparency = 1
            textLabel.Text = title .. (desc ~= "" and " \n<font color='rgb(150,150,150)'>"..desc.."</font>" or "")
            textLabel.RichText = true
            textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            textLabel.Font = Enum.Font.GothamMedium
            textLabel.TextSize = 12
            textLabel.TextXAlignment = Enum.TextXAlignment.Left

            local bindBox = Instance.new("TextButton", kbFrame)
            bindBox.Size = UDim2.new(0, 45, 0, 20)
            bindBox.Position = UDim2.new(1, -53, 0.5, -10)
            bindBox.BackgroundColor3 = currentTheme.GroupBG
            bindBox.Text = currentKey
            bindBox.TextColor3 = currentTheme.Accent
            bindBox.Font = Enum.Font.GothamBold
            bindBox.TextSize = 11
            Instance.new("UICorner", bindBox).CornerRadius = UDim.new(0, 4)
            local bStroke = Instance.new("UIStroke", bindBox)
            bStroke.Color = currentTheme.Stroke
            bStroke.Thickness = 1

            local listen = false

            bindBox.MouseButton1Click:Connect(function()
                listen = true
                bindBox.Text = "..."
            end)

            UIS.InputBegan:Connect(function(input, processed)
                if listen and not processed then
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        listen = false
                        currentKey = input.KeyCode.Name
                        bindBox.Text = currentKey
                        callback(currentKey)
                    end
                end
            end)

            local keybindMethods = {}
            return keybindMethods
        end

        function methods:AddInput(inpOptions)
            inpOptions = inpOptions or {}
            local title = inpOptions.Title or "Input"
            local desc = inpOptions.Desc or ""
            local default = inpOptions.Value or ""
            local callback = inpOptions.Callback or function() end

            local inpFrame = Instance.new("Frame", containerFrame)
            inpFrame.Size = UDim2.new(1, 0, 0, 36)
            inpFrame.BackgroundColor3 = currentTheme.ButtonBG
            inpFrame.BackgroundTransparency = bgTrans
            Instance.new("UICorner", inpFrame).CornerRadius = UDim.new(0, 6)
            local iStroke = Instance.new("UIStroke", inpFrame)
            iStroke.Color = currentTheme.Stroke
            iStroke.Thickness = 1

            local textLabel = Instance.new("TextLabel", inpFrame)
            textLabel.Size = UDim2.new(0.5, 0, 1, 0)
            textLabel.Position = UDim2.new(0, 8, 0, 0)
            textLabel.BackgroundTransparency = 1
            textLabel.Text = title .. (desc ~= "" and " \n<font color='rgb(150,150,150)'>"..desc.."</font>" or "")
            textLabel.RichText = true
            textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            textLabel.Font = Enum.Font.GothamMedium
            textLabel.TextSize = 12
            textLabel.TextXAlignment = Enum.TextXAlignment.Left

            local textBox = Instance.new("TextBox", inpFrame)
            textBox.Size = UDim2.new(0.45, 0, 0, 24)
            textBox.Position = UDim2.new(1, -8, 0.5, -12)
            textBox.AnchorPoint = Vector2.new(1, 0)
            textBox.BackgroundColor3 = currentTheme.GroupBG
            textBox.Text = default
            textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
            textBox.Font = Enum.Font.Gotham
            textBox.TextSize = 12
            textBox.PlaceholderText = "Ketik..."
            textBox.ClipsDescendants = true
            Instance.new("UICorner", textBox).CornerRadius = UDim.new(0, 4)
            local tStroke = Instance.new("UIStroke", textBox)
            tStroke.Color = currentTheme.Stroke
            tStroke.Thickness = 1

            textBox.FocusLost:Connect(function()
                callback(textBox.Text)
            end)

            return textBox
        end

        function methods:AddColorpicker(cpOptions)
            cpOptions = cpOptions or {}
            local title = cpOptions.Title or "Colorpicker"
            local desc = cpOptions.Desc or ""
            local default = cpOptions.Default or Color3.fromRGB(255, 255, 255)
            local callback = cpOptions.Callback or function() end

            local currentR = math.round(default.R * 255)
            local currentG = math.round(default.G * 255)
            local currentB = math.round(default.B * 255)

            local cpFrame = Instance.new("Frame", containerFrame)
            cpFrame.Size = UDim2.new(1, 0, 0, 36)
            cpFrame.BackgroundColor3 = currentTheme.ButtonBG
            cpFrame.BackgroundTransparency = bgTrans
            cpFrame.ClipsDescendants = true
            Instance.new("UICorner", cpFrame).CornerRadius = UDim.new(0, 6)
            local cStroke = Instance.new("UIStroke", cpFrame)
            cStroke.Color = currentTheme.Stroke
            cStroke.Thickness = 1

            local top = Instance.new("TextButton", cpFrame)
            top.Size = UDim2.new(1, 0, 0, 36)
            top.BackgroundTransparency = 1
            top.Text = ""

            local textLabel = Instance.new("TextLabel", top)
            textLabel.Size = UDim2.new(0.7, 0, 1, 0)
            textLabel.Position = UDim2.new(0, 8, 0, 0)
            textLabel.BackgroundTransparency = 1
            textLabel.Text = title .. (desc ~= "" and " \n<font color='rgb(150,150,150)'>"..desc.."</font>" or "")
            textLabel.RichText = true
            textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            textLabel.Font = Enum.Font.GothamMedium
            textLabel.TextSize = 12
            textLabel.TextXAlignment = Enum.TextXAlignment.Left

            local box = Instance.new("Frame", top)
            box.Size = UDim2.new(0, 34, 0, 18)
            box.Position = UDim2.new(1, -42, 0.5, -9)
            box.BackgroundColor3 = default
            Instance.new("UICorner", box).CornerRadius = UDim.new(0, 4)
            local bStroke = Instance.new("UIStroke", box)
            bStroke.Color = currentTheme.Stroke
            bStroke.Thickness = 1

            local slidersFrame = Instance.new("Frame", cpFrame)
            slidersFrame.Size = UDim2.new(1, 0, 0, 110)
            slidersFrame.Position = UDim2.new(0, 0, 0, 36)
            slidersFrame.BackgroundTransparency = 1

            local sfLayout = Instance.new("UIListLayout", slidersFrame)
            sfLayout.SortOrder = Enum.SortOrder.LayoutOrder
            sfLayout.Padding = UDim.new(0, 4)
            
            local sfPad = Instance.new("UIPadding", slidersFrame)
            sfPad.PaddingLeft = UDim.new(0, 8)
            sfPad.PaddingRight = UDim.new(0, 8)
            sfPad.PaddingTop = UDim.new(0, 4)

            local expanded = false

            local function updateColor()
                local newColor = Color3.fromRGB(currentR, currentG, currentB)
                box.BackgroundColor3 = newColor
                callback(newColor)
            end

            local function buatRGBSlider(warnaName, defaultVal, callbackRGB)
                local sFrame = Instance.new("Frame", slidersFrame)
                sFrame.Size = UDim2.new(1, 0, 0, 30)
                sFrame.BackgroundTransparency = 1

                local label = Instance.new("TextLabel", sFrame)
                label.Size = UDim2.new(0, 20, 1, 0)
                label.BackgroundTransparency = 1
                label.Text = warnaName
                label.TextColor3 = Color3.fromRGB(200, 200, 200)
                label.Font = Enum.Font.GothamBold
                label.TextSize = 11

                local valLabel = Instance.new("TextLabel", sFrame)
                valLabel.Size = UDim2.new(0, 25, 1, 0)
                valLabel.Position = UDim2.new(1, -25, 0, 0)
                valLabel.BackgroundTransparency = 1
                valLabel.Text = tostring(defaultVal)
                valLabel.TextColor3 = currentTheme.Accent
                valLabel.Font = Enum.Font.GothamMedium
                valLabel.TextSize = 11

                local lane = Instance.new("Frame", sFrame)
                lane.Size = UDim2.new(1, -55, 0, 4)
                lane.Position = UDim2.new(0, 25, 0.5, -2)
                lane.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
                Instance.new("UICorner", lane)

                local fill = Instance.new("Frame", lane)
                fill.Size = UDim2.new(defaultVal / 255, 0, 1, 0)
                fill.BackgroundColor3 = currentTheme.Accent
                Instance.new("UICorner", fill)

                local sliderBtn = Instance.new("TextButton", lane)
                sliderBtn.Size = UDim2.new(1, 0, 3, 0)
                sliderBtn.Position = UDim2.new(0, 0, -1, 0)
                sliderBtn.BackgroundTransparency = 1
                sliderBtn.Text = ""

                local sliding = false

                local function updateSlider(input)
                    local ratio = math.clamp((input.Position.X - lane.AbsolutePosition.X) / lane.AbsoluteSize.X, 0, 1)
                    local finalVal = math.round(ratio * 255)
                    fill.Size = UDim2.new(finalVal / 255, 0, 1, 0)
                    valLabel.Text = tostring(finalVal)
                    callbackRGB(finalVal)
                end

                sliderBtn.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        sliding = true
                        updateSlider(input)
                    end
                end)

                UIS.InputChanged:Connect(function(input)
                    if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        updateSlider(input)
                    end
                end)

                UIS.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        sliding = false
                    end
                end)
            end

            buatRGBSlider("R", currentR, function(v) currentR = v updateColor() end)
            buatRGBSlider("G", currentG, function(v) currentG = v updateColor() end)
            buatRGBSlider("B", currentB, function(v) currentB = v updateColor() end)

            top.MouseButton1Click:Connect(function()
                expanded = not expanded
                local targetSize = expanded and UDim2.new(1, 0, 0, 146) or UDim2.new(1, 0, 0, 36)
                TweenService:Create(cpFrame, TweenInfo.new(0.2), {Size = targetSize}):Play()
            end)

            local cpMethods = {}
            return cpMethods
        end

        function methods:AddDivider()
            local line = Instance.new("Frame", containerFrame)
            line.Size = UDim2.new(1, 0, 0, 1)
            line.BackgroundColor3 = currentTheme.Stroke
            line.BorderSizePixel = 0
        end

        return methods
    end

    function window:AddTab(tabName)
        local tabIndex = #self.Tabs + 1
        local button = buatButton(tabName.."Btn", tabName, #self.Tabs * 44 + 50)

        local page = Instance.new("Frame", ContentHolder)  
        page.Name = tabName  
        page.Size = UDim2.new(1, 0, 1, 0)  
        page.BackgroundTransparency = 1  
        page.Visible = false  
        page.ClipsDescendants = true
          
        local pad = Instance.new("UIPadding", page)  
        pad.PaddingLeft = UDim.new(0,10)  
        pad.PaddingTop = UDim.new(0,10)  
        pad.PaddingRight = UDim.new(0,10)  
        pad.PaddingBottom = UDim.new(0,10)  

        local frame = Instance.new("Frame", page)  
        frame.Name = "Card"  
        frame.Size = UDim2.new(1, 0, 1, 0)  
        frame.BackgroundColor3 = currentTheme.MainBG  
        frame.BackgroundTransparency = bgTrans
        frame.BorderSizePixel = 0  
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)  
        local fstroke = Instance.new("UIStroke", frame)  
        fstroke.Color = currentTheme.Stroke  
        fstroke.Thickness = 2.5  

        local scroll = Instance.new("ScrollingFrame", frame)  
        scroll.Name = "Scroll"  
        scroll.Size = UDim2.new(1, -24, 1, -24)  
        scroll.Position = UDim2.new(0, 12, 0, 12)  
        scroll.BackgroundTransparency = 1  
        scroll.BorderSizePixel = 0  
        scroll.ScrollBarThickness = 3  
        scroll.CanvasSize = UDim2.new(0,0,0,0)  
        scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y  

        local sPad = Instance.new("UIPadding", scroll)
        sPad.PaddingLeft = UDim.new(0, 6)
        sPad.PaddingRight = UDim.new(0, 6)
        sPad.PaddingTop = UDim.new(0, 6)
        sPad.PaddingBottom = UDim.new(0, 6)
          
        local hlayout = Instance.new("UIListLayout", scroll)  
        hlayout.FillDirection = Enum.FillDirection.Vertical
        hlayout.Padding = UDim.new(0, 6)  
        hlayout.SortOrder = Enum.SortOrder.LayoutOrder  
          
        button.MouseButton1Click:Connect(function()  
            if window.CurrentTab and window.CurrentTab.Index ~= tabIndex then
                local oldTab = window.CurrentTab
                
                oldTab.Button.BackgroundColor3 = currentTheme.ButtonBG  
                oldTab.Button.TextColor3 = Color3.fromRGB(200, 200, 200)  
                oldTab.Page.Visible = false
                
                button.BackgroundColor3 = currentTheme.Accent  
                button.TextColor3 = Color3.fromRGB(255, 255, 255)  
                
                page.Position = UDim2.new(0, 0, 0, 0)
                page.Visible = true
                
                tabLabel.Text = tabName
                tabLabel.Position = UDim2.new(0, 135, 0.5, -14)
                tabLabel.TextTransparency = 0

                window.CurrentTab = {Page = page, Button = button, Index = tabIndex}
            end
        end)  
         
        local tabObj = buatElementMethods(scroll)
        
        function tabObj:AddSection(gbOptions)
            gbOptions = gbOptions or {}
            local gbTitle = gbOptions.title or "Group Box"
            local isOpen = gbOptions.open ~= false

            local groupBox = Instance.new("Frame", scroll)
            groupBox.Name = gbTitle .. "GB"
            groupBox.Size = UDim2.new(1, 0, 0, 26)
            groupBox.BackgroundColor3 = currentTheme.GroupBG
            groupBox.BackgroundTransparency = bgTrans
            groupBox.BorderSizePixel = 0
            groupBox.ClipsDescendants = true

            Instance.new("UICorner", groupBox).CornerRadius = UDim.new(0, 6)
            local gbStroke = Instance.new("UIStroke", groupBox)
            gbStroke.Color = currentTheme.Stroke
            gbStroke.Thickness = 1

            local gbLayout = Instance.new("UIListLayout", groupBox)
            gbLayout.Padding = UDim.new(0, 0)
            gbLayout.SortOrder = Enum.SortOrder.LayoutOrder

            local topBar = Instance.new("Frame", groupBox)
            topBar.Name = "TopBar"
            topBar.Size = UDim2.new(1, 0, 0, 26)
            topBar.BackgroundTransparency = 1

            local topPad = Instance.new("UIPadding", topBar)
            topPad.PaddingLeft = UDim.new(0, 8)
            topPad.PaddingRight = UDim.new(0, 8)

            local titleLabel = Instance.new("TextLabel", topBar)
            titleLabel.Size = UDim2.new(0.7, 0, 1, 0)
            titleLabel.BackgroundTransparency = 1
            titleLabel.Text = gbTitle
            titleLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
            titleLabel.Font = Enum.Font.GothamBold
            titleLabel.TextSize = 11
            titleLabel.TextXAlignment = Enum.TextXAlignment.Left

            local toggleBtn = Instance.new("TextButton", topBar)
            toggleBtn.Size = UDim2.new(0.3, 0, 1, 0)
            toggleBtn.Position = UDim2.new(0.7, 0, 0, 0)
            toggleBtn.BackgroundTransparency = 1
            toggleBtn.Text = isOpen and "-" or "+"
            toggleBtn.TextColor3 = Color3.fromRGB(130, 130, 130)
            toggleBtn.Font = Enum.Font.GothamBold
            toggleBtn.TextSize = 14
            toggleBtn.TextXAlignment = Enum.TextXAlignment.Right

            local separatorLine = Instance.new("Frame", groupBox)
            separatorLine.Name = "Separator"
            separatorLine.Size = UDim2.new(1, 0, 0, 1)
            separatorLine.BackgroundColor3 = currentTheme.Stroke
            separatorLine.BorderSizePixel = 0
            separatorLine.Visible = isOpen

            local container = Instance.new("Frame", groupBox)
            container.Name = "Container"
            container.Size = UDim2.new(1, 0, 0, 0)
            container.BackgroundTransparency = 1
            container.ClipsDescendants = true

            local cPad = Instance.new("UIPadding", container)
            cPad.PaddingLeft = UDim.new(0, 6)
            cPad.PaddingRight = UDim.new(0, 6)
            cPad.PaddingTop = UDim.new(0, 6)
            cPad.PaddingBottom = UDim.new(0, 6)

            local cLayout = Instance.new("UIListLayout", container)
            cLayout.Padding = UDim.new(0, 5)
            cLayout.SortOrder = Enum.SortOrder.LayoutOrder

            local isTweening = false

            if isOpen then
                container.AutomaticSize = Enum.AutomaticSize.Y
                container.Visible = true
                groupBox.AutomaticSize = Enum.AutomaticSize.Y
            else
                container.AutomaticSize = Enum.AutomaticSize.None
                container.Size = UDim2.new(1, 0, 0, 0)
                container.Visible = false
                groupBox.AutomaticSize = Enum.AutomaticSize.None
                groupBox.Size = UDim2.new(1, 0, 0, 26)
            end

            toggleBtn.MouseButton1Click:Connect(function()
                if isTweening then return end
                isTweening = true
                isOpen = not isOpen
                toggleBtn.Text = isOpen and "-" or "+"
                
                local tInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

                if isOpen then
                    separatorLine.Visible = true
                    container.Visible = true
                    container.AutomaticSize = Enum.AutomaticSize.Y
                    
                    local targetHeight = container.AbsoluteSize.Y + 27
                    groupBox.AutomaticSize = Enum.AutomaticSize.None
                    groupBox.Size = UDim2.new(1, 0, 0, targetHeight)

                    local openTween = TweenService:Create(groupBox, tInfo, {Size = UDim2.new(1, 0, 0, targetHeight)})
                    openTween:Play()
                    openTween.Completed:Connect(function()
                        groupBox.AutomaticSize = Enum.AutomaticSize.Y
                        isTweening = false
                    end)
                else
                    groupBox.AutomaticSize = Enum.AutomaticSize.None
                    container.AutomaticSize = Enum.AutomaticSize.None
                    
                    local closeTween = TweenService:Create(groupBox, tInfo, {Size = UDim2.new(1, 0, 0, 26)})
                    closeTween:Play()
                    closeTween.Completed:Connect(function()
                        container.Size = UDim2.new(1, 0, 0, 0)
                        container.Visible = false
                        separatorLine.Visible = false
                        isTweening = false
                    end)
                end
            end)

            local gbMethods = buatElementMethods(container)
            gbMethods.Container = container
            return gbMethods
        end

        table.insert(self.Tabs, {Name = tabName, Button = button, Page = page, Card = frame, Scroll = scroll, TabObj = tabObj})  
          
        if #self.Tabs == 1 then  
            page.Visible = true  
            button.BackgroundColor3 = currentTheme.Accent  
            button.TextColor3 = Color3.fromRGB(255, 255, 255)  
            tabLabel.Text = tabName 
            window.CurrentTab = {Page = page, Button = button, Index = 1}
        end  
          
        return tabObj
    end

    function window:SetTitle(text)
        sideTitle.Text = text
    end

    function window:SetDesc(text)
        sideDesc.Text = text
    end

    return window
end

return library
