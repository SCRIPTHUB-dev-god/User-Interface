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

local iconMap = {
    ["apple"] = "rbxassetid://10709761889",
    ["clipboard"] = "rbxassetid://10709799288",
    ["code"] = "rbxassetid://10709810463",
    ["copy"] = "rbxassetid://10709812159",
    ["eye"] = "rbxassetid://10723346959",
    ["folder"] = "rbxassetid://10723387563",
    ["globe"] = "rbxassetid://10723404337",
    ["home"] = "rbxassetid://10723407389",
    ["info"] = "rbxassetid://10723415903",
    ["key"] = "rbxassetid://10723416652",
    ["laptop"] = "rbxassetid://10723423881",
    ["rocket"] = "rbxassetid://10734934585",
    ["search"] = "rbxassetid://10734943674",
    ["server"] = "rbxassetid://10734949856",
    ["settings"] = "rbxassetid://10734950309",
    ["shield"] = "rbxassetid://10734951847",
    ["sprout"] = "rbxassetid://10734965572",
    ["star"] = "rbxassetid://10734966248",
    ["sword"] = "rbxassetid://10734975486",
    ["swords"] = "rbxassetid://10734975692",
    ["terminal"] = "rbxassetid://10734982144",
    ["user"] = "rbxassetid://10747373176"
}

local function resolveIcon(iconValue, fallbackKey)
    if type(iconValue) ~= "string" or iconValue == "" then
        return iconMap[fallbackKey] or iconMap["code"]
    end
    if iconValue:match("^rbxassetid://") or iconValue:match("^rbxasset://") or iconValue:match("^http") then
        return iconValue
    end
    return iconMap[iconValue] or iconMap[fallbackKey] or iconMap["code"]
end

local themes = {
    dark = {
        MainBG = Color3.fromRGB(24, 24, 26),
        HeaderBG = Color3.fromRGB(15, 15, 15),
        Stroke = Color3.fromRGB(55, 55, 60),
        ButtonBG = Color3.fromRGB(36, 36, 40),
        SectionBG = Color3.fromRGB(30, 30, 33),
        Accent = Color3.fromRGB(140, 140, 140),
        IconCl = Color3.fromRGB(200, 200, 200)
    },
    neon = {
        MainBG = Color3.fromRGB(15, 12, 22),
        HeaderBG = Color3.fromRGB(8, 6, 12),
        Stroke = Color3.fromRGB(0, 255, 204),
        ButtonBG = Color3.fromRGB(28, 22, 40),
        SectionBG = Color3.fromRGB(22, 17, 32),
        Accent = Color3.fromRGB(255, 0, 127),
        IconCl = Color3.fromRGB(0, 255, 204)
    },
    ocean = {
        MainBG = Color3.fromRGB(12, 22, 32),
        HeaderBG = Color3.fromRGB(6, 12, 18),
        Stroke = Color3.fromRGB(0, 150, 255),
        ButtonBG = Color3.fromRGB(20, 36, 52),
        SectionBG = Color3.fromRGB(16, 28, 42),
        Accent = Color3.fromRGB(0, 200, 255),
        IconCl = Color3.fromRGB(0, 200, 255)
    },
    crimson = {
        MainBG = Color3.fromRGB(24, 14, 14),
        HeaderBG = Color3.fromRGB(14, 6, 6),
        Stroke = Color3.fromRGB(180, 30, 30),
        ButtonBG = Color3.fromRGB(40, 20, 20),
        SectionBG = Color3.fromRGB(32, 16, 16),
        Accent = Color3.fromRGB(255, 50, 50),
        IconCl = Color3.fromRGB(255, 50, 50)
    },
    golden = {
        MainBG = Color3.fromRGB(24, 22, 18),
        HeaderBG = Color3.fromRGB(16, 14, 12),
        Stroke = Color3.fromRGB(40, 35, 30),
        ButtonBG = Color3.fromRGB(36, 30, 25),
        SectionBG = Color3.fromRGB(33, 28, 24),
        Accent = Color3.fromRGB(255, 215, 0),
        IconCl = Color3.fromRGB(255, 215, 0)
    },
    light = {
        MainBG = Color3.fromRGB(125, 125, 130),
        HeaderBG = Color3.fromRGB(95, 95, 100),
        Stroke = Color3.fromRGB(180, 180, 185),
        ButtonBG = Color3.fromRGB(145, 145, 150),
        SectionBG = Color3.fromRGB(110, 110, 115),
        Accent = Color3.fromRGB(245, 245, 245),
        IconCl = Color3.fromRGB(95, 95, 100)
    },
    fire = {
        MainBG = Color3.fromRGB(25, 10, 5),
        HeaderBG = Color3.fromRGB(15, 5, 2),
        Stroke = Color3.fromRGB(255, 69, 0),
        ButtonBG = Color3.fromRGB(45, 18, 10),
        SectionBG = Color3.fromRGB(35, 14, 8),
        Accent = Color3.fromRGB(255, 140, 0),
        IconCl = Color3.fromRGB(255, 140, 0)
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
notifLayout.VerticalAlignment = Enum.VerticalAlignment.Top
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
    local windowIcon = resolveIcon(options.icon, "code")
    local bgTrans = options.transparent or 0
    local selectedTheme = options.theme or "dark"
    local currentTheme = themes[selectedTheme:lower()] or themes.dark
    library.CurrentTheme = currentTheme

    local autoshow = options.autoshow
    if autoshow == nil then autoshow = true end

    local addbacksound = options.addbacksound
    if addbacksound == nil then addbacksound = false end

    local soundPlayed = false
    local function playInitSound()
        if addbacksound and not soundPlayed then
            soundPlayed = true
            local s = Instance.new("Sound", game.SoundService)
            s.SoundId = "rbxassetid://126047015098640"
            s.Volume = 2
            s:Play()
        end
    end

    local window = {}
    window.Tabs = {}
    window.CurrentTab = nil
    window.ToggleKey = Enum.KeyCode.G
    local totalTags = 0

    function window:SetToggleKey(key)
        window.ToggleKey = key
    end

    local MainShadow = Instance.new("ImageLabel")
    MainShadow.Name = "MainShadow"
    MainShadow.BackgroundTransparency = 1
    MainShadow.Image = "rbxassetid://6015897843"
    MainShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    MainShadow.ImageTransparency = 0.35
    MainShadow.ScaleType = Enum.ScaleType.Slice
    MainShadow.SliceCenter = Rect.new(49, 49, 450, 450)
    MainShadow.ZIndex = 0
    MainShadow.Parent = ScreenGui

    local MainUI = Instance.new("CanvasGroup")
    MainUI.Name = "MainUI"
    MainUI.Size = UDim2.new(0, 560, 0, 360)
    MainUI.AnchorPoint = Vector2.new(0.5, 0.5)
    MainUI.BackgroundColor3 = currentTheme.MainBG
    MainUI.BackgroundTransparency = bgTrans
    MainUI.BorderSizePixel = 0
    MainUI.ZIndex = 1
    MainUI.Parent = ScreenGui

    local function syncShadow()
        MainShadow.AnchorPoint = MainUI.AnchorPoint
        MainShadow.Position = MainUI.Position
        MainShadow.Size = UDim2.new(MainUI.Size.X.Scale, MainUI.Size.X.Offset + 60, MainUI.Size.Y.Scale, MainUI.Size.Y.Offset + 60)
        MainShadow.Visible = MainUI.Visible
    end

    syncShadow()
    MainUI:GetPropertyChangedSignal("Position"):Connect(syncShadow)
    MainUI:GetPropertyChangedSignal("Size"):Connect(syncShadow)
    MainUI:GetPropertyChangedSignal("Visible"):Connect(syncShadow)
    MainUI:GetPropertyChangedSignal("AnchorPoint"):Connect(syncShadow)

    local UIScale = Instance.new("UIScale")
    UIScale.Scale = 0.80
    UIScale.Parent = MainUI

    local ShadowScale = Instance.new("UIScale")
    ShadowScale.Scale = UIScale.Scale
    ShadowScale.Parent = MainShadow

    UIScale:GetPropertyChangedSignal("Scale"):Connect(function()
        ShadowScale.Scale = UIScale.Scale
    end)

    Instance.new("UICorner", MainUI).CornerRadius = UDim.new(0, 12)
    local MainStroke = Instance.new("UIStroke", MainUI)
    MainStroke.Color = currentTheme.Stroke
    MainStroke.Thickness = 2.5

    local savedTogglePos = UDim2.new(0.05, 0, 0.1, 30)

    local ToggleUI = Instance.new("CanvasGroup")
    ToggleUI.Name = "ToggleUI"
    ToggleUI.Size = UDim2.new(0, 135, 0, 36)
    ToggleUI.BackgroundColor3 = currentTheme.MainBG
    ToggleUI.BackgroundTransparency = bgTrans
    ToggleUI.BorderSizePixel = 0
    ToggleUI.Parent = ScreenGui

    Instance.new("UICorner", ToggleUI).CornerRadius = UDim.new(0, 18)
    local ToggleStroke = Instance.new("UIStroke", ToggleUI)
    ToggleStroke.Color = currentTheme.Stroke
    ToggleStroke.Thickness = 2

    local function showMainUI()
        MainUI.Visible = true
        ToggleUI.Visible = true
        TweenService:Create(MainUI, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, 0, 0.6, 0), GroupTransparency = 0}):Play()
        local t = TweenService:Create(ToggleUI, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(-0.5, 0, savedTogglePos.Y.Scale, savedTogglePos.Y.Offset), GroupTransparency = 1})
        t:Play()
        t.Completed:Connect(function()
            if MainUI.GroupTransparency == 0 then
                ToggleUI.Visible = false
            end
        end)
        playInitSound()
    end

    local function hideMainUI()
        MainUI.Visible = true
        ToggleUI.Visible = true
        ToggleUI.Position = UDim2.new(-0.5, 0, savedTogglePos.Y.Scale, savedTogglePos.Y.Offset)
        TweenService:Create(ToggleUI, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = savedTogglePos, GroupTransparency = 0}):Play()
        local t = TweenService:Create(MainUI, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, 0, 1.5, 0), GroupTransparency = 1})
        t:Play()
        t.Completed:Connect(function()
            if ToggleUI.GroupTransparency == 0 then
                MainUI.Visible = false
            end
        end)
    end

    if autoshow then
        MainUI.Visible = true
        MainUI.Position = UDim2.new(0.5, 0, 0.6, 0)
        MainUI.GroupTransparency = 0
        ToggleUI.Visible = false
        ToggleUI.Position = UDim2.new(-0.5, 0, savedTogglePos.Y.Scale, savedTogglePos.Y.Offset)
        ToggleUI.GroupTransparency = 1
        playInitSound()
    else
        MainUI.Visible = false
        MainUI.Position = UDim2.new(0.5, 0, 1.5, 0)
        MainUI.GroupTransparency = 1
        ToggleUI.Visible = true
        ToggleUI.Position = savedTogglePos
        ToggleUI.GroupTransparency = 0
    end

    local Header = Instance.new("Frame", MainUI)
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 52)
    Header.BackgroundColor3 = currentTheme.HeaderBG
    Header.BackgroundTransparency = bgTrans
    Header.BorderSizePixel = 0
    Header.ClipsDescendants = true

    Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 12)

    local Fix = Instance.new("Frame", Header)
    Fix.Size = UDim2.new(1, 0, 0, 12)
    Fix.Position = UDim2.new(0, 0, 1, -12)
    Fix.BackgroundColor3 = currentTheme.HeaderBG
    Fix.BackgroundTransparency = bgTrans
    Fix.BorderSizePixel = 0

    local headerIcon = Instance.new("ImageLabel", Header)
    headerIcon.Name = "HeaderIcon"
    headerIcon.Size = UDim2.new(0, 30, 0, 30)
    headerIcon.Position = UDim2.new(0, 10, 0.5, -15)
    headerIcon.BackgroundColor3 = currentTheme.SectionBG
    headerIcon.BackgroundTransparency = bgTrans
    headerIcon.Image = windowIcon
    headerIcon.ImageColor3 = currentTheme.IconCl
    headerIcon.BorderSizePixel = 0
    Instance.new("UICorner", headerIcon).CornerRadius = UDim.new(0, 8)
    local headerIconStroke = Instance.new("UIStroke", headerIcon)
    headerIconStroke.Color = currentTheme.Stroke
    headerIconStroke.Thickness = 1

    local headerTitle = Instance.new("TextLabel", Header)
    headerTitle.Name = "HeaderTitle"
    headerTitle.Size = UDim2.new(0, 106, 0, 18)
    headerTitle.Position = UDim2.new(0, 48, 0, 8)
    headerTitle.BackgroundTransparency = 1
    headerTitle.Text = windowTitle
    headerTitle.TextColor3 = Color3.new(1, 1, 1)
    headerTitle.Font = Enum.Font.GothamBold
    headerTitle.TextSize = 13
    headerTitle.TextXAlignment = Enum.TextXAlignment.Left
    headerTitle.ClipsDescendants = false
    headerTitle.TextScaled = true

    local headerTitleConstraint = Instance.new("UITextSizeConstraint", headerTitle)
    headerTitleConstraint.MaxTextSize = 13

    local headerDesc = Instance.new("TextLabel", Header)
    headerDesc.Name = "HeaderDesc"
    headerDesc.Size = UDim2.new(0, 106, 0, 14)
    headerDesc.Position = UDim2.new(0, 48, 0, 27)
    headerDesc.BackgroundTransparency = 1
    headerDesc.Text = windowDesc
    headerDesc.TextColor3 = Color3.fromRGB(150, 150, 150)
    headerDesc.Font = Enum.Font.Gotham
    headerDesc.TextSize = 11
    headerDesc.TextXAlignment = Enum.TextXAlignment.Left
    headerDesc.ClipsDescendants = false
    headerDesc.TextScaled = true

    local headerDescConstraint = Instance.new("UITextSizeConstraint", headerDesc)
    headerDescConstraint.MaxTextSize = 11

    local tabLabel = Instance.new("TextLabel", Header)
    tabLabel.Name = "ActiveTabLabel"
    tabLabel.Size = UDim2.new(0, 100, 0, 32)
    tabLabel.Position = UDim2.new(0, 170, 0.5, -16)
    tabLabel.BackgroundTransparency = 1
    tabLabel.Text = ""
    tabLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    tabLabel.Font = Enum.Font.GothamBold
    tabLabel.TextSize = 15
    tabLabel.TextXAlignment = Enum.TextXAlignment.Left
    tabLabel.ClipsDescendants = false
    tabLabel.TextScaled = true

    local tabLabelConstraint = Instance.new("UITextSizeConstraint", tabLabel)
    tabLabelConstraint.MaxTextSize = 15

    local VLine = Instance.new("Frame", Header)
    VLine.Name = "ProfileLine"
    VLine.Size = UDim2.new(0, 1, 0, 32)
    VLine.Position = UDim2.new(0, 160, 0.5, -16)
    VLine.BackgroundColor3 = currentTheme.Stroke
    VLine.BorderSizePixel = 0
    VLine.ZIndex = 5

    local headerStroke = Instance.new("Frame", Header)
    headerStroke.Name = "HeaderStroke"
    headerStroke.Size = UDim2.new(1, 0, 0, 1)
    headerStroke.Position = UDim2.new(0, 0, 1, -1)
    headerStroke.BackgroundColor3 = currentTheme.Stroke
    headerStroke.BorderSizePixel = 0
    headerStroke.ZIndex = 5

    local TagContainer = Instance.new("ScrollingFrame", Header)
    TagContainer.Name = "TagContainer"
    TagContainer.Size = UDim2.new(0, 155, 0, 24)
    TagContainer.Position = UDim2.new(0, 275, 0.5, -12)
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
    LeftTabBar.Size = UDim2.new(0, 1, 1, -52)
    LeftTabBar.Position = UDim2.new(0, 84, 0, 52)
    LeftTabBar.BackgroundColor3 = currentTheme.Stroke
    LeftTabBar.BorderSizePixel = 0
    LeftTabBar.ZIndex = 5

    local Sidebar = Instance.new("Frame", MainUI)
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 84, 1, -52)
    Sidebar.Position = UDim2.new(0, 0, 0, 52)
    Sidebar.BackgroundTransparency = 1

    local SidebarScroll = Instance.new("ScrollingFrame", Sidebar)
    SidebarScroll.Name = "SidebarScroll"
    SidebarScroll.Size = UDim2.new(1, 0, 1, 0)
    SidebarScroll.Position = UDim2.new(0, 0, 0, 0)
    SidebarScroll.BackgroundTransparency = 1
    SidebarScroll.BorderSizePixel = 0
    SidebarScroll.ScrollBarThickness = 0
    SidebarScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    SidebarScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y

    local sidebarLayout = Instance.new("UIListLayout", SidebarScroll)
    sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    sidebarLayout.Padding = UDim.new(0, 6)
    sidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local sidebarTopPad = Instance.new("UIPadding", SidebarScroll)
    sidebarTopPad.PaddingTop = UDim.new(0, 6)

    local function buatFadeLine(parent, sizeX)
        local line = Instance.new("Frame", parent)
        line.Size = UDim2.new(0, sizeX, 0, 3)
        line.BackgroundColor3 = currentTheme.Stroke
        line.BorderSizePixel = 0
        local corner = Instance.new("UICorner", line)
        corner.CornerRadius = UDim.new(1, 0)
        local gradient = Instance.new("UIGradient", line)
        gradient.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.55),
            NumberSequenceKeypoint.new(0.5, 0),
            NumberSequenceKeypoint.new(1, 0.55)
        })
        return line
    end

    function window:AddDivider(title)
        local holder = Instance.new("Frame", SidebarScroll)
        holder.BackgroundTransparency = 1
        holder.Size = UDim2.new(1, -12, 0, 14)

        if not title then
            local line = buatFadeLine(holder, 0)
            line.Size = UDim2.new(1, 0, 0, 3)
            line.Position = UDim2.new(0, 0, 0.5, -1)
            return
        end

        local layout = Instance.new("UIListLayout", holder)
        layout.FillDirection = Enum.FillDirection.Horizontal
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.VerticalAlignment = Enum.VerticalAlignment.Center
        layout.Padding = UDim.new(0, 4)

        local leftLine = Instance.new("Frame", holder)
        leftLine.Size = UDim2.new(0.5, -4, 0, 3)
        leftLine.BackgroundColor3 = currentTheme.Stroke
        leftLine.BorderSizePixel = 0
        leftLine.LayoutOrder = 1
        Instance.new("UICorner", leftLine).CornerRadius = UDim.new(1, 0)
        local leftGradient = Instance.new("UIGradient", leftLine)
        leftGradient.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.55),
            NumberSequenceKeypoint.new(1, 0)
        })

        local label = Instance.new("TextLabel", holder)
        label.Size = UDim2.new(0, 0, 0, 12)
        label.AutomaticSize = Enum.AutomaticSize.X
        label.BackgroundTransparency = 1
        label.Text = title
        label.TextColor3 = Color3.fromRGB(150, 150, 150)
        label.Font = Enum.Font.GothamBold
        label.TextSize = 8
        label.LayoutOrder = 2

        local rightLine = Instance.new("Frame", holder)
        rightLine.Size = UDim2.new(0.5, -4, 0, 3)
        rightLine.BackgroundColor3 = currentTheme.Stroke
        rightLine.BorderSizePixel = 0
        rightLine.LayoutOrder = 3
        Instance.new("UICorner", rightLine).CornerRadius = UDim.new(1, 0)
        local rightGradient = Instance.new("UIGradient", rightLine)
        rightGradient.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(1, 0.55)
        })
    end

    local ContentHolder = Instance.new("Frame", MainUI)
    ContentHolder.Name = "ContentHolder"
    ContentHolder.Size = UDim2.new(1, -85, 1, -52)
    ContentHolder.Position = UDim2.new(0, 85, 0, 52)
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

    local resizing, resizeStart, startScale
    resizeBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            resizing = true
            resizeStart = input.Position
            startScale = UIScale.Scale
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
            local newScale = math.clamp(startScale + (delta.X / 350), 0.50, 2.50)
            UIScale.Scale = newScale
        end
    end)

    local dragIcon = Instance.new("ImageButton", ToggleUI)
    dragIcon.Name = "DragIcon"
    dragIcon.Size = UDim2.new(0, 19, 0, 19)
    dragIcon.Position = UDim2.new(0, 9, 0.5, -10)
    dragIcon.BackgroundTransparency = 1
    dragIcon.Image = "rbxassetid://10734900011"
    dragIcon.ImageColor3 = currentTheme.IconCl

    local toggleLine = Instance.new("Frame", ToggleUI)
    toggleLine.Size = UDim2.new(0, 1, 0, 18)
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

    toggleClick.MouseButton1Click:Connect(showMainUI)

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
            local newPos = UDim2.new(tStartPos.X.Scale, tStartPos.X.Offset + delta.X, tStartPos.Y.Scale, tStartPos.Y.Offset + delta.Y)
            ToggleUI.Position = newPos
            savedTogglePos = newPos
        end
    end)

    UIS.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == window.ToggleKey then
            if MainUI.Visible and MainUI.GroupTransparency < 0.5 then
                hideMainUI()
            else
                showMainUI()
            end
        end
    end)

    local DestroyDialog = Instance.new("Frame")
    DestroyDialog.Name = "DestroyDialog"
    DestroyDialog.Size = UDim2.new(0, 260, 0, 120)
    DestroyDialog.AnchorPoint = Vector2.new(0.5, 0.5)
    DestroyDialog.Position = UDim2.new(0.5, 0, 0.5, 0)
    DestroyDialog.BackgroundColor3 = currentTheme.SectionBG
    DestroyDialog.BackgroundTransparency = bgTrans
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
    noBtn.BackgroundTransparency = bgTrans
    noBtn.Text = "No"
    noBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    noBtn.Font = Enum.Font.GothamMedium
    noBtn.TextSize = 13
    noBtn.ZIndex = 21
    Instance.new("UICorner", noBtn).CornerRadius = UDim.new(0, 6)
    local noStroke = Instance.new("UIStroke", noBtn)
    noStroke.Color = currentTheme.Stroke
    noStroke.Thickness = 1

    function window:destroy()
        if addbacksound then
            local s = Instance.new("Sound", game.SoundService)
            s.SoundId = "rbxassetid://111617177185247"
            s.Volume = 2
            s:Play()
        end
        local t1 = TweenService:Create(MainUI, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {GroupTransparency = 1})
        t1:Play()
        t1.Completed:Connect(function()
            ScreenGui:Destroy()
        end)
    end

    yesBtn.MouseButton1Click:Connect(function()
        window:destroy()
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

    yellowBtn.MouseButton1Click:Connect(hideMainUI)

    redBtn.MouseButton1Click:Connect(function()
        DestroyDialog.Visible = true
    end)

    local function buatButton(nama, iconValue)
        local btn = Instance.new("ImageButton")
        btn.Name = nama
        btn.Size = UDim2.new(0, 50, 0, 50)
        btn.BackgroundColor3 = currentTheme.ButtonBG
        btn.BackgroundTransparency = bgTrans
        btn.AutoButtonColor = false
        btn.ZIndex = 6
        btn.Parent = SidebarScroll

        local corner = Instance.new("UICorner", btn)
        corner.CornerRadius = UDim.new(0, 10)
        local stroke = Instance.new("UIStroke", btn)
        stroke.Color = currentTheme.Stroke
        stroke.Thickness = 1

        local iconImg = Instance.new("ImageLabel", btn)
        iconImg.Name = "Icon"
        iconImg.Size = UDim2.new(0, 26, 0, 26)
        iconImg.AnchorPoint = Vector2.new(0.5, 0.5)
        iconImg.Position = UDim2.new(0.5, 0, 0.5, 0)
        iconImg.BackgroundTransparency = 1
        iconImg.Image = resolveIcon(iconValue, "code")
        iconImg.ImageColor3 = currentTheme.IconCl
        iconImg.ZIndex = 6

        return btn, iconImg
    end

    function window:AddTag(tagOptions)
        tagOptions = tagOptions or {}
        local tagTitle = tagOptions.title or "Tag"
        local tagColor = tagOptions.color or Color3.fromRGB(40, 40, 40)
        local canClick = tagOptions.getclick or false
        local callback = tagOptions.callback or function() end
        local tagIcon = tagOptions.icon

        totalTags = totalTags + 1

        local tagBtn = Instance.new("TextButton", TagContainer)
        tagBtn.Name = tagTitle .. "Tag"
        tagBtn.Size = UDim2.new(0, 0, 0, 22)
        tagBtn.AutomaticSize = Enum.AutomaticSize.X
        tagBtn.BackgroundColor3 = tagColor
        tagBtn.BackgroundTransparency = bgTrans
        tagBtn.Text = ""

        local tagLayoutItem = Instance.new("UIListLayout", tagBtn)
        tagLayoutItem.FillDirection = Enum.FillDirection.Horizontal
        tagLayoutItem.SortOrder = Enum.SortOrder.LayoutOrder
        tagLayoutItem.Padding = UDim.new(0, 4)
        tagLayoutItem.VerticalAlignment = Enum.VerticalAlignment.Center

        local tagPadding = Instance.new("UIPadding", tagBtn)
        tagPadding.PaddingLeft = UDim.new(0, 8)
        tagPadding.PaddingRight = UDim.new(0, 8)

        local tagCorner = Instance.new("UICorner", tagBtn)
        tagCorner.CornerRadius = UDim.new(0, 6)

        local tagStroke = Instance.new("UIStroke", tagBtn)
        tagStroke.Color = currentTheme.Stroke
        tagStroke.Thickness = 1

        if tagIcon then
            local iconImg = Instance.new("ImageLabel", tagBtn)
            iconImg.Name = "TagIcon"
            iconImg.Size = UDim2.new(0, 12, 0, 12)
            iconImg.BackgroundTransparency = 1
            iconImg.Image = resolveIcon(tagIcon, "code")
            iconImg.ImageColor3 = Color3.fromRGB(255, 255, 255)
            iconImg.LayoutOrder = 1
        end

        local textLabel = Instance.new("TextLabel", tagBtn)
        textLabel.Name = "TagText"
        textLabel.Size = UDim2.new(0, 0, 1, 0)
        textLabel.AutomaticSize = Enum.AutomaticSize.X
        textLabel.BackgroundTransparency = 1
        textLabel.Text = tagTitle
        textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        textLabel.Font = Enum.Font.GothamBold
        textLabel.TextSize = 11
        textLabel.LayoutOrder = 2

        if canClick then
            tagBtn.MouseButton1Click:Connect(callback)
            tagBtn.AutoButtonColor = true
        else
            tagBtn.Active = false
            tagBtn.AutoButtonColor = false
        end

        return tagBtn
    end

    function window:togglegui(tglOptions)
        tglOptions = tglOptions or {}
        local tglTitle = tglOptions.title or windowTitle
        local tglIcon = resolveIcon(tglOptions.icon, "code")

        toggleLabel.Text = tglTitle
        dragIcon.Image = tglIcon
    end

    local function buatElementMethods(containerFrame)
        local methods = {}

        function methods:AddDivider(title)
            local holder = Instance.new("Frame", containerFrame)
            holder.BackgroundTransparency = 1
            holder.Size = UDim2.new(1, 0, 0, 16)

            if not title then
                local line = Instance.new("Frame", holder)
                line.Size = UDim2.new(1, 0, 0, 3)
                line.Position = UDim2.new(0, 0, 0.5, -1)
                line.BackgroundColor3 = currentTheme.Stroke
                line.BorderSizePixel = 0
                Instance.new("UICorner", line).CornerRadius = UDim.new(1, 0)
                local gradient = Instance.new("UIGradient", line)
                gradient.Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0.55),
                    NumberSequenceKeypoint.new(0.5, 0),
                    NumberSequenceKeypoint.new(1, 0.55)
                })
                return
            end

            local layout = Instance.new("UIListLayout", holder)
            layout.FillDirection = Enum.FillDirection.Horizontal
            layout.SortOrder = Enum.SortOrder.LayoutOrder
            layout.VerticalAlignment = Enum.VerticalAlignment.Center
            layout.Padding = UDim.new(0, 6)

            local leftLine = Instance.new("Frame", holder)
            leftLine.Size = UDim2.new(0.5, -6, 0, 3)
            leftLine.BackgroundColor3 = currentTheme.Stroke
            leftLine.BorderSizePixel = 0
            leftLine.LayoutOrder = 1
            Instance.new("UICorner", leftLine).CornerRadius = UDim.new(1, 0)
            local leftGradient = Instance.new("UIGradient", leftLine)
            leftGradient.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.55),
                NumberSequenceKeypoint.new(1, 0)
            })

            local label = Instance.new("TextLabel", holder)
            label.Size = UDim2.new(0, 0, 0, 14)
            label.AutomaticSize = Enum.AutomaticSize.X
            label.BackgroundTransparency = 1
            label.Text = title
            label.TextColor3 = Color3.fromRGB(160, 160, 160)
            label.Font = Enum.Font.GothamBold
            label.TextSize = 10
            label.LayoutOrder = 2

            local rightLine = Instance.new("Frame", holder)
            rightLine.Size = UDim2.new(0.5, -6, 0, 3)
            rightLine.BackgroundColor3 = currentTheme.Stroke
            rightLine.BorderSizePixel = 0
            rightLine.LayoutOrder = 3
            Instance.new("UICorner", rightLine).CornerRadius = UDim.new(1, 0)
            local rightGradient = Instance.new("UIGradient", rightLine)
            rightGradient.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(1, 0.55)
            })
        end

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
            icon.ImageColor3 = currentTheme.IconCl

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
            local search = ddOptions.Search or false
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
            local initialListHeight = #list * 28
            if search then initialListHeight = initialListHeight + 30 end
            dropList.Size = UDim2.new(1, 0, 0, initialListHeight)
            dropList.Position = UDim2.new(0, 0, 0, 36)
            dropList.BackgroundTransparency = 1

            local dlLayout = Instance.new("UIListLayout", dropList)
            dlLayout.SortOrder = Enum.SortOrder.LayoutOrder

            local searchContainer
            local searchBox
            if search then
                searchContainer = Instance.new("Frame", dropList)
                searchContainer.Size = UDim2.new(1, 0, 0, 30)
                searchContainer.BackgroundTransparency = 1
                searchContainer.LayoutOrder = 0

                searchBox = Instance.new("TextBox", searchContainer)
                searchBox.Size = UDim2.new(1, -16, 0, 24)
                searchBox.Position = UDim2.new(0, 8, 0.5, -12)
                searchBox.BackgroundColor3 = currentTheme.SectionBG
                searchBox.BackgroundTransparency = bgTrans
                searchBox.Text = ""
                searchBox.PlaceholderText = "search.."
                searchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
                searchBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
                searchBox.Font = Enum.Font.Gotham
                searchBox.TextSize = 12
                Instance.new("UICorner", searchBox).CornerRadius = UDim.new(0, 4)
                local sBStroke = Instance.new("UIStroke", searchBox)
                sBStroke.Color = currentTheme.Stroke
                sBStroke.Thickness = 1
            end

            local expanded = false
            local optionButtons = {}

            local function refreshSelected()
                choiceText.Text = table.concat(selected, ", ")
                if isMulti then
                    callback(selected)
                else
                    callback(selected[1] or "")
                end
            end

            local function refreshOptionVisuals()
                for _, item in ipairs(optionButtons) do
                    local isSelected = table.find(selected, item.Value) ~= nil
                    item.Button.BackgroundColor3 = isSelected and currentTheme.SectionBG or currentTheme.ButtonBG
                    item.Button.TextColor3 = isSelected and currentTheme.Accent or Color3.fromRGB(200, 200, 200)
                end
            end

            for i, val in ipairs(list) do
                local opt = Instance.new("TextButton", dropList)
                opt.Size = UDim2.new(1, 0, 0, 28)
                opt.BackgroundColor3 = table.find(selected, val) and currentTheme.SectionBG or currentTheme.ButtonBG
                opt.BackgroundTransparency = bgTrans
                opt.Text = "  " .. val
                opt.TextColor3 = table.find(selected, val) and currentTheme.Accent or Color3.fromRGB(200, 200, 200)
                opt.Font = Enum.Font.Gotham
                opt.TextSize = 12
                opt.TextXAlignment = Enum.TextXAlignment.Left
                opt.BorderSizePixel = 0
                opt.LayoutOrder = i

                table.insert(optionButtons, {Button = opt, Value = val})

                opt.MouseButton1Click:Connect(function()
                    if isMulti then
                        local found = table.find(selected, val)
                        if found then
                            table.remove(selected, found)
                        else
                            table.insert(selected, val)
                        end
                    else
                        selected = {val}
                        expanded = false
                        TweenService:Create(ddFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 36)}):Play()
                        arrow.Text = "v"
                    end
                    refreshOptionVisuals()
                    refreshSelected()
                end)
            end

            if search and searchBox then
                searchBox:GetPropertyChangedSignal("Text"):Connect(function()
                    local searchText = searchBox.Text:lower()
                    local visibleCount = 0
                    for _, item in ipairs(optionButtons) do
                        if searchText == "" or item.Value:lower():find(searchText) then
                            item.Button.Visible = true
                            visibleCount = visibleCount + 1
                        else
                            item.Button.Visible = false
                        end
                    end
                    local newHeight = (visibleCount * 28) + 30
                    dropList.Size = UDim2.new(1, 0, 0, newHeight)
                    if expanded then
                        ddFrame.Size = UDim2.new(1, 0, 0, 36 + newHeight)
                    end
                end)
            end

            top.MouseButton1Click:Connect(function()
                expanded = not expanded
                local currentHeight = 0
                if expanded then
                    local visibleCount = 0
                    for _, item in ipairs(optionButtons) do
                        if item.Button.Visible then visibleCount = visibleCount + 1 end
                    end
                    currentHeight = (visibleCount * 28) + (search and 30 or 0)
                end
                local targetSize = expanded and UDim2.new(1, 0, 0, 36 + currentHeight) or UDim2.new(1, 0, 0, 36)
                TweenService:Create(ddFrame, TweenInfo.new(0.2), {Size = targetSize}):Play()
                arrow.Text = expanded and "^" or "v"
            end)
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

            local currentVal = default

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

            local valLabel = Instance.new("TextBox", sldFrame)
            valLabel.Size = UDim2.new(0.35, 0, 0, 24)
            valLabel.Position = UDim2.new(0.65, -8, 0, 2)
            valLabel.BackgroundTransparency = 1
            valLabel.Text = tostring(default)
            valLabel.TextColor3 = currentTheme.Accent
            valLabel.Font = Enum.Font.GothamBold
            valLabel.TextSize = 12
            valLabel.TextXAlignment = Enum.TextXAlignment.Right
            valLabel.ClearTextOnFocus = false

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

            local function applyValue(newVal)
                currentVal = math.clamp(math.round(newVal / step) * step, min, max)
                fill.Size = UDim2.new((currentVal - min) / (max - min), 0, 1, 0)
                valLabel.Text = tostring(currentVal)
                callback(currentVal)
            end

            local function updateSlider(input)
                local currentX = input.Position.X
                local startX = lane.AbsolutePosition.X
                local width = lane.AbsoluteSize.X
                local ratio = math.clamp((currentX - startX) / width, 0, 1)
                local exactVal = min + (ratio * (max - min))
                applyValue(exactVal)
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

            valLabel.FocusLost:Connect(function()
                local inputNum = tonumber(valLabel.Text)
                if inputNum then
                    applyValue(inputNum)
                else
                    valLabel.Text = tostring(currentVal)
                end
            end)

            callback(default)
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
            bindBox.BackgroundColor3 = currentTheme.SectionBG
            bindBox.BackgroundTransparency = bgTrans
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
            textBox.BackgroundColor3 = currentTheme.SectionBG
            textBox.BackgroundTransparency = bgTrans
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
        end

        return methods
    end

    function window:AddTab(tabName, iconName)
        local tabIndex = #self.Tabs + 1
        local button, iconImg = buatButton(tabName.."Btn", iconName or "code")

        local page = Instance.new("Frame", ContentHolder)
        page.Name = tabName
        page.Size = UDim2.new(1, 0, 1, 0)
        page.BackgroundTransparency = 1
        page.Visible = false
        page.ClipsDescendants = true

        local pad = Instance.new("UIPadding", page)
        pad.PaddingLeft = UDim.new(0, 10)
        pad.PaddingTop = UDim.new(0, 10)
        pad.PaddingRight = UDim.new(0, 10)
        pad.PaddingBottom = UDim.new(0, 10)

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
        scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
        scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y

        local sPad = Instance.new("UIPadding", scroll)
        sPad.PaddingLeft = UDim.new(0, 6)
        sPad.PaddingRight = UDim.new(0, 6)
        sPad.PaddingTop = UDim.new(0, 6)
        sPad.PaddingBottom = UDim.new(0, 16 / UIScale.Scale)

        UIScale:GetPropertyChangedSignal("Scale"):Connect(function()
            sPad.PaddingBottom = UDim.new(0, 16 / UIScale.Scale)
        end)

        local hlayout = Instance.new("UIListLayout", scroll)
        hlayout.FillDirection = Enum.FillDirection.Vertical
        hlayout.Padding = UDim.new(0, 6)
        hlayout.SortOrder = Enum.SortOrder.LayoutOrder

        button.MouseButton1Click:Connect(function()
            if window.CurrentTab and window.CurrentTab.Index ~= tabIndex then
                local oldTab = window.CurrentTab

                oldTab.Button.BackgroundColor3 = currentTheme.ButtonBG
                oldTab.Icon.ImageColor3 = currentTheme.IconCl
                oldTab.Page.Visible = false

                button.BackgroundColor3 = currentTheme.Accent
                iconImg.ImageColor3 = Color3.fromRGB(255, 255, 255)

                page.Position = UDim2.new(0, 0, 0, 0)
                page.Visible = true

                tabLabel.Text = tabName
                tabLabel.TextTransparency = 0

                window.CurrentTab = {Page = page, Button = button, Icon = iconImg, Index = tabIndex}
            end
        end)

        local tabObj = buatElementMethods(scroll)

        function tabObj:AddTabbox()
            local tabboxBox = Instance.new("Frame", scroll)
            tabboxBox.Name = "Tabbox"
            tabboxBox.BackgroundColor3 = currentTheme.SectionBG
            tabboxBox.BackgroundTransparency = bgTrans
            tabboxBox.BorderSizePixel = 0
            tabboxBox.ClipsDescendants = true
            tabboxBox.Size = UDim2.new(1, 0, 0, 0)
            tabboxBox.AutomaticSize = Enum.AutomaticSize.Y

            Instance.new("UICorner", tabboxBox).CornerRadius = UDim.new(0, 6)
            local tabboxStroke = Instance.new("UIStroke", tabboxBox)
            tabboxStroke.Color = currentTheme.Stroke
            tabboxStroke.Thickness = 1

            local boxLayout = Instance.new("UIListLayout", tabboxBox)
            boxLayout.SortOrder = Enum.SortOrder.LayoutOrder

            local subTabBar = Instance.new("Frame", tabboxBox)
            subTabBar.Name = "SubTabBar"
            subTabBar.Size = UDim2.new(1, 0, 0, 0)
            subTabBar.AutomaticSize = Enum.AutomaticSize.Y
            subTabBar.BackgroundTransparency = 1
            subTabBar.LayoutOrder = 1

            local subTabPad = Instance.new("UIPadding", subTabBar)
            subTabPad.PaddingLeft = UDim.new(0, 6)
            subTabPad.PaddingRight = UDim.new(0, 6)
            subTabPad.PaddingTop = UDim.new(0, 6)
            subTabPad.PaddingBottom = UDim.new(0, 6)

            local subTabLayout = Instance.new("UIListLayout", subTabBar)
            subTabLayout.FillDirection = Enum.FillDirection.Horizontal
            subTabLayout.SortOrder = Enum.SortOrder.LayoutOrder
            subTabLayout.Padding = UDim.new(0, 6)

            local subPagesHolder = Instance.new("Frame", tabboxBox)
            subPagesHolder.Name = "SubPagesHolder"
            subPagesHolder.Size = UDim2.new(1, 0, 0, 0)
            subPagesHolder.AutomaticSize = Enum.AutomaticSize.Y
            subPagesHolder.BackgroundTransparency = 1
            subPagesHolder.LayoutOrder = 2

            local tabboxObj = {}
            tabboxObj.SubTabs = {}
            tabboxObj.CurrentSubTab = nil

            function tabboxObj:AddTab(subTabName)
                local subIndex = #tabboxObj.SubTabs + 1

                local subTabBtn = Instance.new("TextButton", subTabBar)
                subTabBtn.Name = subTabName .. "Btn"
                subTabBtn.Size = UDim2.new(0, 0, 0, 24)
                subTabBtn.AutomaticSize = Enum.AutomaticSize.X
                subTabBtn.BackgroundColor3 = currentTheme.ButtonBG
                subTabBtn.BackgroundTransparency = bgTrans
                subTabBtn.Text = subTabName
                subTabBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
                subTabBtn.Font = Enum.Font.GothamMedium
                subTabBtn.TextSize = 11

                local sCorner = Instance.new("UICorner", subTabBtn)
                sCorner.CornerRadius = UDim.new(0, 4)

                local sStroke = Instance.new("UIStroke", subTabBtn)
                sStroke.Color = currentTheme.Stroke
                sStroke.Thickness = 1

                local sPad = Instance.new("UIPadding", subTabBtn)
                sPad.PaddingLeft = UDim.new(0, 8)
                sPad.PaddingRight = UDim.new(0, 8)

                local subPage = Instance.new("Frame", subPagesHolder)
                subPage.Name = subTabName .. "Page"
                subPage.Size = UDim2.new(1, 0, 0, 0)
                subPage.AutomaticSize = Enum.AutomaticSize.Y
                subPage.BackgroundTransparency = 1
                subPage.Visible = false

                local spPad = Instance.new("UIPadding", subPage)
                spPad.PaddingLeft = UDim.new(0, 6)
                spPad.PaddingRight = UDim.new(0, 6)
                spPad.PaddingTop = UDim.new(0, 4)
                spPad.PaddingBottom = UDim.new(0, 6)

                local spLayout = Instance.new("UIListLayout", subPage)
                spLayout.SortOrder = Enum.SortOrder.LayoutOrder
                spLayout.Padding = UDim.new(0, 6)

                local subMethods = buatElementMethods(subPage)

                subTabBtn.MouseButton1Click:Connect(function()
                    if tabboxObj.CurrentSubTab and tabboxObj.CurrentSubTab.Index ~= subIndex then
                        tabboxObj.CurrentSubTab.Button.BackgroundColor3 = currentTheme.ButtonBG
                        tabboxObj.CurrentSubTab.Button.TextColor3 = Color3.fromRGB(180, 180, 180)
                        tabboxObj.CurrentSubTab.Page.Visible = false
                    end

                    subTabBtn.BackgroundColor3 = currentTheme.Accent
                    subTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                    subPage.Visible = true

                    tabboxObj.CurrentSubTab = {Button = subTabBtn, Page = subPage, Index = subIndex}
                end)

                if subIndex == 1 then
                    subTabBtn.BackgroundColor3 = currentTheme.Accent
                    subTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                    subPage.Visible = true
                    tabboxObj.CurrentSubTab = {Button = subTabBtn, Page = subPage, Index = subIndex}
                end

                table.insert(tabboxObj.SubTabs, {Button = subTabBtn, Page = subPage, Index = subIndex})
                return subMethods
            end

            return tabboxObj
        end

        if tabIndex == 1 then
            button.BackgroundColor3 = currentTheme.Accent
            iconImg.ImageColor3 = Color3.fromRGB(255, 255, 255)
            page.Position = UDim2.new(0, 0, 0, 0)
            page.Visible = true
            tabLabel.Text = tabName
            window.CurrentTab = {Page = page, Button = button, Icon = iconImg, Index = tabIndex}
        end

        table.insert(window.Tabs, {Page = page, Button = button, Icon = iconImg, Index = tabIndex})
        return tabObj
    end

    return window
end

return library
