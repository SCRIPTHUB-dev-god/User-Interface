local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer

local Icarus = {}
Icarus.__index = Icarus

local Theme = {
    Background = Color3.fromRGB(15,15,15),
    Surface = Color3.fromRGB(20,20,20),
    Accent = Color3.fromRGB(0,170,255),
    Text = Color3.fromRGB(255,255,255),
    Divider = Color3.fromRGB(40,40,40),
    Groupbox = Color3.fromRGB(25,25,25)
}

local function Create(Class, Properties)
    local Object = Instance.new(Class)

    for Index, Value in pairs(Properties or {}) do
        Object[Index] = Value
    end

    return Object
end

function Icarus:SetTheme(NewTheme)
    for Index, Value in pairs(NewTheme) do
        Theme[Index] = Value
    end
end

function Icarus:CreateWindow(Data)
    local Window = {}
    Window.Tabs = {}

    local ScreenGui = Create("ScreenGui",{
        Name = "IcarusLibrary",
        Parent = CoreGui,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })

    local Main = Create("Frame",{
        Parent = ScreenGui,
        Size = UDim2.new(0,700,0,450),
        Position = UDim2.new(0.5,-350,0.5,-225),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0
    })

    Create("UICorner",{
        Parent = Main,
        CornerRadius = UDim.new(0,14)
    })

    local Topbar = Create("Frame",{
        Parent = Main,
        Size = UDim2.new(1,0,0,42),
        BackgroundTransparency = 1
    })

    local Title = Create("TextLabel",{
        Parent = Topbar,
        Size = UDim2.new(1,0,1,0),
        BackgroundTransparency = 1,
        Text = Data.text or "Icarus Library",
        TextColor3 = Theme.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 16
    })

    local TabHolder = Create("Frame",{
        Parent = Main,
        Position = UDim2.new(0,10,0,50),
        Size = UDim2.new(0,170,1,-60),
        BackgroundColor3 = Theme.Surface,
        BorderSizePixel = 0
    })

    Create("UICorner",{
        Parent = TabHolder,
        CornerRadius = UDim.new(0,12)
    })

    local TabList = Create("UIListLayout",{
        Parent = TabHolder,
        Padding = UDim.new(0,6),
        SortOrder = Enum.SortOrder.LayoutOrder
    })

    local PageHolder = Create("Frame",{
        Parent = Main,
        Position = UDim2.new(0,190,0,50),
        Size = UDim2.new(1,-200,1,-60),
        BackgroundTransparency = 1
    })

    local Dragging = false
    local DragInput
    local DragStart
    local StartPos

    Topbar.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = true
            DragStart = Input.Position
            StartPos = Main.Position

            Input.Changed:Connect(function()
                if Input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)

    Topbar.InputChanged:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseMovement then
            DragInput = Input
        end
    end)

    UserInputService.InputChanged:Connect(function(Input)
        if Input == DragInput and Dragging then
            local Delta = Input.Position - DragStart

            Main.Position = UDim2.new(
                StartPos.X.Scale,
                StartPos.X.Offset + Delta.X,
                StartPos.Y.Scale,
                StartPos.Y.Offset + Delta.Y
            )
        end
    end)

    function Window:AddTab(DataTab)
        local Tab = {}
        Tab.Elements = {}

        local TabButton = Create("TextButton",{
            Parent = TabHolder,
            Size = UDim2.new(1,-12,0,38),
            Position = UDim2.new(0,6,0,0),
            BackgroundColor3 = Theme.Groupbox,
            BorderSizePixel = 0,
            Text = DataTab.text or "Tab",
            Font = Enum.Font.GothamSemibold,
            TextSize = 14,
            TextColor3 = Theme.Text,
            AutoButtonColor = false
        })

        Create("UICorner",{
            Parent = TabButton,
            CornerRadius = UDim.new(0,10)
        })

        local Page = Create("ScrollingFrame",{
            Parent = PageHolder,
            Size = UDim2.new(1,0,1,0),
            CanvasSize = UDim2.new(0,0,0,0),
            ScrollBarThickness = 0,
            BackgroundTransparency = 1,
            Visible = false
        })

        local Layout = Create("UIListLayout",{
            Parent = Page,
            Padding = UDim.new(0,10),
            SortOrder = Enum.SortOrder.LayoutOrder
        })

        Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0,0,0,Layout.AbsoluteContentSize.Y + 20)
        end)

        function Tab:Show()
            for _,Child in pairs(PageHolder:GetChildren()) do
                if Child:IsA("ScrollingFrame") then
                    Child.Visible = false
                end
            end

            Page.Visible = true
        end

        TabButton.MouseButton1Click:Connect(function()
            Tab:Show()
        end)

        function Tab:AddGroupbox(GroupData)
            local Groupbox = {}

            local Holder = Create("Frame",{
                Parent = Page,
                Size = UDim2.new(1,-10,0,200),
                BackgroundColor3 = Theme.Groupbox,
                BorderSizePixel = 0
            })

            Create("UICorner",{
                Parent = Holder,
                CornerRadius = UDim.new(0,12)
            })

            local GroupTitle = Create("TextLabel",{
                Parent = Holder,
                Position = UDim2.new(0,12,0,8),
                Size = UDim2.new(1,-20,0,20),
                BackgroundTransparency = 1,
                Text = GroupData.text or "Groupbox",
                Font = Enum.Font.GothamBold,
                TextColor3 = Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local Content = Create("Frame",{
                Parent = Holder,
                Position = UDim2.new(0,10,0,36),
                Size = UDim2.new(1,-20,1,-46),
                BackgroundTransparency = 1
            })

            local ContentLayout = Create("UIListLayout",{
                Parent = Content,
                Padding = UDim.new(0,6),
                SortOrder = Enum.SortOrder.LayoutOrder
            })

            function Groupbox:AddButton(ButtonData)
                local Button = Create("TextButton",{
                    Parent = Content,
                    Size = UDim2.new(1,0,0,34),
                    BackgroundColor3 = Theme.Surface,
                    BorderSizePixel = 0,
                    Text = ButtonData.text or "Button",
                    Font = Enum.Font.GothamMedium,
                    TextColor3 = Theme.Text,
                    TextSize = 13
                })

                Create("UICorner",{
                    Parent = Button,
                    CornerRadius = UDim.new(0,8)
                })

                Button.MouseButton1Click:Connect(function()
                    if ButtonData.callback then
                        ButtonData.callback()
                    end
                end)
            end

            function Groupbox:AddToggle(ToggleData)
                local Enabled = ToggleData.default or false

                local ToggleFrame = Create("TextButton",{
                    Parent = Content,
                    Size = UDim2.new(1,0,0,34),
                    BackgroundColor3 = Theme.Surface,
                    BorderSizePixel = 0,
                    Text = ""
                })

                Create("UICorner",{
                    Parent = ToggleFrame,
                    CornerRadius = UDim.new(0,8)
                })

                local ToggleLabel = Create("TextLabel",{
                    Parent = ToggleFrame,
                    Position = UDim2.new(0,10,0,0),
                    Size = UDim2.new(1,-60,1,0),
                    BackgroundTransparency = 1,
                    Text = ToggleData.text or "Toggle",
                    Font = Enum.Font.GothamMedium,
                    TextColor3 = Theme.Text,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left
                })

                local Indicator = Create("Frame",{
                    Parent = ToggleFrame,
                    AnchorPoint = Vector2.new(1,0.5),
                    Position = UDim2.new(1,-10,0.5,0),
                    Size = UDim2.new(0,18,0,18),
                    BackgroundColor3 = Enabled and Theme.Accent or Color3.fromRGB(50,50,50),
                    BorderSizePixel = 0
                })

                Create("UICorner",{
                    Parent = Indicator,
                    CornerRadius = UDim.new(1,0)
                })

                ToggleFrame.MouseButton1Click:Connect(function()
                    Enabled = not Enabled

                    TweenService:Create(
                        Indicator,
                        TweenInfo.new(0.2),
                        {
                            BackgroundColor3 = Enabled and Theme.Accent or Color3.fromRGB(50,50,50)
                        }
                    ):Play()

                    if ToggleData.callback then
                        ToggleData.callback(Enabled)
                    end
                end)
            end

            function Groupbox:AddSlider(SliderData)
                local Value = SliderData.default or 0
                local Min = SliderData.min or 0
                local Max = SliderData.max or 100

                local SliderFrame = Create("Frame",{
                    Parent = Content,
                    Size = UDim2.new(1,0,0,46),
                    BackgroundColor3 = Theme.Surface,
                    BorderSizePixel = 0
                })

                Create("UICorner",{
                    Parent = SliderFrame,
                    CornerRadius = UDim.new(0,8)
                })

                local SliderLabel = Create("TextLabel",{
                    Parent = SliderFrame,
                    Position = UDim2.new(0,10,0,4),
                    Size = UDim2.new(1,-20,0,18),
                    BackgroundTransparency = 1,
                    Text = SliderData.text or "Slider",
                    Font = Enum.Font.GothamMedium,
                    TextColor3 = Theme.Text,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left
                })

                local Bar = Create("Frame",{
                    Parent = SliderFrame,
                    Position = UDim2.new(0,10,1,-14),
                    Size = UDim2.new(1,-20,0,6),
                    BackgroundColor3 = Color3.fromRGB(40,40,40),
                    BorderSizePixel = 0
                })

                Create("UICorner",{
                    Parent = Bar,
                    CornerRadius = UDim.new(1,0)
                })

                local Fill = Create("Frame",{
                    Parent = Bar,
                    Size = UDim2.new((Value-Min)/(Max-Min),0,1,0),
                    BackgroundColor3 = Theme.Accent,
                    BorderSizePixel = 0
                })

                Create("UICorner",{
                    Parent = Fill,
                    CornerRadius = UDim.new(1,0)
                })
            end

            return Groupbox
        end

        if #Window.Tabs == 0 then
            Tab:Show()
        end

        table.insert(Window.Tabs, Tab)

        return Tab
    end

    return Window
end

return Icarus
