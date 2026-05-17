local IcarusLibrary = {}
IcarusLibrary.__index = IcarusLibrary

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "IcarusLibrary"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 999999999
ScreenGui.Parent = CoreGui

local IcarusCore = {
    Flags = {},
    ConfigPath = "IcarusConfig.json",
    Themes = {
        Dark = {
            Background = Color3.fromRGB(18, 18, 24),
            Secondary = Color3.fromRGB(24, 24, 32),
            Tertiary = Color3.fromRGB(32, 32, 42),
            Border = Color3.fromRGB(45, 45, 60),
            Text = Color3.fromRGB(255, 255, 255),
            TextDim = Color3.fromRGB(180, 180, 200),
            Accent = Color3.fromRGB(138, 43, 226),
            AccentHover = Color3.fromRGB(158, 63, 246),
            AccentDark = Color3.fromRGB(118, 23, 206),
            Success = Color3.fromRGB(40, 201, 64),
            Warning = Color3.fromRGB(255, 189, 68),
            Danger = Color3.fromRGB(255, 95, 86)
        },
        Purple = {
            Background = Color3.fromRGB(22, 15, 32),
            Secondary = Color3.fromRGB(28, 20, 40),
            Tertiary = Color3.fromRGB(35, 25, 50),
            Border = Color3.fromRGB(60, 40, 85),
            Text = Color3.fromRGB(245, 240, 255),
            TextDim = Color3.fromRGB(190, 180, 210),
            Accent = Color3.fromRGB(160, 80, 240),
            AccentHover = Color3.fromRGB(180, 100, 255),
            AccentDark = Color3.fromRGB(140, 60, 220),
            Success = Color3.fromRGB(50, 211, 74),
            Warning = Color3.fromRGB(255, 199, 78),
            Danger = Color3.fromRGB(255, 105, 96)
        }
    },
    CurrentTheme = "Dark",
    Keybinds = {},
    Notifications = {},
    ToggleButton = nil,
    MainWindow = nil
}

local function CreateCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

local function CreateStroke(parent, color, thickness, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Thickness = thickness or 1
    stroke.Transparency = transparency or 0
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = parent
    return stroke
end

local function CreateGradient(parent, colors, rotation)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new(colors)
    gradient.Rotation = rotation or 0
    gradient.Parent = parent
    return gradient
end

local function TweenObject(object, properties, duration, style, direction)
    local tween = TweenService:Create(
        object,
        TweenInfo.new(
            duration or 0.25,
            style or Enum.EasingStyle.Quad,
            direction or Enum.EasingDirection.Out
        ),
        properties
    )
    tween:Play()
    return tween
end

local function CreateShadow(parent)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 40, 1, 40)
    shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://5554236805"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.7
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(23, 23, 277, 277)
    shadow.ZIndex = parent.ZIndex - 1
    shadow.Parent = parent
    return shadow
end

function IcarusCore:Notify(config)
    local notifContainer = ScreenGui:FindFirstChild("NotificationContainer")
    if not notifContainer then
        notifContainer = Instance.new("Frame")
        notifContainer.Name = "NotificationContainer"
        notifContainer.Size = UDim2.new(0, 320, 1, 0)
        notifContainer.Position = UDim2.new(1, -330, 0, 10)
        notifContainer.BackgroundTransparency = 1
        notifContainer.Parent = ScreenGui
        
        local notifList = Instance.new("UIListLayout")
        notifList.Padding = UDim.new(0, 10)
        notifList.SortOrder = Enum.SortOrder.LayoutOrder
        notifList.VerticalAlignment = Enum.VerticalAlignment.Top
        notifList.Parent = notifContainer
    end
    
    local notification = Instance.new("Frame")
    notification.Name = "Notification"
    notification.Size = UDim2.new(1, 0, 0, 0)
    notification.BackgroundColor3 = self.Themes[self.CurrentTheme].Secondary
    notification.BorderSizePixel = 0
    notification.ClipsDescendants = true
    notification.Parent = notifContainer
    CreateCorner(notification, 10)
    CreateStroke(notification, self.Themes[self.CurrentTheme].Accent, 1.5)
    
    local accentBar = Instance.new("Frame")
    accentBar.Size = UDim2.new(0, 3, 1, 0)
    accentBar.BackgroundColor3 = self.Themes[self.CurrentTheme].Accent
    accentBar.BorderSizePixel = 0
    accentBar.Parent = notification
    
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -20, 0, 26)
    title.Position = UDim2.new(0, 15, 0, 8)
    title.BackgroundTransparency = 1
    title.Text = config.text or "Notification"
    title.TextColor3 = self.Themes[self.CurrentTheme].Text
    title.Font = Enum.Font.GothamBold
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = notification
    
    local description = Instance.new("TextLabel")
    description.Name = "Description"
    description.Size = UDim2.new(1, -20, 0, 38)
    description.Position = UDim2.new(0, 15, 0, 34)
    description.BackgroundTransparency = 1
    description.Text = config.description or ""
    title.TextColor3 = self.Themes[self.CurrentTheme].TextDim
    description.Font = Enum.Font.Gotham
    description.TextSize = 12
    description.TextXAlignment = Enum.TextXAlignment.Left
    description.TextYAlignment = Enum.TextYAlignment.Top
    description.TextWrapped = true
    description.Parent = notification
    
    table.insert(self.Notifications, notification)
    
    TweenObject(notification, {Size = UDim2.new(1, 0, 0, 80)}, 0.35, Enum.EasingStyle.Back)
    
    task.delay(config.duration or 3, function()
        TweenObject(notification, {Size = UDim2.new(1, 0, 0, 0)}, 0.25)
        task.wait(0.25)
        notification:Destroy()
        table.remove(self.Notifications, table.find(self.Notifications, notification))
    end)
end

function IcarusCore:SaveConfig()
    local config = {}
    for flag, value in pairs(self.Flags) do
        config[flag] = value
    end
    writefile(self.ConfigPath, HttpService:JSONEncode(config))
    self:Notify({text = "Configuration Saved", description = "Settings saved successfully", duration = 2})
end

function IcarusCore:LoadConfig()
    if isfile(self.ConfigPath) then
        local success, data = pcall(function()
            return HttpService:JSONDecode(readfile(self.ConfigPath))
        end)
        if success and data then
            for flag, value in pairs(data) do
                self.Flags[flag] = value
            end
            self:Notify({text = "Configuration Loaded", description = "Settings restored successfully", duration = 2})
            return true
        end
    end
    return false
end

function IcarusCore:AddKeybind(key, callback)
    table.insert(self.Keybinds, {Key = key, Callback = callback})
end

function IcarusCore:CreateToggleButton(windowRef)
    if self.ToggleButton then
        self.ToggleButton:Destroy()
    end
    
    local toggleBtn = Instance.new("Frame")
    toggleBtn.Name = "IcarusToggle"
    toggleBtn.Size = UDim2.new(0, 50, 0, 50)
    toggleBtn.Position = UDim2.new(0, 20, 0.5, -25)
    toggleBtn.BackgroundColor3 = self.Themes[self.CurrentTheme].Secondary
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Active = true
    toggleBtn.Draggable = true
    toggleBtn.Parent = ScreenGui
    CreateCorner(toggleBtn, 10)
    CreateStroke(toggleBtn, self.Themes[self.CurrentTheme].Accent, 2)
    CreateShadow(toggleBtn)
    
    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.new(0, 28, 0, 28)
    icon.Position = UDim2.new(0.5, -14, 0.5, -14)
    icon.BackgroundTransparency = 1
    icon.Image = "rbxassetid://7734053426"
    icon.ImageColor3 = self.Themes[self.CurrentTheme].Accent
    icon.Parent = toggleBtn
    
    local clickDetector = Instance.new("TextButton")
    clickDetector.Size = UDim2.new(1, 0, 1, 0)
    clickDetector.BackgroundTransparency = 1
    clickDetector.Text = ""
    clickDetector.Parent = toggleBtn
    
    local isVisible = true
    clickDetector.MouseButton1Click:Connect(function()
        isVisible = not isVisible
        if windowRef then
            windowRef.Visible = isVisible
            
            if isVisible then
                TweenObject(toggleBtn, {BackgroundColor3 = self.Themes[self.CurrentTheme].Secondary}, 0.2)
                TweenObject(icon, {ImageColor3 = self.Themes[self.CurrentTheme].Accent, Rotation = 0}, 0.2)
            else
                TweenObject(toggleBtn, {BackgroundColor3 = self.Themes[self.CurrentTheme].Accent}, 0.2)
                TweenObject(icon, {ImageColor3 = Color3.fromRGB(255, 255, 255), Rotation = 90}, 0.2)
            end
        end
    end)
    
    clickDetector.MouseEnter:Connect(function()
        TweenObject(toggleBtn, {Size = UDim2.new(0, 55, 0, 55)}, 0.15, Enum.EasingStyle.Back)
    end)
    
    clickDetector.MouseLeave:Connect(function()
        TweenObject(toggleBtn, {Size = UDim2.new(0, 50, 0, 50)}, 0.15)
    end)
    
    self.ToggleButton = toggleBtn
    return toggleBtn
end

function IcarusLibrary:SetWindows(config)
    local window = Instance.new("Frame")
    window.Name = "IcarusWindow"
    window.Size = UDim2.new(0, 680, 0, 480)
    window.Position = UDim2.new(0.5, -340, 0.5, -240)
    window.BackgroundColor3 = IcarusCore.Themes[config.theme or "Dark"].Background
    window.BorderSizePixel = 0
    window.ClipsDescendants = false
    window.Active = true
    window.Visible = true
    window.Parent = ScreenGui
    CreateCorner(window, 12)
    CreateStroke(window, IcarusCore.Themes[config.theme or "Dark"].Border, 1)
    CreateShadow(window)
    
    local topbar = Instance.new("Frame")
    topbar.Name = "Topbar"
    topbar.Size = UDim2.new(1, 0, 0, 42)
    topbar.BackgroundColor3 = IcarusCore.Themes[config.theme or "Dark"].Secondary
    topbar.BorderSizePixel = 0
    topbar.Parent = window
    CreateCorner(topbar, 12)
    
    local topbarCover = Instance.new("Frame")
    topbarCover.Size = UDim2.new(1, 0, 0, 12)
    topbarCover.Position = UDim2.new(0, 0, 1, -12)
    topbarCover.BackgroundColor3 = IcarusCore.Themes[config.theme or "Dark"].Secondary
    topbarCover.BorderSizePixel = 0
    topbarCover.Parent = topbar
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, -110, 1, 0)
    titleLabel.Position = UDim2.new(0, 16, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = config.text or "Icarus Library"
    titleLabel.TextColor3 = IcarusCore.Themes[config.theme or "Dark"].Text
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 16
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = topbar
    
    local buttonContainer = Instance.new("Frame")
    buttonContainer.Name = "Buttons"
    buttonContainer.Size = UDim2.new(0, 75, 0, 20)
    buttonContainer.Position = UDim2.new(1, -90, 0.5, -10)
    buttonContainer.BackgroundTransparency = 1
    buttonContainer.Parent = topbar
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "Close"
    closeBtn.Size = UDim2.new(0, 20, 0, 20)
    closeBtn.Position = UDim2.new(0, 55, 0, 0)
    closeBtn.BackgroundColor3 = IcarusCore.Themes[config.theme or "Dark"].Danger
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = ""
    closeBtn.AutoButtonColor = false
    closeBtn.Parent = buttonContainer
    CreateCorner(closeBtn, 999)
    
    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Name = "Minimize"
    minimizeBtn.Size = UDim2.new(0, 20, 0, 20)
    minimizeBtn.Position = UDim2.new(0, 28, 0, 0)
    minimizeBtn.BackgroundColor3 = IcarusCore.Themes[config.theme or "Dark"].Warning
    minimizeBtn.BorderSizePixel = 0
    minimizeBtn.Text = ""
    minimizeBtn.AutoButtonColor = false
    minimizeBtn.Parent = buttonContainer
    CreateCorner(minimizeBtn, 999)
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Name = "Toggle"
    toggleBtn.Size = UDim2.new(0, 20, 0, 20)
    toggleBtn.BackgroundColor3 = IcarusCore.Themes[config.theme or "Dark"].Success
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Text = ""
    toggleBtn.AutoButtonColor = false
    toggleBtn.Parent = buttonContainer
    CreateCorner(toggleBtn, 999)
    
    local tabContainer = Instance.new("ScrollingFrame")
    tabContainer.Name = "TabContainer"
    tabContainer.Size = UDim2.new(0, 165, 1, -52)
    tabContainer.Position = UDim2.new(0, 10, 0, 52)
    tabContainer.BackgroundColor3 = IcarusCore.Themes[config.theme or "Dark"].Secondary
    tabContainer.BorderSizePixel = 0
    tabContainer.ScrollBarThickness = 4
    tabContainer.ScrollBarImageColor3 = IcarusCore.Themes[config.theme or "Dark"].Accent
    tabContainer.Parent = window
    CreateCorner(tabContainer, 8)
    
    local tabList = Instance.new("UIListLayout")
    tabList.Padding = UDim.new(0, 5)
    tabList.SortOrder = Enum.SortOrder.LayoutOrder
    tabList.Parent = tabContainer
    
    local tabPadding = Instance.new("UIPadding")
    tabPadding.PaddingTop = UDim.new(0, 8)
    tabPadding.PaddingBottom = UDim.new(0, 8)
    tabPadding.PaddingLeft = UDim.new(0, 8)
    tabPadding.PaddingRight = UDim.new(0, 8)
    tabPadding.Parent = tabContainer
    
    tabList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabContainer.CanvasSize = UDim2.new(0, 0, 0, tabList.AbsoluteContentSize.Y + 16)
    end)
    
    local contentContainer = Instance.new("Frame")
    contentContainer.Name = "ContentContainer"
    contentContainer.Size = UDim2.new(1, -185, 1, -52)
    contentContainer.Position = UDim2.new(0, 185, 0, 52)
    contentContainer.BackgroundTransparency = 1
    contentContainer.Parent = window
    
    local searchBox = Instance.new("TextBox")
    searchBox.Name = "SearchBox"
    searchBox.Size = UDim2.new(0, 200, 0, 30)
    searchBox.Position = UDim2.new(1, -215, 0, 6)
    searchBox.BackgroundColor3 = IcarusCore.Themes[config.theme or "Dark"].Tertiary
    searchBox.BorderSizePixel = 0
    searchBox.Text = ""
    searchBox.PlaceholderText = "  🔍 Search..."
    searchBox.TextColor3 = IcarusCore.Themes[config.theme or "Dark"].Text
    searchBox.PlaceholderColor3 = IcarusCore.Themes[config.theme or "Dark"].TextDim
    searchBox.Font = Enum.Font.Gotham
    searchBox.TextSize = 12
    searchBox.TextXAlignment = Enum.TextXAlignment.Left
    searchBox.Parent = topbar
    CreateCorner(searchBox, 6)
    CreateStroke(searchBox, IcarusCore.Themes[config.theme or "Dark"].Border, 1)
    
    local dragging = false
    local dragStart, startPos
    
    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = window.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            window.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    closeBtn.MouseButton1Click:Connect(function()
        TweenObject(window, {Size = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Back)
        task.wait(0.3)
        window:Destroy()
        if IcarusCore.ToggleButton then
            IcarusCore.ToggleButton:Destroy()
        end
    end)
    
    closeBtn.MouseEnter:Connect(function()
        TweenObject(closeBtn, {Size = UDim2.new(0, 22, 0, 22), Position = UDim2.new(0, 54, 0, -1)}, 0.15)
    end)
    
    closeBtn.MouseLeave:Connect(function()
        TweenObject(closeBtn, {Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(0, 55, 0, 0)}, 0.15)
    end)
    
    local minimized = false
    minimizeBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            TweenObject(window, {
                Size = UDim2.new(0, 680, 0, 42),
                Position = UDim2.new(0.5, -340, 1, -52)
            }, 0.3, Enum.EasingStyle.Back)
        else
            TweenObject(window, {
                Size = UDim2.new(0, 680, 0, 480),
                Position = UDim2.new(0.5, -340, 0.5, -240)
            }, 0.3, Enum.EasingStyle.Back)
        end
    end)
    
    minimizeBtn.MouseEnter:Connect(function()
        TweenObject(minimizeBtn, {Size = UDim2.new(0, 22, 0, 22), Position = UDim2.new(0, 27, 0, -1)}, 0.15)
    end)
    
    minimizeBtn.MouseLeave:Connect(function()
        TweenObject(minimizeBtn, {Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(0, 28, 0, 0)}, 0.15)
    end)
    
    toggleBtn.MouseButton1Click:Connect(function()
        TweenObject(window, {Size = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Back)
        task.wait(0.3)
        window.Visible = false
        TweenObject(window, {Size = UDim2.new(0, 680, 0, 480)}, 0.01)
        
        IcarusCore:CreateToggleButton(window)
        IcarusCore:Notify({
            text = "Toggle Mode Activated",
            description = "Use square button to toggle GUI",
            duration = 2.5
        })
    end)
    
    toggleBtn.MouseEnter:Connect(function()
        TweenObject(toggleBtn, {Size = UDim2.new(0, 22, 0, 22), Position = UDim2.new(0, -1, 0, -1)}, 0.15)
    end)
    
    toggleBtn.MouseLeave:Connect(function()
        TweenObject(toggleBtn, {Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(0, 0, 0, 0)}, 0.15)
    end)
    
    if config.loadinggui then
        local loadingScreen = Instance.new("Frame")
        loadingScreen.Name = "LoadingScreen"
        loadingScreen.Size = UDim2.new(1, 0, 1, 0)
        loadingScreen.BackgroundColor3 = IcarusCore.Themes[config.theme or "Dark"].Background
        loadingScreen.BorderSizePixel = 0
        loadingScreen.ZIndex = 100
        loadingScreen.Parent = window
        CreateCorner(loadingScreen, 12)
        
        local loadingRing = Instance.new("ImageLabel")
        loadingRing.Size = UDim2.new(0, 60, 0, 60)
        loadingRing.Position = UDim2.new(0.5, -30, 0.5, -30)
        loadingRing.BackgroundTransparency = 1
        loadingRing.Image = "rbxassetid://4965945816"
        loadingRing.ImageColor3 = IcarusCore.Themes[config.theme or "Dark"].Accent
        loadingRing.Parent = loadingScreen
        
        local loadingText = Instance.new("TextLabel")
        loadingText.Size = UDim2.new(0, 250, 0, 30)
        loadingText.Position = UDim2.new(0.5, -125, 0.5, 45)
        loadingText.BackgroundTransparency = 1
        loadingText.Text = "Loading Icarus..."
        loadingText.TextColor3 = IcarusCore.Themes[config.theme or "Dark"].Text
        loadingText.Font = Enum.Font.GothamBold
        loadingText.TextSize = 15
        loadingText.Parent = loadingScreen
        
        local progressBar = Instance.new("Frame")
        progressBar.Size = UDim2.new(0, 0, 0, 3)
        progressBar.Position = UDim2.new(0.5, -100, 0.5, 80)
        progressBar.BackgroundColor3 = IcarusCore.Themes[config.theme or "Dark"].Accent
        progressBar.BorderSizePixel = 0
        progressBar.Parent = loadingScreen
        CreateCorner(progressBar, 999)
        
        spawn(function()
            while loadingScreen.Parent do
                TweenObject(loadingRing, {Rotation = 360}, 1.5, Enum.EasingStyle.Linear)
                task.wait(1.5)
                loadingRing.Rotation = 0
            end
        end)
        
        TweenObject(progressBar, {Size = UDim2.new(0, 200, 0, 3)}, 1.5)
        
        task.delay(1.8, function()
            TweenObject(loadingScreen, {BackgroundTransparency = 1}, 0.4)
            TweenObject(loadingRing, {ImageTransparency = 1}, 0.4)
            TweenObject(loadingText, {TextTransparency = 1}, 0.4)
            TweenObject(progressBar, {BackgroundTransparency = 1}, 0.4)
            task.wait(0.4)
            loadingScreen:Destroy()
        end)
    end
    
    IcarusCore.MainWindow = window
    
    local windowObj = {
        Window = window,
        TabContainer = tabContainer,
        ContentContainer = contentContainer,
        Tabs = {},
        CurrentTab = nil,
        Theme = config.theme or "Dark"
    }
    
    setmetatable(windowObj, IcarusLibrary)
    return windowObj
end

function IcarusLibrary:AddTab(config)
    local tabButton = Instance.new("TextButton")
    tabButton.Name = config.text
    tabButton.Size = UDim2.new(1, 0, 0, 36)
    tabButton.BackgroundColor3 = IcarusCore.Themes[self.Theme].Tertiary
    tabButton.BorderSizePixel = 0
    tabButton.Text = ""
    tabButton.AutoButtonColor = false
    tabButton.Parent = self.TabContainer
    CreateCorner(tabButton, 6)
    
    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.new(0, 20, 0, 20)
    icon.Position = UDim2.new(0, 10, 0.5, -10)
    icon.BackgroundTransparency = 1
    icon.Image = config.icon or "rbxassetid://7734053426"
    icon.ImageColor3 = IcarusCore.Themes[self.Theme].TextDim
    icon.Parent = tabButton
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -40, 1, 0)
    label.Position = UDim2.new(0, 35, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = config.text
    label.TextColor3 = IcarusCore.Themes[self.Theme].TextDim
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = tabButton
    
    local contentFrame = Instance.new("ScrollingFrame")
    contentFrame.Name = config.text
    contentFrame.Size = UDim2.new(1, 0, 1, 0)
    contentFrame.BackgroundTransparency = 1
    contentFrame.BorderSizePixel = 0
    contentFrame.ScrollBarThickness = 4
    contentFrame.ScrollBarImageColor3 = IcarusCore.Themes[self.Theme].Accent
    contentFrame.Visible = false
    contentFrame.Parent = self.ContentContainer
    
    local contentList = Instance.new("UIListLayout")
    contentList.Padding = UDim.new(0, 8)
    contentList.SortOrder = Enum.SortOrder.LayoutOrder
    contentList.Parent = contentFrame
    
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 8)
    padding.PaddingBottom = UDim.new(0, 8)
    padding.PaddingLeft = UDim.new(0, 8)
    padding.PaddingRight = UDim.new(0, 12)
    padding.Parent = contentFrame
    
    contentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        contentFrame.CanvasSize = UDim2.new(0, 0, 0, contentList.AbsoluteContentSize.Y + 16)
    end)
    
    tabButton.MouseButton1Click:Connect(function()
        for _, tab in pairs(self.Tabs) do
            TweenObject(tab.Button, {BackgroundColor3 = IcarusCore.Themes[self.Theme].Tertiary}, 0.2)
            TweenObject(tab.Icon, {ImageColor3 = IcarusCore.Themes[self.Theme].TextDim}, 0.2)
            TweenObject(tab.Label, {TextColor3 = IcarusCore.Themes[self.Theme].TextDim}, 0.2)
            tab.Content.Visible = false
        end
        TweenObject(tabButton, {BackgroundColor3 = IcarusCore.Themes[self.Theme].Accent}, 0.2)
        TweenObject(icon, {ImageColor3 = Color3.fromRGB(255, 255, 255)}, 0.2)
        TweenObject(label, {TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.2)
        contentFrame.Visible = true
        self.CurrentTab = config.text
    end)
    
    tabButton.MouseEnter:Connect(function()
        if self.CurrentTab ~= config.text then
            TweenObject(tabButton, {BackgroundColor3 = IcarusCore.Themes[self.Theme].Secondary}, 0.15)
        end
    end)
    
    tabButton.MouseLeave:Connect(function()
        if self.CurrentTab ~= config.text then
            TweenObject(tabButton, {BackgroundColor3 = IcarusCore.Themes[self.Theme].Tertiary}, 0.15)
        end
    end)
    
    local tabObj = {
        Button = tabButton,
        Content = contentFrame,
        Icon = icon,
        Label = label,
        Elements = {}
    }
    
    table.insert(self.Tabs, tabObj)
    
    if #self.Tabs == 1 then
        tabButton.BackgroundColor3 = IcarusCore.Themes[self.Theme].Accent
        icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        contentFrame.Visible = true
        self.CurrentTab = config.text
    end
    
    local tabFunctions = {}
    
    function tabFunctions:AddGroupbox(config)
        local groupbox = Instance.new("Frame")
        groupbox.Name = config.text
        groupbox.Size = UDim2.new(1, 0, 0, 50)
        groupbox.BackgroundColor3 = IcarusCore.Themes[self.Theme].Secondary
        groupbox.BorderSizePixel = 0
        groupbox.Parent = contentFrame
        CreateCorner(groupbox, 8)
        CreateStroke(groupbox, IcarusCore.Themes[self.Theme].Border, 1)
        
        local groupboxIcon = Instance.new("ImageLabel")
        groupboxIcon.Size = UDim2.new(0, 18, 0, 18)
        groupboxIcon.Position = UDim2.new(0, 10, 0, 10)
        groupboxIcon.BackgroundTransparency = 1
        groupboxIcon.Image = config.icon or "rbxassetid://7734053426"
        groupboxIcon.ImageColor3 = IcarusCore.Themes[self.Theme].Accent
        groupboxIcon.Parent = groupbox
        
        local groupboxLabel = Instance.new("TextLabel")
        groupboxLabel.Size = UDim2.new(1, -40, 0, 26)
        groupboxLabel.Position = UDim2.new(0, 33, 0, 7)
        groupboxLabel.BackgroundTransparency = 1
        groupboxLabel.Text = config.text
        groupboxLabel.TextColor3 = IcarusCore.Themes[self.Theme].Text
        groupboxLabel.Font = Enum.Font.GothamBold
        groupboxLabel.TextSize = 14
        groupboxLabel.TextXAlignment = Enum.TextXAlignment.Left
        groupboxLabel.Parent = groupbox
        
        local groupboxContent = Instance.new("Frame")
        groupboxContent.Name = "Content"
        groupboxContent.Size = UDim2.new(1, -20, 1, -40)
        groupboxContent.Position = UDim2.new(0, 10, 0, 38)
        groupboxContent.BackgroundTransparency = 1
        groupboxContent.Parent = groupbox
        
        local groupboxList = Instance.new("UIListLayout")
        groupboxList.Padding = UDim.new(0, 6)
        groupboxList.SortOrder = Enum.SortOrder.LayoutOrder
        groupboxList.Parent = groupboxContent
        
        groupboxList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            groupbox.Size = UDim2.new(1, 0, 0, groupboxList.AbsoluteContentSize.Y + 50)
        end)
        
        return {
            Groupbox = groupbox,
            Content = groupboxContent
        }
    end
    
    function tabFunctions:AddLabel(config)
        local label = Instance.new("TextLabel")
        label.Name = "Label"
        label.Size = UDim2.new(1, 0, 0, 20)
        label.BackgroundTransparency = 1
        label.Text = config.text
        label.TextColor3 = IcarusCore.Themes[self.Theme].Text
        label.Font = Enum.Font.Gotham
        label.TextSize = 13
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = contentFrame
        return label
    end
    
    function tabFunctions:AddButton(config)
        local button = Instance.new("TextButton")
        button.Name = "Button"
        button.Size = UDim2.new(1, 0, 0, 36)
        button.BackgroundColor3 = IcarusCore.Themes[self.Theme].Accent
        button.BorderSizePixel = 0
        button.Text = config.text
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.Font = Enum.Font.GothamBold
        button.TextSize = 13
        button.AutoButtonColor = false
        button.Parent = contentFrame
        CreateCorner(button, 6)
        
        button.MouseButton1Click:Connect(function()
            if config.callback then
                config.callback()
            end
        end)
        
        button.MouseEnter:Connect(function()
            TweenObject(button, {BackgroundColor3 = IcarusCore.Themes[self.Theme].AccentHover}, 0.15)
        end)
        
        button.MouseLeave:Connect(function()
            TweenObject(button, {BackgroundColor3 = IcarusCore.Themes[self.Theme].Accent}, 0.15)
        end)
        
        return button
    end
    
    function tabFunctions:AddParagraph(config)
        local paragraph = Instance.new("Frame")
        paragraph.Name = "Paragraph"
        paragraph.Size = UDim2.new(1, 0, 0, 60)
        paragraph.BackgroundColor3 = IcarusCore.Themes[self.Theme].Secondary
        paragraph.BorderSizePixel = 0
        paragraph.Parent = contentFrame
        CreateCorner(paragraph, 6)
        CreateStroke(paragraph, IcarusCore.Themes[self.Theme].Border, 1)
        
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, -20, 0, 20)
        title.Position = UDim2.new(0, 10, 0, 8)
        title.BackgroundTransparency = 1
        title.Text = config.text
        title.TextColor3 = IcarusCore.Themes[self.Theme].Text
        title.Font = Enum.Font.GothamBold
        title.TextSize = 13
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Parent = paragraph
        
        local desc = Instance.new("TextLabel")
        desc.Size = UDim2.new(1, -20, 0, 28)
        desc.Position = UDim2.new(0, 10, 0, 28)
        desc.BackgroundTransparency = 1
        desc.Text = config.description or ""
        desc.TextColor3 = IcarusCore.Themes[self.Theme].TextDim
        desc.Font = Enum.Font.Gotham
        desc.TextSize = 12
        desc.TextXAlignment = Enum.TextXAlignment.Left
        desc.TextYAlignment = Enum.TextYAlignment.Top
        desc.TextWrapped = true
        desc.Parent = paragraph
        
        return paragraph
    end
    
    function tabFunctions:AddToggle(config)
        local toggleFrame = Instance.new("Frame")
        toggleFrame.Name = "Toggle"
        toggleFrame.Size = UDim2.new(1, 0, 0, 36)
        toggleFrame.BackgroundColor3 = IcarusCore.Themes[self.Theme].Secondary
        toggleFrame.BorderSizePixel = 0
        toggleFrame.Parent = contentFrame
        CreateCorner(toggleFrame, 6)
        CreateStroke(toggleFrame, IcarusCore.Themes[self.Theme].Border, 1)
        
        local toggleLabel = Instance.new("TextLabel")
        toggleLabel.Size = UDim2.new(1, -60, 1, 0)
        toggleLabel.Position = UDim2.new(0, 10, 0, 0)
        toggleLabel.BackgroundTransparency = 1
        toggleLabel.Text = config.text
        toggleLabel.TextColor3 = IcarusCore.Themes[self.Theme].Text
        toggleLabel.Font = Enum.Font.Gotham
        toggleLabel.TextSize = 13
        toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
        toggleLabel.Parent = toggleFrame
        
        local toggleButton = Instance.new("TextButton")
        toggleButton.Size = UDim2.new(0, 46, 0, 22)
        toggleButton.Position = UDim2.new(1, -56, 0.5, -11)
        toggleButton.BackgroundColor3 = config.type and IcarusCore.Themes[self.Theme].Accent or IcarusCore.Themes[self.Theme].Tertiary
        toggleButton.BorderSizePixel = 0
        toggleButton.Text = ""
        toggleButton.AutoButtonColor = false
        toggleButton.Parent = toggleFrame
        CreateCorner(toggleButton, 999)
        
        local toggleCircle = Instance.new("Frame")
        toggleCircle.Size = UDim2.new(0, 18, 0, 18)
        toggleCircle.Position = config.type and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
        toggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        toggleCircle.BorderSizePixel = 0
        toggleCircle.Parent = toggleButton
        CreateCorner(toggleCircle, 999)
        
        local toggled = config.type or false
        
        toggleButton.MouseButton1Click:Connect(function()
            toggled = not toggled
            TweenObject(toggleButton, {
                BackgroundColor3 = toggled and IcarusCore.Themes[self.Theme].Accent or IcarusCore.Themes[self.Theme].Tertiary
            }, 0.2)
            TweenObject(toggleCircle, {
                Position = toggled and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
            }, 0.2, Enum.EasingStyle.Quad)
            if config.callback then
                config.callback(toggled)
            end
        end)
        
        return {
            Frame = toggleFrame,
            SetValue = function(value)
                toggled = value
                TweenObject(toggleButton, {
                    BackgroundColor3 = value and IcarusCore.Themes[self.Theme].Accent or IcarusCore.Themes[self.Theme].Tertiary
                }, 0.2)
                TweenObject(toggleCircle, {
                    Position = value and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
                }, 0.2)
            end
        }
    end
    
    function tabFunctions:AddSlider(config)
        local sliderFrame = Instance.new("Frame")
        sliderFrame.Name = "Slider"
        sliderFrame.Size = UDim2.new(1, 0, 0, 50)
        sliderFrame.BackgroundColor3 = IcarusCore.Themes[self.Theme].Secondary
        sliderFrame.BorderSizePixel = 0
        sliderFrame.Parent = contentFrame
        CreateCorner(sliderFrame, 6)
        CreateStroke(sliderFrame, IcarusCore.Themes[self.Theme].Border, 1)
        
        local sliderLabel = Instance.new("TextLabel")
        sliderLabel.Size = UDim2.new(1, -60, 0, 20)
        sliderLabel.Position = UDim2.new(0, 10, 0, 5)
        sliderLabel.BackgroundTransparency = 1
        sliderLabel.Text = config.text
        sliderLabel.TextColor3 = IcarusCore.Themes[self.Theme].Text
        sliderLabel.Font = Enum.Font.Gotham
        sliderLabel.TextSize = 13
        sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
        sliderLabel.Parent = sliderFrame
        
        local valueLabel = Instance.new("TextLabel")
        valueLabel.Size = UDim2.new(0, 50, 0, 20)
        valueLabel.Position = UDim2.new(1, -60, 0, 5)
        valueLabel.BackgroundTransparency = 1
        valueLabel.Text = tostring(config.default or config.min)
        valueLabel.TextColor3 = IcarusCore.Themes[self.Theme].Accent
        valueLabel.Font = Enum.Font.GothamBold
        valueLabel.TextSize = 13
        valueLabel.TextXAlignment = Enum.TextXAlignment.Right
        valueLabel.Parent = sliderFrame
        
        local sliderTrack = Instance.new("Frame")
        sliderTrack.Size = UDim2.new(1, -20, 0, 6)
        sliderTrack.Position = UDim2.new(0, 10, 1, -16)
        sliderTrack.BackgroundColor3 = IcarusCore.Themes[self.Theme].Tertiary
        sliderTrack.BorderSizePixel = 0
        sliderTrack.Parent = sliderFrame
        CreateCorner(sliderTrack, 999)
        
        local sliderFill = Instance.new("Frame")
        sliderFill.Size = UDim2.new(0, 0, 1, 0)
        sliderFill.BackgroundColor3 = IcarusCore.Themes[self.Theme].Accent
        sliderFill.BorderSizePixel = 0
        sliderFill.Parent = sliderTrack
        CreateCorner(sliderFill, 999)
        
        local sliderDot = Instance.new("Frame")
        sliderDot.Size = UDim2.new(0, 14, 0, 14)
        sliderDot.Position = UDim2.new(1, -7, 0.5, -7)
        sliderDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        sliderDot.BorderSizePixel = 0
        sliderDot.Parent = sliderFill
        CreateCorner(sliderDot, 999)
        
        local sliderInput = Instance.new("TextButton")
        sliderInput.Size = UDim2.new(1, 0, 1, 8)
        sliderInput.Position = UDim2.new(0, 0, 0, -4)
        sliderInput.BackgroundTransparency = 1
        sliderInput.Text = ""
        sliderInput.Parent = sliderTrack
        
        local dragging = false
        
        local function updateSlider(input)
            local relativeX = math.clamp((input.Position.X - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X, 0, 1)
            local value = math.floor(config.min + (config.max - config.min) * relativeX)
            valueLabel.Text = tostring(value)
            sliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
            if config.callback then
                config.callback(value)
            end
        end
        
        sliderInput.MouseButton1Down:Connect(function()
            dragging = true
            TweenObject(sliderDot, {Size = UDim2.new(0, 16, 0, 16), Position = UDim2.new(1, -8, 0.5, -8)}, 0.1)
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
                TweenObject(sliderDot, {Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(1, -7, 0.5, -7)}, 0.15)
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                updateSlider(input)
            end
        end)
        
        sliderInput.MouseButton1Click:Connect(updateSlider)
        
        local defaultRatio = (config.default - config.min) / (config.max - config.min)
        sliderFill.Size = UDim2.new(defaultRatio, 0, 1, 0)
        
        return sliderFrame
    end
    
    function tabFunctions:AddDropdown(config)
        local dropdownFrame = Instance.new("Frame")
        dropdownFrame.Name = "Dropdown"
        dropdownFrame.Size = UDim2.new(1, 0, 0, 36)
        dropdownFrame.BackgroundColor3 = IcarusCore.Themes[self.Theme].Secondary
        dropdownFrame.BorderSizePixel = 0
        dropdownFrame.ClipsDescendants = false
        dropdownFrame.ZIndex = 5
        dropdownFrame.Parent = contentFrame
        CreateCorner(dropdownFrame, 6)
        CreateStroke(dropdownFrame, IcarusCore.Themes[self.Theme].Border, 1)
        
        local dropdownButton = Instance.new("TextButton")
        dropdownButton.Size = UDim2.new(1, 0, 0, 36)
        dropdownButton.BackgroundTransparency = 1
        dropdownButton.Text = ""
        dropdownButton.ZIndex = 6
        dropdownButton.Parent = dropdownFrame
        
        local dropdownLabel = Instance.new("TextLabel")
        dropdownLabel.Size = UDim2.new(1, -40, 0, 36)
        dropdownLabel.Position = UDim2.new(0, 10, 0, 0)
        dropdownLabel.BackgroundTransparency = 1
        dropdownLabel.Text = config.text
        dropdownLabel.TextColor3 = IcarusCore.Themes[self.Theme].Text
        dropdownLabel.Font = Enum.Font.Gotham
        dropdownLabel.TextSize = 13
        dropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
        dropdownLabel.ZIndex = 6
        dropdownLabel.Parent = dropdownFrame
        
        local dropdownIcon = Instance.new("ImageLabel")
        dropdownIcon.Size = UDim2.new(0, 16, 0, 16)
        dropdownIcon.Position = UDim2.new(1, -26, 0, 10)
        dropdownIcon.BackgroundTransparency = 1
        dropdownIcon.Image = "rbxassetid://7733717447"
        dropdownIcon.ImageColor3 = IcarusCore.Themes[self.Theme].TextDim
        dropdownIcon.Rotation = 0
        dropdownIcon.ZIndex = 6
        dropdownIcon.Parent = dropdownFrame
        
        local dropdownContainer = Instance.new("ScrollingFrame")
        dropdownContainer.Name = "DropdownContainer"
        dropdownContainer.Size = UDim2.new(1, 0, 0, 0)
        dropdownContainer.Position = UDim2.new(0, 0, 0, 40)
        dropdownContainer.BackgroundColor3 = IcarusCore.Themes[self.Theme].Tertiary
        dropdownContainer.BorderSizePixel = 0
        dropdownContainer.ClipsDescendants = true
        dropdownContainer.ScrollBarThickness = 3
        dropdownContainer.ScrollBarImageColor3 = IcarusCore.Themes[self.Theme].Accent
        dropdownContainer.ZIndex = 50
        dropdownContainer.Parent = dropdownFrame
        CreateCorner(dropdownContainer, 6)
        CreateStroke(dropdownContainer, IcarusCore.Themes[self.Theme].Accent, 1)
        
        local dropdownList = Instance.new("UIListLayout")
        dropdownList.Padding = UDim.new(0, 3)
        dropdownList.Parent = dropdownContainer
        
        local dropdownPadding = Instance.new("UIPadding")
        dropdownPadding.PaddingTop = UDim.new(0, 5)
        dropdownPadding.PaddingBottom = UDim.new(0, 5)
        dropdownPadding.PaddingLeft = UDim.new(0, 5)
        dropdownPadding.PaddingRight = UDim.new(0, 5)
        dropdownPadding.Parent = dropdownContainer
        
        local opened = false
        local selectedValues = {}
        
        dropdownButton.MouseButton1Click:Connect(function()
            opened = not opened
            TweenObject(dropdownIcon, {Rotation = opened and 180 or 0}, 0.2)
            
            local targetHeight = opened and math.min(#config.options * 30 + 10, 180) or 0
            TweenObject(dropdownContainer, {Size = UDim2.new(1, 0, 0, targetHeight)}, 0.25, Enum.EasingStyle.Quad)
            dropdownContainer.CanvasSize = UDim2.new(0, 0, 0, #config.options * 30 + 10)
        end)
        
        for _, option in ipairs(config.options) do
            local optionButton = Instance.new("TextButton")
            optionButton.Size = UDim2.new(1, 0, 0, 26)
            optionButton.BackgroundColor3 = IcarusCore.Themes[self.Theme].Secondary
            optionButton.BorderSizePixel = 0
            optionButton.Text = option
            optionButton.TextColor3 = IcarusCore.Themes[self.Theme].Text
            optionButton.Font = Enum.Font.Gotham
            optionButton.TextSize = 12
            optionButton.AutoButtonColor = false
            optionButton.ZIndex = 51
            optionButton.Parent = dropdownContainer
            CreateCorner(optionButton, 5)
            
            optionButton.MouseButton1Click:Connect(function()
                if config.multi then
                    local index = table.find(selectedValues, option)
                    if index then
                        table.remove(selectedValues, index)
                        TweenObject(optionButton, {BackgroundColor3 = IcarusCore.Themes[self.Theme].Secondary}, 0.15)
                    else
                        table.insert(selectedValues, option)
                        TweenObject(optionButton, {BackgroundColor3 = IcarusCore.Themes[self.Theme].Accent}, 0.15)
                    end
                else
                    selectedValues = {option}
                    for _, btn in pairs(dropdownContainer:GetChildren()) do
                        if btn:IsA("TextButton") then
                            TweenObject(btn, {BackgroundColor3 = IcarusCore.Themes[self.Theme].Secondary}, 0.15)
                        end
                    end
                    TweenObject(optionButton, {BackgroundColor3 = IcarusCore.Themes[self.Theme].Accent}, 0.15)
                end
                
                if config.callback then
                    config.callback(selectedValues)
                end
            end)
            
            optionButton.MouseEnter:Connect(function()
                if not table.find(selectedValues, option) then
                    TweenObject(optionButton, {BackgroundColor3 = IcarusCore.Themes[self.Theme].Tertiary}, 0.15)
                end
            end)
            
            optionButton.MouseLeave:Connect(function()
                if not table.find(selectedValues, option) then
                    TweenObject(optionButton, {BackgroundColor3 = IcarusCore.Themes[self.Theme].Secondary}, 0.15)
                end
            end)
        end
        
        return dropdownFrame
    end
    
    function tabFunctions:AddDivider(text)
        local divider = Instance.new("Frame")
        divider.Name = "Divider"
        divider.Size = UDim2.new(1, 0, 0, text and 26 or 1)
        divider.BackgroundColor3 = IcarusCore.Themes[self.Theme].Border
        divider.BackgroundTransparency = text and 1 or 0.3
        divider.BorderSizePixel = 0
        divider.Parent = contentFrame
        
        if text then
            local line1 = Instance.new("Frame")
            line1.Size = UDim2.new(0.35, 0, 0, 1)
            line1.Position = UDim2.new(0, 0, 0.5, 0)
            line1.BackgroundColor3 = IcarusCore.Themes[self.Theme].Border
            line1.BackgroundTransparency = 0.3
            line1.BorderSizePixel = 0
            line1.Parent = divider
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0.3, 0, 1, 0)
            label.Position = UDim2.new(0.35, 0, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = text
            label.TextColor3 = IcarusCore.Themes[self.Theme].TextDim
            label.Font = Enum.Font.GothamBold
            label.TextSize = 12
            label.Parent = divider
            
            local line2 = Instance.new("Frame")
            line2.Size = UDim2.new(0.35, 0, 0, 1)
            line2.Position = UDim2.new(0.65, 0, 0.5, 0)
            line2.BackgroundColor3 = IcarusCore.Themes[self.Theme].Border
            line2.BackgroundTransparency = 0.3
            line2.BorderSizePixel = 0
            line2.Parent = divider
        end
        
        return divider
    end
    
    return tabFunctions
end

function IcarusLibrary:AddTheme(themeConfig)
    IcarusCore.Themes.Custom = {
        Background = themeConfig.background and Color3.fromHex(themeConfig.background) or Color3.fromRGB(18, 18, 24),
        Secondary = themeConfig.secondary and Color3.fromHex(themeConfig.secondary) or Color3.fromRGB(24, 24, 32),
        Tertiary = themeConfig.tertiary and Color3.fromHex(themeConfig.tertiary) or Color3.fromRGB(32, 32, 42),
        Border = themeConfig.border and Color3.fromHex(themeConfig.border) or Color3.fromRGB(45, 45, 60),
        Text = themeConfig.text and Color3.fromHex(themeConfig.text) or Color3.fromRGB(255, 255, 255),
        TextDim = themeConfig.text_dim and Color3.fromHex(themeConfig.text_dim) or Color3.fromRGB(180, 180, 200),
        Accent = themeConfig.accent and Color3.fromHex(themeConfig.accent) or Color3.fromRGB(138, 43, 226),
        AccentHover = themeConfig.accent_hover and Color3.fromHex(themeConfig.accent_hover) or Color3.fromRGB(158, 63, 246),
        AccentDark = themeConfig.accent_dark and Color3.fromHex(themeConfig.accent_dark) or Color3.fromRGB(118, 23, 206),
        Success = Color3.fromRGB(40, 201, 64),
        Warning = Color3.fromRGB(255, 189, 68),
        Danger = Color3.fromRGB(255, 95, 86)
    }
    IcarusCore.CurrentTheme = "Custom"
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed then
        for _, keybind in pairs(IcarusCore.Keybinds) do
            if input.KeyCode == keybind.Key then
                keybind.Callback()
            end
        end
    end
end)

task.spawn(function()
    task.wait(0.5)
    IcarusCore:Notify({
        text = "Icarus Library Loaded",
        description = "Ultra Premium System Ready",
        duration = 2.5
    })
end)

return IcarusLibrary
