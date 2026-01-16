local lib = {}
local tween = game:GetService("TweenService")
local input = game:GetService("UserInputService")
local run = game:GetService("RunService")

local cfg = {
    main = Color3.fromRGB(30, 30, 35),
    sec = Color3.fromRGB(40, 40, 48),
    acc = Color3.fromRGB(45, 200, 140),
    txt = Color3.fromRGB(255, 255, 255),
    txt2 = Color3.fromRGB(180, 180, 180),
    dark = Color3.fromRGB(25, 25, 30),
    font = Enum.Font.Gotham,
    round = UDim.new(0, 6)
}

local icons = {
    search = "rbxassetid://3926305904",
    star = "rbxassetid://3926305904",
    arrow = "rbxassetid://3926305904",
    settings = "rbxassetid://3926305904",
    close = "rbxassetid://3926305904"
}

local function tw(obj, props, dur)
    tween:Create(obj, TweenInfo.new(dur or 0.2, Enum.EasingStyle.Quad), props):Play()
end

local function create(class, props)
    local obj = Instance.new(class)
    for k, v in pairs(props) do
        if k ~= "Parent" then obj[k] = v end
    end
    if props.Parent then obj.Parent = props.Parent end
    return obj
end

local function ripple(btn)
    local rip = create("Frame", {
        Parent = btn,
        BackgroundColor3 = Color3.new(1, 1, 1),
        BackgroundTransparency = 0.7,
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, 0, 0, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        ZIndex = btn.ZIndex + 1
    })
    create("UICorner", {Parent = rip, CornerRadius = UDim.new(1, 0)})
    local sz = math.max(btn.AbsoluteSize.X, btn.AbsoluteSize.Y) * 2
    tw(rip, {Size = UDim2.new(0, sz, 0, sz), BackgroundTransparency = 1}, 0.4)
    task.delay(0.4, function() rip:Destroy() end)
end

function lib:new(title)
    local gui = create("ScreenGui", {
        Name = "UILib",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })
    
    if syn then
        syn.protect_gui(gui)
        gui.Parent = game:GetService("CoreGui")
    elseif gethui then
        gui.Parent = gethui()
    else
        gui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    end
    
    local main = create("Frame", {
        Parent = gui,
        BackgroundColor3 = cfg.main,
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, -300, 0.5, -200),
        Size = UDim2.new(0, 600, 0, 400),
        ClipsDescendants = true
    })
    create("UICorner", {Parent = main, CornerRadius = cfg.round})
    
    main.Size = UDim2.new(0, 0, 0, 0)
    main.Position = UDim2.new(0.5, 0, 0.5, 0)
    tw(main, {Size = UDim2.new(0, 600, 0, 400), Position = UDim2.new(0.5, -300, 0.5, -200)}, 0.3)
    
    local shadow = create("ImageLabel", {
        Parent = main,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, -15, 0, -15),
        Size = UDim2.new(1, 30, 1, 30),
        ZIndex = 0,
        Image = "rbxassetid://5554236805",
        ImageColor3 = Color3.new(0, 0, 0),
        ImageTransparency = 0.5,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(23, 23, 277, 277)
    })
    
    local topbar = create("Frame", {
        Parent = main,
        BackgroundColor3 = cfg.dark,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 30)
    })
    create("UICorner", {Parent = topbar, CornerRadius = cfg.round})
    create("Frame", {
        Parent = topbar,
        BackgroundColor3 = cfg.dark,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0.5, 0),
        Size = UDim2.new(1, 0, 0.5, 0)
    })
    
    local titleLbl = create("TextLabel", {
        Parent = topbar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 0),
        Size = UDim2.new(0.5, 0, 1, 0),
        Font = cfg.font,
        Text = title or "UILib",
        TextColor3 = cfg.txt,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    local closeBtn = create("TextButton", {
        Parent = topbar,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -30, 0, 0),
        Size = UDim2.new(0, 30, 1, 0),
        Font = cfg.font,
        Text = "×",
        TextColor3 = cfg.txt2,
        TextSize = 20
    })
    closeBtn.MouseButton1Click:Connect(function()
        tw(main, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.2)
        task.delay(0.2, function() gui:Destroy() end)
    end)
    
    local settingsBtn = create("TextButton", {
        Parent = topbar,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -55, 0, 0),
        Size = UDim2.new(0, 25, 1, 0),
        Font = cfg.font,
        Text = "⚙",
        TextColor3 = cfg.txt2,
        TextSize = 16
    })
    
    local sidebar = create("Frame", {
        Parent = main,
        BackgroundColor3 = cfg.dark,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 30),
        Size = UDim2.new(0, 100, 1, -30)
    })
    
    local tabHolder = create("ScrollingFrame", {
        Parent = sidebar,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 5, 0, 5),
        Size = UDim2.new(1, -10, 1, -10),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = cfg.acc
    })
    create("UIListLayout", {Parent = tabHolder, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 3)})
    
    local content = create("Frame", {
        Parent = main,
        BackgroundColor3 = cfg.sec,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 100, 0, 30),
        Size = UDim2.new(1, -100, 1, -30)
    })
    
    local searchBox = create("Frame", {
        Parent = content,
        BackgroundColor3 = cfg.dark,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 10, 0, 10),
        Size = UDim2.new(1, -20, 0, 30)
    })
    create("UICorner", {Parent = searchBox, CornerRadius = cfg.round})
    
    create("ImageLabel", {
        Parent = searchBox,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 8, 0.5, -8),
        Size = UDim2.new(0, 16, 0, 16),
        Image = icons.search,
        ImageColor3 = cfg.txt2,
        ImageRectOffset = Vector2.new(964, 324),
        ImageRectSize = Vector2.new(36, 36)
    })
    
    local searchInput = create("TextBox", {
        Parent = searchBox,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 30, 0, 0),
        Size = UDim2.new(1, -40, 1, 0),
        Font = cfg.font,
        PlaceholderText = "Search for a module...",
        PlaceholderColor3 = cfg.txt2,
        Text = "",
        TextColor3 = cfg.txt,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    local pages = create("Frame", {
        Parent = content,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 50),
        Size = UDim2.new(1, -20, 1, -60)
    })
    
    local dragging, dragStart, startPos
    topbar.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = inp.Position
            startPos = main.Position
        end
    end)
    topbar.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    input.InputChanged:Connect(function(inp)
        if dragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = inp.Position - dragStart
            tw(main, {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}, 0.05)
        end
    end)
    
    local window = {}
    local tabs = {}
    local activeTab = nil
    
    function window:tab(name)
        local tabBtn = create("TextButton", {
            Parent = tabHolder,
            BackgroundColor3 = cfg.sec,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, 28),
            Font = cfg.font,
            Text = name,
            TextColor3 = cfg.txt2,
            TextSize = 13
        })
        create("UICorner", {Parent = tabBtn, CornerRadius = cfg.round})
        
        local page = create("ScrollingFrame", {
            Parent = pages,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 1, 0),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = cfg.acc,
            Visible = false
        })
        create("UIListLayout", {Parent = page, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8)})
        
        local function updateCanvas()
            local layout = page:FindFirstChildOfClass("UIListLayout")
            if layout then
                page.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
            end
        end
        page.ChildAdded:Connect(updateCanvas)
        
        local function activate()
            for _, t in pairs(tabs) do
                tw(t.btn, {BackgroundTransparency = 1, TextColor3 = cfg.txt2}, 0.15)
                t.page.Visible = false
            end
            tw(tabBtn, {BackgroundTransparency = 0, TextColor3 = cfg.txt}, 0.15)
            page.Visible = true
            activeTab = name
        end
        
        tabBtn.MouseButton1Click:Connect(function()
            ripple(tabBtn)
            activate()
        end)
        
        tabs[name] = {btn = tabBtn, page = page}
        if not activeTab then activate() end
        
        local tab = {}
        
        function tab:section(name)
            local sec = create("Frame", {
                Parent = page,
                BackgroundColor3 = cfg.dark,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 35),
                ClipsDescendants = true
            })
            create("UICorner", {Parent = sec, CornerRadius = cfg.round})
            
            local header = create("Frame", {
                Parent = sec,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 35)
            })
            
            create("ImageLabel", {
                Parent = header,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0.5, -8),
                Size = UDim2.new(0, 16, 0, 16),
                Image = icons.star,
                ImageColor3 = cfg.acc,
                ImageRectOffset = Vector2.new(44, 244),
                ImageRectSize = Vector2.new(36, 36)
            })
            
            local titleLbl = create("TextLabel", {
                Parent = header,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 32, 0, 0),
                Size = UDim2.new(0.5, 0, 1, 0),
                Font = cfg.font,
                Text = name,
                TextColor3 = cfg.txt,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local toggle = create("TextButton", {
                Parent = header,
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -35, 0.5, -8),
                Size = UDim2.new(0, 16, 0, 16),
                Font = cfg.font,
                Text = "▼",
                TextColor3 = cfg.txt2,
                TextSize = 10,
                Rotation = 0
            })
            
            local holder = create("Frame", {
                Parent = sec,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 40),
                Size = UDim2.new(1, -20, 0, 0)
            })
            local list = create("UIListLayout", {Parent = holder, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8)})
            
            local open = true
            local function updateSize()
                local h = open and (list.AbsoluteContentSize.Y + 50) or 35
                tw(sec, {Size = UDim2.new(1, 0, 0, h)}, 0.2)
                tw(toggle, {Rotation = open and 0 or -90}, 0.2)
                task.delay(0.2, updateCanvas)
            end
            
            list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                if open then updateSize() end
            end)
            
            toggle.MouseButton1Click:Connect(function()
                open = not open
                updateSize()
            end)
            
            updateSize()
            
            local section = {}
            
            function section:button(name, callback)
                local btn = create("TextButton", {
                    Parent = holder,
                    BackgroundColor3 = cfg.sec,
                    BorderSizePixel = 0,
                    Size = UDim2.new(1, 0, 0, 32),
                    Font = cfg.font,
                    Text = name,
                    TextColor3 = cfg.txt,
                    TextSize = 13,
                    ClipsDescendants = true
                })
                create("UICorner", {Parent = btn, CornerRadius = cfg.round})
                
                btn.MouseEnter:Connect(function()
                    tw(btn, {BackgroundColor3 = cfg.acc}, 0.15)
                end)
                btn.MouseLeave:Connect(function()
                    tw(btn, {BackgroundColor3 = cfg.sec}, 0.15)
                end)
                btn.MouseButton1Click:Connect(function()
                    ripple(btn)
                    if callback then callback() end
                end)
                
                updateSize()
                return btn
            end
            
            function section:toggle(name, default, callback)
                local val = default or false
                
                local frame = create("Frame", {
                    Parent = holder,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 28)
                })
                
                create("TextLabel", {
                    Parent = frame,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0.7, 0, 1, 0),
                    Font = cfg.font,
                    Text = name,
                    TextColor3 = cfg.txt,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local box = create("Frame", {
                    Parent = frame,
                    BackgroundColor3 = val and cfg.acc or cfg.sec,
                    BorderSizePixel = 0,
                    Position = UDim2.new(1, -44, 0.5, -10),
                    Size = UDim2.new(0, 44, 0, 20)
                })
                create("UICorner", {Parent = box, CornerRadius = UDim.new(1, 0)})
                
                local circle = create("Frame", {
                    Parent = box,
                    BackgroundColor3 = cfg.txt,
                    Position = val and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
                    Size = UDim2.new(0, 16, 0, 16)
                })
                create("UICorner", {Parent = circle, CornerRadius = UDim.new(1, 0)})
                
                local btn = create("TextButton", {
                    Parent = box,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    Text = ""
                })
                
                local function update()
                    tw(box, {BackgroundColor3 = val and cfg.acc or cfg.sec}, 0.15)
                    tw(circle, {Position = val and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}, 0.15)
                end
                
                btn.MouseButton1Click:Connect(function()
                    val = not val
                    update()
                    if callback then callback(val) end
                end)
                
                updateSize()
                return {
                    set = function(_, v) val = v update() end,
                    get = function() return val end
                }
            end
            
            function section:slider(name, min, max, default, callback)
                local val = default or min
                
                local frame = create("Frame", {
                    Parent = holder,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 40)
                })
                
                local top = create("Frame", {
                    Parent = frame,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 20)
                })
                
                create("TextLabel", {
                    Parent = top,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0.5, 0, 1, 0),
                    Font = cfg.font,
                    Text = name,
                    TextColor3 = cfg.txt,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local valLbl = create("TextLabel", {
                    Parent = top,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 0, 0, 0),
                    Size = UDim2.new(0.5, 0, 1, 0),
                    Font = cfg.font,
                    Text = tostring(math.floor(val)),
                    TextColor3 = cfg.txt2,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Right
                })
                
                local bar = create("Frame", {
                    Parent = frame,
                    BackgroundColor3 = cfg.sec,
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, 0, 0, 25),
                    Size = UDim2.new(1, 0, 0, 8)
                })
                create("UICorner", {Parent = bar, CornerRadius = UDim.new(1, 0)})
                
                local fill = create("Frame", {
                    Parent = bar,
                    BackgroundColor3 = cfg.acc,
                    BorderSizePixel = 0,
                    Size = UDim2.new((val - min) / (max - min), 0, 1, 0)
                })
                create("UICorner", {Parent = fill, CornerRadius = UDim.new(1, 0)})
                
                local minLbl = create("TextLabel", {
                    Parent = frame,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 33),
                    Size = UDim2.new(0.3, 0, 0, 15),
                    Font = cfg.font,
                    Text = tostring(min),
                    TextColor3 = cfg.txt2,
                    TextSize = 11,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local maxLbl = create("TextLabel", {
                    Parent = frame,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.7, 0, 0, 33),
                    Size = UDim2.new(0.3, 0, 0, 15),
                    Font = cfg.font,
                    Text = tostring(max),
                    TextColor3 = cfg.txt2,
                    TextSize = 11,
                    TextXAlignment = Enum.TextXAlignment.Right
                })
                
                local sliding = false
                
                bar.InputBegan:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                        sliding = true
                    end
                end)
                
                input.InputEnded:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                        sliding = false
                    end
                end)
                
                input.InputChanged:Connect(function(inp)
                    if sliding and inp.UserInputType == Enum.UserInputType.MouseMovement then
                        local pct = math.clamp((inp.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
                        val = math.floor(min + (max - min) * pct)
                        tw(fill, {Size = UDim2.new(pct, 0, 1, 0)}, 0.05)
                        valLbl.Text = tostring(val)
                        if callback then callback(val) end
                    end
                end)
                
                updateSize()
                return {
                    set = function(_, v)
                        val = math.clamp(v, min, max)
                        local pct = (val - min) / (max - min)
                        fill.Size = UDim2.new(pct, 0, 1, 0)
                        valLbl.Text = tostring(math.floor(val))
                    end,
                    get = function() return val end
                }
            end
            
            function section:input(name, default, callback)
                local frame = create("Frame", {
                    Parent = holder,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 28)
                })
                
                create("TextLabel", {
                    Parent = frame,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0.3, 0, 1, 0),
                    Font = cfg.font,
                    Text = name,
                    TextColor3 = cfg.txt,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local box = create("Frame", {
                    Parent = frame,
                    BackgroundColor3 = cfg.sec,
                    BorderSizePixel = 0,
                    Position = UDim2.new(0.35, 0, 0, 0),
                    Size = UDim2.new(0.65, 0, 1, 0)
                })
                create("UICorner", {Parent = box, CornerRadius = cfg.round})
                
                local inp = create("TextBox", {
                    Parent = box,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 8, 0, 0),
                    Size = UDim2.new(1, -16, 1, 0),
                    Font = cfg.font,
                    Text = default or "",
                    TextColor3 = cfg.txt,
                    TextSize = 13,
                    ClearTextOnFocus = false
                })
                
                inp.FocusLost:Connect(function()
                    if callback then callback(inp.Text) end
                end)
                
                updateSize()
                return {
                    set = function(_, v) inp.Text = v end,
                    get = function() return inp.Text end
                }
            end
            
            function section:dropdown(name, options, default, callback)
                local val = default
                local open = false
                
                local frame = create("Frame", {
                    Parent = holder,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 28),
                    ClipsDescendants = true
                })
                
                local header = create("Frame", {
                    Parent = frame,
                    BackgroundColor3 = cfg.sec,
                    BorderSizePixel = 0,
                    Size = UDim2.new(1, 0, 0, 28)
                })
                create("UICorner", {Parent = header, CornerRadius = cfg.round})
                
                create("TextLabel", {
                    Parent = header,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10, 0, 0),
                    Size = UDim2.new(0.4, 0, 1, 0),
                    Font = cfg.font,
                    Text = name,
                    TextColor3 = cfg.txt,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local valLbl = create("TextLabel", {
                    Parent = header,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.4, 0, 0, 0),
                    Size = UDim2.new(0.5, -10, 1, 0),
                    Font = cfg.font,
                    Text = val or "Select",
                    TextColor3 = cfg.txt2,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Right
                })
                
                local arrow = create("TextLabel", {
                    Parent = header,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, -25, 0, 0),
                    Size = UDim2.new(0, 20, 1, 0),
                    Font = cfg.font,
                    Text = "▼",
                    TextColor3 = cfg.txt2,
                    TextSize = 10,
                    Rotation = 0
                })
                
                local optHolder = create("Frame", {
                    Parent = frame,
                    BackgroundColor3 = cfg.sec,
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, 0, 0, 32),
                    Size = UDim2.new(1, 0, 0, #options * 25)
                })
                create("UICorner", {Parent = optHolder, CornerRadius = cfg.round})
                create("UIListLayout", {Parent = optHolder, SortOrder = Enum.SortOrder.LayoutOrder})
                
                for _, opt in ipairs(options) do
                    local optBtn = create("TextButton", {
                        Parent = optHolder,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 0, 25),
                        Font = cfg.font,
                        Text = opt,
                        TextColor3 = cfg.txt2,
                        TextSize = 12
                    })
                    
                    optBtn.MouseEnter:Connect(function()
                        tw(optBtn, {TextColor3 = cfg.acc}, 0.1)
                    end)
                    optBtn.MouseLeave:Connect(function()
                        tw(optBtn, {TextColor3 = cfg.txt2}, 0.1)
                    end)
                    optBtn.MouseButton1Click:Connect(function()
                        val = opt
                        valLbl.Text = opt
                        open = false
                        tw(frame, {Size = UDim2.new(1, 0, 0, 28)}, 0.15)
                        tw(arrow, {Rotation = 0}, 0.15)
                        task.delay(0.15, updateSize)
                        if callback then callback(val) end
                    end)
                end
                
                local btn = create("TextButton", {
                    Parent = header,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    Text = ""
                })
                
                btn.MouseButton1Click:Connect(function()
                    open = not open
                    local h = open and (32 + #options * 25) or 28
                    tw(frame, {Size = UDim2.new(1, 0, 0, h)}, 0.15)
                    tw(arrow, {Rotation = open and 180 or 0}, 0.15)
                    task.delay(0.15, updateSize)
                end)
                
                updateSize()
                return {
                    set = function(_, v)
                        val = v
                        valLbl.Text = v
                    end,
                    get = function() return val end
                }
            end
            
            function section:colorpicker(name, default, callback)
                local val = default or Color3.new(1, 1, 1)
                local open = false
                local h, s, v = val:ToHSV()
                
                local frame = create("Frame", {
                    Parent = holder,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 28),
                    ClipsDescendants = true
                })
                
                local header = create("Frame", {
                    Parent = frame,
                    BackgroundColor3 = cfg.sec,
                    BorderSizePixel = 0,
                    Size = UDim2.new(1, 0, 0, 28)
                })
                create("UICorner", {Parent = header, CornerRadius = cfg.round})
                
                create("TextLabel", {
                    Parent = header,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10, 0, 0),
                    Size = UDim2.new(0.6, 0, 1, 0),
                    Font = cfg.font,
                    Text = name,
                    TextColor3 = cfg.txt,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local preview = create("Frame", {
                    Parent = header,
                    BackgroundColor3 = val,
                    BorderSizePixel = 0,
                    Position = UDim2.new(1, -60, 0.5, -10),
                    Size = UDim2.new(0, 50, 0, 20)
                })
                create("UICorner", {Parent = preview, CornerRadius = cfg.round})
                
                local picker = create("Frame", {
                    Parent = frame,
                    BackgroundColor3 = cfg.dark,
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, 0, 0, 32),
                    Size = UDim2.new(1, 0, 0, 120)
                })
                create("UICorner", {Parent = picker, CornerRadius = cfg.round})
                
                local sat = create("ImageLabel", {
                    Parent = picker,
                    BackgroundColor3 = Color3.fromHSV(h, 1, 1),
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, 10, 0, 10),
                    Size = UDim2.new(0, 100, 0, 100),
                    Image = "rbxassetid://4155801252"
                })
                create("UICorner", {Parent = sat, CornerRadius = cfg.round})
                
                local satCursor = create("Frame", {
                    Parent = sat,
                    BackgroundColor3 = cfg.txt,
                    BorderSizePixel = 0,
                    Position = UDim2.new(s, -5, 1 - v, -5),
                    Size = UDim2.new(0, 10, 0, 10)
                })
                create("UICorner", {Parent = satCursor, CornerRadius = UDim.new(1, 0)})
                create("UIStroke", {Parent = satCursor, Color = Color3.new(0, 0, 0), Thickness = 1})
                
                local hue = create("Frame", {
                    Parent = picker,
                    BackgroundColor3 = Color3.new(1, 1, 1),
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, 120, 0, 10),
                    Size = UDim2.new(0, 20, 0, 100)
                })
                create("UICorner", {Parent = hue, CornerRadius = cfg.round})
                create("UIGradient", {
                    Parent = hue,
                    Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                        ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
                        ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
                        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
                        ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
                        ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
                    }),
                    Rotation = 90
                })
                
                local hueCursor = create("Frame", {
                    Parent = hue,
                    BackgroundColor3 = cfg.txt,
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, -2, h, -3),
                    Size = UDim2.new(1, 4, 0, 6)
                })
                create("UICorner", {Parent = hueCursor, CornerRadius = cfg.round})
                
                local hexBox = create("TextBox", {
                    Parent = picker,
                    BackgroundColor3 = cfg.sec,
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, 150, 0, 10),
                    Size = UDim2.new(1, -160, 0, 25),
                    Font = cfg.font,
                    Text = "#" .. val:ToHex():upper(),
                    TextColor3 = cfg.txt,
                    TextSize = 12
                })
                create("UICorner", {Parent = hexBox, CornerRadius = cfg.round})
                
                local function update()
                    val = Color3.fromHSV(h, s, v)
                    preview.BackgroundColor3 = val
                    sat.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                    satCursor.Position = UDim2.new(s, -5, 1 - v, -5)
                    hueCursor.Position = UDim2.new(0, -2, h, -3)
                    hexBox.Text = "#" .. val:ToHex():upper()
                    if callback then callback(val) end
                end
                
                local draggingSat, draggingHue = false, false
                
                sat.InputBegan:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                        draggingSat = true
                    end
                end)
                
                hue.InputBegan:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                        draggingHue = true
                    end
                end)
                
                input.InputEnded:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                        draggingSat = false
                        draggingHue = false
                    end
                end)
                
                input.InputChanged:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseMovement then
                        if draggingSat then
                            s = math.clamp((inp.Position.X - sat.AbsolutePosition.X) / sat.AbsoluteSize.X, 0, 1)
                            v = 1 - math.clamp((inp.Position.Y - sat.AbsolutePosition.Y) / sat.AbsoluteSize.Y, 0, 1)
                            update()
                        elseif draggingHue then
                            h = math.clamp((inp.Position.Y - hue.AbsolutePosition.Y) / hue.AbsoluteSize.Y, 0, 1)
                            update()
                        end
                    end
                end)
                
                hexBox.FocusLost:Connect(function()
                    local hex = hexBox.Text:gsub("#", "")
                    local ok, col = pcall(function() return Color3.fromHex(hex) end)
                    if ok then
                        val = col
                        h, s, v = val:ToHSV()
                        update()
                    end
                end)
                
                local btn = create("TextButton", {
                    Parent = header,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    Text = ""
                })
                
                btn.MouseButton1Click:Connect(function()
                    open = not open
                    tw(frame, {Size = UDim2.new(1, 0, 0, open and 160 or 28)}, 0.2)
                    task.delay(0.2, updateSize)
                end)
                
                updateSize()
                return {
                    set = function(_, c)
                        val = c
                        h, s, v = c:ToHSV()
                        update()
                    end,
                    get = function() return val end
                }
            end
            
            function section:keybind(name, default, callback)
                local key = default
                local listening = false
                
                local frame = create("Frame", {
                    Parent = holder,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 28)
                })
                
                create("TextLabel", {
                    Parent = frame,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0.6, 0, 1, 0),
                    Font = cfg.font,
                    Text = name,
                    TextColor3 = cfg.txt,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local btn = create("TextButton", {
                    Parent = frame,
                    BackgroundColor3 = cfg.sec,
                    BorderSizePixel = 0,
                    Position = UDim2.new(0.6, 0, 0, 0),
                    Size = UDim2.new(0.4, 0, 1, 0),
                    Font = cfg.font,
                    Text = key and key.Name or "None",
                    TextColor3 = cfg.txt2,
                    TextSize = 12
                })
                create("UICorner", {Parent = btn, CornerRadius = cfg.round})
                
                btn.MouseButton1Click:Connect(function()
                    listening = true
                    btn.Text = "..."
                end)
                
                input.InputBegan:Connect(function(inp, gpe)
                    if listening and inp.UserInputType == Enum.UserInputType.Keyboard then
                        key = inp.KeyCode
                        btn.Text = key.Name
                        listening = false
                    elseif key and inp.KeyCode == key and not gpe then
                        if callback then callback() end
                    end
                end)
                
                updateSize()
                return {
                    set = function(_, k)
                        key = k
                        btn.Text = k and k.Name or "None"
                    end,
                    get = function() return key end
                }
            end
            
            function section:label(text)
                local lbl = create("TextLabel", {
                    Parent = holder,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 20),
                    Font = cfg.font,
                    Text = text,
                    TextColor3 = cfg.txt2,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                updateSize()
                return {
                    set = function(_, t) lbl.Text = t end
                }
            end
            
            return section
        end
        
        return tab
    end
    
    function window:notify(title, text, dur)
        local notif = create("Frame", {
            Parent = gui,
            BackgroundColor3 = cfg.dark,
            BorderSizePixel = 0,
            Position = UDim2.new(1, 10, 0.8, 0),
            Size = UDim2.new(0, 250, 0, 60)
        })
        create("UICorner", {Parent = notif, CornerRadius = cfg.round})
        
        create("TextLabel", {
            Parent = notif,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 10, 0, 5),
            Size = UDim2.new(1, -20, 0, 20),
            Font = cfg.font,
            Text = title,
            TextColor3 = cfg.acc,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        
        create("TextLabel", {
            Parent = notif,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 10, 0, 25),
            Size = UDim2.new(1, -20, 0, 30),
            Font = cfg.font,
            Text = text,
            TextColor3 = cfg.txt2,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true
        })
        
        tw(notif, {Position = UDim2.new(1, -260, 0.8, 0)}, 0.3)
        task.delay(dur or 3, function()
            tw(notif, {Position = UDim2.new(1, 10, 0.8, 0)}, 0.3)
            task.delay(0.3, function() notif:Destroy() end)
        end)
    end
    
    function window:destroy()
        tw(main, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.2)
        task.delay(0.2, function() gui:Destroy() end)
    end
    
    return window
end

return lib
