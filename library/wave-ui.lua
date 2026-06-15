local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")
local userInputService = game:GetService("UserInputService")
local tweenService = game:GetService("TweenService")
local runService = game:GetService("RunService")

local executorName = "Unknown"
local success, result = pcall(function()
	if typeof(identifyexecutor) == "function" then
		local name = identifyexecutor()
		if typeof(name) == "string" then return name end
	elseif typeof(getexecutorname) == "function" then
		local name = getexecutorname()
		if typeof(name) == "string" then return name end
	end
	return "Unknown"
end)

if success and result then
	executorName = result
end

local library = {}

local oldGui = playerGui:FindFirstChild("PremiumMobileGui")
if oldGui then
	oldGui:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PremiumMobileGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local mainUI = Instance.new("Frame")
mainUI.Name = "MainUI"
mainUI.Size = UDim2.new(0, 560, 0, 360)
mainUI.AnchorPoint = Vector2.new(0.5, 0.5)
mainUI.Position = UDim2.new(0.5, 0, 0.5, -25)
mainUI.BackgroundColor3 = Color3.fromRGB(24, 24, 26)
mainUI.BorderSizePixel = 0
mainUI.Parent = screenGui

local uiScale = Instance.new("UIScale")
uiScale.Scale = 1
uiScale.Parent = mainUI

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainUI

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(55, 55, 60)
mainStroke.Thickness = 1.5
mainStroke.Parent = mainUI

local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1, 0, 0, 36)
topBar.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
topBar.BorderSizePixel = 0
topBar.Parent = mainUI

local topBarCorner = Instance.new("UICorner")
topBarCorner.CornerRadius = UDim.new(0, 12)
topBarCorner.Parent = topBar

local topBarHide = Instance.new("Frame")
topBarHide.Size = UDim2.new(1, 0, 0, 16)
topBarHide.Position = UDim2.new(0, 0, 1, -16)
topBarHide.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
topBarHide.BorderSizePixel = 0
topBarHide.Parent = topBar

local pfpLabel = Instance.new("ImageLabel")
pfpLabel.Name = "PlayerPfp"
pfpLabel.Size = UDim2.new(0, 24, 0, 24)
pfpLabel.Position = UDim2.new(0, 14, 0.5, -12)
pfpLabel.BackgroundTransparency = 1
pfpLabel.Parent = topBar

local pfpCorner = Instance.new("UICorner")
pfpCorner.CornerRadius = UDim.new(1, 0)
pfpCorner.Parent = pfpLabel

task.spawn(function()
	local thumbnailSuccess, content = pcall(function()
		return players:GetUserThumbnailAsync(localPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
	end)
	if thumbnailSuccess then
		pfpLabel.Image = content
	end
end)

local animFrame = Instance.new("Frame")
animFrame.Name = "AnimFrame"
animFrame.Size = UDim2.new(0, 100, 1, 0)
animFrame.Position = UDim2.new(0, 48, 0, 0)
animFrame.BackgroundTransparency = 1
animFrame.ClipsDescendants = true
animFrame.Parent = topBar

local waveText = Instance.new("TextLabel")
waveText.Name = "WaveText"
waveText.Size = UDim2.new(1, 0, 1, 0)
waveText.Position = UDim2.new(0, -100, 0, 0)
waveText.BackgroundTransparency = 1
waveText.Text = "wave ui"
waveText.TextColor3 = Color3.fromRGB(255, 255, 255)
waveText.TextSize = 14
waveText.Font = Enum.Font.GothamBold
waveText.TextXAlignment = Enum.TextXAlignment.Left
waveText.TextYAlignment = Enum.TextYAlignment.Center
waveText.Parent = animFrame

task.spawn(function()
	while true do
		waveText.Position = UDim2.new(0, -100, 0, 0)
		local tween = tweenService:Create(waveText, TweenInfo.new(6, Enum.EasingStyle.Linear), {Position = UDim2.new(1, 0, 0, 0)})
		tween:Play()
		tween.Completed:Wait()
		task.wait(0.2)
	end
end)

local waveDivider = Instance.new("Frame")
waveDivider.Name = "WaveDivider"
waveDivider.Size = UDim2.new(0, 1, 0, 16)
waveDivider.Position = UDim2.new(0, 154, 0.5, -8)
waveDivider.BackgroundColor3 = Color3.fromRGB(55, 55, 60)
waveDivider.BorderSizePixel = 0
waveDivider.Parent = topBar

local tagsContainer = Instance.new("Frame")
tagsContainer.Name = "TagsContainer"
tagsContainer.Size = UDim2.new(0, 340, 0, 20)
tagsContainer.Position = UDim2.new(0, 162, 0.5, -10)
tagsContainer.BackgroundTransparency = 1
tagsContainer.Parent = topBar

local tagsLayout = Instance.new("UIListLayout")
tagsLayout.FillDirection = Enum.FillDirection.Horizontal
tagsLayout.SortOrder = Enum.SortOrder.LayoutOrder
tagsLayout.Padding = UDim.new(0, 6)
tagsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
tagsLayout.Parent = tagsContainer

local execFrame = Instance.new("Frame")
execFrame.Name = "ExecutorTag"
execFrame.AutomaticSize = Enum.AutomaticSize.X
execFrame.Size = UDim2.new(0, 0, 1, 0)
execFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
execFrame.LayoutOrder = 5
execFrame.Parent = tagsContainer

local execPadding = Instance.new("UIPadding")
execPadding.PaddingLeft = UDim.new(0, 8)
execPadding.PaddingRight = UDim.new(0, 8)
execPadding.Parent = execFrame

local execCorner = Instance.new("UICorner")
execCorner.CornerRadius = UDim.new(0, 5)
execCorner.Parent = execFrame

local execStroke = Instance.new("UIStroke")
execStroke.Color = Color3.fromRGB(55, 55, 60)
execStroke.Thickness = 1
execStroke.Parent = execFrame

local execLabel = Instance.new("TextLabel")
execLabel.AutomaticSize = Enum.AutomaticSize.X
execLabel.Size = UDim2.new(0, 0, 1, 0)
execLabel.BackgroundTransparency = 1
execLabel.Text = executorName
execLabel.TextColor3 = Color3.fromRGB(255, 170, 0)
execLabel.TextSize = 9
execLabel.Font = Enum.Font.GothamBold
execLabel.TextXAlignment = Enum.TextXAlignment.Center
execLabel.TextYAlignment = Enum.TextYAlignment.Center
execLabel.Parent = execFrame

local fpsFrame = Instance.new("Frame")
fpsFrame.Name = "FPSTag"
fpsFrame.Size = UDim2.new(0, 48, 1, 0)
fpsFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
fpsFrame.LayoutOrder = 6
fpsFrame.Parent = tagsContainer

local fpsCorner = Instance.new("UICorner")
fpsCorner.CornerRadius = UDim.new(0, 5)
fpsCorner.Parent = fpsFrame

local fpsStroke = Instance.new("UIStroke")
fpsStroke.Color = Color3.fromRGB(55, 55, 60)
fpsStroke.Thickness = 1
fpsStroke.Parent = fpsFrame

local fpsLabel = Instance.new("TextLabel")
fpsLabel.Size = UDim2.new(1, 0, 1, 0)
fpsLabel.BackgroundTransparency = 1
fpsLabel.Text = "FPS: 0"
fpsLabel.TextColor3 = Color3.fromRGB(0, 255, 140)
fpsLabel.TextSize = 9
fpsLabel.Font = Enum.Font.GothamBold
fpsLabel.TextXAlignment = Enum.TextXAlignment.Center
fpsLabel.TextYAlignment = Enum.TextYAlignment.Center
fpsLabel.Parent = fpsFrame

local clockFrame = Instance.new("Frame")
clockFrame.Name = "ClockTag"
clockFrame.Size = UDim2.new(0, 64, 1, 0)
clockFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
clockFrame.LayoutOrder = 7
clockFrame.Parent = clockFrame.Parent or tagsContainer

local clockCorner = Instance.new("UICorner")
clockCorner.CornerRadius = UDim.new(0, 5)
clockCorner.Parent = clockFrame

local clockStroke = Instance.new("UIStroke")
clockStroke.Color = Color3.fromRGB(0, 180, 255)
clockStroke.Thickness = 1
clockStroke.Parent = clockFrame

local clockLabel = Instance.new("TextLabel")
clockLabel.Size = UDim2.new(1, 0, 1, 0)
clockLabel.BackgroundTransparency = 1
clockLabel.Text = "00:00:00"
clockLabel.TextColor3 = Color3.fromRGB(0, 180, 255)
clockLabel.TextSize = 9
clockLabel.Font = Enum.Font.GothamBold
clockLabel.TextXAlignment = Enum.TextXAlignment.Center
clockLabel.TextYAlignment = Enum.TextYAlignment.Center
clockLabel.Parent = clockFrame

local builtInTopbarDivider = Instance.new("Frame")
builtInTopbarDivider.Name = "BuiltInTopbarDivider"
builtInTopbarDivider.Size = UDim2.new(0, 1, 0, 14)
builtInTopbarDivider.BackgroundColor3 = Color3.fromRGB(55, 55, 60)
builtInTopbarDivider.BorderSizePixel = 0
builtInTopbarDivider.LayoutOrder = 8
builtInTopbarDivider.Visible = false
builtInTopbarDivider.Parent = tagsContainer

local searchFrame = Instance.new("Frame")
searchFrame.Name = "SearchBar"
searchFrame.Size = UDim2.new(0, 100, 0, 20)
searchFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
searchFrame.LayoutOrder = 9
searchFrame.Visible = true
searchFrame.Parent = tagsContainer

local searchCorner = Instance.new("UICorner")
searchCorner.CornerRadius = UDim.new(0, 5)
searchCorner.Parent = searchFrame

local searchStroke = Instance.new("UIStroke")
searchStroke.Color = Color3.fromRGB(55, 55, 60)
searchStroke.Thickness = 1
searchStroke.Parent = searchFrame

local searchBox = Instance.new("TextBox")
searchBox.Size = UDim2.new(1, -10, 1, 0)
searchBox.Position = UDim2.new(0, 5, 0, 0)
searchBox.BackgroundTransparency = 1
searchBox.Text = ""
searchBox.PlaceholderText = "Search..."
searchBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 105)
searchBox.TextColor3 = Color3.fromRGB(220, 220, 225)
searchBox.TextSize = 9
searchBox.Font = Enum.Font.GothamMedium
searchBox.ClearTextOnFocus = true
searchBox.Parent = searchFrame

task.spawn(function()
	local fpsCount = 0
	local nextUpdate = os.clock() + 1
	runService.RenderStepped:Connect(function()
		fpsCount = fpsCount + 1
		local currentTime = os.clock()
		if currentTime >= nextUpdate then
			clockLabel.Text = os.date("%X")
			fpsLabel.Text = "FPS: " .. fpsCount
			fpsCount = 0
			nextUpdate = currentTime + 1
		end
	end)
end)

local redBtn = Instance.new("TextButton")
redBtn.Size = UDim2.new(0, 13, 0, 13)
redBtn.Position = UDim2.new(1, -24, 0.5, -6)
redBtn.BackgroundColor3 = Color3.fromRGB(255, 95, 85)
redBtn.Text = ""
redBtn.Parent = topBar

local redCorner = Instance.new("UICorner")
redCorner.CornerRadius = UDim.new(1, 0)
redCorner.Parent = redBtn

local redStroke = Instance.new("UIStroke")
redStroke.Color = Color3.fromRGB(180, 50, 50)
redStroke.Thickness = 1
redStroke.Parent = redBtn

local yellowBtn = Instance.new("TextButton")
yellowBtn.Size = UDim2.new(0, 13, 0, 13)
yellowBtn.Position = UDim2.new(1, -44, 0.5, -6)
yellowBtn.BackgroundColor3 = Color3.fromRGB(255, 190, 45)
yellowBtn.Text = ""
yellowBtn.Parent = topBar

local yellowCorner = Instance.new("UICorner")
yellowCorner.CornerRadius = UDim.new(1, 0)
yellowCorner.Parent = yellowBtn

local yellowStroke = Instance.new("UIStroke")
yellowStroke.Color = Color3.fromRGB(190, 130, 30)
yellowStroke.Thickness = 1
yellowStroke.Parent = yellowBtn

local sideBar = Instance.new("Frame")
sideBar.Name = "SideBar"
sideBar.Size = UDim2.new(0, 165, 1, -60)
sideBar.Position = UDim2.new(0, 0, 0, 36)
sideBar.BackgroundColor3 = Color3.fromRGB(16, 16, 18)
sideBar.BorderSizePixel = 0
sideBar.Parent = mainUI

local sideBarCorner = Instance.new("UICorner")
sideBarCorner.CornerRadius = UDim.new(0, 12)
sideBarCorner.Parent = sideBar

local sideBarHide = Instance.new("Frame")
sideBarHide.Size = UDim2.new(0, 16, 1, 0)
sideBarHide.Position = UDim2.new(1, -16, 0, 0)
sideBarHide.BackgroundColor3 = Color3.fromRGB(16, 16, 18)
sideBarHide.BorderSizePixel = 0
sideBarHide.Parent = sideBar

local sideBarHideTop = Instance.new("Frame")
sideBarHideTop.Size = UDim2.new(1, 0, 0, 16)
sideBarHideTop.Position = UDim2.new(0, 0, 0, 0)
sideBarHideTop.BackgroundColor3 = Color3.fromRGB(16, 16, 18)
sideBarHideTop.BorderSizePixel = 0
sideBarHideTop.Parent = sideBar

local sideBarStroke = Instance.new("UIStroke")
sideBarStroke.Color = Color3.fromRGB(45, 45, 48)
sideBarStroke.Thickness = 1
sideBarStroke.Parent = sideBar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -24, 0, 24)
title.Position = UDim2.new(0, 14, 0, 14)
title.BackgroundTransparency = 1
title.Text = "MAIN UI"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = sideBar

local titleConstraint = Instance.new("UITextSizeConstraint")
titleConstraint.MaxTextSize = 16
titleConstraint.MinTextSize = 9
titleConstraint.Parent = title

local desc = Instance.new("TextLabel")
desc.Size = UDim2.new(1, -24, 0, 14)
desc.Position = UDim2.new(0, 14, 0, 38)
desc.BackgroundTransparency = 1
desc.Text = "Mobile Optimization"
desc.TextColor3 = Color3.fromRGB(115, 115, 125)
desc.TextScaled = true
desc.Font = Enum.Font.GothamMedium
desc.TextXAlignment = Enum.TextXAlignment.Left
desc.Parent = sideBar

local descConstraint = Instance.new("UITextSizeConstraint")
descConstraint.MaxTextSize = 11
descConstraint.MinTextSize = 7
descConstraint.Parent = desc

local mainDivider = Instance.new("Frame")
mainDivider.Size = UDim2.new(1, -28, 0, 1)
mainDivider.Position = UDim2.new(0, 14, 0, 60)
mainDivider.BackgroundColor3 = Color3.fromRGB(45, 45, 48)
mainDivider.BorderSizePixel = 0
mainDivider.Parent = sideBar

local tabContainer = Instance.new("ScrollingFrame")
tabContainer.Size = UDim2.new(1, -20, 1, -78)
tabContainer.Position = UDim2.new(0, 10, 0, 68)
tabContainer.BackgroundTransparency = 1
tabContainer.BorderSizePixel = 0
tabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
tabContainer.ScrollBarThickness = 0
tabContainer.Parent = sideBar

local tabLayout = Instance.new("UIListLayout")
tabLayout.Padding = UDim.new(0, 6)
tabLayout.Parent = tabContainer

local contentContainer = Instance.new("Frame")
contentContainer.Size = UDim2.new(1, -195, 1, -74)
contentContainer.Position = UDim2.new(0, 182, 0, 42)
contentContainer.BackgroundTransparency = 1
contentContainer.ClipsDescendants = true
contentContainer.Parent = mainUI

local footer = Instance.new("Frame")
footer.Name = "Footer"
footer.Size = UDim2.new(1, 0, 0, 24)
footer.Position = UDim2.new(0, 0, 1, -24)
footer.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
footer.BorderSizePixel = 0
footer.Parent = mainUI

local footerCorner = Instance.new("UICorner")
footerCorner.CornerRadius = UDim.new(0, 12)
footerCorner.Parent = footer

local footerText = Instance.new("TextLabel")
footerText.Size = UDim2.new(1, -40, 1, 0)
footerText.Position = UDim2.new(0, 14, 0, 0)
footerText.BackgroundTransparency = 1
footerText.Text = "wave ui: v1.3"
footerText.TextColor3 = Color3.fromRGB(115, 115, 125)
footerText.TextSize = 11
footerText.Font = Enum.Font.GothamMedium
footerText.TextXAlignment = Enum.TextXAlignment.Left
footerText.Parent = footer

local resizeBtn = Instance.new("TextButton")
resizeBtn.Name = "ResizeBtn"
resizeBtn.Size = UDim2.new(0, 16, 0, 16)
resizeBtn.Position = UDim2.new(1, -22, 0, 4)
resizeBtn.BackgroundTransparency = 1
resizeBtn.Text = "◢"
resizeBtn.TextColor3 = Color3.fromRGB(110, 110, 115)
resizeBtn.TextSize = 11
resizeBtn.Font = Enum.Font.GothamBold
resizeBtn.Parent = footer

local dialog = Instance.new("Frame")
dialog.Name = "DialogFrame"
dialog.Size = UDim2.new(0, 280, 0, 140)
dialog.Position = UDim2.new(0.5, -140, 0.5, -70)
dialog.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
dialog.BorderSizePixel = 0
dialog.Visible = false
dialog.ZIndex = 20
dialog.Parent = screenGui

local dialogCorner = Instance.new("UICorner")
dialogCorner.CornerRadius = UDim.new(0, 10)
dialogCorner.Parent = dialog

local dialogStroke = Instance.new("UIStroke")
dialogStroke.Color = Color3.fromRGB(70, 70, 75)
dialogStroke.Thickness = 1.5
dialogStroke.Parent = dialog

local dialogTitle = Instance.new("TextLabel")
dialogTitle.Size = UDim2.new(1, -24, 0, 50)
dialogTitle.Position = UDim2.new(0, 12, 0, 14)
dialogTitle.BackgroundTransparency = 1
dialogTitle.Text = "Are you sure you want to completely destroy the interface?"
dialogTitle.TextColor3 = Color3.fromRGB(240, 240, 245)
dialogTitle.TextSize = 13
dialogTitle.Font = Enum.Font.GothamBold
dialogTitle.TextWrapped = true
dialogTitle.ZIndex = 21
dialogTitle.Parent = dialog

local yesBtn = Instance.new("TextButton")
yesBtn.Size = UDim2.new(0, 110, 0, 36)
yesBtn.Position = UDim2.new(0, 20, 0, 82)
yesBtn.BackgroundColor3 = Color3.fromRGB(235, 80, 80)
yesBtn.Text = "Yes"
yesBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
yesBtn.TextSize = 13
yesBtn.Font = Enum.Font.GothamBold
yesBtn.ZIndex = 21
yesBtn.Parent = dialog

local yesCorner = Instance.new("UICorner")
yesCorner.CornerRadius = UDim.new(0, 8)
yesCorner.Parent = yesBtn

local noBtn = Instance.new("TextButton")
noBtn.Size = UDim2.new(0, 110, 0, 36)
noBtn.Position = UDim2.new(1, -130, 0, 82)
noBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
noBtn.Text = "No"
noBtn.TextColor3 = Color3.fromRGB(230, 230, 235)
noBtn.TextSize = 13
noBtn.Font = Enum.Font.GothamBold
noBtn.ZIndex = 21
noBtn.Parent = dialog

local noCorner = Instance.new("UICorner")
noCorner.CornerRadius = UDim.new(0, 8)
noCorner.Parent = noBtn

local toggleUI = Instance.new("Frame")
toggleUI.Name = "ToggleUI"
toggleUI.Size = UDim2.new(0, 140, 0, 36)
toggleUI.Position = UDim2.new(0, 25, 0, 25)
toggleUI.BackgroundColor3 = Color3.fromRGB(24, 24, 26)
toggleUI.Visible = false
toggleUI.Parent = screenGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 18)
toggleCorner.Parent = toggleUI

local toggleStroke = Instance.new("UIStroke")
toggleStroke.Thickness = 1.8
toggleStroke.Color = Color3.fromRGB(255, 255, 255)
toggleStroke.Parent = toggleUI

local toggleGradient = Instance.new("UIGradient")
toggleGradient.Color = ColorSequence.new({ 
	ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 180, 185)), 
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(75, 75, 80)), 
	ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 180, 185)) 
})
toggleGradient.Parent = toggleStroke

task.spawn(function()
	local rot = 0
	while true do
		rot = (rot + 4) % 360
		toggleGradient.Rotation = rot
		task.wait(0.02)
	end
end)

local dragBtnToggle = Instance.new("TextButton")
dragBtnToggle.Name = "DragButton"
dragBtnToggle.Size = UDim2.new(0, 34, 1, 0)
dragBtnToggle.Position = UDim2.new(0, 0, 0, 0)
dragBtnToggle.BackgroundTransparency = 1
dragBtnToggle.Text = ""
dragBtnToggle.Parent = toggleUI

local iconColor = Color3.fromRGB(140, 140, 145)
local line1 = Instance.new("Frame")
line1.Name = "Line1"
line1.Size = UDim2.new(0, 12, 0, 2)
line1.Position = UDim2.new(0.5, -6, 0.5, -4)
line1.BackgroundColor3 = iconColor
line1.BorderSizePixel = 0
line1.Parent = dragBtnToggle
Instance.new("UICorner", line1).CornerRadius = UDim.new(1, 0)

local line2 = Instance.new("Frame")
line2.Name = "Line2"
line2.Size = UDim2.new(0, 12, 0, 2)
line2.Position = UDim2.new(0.5, -6, 0.5, -1)
line2.BackgroundColor3 = iconColor
line2.BorderSizePixel = 0
line2.Parent = dragBtnToggle
Instance.new("UICorner", line2).CornerRadius = UDim.new(1, 0)

local line3 = Instance.new("Frame")
line3.Name = "Line3"
line3.Size = UDim2.new(0, 12, 0, 2)
line3.Position = UDim2.new(0.5, -6, 0.5, 2)
line3.BackgroundColor3 = iconColor
line3.BorderSizePixel = 0
line3.Parent = dragBtnToggle
Instance.new("UICorner", line3).CornerRadius = UDim.new(1, 0)

local toggleLine = Instance.new("Frame")
toggleLine.Size = UDim2.new(0, 1, 0, 18)
toggleLine.Position = UDim2.new(0, 34, 0.5, -9)
toggleLine.BackgroundColor3 = Color3.fromRGB(55, 55, 60)
toggleLine.BorderSizePixel = 0
toggleLine.Parent = toggleUI

local toggleClickBtn = Instance.new("TextButton")
toggleClickBtn.Name = "ToggleClickButton"
toggleClickBtn.Size = UDim2.new(1, -40, 1, 0)
toggleClickBtn.Position = UDim2.new(0, 40, 0, 0)
toggleClickBtn.BackgroundTransparency = 1
toggleClickBtn.Text = "Open UI"
toggleClickBtn.TextColor3 = Color3.fromRGB(240, 240, 245)
toggleClickBtn.TextSize = 12
toggleClickBtn.Font = Enum.Font.GothamBold
toggleClickBtn.TextXAlignment = Enum.TextXAlignment.Center
toggleClickBtn.Parent = toggleUI

local dragging = false
local dragInput, dragStart, startPos
local function update(input)
	local delta = input.Position - dragStart
	mainUI.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

topBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = mainUI.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then dragging = false end
		end)
	end
end)

topBar.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)

local tDragging = false
local tDragStart, tStartPos
dragBtnToggle.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		tDragging = true
		tDragStart = input.Position
		tStartPos = toggleUI.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then tDragging = false end
		end)
	end
end)

local scaleChangedBindable = Instance.new("BindableEvent")
local resizing = false
local resizeStart, startScale
resizeBtn.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		resizing = true
		resizeStart = input.Position
		startScale = uiScale.Scale
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then resizing = false end
		end)
	end
end)

userInputService.InputChanged:Connect(function(input)
	if dragging and input == dragInput then
		update(input)
	elseif tDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - tDragStart
		toggleUI.Position = UDim2.new(tStartPos.X.Scale, tStartPos.X.Offset + delta.X, tStartPos.Y.Scale, tStartPos.Y.Offset + delta.Y)
	elseif resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - resizeStart
		local deltaX = delta.X
		local newScale = startScale + (deltaX / 300)
		uiScale.Scale = math.clamp(newScale, 0.8, 1.5)
		scaleChangedBindable:Fire()
	end
end)

redBtn.MouseButton1Click:Connect(function()
	dialog.Size = UDim2.new(0, 240, 0, 120)
	dialog.Position = UDim2.new(0.5, -120, 0.5, -60)
	dialog.Visible = true
	tweenService:Create(dialog, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Size = UDim2.new(0, 280, 0, 140),
		Position = UDim2.new(0.5, -140, 0.5, -70)
	}):Play()
end)

yesBtn.MouseButton1Click:Connect(function() screenGui:Destroy() end)
noBtn.MouseButton1Click:Connect(function() dialog.Visible = false end)

yellowBtn.MouseButton1Click:Connect(function()
	mainUI.Visible = false
	toggleUI.Visible = true
end)

toggleClickBtn.MouseButton1Click:Connect(function()
	toggleUI.Visible = false
	mainUI.Visible = true
end)

tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	tabContainer.CanvasSize = UDim2.new(0, 0, 0, tabLayout.AbsoluteContentSize.Y)
end)

local pages = {}
local tabs = {}
local currentTabIndex = 1
local isTransitioning = false

function library:CreateWindow(config)
	if config.title then
		title.Text = string.upper(config.title)
	end
	if config.desc then
		desc.Text = config.desc
	end
	if config.footer then
		footerText.Text = config.footer
	end
	if config.open ~= nil then
		if config.open == true then
			mainUI.Visible = true
			toggleUI.Visible = false
		elseif config.open == false then
			mainUI.Visible = false
			toggleUI.Visible = true
		end
	else
		mainUI.Visible = true
		toggleUI.Visible = false
	end
	
	local windowApi = {}
	
	function windowApi:SetTitle(newTitle)
		title.Text = string.upper(newTitle)
	end
	
	function windowApi:SetDesc(newDesc)
		desc.Text = newDesc
	end
	function windowApi:SetFooter(newFooterText)
		footerText.Text = newFooterText
	end
	function windowApi:Open(state)
		if state == true then
			mainUI.Visible = true
			toggleUI.Visible = false
		elseif state == false then
			mainUI.Visible = false
			toggleUI.Visible = true
		end
	end
	
	return windowApi
end

function library:SetTopTags(tagsList)
	for _, child in pairs(tagsContainer:GetChildren()) do
		if child.Name == "CustomTag" then
			child:Destroy()
		end
	end
	local count = #tagsList
	if count < 1 then 
		builtInTopbarDivider.Visible = false
		searchFrame.Visible = true
		return 
	end
	if count > 3 then count = 3 end
	builtInTopbarDivider.Visible = true
	searchFrame.Visible = false
	
	for i = 1, count do
		local tagFrame = Instance.new("Frame")
		tagFrame.Name = "CustomTag"
		tagFrame.Size = UDim2.new(0, 52, 1, 0)
		tagFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
		tagFrame.LayoutOrder = 9 + i
		tagFrame.Parent = tagsContainer
		
		local tagCorner = Instance.new("UICorner")
		tagCorner.CornerRadius = UDim.new(0, 5)
		tagCorner.Parent = tagFrame
		
		local tagStroke = Instance.new("UIStroke")
		tagStroke.Color = Color3.fromRGB(55, 55, 60)
		tagStroke.Thickness = 1
		tagStroke.Parent = tagFrame
		
		local tagLabel = Instance.new("TextLabel")
		tagLabel.Size = UDim2.new(1, 0, 1, 0)
		tagLabel.BackgroundTransparency = 1
		tagLabel.Text = tostring(tagsList[i])
		tagLabel.TextColor3 = Color3.fromRGB(220, 220, 225)
		tagLabel.TextSize = 9
		tagLabel.Font = Enum.Font.GothamBold
		tagLabel.TextXAlignment = Enum.TextXAlignment.Center
		tagLabel.TextYAlignment = Enum.TextYAlignment.Center
		tagLabel.Parent = tagFrame
	end
end

function library:CreateTab(tabName)
	local tabBtn = Instance.new("TextButton")
	tabBtn.Size = UDim2.new(1, 0, 0, 34)
	tabBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 30)
	tabBtn.Text = " " .. tabName
	tabBtn.TextColor3 = Color3.fromRGB(160, 160, 165)
	tabBtn.TextSize = 12
	tabBtn.Font = Enum.Font.GothamBold
	tabBtn.TextXAlignment = Enum.TextXAlignment.Left
	tabBtn.Parent = tabContainer
	
	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 6)
	btnCorner.Parent = tabBtn
	
	local btnStroke = Instance.new("UIStroke")
	btnStroke.Color = Color3.fromRGB(48, 48, 52)
	btnStroke.Thickness = 1
	btnStroke.Parent = tabBtn
	
	local page = Instance.new("ScrollingFrame")
	page.Size = UDim2.new(1, 0, 1, 0)
	page.BackgroundTransparency = 1
	page.BorderSizePixel = 0
	page.Visible = false
	page.ScrollBarThickness = 0
	page.CanvasSize = UDim2.new(0, 0, 0, 0)
	page.ClipsDescendants = true
	page.Parent = contentContainer
	
	local pagePadding = Instance.new("UIPadding")
	pagePadding.PaddingLeft = UDim.new(0, 6)
	pagePadding.PaddingRight = UDim.new(0, 6)
	pagePadding.PaddingTop = UDim.new(0, 6)
	pagePadding.PaddingBottom = UDim.new(0, 6)
	pagePadding.Parent = page
	
	local pageLayout = Instance.new("UIListLayout")
	pageLayout.Padding = UDim.new(0, 10)
	pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
	pageLayout.Parent = page
	
	pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		page.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y + 20)
	end)
	
	table.insert(pages, page)
	table.insert(tabs, tabBtn)
	local thisTabIndex = #pages
	
	tabBtn.MouseButton1Click:Connect(function()
		if thisTabIndex == currentTabIndex or isTransitioning then return end
		isTransitioning = true
		local oldPage = pages[currentTabIndex]
		local newPage = page
		for _, t in pairs(tabs) do
			t.TextColor3 = Color3.fromRGB(160, 160, 165)
			t.UIStroke.Color = Color3.fromRGB(48, 48, 52)
		end
		tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		tabBtn.UIStroke.Color = Color3.fromRGB(90, 90, 95)
		if thisTabIndex < currentTabIndex then
			newPage.Position = UDim2.new(-1, 0, 0, 0)
			newPage.Visible = true
			tweenService:Create(oldPage, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(1, 0, 0, 0)}):Play()
			local tweenNew = tweenService:Create(newPage, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)})
			tweenNew:Play()
			tweenNew.Completed:Wait()
			oldPage.Visible = false
		else
			newPage.Position = UDim2.new(1, 0, 0, 0)
			newPage.Visible = true
			tweenService:Create(oldPage, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(-1, 0, 0, 0)}):Play()
			local tweenNew = tweenService:Create(newPage, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)})
			tweenNew:Play()
			tweenNew.Completed:Wait()
			oldPage.Visible = false
		end
		currentTabIndex = thisTabIndex
		isTransitioning = false
	end)
	
	if #pages == 1 then
		page.Visible = true
		tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		tabBtn.UIStroke.Color = Color3.fromRGB(90, 90, 95)
	end
	
	local currentDualRow = nil
	local pageElements = {}
	
	function pageElements:CreateGroupBox(boxTitle, layoutType, initialState)
		local isExpanded = true
		if initialState == "close" then
			isExpanded = false
		end
		local groupBox = Instance.new("Frame")
		groupBox.Name = "GroupBox"
		groupBox.BackgroundColor3 = Color3.fromRGB(28, 28, 30)
		groupBox.BorderSizePixel = 0
		groupBox.ClipsDescendants = true
		
		local groupCorner = Instance.new("UICorner")
		groupCorner.CornerRadius = UDim.new(0, 8)
		groupCorner.Parent = groupBox
		
		local groupStroke = Instance.new("UIStroke")
		groupStroke.Color = Color3.fromRGB(48, 48, 52)
		groupStroke.Thickness = 1
		groupStroke.Parent = groupBox
		
		local groupLabel = Instance.new("TextLabel")
		groupLabel.Name = "GroupTitle"
		groupLabel.Size = UDim2.new(1, -40, 0, 20)
		groupLabel.Position = UDim2.new(0, 10, 0, 6)
		groupLabel.BackgroundTransparency = 1
		groupLabel.Text = string.upper(boxTitle)
		groupLabel.TextColor3 = Color3.fromRGB(180, 180, 185)
		groupLabel.TextSize = 10
		groupLabel.Font = Enum.Font.GothamBold
		groupLabel.TextXAlignment = Enum.TextXAlignment.Left
		groupLabel.Parent = groupBox
		
		local groupDivider = Instance.new("Frame")
		groupDivider.Size = UDim2.new(1, -20, 0, 1)
		groupDivider.Position = UDim2.new(0, 10, 0, 28)
		groupDivider.BackgroundColor3 = Color3.fromRGB(48, 48, 52)
		groupDivider.BorderSizePixel = 0
		groupDivider.Parent = groupBox
		
		local toggleBtn = Instance.new("TextButton")
		toggleBtn.Size = UDim2.new(0, 16, 0, 16)
		toggleBtn.Position = UDim2.new(1, -26, 0, 8)
		toggleBtn.BackgroundTransparency = 1
		toggleBtn.Text = isExpanded and "-" or "+"
		toggleBtn.TextColor3 = Color3.fromRGB(160, 160, 165)
		toggleBtn.TextSize = 12
		toggleBtn.Font = Enum.Font.GothamBold
		toggleBtn.Parent = groupBox
		
		local boxContent = Instance.new("Frame")
		boxContent.Name = "ElementsContainer"
		boxContent.Size = UDim2.new(1, 0, 1, -32)
		boxContent.Position = UDim2.new(0, 0, 0, 30)
		boxContent.BackgroundTransparency = 1
		boxContent.BorderSizePixel = 0
		boxContent.Visible = isExpanded
		boxContent.Parent = groupBox
		
		local boxLayout = Instance.new("UIListLayout")
		boxLayout.Padding = UDim.new(0, 5)
		boxLayout.SortOrder = Enum.SortOrder.LayoutOrder
		boxLayout.Parent = boxContent
		
		local boxPadding = Instance.new("UIPadding")
		boxPadding.PaddingLeft = UDim.new(0, 10)
		boxPadding.PaddingRight = UDim.new(0, 10)
		boxPadding.PaddingTop = UDim.new(0, 5)
		boxPadding.PaddingBottom = UDim.new(0, 5)
		boxPadding.Parent = boxContent
		
		local currentCalculatedHeight = 36
		local collapsedHeight = 30
		local hasTabs = false
		local groupTabBar = nil
		local groupPagesContainer = nil
		local tabBoxPages = {}
		local tabBoxButtons = {}
		local currentTabBoxIndex = 1
		local activeTabPageLayout = nil
		
		local currentDualButtonRow = nil

		local function updateDimensions()
			local currentScale = uiScale.Scale
			local adjustedContentHeight = 0
			if hasTabs then
				if activeTabPageLayout then
					groupPagesContainer.Size = UDim2.new(1, 0, 0, activeTabPageLayout.AbsoluteContentSize.Y)
					adjustedContentHeight = groupTabBar.Size.Y.Offset + 4 + (activeTabPageLayout.AbsoluteContentSize.Y / currentScale)
				end
			else
				adjustedContentHeight = boxLayout.AbsoluteContentSize.Y / currentScale
			end
			local totalNeeded = adjustedContentHeight + 40
			currentCalculatedHeight = totalNeeded
			
			if isExpanded then
				groupBox.Size = UDim2.new(groupBox.Size.X.Scale, groupBox.Size.X.Offset, 0, currentCalculatedHeight)
				
				if layoutType ~= "allside" and groupBox.Parent:IsA("Frame") then
					local row = groupBox.Parent
					local maxTarget = 30
					for _, child in pairs(row:GetChildren()) do
						if child:IsA("Frame") and child.Size.Y.Offset > maxTarget then
							maxTarget = child.Size.Y.Offset
						end
					end
					row.Size = UDim2.new(1, 0, 0, maxTarget)
				end
			end
		end
		
		boxLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateDimensions)
		scaleChangedBindable.Event:Connect(updateDimensions)
		
		toggleBtn.MouseButton1Click:Connect(function()
			isExpanded = not isExpanded
			toggleBtn.Text = isExpanded and "-" or "+"
			boxContent.Visible = isExpanded
			
			local targetHeight = isExpanded and currentCalculatedHeight or collapsedHeight
			local targetSize = UDim2.new(groupBox.Size.X.Scale, groupBox.Size.X.Offset, 0, targetHeight)
			
			tweenService:Create(groupBox, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = targetSize}):Play()
			
			if layoutType ~= "allside" and groupBox.Parent:IsA("Frame") then
				local row = groupBox.Parent
				local maxTarget = collapsedHeight
				for _, child in pairs(row:GetChildren()) do
					if child:IsA("Frame") then
						local currentH = (child == groupBox) and targetHeight or child.Size.Y.Offset
						if currentH > maxTarget then
							maxTarget = currentH
						end
					end
				end
				tweenService:Create(row, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, maxTarget)}):Play()
			end
		end)
		
		if layoutType == "allside" then
			currentDualRow = nil
			groupBox.Size = UDim2.new(1, 0, 0, isExpanded and currentCalculatedHeight or collapsedHeight)
			groupBox.Parent = page
		else
			local canReuse = false
			if currentDualRow then
				if layoutType == "left" and not currentDualRow:GetAttribute("LeftTaken") then
					canReuse = true
				elseif layoutType == "right" and not currentDualRow:GetAttribute("RightTaken") then
					canReuse = true
				end
			end
			if not canReuse then
				currentDualRow = Instance.new("Frame")
				currentDualRow.Size = UDim2.new(1, 0, 0, isExpanded and currentCalculatedHeight or collapsedHeight)
				currentDualRow.BackgroundTransparency = 1
				currentDualRow.Parent = page
				currentDualRow:SetAttribute("LeftTaken", false)
				currentDualRow:SetAttribute("RightTaken", false)
			end
			groupBox.Size = UDim2.new(0.49, 0, 0, isExpanded and currentCalculatedHeight or collapsedHeight)
			if layoutType == "left" then
				groupBox.Position = UDim2.new(0, 0, 0, 0)
				groupBox.Parent = currentDualRow
				currentDualRow:SetAttribute("LeftTaken", true)
			elseif layoutType == "right" then
				groupBox.Position = UDim2.new(0.51, 0, 0, 0)
				groupBox.Parent = currentDualRow
				currentDualRow:SetAttribute("RightTaken", true)
			end
		end
		
		local innerElements = {}
		
		function innerElements:CreateButton(config, callback)
			if hasTabs then return end
			local titleText = ""
			local cb = callback
			if type(config) == "table" then
				titleText = config.title or config.text or ""
				cb = config.callback
			else
				titleText = config or ""
			end

			local btn = Instance.new("TextButton")
			btn.BackgroundColor3 = Color3.fromRGB(36, 36, 38)
			btn.Text = titleText
			btn.TextColor3 = Color3.fromRGB(230, 230, 235)
			btn.TextSize = 11
			btn.Font = Enum.Font.GothamMedium
			Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
			local str = Instance.new("UIStroke", btn)
			str.Color = Color3.fromRGB(52, 52, 56)
			btn.MouseButton1Click:Connect(function() if cb then cb() end end)

			if currentDualButtonRow and not currentDualButtonRow:GetAttribute("RightButtonTaken") then
				btn.Size = UDim2.new(0.49, 0, 1, 0)
				btn.Position = UDim2.new(0.51, 0, 0, 0)
				btn.Parent = currentDualButtonRow
				currentDualButtonRow:SetAttribute("RightButtonTaken", true)
				currentDualButtonRow = nil
			else
				currentDualButtonRow = Instance.new("Frame")
				currentDualButtonRow.Size = UDim2.new(1, 0, 0, 24)
				currentDualButtonRow.BackgroundTransparency = 1
				currentDualButtonRow.Parent = boxContent
				currentDualButtonRow:SetAttribute("RightButtonTaken", false)
				
				btn.Size = UDim2.new(0.49, 0, 1, 0)
				btn.Position = UDim2.new(0, 0, 0, 0)
				btn.Parent = currentDualButtonRow
			end
			return btn
		end

		function innerElements:CreateDualButton(config, cb1, text2, cb2)
			currentDualButtonRow = nil
			local row = Instance.new("Frame")
			row.Size = UDim2.new(1, 0, 0, 24)
			row.BackgroundTransparency = 1
			row.Parent = boxContent
			local t1, t2 = "Button 1", "Button 2"
			local c1, c2 = cb1, cb2
			if type(config) == "table" then
				t1 = config.Text1 or (config.Button1 and config.Button1.Text) or "Button 1"
				c1 = config.Callback1 or (config.Button1 and config.Button1.Callback) or nil
				t2 = config.Text2 or (config.Button2 and config.Button2.Text) or "Button 2"
				c2 = config.Callback2 or (config.Button2 and config.Button2.Callback) or nil
			else
				t1 = config or "Button 1"
				t2 = text2 or "Button 2"
			end
			local btn1 = Instance.new("TextButton")
			btn1.Size = UDim2.new(0.49, 0, 1, 0)
			btn1.Position = UDim2.new(0, 0, 0, 0)
			btn1.BackgroundColor3 = Color3.fromRGB(36, 36, 38)
			btn1.Text = t1
			btn1.TextColor3 = Color3.fromRGB(230, 230, 235)
			btn1.TextSize = 11
			btn1.Font = Enum.Font.GothamMedium
			btn1.Parent = row
			Instance.new("UICorner", btn1).CornerRadius = UDim.new(0, 5)
			local str1 = Instance.new("UIStroke", btn1)
			str1.Color = Color3.fromRGB(52, 52, 56)
			btn1.MouseButton1Click:Connect(function() if c1 then c1() end end)
			local btn2 = Instance.new("TextButton")
			btn2.Size = UDim2.new(0.49, 0, 1, 0)
			btn2.Position = UDim2.new(0.51, 0, 0, 0)
			btn2.BackgroundColor3 = Color3.fromRGB(36, 36, 38)
			btn2.Text = t2
			btn2.TextColor3 = Color3.fromRGB(230, 230, 235)
			btn2.TextSize = 11
			btn2.Font = Enum.Font.GothamMedium
			btn2.Parent = row
			Instance.new("UICorner", btn2).CornerRadius = UDim.new(0, 5)
			local str2 = Instance.new("UIStroke", btn2)
			str2.Color = Color3.fromRGB(52, 52, 56)
			btn2.MouseButton1Click:Connect(function() if c2 then c2() end end)
			return row
		end
		
		function innerElements:CreateToggle(text, default, callback)
			if hasTabs then return end
			currentDualButtonRow = nil
			local toggleFrame = Instance.new("Frame")
			toggleFrame.Size = UDim2.new(1, 0, 0, 24)
			toggleFrame.BackgroundTransparency = 1
			toggleFrame.Parent = boxContent
			
			local lbl = Instance.new("TextLabel")
			lbl.Size = UDim2.new(1, -35, 1, 0)
			lbl.BackgroundTransparency = 1
			lbl.Text = text
			lbl.TextColor3 = Color3.fromRGB(210, 210, 215)
			lbl.TextSize = 11
			lbl.Font = Enum.Font.GothamMedium
			lbl.TextXAlignment = Enum.TextXAlignment.Left
			lbl.Parent = toggleFrame
			
			local switch = Instance.new("TextButton")
			switch.Size = UDim2.new(0, 28, 0, 15)
			switch.Position = UDim2.new(1, -28, 0.5, -7)
			switch.BackgroundColor3 = default and Color3.fromRGB(0, 140, 255) or Color3.fromRGB(50, 50, 55)
			switch.Text = ""
			switch.Parent = toggleFrame
			Instance.new("UICorner", switch).CornerRadius = UDim.new(1, 0)
			
			local indicator = Instance.new("Frame")
			indicator.Size = UDim2.new(0, 11, 0, 11)
			indicator.Position = default and UDim2.new(1, -13, 0.5, -5) or UDim2.new(0, 2, 0.5, -5)
			indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			indicator.Parent = switch
			Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)
			
			local toggled = default
			switch.MouseButton1Click:Connect(function()
				toggled = not toggled
				tweenService:Create(switch, TweenInfo.new(0.12), {BackgroundColor3 = toggled and Color3.fromRGB(0, 140, 255) or Color3.fromRGB(50, 50, 55)}):Play()
				tweenService:Create(indicator, TweenInfo.new(0.12), {Position = toggled and UDim2.new(1, -13, 0.5, -5) or UDim2.new(0, 2, 0.5, -5)}):Play()
				if callback then callback(toggled) end
			end)
			return toggleFrame
		end

		function innerElements:CreateCheckbox(text, default, callback)
			if hasTabs then return end
			currentDualButtonRow = nil
			local checkboxFrame = Instance.new("Frame")
			checkboxFrame.Size = UDim2.new(1, 0, 0, 24)
			checkboxFrame.BackgroundTransparency = 1
			checkboxFrame.Parent = boxContent
			
			local lbl = Instance.new("TextLabel")
			lbl.Size = UDim2.new(1, -30, 1, 0)
			lbl.BackgroundTransparency = 1
			lbl.Text = text
			lbl.TextColor3 = Color3.fromRGB(210, 210, 215)
			lbl.TextSize = 11
			lbl.Font = Enum.Font.GothamMedium
			lbl.TextXAlignment = Enum.TextXAlignment.Left
			lbl.Parent = checkboxFrame
			
			local box = Instance.new("TextButton")
			box.Size = UDim2.new(0, 16, 0, 16)
			box.Position = UDim2.new(1, -22, 0.5, -8)
			box.BackgroundColor3 = Color3.fromRGB(36, 36, 38)
			box.Text = ""
			box.Parent = checkboxFrame
			Instance.new("UICorner", box).CornerRadius = UDim.new(0, 4)
			local str = Instance.new("UIStroke", box)
			str.Color = Color3.fromRGB(55, 55, 60)
			str.Thickness = 1
			
			local innerCheck = Instance.new("Frame")
			innerCheck.Size = UDim2.new(0, 10, 0, 10)
			innerCheck.Position = UDim2.new(0.5, -5, 0.5, -5)
			innerCheck.BackgroundColor3 = Color3.fromRGB(0, 140, 255)
			innerCheck.Visible = default
			innerCheck.Parent = box
			Instance.new("UICorner", innerCheck).CornerRadius = UDim.new(0, 3)
			
			local checked = default
			box.MouseButton1Click:Connect(function()
				checked = not checked
				innerCheck.Visible = checked
				if callback then callback(checked) end
			end)
			return checkboxFrame
		end
		
		function innerElements:CreateSlider(text, min, max, default, callback)
			if hasTabs then return end
			currentDualButtonRow = nil
			local sliderFrame = Instance.new("Frame")
			sliderFrame.Size = UDim2.new(1, 0, 0, 32)
			sliderFrame.BackgroundTransparency = 1
			sliderFrame.Parent = boxContent
			
			local lbl = Instance.new("TextLabel")
			lbl.Size = UDim2.new(1, 0, 0, 12)
			lbl.BackgroundTransparency = 1
			lbl.Text = text
			lbl.TextColor3 = Color3.fromRGB(210, 210, 215)
			lbl.TextSize = 10
			lbl.Font = Enum.Font.GothamMedium
			lbl.TextXAlignment = Enum.TextXAlignment.Left
			lbl.Parent = sliderFrame
			
			local valLbl = Instance.new("TextLabel")
			valLbl.Size = UDim2.new(0, 40, 0, 12)
			valLbl.Position = UDim2.new(1, -40, 0, 0)
			valLbl.BackgroundTransparency = 1
			valLbl.Text = tostring(default)
			valLbl.TextColor3 = Color3.fromRGB(150, 150, 155)
			valLbl.TextSize = 10
			valLbl.Font = Enum.Font.GothamMedium
			valLbl.TextXAlignment = Enum.TextXAlignment.Right
			valLbl.Parent = sliderFrame
			
			local bar = Instance.new("TextButton")
			bar.Size = UDim2.new(1, 0, 0, 5)
			bar.Position = UDim2.new(0, 0, 0, 18)
			bar.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
			bar.Text = ""
			bar.Parent = sliderFrame
			Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)
			
			local fill = Instance.new("Frame")
			local pct = (default - min) / (max - min)
			fill.Size = UDim2.new(pct, 0, 1, 0)
			fill.BackgroundColor3 = Color3.fromRGB(0, 140, 255)
			fill.Parent = bar
			Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
			
			local sliding = false
			local function updateSlider(input)
				local movePct = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
				fill.Size = UDim2.new(movePct, 0, 1, 0)
				local val = math.floor(min + (max - min) * movePct)
				valLbl.Text = tostring(val)
				if callback then callback(val) end
			end
			
			bar.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					sliding = true
					updateSlider(input)
				end
			end)
			userInputService.InputChanged:Connect(function(input)
				if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then updateSlider(input) end
			end)
			userInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then sliding = false end
			end)
			return sliderFrame
		end
		
		function innerElements:CreateDropdown(config, optionsList, callback)
			if hasTabs then return end
			currentDualButtonRow = nil
			local text = ""
			local list = {}
			local isMulti = false
			local cb = nil

			if type(config) == "table" and not config.Size then
				text = config.text or config.title or ""
				list = config.list or config.options or {}
				isMulti = config.multi or config.MultipleOptions or false
				cb = config.callback
			else
				text = config or ""
				list = optionsList or {}
				cb = callback
			end

			local selectedOptions = {}
			local dropFrame = Instance.new("Frame")
			dropFrame.Size = UDim2.new(1, 0, 0, 24)
			dropFrame.BackgroundColor3 = Color3.fromRGB(34, 34, 36)
			dropFrame.ClipsDescendants = true
			dropFrame.Parent = boxContent
			Instance.new("UICorner", dropFrame).CornerRadius = UDim.new(0, 5)
			local str = Instance.new("UIStroke", dropFrame)
			str.Color = Color3.fromRGB(50, 50, 55)
			
			local mainBtn = Instance.new("TextButton")
			mainBtn.Size = UDim2.new(1, 0, 0, 24)
			mainBtn.BackgroundTransparency = 1
			mainBtn.Text = " " .. text .. " : Select..."
			mainBtn.TextColor3 = Color3.fromRGB(200, 200, 205)
			mainBtn.TextSize = 10
			mainBtn.Font = Enum.Font.GothamMedium
			mainBtn.TextXAlignment = Enum.TextXAlignment.Left
			mainBtn.Parent = dropFrame
			
			local listFrame = Instance.new("Frame")
			listFrame.Size = UDim2.new(1, 0, 0, #list * 20)
			listFrame.Position = UDim2.new(0, 0, 0, 24)
			listFrame.BackgroundTransparency = 1
			listFrame.Parent = dropFrame
			local listLayout = Instance.new("UIListLayout")
			listLayout.Parent = listFrame
			
			local function updateDisplayText()
				local selectedText = {}
				for opt, val in pairs(selectedOptions) do
					if val then table.insert(selectedText, tostring(opt)) end
				end
				if #selectedText > 0 then
					mainBtn.Text = " " .. text .. " : " .. table.concat(selectedText, ", ")
				else
					mainBtn.Text = " " .. text .. " : Select..."
				end
			end

			for _, option in pairs(list) do
				local optBtn = Instance.new("TextButton")
				optBtn.Size = UDim2.new(1, 0, 0, 20)
				optBtn.BackgroundTransparency = 1
				optBtn.Text = " " .. tostring(option)
				optBtn.TextColor3 = Color3.fromRGB(160, 160, 165)
				optBtn.TextSize = 10
				optBtn.Font = Enum.Font.Gotham
				optBtn.TextXAlignment = Enum.TextXAlignment.Left
				optBtn.Parent = listFrame
				
				optBtn.MouseButton1Click:Connect(function()
					if isMulti then
						selectedOptions[option] = not selectedOptions[option]
						if selectedOptions[option] then
							optBtn.TextColor3 = Color3.fromRGB(0, 140, 255)
						else
							optBtn.TextColor3 = Color3.fromRGB(160, 160, 165)
						end
						updateDisplayText()
						if cb then
							local currentSelection = {}
							for opt, val in pairs(selectedOptions) do
								if val then table.insert(currentSelection, opt) end
							end
							cb(currentSelection)
						end
					else
						mainBtn.Text = " " .. text .. " : " .. tostring(option)
						dropFrame.Size = UDim2.new(1, 0, 0, 24)
						updateDimensions()
						if cb then cb(option) end
					end
				end)
			end
			
			local isOpened = false
			mainBtn.MouseButton1Click:Connect(function()
				isOpened = not isOpened
				local targetH = isOpened and (24 + #list * 20) or 24
				dropFrame.Size = UDim2.new(1, 0, 0, targetH)
				updateDimensions()
			end)
			return dropFrame
		end
		
		function innerElements:CreateInput(text, placeholder, callback)
			if hasTabs then return end
			currentDualButtonRow = nil
			local inputFrame = Instance.new("Frame")
			inputFrame.Size = UDim2.new(1, 0, 0, 24)
			inputFrame.BackgroundTransparency = 1
			inputFrame.Parent = boxContent
			
			local lbl = Instance.new("TextLabel")
			lbl.Size = UDim2.new(0.4, 0, 1, 0)
			lbl.BackgroundTransparency = 1
			lbl.Text = text
			lbl.TextColor3 = Color3.fromRGB(210, 210, 215)
			lbl.TextSize = 11
			lbl.Font = Enum.Font.GothamMedium
			lbl.TextXAlignment = Enum.TextXAlignment.Left
			lbl.Parent = inputFrame
			
			local box = Instance.new("TextBox")
			box.Size = UDim2.new(0.6, -4, 1, 0)
			box.Position = UDim2.new(0.4, 4, 0, 0)
			box.BackgroundColor3 = Color3.fromRGB(36, 36, 38)
			box.Text = ""
			box.PlaceholderText = placeholder
			box.PlaceholderColor3 = Color3.fromRGB(100, 100, 105)
			box.TextColor3 = Color3.fromRGB(230, 230, 235)
			box.TextSize = 10
			box.Font = Enum.Font.Gotham
			box.ClearTextOnFocus = false
			box.Parent = inputFrame
			Instance.new("UICorner", box).CornerRadius = UDim.new(0, 5)
			local str = Instance.new("UIStroke", box)
			str.Color = Color3.fromRGB(50, 50, 55)
			
			box.FocusLost:Connect(function(enterPressed) if callback then callback(box.Text, enterPressed) end end)
			return inputFrame
		end
		
		function innerElements:CreateParagraph(text)
			if hasTabs then return end
			currentDualButtonRow = nil
			local para = Instance.new("TextLabel")
			para.Size = UDim2.new(1, 0, 0, 28)
			para.BackgroundTransparency = 1
			para.Text = text
			para.TextColor3 = Color3.fromRGB(140, 140, 145)
			para.TextSize = 10
			para.Font = Enum.Font.Gotham
			para.TextWrapped = true
			para.TextXAlignment = Enum.TextXAlignment.Left
			para.TextYAlignment = Enum.TextYAlignment.Top
			para.Parent = boxContent
			return para
		end
		
		function innerElements:CreateLabel(text)
			if hasTabs then return end
			currentDualButtonRow = nil
			local label = Instance.new("TextLabel")
			label.Size = UDim2.new(1, 0, 0, 16)
			label.BackgroundTransparency = 1
			label.Text = text
			label.TextColor3 = Color3.fromRGB(240, 240, 245)
			label.TextSize = 11
			label.Font = Enum.Font.GothamMedium
			label.TextXAlignment = Enum.TextXAlignment.Left
			label.Parent = boxContent
			return label
		end
		
		function innerElements:CreateDivider()
			if hasTabs then return end
			currentDualButtonRow = nil
			local div = Instance.new("Frame")
			div.Size = UDim2.new(1, 0, 0, 1)
			div.BackgroundColor3 = Color3.fromRGB(48, 48, 52)
			div.BorderSizePixel = 0
			div.Parent = boxContent
			return div
		end
		
		function innerElements:tabbox(tabName)
			currentDualButtonRow = nil
			local allowedMax = (layoutType == "allside") and 5 or 3
			if #tabBoxPages >= allowedMax then
				return nil
			end
			if not hasTabs then
				hasTabs = true
				for _, child in pairs(boxContent:GetChildren()) do
					if not child:IsA("UIListLayout") and not child:IsA("UIPadding") then
						child:Destroy()
					end
				end
				groupTabBar = Instance.new("Frame")
				groupTabBar.Size = UDim2.new(1, 0, 0, 26)
				groupTabBar.BackgroundTransparency = 1
				groupTabBar.LayoutOrder = 1
				groupTabBar.Parent = boxContent
				
				local groupTabLayout = Instance.new("UIListLayout")
				groupTabLayout.FillDirection = Enum.FillDirection.Horizontal
				groupTabLayout.SortOrder = Enum.SortOrder.LayoutOrder
				groupTabLayout.Padding = UDim.new(0, 4)
				groupTabLayout.Parent = groupTabBar
				
				groupPagesContainer = Instance.new("Frame")
				groupPagesContainer.Size = UDim2.new(1, 0, 0, 0)
				groupPagesContainer.BackgroundTransparency = 1
				groupPagesContainer.LayoutOrder = 2
				groupPagesContainer.Parent = boxContent
				
				boxLayout.Padding = UDim.new(0, 4)
			end
			
			local tabBtn = Instance.new("TextButton")
			tabBtn.BackgroundColor3 = Color3.fromRGB(36, 36, 38)
			tabBtn.Text = tabName
			tabBtn.TextColor3 = Color3.fromRGB(150, 150, 155)
			tabBtn.TextSize = 10
			tabBtn.Font = Enum.Font.GothamBold
			tabBtn.LayoutOrder = #tabBoxButtons + 1
			tabBtn.Parent = groupTabBar
			
			local tCorner = Instance.new("UICorner")
			tCorner.CornerRadius = UDim.new(0, 4)
			tCorner.Parent = tabBtn
			
			local tStroke = Instance.new("UIStroke")
			tStroke.Color = Color3.fromRGB(50, 50, 55)
			tStroke.Thickness = 1
			tStroke.Parent = tabBtn
			
			local tPage = Instance.new("Frame")
			tPage.Size = UDim2.new(1, 0, 1, 0)
			tPage.BackgroundTransparency = 1
			tPage.Visible = false
			tPage.Parent = groupPagesContainer
			
			local tLayout = Instance.new("UIListLayout")
			tLayout.Padding = UDim.new(0, 5)
			tLayout.SortOrder = Enum.SortOrder.LayoutOrder
			tLayout.Parent = tPage
			
			table.insert(tabBoxPages, tPage)
			table.insert(tabBoxButtons, tabBtn)
			local thisIdx = #tabBoxPages
			local totalTabs = #tabBoxButtons
			local padTotal = (totalTabs - 1) * 4
			
			groupTabBar.Size = UDim2.new(1, 0, 0, 26)
			for _, btn in pairs(tabBoxButtons) do
				btn.Size = UDim2.new(1 / totalTabs, -(padTotal / totalTabs), 1, 0)
				btn.TextSize = 10
			end
			
			if thisIdx == 1 then
				tPage.Visible = true
				tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
				tabBtn.UIStroke.Color = Color3.fromRGB(90, 90, 95)
				activeTabPageLayout = tLayout
			end
			
			tLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				if currentTabBoxIndex == thisIdx then
					updateDimensions()
				end
			end)
			
			tabBtn.MouseButton1Click:Connect(function()
				if currentTabBoxIndex == thisIdx then return end
				for i, btn in pairs(tabBoxButtons) do
					btn.TextColor3 = Color3.fromRGB(150, 150, 155)
					btn.UIStroke.Color = Color3.fromRGB(50, 50, 55)
					tabBoxPages[i].Visible = false
				end
				tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
				tabBtn.UIStroke.Color = Color3.fromRGB(90, 90, 95)
				tPage.Visible = true
				currentTabBoxIndex = thisIdx
				activeTabPageLayout = tLayout
				updateDimensions()
			end)
			
			local tabElements = {}
			local currentTabDualButtonRow = nil

			function tabElements:CreateButton(config, callback)
				local titleText = ""
				local cb = callback
				if type(config) == "table" then
					titleText = config.title or config.text or ""
					cb = config.callback
				else
					titleText = config or ""
				end

				local btn = Instance.new("TextButton")
				btn.BackgroundColor3 = Color3.fromRGB(36, 36, 38)
				btn.Text = titleText
				btn.TextColor3 = Color3.fromRGB(230, 230, 235)
				btn.TextSize = 11
				btn.Font = Enum.Font.GothamMedium
				Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
				local str = Instance.new("UIStroke", btn)
				str.Color = Color3.fromRGB(52, 52, 56)
				btn.MouseButton1Click:Connect(function() if cb then cb() end end)

				if currentTabDualButtonRow and not currentTabDualButtonRow:GetAttribute("RightButtonTaken") then
					btn.Size = UDim2.new(0.49, 0, 1, 0)
					btn.Position = UDim2.new(0.51, 0, 0, 0)
					btn.Parent = currentTabDualButtonRow
					currentTabDualButtonRow:SetAttribute("RightButtonTaken", true)
					currentTabDualButtonRow = nil
				else
					currentTabDualButtonRow = Instance.new("Frame")
					currentTabDualButtonRow.Size = UDim2.new(1, 0, 0, 24)
					currentTabDualButtonRow.BackgroundTransparency = 1
					currentTabDualButtonRow.Parent = tPage
					currentTabDualButtonRow:SetAttribute("RightButtonTaken", false)
					
					btn.Size = UDim2.new(0.49, 0, 1, 0)
					btn.Position = UDim2.new(0, 0, 0, 0)
					btn.Parent = currentTabDualButtonRow
				end
				return btn
			end

			function tabElements:CreateDualButton(config, cb1, text2, cb2)
				currentTabDualButtonRow = nil
				local row = Instance.new("Frame")
				row.Size = UDim2.new(1, 0, 0, 24)
				row.BackgroundTransparency = 1
				row.Parent = tPage
				local t1, t2 = "Button 1", "Button 2"
				local c1, c2 = cb1, cb2
				if type(config) == "table" then
					t1 = config.Text1 or (config.Button1 and config.Button1.Text) or "Button 1"
					c1 = config.Callback1 or (config.Button1 and config.Button1.Callback) or nil
					t2 = config.Text2 or (config.Button2 and config.Button2.Text) or "Button 2"
					c2 = config.Callback2 or (config.Button2 and config.Button2.Callback) or nil
				else
					t1 = config or "Button 1"
					t2 = text2 or "Button 2"
				end
				local btn1 = Instance.new("TextButton")
				btn1.Size = UDim2.new(0.49, 0, 1, 0)
				btn1.Position = UDim2.new(0, 0, 0, 0)
				btn1.BackgroundColor3 = Color3.fromRGB(36, 36, 38)
				btn1.Text = t1
				btn1.TextColor3 = Color3.fromRGB(230, 230, 235)
				btn1.TextSize = 11
				btn1.Font = Enum.Font.GothamMedium
				btn1.Parent = row
				Instance.new("UICorner", btn1).CornerRadius = UDim.new(0, 5)
				local str1 = Instance.new("UIStroke", btn1)
				str1.Color = Color3.fromRGB(52, 52, 56)
				btn1.MouseButton1Click:Connect(function() if c1 then c1() end end)
				local btn2 = Instance.new("TextButton")
				btn2.Size = UDim2.new(0.49, 0, 1, 0)
				btn2.Position = UDim2.new(0.51, 0, 0, 0)
				btn2.BackgroundColor3 = Color3.fromRGB(36, 36, 38)
				btn2.Text = t2
				btn2.TextColor3 = Color3.fromRGB(230, 230, 235)
				btn2.TextSize = 11
				btn2.Font = Enum.Font.GothamMedium
				btn2.Parent = row
				Instance.new("UICorner", btn2).CornerRadius = UDim.new(0, 5)
				local str2 = Instance.new("UIStroke", btn2)
				str2.Color = Color3.fromRGB(52, 52, 56)
				btn2.MouseButton1Click:Connect(function() if c2 then c2() end end)
				return row
			end
			
			function tabElements:CreateToggle(text, default, callback)
				currentTabDualButtonRow = nil
				local toggleFrame = Instance.new("Frame")
				toggleFrame.Size = UDim2.new(1, 0, 0, 24)
				toggleFrame.BackgroundTransparency = 1
				toggleFrame.Parent = tPage
				
				local lbl = Instance.new("TextLabel")
				lbl.Size = UDim2.new(1, -35, 1, 0)
				lbl.BackgroundTransparency = 1
				lbl.Text = text
				lbl.TextColor3 = Color3.fromRGB(210, 210, 215)
				lbl.TextSize = 11
				lbl.Font = Enum.Font.GothamMedium
				lbl.TextXAlignment = Enum.TextXAlignment.Left
				lbl.Parent = toggleFrame
				
				local switch = Instance.new("TextButton")
				switch.Size = UDim2.new(0, 28, 0, 15)
				switch.Position = UDim2.new(1, -28, 0.5, -7)
				switch.BackgroundColor3 = default and Color3.fromRGB(0, 140, 255) or Color3.fromRGB(50, 50, 55)
				switch.Text = ""
				switch.Parent = toggleFrame
				Instance.new("UICorner", switch).CornerRadius = UDim.new(1, 0)
				
				local indicator = Instance.new("Frame")
				indicator.Size = UDim2.new(0, 11, 0, 11)
				indicator.Position = default and UDim2.new(1, -13, 0.5, -5) or UDim2.new(0, 2, 0.5, -5)
				indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				indicator.Parent = switch
				Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)
				
				local toggled = default
				switch.MouseButton1Click:Connect(function()
					toggled = not toggled
					tweenService:Create(switch, TweenInfo.new(0.12), {BackgroundColor3 = toggled and Color3.fromRGB(0, 140, 255) or Color3.fromRGB(50, 50, 55)}):Play()
					tweenService:Create(indicator, TweenInfo.new(0.12), {Position = toggled and UDim2.new(1, -13, 0.5, -5) or UDim2.new(0, 2, 0.5, -5)}):Play()
					if callback then callback(toggled) end
				end)
				return toggleFrame
			end

			function tabElements:CreateCheckbox(text, default, callback)
				currentTabDualButtonRow = nil
				local checkboxFrame = Instance.new("Frame")
				checkboxFrame.Size = UDim2.new(1, 0, 0, 24)
				checkboxFrame.BackgroundTransparency = 1
				checkboxFrame.Parent = tPage
				
				local lbl = Instance.new("TextLabel")
				lbl.Size = UDim2.new(1, -30, 1, 0)
				lbl.BackgroundTransparency = 1
				lbl.Text = text
				lbl.TextColor3 = Color3.fromRGB(210, 210, 215)
				lbl.TextSize = 11
				lbl.Font = Enum.Font.GothamMedium
				lbl.TextXAlignment = Enum.TextXAlignment.Left
				lbl.Parent = checkboxFrame
				
				local box = Instance.new("TextButton")
				box.Size = UDim2.new(0, 16, 0, 16)
				box.Position = UDim2.new(1, -22, 0.5, -8)
				box.BackgroundColor3 = Color3.fromRGB(36, 36, 38)
				box.Text = ""
				box.Parent = checkboxFrame
				Instance.new("UICorner", box).CornerRadius = UDim.new(0, 4)
				local str = Instance.new("UIStroke", box)
				str.Color = Color3.fromRGB(55, 55, 60)
				str.Thickness = 1
				
				local innerCheck = Instance.new("Frame")
				innerCheck.Size = UDim2.new(0, 10, 0, 10)
				innerCheck.Position = UDim2.new(0.5, -5, 0.5, -5)
				innerCheck.BackgroundColor3 = Color3.fromRGB(0, 140, 255)
				innerCheck.Visible = default
				innerCheck.Parent = box
				Instance.new("UICorner", innerCheck).CornerRadius = UDim.new(0, 3)
				
				local checked = default
				box.MouseButton1Click:Connect(function()
					checked = not checked
					innerCheck.Visible = checked
					if callback then callback(checked) end
				end)
				return checkboxFrame
			end
			
			function tabElements:CreateSlider(text, min, max, default, callback)
				currentTabDualButtonRow = nil
				local sliderFrame = Instance.new("Frame")
				sliderFrame.Size = UDim2.new(1, 0, 0, 32)
				sliderFrame.BackgroundTransparency = 1
				sliderFrame.Parent = tPage
				
				local lbl = Instance.new("TextLabel")
				lbl.Size = UDim2.new(1, 0, 0, 12)
				lbl.BackgroundTransparency = 1
				lbl.Text = text
				lbl.TextColor3 = Color3.fromRGB(210, 210, 215)
				lbl.TextSize = 10
				lbl.Font = Enum.Font.GothamMedium
				lbl.TextXAlignment = Enum.TextXAlignment.Left
				lbl.Parent = sliderFrame
				
				local valLbl = Instance.new("TextLabel")
				valLbl.Size = UDim2.new(0, 40, 0, 12)
				valLbl.Position = UDim2.new(1, -40, 0, 0)
				valLbl.BackgroundTransparency = 1
				valLbl.Text = tostring(default)
				valLbl.TextColor3 = Color3.fromRGB(150, 150, 155)
				valLbl.TextSize = 10
				valLbl.Font = Enum.Font.GothamMedium
				valLbl.TextXAlignment = Enum.TextXAlignment.Right
				valLbl.Parent = sliderFrame
				
				local bar = Instance.new("TextButton")
				bar.Size = UDim2.new(1, 0, 0, 5)
				bar.Position = UDim2.new(0, 0, 0, 18)
				bar.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
				bar.Text = ""
				bar.Parent = tPage
				Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)
				
				local fill = Instance.new("Frame")
				local pct = (default - min) / (max - min)
				fill.Size = UDim2.new(pct, 0, 1, 0)
				fill.BackgroundColor3 = Color3.fromRGB(0, 140, 255)
				fill.Parent = bar
				Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
				
				local sliding = false
				local function updateSlider(input)
					local movePct = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
					fill.Size = UDim2.new(movePct, 0, 1, 0)
					local val = math.floor(min + (max - min) * movePct)
					valLbl.Text = tostring(val)
					if callback then callback(val) end
				end
				
				bar.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						sliding = true
						updateSlider(input)
					end
				end)
				userInputService.InputChanged:Connect(function(input)
					if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then updateSlider(input) end
				end)
				userInputService.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then sliding = false end
				end)
				return sliderFrame
			end
			
			function tabElements:CreateDropdown(config, optionsList, callback)
				currentTabDualButtonRow = nil
				local text = ""
				local list = {}
				local isMulti = false
				local cb = nil

				if type(config) == "table" and not config.Size then
					text = config.text or config.title or ""
					list = config.list or config.options or {}
					isMulti = config.multi or config.MultipleOptions or false
					cb = config.callback
				else
					text = config or ""
					list = optionsList or {}
					cb = callback
				end

				local selectedOptions = {}
				local dropFrame = Instance.new("Frame")
				dropFrame.Size = UDim2.new(1, 0, 0, 24)
				dropFrame.BackgroundColor3 = Color3.fromRGB(34, 34, 36)
				dropFrame.ClipsDescendants = true
				dropFrame.Parent = tPage
				Instance.new("UICorner", dropFrame).CornerRadius = UDim.new(0, 5)
				local str = Instance.new("UIStroke", dropFrame)
				str.Color = Color3.fromRGB(50, 50, 55)
				
				local mainBtn = Instance.new("TextButton")
				mainBtn.Size = UDim2.new(1, 0, 0, 24)
				mainBtn.BackgroundTransparency = 1
				mainBtn.Text = " " .. text .. " : Select..."
				mainBtn.TextColor3 = Color3.fromRGB(200, 200, 205)
				mainBtn.TextSize = 10
				mainBtn.Font = Enum.Font.GothamMedium
				mainBtn.TextXAlignment = Enum.TextXAlignment.Left
				mainBtn.Parent = dropFrame
				
				local listFrame = Instance.new("Frame")
				listFrame.Size = UDim2.new(1, 0, 0, #list * 20)
				listFrame.Position = UDim2.new(0, 0, 0, 24)
				listFrame.BackgroundTransparency = 1
				listFrame.Parent = dropFrame
				local listLayout = Instance.new("UIListLayout")
				listLayout.Parent = listFrame
				
				local function updateDisplayText()
					local selectedText = {}
					for opt, val in pairs(selectedOptions) do
						if val then table.insert(selectedText, tostring(opt)) end
					end
					if #selectedText > 0 then
						mainBtn.Text = " " .. text .. " : " .. table.concat(selectedText, ", ")
					else
						mainBtn.Text = " " .. text .. " : Select..."
					end
				end

				for _, option in pairs(list) do
					local optBtn = Instance.new("TextButton")
					optBtn.Size = UDim2.new(1, 0, 0, 20)
					optBtn.BackgroundTransparency = 1
					optBtn.Text = " " .. tostring(option)
					optBtn.TextColor3 = Color3.fromRGB(160, 160, 165)
					optBtn.TextSize = 10
					optBtn.Font = Enum.Font.Gotham
					optBtn.TextXAlignment = Enum.TextXAlignment.Left
					optBtn.Parent = listFrame
					
					optBtn.MouseButton1Click:Connect(function()
						if isMulti then
							selectedOptions[option] = not selectedOptions[option]
							if selectedOptions[option] then
								optBtn.TextColor3 = Color3.fromRGB(0, 140, 255)
							else
								optBtn.TextColor3 = Color3.fromRGB(160, 160, 165)
							end
							updateDisplayText()
							if cb then
								local currentSelection = {}
								for opt, val in pairs(selectedOptions) do
									if val then table.insert(currentSelection, opt) end
								end
								cb(currentSelection)
							end
						else
							mainBtn.Text = " " .. text .. " : " .. tostring(option)
							dropFrame.Size = UDim2.new(1, 0, 0, 24)
							updateDimensions()
							if cb then cb(option) end
						end
					end)
				end
				
				local isOpened = false
				mainBtn.MouseButton1Click:Connect(function()
					isOpened = not isOpened
					local targetH = isOpened and (24 + #list * 20) or 24
					dropFrame.Size = UDim2.new(1, 0, 0, targetH)
					updateDimensions()
				end)
				return dropFrame
			end
			
			function tabElements:CreateInput(text, placeholder, callback)
				currentTabDualButtonRow = nil
				local inputFrame = Instance.new("Frame")
				inputFrame.Size = UDim2.new(1, 0, 0, 24)
				inputFrame.BackgroundTransparency = 1
				inputFrame.Parent = tPage
				
				local lbl = Instance.new("TextLabel")
				lbl.Size = UDim2.new(0.4, 0, 1, 0)
				lbl.BackgroundTransparency = 1
				lbl.Text = text
				lbl.TextColor3 = Color3.fromRGB(210, 210, 215)
				lbl.TextSize = 11
				lbl.Font = Enum.Font.GothamMedium
				lbl.TextXAlignment = Enum.TextXAlignment.Left
				lbl.Parent = inputFrame
				
				local box = Instance.new("TextBox")
				box.Size = UDim2.new(0.6, -4, 1, 0)
				box.Position = UDim2.new(0.4, 4, 0, 0)
				box.BackgroundColor3 = Color3.fromRGB(36, 36, 38)
				box.Text = ""
				box.PlaceholderText = placeholder
				box.PlaceholderColor3 = Color3.fromRGB(100, 100, 105)
				box.TextColor3 = Color3.fromRGB(230, 230, 235)
				box.TextSize = 10
				box.Font = Enum.Font.Gotham
				box.ClearTextOnFocus = false
				box.Parent = inputFrame
				Instance.new("UICorner", box).CornerRadius = UDim.new(0, 5)
				local str = Instance.new("UIStroke", box)
				str.Color = Color3.fromRGB(50, 50, 55)
				
				box.FocusLost:Connect(function(enterPressed) if callback then callback(box.Text, enterPressed) end end)
				return inputFrame
			end
			
			function tabElements:CreateParagraph(text)
				currentTabDualButtonRow = nil
				local para = Instance.new("TextLabel")
				para.Size = UDim2.new(1, 0, 0, 28)
				para.BackgroundTransparency = 1
				para.Text = text
				para.TextColor3 = Color3.fromRGB(140, 140, 145)
				para.TextSize = 10
				para.Font = Enum.Font.Gotham
				para.TextWrapped = true
				para.TextXAlignment = Enum.TextXAlignment.Left
				para.TextYAlignment = Enum.TextYAlignment.Top
				para.Parent = tPage
				return para
			end
			
			function tabElements:CreateLabel(text)
				currentTabDualButtonRow = nil
				local label = Instance.new("TextLabel")
				label.Size = UDim2.new(1, 0, 0, 16)
				label.BackgroundTransparency = 1
				label.Text = text
				label.TextColor3 = Color3.fromRGB(240, 240, 245)
				label.TextSize = 11
				label.Font = Enum.Font.GothamMedium
				label.TextXAlignment = Enum.TextXAlignment.Left
				label.Parent = tPage
				return label
			end
			
			function tabElements:CreateDivider()
				currentTabDualButtonRow = nil
				local div = Instance.new("Frame")
				div.Size = UDim2.new(1, 0, 0, 1)
				div.BackgroundColor3 = Color3.fromRGB(48, 48, 52)
				div.BorderSizePixel = 0
				div.Parent = tPage
				return div
			end
			
			return tabElements
		end
		
		return innerElements
	end
	return pageElements
end

local function checkMatch(obj, q)
	if q == "" then return true end
	if obj:IsA("TextLabel") or obj:IsA("TextButton") then
		if string.find(string.lower(obj.Text), q, 1, true) then
			return true
		end
	end
	for _, child in ipairs(obj:GetChildren()) do
		if child.Name ~= "GroupTitle" and checkMatch(child, q) then
			return true
		end
	end
	return false
end

searchBox:GetPropertyChangedSignal("Text"):Connect(function()
	local query = string.lower(searchBox.Text)
	for _, page in ipairs(pages) do
		for _, child in ipairs(page:GetChildren()) do
			if child.Name == "GroupBox" and child:IsA("GuiObject") then
				local titleLabel = child:FindFirstChild("GroupTitle")
				local titleText = titleLabel and string.lower(titleLabel.Text) or ""
				local titleMatches = (query == "") or (string.find(titleText, query, 1, true) ~= nil)
				local content = child:FindFirstChild("ElementsContainer")
				local anyElementMatches = false
				if content then
					for _, element in ipairs(content:GetChildren()) do
						if element:IsA("GuiObject") and element.Name ~= "UIListLayout" and element.Name ~= "UIPadding" then
							if element.LayoutOrder == 2 and element:IsA("Frame") then
								local anyTabElementMatches = false
								for _, tabPage in ipairs(element:GetChildren()) do
									if tabPage:IsA("Frame") then
										local pageMatch = false
										for _, tabElem in ipairs(tabPage:GetChildren()) do
											if tabElem:IsA("GuiObject") and tabElem.Name ~= "UIListLayout" then
												local m = (query == "") or checkMatch(tabElem, query)
												tabElem.Visible = m
												if m then pageMatch = true end
											end
										end
										if pageMatch then anyTabElementMatches = true end
									end
								end
								if anyTabElementMatches then anyElementMatches = true end
							else
								local m = (query == "") or checkMatch(element, query)
								element.Visible = m
								if m then anyElementMatches = true end
							end
						end
					end
				end
				child.Visible = titleMatches or anyElementMatches
			elseif child:IsA("Frame") then
				local hasVisibleChild = false
				for _, subChild in ipairs(child:GetChildren()) do
					if subChild.Name == "GroupBox" and subChild:IsA("GuiObject") then
						local titleLabel = subChild:FindFirstChild("GroupTitle")
						local titleText = titleLabel and string.lower(titleLabel.Text) or ""
						local titleMatches = (query == "") or (string.find(titleText, query, 1, true) ~= nil)
						local content = subChild:FindFirstChild("ElementsContainer")
						local anyElementMatches = false
						if content then
							for _, element in ipairs(content:GetChildren()) do
								if element:IsA("GuiObject") and element.Name ~= "UIListLayout" and element.Name ~= "UIPadding" then
									if element.LayoutOrder == 2 and element:IsA("Frame") then
										local anyTabElementMatches = false
										for _, tabPage in ipairs(element:GetChildren()) do
											if tabPage:IsA("Frame") then
												local pageMatch = false
												for _, tabElem in ipairs(tabPage:GetChildren()) do
													if tabElem:IsA("GuiObject") and tabElem.Name ~= "UIListLayout" then
														local m = (query == "") or checkMatch(tabElem, query)
														tabElem.Visible = m
														if m then pageMatch = true end
													end
												end
												if pageMatch then anyTabElementMatches = true end
											end
										end
										if anyTabElementMatches then anyElementMatches = true end
									else
										local m = (query == "") or checkMatch(element, query)
										element.Visible = m
										if m then anyElementMatches = true end
									end
								end
							end
						end
						subChild.Visible = titleMatches or anyElementMatches
						if subChild.Visible then hasVisibleChild = true end
					end
				end
				child.Visible = (query == "") or hasVisibleChild
			end
		end
	end
end)

return library
