--[[
 __    __  _         __        _____ 
/ / /\ \ \/_\/\   /\/__\/\ /\  \_   \
\ \/  \/ //_\\ \ / /_\ / / \ \  / /\/
 \  /\  /  _  \ V //__ \ \_/ /\/ /_  
  \/  \/\_/ \_/\_/\__/  \___/\____/  
        ui library open source
]]

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



local notificationHolder = Instance.new("Frame")
notificationHolder.Name = "NotificationHolder"
notificationHolder.Size = UDim2.new(0, 300, 1, 0)
notificationHolder.Position = UDim2.new(1, -310, 1, -10)
notificationHolder.AnchorPoint = Vector2.new(0,1)
notificationHolder.BackgroundTransparency = 1
notificationHolder.ZIndex = 100
notificationHolder.Parent = screenGui

local notifLayout = Instance.new("UIListLayout")
notifLayout.FillDirection = Enum.FillDirection.Vertical
notifLayout.SortOrder = Enum.SortOrder.LayoutOrder
notifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
notifLayout.Padding = UDim.new(0, 8)
notifLayout.Parent = notificationHolder

local notifPadding = Instance.new("UIPadding")
notifPadding.PaddingBottom = UDim.new(0, 10)
notifPadding.Parent = notificationHolder

function library:Addnotification(config)
	config = config or {}
	local titleText = config.title or config.Title or "Notification"
	local descText = config.desc or config.Desc or config.description or ""
	local duration = config.duration or config.Duration or 3
	duration = tonumber(duration) or 3

	local notifFrame = Instance.new("Frame")
	notifFrame.Size = UDim2.new(1, 0, 0, 0)
	notifFrame.AutomaticSize = Enum.AutomaticSize.Y
	notifFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
	notifFrame.BorderSizePixel = 0
	notifFrame.ZIndex = 101
	notifFrame.Parent = notificationHolder
	notifFrame.ClipsDescendants = true

	notifFrame.Position = UDim2.new(1, 20, 0, 0)

	local notifCorner = Instance.new("UICorner")
	notifCorner.CornerRadius = UDim.new(0, 8)
	notifCorner.Parent = notifFrame

	local notifStroke = Instance.new("UIStroke")
	notifStroke.Color = Color3.fromRGB(55,55,60)
	notifStroke.Thickness = 1
	notifStroke.Parent = notifFrame

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Size = UDim2.new(1, -20, 0, 18)
	titleLabel.Position = UDim2.new(0, 10, 0, 8)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = tostring(titleText)
	titleLabel.TextColor3 = Color3.fromRGB(240,240,245)
	titleLabel.TextSize = 12
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.TextYAlignment = Enum.TextYAlignment.Top
	titleLabel.TextWrapped = true
	titleLabel.AutomaticSize = Enum.AutomaticSize.Y
	titleLabel.ZIndex = 102
	titleLabel.Parent = notifFrame

	local descLabel = Instance.new("TextLabel")
	descLabel.Size = UDim2.new(1, -20, 0, 0)
	descLabel.Position = UDim2.new(0, 10, 0, 28)
	descLabel.BackgroundTransparency = 1
	descLabel.Text = tostring(descText)
	descLabel.TextColor3 = Color3.fromRGB(160,160,165)
	descLabel.TextSize = 11
	descLabel.Font = Enum.Font.Gotham
	descLabel.TextXAlignment = Enum.TextXAlignment.Left
	descLabel.TextYAlignment = Enum.TextYAlignment.Top
	descLabel.TextWrapped = true
	descLabel.AutomaticSize = Enum.AutomaticSize.Y
	descLabel.ZIndex = 102
	descLabel.Parent = notifFrame

	local progressBar = Instance.new("Frame")
	progressBar.Size = UDim2.new(1, 0, 0, 2)
	progressBar.Position = UDim2.new(0, 0, 1, -2)
	progressBar.BackgroundColor3 = Color3.fromRGB(0, 140, 255)
	progressBar.BorderSizePixel = 0
	progressBar.ZIndex = 102
	progressBar.Parent = notifFrame
	Instance.new("UICorner", progressBar).CornerRadius = UDim.new(0,2)


	task.wait()
	local totalHeight = titleLabel.AbsoluteSize.Y + descLabel.AbsoluteSize.Y + 20
	if descText == "" then totalHeight = titleLabel.AbsoluteSize.Y + 16 end
	notifFrame.Size = UDim2.new(1, 0, 0, totalHeight)


	local tweenIn = tweenService:Create(notifFrame, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0,0,0,0)})
	tweenIn:Play()


	local tweenProgress = tweenService:Create(progressBar, TweenInfo.new(duration, Enum.EasingStyle.Linear), {Size = UDim2.new(0,0,0,2)})
	tweenProgress:Play()

	task.spawn(function()
		task.wait(duration)

		local tweenOut = tweenService:Create(notifFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(1,20,0,0), BackgroundTransparency = 1})
		tweenService:Create(titleLabel, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
		tweenService:Create(descLabel, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
		tweenService:Create(progressBar, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
		tweenOut:Play()
		tweenOut.Completed:Wait()
		notifFrame:Destroy()
	end)

	return notifFrame
end


library.AddNotification = library.Addnotification
library.addnotification = library.Addnotification


local mainUI = Instance.new("Frame")
mainUI.Name = "MainUI"
mainUI.Size = UDim2.new(0, 560, 0, 360)
mainUI.AnchorPoint = Vector2.new(0.5, 0.5)
mainUI.Position = UDim2.new(0.5, 0, 0.5, -25)
mainUI.BackgroundColor3 = Color3.fromRGB(24, 24, 26)
mainUI.BorderSizePixel = 0
mainUI.ZIndex = 1
mainUI.Parent = screenGui

local uiScale = Instance.new("UIScale")
uiScale.Scale = 0.9
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

local headerAnimEnabled = true
local headerAnimSpeed = 6
local headerTween = nil

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
		if headerAnimEnabled then
			waveText.Position = UDim2.new(0, -100, 0, 0)
			headerTween = tweenService:Create(waveText, TweenInfo.new(headerAnimSpeed, Enum.EasingStyle.Linear), {Position = UDim2.new(1, 0, 0, 0)})
			headerTween:Play()
			headerTween.Completed:Wait()
			task.wait(0.2)
		else
			task.wait(0.2)
		end
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
clockFrame.Parent = tagsContainer

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
resizeBtn.Position = UDim2.new(1, -20, 1, -20)
resizeBtn.AnchorPoint = Vector2.new(0,0)
resizeBtn.BackgroundTransparency = 1
resizeBtn.Text = "◢"
resizeBtn.TextColor3 = Color3.fromRGB(110, 110, 115)
resizeBtn.TextSize = 11
resizeBtn.Font = Enum.Font.GothamBold
resizeBtn.ZIndex = 10
resizeBtn.Parent = mainUI

local dialog = Instance.new("Frame")
dialog.Name = "DialogFrame"
dialog.Size = UDim2.new(0, 280, 0, 140)
dialog.Position = UDim2.new(0.5, -140, 0.5, -70)
dialog.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
dialog.BorderSizePixel = 0
dialog.Visible = false
dialog.ZIndex = 20
dialog.Parent = mainUI

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


local currentTransparency = 0
local infoEnabled = true

local function GetOriginalTransparency(instance, key, defaultVal)
	local attrName = "Original_"..key
	local stored = instance:GetAttribute(attrName)
	if stored == nil then
		instance:SetAttribute(attrName, defaultVal)
		return defaultVal
	end
	return stored
end

local function ApplyTransparencyToAll(value)
	value = math.clamp(value, 0, 1)
	currentTransparency = value
	for _, obj in ipairs(screenGui:GetDescendants()) do
		if obj:IsA("GuiObject") then
			if obj.BackgroundTransparency ~= 1 or obj:GetAttribute("Original_Bg") ~= nil then
				local orig = GetOriginalTransparency(obj, "Bg", obj.BackgroundTransparency)
				if orig < 0.99 then
					if obj.Name ~= "AnimFrame" and obj.Name ~= "TagsContainer" then
						obj.BackgroundTransparency = orig + (1 - orig) * value
					end
				end
			end
			if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
				local origT = GetOriginalTransparency(obj, "Text", obj.TextTransparency)
				if origT < 0.99 then
					obj.TextTransparency = origT + (1 - origT) * value
				end
				if obj:IsA("TextBox") then
					local origPh = GetOriginalTransparency(obj, "Placeholder", 0)

				end
			end
			if obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
				if obj.Image ~= "" and obj.Image ~= nil then
					local origI = GetOriginalTransparency(obj, "Image", obj.ImageTransparency)
					if origI < 0.99 then
						obj.ImageTransparency = origI + (1 - origI) * value
					end
				end
			end
		end
		if obj:IsA("UIStroke") then
			local origS = GetOriginalTransparency(obj, "Stroke", obj.Transparency)
			if origS < 0.99 then
				obj.Transparency = origS + (1 - origS) * value
			end
		end
		if obj:IsA("ScrollingFrame") then
			local origS = GetOriginalTransparency(obj, "Scroll", obj.ScrollBarImageTransparency)

			if origS ~= nil then

			end
		end
	end
end

local function RefreshTopBarVisibility()
	local hasCustom = false
	for _, child in pairs(tagsContainer:GetChildren()) do
		if child.Name == "CustomTag" then hasCustom = true break end
	end
	if infoEnabled then
		execFrame.Visible = true
		fpsFrame.Visible = true
		clockFrame.Visible = true
		waveDivider.Visible = true
		if hasCustom then
			builtInTopbarDivider.Visible = true
			searchFrame.Visible = false
		else
			builtInTopbarDivider.Visible = false
			searchFrame.Visible = true
			searchFrame.Size = UDim2.new(0, 100, 0, 20)
		end
	else
		execFrame.Visible = false
		fpsFrame.Visible = false
		clockFrame.Visible = false
		waveDivider.Visible = false
		builtInTopbarDivider.Visible = false
		searchFrame.Visible = true
		if hasCustom then
			searchFrame.Size = UDim2.new(0, 160, 0, 20)
		else
			searchFrame.Size = UDim2.new(0, 340, 0, 20)
		end
	end
end


task.spawn(function()
	for _, obj in ipairs(screenGui:GetDescendants()) do
		if obj:IsA("GuiObject") then
			obj:SetAttribute("Original_Bg", obj.BackgroundTransparency)
			if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
				obj:SetAttribute("Original_Text", obj.TextTransparency)
			end
			if obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
				obj:SetAttribute("Original_Image", obj.ImageTransparency)
			end
		end
		if obj:IsA("UIStroke") then
			obj:SetAttribute("Original_Stroke", obj.Transparency)
		end
	end
end)

local dragging = false
local dragInput, dragStart, startPos
local originalMainPos = UDim2.new(0.5, 0, 0.5, -25)
local function update(input)
	local delta = input.Position - dragStart
	local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	mainUI.Position = newPos
	originalMainPos = newPos
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
		local clamped = math.clamp(newScale, 0.72, 1.35)
		uiScale.Scale = clamped
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

yesBtn.MouseButton1Click:Connect(function()
	dialog.Visible = false
	if isAnimating then return end
	isAnimating = true

	local tweenInfoShrink = TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.In)

	local tweenScale = tweenService:Create(uiScale, tweenInfoShrink, {Scale = 0})
	tweenScale:Play()
	tweenScale.Completed:Wait()
	screenGui:Destroy()
end)
noBtn.MouseButton1Click:Connect(function() dialog.Visible = false end)

local isAnimating = false

yellowBtn.MouseButton1Click:Connect(function()
	if isAnimating then return end
	isAnimating = true
	local startPos = mainUI.Position
	local targetPos = UDim2.new(startPos.X.Scale, startPos.X.Offset, 1.5, 0)
	

	local tweenInfoDown = TweenInfo.new(0.55, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
	local tweenMainDown = tweenService:Create(mainUI, tweenInfoDown, {Position = targetPos})
	tweenMainDown:Play()
	tweenMainDown.Completed:Wait()
	
	mainUI.Visible = false
	mainUI.Position = originalMainPos
	

	toggleUI.Visible = true
	toggleUI.BackgroundTransparency = 1
	toggleStroke.Transparency = 1
	toggleClickBtn.TextTransparency = 1
	toggleLine.BackgroundTransparency = 1
	line1.BackgroundTransparency = 1
	line2.BackgroundTransparency = 1
	line3.BackgroundTransparency = 1
	
	local tweenInfoFade = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	tweenService:Create(toggleUI, tweenInfoFade, {BackgroundTransparency = 0}):Play()
	tweenService:Create(toggleStroke, tweenInfoFade, {Transparency = 0}):Play()
	tweenService:Create(toggleLine, tweenInfoFade, {BackgroundTransparency = 0}):Play()
	tweenService:Create(line1, tweenInfoFade, {BackgroundTransparency = 0}):Play()
	tweenService:Create(line2, tweenInfoFade, {BackgroundTransparency = 0}):Play()
	tweenService:Create(line3, tweenInfoFade, {BackgroundTransparency = 0}):Play()
	local t = tweenService:Create(toggleClickBtn, tweenInfoFade, {TextTransparency = 0})
	t:Play()
	t.Completed:Wait()
	isAnimating = false
end)

toggleClickBtn.MouseButton1Click:Connect(function()
	if isAnimating then return end
	isAnimating = true
	

	local tweenInfoFadeOut = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
	local tw1 = tweenService:Create(toggleUI, tweenInfoFadeOut, {BackgroundTransparency = 1})
	local tw2 = tweenService:Create(toggleStroke, tweenInfoFadeOut, {Transparency = 1})
	local tw3 = tweenService:Create(toggleClickBtn, tweenInfoFadeOut, {TextTransparency = 1})
	local tw4 = tweenService:Create(toggleLine, tweenInfoFadeOut, {BackgroundTransparency = 1})
	local tw5 = tweenService:Create(line1, tweenInfoFadeOut, {BackgroundTransparency = 1})
	local tw6 = tweenService:Create(line2, tweenInfoFadeOut, {BackgroundTransparency = 1})
	local tw7 = tweenService:Create(line3, tweenInfoFadeOut, {BackgroundTransparency = 1})
	tw1:Play() tw2:Play() tw3:Play() tw4:Play() tw5:Play() tw6:Play() tw7:Play()
	tw1.Completed:Wait()
	
	toggleUI.Visible = false
	

	local startPosDown = UDim2.new(originalMainPos.X.Scale, originalMainPos.X.Offset, 1.5, 0)
	mainUI.Position = startPosDown
	mainUI.Visible = true
	
	local tweenInfoUp = TweenInfo.new(0.55, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	local tweenMainUp = tweenService:Create(mainUI, tweenInfoUp, {Position = originalMainPos})
	tweenMainUp:Play()
	tweenMainUp.Completed:Wait()
	isAnimating = false
end)

tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
end)


local pages = {}
local tabs = {}
local currentTabIndex = 1
local isTransitioning = false

function library:CreateWindow(config)
	config = config or {}
	if config.title then
		title.Text = string.upper(config.title)
	end
	if config.desc then
		desc.Text = config.desc
	end

	local hasFooter = false
	if config.footer and tostring(config.footer) ~= "" then
		footerText.Text = config.footer
		footer.Visible = true
		hasFooter = true

		mainUI.Size = UDim2.new(0, 560, 0, 360)
		contentContainer.Size = UDim2.new(1, -195, 1, -74)
		contentContainer.Position = UDim2.new(0, 182, 0, 42)
		sideBar.Size = UDim2.new(0, 165, 1, -60)
	else
		footer.Visible = false
		hasFooter = false

		mainUI.Size = UDim2.new(0, 560, 0, 336)
		contentContainer.Size = UDim2.new(1, -195, 1, -50)
		contentContainer.Position = UDim2.new(0, 182, 0, 42)
		sideBar.Size = UDim2.new(0, 165, 1, -36)
	end
	mainUI:SetAttribute("HasFooter", hasFooter)


	if config.info ~= nil then
		infoEnabled = config.info
	else
		infoEnabled = true
	end
	RefreshTopBarVisibility()


	if config.transparency ~= nil then
		ApplyTransparencyToAll(config.transparency)
	elseif config.Transparency ~= nil then
		ApplyTransparencyToAll(config.Transparency)
	end


	local shouldOpen = true
	if config.opened ~= nil then
		shouldOpen = config.opened
	elseif config.open ~= nil then
		shouldOpen = config.open
	end
	if shouldOpen == true then
		mainUI.Visible = true
		toggleUI.Visible = false
	elseif shouldOpen == false then
		mainUI.Visible = false
		toggleUI.Visible = true
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
		if newFooterText == nil or tostring(newFooterText) == "" then
			footer.Visible = false
			mainUI.Size = UDim2.new(0, 560, 0, 336)
			contentContainer.Size = UDim2.new(1, -195, 1, -50)
			sideBar.Size = UDim2.new(0, 165, 1, -36)
			mainUI:SetAttribute("HasFooter", false)
		else
			footerText.Text = newFooterText
			footer.Visible = true
			mainUI.Size = UDim2.new(0, 560, 0, 360)
			contentContainer.Size = UDim2.new(1, -195, 1, -74)
			sideBar.Size = UDim2.new(0, 165, 1, -60)
			mainUI:SetAttribute("HasFooter", true)
		end
	end


	function windowApi:opened(state)
		if isAnimating then return end
		if state == true then
			if not mainUI.Visible then
				isAnimating = true
				local startPosDown = UDim2.new(originalMainPos.X.Scale, originalMainPos.X.Offset, 1.5, 0)
				mainUI.Position = startPosDown
				mainUI.Visible = true
				toggleUI.Visible = false
				local tweenInfoUp = TweenInfo.new(0.55, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
				local tweenMainUp = tweenService:Create(mainUI, tweenInfoUp, {Position = originalMainPos})
				tweenMainUp:Play()
				tweenMainUp.Completed:Wait()
				isAnimating = false
			end
		elseif state == false then
			if mainUI.Visible then
				isAnimating = true
				local startPos = mainUI.Position
				local targetPos = UDim2.new(startPos.X.Scale, startPos.X.Offset, 1.5, 0)
				local tweenInfoDown = TweenInfo.new(0.55, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
				local tweenMainDown = tweenService:Create(mainUI, tweenInfoDown, {Position = targetPos})
				tweenMainDown:Play()
				tweenMainDown.Completed:Wait()
				mainUI.Visible = false
				mainUI.Position = originalMainPos
				toggleUI.Visible = true
				toggleUI.BackgroundTransparency = 0
				toggleStroke.Transparency = 0
				toggleClickBtn.TextTransparency = 0
				toggleLine.BackgroundTransparency = 0
				line1.BackgroundTransparency = 0
				line2.BackgroundTransparency = 0
				line3.BackgroundTransparency = 0
				isAnimating = false
			end
		end
	end

	windowApi.Open = windowApi.opened
	windowApi.open = windowApi.opened


	function windowApi:SetTransparency(value)
		ApplyTransparencyToAll(value)
	end
	function windowApi:SetTransparencyLevel(value)
		ApplyTransparencyToAll(value)
	end
	function windowApi:GetTransparency()
		return currentTransparency
	end


	function windowApi:SetInfo(state)
		infoEnabled = state and true or false
		RefreshTopBarVisibility()
	end
	function windowApi:ToggleInfo(state)
		infoEnabled = state and true or false
		RefreshTopBarVisibility()
	end


	function windowApi:SetMovingText(text)
		if text then
			waveText.Text = tostring(text)
		end
	end


	function windowApi:AddTag(tagConfig)
		tagConfig = tagConfig or {}
		local titleText = tagConfig.title or tagConfig.Title or ""
		local canClicked = tagConfig.canclicked
		if canClicked == nil then canClicked = tagConfig.canClicked end
		if canClicked == nil then canClicked = tagConfig.CanClicked end
		if canClicked == nil then canClicked = false end
		local callback = tagConfig.callback or tagConfig.Callback


		local existingTags = {}
		for _, child in pairs(tagsContainer:GetChildren()) do
			if child.Name == "CustomTag" then table.insert(existingTags, child) end
		end
		if #existingTags >= 3 then
			existingTags[1]:Destroy()
		end

		local tagFrame
		if canClicked then
			tagFrame = Instance.new("TextButton")
			tagFrame.AutoButtonColor = true
			tagFrame.Text = ""
		else
			tagFrame = Instance.new("Frame")
		end
		tagFrame.Name = "CustomTag"
		tagFrame.AutomaticSize = Enum.AutomaticSize.X
		tagFrame.Size = UDim2.new(0, 0, 1, 0)
		tagFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
		tagFrame.LayoutOrder = 20 + #existingTags
		tagFrame.Parent = tagsContainer

		local tagPadding = Instance.new("UIPadding")
		tagPadding.PaddingLeft = UDim.new(0, 8)
		tagPadding.PaddingRight = UDim.new(0, 8)
		tagPadding.Parent = tagFrame

		local tagCorner = Instance.new("UICorner")
		tagCorner.CornerRadius = UDim.new(0, 5)
		tagCorner.Parent = tagFrame

		local tagStroke = Instance.new("UIStroke")
		tagStroke.Color = Color3.fromRGB(55, 55, 60)
		tagStroke.Thickness = 1
		tagStroke.Parent = tagFrame

		local tagLabel = Instance.new("TextLabel")
		tagLabel.AutomaticSize = Enum.AutomaticSize.X
		tagLabel.Size = UDim2.new(0, 0, 1, 0)
		tagLabel.BackgroundTransparency = 1
		tagLabel.Text = tostring(titleText)
		tagLabel.TextColor3 = Color3.fromRGB(220, 220, 225)
		tagLabel.TextSize = 9
		tagLabel.Font = Enum.Font.GothamBold
		tagLabel.TextXAlignment = Enum.TextXAlignment.Center
		tagLabel.TextYAlignment = Enum.TextYAlignment.Center
		tagLabel.Parent = tagFrame


		tagFrame:SetAttribute("Original_Bg", 0)
		tagLabel:SetAttribute("Original_Text", 0)
		tagStroke:SetAttribute("Original_Stroke", 0)

		if currentTransparency > 0 then
			tagFrame.BackgroundTransparency = currentTransparency
			tagStroke.Transparency = currentTransparency
			tagLabel.TextTransparency = currentTransparency
		end

		if canClicked and typeof(callback) == "function" then
			tagFrame.MouseButton1Click:Connect(function()
				pcall(callback)
			end)
		end

		RefreshTopBarVisibility()
		return tagFrame
	end

	function windowApi:ClearTags()
		for _, child in pairs(tagsContainer:GetChildren()) do
			if child.Name == "CustomTag" then child:Destroy() end
		end
		RefreshTopBarVisibility()
	end


	function windowApi:SetTopTags(tagsList)
		windowApi:ClearTags()
		if typeof(tagsList) ~= "table" then return end
		for i, v in ipairs(tagsList) do
			if i > 3 then break end
			windowApi:AddTag({title = tostring(v), canclicked = false})
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
	local count = 0
	if typeof(tagsList) == "table" then count = #tagsList else count = 0 end
	if count < 1 then 
		builtInTopbarDivider.Visible = false
		if infoEnabled then searchFrame.Visible = true end
		RefreshTopBarVisibility()
		return 
	end
	if count > 3 then count = 3 end
	builtInTopbarDivider.Visible = true
	if infoEnabled then searchFrame.Visible = false end
	
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
	RefreshTopBarVisibility()
end


function library:AddTag(tagConfig)

	local tagConfig = tagConfig or {}
	local titleText = tagConfig.title or ""
	local canClicked = tagConfig.canclicked or false
	local callback = tagConfig.callback
	local existingTags = {}
	for _, child in pairs(tagsContainer:GetChildren()) do if child.Name=="CustomTag" then table.insert(existingTags, child) end end
	if #existingTags >=3 then existingTags[1]:Destroy() end
	local tagFrame
	if canClicked then tagFrame = Instance.new("TextButton") tagFrame.AutoButtonColor=true tagFrame.Text="" else tagFrame=Instance.new("Frame") end
	tagFrame.Name="CustomTag" tagFrame.AutomaticSize=Enum.AutomaticSize.X tagFrame.Size=UDim2.new(0,0,1,0) tagFrame.BackgroundColor3=Color3.fromRGB(28,28,32) tagFrame.LayoutOrder=20+#existingTags tagFrame.Parent=tagsContainer
	local tagPadding=Instance.new("UIPadding") tagPadding.PaddingLeft=UDim.new(0,8) tagPadding.PaddingRight=UDim.new(0,8) tagPadding.Parent=tagFrame
	local tagCorner=Instance.new("UICorner") tagCorner.CornerRadius=UDim.new(0,5) tagCorner.Parent=tagFrame
	local tagStroke=Instance.new("UIStroke") tagStroke.Color=Color3.fromRGB(55,55,60) tagStroke.Thickness=1 tagStroke.Parent=tagFrame
	local tagLabel=Instance.new("TextLabel") tagLabel.AutomaticSize=Enum.AutomaticSize.X tagLabel.Size=UDim2.new(0,0,1,0) tagLabel.BackgroundTransparency=1 tagLabel.Text=tostring(titleText) tagLabel.TextColor3=Color3.fromRGB(220,220,225) tagLabel.TextSize=9 tagLabel.Font=Enum.Font.GothamBold tagLabel.TextXAlignment=Enum.TextXAlignment.Center tagLabel.TextYAlignment=Enum.TextYAlignment.Center tagLabel.Parent=tagFrame
	if canClicked and typeof(callback)=="function" then tagFrame.MouseButton1Click:Connect(function() pcall(callback) end) end
	RefreshTopBarVisibility()
	return tagFrame
end

function library:SetTransparency(value)
	ApplyTransparencyToAll(value)
end

function library:SetInfo(state)
	infoEnabled = state and true or false
	RefreshTopBarVisibility()
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
	page.ScrollBarThickness = 2
	page.CanvasSize = UDim2.new(0, 0, 0, 0)
	page.AutomaticCanvasSize = Enum.AutomaticSize.Y
	page.ScrollingDirection = Enum.ScrollingDirection.Y
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
		groupBox.AutomaticSize = Enum.AutomaticSize.Y
		
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
		boxContent.Size = UDim2.new(1, 0, 0, 0)
		boxContent.AutomaticSize = Enum.AutomaticSize.Y
		boxContent.Position = UDim2.new(0, 0, 0, 30)
		boxContent.BackgroundTransparency = 1
		boxContent.BorderSizePixel = 0
		boxContent.Visible = isExpanded
		boxContent.Parent = groupBox
		task.spawn(function()
			while groupBox and groupBox.Parent do
				task.wait(0.1)
				if not isExpanded then continue end
				if not boxContent.Visible then continue end
				local maxBottom = 0
				for _, child in ipairs(boxContent:GetChildren()) do
					if child:IsA("GuiObject") and child.Visible then
						local bottom = child.AbsolutePosition.Y + child.AbsoluteSize.Y
						if bottom > maxBottom then maxBottom = bottom end
					end
				end
				if maxBottom > 0 then
					local groupBottom = groupBox.AbsolutePosition.Y + groupBox.AbsoluteSize.Y
					if maxBottom + 8 > groupBottom then
						local diff = (maxBottom - groupBottom) + 12
						if groupBox.AutomaticSize == Enum.AutomaticSize.Y then
						else
							groupBox.Size = UDim2.new(groupBox.Size.X.Scale, groupBox.Size.X.Offset, 0, groupBox.Size.Y.Offset + diff)
						end
					end
				end
			end
		end)

		
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
			if not isExpanded then
				groupBox.AutomaticSize = Enum.AutomaticSize.None
				groupBox.Size = UDim2.new(groupBox.Size.X.Scale, groupBox.Size.X.Offset, 0, 30)
				if layoutType ~= "allside" and groupBox.Parent:IsA("Frame") then
					local row = groupBox.Parent
					row.AutomaticSize = Enum.AutomaticSize.Y
					row.Size = UDim2.new(1, 0, 0, 0)
				end
				return
			end
			groupBox.AutomaticSize = Enum.AutomaticSize.Y
			groupBox.Size = UDim2.new(groupBox.Size.X.Scale, groupBox.Size.X.Offset, 0, 0)
			if hasTabs then
				if activeTabPageLayout then
					groupPagesContainer.AutomaticSize = Enum.AutomaticSize.Y
					groupPagesContainer.Size = UDim2.new(1, 0, 0, 0)
					task.spawn(function()
						task.wait()
						groupPagesContainer.Size = UDim2.new(1, 0, 0, activeTabPageLayout.AbsoluteContentSize.Y)
					end)
				end
			end
			if layoutType ~= "allside" and groupBox.Parent:IsA("Frame") then
				local row = groupBox.Parent
				row.AutomaticSize = Enum.AutomaticSize.Y
				row.Size = UDim2.new(1, 0, 0, 0)
			end
		end
		
		boxLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			updateDimensions()
		end)
		scaleChangedBindable.Event:Connect(updateDimensions)
		task.spawn(function()
			while groupBox and groupBox.Parent do
				task.wait(0.15)
				if isExpanded and boxLayout then
					local needed = boxLayout.AbsoluteContentSize.Y + 40
					if needed > 0 then
						if groupBox.AutomaticSize == Enum.AutomaticSize.None then
							groupBox.Size = UDim2.new(groupBox.Size.X.Scale, groupBox.Size.X.Offset, 0, 30)
						end
					end
				end
			end
		end)
		
		toggleBtn.MouseButton1Click:Connect(function()
			isExpanded = not isExpanded
			toggleBtn.Text = isExpanded and "-" or "+"
			boxContent.Visible = isExpanded
			if isExpanded then
				groupBox.AutomaticSize = Enum.AutomaticSize.Y
				groupBox.Size = UDim2.new(groupBox.Size.X.Scale, groupBox.Size.X.Offset, 0, 0)
			else
				groupBox.AutomaticSize = Enum.AutomaticSize.None
				groupBox.Size = UDim2.new(groupBox.Size.X.Scale, groupBox.Size.X.Offset, 0, 30)
			end
			if layoutType ~= "allside" and groupBox.Parent:IsA("Frame") then
				local row = groupBox.Parent
				row.AutomaticSize = Enum.AutomaticSize.Y
				row.Size = UDim2.new(1, 0, 0, 0)
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

			local row = Instance.new("Frame")
			row.Name = "ButtonRow"
			row.Size = UDim2.new(1, 0, 0, 24)
			row.BackgroundTransparency = 1
			row.Parent = boxContent

			local btn = Instance.new("TextButton")
			btn.Name = "MainButton"
			btn.Size = UDim2.new(1, 0, 1, 0)
			btn.BackgroundColor3 = Color3.fromRGB(36, 36, 38)
			btn.Text = titleText
			btn.TextColor3 = Color3.fromRGB(230, 230, 235)
			btn.TextSize = 11
			btn.Font = Enum.Font.GothamMedium
			btn.Parent = row
			Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
			local str = Instance.new("UIStroke", btn)
			str.Color = Color3.fromRGB(52, 52, 56)
			btn.MouseButton1Click:Connect(function() if cb then cb() end end)

			local api = {}
			api.Instance = btn
			api.Row = row
			api.IsDual = false

			function api:CreateButton(secondConfig, secondCallback)
				if self.IsDual then return nil end
				local secondTitle = ""
				local secondCb = secondCallback
				if type(secondConfig) == "table" then
					secondTitle = secondConfig.title or secondConfig.text or ""
					secondCb = secondConfig.callback
				else
					secondTitle = secondConfig or ""
				end


				self.Instance.Size = UDim2.new(0.49, 0, 1, 0)
				self.Instance.Position = UDim2.new(0, 0, 0, 0)


				local btn2 = Instance.new("TextButton")
				btn2.Name = "SecondButton"
				btn2.Size = UDim2.new(0.49, 0, 1, 0)
				btn2.Position = UDim2.new(0.51, 0, 0, 0)
				btn2.BackgroundColor3 = Color3.fromRGB(36, 36, 38)
				btn2.Text = secondTitle
				btn2.TextColor3 = Color3.fromRGB(230, 230, 235)
				btn2.TextSize = 11
				btn2.Font = Enum.Font.GothamMedium
				btn2.Parent = row
				Instance.new("UICorner", btn2).CornerRadius = UDim.new(0, 5)
				local str2 = Instance.new("UIStroke", btn2)
				str2.Color = Color3.fromRGB(52, 52, 56)
				btn2.MouseButton1Click:Connect(function() if secondCb then secondCb() end end)

				self.IsDual = true


				local api2 = {}
				api2.Instance = btn2
				api2.Row = row
				api2.IsDual = true
				function api2:CreateButton() return nil end
				setmetatable(api2, {
					__index = function(t,k)
						local v = rawget(t,k)
						if v ~= nil then return v end
						return t.Instance[k]
					end,
					__newindex = function(t,k,v)
						if pcall(function() return t.Instance[k] end) then
							t.Instance[k] = v
						else
							rawset(t,k,v)
						end
					end
				})
				return api2
			end

			setmetatable(api, {
				__index = function(t,k)
					local v = rawget(t,k)
					if v ~= nil then return v end
					return t.Instance[k]
				end,
				__newindex = function(t,k,v)

					local success = pcall(function() t.Instance[k] = v end)
					if not success then
						rawset(t,k,v)
					end
				end
			})

			return api
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
			
			local valBtn = Instance.new("TextButton")
			valBtn.Size = UDim2.new(0, 50, 0, 12)
			valBtn.Position = UDim2.new(1, -50, 0, 0)
			valBtn.BackgroundTransparency = 1
			valBtn.Text = tostring(default)
			valBtn.TextColor3 = Color3.fromRGB(150, 150, 155)
			valBtn.TextSize = 10
			valBtn.Font = Enum.Font.GothamMedium
			valBtn.TextXAlignment = Enum.TextXAlignment.Right
			valBtn.Parent = sliderFrame
			
			local valInput = Instance.new("TextBox")
			valInput.Size = UDim2.new(0, 50, 0, 14)
			valInput.Position = UDim2.new(1, -50, 0, -1)
			valInput.BackgroundColor3 = Color3.fromRGB(36,36,38)
			valInput.Text = tostring(default)
			valInput.TextColor3 = Color3.fromRGB(230,230,235)
			valInput.TextSize = 10
			valInput.Font = Enum.Font.GothamMedium
			valInput.Visible = false
			valInput.ClearTextOnFocus = false
			valInput.Parent = sliderFrame
			Instance.new("UICorner", valInput).CornerRadius = UDim.new(0, 4)
			local inputStroke = Instance.new("UIStroke", valInput)
			inputStroke.Color = Color3.fromRGB(0,140,255)
			inputStroke.Thickness = 1
			
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
			
			local dot = Instance.new("Frame")
			dot.Name = "SliderDot"
			dot.Size = UDim2.new(0, 10, 0, 10)
			dot.Position = UDim2.new(pct, -5, 0.5, -5)
			dot.BackgroundColor3 = Color3.fromRGB(255,255,255)
			dot.BorderSizePixel = 0
			dot.ZIndex = 2
			dot.Parent = bar
			Instance.new("UICorner", dot).CornerRadius = UDim.new(1,0)
			local dotStroke = Instance.new("UIStroke", dot)
			dotStroke.Color = Color3.fromRGB(0,140,255)
			dotStroke.Thickness = 1.5
			
			local sliding = false
			local currentVal = default
			local function setSliderValue(val)
				local clamped = math.clamp(val, min, max)
				local movePct = (clamped - min) / (max - min)
				fill.Size = UDim2.new(movePct, 0, 1, 0)
				dot.Position = UDim2.new(movePct, -5, 0.5, -5)
				valBtn.Text = tostring(math.floor(clamped))
				valInput.Text = tostring(math.floor(clamped))
				currentVal = math.floor(clamped)
				if callback then callback(currentVal) end
			end

			local function updateSlider(input)
				local movePct = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
				local val = min + (max - min) * movePct
				setSliderValue(val)
			end
			
			bar.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					sliding = true
					updateSlider(input)
				end
			end)
			dot.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					sliding = true
				end
			end)
			userInputService.InputChanged:Connect(function(input)
				if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then updateSlider(input) end
			end)
			userInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then sliding = false end
			end)

			valBtn.MouseButton1Click:Connect(function()
				valBtn.Visible = false
				valInput.Visible = true
				valInput:CaptureFocus()
				valInput.Text = tostring(currentVal)
			end)

			valInput.FocusLost:Connect(function(enterPressed)
				local num = tonumber(valInput.Text)
				if num then
					setSliderValue(num)
				end
				valInput.Visible = false
				valBtn.Visible = true
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
		
		
		function innerElements:CreateParagraph(config)
			if hasTabs then return end
			local titleText = ""
			local descText = ""
			if type(config) == "table" then
				titleText = config.title or config.Title or ""
				descText = config.desc or config.Desc or config.description or config.Description or config.text or config.Text or ""
			elseif type(config) == "string" then
				descText = config
			end
			local paraFrame = Instance.new("Frame")
			paraFrame.Size = UDim2.new(1, 0, 0, 0)
			paraFrame.AutomaticSize = Enum.AutomaticSize.Y
			paraFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 30)
			paraFrame.Parent = boxContent
			Instance.new("UICorner", paraFrame).CornerRadius = UDim.new(0, 6)
			local stroke = Instance.new("UIStroke", paraFrame)
			stroke.Color = Color3.fromRGB(48, 48, 52)
			stroke.Thickness = 1
			local padding = Instance.new("UIPadding", paraFrame)
			padding.PaddingTop = UDim.new(0, 6)
			padding.PaddingBottom = UDim.new(0, 6)
			padding.PaddingLeft = UDim.new(0, 8)
			padding.PaddingRight = UDim.new(0, 8)
			local layout = Instance.new("UIListLayout", paraFrame)
			layout.SortOrder = Enum.SortOrder.LayoutOrder
			layout.Padding = UDim.new(0, 2)
			if titleText ~= "" then
				local titleLbl = Instance.new("TextLabel")
				titleLbl.Size = UDim2.new(1, 0, 0, 0)
				titleLbl.AutomaticSize = Enum.AutomaticSize.Y
				titleLbl.BackgroundTransparency = 1
				titleLbl.Text = titleText
				titleLbl.TextColor3 = Color3.fromRGB(240, 240, 245)
				titleLbl.TextSize = 11
				titleLbl.Font = Enum.Font.GothamBold
				titleLbl.TextXAlignment = Enum.TextXAlignment.Left
				titleLbl.TextWrapped = true
				titleLbl.LayoutOrder = 1
				titleLbl.Parent = paraFrame
			end
			if descText ~= "" then
				local descLbl = Instance.new("TextLabel")
				descLbl.Size = UDim2.new(1, 0, 0, 0)
				descLbl.AutomaticSize = Enum.AutomaticSize.Y
				descLbl.BackgroundTransparency = 1
				descLbl.Text = descText
				descLbl.TextColor3 = Color3.fromRGB(140, 140, 145)
				descLbl.TextSize = 10
				descLbl.Font = Enum.Font.Gotham
				descLbl.TextXAlignment = Enum.TextXAlignment.Left
				descLbl.TextWrapped = true
				descLbl.LayoutOrder = 2
				descLbl.Parent = paraFrame
			end
			return paraFrame
		end

		
		function innerElements:CreateLabel(text)
			if hasTabs then return end
			local labelText = ""
			if type(text) == "table" then
				labelText = text.text or text.title or text.Text or ""
			else
				labelText = tostring(text or "")
			end
			local label = Instance.new("TextLabel")
			label.Size = UDim2.new(1, 0, 0, 16)
			label.BackgroundTransparency = 1
			label.Text = labelText
			label.TextColor3 = Color3.fromRGB(240, 240, 245)
			label.TextSize = 11
			label.Font = Enum.Font.GothamMedium
			label.TextXAlignment = Enum.TextXAlignment.Left
			label.TextWrapped = true
			label.Parent = boxContent
			return label
		end

		
		function innerElements:CreateDivider(text)
			if hasTabs then return end
			local dividerText = ""
			if type(text) == "table" then
				dividerText = text.text or text.title or text.Text or ""
			elseif type(text) == "string" then
				dividerText = text
			end
			local divFrame = Instance.new("Frame")
			divFrame.Size = UDim2.new(1, 0, 0, 16)
			divFrame.BackgroundTransparency = 1
			divFrame.Parent = boxContent
			local line = Instance.new("Frame")
			line.Size = UDim2.new(1, 0, 0, 1)
			line.Position = UDim2.new(0, 0, 0.5, 0)
			line.BackgroundColor3 = Color3.fromRGB(48, 48, 52)
			line.BorderSizePixel = 0
			line.Parent = divFrame
			if dividerText ~= "" then
				local textSize = 10
				if string.len(dividerText) > 20 then textSize = 9 end
				if string.len(dividerText) > 35 then textSize = 8 end
				if string.len(dividerText) > 50 then textSize = 7 end
				local textLabel = Instance.new("TextLabel")
				textLabel.Size = UDim2.new(0, 0, 0, 16)
				textLabel.AutomaticSize = Enum.AutomaticSize.X
				textLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
				textLabel.AnchorPoint = Vector2.new(0.5, 0.5)
				textLabel.BackgroundColor3 = Color3.fromRGB(28, 28, 30)
				textLabel.Text = dividerText
				textLabel.TextColor3 = Color3.fromRGB(140, 140, 145)
				textLabel.TextSize = textSize
				textLabel.Font = Enum.Font.GothamMedium
				textLabel.Parent = divFrame
				local pad = Instance.new("UIPadding", textLabel)
				pad.PaddingLeft = UDim.new(0, 8)
				pad.PaddingRight = UDim.new(0, 8)
			end
			return divFrame
		end

		
		function innerElements:CreateKeybind(key, callback)
			if hasTabs then return end
			local defaultKey = "G"
			local cb = nil
			if type(key) == "table" then
				defaultKey = key.key or key.Key or key.default or key.Default or "G"
				cb = key.callback or key.Callback
			else
				defaultKey = key or "G"
				cb = callback
			end
			local keybindFrame = Instance.new("Frame")
			keybindFrame.Size = UDim2.new(1, 0, 0, 24)
			keybindFrame.BackgroundTransparency = 1
			keybindFrame.Parent = boxContent
			local lbl = Instance.new("TextLabel")
			lbl.Size = UDim2.new(1, -60, 1, 0)
			lbl.BackgroundTransparency = 1
			lbl.Text = "Keybind"
			lbl.TextColor3 = Color3.fromRGB(210, 210, 215)
			lbl.TextSize = 11
			lbl.Font = Enum.Font.GothamMedium
			lbl.TextXAlignment = Enum.TextXAlignment.Left
			lbl.Parent = keybindFrame
			local keyBtn = Instance.new("TextButton")
			keyBtn.Size = UDim2.new(0, 50, 0, 20)
			keyBtn.Position = UDim2.new(1, -50, 0.5, -10)
			keyBtn.BackgroundColor3 = Color3.fromRGB(36, 36, 38)
			keyBtn.Text = tostring(defaultKey)
			keyBtn.TextColor3 = Color3.fromRGB(230, 230, 235)
			keyBtn.TextSize = 11
			keyBtn.Font = Enum.Font.GothamMedium
			keyBtn.Parent = keybindFrame
			Instance.new("UICorner", keyBtn).CornerRadius = UDim.new(0, 5)
			local stroke = Instance.new("UIStroke", keyBtn)
			stroke.Color = Color3.fromRGB(55, 55, 60)
			local currentKey = tostring(defaultKey)
			local function getKeyCode(str)
				local upper = string.upper(str)
				local success, code = pcall(function() return Enum.KeyCode[upper] end)
				if success and code then return code end
				return Enum.KeyCode.G
			end
			local currentKeyCode = getKeyCode(currentKey)
			local binding = false
			keyBtn.MouseButton1Click:Connect(function()
				if binding then return end
				binding = true
				keyBtn.Text = "..."
				local conn
				conn = userInputService.InputBegan:Connect(function(input, gameProcessed)
					if gameProcessed then return end
					if input.UserInputType == Enum.UserInputType.Keyboard then
						currentKeyCode = input.KeyCode
						currentKey = input.KeyCode.Name
						keyBtn.Text = currentKey
						binding = false
						conn:Disconnect()
					end
				end)
			end)
			userInputService.InputBegan:Connect(function(input, gameProcessed)
				if gameProcessed then return end
				if binding then return end
				if userInputService:GetFocusedTextBox() then return end
				if input.KeyCode == currentKeyCode then
					if cb then cb() end
				end
			end)
			return keybindFrame
		end
		function innerElements:Createkeybind(key, callback)
			return innerElements:CreateKeybind(key, callback)
		end


function innerElements:CreateColorpicker(text, default, callback)
			if hasTabs then return end
			currentDualButtonRow = nil
			local defaultColor = default
			if typeof(defaultColor) ~= "Color3" then defaultColor = Color3.fromRGB(255, 0, 0) end
			local currentColor = defaultColor
			local h, s, v = Color3.toHSV(currentColor)

			local pickerFrame = Instance.new("Frame")
			pickerFrame.Size = UDim2.new(1, 0, 0, 24)
			pickerFrame.BackgroundTransparency = 1
			pickerFrame.Parent = boxContent

			local lbl = Instance.new("TextLabel")
			lbl.Size = UDim2.new(1, -40, 1, 0)
			lbl.BackgroundTransparency = 1
			lbl.Text = text
			lbl.TextColor3 = Color3.fromRGB(210, 210, 215)
			lbl.TextSize = 11
			lbl.Font = Enum.Font.GothamMedium
			lbl.TextXAlignment = Enum.TextXAlignment.Left
			lbl.Parent = pickerFrame

			local previewBtn = Instance.new("TextButton")
			previewBtn.Size = UDim2.new(0, 28, 0, 18)
			previewBtn.Position = UDim2.new(1, -28, 0.5, -9)
			previewBtn.BackgroundColor3 = currentColor
			previewBtn.Text = ""
			previewBtn.Parent = pickerFrame
			Instance.new("UICorner", previewBtn).CornerRadius = UDim.new(0, 4)
			local previewStroke = Instance.new("UIStroke", previewBtn)
			previewStroke.Color = Color3.fromRGB(55, 55, 60)
			previewStroke.Thickness = 1

			local popup = Instance.new("Frame")
			popup.Name = "ColorPickerPopup"
			popup.Size = UDim2.new(0, 260, 0, 300)
			popup.Position = UDim2.new(0.5, -130, 0.5, -150)
			popup.BackgroundColor3 = Color3.fromRGB(32, 32, 34)
			popup.Visible = false
			popup.ZIndex = 50
			popup.Parent = mainUI
			Instance.new("UICorner", popup).CornerRadius = UDim.new(0, 8)
			local popStroke = Instance.new("UIStroke", popup)
			popStroke.Color = Color3.fromRGB(60, 60, 65)
			popStroke.Thickness = 1.5

			local popTitle = Instance.new("TextLabel")
			popTitle.Size = UDim2.new(1, -20, 0, 24)
			popTitle.Position = UDim2.new(0, 10, 0, 8)
			popTitle.BackgroundTransparency = 1
			popTitle.Text = "Select color"
			popTitle.TextColor3 = Color3.fromRGB(240,240,245)
			popTitle.TextSize = 12
			popTitle.Font = Enum.Font.GothamBold
			popTitle.TextXAlignment = Enum.TextXAlignment.Left
			popTitle.ZIndex = 51
			popTitle.Parent = popup

			local closeBtn = Instance.new("TextButton")
			closeBtn.Size = UDim2.new(0, 20, 0, 20)
			closeBtn.Position = UDim2.new(1, -28, 0, 8)
			closeBtn.BackgroundTransparency = 1
			closeBtn.Text = "x"
			closeBtn.TextColor3 = Color3.fromRGB(180,180,185)
			closeBtn.TextSize = 14
			closeBtn.Font = Enum.Font.GothamBold
			closeBtn.ZIndex = 51
			closeBtn.Parent = popup

			local svBox = Instance.new("Frame")
			svBox.Size = UDim2.new(0, 180, 0, 140)
			svBox.Position = UDim2.new(0, 10, 0, 36)
			svBox.BackgroundColor3 = Color3.fromHSV(h,1,1)
			svBox.ZIndex = 51
			svBox.Parent = popup
			Instance.new("UICorner", svBox).CornerRadius = UDim.new(0, 6)


			local whiteOverlay = Instance.new("Frame")
			whiteOverlay.Size = UDim2.new(1,0,1,0)
			whiteOverlay.BackgroundColor3 = Color3.fromRGB(255,255,255)
			whiteOverlay.ZIndex = 52
			whiteOverlay.Parent = svBox
			local whiteGrad = Instance.new("UIGradient", whiteOverlay)
			whiteGrad.Rotation = 0
			whiteGrad.Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0,0),
				NumberSequenceKeypoint.new(1,1)
			})
			Instance.new("UICorner", whiteOverlay).CornerRadius = UDim.new(0, 6)

			local blackOverlay = Instance.new("Frame")
			blackOverlay.Size = UDim2.new(1,0,1,0)
			blackOverlay.BackgroundColor3 = Color3.fromRGB(0,0,0)
			blackOverlay.ZIndex = 53
			blackOverlay.Parent = svBox
			local blackGrad = Instance.new("UIGradient", blackOverlay)
			blackGrad.Rotation = 90
			blackGrad.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,1), NumberSequenceKeypoint.new(1,0)})
			Instance.new("UICorner", blackOverlay).CornerRadius = UDim.new(0, 6)

			local svCursor = Instance.new("Frame")
			svCursor.Size = UDim2.new(0, 8, 0, 8)
			svCursor.AnchorPoint = Vector2.new(0.5,0.5)
			svCursor.BackgroundColor3 = Color3.fromRGB(255,255,255)
			svCursor.ZIndex = 55
			svCursor.Parent = svBox
			Instance.new("UICorner", svCursor).CornerRadius = UDim.new(1,0)

			local hueBar = Instance.new("Frame")
			hueBar.Size = UDim2.new(0, 16, 0, 140)
			hueBar.Position = UDim2.new(0, 200, 0, 36)
			hueBar.ZIndex = 51
			hueBar.Parent = popup
			Instance.new("UICorner", hueBar).CornerRadius = UDim.new(0, 8)
			local hueGrad = Instance.new("UIGradient", hueBar)
			hueGrad.Rotation = 90
			hueGrad.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(255,0,0)),
				ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255,255,0)),
				ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0,255,0)),
				ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0,255,255)),
				ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0,0,255)),
				ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255,0,255)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(255,0,0))
			})

			local hueCursor = Instance.new("Frame")
			hueCursor.Size = UDim2.new(1, 4, 0, 4)
			hueCursor.AnchorPoint = Vector2.new(0.5,0.5)
			hueCursor.BackgroundColor3 = Color3.fromRGB(255,255,255)
			hueCursor.ZIndex = 52
			hueCursor.Parent = hueBar
			Instance.new("UICorner", hueCursor).CornerRadius = UDim.new(1,0)

			local bigPreview = Instance.new("Frame")
			bigPreview.Size = UDim2.new(0, 50, 0, 50)
			bigPreview.Position = UDim2.new(1, -60, 0, 36)
			bigPreview.BackgroundColor3 = currentColor
			bigPreview.ZIndex = 51
			bigPreview.Parent = popup
			Instance.new("UICorner", bigPreview).CornerRadius = UDim.new(0, 8)

			local hexBox = Instance.new("TextBox")
			hexBox.Size = UDim2.new(0, 90, 0, 22)
			hexBox.Position = UDim2.new(0, 10, 0, 186)
			hexBox.BackgroundColor3 = Color3.fromRGB(42,42,46)
			hexBox.Text = string.format("#%02X%02X%02X", currentColor.R*255, currentColor.G*255, currentColor.B*255)
			hexBox.TextColor3 = Color3.fromRGB(230,230,235)
			hexBox.TextSize = 11
			hexBox.Font = Enum.Font.Gotham
			hexBox.ZIndex = 51
			hexBox.Parent = popup
			Instance.new("UICorner", hexBox).CornerRadius = UDim.new(0, 5)

			local presetFrame = Instance.new("Frame")
			presetFrame.Size = UDim2.new(1, -20, 0, 60)
			presetFrame.Position = UDim2.new(0, 10, 0, 216)
			presetFrame.BackgroundTransparency = 1
			presetFrame.ZIndex = 51
			presetFrame.Parent = popup
			local presetLayout = Instance.new("UIGridLayout", presetFrame)
			presetLayout.CellPadding = UDim2.new(0, 4, 0, 4)
			presetLayout.CellSize = UDim2.new(0, 18, 0, 18)

			local presetColors = {
				Color3.fromRGB(255,255,255), Color3.fromRGB(0,0,0), Color3.fromRGB(244,67,54), Color3.fromRGB(233,30,99),
				Color3.fromRGB(156,39,176), Color3.fromRGB(103,58,183), Color3.fromRGB(63,81,181), Color3.fromRGB(33,150,243),
				Color3.fromRGB(0,188,212), Color3.fromRGB(0,150,136), Color3.fromRGB(76,175,80), Color3.fromRGB(255,235,59),
				Color3.fromRGB(255,193,7), Color3.fromRGB(255,152,0), Color3.fromRGB(255,87,34), Color3.fromRGB(121,85,72)
			}
			for _, col in ipairs(presetColors) do
				local cBtn = Instance.new("TextButton")
				cBtn.BackgroundColor3 = col
				cBtn.Text = ""
				cBtn.ZIndex = 52
				cBtn.Parent = presetFrame
				Instance.new("UICorner", cBtn).CornerRadius = UDim.new(0, 4)
				cBtn.MouseButton1Click:Connect(function()
					currentColor = col
					h,s,v = Color3.toHSV(col)
					previewBtn.BackgroundColor3 = col
					bigPreview.BackgroundColor3 = col
					svBox.BackgroundColor3 = Color3.fromHSV(h,1,1)
					hexBox.Text = string.format("#%02X%02X%02X", col.R*255, col.G*255, col.B*255)
					svCursor.Position = UDim2.new(s,0,1-v,0)
					hueCursor.Position = UDim2.new(0.5,0,h,0)
					if callback then callback(col) end
				end)
			end

			local function updateColorFromHSV()
				currentColor = Color3.fromHSV(h,s,v)
				previewBtn.BackgroundColor3 = currentColor
				bigPreview.BackgroundColor3 = currentColor
				svBox.BackgroundColor3 = Color3.fromHSV(h,1,1)
				hexBox.Text = string.format("#%02X%02X%02X", currentColor.R*255, currentColor.G*255, currentColor.B*255)
				if callback then callback(currentColor) end
			end

			local draggingSV = false
			svBox.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then draggingSV=true end
			end)
			userInputService.InputChanged:Connect(function(input)
				if draggingSV and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
					local relX = math.clamp((input.Position.X - svBox.AbsolutePosition.X)/svBox.AbsoluteSize.X,0,1)
					local relY = math.clamp((input.Position.Y - svBox.AbsolutePosition.Y)/svBox.AbsoluteSize.Y,0,1)
					s=relX v=1-relY svCursor.Position=UDim2.new(s,0,1-v,0) updateColorFromHSV()
				end
			end)
			userInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then draggingSV=false end
			end)

			local draggingHue = false
			hueBar.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then draggingHue=true end
			end)
			userInputService.InputChanged:Connect(function(input)
				if draggingHue and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
					local relY = math.clamp((input.Position.Y - hueBar.AbsolutePosition.Y)/hueBar.AbsoluteSize.Y,0,1)
					h=relY hueCursor.Position=UDim2.new(0.5,0,h,0) updateColorFromHSV()
				end
			end)
			userInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then draggingHue=false end
			end)

			svCursor.Position = UDim2.new(s,0,1-v,0)
			hueCursor.Position = UDim2.new(0.5,0,h,0)

			previewBtn.MouseButton1Click:Connect(function() popup.Visible = not popup.Visible end)
			closeBtn.MouseButton1Click:Connect(function() popup.Visible = false end)

			return pickerFrame
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
				task.spawn(function()
					task.wait()
					if page and pageLayout then
						page.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y + 30)
					end
				end)
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

			local row = Instance.new("Frame")
			row.Name = "ButtonRow"
			row.Size = UDim2.new(1, 0, 0, 24)
			row.BackgroundTransparency = 1
			row.Parent = tPage

			local btn = Instance.new("TextButton")
			btn.Name = "MainButton"
			btn.Size = UDim2.new(1, 0, 1, 0)
			btn.BackgroundColor3 = Color3.fromRGB(36, 36, 38)
			btn.Text = titleText
			btn.TextColor3 = Color3.fromRGB(230, 230, 235)
			btn.TextSize = 11
			btn.Font = Enum.Font.GothamMedium
			btn.Parent = row
			Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
			local str = Instance.new("UIStroke", btn)
			str.Color = Color3.fromRGB(52, 52, 56)
			btn.MouseButton1Click:Connect(function() if cb then cb() end end)

			local api = {}
			api.Instance = btn
			api.Row = row
			api.IsDual = false

			function api:CreateButton(secondConfig, secondCallback)
				if self.IsDual then return nil end
				local secondTitle = ""
				local secondCb = secondCallback
				if type(secondConfig) == "table" then
					secondTitle = secondConfig.title or secondConfig.text or ""
					secondCb = secondConfig.callback
				else
					secondTitle = secondConfig or ""
				end


				self.Instance.Size = UDim2.new(0.49, 0, 1, 0)
				self.Instance.Position = UDim2.new(0, 0, 0, 0)


				local btn2 = Instance.new("TextButton")
				btn2.Name = "SecondButton"
				btn2.Size = UDim2.new(0.49, 0, 1, 0)
				btn2.Position = UDim2.new(0.51, 0, 0, 0)
				btn2.BackgroundColor3 = Color3.fromRGB(36, 36, 38)
				btn2.Text = secondTitle
				btn2.TextColor3 = Color3.fromRGB(230, 230, 235)
				btn2.TextSize = 11
				btn2.Font = Enum.Font.GothamMedium
				btn2.Parent = row
				Instance.new("UICorner", btn2).CornerRadius = UDim.new(0, 5)
				local str2 = Instance.new("UIStroke", btn2)
				str2.Color = Color3.fromRGB(52, 52, 56)
				btn2.MouseButton1Click:Connect(function() if secondCb then secondCb() end end)

				self.IsDual = true


				local api2 = {}
				api2.Instance = btn2
				api2.Row = row
				api2.IsDual = true
				function api2:CreateButton() return nil end
				setmetatable(api2, {
					__index = function(t,k)
						local v = rawget(t,k)
						if v ~= nil then return v end
						return t.Instance[k]
					end,
					__newindex = function(t,k,v)
						if pcall(function() return t.Instance[k] end) then
							t.Instance[k] = v
						else
							rawset(t,k,v)
						end
					end
				})
				return api2
			end

			setmetatable(api, {
				__index = function(t,k)
					local v = rawget(t,k)
					if v ~= nil then return v end
					return t.Instance[k]
				end,
				__newindex = function(t,k,v)

					local success = pcall(function() t.Instance[k] = v end)
					if not success then
						rawset(t,k,v)
					end
				end
			})

			return api
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
			
			local valBtn = Instance.new("TextButton")
			valBtn.Size = UDim2.new(0, 50, 0, 12)
			valBtn.Position = UDim2.new(1, -50, 0, 0)
			valBtn.BackgroundTransparency = 1
			valBtn.Text = tostring(default)
			valBtn.TextColor3 = Color3.fromRGB(150, 150, 155)
			valBtn.TextSize = 10
			valBtn.Font = Enum.Font.GothamMedium
			valBtn.TextXAlignment = Enum.TextXAlignment.Right
			valBtn.Parent = sliderFrame
			
			local valInput = Instance.new("TextBox")
			valInput.Size = UDim2.new(0, 50, 0, 14)
			valInput.Position = UDim2.new(1, -50, 0, -1)
			valInput.BackgroundColor3 = Color3.fromRGB(36,36,38)
			valInput.Text = tostring(default)
			valInput.TextColor3 = Color3.fromRGB(230,230,235)
			valInput.TextSize = 10
			valInput.Font = Enum.Font.GothamMedium
			valInput.Visible = false
			valInput.ClearTextOnFocus = false
			valInput.Parent = sliderFrame
			Instance.new("UICorner", valInput).CornerRadius = UDim.new(0, 4)
			local inputStroke = Instance.new("UIStroke", valInput)
			inputStroke.Color = Color3.fromRGB(0,140,255)
			inputStroke.Thickness = 1
			
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
			
			local dot = Instance.new("Frame")
			dot.Name = "SliderDot"
			dot.Size = UDim2.new(0, 10, 0, 10)
			dot.Position = UDim2.new(pct, -5, 0.5, -5)
			dot.BackgroundColor3 = Color3.fromRGB(255,255,255)
			dot.BorderSizePixel = 0
			dot.ZIndex = 2
			dot.Parent = bar
			Instance.new("UICorner", dot).CornerRadius = UDim.new(1,0)
			local dotStroke = Instance.new("UIStroke", dot)
			dotStroke.Color = Color3.fromRGB(0,140,255)
			dotStroke.Thickness = 1.5
			
			local sliding = false
			local currentVal = default
			local function setSliderValue(val)
				local clamped = math.clamp(val, min, max)
				local movePct = (clamped - min) / (max - min)
				fill.Size = UDim2.new(movePct, 0, 1, 0)
				dot.Position = UDim2.new(movePct, -5, 0.5, -5)
				valBtn.Text = tostring(math.floor(clamped))
				valInput.Text = tostring(math.floor(clamped))
				currentVal = math.floor(clamped)
				if callback then callback(currentVal) end
			end

			local function updateSlider(input)
				local movePct = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
				local val = min + (max - min) * movePct
				setSliderValue(val)
			end
			
			bar.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					sliding = true
					updateSlider(input)
				end
			end)
			dot.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					sliding = true
				end
			end)
			userInputService.InputChanged:Connect(function(input)
				if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then updateSlider(input) end
			end)
			userInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then sliding = false end
			end)

			valBtn.MouseButton1Click:Connect(function()
				valBtn.Visible = false
				valInput.Visible = true
				valInput:CaptureFocus()
				valInput.Text = tostring(currentVal)
			end)

			valInput.FocusLost:Connect(function(enterPressed)
				local num = tonumber(valInput.Text)
				if num then
					setSliderValue(num)
				end
				valInput.Visible = false
				valBtn.Visible = true
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
			
			
		function tabElements:CreateParagraph(config)
						local titleText = ""
			local descText = ""
			if type(config) == "table" then
				titleText = config.title or config.Title or ""
				descText = config.desc or config.Desc or config.description or config.Description or config.text or config.Text or ""
			elseif type(config) == "string" then
				descText = config
			end
			local paraFrame = Instance.new("Frame")
			paraFrame.Size = UDim2.new(1, 0, 0, 0)
			paraFrame.AutomaticSize = Enum.AutomaticSize.Y
			paraFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 30)
			paraFrame.Parent = tPage
			Instance.new("UICorner", paraFrame).CornerRadius = UDim.new(0, 6)
			local stroke = Instance.new("UIStroke", paraFrame)
			stroke.Color = Color3.fromRGB(48, 48, 52)
			stroke.Thickness = 1
			local padding = Instance.new("UIPadding", paraFrame)
			padding.PaddingTop = UDim.new(0, 6)
			padding.PaddingBottom = UDim.new(0, 6)
			padding.PaddingLeft = UDim.new(0, 8)
			padding.PaddingRight = UDim.new(0, 8)
			local layout = Instance.new("UIListLayout", paraFrame)
			layout.SortOrder = Enum.SortOrder.LayoutOrder
			layout.Padding = UDim.new(0, 2)
			if titleText ~= "" then
				local titleLbl = Instance.new("TextLabel")
				titleLbl.Size = UDim2.new(1, 0, 0, 0)
				titleLbl.AutomaticSize = Enum.AutomaticSize.Y
				titleLbl.BackgroundTransparency = 1
				titleLbl.Text = titleText
				titleLbl.TextColor3 = Color3.fromRGB(240, 240, 245)
				titleLbl.TextSize = 11
				titleLbl.Font = Enum.Font.GothamBold
				titleLbl.TextXAlignment = Enum.TextXAlignment.Left
				titleLbl.TextWrapped = true
				titleLbl.LayoutOrder = 1
				titleLbl.Parent = paraFrame
			end
			if descText ~= "" then
				local descLbl = Instance.new("TextLabel")
				descLbl.Size = UDim2.new(1, 0, 0, 0)
				descLbl.AutomaticSize = Enum.AutomaticSize.Y
				descLbl.BackgroundTransparency = 1
				descLbl.Text = descText
				descLbl.TextColor3 = Color3.fromRGB(140, 140, 145)
				descLbl.TextSize = 10
				descLbl.Font = Enum.Font.Gotham
				descLbl.TextXAlignment = Enum.TextXAlignment.Left
				descLbl.TextWrapped = true
				descLbl.LayoutOrder = 2
				descLbl.Parent = paraFrame
			end
			return paraFrame
		end


			
		function tabElements:CreateLabel(text)
						local labelText = ""
			if type(text) == "table" then
				labelText = text.text or text.title or text.Text or ""
			else
				labelText = tostring(text or "")
			end
			local label = Instance.new("TextLabel")
			label.Size = UDim2.new(1, 0, 0, 16)
			label.BackgroundTransparency = 1
			label.Text = labelText
			label.TextColor3 = Color3.fromRGB(240, 240, 245)
			label.TextSize = 11
			label.Font = Enum.Font.GothamMedium
			label.TextXAlignment = Enum.TextXAlignment.Left
			label.TextWrapped = true
			label.Parent = tPage
			return label
		end


			
		function tabElements:CreateDivider(text)
						local dividerText = ""
			if type(text) == "table" then
				dividerText = text.text or text.title or text.Text or ""
			elseif type(text) == "string" then
				dividerText = text
			end
			local divFrame = Instance.new("Frame")
			divFrame.Size = UDim2.new(1, 0, 0, 16)
			divFrame.BackgroundTransparency = 1
			divFrame.Parent = tPage
			local line = Instance.new("Frame")
			line.Size = UDim2.new(1, 0, 0, 1)
			line.Position = UDim2.new(0, 0, 0.5, 0)
			line.BackgroundColor3 = Color3.fromRGB(48, 48, 52)
			line.BorderSizePixel = 0
			line.Parent = divFrame
			if dividerText ~= "" then
				local textSize = 10
				if string.len(dividerText) > 20 then textSize = 9 end
				if string.len(dividerText) > 35 then textSize = 8 end
				if string.len(dividerText) > 50 then textSize = 7 end
				local textLabel = Instance.new("TextLabel")
				textLabel.Size = UDim2.new(0, 0, 0, 16)
				textLabel.AutomaticSize = Enum.AutomaticSize.X
				textLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
				textLabel.AnchorPoint = Vector2.new(0.5, 0.5)
				textLabel.BackgroundColor3 = Color3.fromRGB(28, 28, 30)
				textLabel.Text = dividerText
				textLabel.TextColor3 = Color3.fromRGB(140, 140, 145)
				textLabel.TextSize = textSize
				textLabel.Font = Enum.Font.GothamMedium
				textLabel.Parent = divFrame
				local pad = Instance.new("UIPadding", textLabel)
				pad.PaddingLeft = UDim.new(0, 8)
				pad.PaddingRight = UDim.new(0, 8)
			end
			return divFrame
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
