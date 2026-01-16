local lib = {}
local tween = game:GetService("TweenService")
local input = game:GetService("UserInputService")
local run = game:GetService("RunService")
local lighting = game:GetService("Lighting")
local players = game:GetService("Players")
local player = players.LocalPlayer
local mouse = player:GetMouse()

local env = getgenv and getgenv() or _G
if env.BioLibLoaded then return env.BioLib end
env.BioLibLoaded = true

local theme = {
    bg = Color3.fromRGB(12, 10, 18),
    sidebar = Color3.fromRGB(8, 6, 14),
    card = Color3.fromRGB(18, 15, 28),
    cardHover = Color3.fromRGB(28, 24, 42),
    accent = Color3.fromRGB(138, 90, 255),
    accentDark = Color3.fromRGB(98, 60, 200),
    text = Color3.fromRGB(245, 245, 250),
    textDim = Color3.fromRGB(120, 115, 140),
    textDark = Color3.fromRGB(70, 65, 90),
    border = Color3.fromRGB(40, 35, 60),
    red = Color3.fromRGB(255, 75, 95),
    orange = Color3.fromRGB(255, 160, 60),
    shadow = Color3.fromRGB(0, 0, 0)
}

local function tw(obj, props, dur, style, dir)
    local info = TweenInfo.new(dur or 0.25, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out)
    local t = tween:Create(obj, info, props)
    t:Play()
    return t
end

local function create(class, props)
    local obj = Instance.new(class)
    for k, v in pairs(props) do
        if k ~= "Parent" then obj[k] = v end
    end
    if props.Parent then obj.Parent = props.Parent end
    return obj
end

local function addStroke(parent, col, thick, trans)
    return create("UIStroke", {
        Parent = parent,
        Color = col or theme.border,
        Thickness = thick or 1,
        Transparency = trans or 0.5
    })
end

local function addCorner(parent, rad)
    return create("UICorner", {Parent = parent, CornerRadius = rad or UDim.new(0, 8)})
end

local function addPadding(parent, l, r, t, b)
    return create("UIPadding", {
        Parent = parent,
        PaddingLeft = UDim.new(0, l or 0),
        PaddingRight = UDim.new(0, r or 0),
        PaddingTop = UDim.new(0, t or 0),
        PaddingBottom = UDim.new(0, b or 0)
    })
end

local function addShadow(parent, trans)
    return create("ImageLabel", {
        Parent = parent,
        Name = "Shadow",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, -20, 0, -20),
        Size = UDim2.new(1, 40, 1, 40),
        ZIndex = -1,
        Image = "rbxassetid://6014261993",
        ImageColor3 = theme.shadow,
        ImageTransparency = trans or 0.4,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(49, 49, 450, 450)
    })
end

local function ripple(parent, x, y)
    local abs = parent.AbsoluteSize
    local pos = parent.AbsolutePosition
    local rx, ry = x - pos.X, y - pos.Y
    local maxSize = math.max(abs.X, abs.Y) * 2.5
    
    local rip = create("Frame", {
        Parent = parent,
        Name = "Ripple",
        BackgroundColor3 = Color3.new(1, 1, 1),
        BackgroundTransparency = 0.85,
        BorderSizePixel = 0,
        Position = UDim2.new(0, rx, 0, ry),
        Size = UDim2.new(0, 0, 0, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        ZIndex = 100
    })
    addCorner(rip, UDim.new(1, 0))
    
    tw(rip, {Size = UDim2.new(0, maxSize, 0, maxSize), BackgroundTransparency = 1}, 0.5, Enum.EasingStyle.Quad)
    task.delay(0.5, function() rip:Destroy() end)
end

function lib:init(title, subtitle)
    local gui = create("ScreenGui", {
        Name = "BioLib_" .. tostring(math.random(1000, 9999)),
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset = true
    })
    
    local protected = false
    if syn and syn.protect_gui then
        syn.protect_gui(gui)
        protected = true
    end
    
    if gethui then
        gui.Parent = gethui()
    elseif protected then
        gui.Parent = game:GetService("CoreGui")
    else
        gui.Parent = player:WaitForChild("PlayerGui")
    end
    
    local blur = create("BlurEffect", {
        Parent = lighting,
        Name = "BioLibBlur",
        Size = 0
    })
    tw(blur, {Size = 6}, 0.5)
    
    local main = create("Frame", {
        Parent = gui,
        Name = "Main",
        BackgroundColor3 = theme.bg,
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, 0, 0, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        ClipsDescendants = true
    })
    addCorner(main, UDim.new(0, 12))
    addShadow(main, 0.3)
    addStroke(main, theme.border, 1, 0.7)
    
    tw(main, {Size = UDim2.new(0, 680, 0, 450)}, 0.4, Enum.EasingStyle.Back)
    
    local sidebar = create("Frame", {
        Parent = main,
        Name = "Sidebar",
        BackgroundColor3 = theme.sidebar,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(0, 140, 1, 0),
        ClipsDescendants = true
    })
    addCorner(sidebar, UDim.new(0, 12))
    
    local logo = create("Frame", {
        Parent = sidebar,
        Name = "Logo",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(1, 0, 0, 70)
    })
    
    local logoIcon = create("ImageLabel", {
        Parent = logo,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0.5, -12),
        Size = UDim2.new(0, 24, 0, 24),
        Image = "rbxassetid://7733715400",
        ImageColor3 = theme.accent
    })
    
    local titleLbl = create("TextLabel", {
        Parent = logo,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 45, 0, 14),
        Size = UDim2.new(1, -50, 0, 22),
        Font = Enum.Font.GothamBlack,
        Text = title or "BioHazard",
        TextColor3 = theme.text,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    local subLbl = create("TextLabel", {
        Parent = logo,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 45, 0, 36),
        Size = UDim2.new(1, -50, 0, 16),
        Font = Enum.Font.GothamMedium,
        Text = subtitle or "Sneak Peek",
        TextColor3 = theme.textDim,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    local divider = create("Frame", {
        Parent = sidebar,
        BackgroundColor3 = theme.border,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        Position = UDim2.new(0.1, 0, 0, 70),
        Size = UDim2.new(0.8, 0, 0, 1)
    })
    
    local tabScroll = create("ScrollingFrame", {
        Parent = sidebar,
        Name = "Tabs",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 80),
        Size = UDim2.new(1, 0, 1, -80),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 0,
        ScrollingDirection = Enum.ScrollingDirection.Y
    })
    addPadding(tabScroll, 10, 10, 5, 5)
    
    local tabList = create("UIListLayout", {
        Parent = tabScroll,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 4)
    })
    
    local content = create("Frame", {
        Parent = main,
        Name = "Content",
        BackgroundColor3 = theme.bg,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 140, 0, 0),
        Size = UDim2.new(1, -140, 1, 0),
        ClipsDescendants = true
    })
    addCorner(content, UDim.new(0, 12))
    
    local topbar = create("Frame", {
        Parent = content,
        Name = "Topbar",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(1, 0, 0, 55)
    })
    
    local searchBox = create("Frame", {
        Parent = topbar,
        Name = "Search",
        BackgroundColor3 = theme.card,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 15, 0.5, -17),
        Size = UDim2.new(0.55, -30, 0, 34)
    })
    addCorner(searchBox, UDim.new(0, 8))
    addStroke(searchBox, theme.border, 1, 0.7)
    
    local searchIcon = create("ImageLabel", {
        Parent = searchBox,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 12, 0.5, -8),
        Size = UDim2.new(0, 16, 0, 16),
        Image = "rbxassetid://7072706663",
        ImageColor3 = theme.textDim
    })
    
    local searchInput = create("TextBox", {
        Parent = searchBox,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 36, 0, 0),
        Size = UDim2.new(1, -48, 1, 0),
        Font = Enum.Font.Gotham,
        PlaceholderText = "Search for a module...",
        PlaceholderColor3 = theme.textDark,
        Text = "",
        TextColor3 = theme.text,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    searchInput.Focused:Connect(function()
        tw(searchBox:FindFirstChild("UIStroke"), {Color = theme.accent, Transparency = 0.3}, 0.2)
    end)
    searchInput.FocusLost:Connect(function()
        tw(searchBox:FindFirstChild("UIStroke"), {Color = theme.border, Transparency = 0.7}, 0.2)
    end)
    
    local allElements = {}
    
    searchInput:GetPropertyChangedSignal("Text"):Connect(function()
        local q = searchInput.Text:lower()
        for _, el in pairs(allElements) do
            local match = q == "" or el.name:lower():find(q, 1, true)
            el.frame.Visible = match
        end
    end)
    
    local btnHolder = create("Frame", {
        Parent = topbar,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -80, 0.5, -15),
        Size = UDim2.new(0, 70, 0, 30)
    })
    
    local minimizeBtn = create("TextButton", {
        Parent = btnHolder,
        BackgroundColor3 = theme.card,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0.5, -15),
        Size = UDim2.new(0, 30, 0, 30),
        Text = "",
        AutoButtonColor = false
    })
    addCorner(minimizeBtn, UDim.new(0, 8))
    
    local minIcon = create("Frame", {
        Parent = minimizeBtn,
        BackgroundColor3 = theme.orange,
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, -6, 0.5, -1),
        Size = UDim2.new(0, 12, 0, 2)
    })
    addCorner(minIcon, UDim.new(1, 0))
    
    minimizeBtn.MouseEnter:Connect(function()
        tw(minimizeBtn, {BackgroundColor3 = theme.cardHover}, 0.15)
        tw(minIcon, {BackgroundColor3 = theme.text}, 0.15)
    end)
    minimizeBtn.MouseLeave:Connect(function()
        tw(minimizeBtn, {BackgroundColor3 = theme.card}, 0.15)
        tw(minIcon, {BackgroundColor3 = theme.orange}, 0.15)
    end)
    
    local closeBtn = create("TextButton", {
        Parent = btnHolder,
        BackgroundColor3 = theme.card,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 40, 0, 0),
        Size = UDim2.new(0, 30, 0, 30),
        Text = "",
        AutoButtonColor = false
    })
    addCorner(closeBtn, UDim.new(0, 8))
    
    local closeIcon = create("TextLabel", {
        Parent = closeBtn,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = "×",
        TextColor3 = theme.red,
        TextSize = 20
    })
    
    closeBtn.MouseEnter:Connect(function()
        tw(closeBtn, {BackgroundColor3 = theme.red}, 0.15)
        tw(closeIcon, {TextColor3 = theme.text}, 0.15)
    end)
    closeBtn.MouseLeave:Connect(function()
        tw(closeBtn, {BackgroundColor3 = theme.card}, 0.15)
        tw(closeIcon, {TextColor3 = theme.red}, 0.15)
    end)
    
    local pages = create("Frame", {
        Parent = content,
        Name = "Pages",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 55),
        Size = UDim2.new(1, 0, 1, -55),
        ClipsDescendants = true
    })
    
    local resizeHandle = create("TextButton", {
        Parent = main,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -20, 1, -20),
        Size = UDim2.new(0, 20, 0, 20),
        Text = "",
        AutoButtonColor = false,
        ZIndex = 10
    })
    
    local resizeDots = create("Frame", {
        Parent = resizeHandle,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0)
    })
    
    for i = 1, 3 do
        for j = 1, 3 do
            if i + j >= 4 then
                create("Frame", {
                    Parent = resizeDots,
                    BackgroundColor3 = theme.textDark,
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, (i-1)*6 + 2, 0, (j-1)*6 + 2),
                    Size = UDim2.new(0, 3, 0, 3)
                })
            end
        end
    end
    
    local resizing, resizeStart, startSize = false, nil, nil
    
    resizeHandle.MouseEnter:Connect(function()
        for _, dot in pairs(resizeDots:GetChildren()) do
            tw(dot, {BackgroundColor3 = theme.accent}, 0.15)
        end
    end)
    resizeHandle.MouseLeave:Connect(function()
        if not resizing then
            for _, dot in pairs(resizeDots:GetChildren()) do
                tw(dot, {BackgroundColor3 = theme.textDark}, 0.15)
            end
        end
    end)
    
    resizeHandle.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 and not minimized then
            resizing = true
            resizeStart = inp.Position
            startSize = main.Size
        end
    end)
    
    input.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 and resizing then
            resizing = false
            for _, dot in pairs(resizeDots:GetChildren()) do
                tw(dot, {BackgroundColor3 = theme.textDark}, 0.15)
            end
        end
    end)
    
    input.InputChanged:Connect(function(inp)
        if resizing and inp.UserInputType == Enum.UserInputType.MouseMovement and not minimized then
            local delta = inp.Position - resizeStart
            local newW = math.clamp(startSize.X.Offset + delta.X, 500, 1000)
            local newH = math.clamp(startSize.Y.Offset + delta.Y, 300, 700)
            main.Size = UDim2.new(0, newW, 0, newH)
        end
    end)
    
    local dragging, dragStart, startPos
    local canDrag = true
    
    topbar.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 and canDrag then
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
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    local minimized = false
    minimizeBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        canDrag = not minimized
        if minimized then
            tw(content, {Size = UDim2.new(1, -140, 0, 55)}, 0.3, Enum.EasingStyle.Quart)
            tw(main, {Size = UDim2.new(0, 680, 0, 55)}, 0.3, Enum.EasingStyle.Quart)
            tw(blur, {Size = 0}, 0.25)
        else
            tw(content, {Size = UDim2.new(1, -140, 1, 0)}, 0.3, Enum.EasingStyle.Quart)
            tw(main, {Size = UDim2.new(0, 680, 0, 450)}, 0.3, Enum.EasingStyle.Quart)
            tw(blur, {Size = 6}, 0.25)
        end
    end)
    
    closeBtn.MouseButton1Click:Connect(function()
        visible = false
        tw(blur, {Size = 0}, 0.3)
        tw(main, {Size = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        task.delay(0.35, function()
            main.Visible = false
            gui.Enabled = false
            openBtn.Visible = true
        end)
    end)
    
    local openBtn = create("TextButton", {
        Parent = gui,
        Name = "OpenButton",
        BackgroundColor3 = theme.accent,
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, -30, 0, 10),
        Size = UDim2.new(0, 60, 0, 40),
        Text = "",
        AutoButtonColor = false,
        Visible = false,
        ZIndex = 1000
    })
    addCorner(openBtn, UDim.new(0, 10))
    addShadow(openBtn, 0.5)
    
    local openIcon = create("TextLabel", {
        Parent = openBtn,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Font = Enum.Font.GothamBlack,
        Text = "☰",
        TextColor3 = theme.text,
        TextSize = 24
    })
    
    openBtn.MouseEnter:Connect(function()
        tw(openBtn, {BackgroundTransparency = 0.1}, 0.2)
    end)
    openBtn.MouseLeave:Connect(function()
        tw(openBtn, {BackgroundTransparency = 0.3}, 0.2)
    end)
    
    openBtn.MouseButton1Click:Connect(function()
        visible = true
        openBtn.Visible = false
        gui.Enabled = true
        main.Visible = true
        main.Size = UDim2.new(0, 0, 0, 0)
        tw(main, {Size = UDim2.new(0, 680, 0, 450)}, 0.4, Enum.EasingStyle.Back)
        tw(blur, {Size = 6}, 0.4)
    end)
    
    local visible = true
    local toggleKey = Enum.KeyCode.Insert
    local toggleCooldown = false
    
    input.InputBegan:Connect(function(key, gpe)
        if gpe then return end
        if key.KeyCode == toggleKey and not toggleCooldown then
            toggleCooldown = true
            task.delay(0.5, function() toggleCooldown = false end)
            visible = not visible
            if visible then
                openBtn.Visible = false
                gui.Enabled = true
                main.Visible = true
                main.Size = UDim2.new(0, 0, 0, 0)
                tw(main, {Size = UDim2.new(0, 680, 0, 450)}, 0.4, Enum.EasingStyle.Back)
                tw(blur, {Size = 6}, 0.4)
            else
                tw(blur, {Size = 0}, 0.3)
                tw(main, {Size = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
                task.delay(0.35, function()
                    main.Visible = false
                    gui.Enabled = false
                    openBtn.Visible = true
                end)
            end
        end
    end)
    
    local cfgData = {}
    local elements = {}
    local autoSave = false
    local autoSaveName = "autosave"
    
    local function saveElement(key, value)
        cfgData[key] = value
        if autoSave then
            task.delay(0.5, function()
                window:saveConfig(autoSaveName)
            end)
        end
    end
    
    local window = {
        gui = gui, 
        main = main,
        openBtn = openBtn,
        tabs = {}, 
        activeTab = nil,
        cfgFolder = "configs",
        cfgData = cfgData,
        elements = elements
    }
    
    function window:tab(name)
        local tabBtn = create("TextButton", {
            Parent = tabScroll,
            Name = name,
            BackgroundColor3 = theme.card,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, 36),
            Text = "",
            AutoButtonColor = false
        })
        addCorner(tabBtn, UDim.new(0, 8))
        
        local indicator = create("Frame", {
            Parent = tabBtn,
            Name = "Indicator",
            BackgroundColor3 = theme.accent,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 0.15, 0),
            Size = UDim2.new(0, 3, 0.7, 0),
            BackgroundTransparency = 1
        })
        addCorner(indicator, UDim.new(1, 0))
        
        local tabLbl = create("TextLabel", {
            Parent = tabBtn,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 14, 0, 0),
            Size = UDim2.new(1, -20, 1, 0),
            Font = Enum.Font.GothamBold,
            Text = name,
            TextColor3 = theme.textDim,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        
        local page = create("ScrollingFrame", {
            Parent = pages,
            Name = name,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 0, 0),
            Size = UDim2.new(1, 0, 1, 0),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = theme.accent,
            ScrollBarImageTransparency = 0.5,
            Visible = false,
            ClipsDescendants = true
        })
        addPadding(page, 15, 15, 10, 10)
        
        local pageList = create("UIListLayout", {
            Parent = page,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 12)
        })
        
        local function updateCanvas()
            page.CanvasSize = UDim2.new(0, 0, 0, pageList.AbsoluteContentSize.Y + 25)
        end
        pageList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)
        
        local function activate()
            for _, t in pairs(window.tabs) do
                tw(t.btn, {BackgroundTransparency = 1}, 0.2)
                tw(t.btn.Indicator, {BackgroundTransparency = 1}, 0.2)
                tw(t.btn:FindFirstChild("TextLabel"), {TextColor3 = theme.textDim}, 0.2)
                t.page.Visible = false
            end
            tw(tabBtn, {BackgroundTransparency = 0.9}, 0.2)
            tw(indicator, {BackgroundTransparency = 0}, 0.2)
            tw(tabLbl, {TextColor3 = theme.text}, 0.2)
            page.Visible = true
            window.activeTab = name
        end
        
        tabBtn.MouseEnter:Connect(function()
            if window.activeTab ~= name then
                tw(tabBtn, {BackgroundTransparency = 0.95}, 0.15)
            end
        end)
        tabBtn.MouseLeave:Connect(function()
            if window.activeTab ~= name then
                tw(tabBtn, {BackgroundTransparency = 1}, 0.15)
            end
        end)
        tabBtn.MouseButton1Click:Connect(function()
            ripple(tabBtn, mouse.X, mouse.Y)
            activate()
        end)
        
        window.tabs[name] = {btn = tabBtn, page = page}
        
        if not window.activeTab then
            task.delay(0.1, activate)
        end
        
        tabList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tabScroll.CanvasSize = UDim2.new(0, 0, 0, tabList.AbsoluteContentSize.Y + 15)
        end)
        
        local tab = {}
        
        function tab:section(name)
            local sec = create("Frame", {
                Parent = page,
                Name = name,
                BackgroundColor3 = theme.card,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 45),
                ClipsDescendants = true
            })
            addCorner(sec, UDim.new(0, 10))
            addStroke(sec, theme.border, 1, 0.8)
            
            local header = create("Frame", {
                Parent = sec,
                Name = "Header",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 45)
            })
            
            local secTitle = create("TextLabel", {
                Parent = header,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 15, 0, 0),
                Size = UDim2.new(0.7, 0, 1, 0),
                Font = Enum.Font.GothamBlack,
                Text = name,
                TextColor3 = theme.text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local expandBtn = create("TextButton", {
                Parent = header,
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -35, 0, 0),
                Size = UDim2.new(0, 35, 1, 0),
                Text = "",
                AutoButtonColor = false
            })
            
            local expandIcon = create("ImageLabel", {
                Parent = expandBtn,
                BackgroundTransparency = 1,
                Position = UDim2.new(0.5, -6, 0.5, -6),
                Size = UDim2.new(0, 12, 0, 12),
                Image = "rbxassetid://6031091004",
                ImageColor3 = theme.textDim,
                Rotation = 0
            })
            
            local holder = create("Frame", {
                Parent = sec,
                Name = "Holder",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 15, 0, 50),
                Size = UDim2.new(1, -30, 0, 0)
            })
            
            local holderList = create("UIListLayout", {
                Parent = holder,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 10)
            })
            
            local expanded = true
            
            local function updateSecSize()
                local h = expanded and (holderList.AbsoluteContentSize.Y + 65) or 45
                tw(sec, {Size = UDim2.new(1, 0, 0, h)}, 0.25, Enum.EasingStyle.Quart)
                tw(expandIcon, {Rotation = expanded and 180 or 0}, 0.25)
                task.delay(0.25, updateCanvas)
            end
            
            holderList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                if expanded then updateSecSize() end
            end)
            
            expandBtn.MouseButton1Click:Connect(function()
                expanded = not expanded
                updateSecSize()
            end)
            
            updateSecSize()
            
            local section = {}
            
            function section:button(name, callback)
                local btn = create("TextButton", {
                    Parent = holder,
                    Name = name,
                    BackgroundColor3 = theme.bg,
                    BorderSizePixel = 0,
                    Size = UDim2.new(1, 0, 0, 38),
                    Text = "",
                    AutoButtonColor = false,
                    ClipsDescendants = true
                })
                addCorner(btn, UDim.new(0, 8))
                addStroke(btn, theme.border, 1, 0.8)
                
                local btnLbl = create("TextLabel", {
                    Parent = btn,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    Font = Enum.Font.GothamBlack,
                    Text = name,
                    TextColor3 = theme.text,
                    TextSize = 13
                })
                
                btn.MouseEnter:Connect(function()
                    tw(btn, {BackgroundColor3 = theme.accent}, 0.2)
                    tw(btn:FindFirstChild("UIStroke"), {Transparency = 1}, 0.2)
                end)
                btn.MouseLeave:Connect(function()
                    tw(btn, {BackgroundColor3 = theme.bg}, 0.2)
                    tw(btn:FindFirstChild("UIStroke"), {Transparency = 0.8}, 0.2)
                end)
                btn.MouseButton1Click:Connect(function()
                    ripple(btn, mouse.X, mouse.Y)
                    if callback then callback() end
                end)
                
                table.insert(allElements, {name = name, frame = btn})
                updateSecSize()
                return btn
            end
            
            function section:toggle(name, default, callback)
                local val = default or false
                
                local frame = create("Frame", {
                    Parent = holder,
                    Name = name,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 32)
                })
                
                local lbl = create("TextLabel", {
                    Parent = frame,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 0),
                    Size = UDim2.new(0.7, 0, 1, 0),
                    Font = Enum.Font.GothamBold,
                    Text = name,
                    TextColor3 = theme.text,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local box = create("Frame", {
                    Parent = frame,
                    BackgroundColor3 = val and theme.accent or theme.bg,
                    BorderSizePixel = 0,
                    Position = UDim2.new(1, -48, 0.5, -12),
                    Size = UDim2.new(0, 48, 0, 24)
                })
                addCorner(box, UDim.new(1, 0))
                addStroke(box, val and theme.accent or theme.border, 1, val and 0 or 0.6)
                
                local dot = create("Frame", {
                    Parent = box,
                    BackgroundColor3 = theme.text,
                    BorderSizePixel = 0,
                    Position = val and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10),
                    Size = UDim2.new(0, 20, 0, 20)
                })
                addCorner(dot, UDim.new(1, 0))
                
                local btn = create("TextButton", {
                    Parent = frame,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    Text = ""
                })
                
                local function update()
                    tw(box, {BackgroundColor3 = val and theme.accent or theme.bg}, 0.2)
                    tw(box:FindFirstChild("UIStroke"), {Color = val and theme.accent or theme.border, Transparency = val and 0 or 0.6}, 0.2)
                    tw(dot, {Position = val and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)}, 0.2, Enum.EasingStyle.Back)
                end
                
                btn.MouseButton1Click:Connect(function()
                    val = not val
                    update()
                    saveElement(name, val)
                    if callback then callback(val) end
                end)
                
                table.insert(allElements, {name = name, frame = frame})
                updateSecSize()
                elements[name] = {
                    set = function(_, v) val = v update() end,
                    get = function() return val end
                }
                return elements[name]
            end
            
            function section:slider(name, min, max, default, callback)
                local val = default or min
                
                local frame = create("Frame", {
                    Parent = holder,
                    Name = name,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 50)
                })
                
                local top = create("Frame", {
                    Parent = frame,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 20)
                })
                
                local lbl = create("TextLabel", {
                    Parent = top,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0.5, 0, 1, 0),
                    Font = Enum.Font.GothamBold,
                    Text = name,
                    TextColor3 = theme.text,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local valLbl = create("TextLabel", {
                    Parent = top,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 0, 0, 0),
                    Size = UDim2.new(0.5, 0, 1, 0),
                    Font = Enum.Font.GothamBold,
                    Text = tostring(math.floor(val)),
                    TextColor3 = theme.accent,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Right
                })
                
                local bar = create("Frame", {
                    Parent = frame,
                    BackgroundColor3 = theme.bg,
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, 0, 0, 28),
                    Size = UDim2.new(1, 0, 0, 8)
                })
                addCorner(bar, UDim.new(1, 0))
                
                local fill = create("Frame", {
                    Parent = bar,
                    BackgroundColor3 = theme.accent,
                    BorderSizePixel = 0,
                    Size = UDim2.new((val - min) / (max - min), 0, 1, 0)
                })
                addCorner(fill, UDim.new(1, 0))
                
                local fillGlow = create("Frame", {
                    Parent = fill,
                    BackgroundColor3 = theme.accent,
                    BackgroundTransparency = 0.7,
                    BorderSizePixel = 0,
                    Position = UDim2.new(1, -6, 0.5, -8),
                    Size = UDim2.new(0, 16, 0, 16),
                    AnchorPoint = Vector2.new(0.5, 0)
                })
                addCorner(fillGlow, UDim.new(1, 0))
                
                local knob = create("Frame", {
                    Parent = fill,
                    BackgroundColor3 = theme.text,
                    BorderSizePixel = 0,
                    Position = UDim2.new(1, -6, 0.5, -6),
                    Size = UDim2.new(0, 12, 0, 12),
                    AnchorPoint = Vector2.new(0.5, 0)
                })
                addCorner(knob, UDim.new(1, 0))
                
                local minLbl = create("TextLabel", {
                    Parent = frame,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 38),
                    Size = UDim2.new(0.3, 0, 0, 14),
                    Font = Enum.Font.Gotham,
                    Text = tostring(min),
                    TextColor3 = theme.textDark,
                    TextSize = 11,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local maxLbl = create("TextLabel", {
                    Parent = frame,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.7, 0, 0, 38),
                    Size = UDim2.new(0.3, 0, 0, 14),
                    Font = Enum.Font.Gotham,
                    Text = tostring(max),
                    TextColor3 = theme.textDark,
                    TextSize = 11,
                    TextXAlignment = Enum.TextXAlignment.Right
                })
                
                local sliding = false
                
                bar.InputBegan:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                        sliding = true
                        tw(knob, {Size = UDim2.new(0, 16, 0, 16), Position = UDim2.new(1, -8, 0.5, -8)}, 0.15)
                        tw(fillGlow, {BackgroundTransparency = 0.5}, 0.15)
                    end
                end)
                
                input.InputEnded:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                        sliding = false
                        tw(knob, {Size = UDim2.new(0, 12, 0, 12), Position = UDim2.new(1, -6, 0.5, -6)}, 0.15)
                        tw(fillGlow, {BackgroundTransparency = 0.7}, 0.15)
                    end
                end)
                
                input.InputChanged:Connect(function(inp)
                    if sliding and inp.UserInputType == Enum.UserInputType.MouseMovement then
                        local pct = math.clamp((inp.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
                        val = math.floor(min + (max - min) * pct)
                        fill.Size = UDim2.new(pct, 0, 1, 0)
                        valLbl.Text = tostring(val)
                        saveElement(name, val)
                        if callback then callback(val) end
                    end
                end)
                
                table.insert(allElements, {name = name, frame = frame})
                updateSecSize()
                elements[name] = {
                    set = function(_, v)
                        val = math.clamp(v, min, max)
                        local pct = (val - min) / (max - min)
                        fill.Size = UDim2.new(pct, 0, 1, 0)
                        valLbl.Text = tostring(math.floor(val))
                    end,
                    get = function() return val end
                }
                return elements[name]
            end
            
            function section:input(name, default, callback)
                local frame = create("Frame", {
                    Parent = holder,
                    Name = name,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 32)
                })
                
                local lbl = create("TextLabel", {
                    Parent = frame,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0.3, 0, 1, 0),
                    Font = Enum.Font.GothamBold,
                    Text = name,
                    TextColor3 = theme.text,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local box = create("Frame", {
                    Parent = frame,
                    BackgroundColor3 = theme.bg,
                    BorderSizePixel = 0,
                    Position = UDim2.new(0.32, 0, 0, 0),
                    Size = UDim2.new(0.68, 0, 1, 0)
                })
                addCorner(box, UDim.new(0, 6))
                addStroke(box, theme.border, 1, 0.7)
                
                local inp = create("TextBox", {
                    Parent = box,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 12, 0, 0),
                    Size = UDim2.new(1, -24, 1, 0),
                    Font = Enum.Font.Gotham,
                    Text = default or "",
                    TextColor3 = theme.text,
                    TextSize = 12,
                    ClearTextOnFocus = false,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                inp.Focused:Connect(function()
                    tw(box:FindFirstChild("UIStroke"), {Color = theme.accent, Transparency = 0.3}, 0.2)
                end)
                inp.FocusLost:Connect(function()
                    tw(box:FindFirstChild("UIStroke"), {Color = theme.border, Transparency = 0.7}, 0.2)
                    if callback then callback(inp.Text) end
                end)
                
                table.insert(allElements, {name = name, frame = frame})
                updateSecSize()
                return {
                    set = function(_, v) inp.Text = v end,
                    get = function() return inp.Text end
                }
            end
            
            function section:dropdown(name, opts, default, callback, multi)
                local val = default
                local open = false
                local selected = multi and {} or nil
                
                local frame = create("Frame", {
                    Parent = holder,
                    Name = name,
                    BackgroundColor3 = theme.bg,
                    BorderSizePixel = 0,
                    Size = UDim2.new(1, 0, 0, 36),
                    ClipsDescendants = true
                })
                addCorner(frame, UDim.new(0, 8))
                addStroke(frame, theme.border, 1, 0.7)
                
                local header = create("TextButton", {
                    Parent = frame,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 36),
                    Text = "",
                    AutoButtonColor = false
                })
                
                local lbl = create("TextLabel", {
                    Parent = header,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 12, 0, 0),
                    Size = UDim2.new(0.4, 0, 1, 0),
                    Font = Enum.Font.GothamBold,
                    Text = name,
                    TextColor3 = theme.text,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local valLbl = create("TextLabel", {
                    Parent = header,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.4, 0, 0, 0),
                    Size = UDim2.new(0.5, -20, 1, 0),
                    Font = Enum.Font.GothamMedium,
                    Text = val or "Select...",
                    TextColor3 = (multi and default) and theme.accent or theme.textDim,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Right
                })
                
                local arrow = create("ImageLabel", {
                    Parent = header,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, -28, 0.5, -6),
                    Size = UDim2.new(0, 12, 0, 12),
                    Image = "rbxassetid://6031091004",
                    ImageColor3 = theme.textDim,
                    Rotation = 0
                })
                
                local optHolder = create("Frame", {
                    Parent = frame,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 8, 0, 40),
                    Size = UDim2.new(1, -16, 0, #opts * 30)
                })
                
                local optList = create("UIListLayout", {
                    Parent = optHolder,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Padding = UDim.new(0, 2)
                })
                
                for i, opt in ipairs(opts) do
                    local optBtn = create("TextButton", {
                        Parent = optHolder,
                        BackgroundColor3 = theme.card,
                        BackgroundTransparency = 1,
                        BorderSizePixel = 0,
                        Size = UDim2.new(1, 0, 0, 28),
                        Font = Enum.Font.Gotham,
                        Text = opt,
                        TextColor3 = theme.textDim,
                        TextSize = 12,
                        AutoButtonColor = false
                    })
                    addCorner(optBtn, UDim.new(0, 6))
                    
                    local function updateOptColor()
                        local isSelected = false
                        if multi then
                            isSelected = selected and selected[opt]
                        else
                            isSelected = val == opt
                        end
                        if isSelected then
                            optBtn.BackgroundTransparency = 0
                            optBtn.BackgroundColor3 = theme.accent
                            optBtn.TextColor3 = theme.text
                        end
                    end
                    
                    updateOptColor()
                    
                    optBtn.MouseEnter:Connect(function()
                        if not ((multi and selected and selected[opt]) or (not multi and val == opt)) then
                            tw(optBtn, {BackgroundTransparency = 0, BackgroundColor3 = theme.card, TextColor3 = theme.text}, 0.15)
                        end
                    end)
                    optBtn.MouseLeave:Connect(function()
                        local isSelected = (multi and selected and selected[opt]) or (not multi and val == opt)
                        if isSelected then
                            tw(optBtn, {BackgroundTransparency = 0, BackgroundColor3 = theme.accent, TextColor3 = theme.text}, 0.15)
                        else
                            tw(optBtn, {BackgroundTransparency = 1, TextColor3 = theme.textDim}, 0.15)
                        end
                    end)
                    optBtn.MouseButton1Click:Connect(function()
                        if multi then
                            if not selected then selected = {} end
                            selected[opt] = not selected[opt]
                            local list = {}
                            for k, v in pairs(selected) do
                                if v then table.insert(list, k) end
                            end
                            valLbl.Text = #list > 0 and table.concat(list, ", ") or "Select..."
                            valLbl.TextColor3 = #list > 0 and theme.accent or theme.textDim
                            for _, child in pairs(optHolder:GetChildren()) do
                                if child:IsA("TextButton") then
                                    local isSelected = selected[child.Text]
                                    if isSelected then
                                        tw(child, {BackgroundTransparency = 0, BackgroundColor3 = theme.accent, TextColor3 = theme.text}, 0.15)
                                    else
                                        tw(child, {BackgroundTransparency = 1, TextColor3 = theme.textDim}, 0.15)
                                    end
                                end
                            end
                            if callback then callback(list) end
                        else
                            val = opt
                            valLbl.Text = opt
                            valLbl.TextColor3 = theme.accent
                            for _, child in pairs(optHolder:GetChildren()) do
                                if child:IsA("TextButton") then
                                    if child.Text == val then
                                        tw(child, {BackgroundTransparency = 0, BackgroundColor3 = theme.accent, TextColor3 = theme.text}, 0.15)
                                    else
                                        tw(child, {BackgroundTransparency = 1, TextColor3 = theme.textDim}, 0.15)
                                    end
                                end
                            end
                            open = false
                            tw(frame, {Size = UDim2.new(1, 0, 0, 36)}, 0.2, Enum.EasingStyle.Quart)
                            tw(arrow, {Rotation = 0}, 0.2)
                            task.delay(0.2, updateSecSize)
                            if callback then callback(val) end
                        end
                    end)
                end
                
                header.MouseButton1Click:Connect(function()
                    open = not open
                    local h = open and (44 + #opts * 30) or 36
                    tw(frame, {Size = UDim2.new(1, 0, 0, h)}, 0.2, Enum.EasingStyle.Quart)
                    tw(arrow, {Rotation = open and 180 or 0}, 0.2)
                    task.delay(0.2, updateSecSize)
                end)
                
                table.insert(allElements, {name = name, frame = frame})
                updateSecSize()
                return {
                    set = function(_, v) val = v valLbl.Text = v end,
                    get = function() return val end
                }
            end
            
            function section:colorpicker(name, default, callback)
                local val = default or Color3.new(1, 1, 1)
                local open = false
                local h, s, v = val:ToHSV()
                
                local frame = create("Frame", {
                    Parent = holder,
                    Name = name,
                    BackgroundColor3 = theme.bg,
                    BorderSizePixel = 0,
                    Size = UDim2.new(1, 0, 0, 36),
                    ClipsDescendants = true
                })
                addCorner(frame, UDim.new(0, 8))
                addStroke(frame, theme.border, 1, 0.7)
                
                local header = create("TextButton", {
                    Parent = frame,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 36),
                    Text = "",
                    AutoButtonColor = false
                })
                
                local lbl = create("TextLabel", {
                    Parent = header,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 12, 0, 0),
                    Size = UDim2.new(0.5, 0, 1, 0),
                    Font = Enum.Font.GothamBold,
                    Text = name,
                    TextColor3 = theme.text,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local preview = create("Frame", {
                    Parent = header,
                    BackgroundColor3 = val,
                    BorderSizePixel = 0,
                    Position = UDim2.new(1, -80, 0.5, -10),
                    Size = UDim2.new(0, 60, 0, 20)
                })
                addCorner(preview, UDim.new(0, 4))
                addStroke(preview, theme.border, 1, 0.5)
                
                local hexLbl = create("TextLabel", {
                    Parent = preview,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    Font = Enum.Font.GothamBold,
                    Text = "#" .. val:ToHex():upper(),
                    TextColor3 = theme.text,
                    TextSize = 10
                })
                
                local picker = create("Frame", {
                    Parent = frame,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10, 0, 42),
                    Size = UDim2.new(1, -20, 0, 130),
                    Visible = false
                })
                
                local sat = create("ImageLabel", {
                    Parent = picker,
                    BackgroundColor3 = Color3.fromHSV(h, 1, 1),
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, 0, 0, 0),
                    Size = UDim2.new(0, 130, 0, 100),
                    Image = "rbxassetid://4155801252"
                })
                addCorner(sat, UDim.new(0, 6))
                
                local satCursor = create("Frame", {
                    Parent = sat,
                    BackgroundColor3 = theme.text,
                    BorderSizePixel = 0,
                    Position = UDim2.new(s, -7, 1 - v, -7),
                    Size = UDim2.new(0, 14, 0, 14),
                    Visible = false
                })
                addCorner(satCursor, UDim.new(1, 0))
                addStroke(satCursor, theme.shadow, 2, 0)
                
                local hueBar = create("Frame", {
                    Parent = picker,
                    BackgroundColor3 = Color3.new(1, 1, 1),
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, 140, 0, 0),
                    Size = UDim2.new(0, 20, 0, 100)
                })
                addCorner(hueBar, UDim.new(0, 6))
                
                create("UIGradient", {
                    Parent = hueBar,
                    Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                        ColorSequenceKeypoint.new(0.167, Color3.fromRGB(255, 255, 0)),
                        ColorSequenceKeypoint.new(0.333, Color3.fromRGB(0, 255, 0)),
                        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
                        ColorSequenceKeypoint.new(0.667, Color3.fromRGB(0, 0, 255)),
                        ColorSequenceKeypoint.new(0.833, Color3.fromRGB(255, 0, 255)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
                    }),
                    Rotation = 90
                })
                
                local hueCursor = create("Frame", {
                    Parent = hueBar,
                    BackgroundColor3 = theme.text,
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, -3, h, -4),
                    Size = UDim2.new(1, 6, 0, 8)
                })
                addCorner(hueCursor, UDim.new(0, 4))
                
                local hexBox = create("TextBox", {
                    Parent = picker,
                    BackgroundColor3 = theme.card,
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, 170, 0, 0),
                    Size = UDim2.new(1, -170, 0, 30),
                    Font = Enum.Font.GothamMedium,
                    Text = "#" .. val:ToHex():upper(),
                    TextColor3 = theme.text,
                    TextSize = 12,
                    ClearTextOnFocus = false
                })
                addCorner(hexBox, UDim.new(0, 6))
                
                local rgbHolder = create("Frame", {
                    Parent = picker,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 170, 0, 38),
                    Size = UDim2.new(1, -170, 0, 60)
                })
                
                local r, g, b = math.floor(val.R * 255), math.floor(val.G * 255), math.floor(val.B * 255)
                
                local function createRgbInput(name, value, yPos)
                    local row = create("Frame", {
                        Parent = rgbHolder,
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 0, 0, yPos),
                        Size = UDim2.new(1, 0, 0, 18)
                    })
                    
                    create("TextLabel", {
                        Parent = row,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(0, 25, 1, 0),
                        Font = Enum.Font.GothamBold,
                        Text = name,
                        TextColor3 = theme.textDim,
                        TextSize = 11,
                        TextXAlignment = Enum.TextXAlignment.Left
                    })
                    
                    local rowBox = create("TextBox", {
                        Parent = row,
                        BackgroundColor3 = theme.card,
                        BorderSizePixel = 0,
                        Position = UDim2.new(0, 30, 0, 0),
                        Size = UDim2.new(1, -30, 1, 0),
                        Font = Enum.Font.Gotham,
                        Text = tostring(value),
                        TextColor3 = theme.text,
                        TextSize = 11,
                        ClearTextOnFocus = false
                    })
                    addCorner(rowBox, UDim.new(0, 4))
                    
                    return rowBox
                end
                
                local rBox = createRgbInput("R:", r, 0)
                local gBox = createRgbInput("G:", g, 21)
                local bBox = createRgbInput("B:", b, 42)
                
                local function updateColor()
                    val = Color3.fromHSV(h, s, v)
                    preview.BackgroundColor3 = val
                    sat.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                    satCursor.Position = UDim2.new(s, -7, 1 - v, -7)
                    hueCursor.Position = UDim2.new(0, -3, h, -4)
                    hexLbl.Text = "#" .. val:ToHex():upper()
                    hexBox.Text = "#" .. val:ToHex():upper()
                    rBox.Text = tostring(math.floor(val.R * 255))
                    gBox.Text = tostring(math.floor(val.G * 255))
                    bBox.Text = tostring(math.floor(val.B * 255))
                    if callback then callback(val) end
                end
                
                local draggingSat, draggingHue = false, false
                
                sat.InputBegan:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                        draggingSat = true
                    end
                end)
                
                hueBar.InputBegan:Connect(function(inp)
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
                            updateColor()
                        elseif draggingHue then
                            h = math.clamp((inp.Position.Y - hueBar.AbsolutePosition.Y) / hueBar.AbsoluteSize.Y, 0, 1)
                            updateColor()
                        end
                    end
                end)
                
                hexBox.FocusLost:Connect(function()
                    local hex = hexBox.Text:gsub("#", "")
                    local ok, col = pcall(function() return Color3.fromHex(hex) end)
                    if ok then
                        val = col
                        h, s, v = val:ToHSV()
                        updateColor()
                    end
                end)
                
                header.MouseButton1Click:Connect(function()
                    open = not open
                    picker.Visible = open
                    satCursor.Visible = open
                    tw(frame, {Size = UDim2.new(1, 0, 0, open and 180 or 36)}, 0.25, Enum.EasingStyle.Quart)
                    task.delay(0.25, updateSecSize)
                end)
                
                table.insert(allElements, {name = name, frame = frame})
                updateSecSize()
                return {
                    set = function(_, c) val = c h, s, v = c:ToHSV() updateColor() end,
                    get = function() return val end
                }
            end
            
            function section:keybind(name, default, callback)
                local key = default
                local listening = false
                
                local frame = create("Frame", {
                    Parent = holder,
                    Name = name,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 32)
                })
                
                local lbl = create("TextLabel", {
                    Parent = frame,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0.6, 0, 1, 0),
                    Font = Enum.Font.GothamBold,
                    Text = name,
                    TextColor3 = theme.text,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local btn = create("TextButton", {
                    Parent = frame,
                    BackgroundColor3 = theme.bg,
                    BorderSizePixel = 0,
                    Position = UDim2.new(0.62, 0, 0, 0),
                    Size = UDim2.new(0.38, 0, 1, 0),
                    Font = Enum.Font.GothamMedium,
                    Text = key and key.Name or "None",
                    TextColor3 = theme.textDim,
                    TextSize = 12,
                    AutoButtonColor = false
                })
                addCorner(btn, UDim.new(0, 6))
                addStroke(btn, theme.border, 1, 0.7)
                
                btn.MouseEnter:Connect(function()
                    tw(btn, {BackgroundColor3 = theme.card}, 0.15)
                end)
                btn.MouseLeave:Connect(function()
                    tw(btn, {BackgroundColor3 = theme.bg}, 0.15)
                end)
                
                btn.MouseButton1Click:Connect(function()
                    listening = true
                    btn.Text = "..."
                    tw(btn:FindFirstChild("UIStroke"), {Color = theme.accent}, 0.15)
                end)
                
                input.InputBegan:Connect(function(inp, gpe)
                    if listening and inp.UserInputType == Enum.UserInputType.Keyboard then
                        key = inp.KeyCode
                        btn.Text = key.Name
                        listening = false
                        tw(btn:FindFirstChild("UIStroke"), {Color = theme.border}, 0.15)
                    elseif key and inp.KeyCode == key and not gpe then
                        if callback then callback() end
                    end
                end)
                
                table.insert(allElements, {name = name, frame = frame})
                updateSecSize()
                return {
                    set = function(_, k) key = k btn.Text = k and k.Name or "None" end,
                    get = function() return key end
                }
            end
            
            function section:label(text)
                local lbl = create("TextLabel", {
                    Parent = holder,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 24),
                    Font = Enum.Font.Gotham,
                    Text = text,
                    TextColor3 = theme.textDim,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                table.insert(allElements, {name = text, frame = lbl})
                updateSecSize()
                return {set = function(_, t) lbl.Text = t end}
            end
            
            return section
        end
        
        return tab
    end
    
    function window:notify(title, text, dur, type)
        local col = type == "error" and theme.red or type == "warning" and theme.orange or theme.accent
        
        local notif = create("Frame", {
            Parent = gui,
            Name = "Notification",
            BackgroundColor3 = theme.card,
            BorderSizePixel = 0,
            Position = UDim2.new(1, 20, 0.85, 0),
            Size = UDim2.new(0, 280, 0, 70),
            AnchorPoint = Vector2.new(0, 0.5)
        })
        addCorner(notif, UDim.new(0, 10))
        addShadow(notif, 0.5)
        
        local accent = create("Frame", {
            Parent = notif,
            BackgroundColor3 = col,
            BorderSizePixel = 0,
            Size = UDim2.new(0, 4, 1, 0)
        })
        addCorner(accent, UDim.new(0, 10))
        
        create("TextLabel", {
            Parent = notif,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 15, 0, 10),
            Size = UDim2.new(1, -25, 0, 20),
            Font = Enum.Font.GothamBold,
            Text = title,
            TextColor3 = col,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        
        create("TextLabel", {
            Parent = notif,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 15, 0, 32),
            Size = UDim2.new(1, -25, 0, 30),
            Font = Enum.Font.Gotham,
            Text = text,
            TextColor3 = theme.textDim,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true
        })
        
        local progress = create("Frame", {
            Parent = notif,
            BackgroundColor3 = col,
            BackgroundTransparency = 0.7,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 1, -3),
            Size = UDim2.new(1, 0, 0, 3)
        })
        
        tw(notif, {Position = UDim2.new(1, -290, 0.85, 0)}, 0.4, Enum.EasingStyle.Quart)
        tw(progress, {Size = UDim2.new(0, 0, 0, 3)}, dur or 3, Enum.EasingStyle.Linear)
        
        task.delay(dur or 3, function()
            tw(notif, {Position = UDim2.new(1, 20, 0.85, 0)}, 0.3, Enum.EasingStyle.Quart)
            task.delay(0.35, function() notif:Destroy() end)
        end)
    end
    
    function window:destroy()
        tw(blur, {Size = 0}, 0.3)
        tw(main, {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        task.delay(0.35, function()
            gui:Destroy()
            blur:Destroy()
            env.BioLibLoaded = false
        end)
    end
    
    function window:setCfgFolder(folder)
        self.cfgFolder = folder
    end
    
    function window:enableAutoSave(name)
        autoSave = true
        autoSaveName = name or "autosave"
    end
    
    function window:disableAutoSave()
        autoSave = false
    end
    
    function window:saveConfig(name)
        local success, err = pcall(function()
            if not isfolder then return end
            if not isfolder(self.cfgFolder) then
                makefolder(self.cfgFolder)
            end
            local path = self.cfgFolder .. "/" .. name .. ".json"
            local data = game:GetService("HttpService"):JSONEncode(self.cfgData)
            writefile(path, data)
        end)
        if success then
            self:notify("Config", "Saved: " .. name, 2)
        else
            self:notify("Error", "Failed to save config", 2, "error")
        end
    end
    
    function window:loadConfig(name)
        local success, err = pcall(function()
            if not isfile then return end
            local path = self.cfgFolder .. "/" .. name .. ".json"
            if isfile(path) then
                local data = readfile(path)
                self.cfgData = game:GetService("HttpService"):JSONDecode(data)
                for k, v in pairs(self.cfgData) do
                    if self.elements and self.elements[k] then
                        self.elements[k]:set(v)
                    end
                end
            end
        end)
        if success then
            self:notify("Config", "Loaded: " .. name, 2)
        else
            self:notify("Error", "Failed to load config", 2, "error")
        end
    end
    
    function window:deleteConfig(name)
        local success = pcall(function()
            if not delfile then return end
            local path = self.cfgFolder .. "/" .. name .. ".json"
            if isfile(path) then
                delfile(path)
            end
        end)
        if success then
            self:notify("Config", "Deleted: " .. name, 2)
        else
            self:notify("Error", "Failed to delete", 2, "error")
        end
    end
    
    function window:listConfigs()
        local configs = {}
        if not isfolder or not listfiles then return configs end
        if not isfolder(self.cfgFolder) then
            makefolder(self.cfgFolder)
            return configs
        end
        for _, file in pairs(listfiles(self.cfgFolder)) do
            local name = file:match("([^/\\]+)%.json$")
            if name then table.insert(configs, name) end
        end
        return configs
    end
    
    function window:exportConfig(name)
        local success, result = pcall(function()
            if not isfile then return "" end
            local path = self.cfgFolder .. "/" .. name .. ".json"
            if isfile(path) then
                local data = readfile(path)
                if setclipboard then
                    setclipboard(data)
                    return "clipboard"
                end
                return data
            end
            return ""
        end)
        if success and result == "clipboard" then
            self:notify("Export", "Copied to clipboard", 2)
            return true
        elseif success and result ~= "" then
            self:notify("Export", "Config data ready", 2)
            return result
        else
            self:notify("Error", "Export failed", 2, "error")
            return false
        end
    end
    
    function window:importConfig(name, data)
        local success = pcall(function()
            if not writefile or not isfolder then return end
            if not isfolder(self.cfgFolder) then
                makefolder(self.cfgFolder)
            end
            local path = self.cfgFolder .. "/" .. name .. ".json"
            writefile(path, data)
        end)
        if success then
            self:notify("Import", "Imported: " .. name, 2)
        else
            self:notify("Error", "Import failed", 2, "error")
        end
    end
    
    function window:setToggleKey(key)
        toggleKey = key
    end
    
    function window:showOpenButton(show)
        openBtn.Visible = show
    end
    
    return window
end

env.BioLib = lib
return lib
