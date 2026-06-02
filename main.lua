local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local Library = {}

Library.Theme = {
    DeepBg = Color3.fromRGB(24, 24, 24),     
    SidebarBg = Color3.fromRGB(32, 32, 32),  
    Border = Color3.fromRGB(48, 48, 48),     
    Accent = Color3.fromRGB(124, 58, 237),   
    Text = Color3.fromRGB(220, 220, 220),    
    TextMuted = Color3.fromRGB(140, 140, 145),
    GroupBoxBg = Color3.fromRGB(28, 28, 28)
}

Library.Icons = {
    home = "rbxassetid://10734934551",
    shield = "rbxassetid://10734950309",
    zap = "rbxassetid://10734947413",
    eye = "rbxassetid://10734896245",
    code = "rbxassetid://10734919316",
    sliders = "rbxassetid://10734921609",
    target = "rbxassetid://10734941199",
    settings = "rbxassetid://10734950020",
    sword = "rbxassetid://10723374641",
    crosshair = "rbxassetid://10723346959",
    key = "rbxassetid://10734943441",
    lock = "rbxassetid://10734943549",
    trash = "rbxassetid://10747373861",
    refresh = "rbxassetid://10747363435",
    map = "rbxassetid://10734943674",
    info = "rbxassetid://10734934785",
    user = "rbxassetid://10747383161",
    mouse = "rbxassetid://10723345553",
    star = "rbxassetid://10747371915",
    heart = "rbxassetid://10723348621"
}

function Library:CreateWindow(options)
    local config = options or {}
    local titleText = config.title or config.Title or "Window"

    local sg = Instance.new("ScreenGui", PlayerGui)
    sg.Name = "ObsidianEngine"
    sg.ResetOnSpawn = false

    local main = Instance.new("Frame", sg)
    main.Size = UDim2.new(0, 650, 0, 450)
    main.Position = UDim2.new(0.5, -325, 0.5, -225)
    main.BackgroundColor3 = Library.Theme.DeepBg
    main.BorderSizePixel = 0
    
    local mainStroke = Instance.new("UIStroke", main)
    mainStroke.Color = Library.Theme.Border
    mainStroke.Thickness = 1

    local corner = Instance.new("UICorner", main)
    corner.CornerRadius = UDim.new(0, 6)

    local leftSidebar = Instance.new("Frame", main)
    leftSidebar.Size = UDim2.new(0, 160, 1, 0)
    leftSidebar.BackgroundColor3 = Library.Theme.SidebarBg
    leftSidebar.BorderSizePixel = 0
    
    local leftSidebarCorner = Instance.new("UICorner", leftSidebar)
    leftSidebarCorner.CornerRadius = UDim.new(0, 6)
    
    local sideFix = Instance.new("Frame", leftSidebar)
    sideFix.Size = UDim2.new(0, 10, 1, 0)
    sideFix.Position = UDim2.new(1, -10, 0, 0)
    sideFix.BackgroundColor3 = Library.Theme.SidebarBg
    sideFix.BorderSizePixel = 0

    local leftBorder = Instance.new("Frame", leftSidebar)
    leftBorder.Size = UDim2.new(0, 1, 1, 0)
    leftBorder.Position = UDim2.new(1, -1, 0, 0)
    leftBorder.BackgroundColor3 = Library.Theme.Border
    leftBorder.BorderSizePixel = 0

    local explorerTitle = Instance.new("TextLabel", leftSidebar)
    explorerTitle.Size = UDim2.new(1, -20, 0, 40)
    explorerTitle.Position = UDim2.new(0, 15, 0, 0)
    explorerTitle.Text = titleText
    explorerTitle.Font = Enum.Font.GothamBold
    explorerTitle.TextSize = 13
    explorerTitle.TextColor3 = Library.Theme.Text
    explorerTitle.TextXAlignment = Enum.TextXAlignment.Left
    explorerTitle.BackgroundTransparency = 1

    local contentArea = Instance.new("Frame", main)
    contentArea.Size = UDim2.new(1, -160, 1, 0)
    contentArea.Position = UDim2.new(0, 160, 0, 0)
    contentArea.BackgroundTransparency = 1

    local tabScroll = Instance.new("ScrollingFrame", leftSidebar)
    tabScroll.Size = UDim2.new(1, -10, 1, -50)
    tabScroll.Position = UDim2.new(0, 5, 0, 45)
    tabScroll.BackgroundTransparency = 1
    tabScroll.BorderSizePixel = 0
    tabScroll.ScrollBarThickness = 0

    local tabLayout = Instance.new("UIListLayout", tabScroll)
    tabLayout.Padding = UDim.new(0, 4)

    local dragging, dragInput, dragStart, startPos
    main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    main.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    local windowActions = {}
    local firstTab = true

    function windowActions:CreateTab(tabOptions)
        local tabConfig = tabOptions or {}
        local tabName = tabConfig.name or "Tab"
        local iconName = tabConfig.icon or "home"
        local iconId = Library.Icons[iconName] or Library.Icons["home"]

        local tabBtn = Instance.new("TextButton", tabScroll)
        tabBtn.Size = UDim2.new(1, 0, 0, 32)
        tabBtn.BackgroundTransparency = 1
        tabBtn.Text = ""
        tabBtn.AutoButtonColor = false

        local tabCorner = Instance.new("UICorner", tabBtn)
        tabCorner.CornerRadius = UDim.new(0, 4)

        local iconImg = Instance.new("ImageLabel", tabBtn)
        iconImg.Size = UDim2.new(0, 16, 0, 16)
        iconImg.Position = UDim2.new(0, 10, 0.5, -8)
        iconImg.BackgroundTransparency = 1
        iconImg.Image = iconId
        iconImg.ImageColor3 = Library.Theme.TextMuted

        local nameLabel = Instance.new("TextLabel", tabBtn)
        nameLabel.Size = UDim2.new(1, -36, 1, 0)
        nameLabel.Position = UDim2.new(0, 32, 0, 0)
        nameLabel.Text = tabName
        nameLabel.Font = Enum.Font.GothamMedium
        nameLabel.TextSize = 12
        nameLabel.TextColor3 = Library.Theme.TextMuted
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.BackgroundTransparency = 1

        local mainTabFrame = Instance.new("ScrollingFrame", contentArea)
        mainTabFrame.Size = UDim2.new(1, 0, 1, 0)
        mainTabFrame.BackgroundTransparency = 1
        mainTabFrame.BorderSizePixel = 0
        mainTabFrame.ScrollBarThickness = 2
        mainTabFrame.ScrollBarImageColor3 = Library.Theme.Border
        mainTabFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        mainTabFrame.AutomaticCanvasSize = Enum.AutomaticCanvasSize.Y
        mainTabFrame.Visible = false

        local leftColumn = Instance.new("Frame", mainTabFrame)
        leftColumn.Size = UDim2.new(0.5, -15, 0, 0)
        leftColumn.Position = UDim2.new(0, 10, 0, 15)
        leftColumn.BackgroundTransparency = 1
        leftColumn.AutomaticSize = Enum.AutomaticSize.Y

        local leftLayout = Instance.new("UIListLayout", leftColumn)
        leftLayout.Padding = UDim.new(0, 12)

        local rightColumn = Instance.new("Frame", mainTabFrame)
        rightColumn.Size = UDim2.new(0.5, -15, 0, 0)
        rightColumn.Position = UDim2.new(0.5, 5, 0, 15)
        rightColumn.BackgroundTransparency = 1
        rightColumn.AutomaticSize = Enum.AutomaticSize.Y

        local rightLayout = Instance.new("UIListLayout", rightColumn)
        rightLayout.Padding = UDim.new(0, 12)

        if firstTab then
            firstTab = false
            tabBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            tabBtn.BackgroundTransparency = 0.5
            iconImg.ImageColor3 = Library.Theme.Accent
            nameLabel.TextColor3 = Library.Theme.Text
            mainTabFrame.Visible = true
        end

        tabBtn.MouseButton1Click:Connect(function()
            for _, child in pairs(tabScroll:GetChildren()) do
                if child:IsA("TextButton") then
                    child.BackgroundTransparency = 1
                    child.ImageLabel.ImageColor3 = Library.Theme.TextMuted
                    child.TextLabel.TextColor3 = Library.Theme.TextMuted
                end
            end
            for _, canvas in pairs(contentArea:GetChildren()) do
                if canvas:IsA("ScrollingFrame") then
                    canvas.Visible = false
                end
            end
            tabBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            tabBtn.BackgroundTransparency = 0.5
            iconImg.ImageColor3 = Library.Theme.Accent
            nameLabel.TextColor3 = Library.Theme.Text
            mainTabFrame.Visible = true
        end)

        local tabActions = {}

        function tabActions:CreateGroupBox(boxOptions)
            local boxConfig = boxOptions or {}
            local boxName = boxConfig.name or "Group"
            local side = boxConfig.side or "left"
            local targetColumn = leftColumn
            
            if string.lower(side) == "right" then
                targetColumn = rightColumn
            end

            local boxFrame = Instance.new("Frame", targetColumn)
            boxFrame.Size = UDim2.new(1, 0, 0, 0)
            boxFrame.BackgroundColor3 = Library.Theme.GroupBoxBg
            boxFrame.BorderSizePixel = 0
            boxFrame.AutomaticSize = Enum.AutomaticSize.Y

            local boxCorner = Instance.new("UICorner", boxFrame)
            boxCorner.CornerRadius = UDim.new(0, 4)

            local boxStroke = Instance.new("UIStroke", boxFrame)
            boxStroke.Color = Library.Theme.Border
            boxStroke.Thickness = 1

            local boxTitle = Instance.new("TextLabel", boxFrame)
            boxTitle.Size = UDim2.new(1, -20, 0, 28)
            boxTitle.Position = UDim2.new(0, 10, 0, 0)
            boxTitle.Text = boxName
            boxTitle.Font = Enum.Font.GothamBold
            boxTitle.TextSize = 11
            boxTitle.TextColor3 = Library.Theme.TextMuted
            boxTitle.TextXAlignment = Enum.TextXAlignment.Left
            boxTitle.BackgroundTransparency = 1

            local elementContainer = Instance.new("Frame", boxFrame)
            elementContainer.Size = UDim2.new(1, -20, 0, 0)
            elementContainer.Position = UDim2.new(0, 10, 0, 28)
            elementContainer.BackgroundTransparency = 1
            elementContainer.AutomaticSize = Enum.AutomaticSize.Y

            local elementLayout = Instance.new("UIListLayout", elementContainer)
            elementLayout.Padding = UDim.new(0, 10)
            
            local paddingFix = Instance.new("UIPadding", elementContainer)
            paddingFix.PaddingBottom = UDim.new(0, 10)

            local boxActions = {}

            function boxActions:AddToggle(text, default, callback)
                local row = Instance.new("Frame", elementContainer)
                row.Size = UDim2.new(1, 0, 0, 24)
                row.BackgroundTransparency = 1

                local label = Instance.new("TextLabel", row)
                label.Size = UDim2.new(1, -40, 1, 0)
                label.BackgroundTransparency = 1
                label.Text = text
                label.Font = Enum.Font.Gotham
                label.TextSize = 12
                label.TextColor3 = Library.Theme.Text
                label.TextXAlignment = Enum.TextXAlignment.Left

                local switch = Instance.new("TextButton", row)
                switch.Size = UDim2.new(0, 30, 0, 16)
                switch.Position = UDim2.new(1, -30, 0.5, -8)
                switch.BackgroundColor3 = default and Library.Theme.Accent or Library.Theme.SidebarBg
                switch.Text = ""
                switch.AutoButtonColor = false
                
                local sC = Instance.new("UICorner", switch)
                sC.CornerRadius = UDim.new(1, 0)
                
                local sS = Instance.new("UIStroke", switch)
                sS.Color = Library.Theme.Border
                sS.Thickness = 1

                local circle = Instance.new("Frame", switch)
                circle.Size = UDim2.new(0, 10, 0, 10)
                circle.Position = default and UDim2.new(1, -13, 0.5, -5) or UDim2.new(0, 3, 0.5, -5)
                circle.BackgroundColor3 = Library.Theme.Text
                
                local cC = Instance.new("UICorner", circle)
                cC.CornerRadius = UDim.new(1, 0)

                local state = default
                switch.MouseButton1Click:Connect(function()
                    state = not state
                    local targetPos = state and UDim2.new(1, -13, 0.5, -5) or UDim2.new(0, 3, 0.5, -5)
                    local targetColor = state and Library.Theme.Accent or Library.Theme.SidebarBg
                    
                    TweenService:Create(circle, TweenInfo.new(0.1), {Position = targetPos}):Play()
                    TweenService:Create(switch, TweenInfo.new(0.1), {BackgroundColor3 = targetColor}):Play()
                    if callback then callback(state) end
                end)
            end

            function boxActions:AddSlider(text, min, max, default, callback)
                local row = Instance.new("Frame", elementContainer)
                row.Size = UDim2.new(1, 0, 0, 38)
                row.BackgroundTransparency = 1

                local label = Instance.new("TextLabel", row)
                label.Size = UDim2.new(1, -40, 0, 18)
                label.BackgroundTransparency = 1
                label.Text = text
                label.Font = Enum.Font.Gotham
                label.TextSize = 12
                label.TextColor3 = Library.Theme.Text
                label.TextXAlignment = Enum.TextXAlignment.Left

                local valueLabel = Instance.new("TextLabel", row)
                valueLabel.Size = UDim2.new(0, 40, 0, 18)
                valueLabel.Position = UDim2.new(1, -40, 0, 0)
                valueLabel.BackgroundTransparency = 1
                valueLabel.Text = tostring(default)
                valueLabel.Font = Enum.Font.GothamMedium
                valueLabel.TextSize = 11
                valueLabel.TextColor3 = Library.Theme.TextMuted
                valueLabel.TextXAlignment = Enum.TextXAlignment.Right

                local slideBar = Instance.new("TextButton", row)
                slideBar.Size = UDim2.new(1, 0, 0, 4)
                slideBar.Position = UDim2.new(0, 0, 0, 26)
                slideBar.BackgroundColor3 = Library.Theme.SidebarBg
                slideBar.Text = ""
                slideBar.AutoButtonColor = false
                
                local sbC = Instance.new("UICorner", slideBar)
                sbC.CornerRadius = UDim.new(1, 0)

                local fill = Instance.new("Frame", slideBar)
                fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
                fill.BackgroundColor3 = Library.Theme.Accent
                fill.BorderSizePixel = 0
                
                local fC = Instance.new("UICorner", fill)
                fC.CornerRadius = UDim.new(1, 0)

                local sliderDragging = false

                local function updateSlider(input)
                    local pos = math.clamp((input.Position.X - slideBar.AbsolutePosition.X) / slideBar.AbsoluteSize.X, 0, 1)
                    fill.Size = UDim2.new(pos, 0, 1, 0)
                    local val = math.floor(min + (max - min) * pos)
                    valueLabel.Text = tostring(val)
                    if callback then callback(val) end
                end

                slideBar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        sliderDragging = true
                        updateSlider(input)
                    end
                end)

                UserInputService.InputChanged:Connect(function(input)
                    if sliderDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        updateSlider(input)
                    end
                end)

                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        sliderDragging = false
                    end
                end)
            end

            return boxActions
        end

        return tabActions
    end

    return windowActions
end

return Library
