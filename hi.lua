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

-- Load Icons API
local Icons = nil
pcall(function()
    Icons = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/Icons/main/Main-v2.lua"))()
    Icons.SetIconsType("lucide")
end)

local function getIcon(name)
    if Icons then
        local ok, result = pcall(function()
            return Icons.Icon(name:lower(), nil, true)
        end)
        if ok and result then 
            -- result is {spritesheetUrl, {ImageRectSize, ImageRectPosition}}
            if type(result) == "table" and result[1] then
                return result[1], result[2]
            elseif type(result) == "string" then
                return result, nil
            end
        end
    end
    return nil, nil
end

local function applyIcon(imageLabel, iconName, fallback)
    local img, rect = getIcon(iconName)
    if img then
        imageLabel.Image = img
        if rect then
            imageLabel.ImageRectSize = rect.ImageRectSize or Vector2.new(0, 0)
            imageLabel.ImageRectOffset = rect.ImageRectPosition or Vector2.new(0, 0)
        else
            imageLabel.ImageRectSize = Vector2.new(0, 0)
            imageLabel.ImageRectOffset = Vector2.new(0, 0)
        end
    elseif fallback then
        imageLabel.Image = fallback
        imageLabel.ImageRectSize = Vector2.new(0, 0)
        imageLabel.ImageRectOffset = Vector2.new(0, 0)
    end
end

local theme = {
    bg = Color3.fromRGB(12, 10, 18),
    sidebar = Color3.fromRGB(8, 6, 14),
    card = Color3.fromRGB(18, 15, 28),
    cardHover = Color3.fromRGB(35, 25, 55),
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

local iconMap = {
    Main = "home", Combat = "swords", Configs = "folder-cog", Settings = "settings",
    Player = "user", Visual = "eye", Misc = "sparkles", ESP = "scan-eye",
    Aimbot = "crosshair", Movement = "footprints", World = "globe", Teleport = "map-pin",
    Scripts = "code", Credits = "heart", Info = "info", home = "home",
    settings = "settings", combat = "swords", user = "user", shield = "shield",
    target = "target", zap = "zap", star = "star", heart = "heart",
    folder = "folder", file = "file", save = "save", download = "download",
    upload = "upload", search = "search", eye = "eye", lock = "lock",
    unlock = "unlock", play = "play", pause = "pause", stop = "square",
    bell = "bell", trash = "trash-2", edit = "pencil", plus = "plus",
    minus = "minus", check = "check", x = "x", menu = "menu",
    grid = "grid", layers = "layers", box = "box", gift = "gift",
    crown = "crown", flame = "flame", rocket = "rocket", globe = "globe",
    crosshair = "crosshair", gamepad = "gamepad-2", cpu = "cpu", code = "code",
    terminal = "terminal", database = "database", cloud = "cloud", wifi = "wifi",
    power = "power", sun = "sun", moon = "moon", clock = "clock",
    activity = "activity", award = "award", trophy = "trophy", flag = "flag",
    ["Save Config"] = "save", ["Load Config"] = "folder-open", ["Delete Config"] = "trash-2",
    ["Export Config"] = "upload", ["Import Config"] = "download", Showcase = "box",
    Lorem = "file-text", Ipsum = "layers", ["Config System"] = "folder-cog"
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
        BackgroundColor3 = theme.accent,
        BackgroundTransparency = 0.7,
        BorderSizePixel = 0,
        Position = UDim2.new(0, rx, 0, ry),
        Size = UDim2.new(0, 0, 0, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        ZIndex = 100
    })
    addCorner(rip, UDim.new(1, 0))
    
    tw(rip, {Size = UDim2.new(0, maxSize, 0, maxSize), BackgroundTransparency = 1}, 0.4, Enum.EasingStyle.Quad)
    task.delay(0.4, function() rip:Destroy() end)
end

lib.icons = iconMap

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
    
    -- Snowflakes on background
    local bgSnowHolder = create("Frame", {
        Parent = gui,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        ZIndex = 0
    })
    local bgSnowflakes = {}
    for i = 1, 60 do
        local s = math.random(2, 5)
        local startX = math.random()
        local startY = math.random()
        local snow = create("ImageLabel", {
            Parent = bgSnowHolder,
            BackgroundTransparency = 1,
            Position = UDim2.new(startX, 0, startY, 0),
            Size = UDim2.new(0, s, 0, s),
            Image = "rbxassetid://5028857084",
            ImageColor3 = Color3.fromRGB(200, 200, 255),
            ImageTransparency = math.random(20, 50) / 100
        })
        table.insert(bgSnowflakes, {frame = snow, speedY = 0.00008 + math.random() * 0.00015, speedX = (math.random() - 0.5) * 0.00005, x = startX, y = startY, rot = math.random(0, 360)})
    end
    
    task.spawn(function()
        while gui and gui.Parent do
            for _, data in ipairs(bgSnowflakes) do
                if data.frame and data.frame.Parent then
                    data.y = data.y + data.speedY
                    data.x = data.x + data.speedX
                    data.rot = data.rot + 0.5
                    if data.y > 1.1 then
                        data.y = -0.05
                        data.x = math.random()
                    end
                    data.frame.Position = UDim2.new(data.x, 0, data.y, 0)
                    data.frame.Rotation = data.rot
                end
            end
            task.wait(0.016)
        end
    end)
    
    -- Save window size
    local savedSize = {w = 680, h = 450}
    
    local main = create("Frame", {
        Parent = gui,
        Name = "Main",
        BackgroundColor3 = Color3.fromRGB(10, 8, 18),
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, 0, 0, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        ClipsDescendants = true
    })
    addCorner(main, UDim.new(0, 14))
    addShadow(main, 0.5)
    
    local mainStroke = create("UIStroke", {
        Parent = main,
        Color = theme.accent,
        Thickness = 1.5,
        Transparency = 0.5
    })
    
    -- Animate main stroke pulsing
    task.spawn(function()
        while main and main.Parent do
            tw(mainStroke, {Transparency = 0.3, Thickness = 2}, 1.5)
            task.wait(1.5)
            tw(mainStroke, {Transparency = 0.6, Thickness = 1.5}, 1.5)
            task.wait(1.5)
        end
    end)
    
    -- Animated BRIGHT stars that MOVE
    local stars = {}
    for i = 1, 100 do
        local s = math.random(2, 5)
        local startX = math.random() * 1.1 - 0.05
        local startY = math.random()
        local star = create("Frame", {
            Parent = main,
            BackgroundColor3 = Color3.fromRGB(220 + math.random(0, 35), 200 + math.random(0, 55), 255),
            BorderSizePixel = 0,
            Position = UDim2.new(startX, 0, startY, 0),
            Size = UDim2.new(0, s, 0, s),
            BackgroundTransparency = math.random(5, 35) / 100,
            ZIndex = 1
        })
        addCorner(star, UDim.new(1, 0))
        
        -- Star glow effect
        local glow = create("ImageLabel", {
            Parent = star,
            BackgroundTransparency = 1,
            Position = UDim2.new(0.5, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Size = UDim2.new(3, 0, 3, 0),
            Image = "rbxassetid://5028857084",
            ImageColor3 = Color3.fromRGB(180, 140, 255),
            ImageTransparency = 0.7,
            ScaleType = Enum.ScaleType.Slice,
            SliceCenter = Rect.new(24, 24, 276, 276),
            ZIndex = 0
        })
        
        table.insert(stars, {frame = star, speed = 0.00015 + math.random() * 0.0004, x = startX})
    end
    
    -- Star movement animation
    task.spawn(function()
        while main and main.Parent do
            for _, data in ipairs(stars) do
                if data.frame and data.frame.Parent then
                    data.x = data.x - data.speed
                    if data.x < -0.05 then
                        data.x = 1.05
                        data.frame.Position = UDim2.new(data.x, 0, math.random(), 0)
                    else
                        data.frame.Position = UDim2.new(data.x, 0, data.frame.Position.Y.Scale, 0)
                    end
                end
            end
            task.wait(0.016)
        end
    end)
    
    -- Star twinkle animation
    for _, data in ipairs(stars) do
        task.spawn(function()
            task.wait(math.random() * 2)
            while data.frame and data.frame.Parent do
                tw(data.frame, {BackgroundTransparency = 0.6}, 0.5 + math.random() * 0.5)
                task.wait(0.6 + math.random() * 0.6)
                tw(data.frame, {BackgroundTransparency = math.random(5, 25) / 100}, 0.5 + math.random() * 0.5)
                task.wait(0.6 + math.random() * 0.6)
            end
        end)
    end
    
    tw(main, {Size = UDim2.new(0, savedSize.w, 0, savedSize.h)}, 0.4, Enum.EasingStyle.Back)
    
    local sidebar = create("Frame", {
        Parent = main,
        Name = "Sidebar",
        BackgroundColor3 = Color3.fromRGB(14, 11, 24),
        BackgroundTransparency = 0.15,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(0, 145, 1, 0),
        ClipsDescendants = true,
        ZIndex = 2
    })
    addCorner(sidebar, UDim.new(0, 14))
    
    local sidebarGrad = create("UIGradient", {
        Parent = sidebar,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 15, 35)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 6, 16))
        }),
        Rotation = 180
    })
    
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
        BackgroundColor3 = Color3.fromRGB(14, 12, 24),
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 145, 0, 0),
        Size = UDim2.new(1, -145, 1, 0),
        ClipsDescendants = true,
        ZIndex = 2
    })
    addCorner(content, UDim.new(0, 14))
    
    local contentGrad = create("UIGradient", {
        Parent = content,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(18, 14, 30)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 8, 18))
        }),
        Rotation = 180
    })
    
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
        Image = "rbxassetid://10734898355",
        ImageColor3 = theme.textDim,
        Visible = false
    })
    
    local searchInput = create("TextBox", {
        Parent = searchBox,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 12, 0, 0),
        Size = UDim2.new(1, -24, 1, 0),
        Font = Enum.Font.Gotham,
        PlaceholderText = "Search...",
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
    local windowTabs = {}
    local activeTabName = nil
    
    searchInput:GetPropertyChangedSignal("Text"):Connect(function()
        local q = searchInput.Text:lower()
        if q ~= "" then
            for _, t in pairs(windowTabs) do
                if t.page then t.page.Visible = true end
            end
            for _, el in pairs(allElements) do
                local match = el.name:lower():find(q, 1, true)
                el.frame.Visible = match
            end
        else
            for _, t in pairs(windowTabs) do
                if t.page then t.page.Visible = (t == windowTabs[activeTabName]) end
            end
            for _, el in pairs(allElements) do
                el.frame.Visible = true
            end
        end
    end)
    
    local btnHolder = create("Frame", {
        Parent = topbar,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -80, 0.5, -15),
        Size = UDim2.new(0, 70, 0, 30)
    })
    
    local timeLabel = create("TextLabel", {
        Parent = topbar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, -60, 0, 0),
        Size = UDim2.new(0, 120, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = os.date("%H:%M:%S"),
        TextColor3 = theme.text,
        TextSize = 16,
        Visible = false
    })
    
    task.spawn(function()
        while timeLabel and timeLabel.Parent do
            if timeLabel.Visible then
                timeLabel.Text = os.date("%H:%M:%S")
            end
            task.wait(1)
        end
    end)
    
    local minimizeBtn = create("TextButton", {
        Parent = btnHolder,
        BackgroundColor3 = Color3.fromRGB(35, 25, 55),
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(0, 30, 0, 30),
        Text = "",
        AutoButtonColor = false
    })
    addCorner(minimizeBtn, UDim.new(0, 8))
    
    local minIcon = create("Frame", {
        Parent = minimizeBtn,
        BackgroundColor3 = theme.accent,
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, -6, 0.5, -1),
        Size = UDim2.new(0, 12, 0, 2)
    })
    addCorner(minIcon, UDim.new(1, 0))
    
    minimizeBtn.MouseEnter:Connect(function()
        tw(minimizeBtn, {BackgroundColor3 = theme.accent}, 0.15)
        tw(minIcon, {BackgroundColor3 = theme.text}, 0.15)
    end)
    minimizeBtn.MouseLeave:Connect(function()
        tw(minimizeBtn, {BackgroundColor3 = Color3.fromRGB(35, 25, 55)}, 0.15)
        tw(minIcon, {BackgroundColor3 = theme.accent}, 0.15)
    end)
    
    local closeBtn = create("TextButton", {
        Parent = btnHolder,
        BackgroundColor3 = Color3.fromRGB(35, 25, 55),
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
        TextColor3 = theme.accent,
        TextSize = 20
    })
    
    closeBtn.MouseEnter:Connect(function()
        tw(closeBtn, {BackgroundColor3 = theme.accent}, 0.15)
        tw(closeIcon, {TextColor3 = theme.text}, 0.15)
    end)
    closeBtn.MouseLeave:Connect(function()
        tw(closeBtn, {BackgroundColor3 = Color3.fromRGB(35, 25, 55)}, 0.15)
        tw(closeIcon, {TextColor3 = theme.accent}, 0.15)
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
        if not minimized then
            for _, dot in pairs(resizeDots:GetChildren()) do
                tw(dot, {BackgroundColor3 = theme.accent}, 0.15)
            end
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
            savedSize.w = newW
            savedSize.h = newH
        end
    end)
    
    local dragging, dragStart, startPos
    
    -- Drag from topbar
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
    
    -- Drag from logo area (sidebar header)
    logo.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = inp.Position
            startPos = main.Position
        end
    end)
    
    logo.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    -- Drag from sidebar (empty space)
    sidebar.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = inp.Position
            startPos = main.Position
        end
    end)
    
    sidebar.InputEnded:Connect(function(inp)
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
    local visible = true
    local toggleKey = Enum.KeyCode.Insert
    local toggleCooldown = false
    
    minimizeBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        resizeHandle.Visible = not minimized
        searchBox.Visible = not minimized
        timeLabel.Visible = minimized
        if minimized then
            tw(sidebar, {Size = UDim2.new(0, 0, 1, 0)}, 0.3, Enum.EasingStyle.Quart)
            tw(content, {Position = UDim2.new(0, 0, 0, 0), Size = UDim2.new(1, 0, 0, 55), BackgroundTransparency = 0.5}, 0.3, Enum.EasingStyle.Quart)
            tw(main, {Size = UDim2.new(0, 400, 0, 55)}, 0.3, Enum.EasingStyle.Quart)
            tw(blur, {Size = 0}, 0.25)
        else
            tw(sidebar, {Size = UDim2.new(0, 145, 1, 0)}, 0.3, Enum.EasingStyle.Quart)
            tw(content, {Position = UDim2.new(0, 145, 0, 0), Size = UDim2.new(1, -145, 1, 0), BackgroundTransparency = 0.1}, 0.3, Enum.EasingStyle.Quart)
            tw(main, {Size = UDim2.new(0, savedSize.w, 0, savedSize.h)}, 0.3, Enum.EasingStyle.Quart)
            tw(blur, {Size = 6}, 0.25)
        end
    end)
    
    local openGui = create("ScreenGui", {
        Name = "BioLib_OpenBtn",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset = true,
        DisplayOrder = 100
    })
    
    if syn and syn.protect_gui then
        syn.protect_gui(openGui)
    end
    
    if gethui then
        openGui.Parent = gethui()
    elseif protected then
        openGui.Parent = game:GetService("CoreGui")
    else
        openGui.Parent = player:WaitForChild("PlayerGui")
    end
    
    local openBtn = create("TextButton", {
        Parent = openGui,
        Name = "OpenButton",
        BackgroundColor3 = theme.accent,
        BackgroundTransparency = 0.15,
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, -35, 0, 10),
        Size = UDim2.new(0, 70, 0, 70),
        Text = "",
        AutoButtonColor = false,
        Visible = false
    })
    addCorner(openBtn, UDim.new(0, 14))
    addShadow(openBtn, 0.3)
    addStroke(openBtn, theme.accent, 2, 0.3)
    
    -- Beautiful gradient for open button
    local openBtnGrad = create("UIGradient", {
        Parent = openBtn,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(160, 100, 255)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(138, 90, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 60, 200))
        }),
        Rotation = 45
    })
    
    -- Add icon to open button - rocket icon
    local openBtnIcon = create("ImageLabel", {
        Parent = openBtn,
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, -14, 0.5, -14),
        Size = UDim2.new(0, 28, 0, 28),
        Image = "rbxassetid://7072719338",
        ImageColor3 = theme.text,
        Rotation = -45
    })
    applyIcon(openBtnIcon, "rocket", "rbxassetid://7072719338")
    
    -- Glow effect for open button icon
    local openBtnGlow = create("ImageLabel", {
        Parent = openBtn,
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.new(1, 30, 1, 30),
        Image = "rbxassetid://5028857084",
        ImageColor3 = theme.accent,
        ImageTransparency = 0.6,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(24, 24, 276, 276),
        ZIndex = 0
    })
    
    openBtn.MouseEnter:Connect(function()
        tw(openBtn, {BackgroundTransparency = 0, Size = UDim2.new(0, 75, 0, 75)}, 0.2)
        tw(openBtnIcon, {Rotation = 0}, 0.3)
        tw(openBtnGlow, {ImageTransparency = 0.3, Size = UDim2.new(1, 40, 1, 40)}, 0.2)
    end)
    openBtn.MouseLeave:Connect(function()
        tw(openBtn, {BackgroundTransparency = 0.15, Size = UDim2.new(0, 70, 0, 70)}, 0.2)
        tw(openBtnIcon, {Rotation = -45}, 0.3)
        tw(openBtnGlow, {ImageTransparency = 0.6, Size = UDim2.new(1, 30, 1, 30)}, 0.2)
    end)
    
    task.spawn(function()
        while openGui and openGui.Parent do
            if openBtn.Visible then
                local stroke = openBtn:FindFirstChild("UIStroke")
                if stroke then
                    tw(stroke, {Transparency = 0}, 0.8)
                    task.wait(0.8)
                    tw(stroke, {Transparency = 0.6}, 0.8)
                    task.wait(0.8)
                end
            else
                task.wait(0.5)
            end
        end
    end)
    
    openBtn.MouseButton1Click:Connect(function()
        visible = true
        minimized = false
        resizeHandle.Visible = true
        searchBox.Visible = true
        timeLabel.Visible = false
        openBtn.Visible = false
        main.Visible = true
        bgSnowHolder.Visible = true
        main.Size = UDim2.new(0, 0, 0, 0)
        sidebar.Size = UDim2.new(0, 145, 1, 0)
        content.Position = UDim2.new(0, 145, 0, 0)
        content.Size = UDim2.new(1, -145, 1, 0)
        content.BackgroundTransparency = 0.1
        tw(main, {Size = UDim2.new(0, savedSize.w, 0, savedSize.h)}, 0.4, Enum.EasingStyle.Back)
        tw(blur, {Size = 6}, 0.4)
    end)
    
    closeBtn.MouseButton1Click:Connect(function()
        visible = false
        bgSnowHolder.Visible = false
        tw(blur, {Size = 0}, 0.3)
        tw(main, {Size = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        task.delay(0.35, function()
            main.Visible = false
            openBtn.Visible = true
        end)
    end)
    
    input.InputBegan:Connect(function(key, gpe)
        if gpe then return end
        if key.KeyCode == toggleKey and not toggleCooldown then
            toggleCooldown = true
            task.delay(0.5, function() toggleCooldown = false end)
            visible = not visible
            if visible then
                minimized = false
                resizeHandle.Visible = true
                searchBox.Visible = true
                timeLabel.Visible = false
                openBtn.Visible = false
                main.Visible = true
                bgSnowHolder.Visible = true
                main.Size = UDim2.new(0, 0, 0, 0)
                sidebar.Size = UDim2.new(0, 145, 1, 0)
                content.Position = UDim2.new(0, 145, 0, 0)
                content.Size = UDim2.new(1, -145, 1, 0)
                content.BackgroundTransparency = 0.1
                tw(main, {Size = UDim2.new(0, savedSize.w, 0, savedSize.h)}, 0.4, Enum.EasingStyle.Back)
                tw(blur, {Size = 6}, 0.4)
            else
                bgSnowHolder.Visible = false
                tw(blur, {Size = 0}, 0.3)
                tw(main, {Size = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
                task.delay(0.35, function()
                    main.Visible = false
                    openBtn.Visible = true
                end)
            end
        end
    end)
    
    local cfgData = {}
    local elements = {}
    local autoSave = false
    local autoSaveName = "default"
    local notifQueue = {}
    
    local window = {
        gui = gui, 
        openGui = openGui,
        main = main,
        openBtn = openBtn,
        openBtnIcon = openBtnIcon,
        tabs = windowTabs, 
        activeTab = nil,
        cfgFolder = "configs",
        cfgData = cfgData,
        elements = elements,
        onConfigListUpdate = nil
    }
    
    -- Method to set custom icon for open button
    -- Usage: win:setOpenIcon("rbxassetid://123456789") or win:setOpenIcon(getIcon("star"))
    function window:setOpenIcon(imageId)
        if openBtnIcon and imageId then
            openBtnIcon.Image = imageId
        end
    end
    
    local function saveElement(key, value)
        cfgData[key] = value
        if autoSave and autoSaveName then
            task.delay(0.5, function()
                pcall(function()
                    if not writefile or not makefolder or not isfolder then return end
                    if not isfolder(window.cfgFolder) then
                        makefolder(window.cfgFolder)
                    end
                    local path = window.cfgFolder .. "/" .. autoSaveName .. ".json"
                    local data = game:GetService("HttpService"):JSONEncode(cfgData)
                    writefile(path, data)
                end)
            end)
        end
    end
    
    function window:tab(name, icon)
        local tabBtn = create("TextButton", {
            Parent = tabScroll,
            Name = name,
            BackgroundColor3 = Color3.fromRGB(138, 90, 255),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, 40),
            Text = "",
            AutoButtonColor = false
        })
        addCorner(tabBtn, UDim.new(0, 10))
        
        local tabGlow = create("ImageLabel", {
            Parent = tabBtn,
            Name = "Glow",
            BackgroundTransparency = 1,
            Position = UDim2.new(0.5, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Size = UDim2.new(1, 20, 1, 20),
            Image = "rbxassetid://5028857084",
            ImageColor3 = theme.accent,
            ImageTransparency = 1,
            ScaleType = Enum.ScaleType.Slice,
            SliceCenter = Rect.new(24, 24, 276, 276),
            ZIndex = 0
        })
        
        local indicator = create("Frame", {
            Parent = tabBtn,
            Name = "Indicator",
            BackgroundColor3 = theme.accent,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 2, 0.2, 0),
            Size = UDim2.new(0, 3, 0.6, 0),
            BackgroundTransparency = 1
        })
        addCorner(indicator, UDim.new(1, 0))
        
        -- Indicator glow
        local indicatorGlow = create("ImageLabel", {
            Parent = indicator,
            BackgroundTransparency = 1,
            Position = UDim2.new(0.5, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Size = UDim2.new(0, 8, 1, 8),
            Image = "rbxassetid://5028857084",
            ImageColor3 = theme.accent,
            ImageTransparency = 1,
            ScaleType = Enum.ScaleType.Slice,
            SliceCenter = Rect.new(24, 24, 276, 276),
            ZIndex = 0
        })
        
        local iconSize = 18
        -- Get icon from API or fallback
        local iconName = iconMap[name] or iconMap[icon] or name:lower()
        local img, rect = getIcon(iconName)
        local hasIcon = img ~= nil or icon ~= nil
        
        local tabIcon
        if hasIcon then
            tabIcon = create("ImageLabel", {
                Parent = tabBtn,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 0.5, -iconSize/2),
                Size = UDim2.new(0, iconSize, 0, iconSize),
                Image = "",
                ImageColor3 = theme.textDim
            })
            
            if icon then
                tabIcon.Image = icon
            else
                applyIcon(tabIcon, iconName)
            end
        end
        
        local tabLbl = create("TextLabel", {
            Parent = tabBtn,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, hasIcon and 36 or 12, 0, 0),
            Size = UDim2.new(1, hasIcon and -44 or -20, 1, 0),
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
            ScrollBarThickness = 0,
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
            if window.activeTab == name then return end
            
            for _, t in pairs(window.tabs) do
                tw(t.btn, {BackgroundTransparency = 1}, 0.25)
                local ind = t.btn:FindFirstChild("Indicator")
                if ind then 
                    tw(ind, {BackgroundTransparency = 1}, 0.25)
                    local indGlow = ind:FindFirstChild("ImageLabel")
                    if indGlow then tw(indGlow, {ImageTransparency = 1}, 0.25) end
                end
                local glow = t.btn:FindFirstChild("Glow")
                if glow then tw(glow, {ImageTransparency = 1}, 0.25) end
                local txt = t.btn:FindFirstChild("TextLabel")
                if txt then tw(txt, {TextColor3 = theme.textDim}, 0.25) end
                local ico = t.btn:FindFirstChild("ImageLabel")
                if ico and ico.Name ~= "Glow" then tw(ico, {ImageColor3 = theme.textDim}, 0.25) end
                if t.page ~= page and t.page.Visible then
                    t.page.Visible = false
                end
            end
            tw(tabBtn, {BackgroundTransparency = 0.85}, 0.25)
            tw(indicator, {BackgroundTransparency = 0}, 0.25)
            tw(indicatorGlow, {ImageTransparency = 0.5}, 0.25)
            tw(tabGlow, {ImageTransparency = 0.7}, 0.25)
            tw(tabLbl, {TextColor3 = theme.text}, 0.25)
            if tabIcon then tw(tabIcon, {ImageColor3 = theme.accent}, 0.25) end
            
            page.Visible = true
            
            window.activeTab = name
            activeTabName = name
        end
        
        tabBtn.MouseEnter:Connect(function()
            if window.activeTab ~= name then
                tw(tabBtn, {BackgroundTransparency = 0.92}, 0.15)
                tw(tabGlow, {ImageTransparency = 0.85}, 0.15)
            end
        end)
        tabBtn.MouseLeave:Connect(function()
            if window.activeTab ~= name then
                tw(tabBtn, {BackgroundTransparency = 1}, 0.15)
                tw(tabGlow, {ImageTransparency = 1}, 0.15)
            end
        end)
        tabBtn.MouseButton1Click:Connect(function()
            activate()
        end)
        
        window.tabs[name] = {btn = tabBtn, page = page}
        
        if not window.activeTab then
            tw(tabBtn, {BackgroundTransparency = 0.85}, 0.2)
            tw(indicator, {BackgroundTransparency = 0}, 0.2)
            tw(indicatorGlow, {ImageTransparency = 0.5}, 0.2)
            tw(tabGlow, {ImageTransparency = 0.7}, 0.2)
            tw(tabLbl, {TextColor3 = theme.text}, 0.2)
            if tabIcon then tw(tabIcon, {ImageColor3 = theme.accent}, 0.2) end
            page.Visible = true
            window.activeTab = name
            activeTabName = name
        end
        
        tabList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tabScroll.CanvasSize = UDim2.new(0, 0, 0, tabList.AbsoluteContentSize.Y + 15)
        end)
        
        local tab = {}
        tab.name = name
        
        function tab:section(name)
            local sec = create("Frame", {
                Parent = page,
                Name = name,
                BackgroundColor3 = Color3.fromRGB(18, 15, 30),
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 45),
                ClipsDescendants = true
            })
            addCorner(sec, UDim.new(0, 12))
            addStroke(sec, Color3.fromRGB(70, 55, 100), 1, 0.7)
            
            local secGrad = create("UIGradient", {
                Parent = sec,
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(22, 18, 38)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(14, 12, 24))
                }),
                Rotation = 135
            })
            
            local headerLine = create("Frame", {
                Parent = sec,
                Name = "HeaderLine",
                BackgroundColor3 = theme.accent,
                BackgroundTransparency = 0.7,
                BorderSizePixel = 0,
                Position = UDim2.new(0, 15, 0, 44),
                Size = UDim2.new(1, -30, 0, 1)
            })
            
            local header = create("Frame", {
                Parent = sec,
                Name = "Header",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 45)
            })
            
            local secIcon = create("Frame", {
                Parent = header,
                Name = "SecIcon",
                BackgroundColor3 = theme.accent,
                BackgroundTransparency = 0.85,
                BorderSizePixel = 0,
                Position = UDim2.new(0, 12, 0.5, -12),
                Size = UDim2.new(0, 24, 0, 24)
            })
            addCorner(secIcon, UDim.new(0, 6))
            
            local iconLbl = create("ImageLabel", {
                Parent = secIcon,
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 16, 0, 16),
                Position = UDim2.new(0.5, -8, 0.5, -8),
                ImageColor3 = theme.accent,
                ImageTransparency = 0,
                ScaleType = Enum.ScaleType.Fit,
                Image = ""
            })
            applyIcon(iconLbl, name)
            
            local secTitle = create("TextLabel", {
                Parent = header,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 44, 0, 0),
                Size = UDim2.new(0.7, -44, 1, 0),
                Font = Enum.Font.GothamBlack,
                Text = name,
                TextColor3 = theme.text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local expandBtn = create("TextButton", {
                Parent = header,
                BackgroundColor3 = theme.accent,
                BackgroundTransparency = 0.9,
                Position = UDim2.new(1, -40, 0.5, -14),
                Size = UDim2.new(0, 28, 0, 28),
                Text = "",
                AutoButtonColor = false
            })
            addCorner(expandBtn, UDim.new(0, 8))
            
            local expandIcon = create("ImageLabel", {
                Parent = expandBtn,
                BackgroundTransparency = 1,
                Position = UDim2.new(0.5, -6, 0.5, -6),
                Size = UDim2.new(0, 12, 0, 12),
                Image = "rbxassetid://6031091004",
                ImageColor3 = theme.accent,
                Rotation = 0
            })
            
            expandBtn.MouseEnter:Connect(function()
                tw(expandBtn, {BackgroundTransparency = 0.8}, 0.15)
            end)
            expandBtn.MouseLeave:Connect(function()
                tw(expandBtn, {BackgroundTransparency = 0.9}, 0.15)
            end)
            
            local holder = create("Frame", {
                Parent = sec,
                Name = "Holder",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 15, 0, 54),
                Size = UDim2.new(1, -30, 0, 0)
            })
            
            local holderList = create("UIListLayout", {
                Parent = holder,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 12)
            })
            
            local expanded = true
            
            local function updateSecSize()
                local h = expanded and (holderList.AbsoluteContentSize.Y + 72) or 45
                tw(sec, {Size = UDim2.new(1, 0, 0, h)}, 0.25, Enum.EasingStyle.Quart)
                tw(expandIcon, {Rotation = expanded and 180 or 0}, 0.25)
                tw(headerLine, {BackgroundTransparency = expanded and 0.7 or 1}, 0.25)
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
                    BackgroundColor3 = Color3.fromRGB(25, 20, 45),
                    BorderSizePixel = 0,
                    Size = UDim2.new(1, 0, 0, 42),
                    Text = "",
                    AutoButtonColor = false,
                    ClipsDescendants = true
                })
                addCorner(btn, UDim.new(0, 10))
                addStroke(btn, Color3.fromRGB(80, 60, 120), 1, 0.6)
                
                local btnGrad = create("UIGradient", {
                    Parent = btn,
                    Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 25, 55)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 16, 36))
                    }),
                    Rotation = 90
                })
                
                local btnIcon = create("Frame", {
                    Parent = btn,
                    BackgroundColor3 = theme.accent,
                    BackgroundTransparency = 0.8,
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, 12, 0.5, -10),
                    Size = UDim2.new(0, 20, 0, 20)
                })
                addCorner(btnIcon, UDim.new(0, 6))
                
                local iconName = iconMap[name] or name:lower()
                local img, rect = getIcon(iconName)
                local btnArrow = img and create("ImageLabel", {
                    Parent = btnIcon,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 14, 0, 14),
                    Position = UDim2.new(0.5, -7, 0.5, -7),
                    Image = "",
                    ImageColor3 = theme.accent,
                    ScaleType = Enum.ScaleType.Fit
                }) or create("TextLabel", {
                    Parent = btnIcon,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    Font = Enum.Font.GothamBold,
                    Text = "→",
                    TextColor3 = theme.accent,
                    TextSize = 14
                })
                
                if img and btnArrow:IsA("ImageLabel") then
                    applyIcon(btnArrow, iconName)
                end
                
                local btnLbl = create("TextLabel", {
                    Parent = btn,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 40, 0, 0),
                    Size = UDim2.new(1, -50, 1, 0),
                    Font = Enum.Font.GothamBold,
                    Text = name,
                    TextColor3 = theme.text,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                btn.MouseEnter:Connect(function()
                    tw(btn, {BackgroundColor3 = theme.accent}, 0.2)
                    tw(btn:FindFirstChild("UIStroke"), {Color = theme.accent, Transparency = 0.3}, 0.2)
                    tw(btnIcon, {BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 0.7}, 0.2)
                    if btnArrow:IsA("ImageLabel") then
                        tw(btnArrow, {ImageColor3 = Color3.new(1, 1, 1)}, 0.2)
                    else
                        tw(btnArrow, {TextColor3 = Color3.new(1, 1, 1)}, 0.2)
                    end
                    btnGrad.Enabled = false
                end)
                btn.MouseLeave:Connect(function()
                    tw(btn, {BackgroundColor3 = Color3.fromRGB(25, 20, 45)}, 0.2)
                    tw(btn:FindFirstChild("UIStroke"), {Color = Color3.fromRGB(80, 60, 120), Transparency = 0.6}, 0.2)
                    tw(btnIcon, {BackgroundColor3 = theme.accent, BackgroundTransparency = 0.8}, 0.2)
                    if btnArrow:IsA("ImageLabel") then
                        tw(btnArrow, {ImageColor3 = theme.accent}, 0.2)
                    else
                        tw(btnArrow, {TextColor3 = theme.accent}, 0.2)
                    end
                    btnGrad.Enabled = true
                end)
                btn.MouseButton1Click:Connect(function()
                    ripple(btn, mouse.X, mouse.Y)
                    if callback then callback() end
                end)
                
                table.insert(allElements, {name = name, frame = btn, tab = tab.name})
                updateSecSize()
                return btn
            end
            
            function section:toggle(name, default, callback)
                local val = default or false
                
                local frame = create("Frame", {
                    Parent = holder,
                    Name = name,
                    BackgroundColor3 = Color3.fromRGB(25, 20, 38),
                    BackgroundTransparency = 0.5,
                    Size = UDim2.new(1, 0, 0, 40)
                })
                addCorner(frame, UDim.new(0, 10))
                
                local lbl = create("TextLabel", {
                    Parent = frame,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 14, 0, 0),
                    Size = UDim2.new(0.65, 0, 1, 0),
                    Font = Enum.Font.GothamBold,
                    Text = name,
                    TextColor3 = theme.text,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local box = create("Frame", {
                    Parent = frame,
                    BackgroundColor3 = val and theme.accent or Color3.fromRGB(30, 25, 50),
                    BorderSizePixel = 0,
                    Position = UDim2.new(1, -60, 0.5, -13),
                    Size = UDim2.new(0, 52, 0, 26)
                })
                addCorner(box, UDim.new(1, 0))
                addStroke(box, val and theme.accent or Color3.fromRGB(60, 50, 90), 1.5, val and 0.3 or 0.5)
                
                local boxGrad = create("UIGradient", {
                    Parent = box,
                    Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 60, 180)),
                        ColorSequenceKeypoint.new(0.3, theme.accent),
                        ColorSequenceKeypoint.new(0.7, Color3.fromRGB(180, 120, 255)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 60, 180))
                    }),
                    Offset = Vector2.new(-1, 0),
                    Enabled = val
                })
                
                if val then
                    task.spawn(function()
                        while box and box.Parent and boxGrad.Enabled do
                            tw(boxGrad, {Offset = Vector2.new(1, 0)}, 1.5, Enum.EasingStyle.Linear)
                            task.wait(1.5)
                            if boxGrad.Enabled then
                                boxGrad.Offset = Vector2.new(-1, 0)
                            end
                        end
                    end)
                end
                
                local dot = create("Frame", {
                    Parent = box,
                    BackgroundColor3 = Color3.new(1, 1, 1),
                    BorderSizePixel = 0,
                    Position = val and UDim2.new(1, -24, 0.5, -10) or UDim2.new(0, 3, 0.5, -10),
                    Size = UDim2.new(0, 20, 0, 20)
                })
                addCorner(dot, UDim.new(1, 0))
                
                local dotShadow = create("ImageLabel", {
                    Parent = dot,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 0, 0.5, 2),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Size = UDim2.new(1, 10, 1, 10),
                    Image = "rbxassetid://5028857084",
                    ImageColor3 = Color3.new(0, 0, 0),
                    ImageTransparency = 0.6,
                    ScaleType = Enum.ScaleType.Slice,
                    SliceCenter = Rect.new(24, 24, 276, 276),
                    ZIndex = 0
                })
                
                local btn = create("TextButton", {
                    Parent = frame,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    Text = ""
                })
                
                local function update()
                    tw(box, {BackgroundColor3 = val and theme.accent or Color3.fromRGB(30, 25, 50)}, 0.25)
                    tw(box:FindFirstChild("UIStroke"), {Color = val and theme.accent or Color3.fromRGB(60, 50, 90), Transparency = val and 0.3 or 0.5}, 0.25)
                    tw(dot, {Position = val and UDim2.new(1, -24, 0.5, -10) or UDim2.new(0, 3, 0.5, -10)}, 0.25, Enum.EasingStyle.Back)
                    boxGrad.Enabled = val
                    if val then
                        task.spawn(function()
                            while box and box.Parent and boxGrad.Enabled do
                                tw(boxGrad, {Offset = Vector2.new(1, 0)}, 1.5, Enum.EasingStyle.Linear)
                                task.wait(1.5)
                                if boxGrad.Enabled then
                                    boxGrad.Offset = Vector2.new(-1, 0)
                                end
                            end
                        end)
                    end
                end
                
                btn.MouseButton1Click:Connect(function()
                    val = not val
                    update()
                    saveElement(name, val)
                    if callback then callback(val) end
                end)
                
                table.insert(allElements, {name = name, frame = frame, tab = tab.name})
                updateSecSize()
                elements[name] = {
                    set = function(_, v) val = v update() end,
                    get = function() return val end,
                    default = default or false
                }
                return elements[name]
            end
            
            function section:slider(name, min, max, default, callback)
                local val = default or min
                
                local frame = create("Frame", {
                    Parent = holder,
                    Name = name,
                    BackgroundColor3 = Color3.fromRGB(25, 20, 38),
                    BackgroundTransparency = 0.5,
                    Size = UDim2.new(1, 0, 0, 68)
                })
                addCorner(frame, UDim.new(0, 10))
                
                local top = create("Frame", {
                    Parent = frame,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 14, 0, 0),
                    Size = UDim2.new(1, -28, 0, 28)
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
                
                local valBox = create("Frame", {
                    Parent = top,
                    BackgroundColor3 = theme.accent,
                    BackgroundTransparency = 0.85,
                    Position = UDim2.new(1, -50, 0.5, -10),
                    Size = UDim2.new(0, 50, 0, 20)
                })
                addCorner(valBox, UDim.new(0, 6))
                
                local valLbl = create("TextLabel", {
                    Parent = valBox,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    Font = Enum.Font.GothamBold,
                    Text = tostring(math.floor(val)),
                    TextColor3 = theme.accent,
                    TextSize = 13
                })
                
                local bar = create("Frame", {
                    Parent = frame,
                    BackgroundColor3 = Color3.fromRGB(30, 25, 50),
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, 14, 0, 35),
                    Size = UDim2.new(1, -28, 0, 12)
                })
                addCorner(bar, UDim.new(1, 0))
                addStroke(bar, Color3.fromRGB(50, 40, 80), 1, 0.6)
                
                local fill = create("Frame", {
                    Parent = bar,
                    BackgroundColor3 = theme.accent,
                    BorderSizePixel = 0,
                    Size = UDim2.new((val - min) / (max - min), 0, 1, 0)
                })
                addCorner(fill, UDim.new(1, 0))
                
                local fillGrad = create("UIGradient", {
                    Parent = fill,
                    Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 60, 180)),
                        ColorSequenceKeypoint.new(0.3, theme.accent),
                        ColorSequenceKeypoint.new(0.7, Color3.fromRGB(180, 120, 255)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 60, 180))
                    }),
                    Offset = Vector2.new(-1, 0)
                })
                
                task.spawn(function()
                    while fill and fill.Parent do
                        tw(fillGrad, {Offset = Vector2.new(1, 0)}, 1.5, Enum.EasingStyle.Linear)
                        task.wait(1.5)
                        fillGrad.Offset = Vector2.new(-1, 0)
                    end
                end)
                
                local pct = (val - min) / (max - min)
                local knob = create("Frame", {
                    Parent = bar,
                    BackgroundColor3 = Color3.new(1, 1, 1),
                    BorderSizePixel = 0,
                    Position = UDim2.new(pct, -10, 0.5, -10),
                    Size = UDim2.new(0, 20, 0, 20),
                    ZIndex = 3
                })
                addCorner(knob, UDim.new(1, 0))
                
                local knobGlow = create("ImageLabel", {
                    Parent = knob,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Size = UDim2.new(1, 16, 1, 16),
                    Image = "rbxassetid://5028857084",
                    ImageColor3 = theme.accent,
                    ImageTransparency = 0.5,
                    ScaleType = Enum.ScaleType.Slice,
                    SliceCenter = Rect.new(24, 24, 276, 276),
                    ZIndex = 2
                })
                
                local minLbl = create("TextLabel", {
                    Parent = frame,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 14, 0, 52),
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
                    Position = UDim2.new(0.7, -14, 0, 52),
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
                        local newPct = math.clamp((inp.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
                        val = math.floor(min + (max - min) * newPct)
                        fill.Size = UDim2.new(newPct, 0, 1, 0)
                        knob.Position = UDim2.new(newPct, -12, 0.5, -12)
                        knob.Size = UDim2.new(0, 24, 0, 24)
                        valLbl.Text = tostring(val)
                        saveElement(name, val)
                        if callback then callback(val) end
                    end
                end)
                
                input.InputEnded:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 and sliding then
                        sliding = false
                        local currPct = (val - min) / (max - min)
                        tw(knob, {Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(currPct, -10, 0.5, -10)}, 0.15)
                        tw(knobGlow, {ImageTransparency = 0.5, Size = UDim2.new(1, 16, 1, 16)}, 0.15)
                    end
                end)
                
                input.InputChanged:Connect(function(inp)
                    if sliding and inp.UserInputType == Enum.UserInputType.MouseMovement then
                        local newPct = math.clamp((inp.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
                        val = math.floor(min + (max - min) * newPct)
                        fill.Size = UDim2.new(newPct, 0, 1, 0)
                        knob.Position = UDim2.new(newPct, -12, 0.5, -12)
                        valLbl.Text = tostring(val)
                        saveElement(name, val)
                        if callback then callback(val) end
                    end
                end)
                
                table.insert(allElements, {name = name, frame = frame, tab = tab.name})
                updateSecSize()
                elements[name] = {
                    set = function(_, v)
                        val = math.clamp(v, min, max)
                        local pct = (val - min) / (max - min)
                        fill.Size = UDim2.new(pct, 0, 1, 0)
                        knob.Position = UDim2.new(pct, -10, 0.5, -10)
                        valLbl.Text = tostring(math.floor(val))
                    end,
                    get = function() return val end,
                    default = default or min
                }
                return elements[name]
            end
            
            function section:input(name, default, callback)
                local frame = create("Frame", {
                    Parent = holder,
                    Name = name,
                    BackgroundColor3 = Color3.fromRGB(22, 18, 34),
                    BackgroundTransparency = 0.3,
                    Size = UDim2.new(1, 0, 0, 42)
                })
                addCorner(frame, UDim.new(0, 10))
                addStroke(frame, Color3.fromRGB(50, 40, 75), 1, 0.7)
                
                local frameGrad = create("UIGradient", {
                    Parent = frame,
                    Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(18, 15, 32)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(14, 11, 24))
                    }),
                    Rotation = 90
                })
                
                local lbl = create("TextLabel", {
                    Parent = frame,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 14, 0, 0),
                    Size = UDim2.new(0.3, -14, 1, 0),
                    Font = Enum.Font.GothamBold,
                    Text = name,
                    TextColor3 = theme.text,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local box = create("Frame", {
                    Parent = frame,
                    BackgroundColor3 = Color3.fromRGB(22, 18, 38),
                    BorderSizePixel = 0,
                    Position = UDim2.new(0.32, 0, 0.5, -15),
                    Size = UDim2.new(0.68, -14, 0, 30)
                })
                addCorner(box, UDim.new(0, 6))
                addStroke(box, Color3.fromRGB(55, 45, 85), 1, 0.7)
                
                local inp = create("TextBox", {
                    Parent = box,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 12, 0, 0),
                    Size = UDim2.new(1, -24, 1, 0),
                    Font = Enum.Font.Gotham,
                    Text = "",
                    PlaceholderText = default or "",
                    PlaceholderColor3 = theme.textDark,
                    TextColor3 = theme.text,
                    TextSize = 12,
                    ClearTextOnFocus = false,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                inp.Focused:Connect(function()
                    tw(box:FindFirstChild("UIStroke"), {Color = theme.accent, Transparency = 0.3}, 0.2)
                end)
                inp.FocusLost:Connect(function()
                    tw(box:FindFirstChild("UIStroke"), {Color = Color3.fromRGB(55, 45, 85), Transparency = 0.7}, 0.2)
                    if callback then callback(inp.Text) end
                end)
                
                table.insert(allElements, {name = name, frame = frame, tab = tab.name})
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
                    BackgroundColor3 = Color3.fromRGB(22, 18, 34),
                    BorderSizePixel = 0,
                    Size = UDim2.new(1, 0, 0, 44),
                    ClipsDescendants = true
                })
                addCorner(frame, UDim.new(0, 10))
                addStroke(frame, Color3.fromRGB(50, 40, 75), 1, 0.7)
                
                local frameGrad = create("UIGradient", {
                    Parent = frame,
                    Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(18, 15, 32)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(14, 11, 24))
                    }),
                    Rotation = 90
                })
                
                local header = create("TextButton", {
                    Parent = frame,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 44),
                    Text = "",
                    AutoButtonColor = false
                })
                
                local lbl = create("TextLabel", {
                    Parent = header,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 14, 0, 0),
                    Size = UDim2.new(0.4, -14, 1, 0),
                    Font = Enum.Font.GothamBold,
                    Text = name,
                    TextColor3 = theme.text,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local valBox = create("Frame", {
                    Parent = header,
                    BackgroundColor3 = Color3.fromRGB(22, 18, 38),
                    BackgroundTransparency = 0,
                    Position = UDim2.new(0.4, 0, 0.5, -14),
                    Size = UDim2.new(0.6, -18, 0, 28)
                })
                addCorner(valBox, UDim.new(0, 6))
                addStroke(valBox, Color3.fromRGB(55, 45, 85), 1, 0.7)
                
                local valLbl = create("TextLabel", {
                    Parent = valBox,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10, 0, 0),
                    Size = UDim2.new(1, -36, 1, 0),
                    Font = Enum.Font.GothamMedium,
                    Text = val or "Select...",
                    TextColor3 = val and theme.accent or theme.textDim,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextTruncate = Enum.TextTruncate.AtEnd
                })
                
                local arrow = create("ImageLabel", {
                    Parent = valBox,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, -22, 0.5, -6),
                    Size = UDim2.new(0, 12, 0, 12),
                    Image = "rbxassetid://6031091004",
                    ImageColor3 = theme.accent,
                    Rotation = 0
                })
                
                local optHolder = create("Frame", {
                    Parent = frame,
                    BackgroundColor3 = Color3.fromRGB(12, 10, 22),
                    BackgroundTransparency = 0,
                    Position = UDim2.new(0, 8, 0, 48),
                    Size = UDim2.new(1, -16, 0, #opts * 32)
                })
                addCorner(optHolder, UDim.new(0, 6))
                
                local optList = create("UIListLayout", {
                    Parent = optHolder,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Padding = UDim.new(0, 2)
                })
                addPadding(optHolder, 4, 4, 4, 4)
                
                for i, opt in ipairs(opts) do
                    local isSelected = (multi and selected and selected[opt]) or (not multi and val == opt)
                    
                    local optBtn = create("TextButton", {
                        Parent = optHolder,
                        BackgroundColor3 = isSelected and Color3.fromRGB(60, 40, 105) or Color3.fromRGB(18, 15, 32),
                        BackgroundTransparency = isSelected and 0.2 or 0.4,
                        BorderSizePixel = 0,
                        Size = UDim2.new(1, 0, 0, 28),
                        Font = Enum.Font.Gotham,
                        Text = "",
                        AutoButtonColor = false
                    })
                    addCorner(optBtn, UDim.new(0, 6))
                    
                    local optLbl = create("TextLabel", {
                        Parent = optBtn,
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 10, 0, 0),
                        Size = UDim2.new(1, -20, 1, 0),
                        Font = Enum.Font.GothamMedium,
                        Text = opt,
                        TextColor3 = isSelected and theme.accent or theme.textDim,
                        TextSize = 12,
                        TextXAlignment = Enum.TextXAlignment.Left
                    })
                    
                    local function updateOptColor()
                        local isSel = false
                        if multi then
                            isSel = selected and selected[opt]
                        else
                            isSel = val == opt
                        end
                        optLbl.TextColor3 = isSel and theme.accent or theme.textDim
                        optBtn.BackgroundTransparency = isSel and 0.2 or 0.3
                        optBtn.BackgroundColor3 = isSel and Color3.fromRGB(70, 45, 120) or Color3.fromRGB(22, 18, 40)
                    end
                    
                    updateOptColor()
                    
                    optBtn.MouseEnter:Connect(function()
                        tw(optBtn, {BackgroundTransparency = 0.1, BackgroundColor3 = Color3.fromRGB(80, 55, 140)}, 0.15)
                        tw(optLbl, {TextColor3 = theme.text}, 0.15)
                    end)
                    optBtn.MouseLeave:Connect(function()
                        local isSelected = multi and (selected and selected[opt]) or (val == opt)
                        local isSel = multi and (selected and selected[opt]) or (val == opt)
                        tw(optBtn, {BackgroundTransparency = isSel and 0.2 or 0.3, BackgroundColor3 = isSel and Color3.fromRGB(70, 45, 120) or Color3.fromRGB(22, 18, 40)}, 0.15)
                        tw(optLbl, {TextColor3 = isSel and theme.accent or theme.textDim}, 0.15)
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
                                    local lbl = child:FindFirstChildOfClass("TextLabel")
                                    local isSel = selected[lbl and lbl.Text or ""]
                                    if lbl then tw(lbl, {TextColor3 = isSel and theme.accent or theme.textDim}, 0.15) end
                                    tw(child, {BackgroundTransparency = isSel and 0.2 or 0.4, BackgroundColor3 = isSel and Color3.fromRGB(60, 40, 105) or Color3.fromRGB(18, 15, 32)}, 0.15)
                                end
                            end
                            if callback then callback(list) end
                        else
                            val = opt
                            valLbl.Text = opt
                            valLbl.TextColor3 = theme.accent
                            for _, child in pairs(optHolder:GetChildren()) do
                                if child:IsA("TextButton") then
                                    local lbl = child:FindFirstChildOfClass("TextLabel")
                                    local isSel = lbl and lbl.Text == val
                                    if lbl then tw(lbl, {TextColor3 = isSel and theme.accent or theme.textDim}, 0.15) end
                                    tw(child, {BackgroundTransparency = isSel and 0.2 or 0.4, BackgroundColor3 = isSel and Color3.fromRGB(60, 40, 105) or Color3.fromRGB(18, 15, 32)}, 0.15)
                                end
                            end
                            open = false
                            tw(frame, {Size = UDim2.new(1, 0, 0, 44)}, 0.2, Enum.EasingStyle.Quart)
                            tw(arrow, {Rotation = 0}, 0.2)
                            task.delay(0.2, updateSecSize)
                            if callback then callback(val) end
                        end
                    end)
                end
                
                header.MouseButton1Click:Connect(function()
                    open = not open
                    local h = open and (58 + #opts * 30 + 8) or 44
                    optHolder.Size = UDim2.new(1, -16, 0, #opts * 30 + 8)
                    tw(frame, {Size = UDim2.new(1, 0, 0, h)}, 0.2, Enum.EasingStyle.Quart)
                    tw(arrow, {Rotation = open and 180 or 0}, 0.2)
                    task.delay(0.2, updateSecSize)
                end)
                
                table.insert(allElements, {name = name, frame = frame, tab = tab.name})
                updateSecSize()
                return {
                    set = function(_, v) val = v valLbl.Text = v end,
                    get = function() return val end,
                    updateOptions = function(_, newOpts)
                        opts = newOpts
                        for _, child in pairs(optHolder:GetChildren()) do
                            if child:IsA("TextButton") then
                                child:Destroy()
                            end
                        end
                        for i, opt in ipairs(opts) do
                            local isSel = val == opt
                            local optBtn = create("TextButton", {
                                Parent = optHolder,
                                BackgroundColor3 = isSel and Color3.fromRGB(60, 40, 105) or Color3.fromRGB(18, 15, 32),
                                BackgroundTransparency = isSel and 0.2 or 0.4,
                                BorderSizePixel = 0,
                                Size = UDim2.new(1, 0, 0, 28),
                                Font = Enum.Font.Gotham,
                                Text = "",
                                AutoButtonColor = false
                            })
                            addCorner(optBtn, UDim.new(0, 6))
                            
                            local optLbl = create("TextLabel", {
                                Parent = optBtn,
                                BackgroundTransparency = 1,
                                Position = UDim2.new(0, 10, 0, 0),
                                Size = UDim2.new(1, -20, 1, 0),
                                Font = Enum.Font.GothamMedium,
                                Text = opt,
                                TextColor3 = isSel and theme.accent or theme.textDim,
                                TextSize = 12,
                                TextXAlignment = Enum.TextXAlignment.Left
                            })
                            
                            optBtn.MouseEnter:Connect(function()
                                tw(optBtn, {BackgroundTransparency = 0.1, BackgroundColor3 = Color3.fromRGB(70, 50, 125)}, 0.15)
                                tw(optLbl, {TextColor3 = theme.text}, 0.15)
                            end)
                            optBtn.MouseLeave:Connect(function()
                                local isSel = val == opt
                                tw(optBtn, {BackgroundTransparency = isSel and 0.2 or 0.4, BackgroundColor3 = isSel and Color3.fromRGB(60, 40, 105) or Color3.fromRGB(18, 15, 32)}, 0.15)
                                tw(optLbl, {TextColor3 = isSel and theme.accent or theme.textDim}, 0.15)
                            end)
                            optBtn.MouseButton1Click:Connect(function()
                                val = opt
                                valLbl.Text = opt
                                valLbl.TextColor3 = theme.accent
                                for _, child in pairs(optHolder:GetChildren()) do
                                    if child:IsA("TextButton") then
                                        local lbl = child:FindFirstChildOfClass("TextLabel")
                                        local isSel = lbl and lbl.Text == val
                                        if lbl then tw(lbl, {TextColor3 = isSel and theme.accent or theme.textDim}, 0.15) end
                                        tw(child, {BackgroundTransparency = isSel and 0.2 or 0.4, BackgroundColor3 = isSel and Color3.fromRGB(60, 40, 105) or Color3.fromRGB(18, 15, 32)}, 0.15)
                                    end
                                end
                                open = false
                                tw(frame, {Size = UDim2.new(1, 0, 0, 44)}, 0.2, Enum.EasingStyle.Quart)
                                tw(arrow, {Rotation = 0}, 0.2)
                                task.delay(0.2, updateSecSize)
                                if callback then callback(val) end
                            end)
                        end
                        optHolder.Size = UDim2.new(1, -16, 0, #opts * 30 + 8)
                    end
                }
            end
            
            function section:colorpicker(name, default, callback)
                local val = default or Color3.new(1, 1, 1)
                local open = false
                local h, s, v = val:ToHSV()
                
                local frame = create("Frame", {
                    Parent = holder,
                    Name = name,
                    BackgroundColor3 = Color3.fromRGB(22, 18, 34),
                    BorderSizePixel = 0,
                    Size = UDim2.new(1, 0, 0, 44),
                    ClipsDescendants = true
                })
                addCorner(frame, UDim.new(0, 10))
                addStroke(frame, Color3.fromRGB(50, 40, 75), 1, 0.7)
                
                local frameGrad = create("UIGradient", {
                    Parent = frame,
                    Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(18, 15, 32)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(14, 11, 24))
                    }),
                    Rotation = 90
                })
                
                local header = create("TextButton", {
                    Parent = frame,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 44),
                    Text = "",
                    AutoButtonColor = false
                })
                
                local lbl = create("TextLabel", {
                    Parent = header,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 14, 0, 0),
                    Size = UDim2.new(0.5, -14, 1, 0),
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
                    Position = UDim2.new(1, -80, 0.5, -12),
                    Size = UDim2.new(0, 65, 0, 24)
                })
                addCorner(preview, UDim.new(0, 6))
                addStroke(preview, Color3.fromRGB(theme.accent.R * 255 * 0.7, theme.accent.G * 255 * 0.7, theme.accent.B * 255 * 0.7), 1.5, 0.6)
                
                local hexLbl = create("TextLabel", {
                    Parent = preview,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    Font = Enum.Font.GothamBold,
                    Text = "#" .. val:ToHex():upper(),
                    TextColor3 = theme.text,
                    TextSize = 11
                })
                
                local picker = create("Frame", {
                    Parent = frame,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 14, 0, 50),
                    Size = UDim2.new(1, -28, 0, 130),
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
                
                rBox.FocusLost:Connect(function()
                    local num = tonumber(rBox.Text)
                    if num then
                        val = Color3.fromRGB(math.clamp(num, 0, 255), val.G * 255, val.B * 255)
                        h, s, v = val:ToHSV()
                        updateColor()
                    end
                end)
                
                gBox.FocusLost:Connect(function()
                    local num = tonumber(gBox.Text)
                    if num then
                        val = Color3.fromRGB(val.R * 255, math.clamp(num, 0, 255), val.B * 255)
                        h, s, v = val:ToHSV()
                        updateColor()
                    end
                end)
                
                bBox.FocusLost:Connect(function()
                    local num = tonumber(bBox.Text)
                    if num then
                        val = Color3.fromRGB(val.R * 255, val.G * 255, math.clamp(num, 0, 255))
                        h, s, v = val:ToHSV()
                        updateColor()
                    end
                end)
                
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
                    if #hex == 6 then
                        local ok, col = pcall(function() return Color3.fromHex(hex) end)
                        if ok and col then
                            val = col
                            h, s, v = val:ToHSV()
                            updateColor()
                        end
                    end
                end)
                
                header.MouseButton1Click:Connect(function()
                    open = not open
                    picker.Visible = open
                    satCursor.Visible = open
                    tw(frame, {Size = UDim2.new(1, 0, 0, open and 190 or 44)}, 0.25, Enum.EasingStyle.Quart)
                    task.delay(0.25, updateSecSize)
                end)
                
                table.insert(allElements, {name = name, frame = frame, tab = tab.name})
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
                    BackgroundColor3 = Color3.fromRGB(22, 18, 34),
                    BackgroundTransparency = 0.4,
                    Size = UDim2.new(1, 0, 0, 40)
                })
                addCorner(frame, UDim.new(0, 10))
                
                local lbl = create("TextLabel", {
                    Parent = frame,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 14, 0, 0),
                    Size = UDim2.new(0.5, -14, 1, 0),
                    Font = Enum.Font.GothamBold,
                    Text = name,
                    TextColor3 = theme.text,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local btn = create("TextButton", {
                    Parent = frame,
                    BackgroundColor3 = Color3.fromRGB(30, 25, 55),
                    BorderSizePixel = 0,
                    Position = UDim2.new(0.55, 0, 0.5, -14),
                    Size = UDim2.new(0.45, -14, 0, 28),
                    Font = Enum.Font.GothamBold,
                    Text = key and key.Name or "None",
                    TextColor3 = theme.accent,
                    TextSize = 12,
                    AutoButtonColor = false
                })
                addCorner(btn, UDim.new(0, 8))
                addStroke(btn, theme.accent, 1, 0.5)
                
                btn.MouseEnter:Connect(function()
                    tw(btn, {BackgroundColor3 = Color3.fromRGB(50, 40, 90)}, 0.15)
                end)
                btn.MouseLeave:Connect(function()
                    tw(btn, {BackgroundColor3 = Color3.fromRGB(30, 25, 55)}, 0.15)
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
                local lblFrame = create("Frame", {
                    Parent = holder,
                    BackgroundColor3 = theme.accent,
                    BackgroundTransparency = 0.92,
                    Size = UDim2.new(1, 0, 0, 28)
                })
                addCorner(lblFrame, UDim.new(0, 8))
                
                local lbl = create("TextLabel", {
                    Parent = lblFrame,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 12, 0, 0),
                    Size = UDim2.new(1, -24, 1, 0),
                    Font = Enum.Font.GothamMedium,
                    Text = text,
                    TextColor3 = theme.textDim,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                table.insert(allElements, {name = text, frame = lblFrame, tab = tab.name})
                updateSecSize()
                return {set = function(_, t) lbl.Text = t end}
            end
            
            return section
        end
        
        return tab
    end
    
    function window:notify(title, text, dur, type)
        local col = type == "error" and theme.red or type == "warning" and theme.orange or theme.accent
        dur = dur or 3
        
        local ypos = 0.85
        for i, n in ipairs(notifQueue) do
            if n and n.Parent then
                ypos = ypos - 0.11
            end
        end
        
        local notif = create("Frame", {
            Parent = gui,
            Name = "Notification",
            BackgroundColor3 = Color3.fromRGB(18, 14, 30),
            BorderSizePixel = 0,
            Position = UDim2.new(1, 20, ypos, 0),
            Size = UDim2.new(0, 320, 0, 80),
            AnchorPoint = Vector2.new(0, 0.5),
            ZIndex = 100
        })
        addCorner(notif, UDim.new(0, 14))
        addShadow(notif, 0.4)
        addStroke(notif, col, 2, 0.4)
        
        local notifIcon = create("Frame", {
            Parent = notif,
            BackgroundColor3 = col,
            BackgroundTransparency = 0.85,
            Position = UDim2.new(0, 14, 0.5, -18),
            Size = UDim2.new(0, 36, 0, 36)
        })
        addCorner(notifIcon, UDim.new(0, 10))
        
        local iconSymbol = create("TextLabel", {
            Parent = notifIcon,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Font = Enum.Font.GothamBlack,
            Text = type == "error" and "!" or type == "warning" and "⚠" or "✓",
            TextColor3 = col,
            TextSize = 18
        })
        
        create("TextLabel", {
            Parent = notif,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 60, 0, 14),
            Size = UDim2.new(1, -75, 0, 22),
            Font = Enum.Font.GothamBlack,
            Text = title,
            TextColor3 = col,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        
        create("TextLabel", {
            Parent = notif,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 60, 0, 38),
            Size = UDim2.new(1, -75, 0, 28),
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
            BackgroundTransparency = 0.3,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 1, -4),
            Size = UDim2.new(1, 0, 0, 4)
        })
        addCorner(progress, UDim.new(1, 0))
        
        table.insert(notifQueue, notif)
        
        tw(notif, {Position = UDim2.new(1, -330, ypos, 0)}, 0.4, Enum.EasingStyle.Back)
        tw(progress, {Size = UDim2.new(0, 0, 0, 4)}, dur, Enum.EasingStyle.Linear)
        
        task.delay(dur, function()
            tw(notif, {Position = UDim2.new(1, 20, ypos, 0)}, 0.3, Enum.EasingStyle.Quart)
            task.delay(0.35, function()
                for i, n in ipairs(notifQueue) do
                    if n == notif then
                        table.remove(notifQueue, i)
                        break
                    end
                end
                notif:Destroy()
                for i, n in ipairs(notifQueue) do
                    if n and n.Parent then
                        tw(n, {Position = UDim2.new(n.Position.X.Scale, n.Position.X.Offset, 0.85 - (i - 1) * 0.11, 0)}, 0.3, Enum.EasingStyle.Quart)
                    end
                end
            end)
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
            self:notify("Success", "Saved: " .. name, 2)
            if self.onConfigListUpdate then
                self.onConfigListUpdate()
            end
        else
            self:notify("Error", "Save failed", 2, "error")
        end
    end
    
    function window:loadConfig(name)
        autoSaveName = name
        autoSave = true
        local success, err = pcall(function()
            if not isfile then return end
            local path = self.cfgFolder .. "/" .. name .. ".json"
            if isfile(path) then
                local data = readfile(path)
                self.cfgData = game:GetService("HttpService"):JSONDecode(data)
                cfgData = self.cfgData
                for k, v in pairs(self.cfgData) do
                    if self.elements and self.elements[k] then
                        self.elements[k]:set(v)
                    end
                end
            end
        end)
        if success then
            self:notify("Config", "Loaded: " .. name .. " (AutoSave ON)", 2)
            if self.onConfigLoad then
                self.onConfigLoad(name)
            end
            return true
        else
            self:notify("Error", "Load failed", 2, "error")
            return false
        end
    end
    
    function window:createConfig(name)
        for k, el in pairs(self.elements) do
            if el.default ~= nil then
                el:set(el.default)
            end
        end
        self.cfgData = {}
        cfgData = {}
        autoSaveName = name
        autoSave = true
        self:saveConfig(name)
        self:notify("Config", "Created: " .. name, 2)
        if self.onConfigLoad then
            self.onConfigLoad(name)
        end
    end
    
    function window:deleteConfig(name)
        if not isfile or not delfile then return end
        local path = self.cfgFolder .. "/" .. name .. ".json"
        if not isfile(path) then 
            self:notify("Error", "Config not found", 2, "error")
            return 
        end
        local success = pcall(function()
            delfile(path)
        end)
        if success then
            self:notify("Success", "Deleted: " .. name, 2)
            if self.onConfigListUpdate then
                self.onConfigListUpdate()
            end
        else
            self:notify("Error", "Delete failed", 2, "error")
        end
    end
    
    function window:listConfigs()
        local configs = {}
        if not isfolder or not listfiles then return configs end
        if not isfolder(self.cfgFolder) then
            makefolder(self.cfgFolder)
        end
        local hasDefault = false
        for _, file in pairs(listfiles(self.cfgFolder)) do
            local name = file:match("([^/\\]+)%.json$")
            if name then 
                table.insert(configs, name)
                if name == "default" then hasDefault = true end
            end
        end
        if not hasDefault then
            self:saveConfig("default")
            table.insert(configs, "default")
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
            if self.onConfigListUpdate then
                self.onConfigListUpdate()
            end
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
