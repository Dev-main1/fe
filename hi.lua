local lib = {}
local csk = ColorSequenceKeypoint
local tw = game:GetService("TweenService")
local inp = game:GetService("UserInputService")
local run = game:GetService("RunService")
local light = game:GetService("Lighting")
local plrs = game:GetService("Players")
local plr = plrs.LocalPlayer
local mouse = plr:GetMouse()
local env = getgenv and getgenv() or _G
if env.loaded then return env.lib end
env.loaded = true
local icons = nil
pcall(function()
    icons = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/Icons/main/Main-v2.lua"))()
    icons.SetIconsType("lucide")
end)
local function geticon(name)
    if icons then
        local ok, res = pcall(function()
            return icons.Icon(name:lower(), nil, true)
        end)
        if ok and res then 
            if type(res) == "table" and res[1] then
                return res[1], res[2]
            elseif type(res) == "string" then
                return res, nil
            end
        end
    end
    return nil, nil
end
local fbicons = {
    home = "rbxassetid://7734053495",
    swords = "rbxassetid://7734053326",
    ["folder-cog"] = "rbxassetid://7734056813",
    settings = "rbxassetid://7734053426",
    user = "rbxassetid://7734053495",
    eye = "rbxassetid://7734053241",
    sparkles = "rbxassetid://7743878358",
    crosshair = "rbxassetid://7734056813",
    rocket = "rbxassetid://7072719338",
    aimbot = "rbxassetid://7734056813",
    showcase = "rbxassetid://7743878358",
    combat = "rbxassetid://7734053326",
    configs = "rbxassetid://7734056813",
    player = "rbxassetid://7734053495",
    visual = "rbxassetid://7734053241",
    misc = "rbxassetid://7743878358"
}
local function icon(lbl, name, fb)
    local img, rect = geticon(name)
    if img then
        lbl.Image = img
        if rect then
            lbl.ImageRectSize = rect.ImageRectSize or Vector2.new(0, 0)
            lbl.ImageRectOffset = rect.ImageRectPosition or Vector2.new(0, 0)
        else
            lbl.ImageRectSize = Vector2.new(0, 0)
            lbl.ImageRectOffset = Vector2.new(0, 0)
        end
    else
        local fb = fb or fbicons[name:lower()] or "rbxassetid://7734053495"
        lbl.Image = fb
        lbl.ImageRectSize = Vector2.new(0, 0)
        lbl.ImageRectOffset = Vector2.new(0, 0)
    end
end
local theme = {
    bg = Color3.fromRGB(12, 10, 18),
    sidebar = Color3.fromRGB(8, 6, 14),
    card = Color3.fromRGB(18, 15, 28),
    cardhover = Color3.fromRGB(35, 25, 55),
    accent = Color3.fromRGB(138, 90, 255),
    accentdark = Color3.fromRGB(98, 60, 200),
    text = Color3.fromRGB(245, 245, 250),
    textdim = Color3.fromRGB(120, 115, 140),
    textdark = Color3.fromRGB(70, 65, 90),
    border = Color3.fromRGB(40, 35, 60),
    red = Color3.fromRGB(255, 75, 95),
    orange = Color3.fromRGB(255, 160, 60),
    shadow = Color3.fromRGB(0, 0, 0)
}
local iconmap = {
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
local function tween(obj, props, dur, style, dir)
    local map = {
        bgc = "BackgroundColor3",
        bgt = "BackgroundTransparency",
        bsp = "BorderSizePixel",
        tc = "TextColor3",
        ts = "TextSize",
        it = "ImageTransparency",
        sz = "AbsoluteSize",
        pos = "AbsolutePosition",
        anchor = "AnchorPoint",
        clips = "ClipsDescendants",
        Visible = "Visible",
        Rotation = "Rotation",
        Position = "Position",
        Size = "Size",
        Transparency = "Transparency",
        Color = "Color",
        ImageColor3 = "ImageColor3"
    }
    local mapped = {}
    for k, v in pairs(props) do
        local prop = map[k] or k
        mapped[prop] = v
    end
    local info = TweenInfo.new(dur or 0.25, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out)
    local t = tw:Create(obj, info, mapped)
    t:Play()
    return t
end
local function create(cls, props)
    local obj = Instance.new(cls)
    local map = {
        bgc = "BackgroundColor3",
        bgt = "BackgroundTransparency",
        bsp = "BorderSizePixel",
        tc = "TextColor3",
        ts = "TextSize",
        it = "ImageTransparency",
        sz = "AbsoluteSize",
        pos = "AbsolutePosition",
        anchor = "AnchorPoint",
        clips = "ClipsDescendants",
        vis = "Visible",
        itype = "UserInputType",
        down1 = "MouseButton1Down",
        up1 = "MouseButton1Up",
        click = "MouseButton1Click",
        enter = "MouseEnter",
        leave = "MouseLeave",
        began = "InputBegan",
        ended = "InputEnded",
        changed = "Changed",
        lost = "FocusLost",
        wrap = "TextWrapped",
        csz = "AbsoluteContentSize"
    }
    for k, v in pairs(props) do
        if k ~= "Parent" then
            local prop = map[k] or k
            obj[prop] = v
        end
    end
    if props.Parent then obj.Parent = props.Parent end
    return obj
end
local function stroke(par, col, thick, trans)
    return create("UIStroke", {
        Parent = par,
        Color = col or theme.border,
        Thickness = thick or 1,
        Transparency = trans or 0.5
    })
end
local function corner(par, rad)
    return create("UICorner", {Parent = par, CornerRadius = rad or UDim.new(0, 8)})
end
local function padding(par, l, r, t, b)
    return create("UIPadding", {
        Parent = par,
        PaddingLeft = UDim.new(0, l or 0),
        PaddingRight = UDim.new(0, r or 0),
        PaddingTop = UDim.new(0, t or 0),
        PaddingBottom = UDim.new(0, b or 0)
    })
end
local function shadow(par, trans)
    return create("ImageLabel", {
        Parent = par,
        Name = "Shadow",
        bgt = 1,
        Position = UDim2.new(0, -20, 0, -20),
        Size = UDim2.new(1, 40, 1, 40),
        ZIndex = -1,
        Image = "rbxassetid://6014261993",
        ImageColor3 = theme.shadow,
        it = trans or 0.4,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(49, 49, 450, 450)
    })
end
local function ripple(par, x, y)
    local sz = par.sz
    local pos = par.pos
    local rx, ry = x - pos.X, y - pos.Y
    local max = math.max(sz.X, sz.Y) * 2.5
    local rip = create("Frame", {
        Parent = par,
        Name = "Ripple",
        bgc = theme.accent,
        bgt = 0.7,
        bsp = 0,
        Position = UDim2.new(0, rx, 0, ry),
        Size = UDim2.new(0, 0, 0, 0),
        anchor = Vector2.new(0.5, 0.5),
        ZIndex = 100
    })
    corner(rip, UDim.new(1, 0))
    tween(rip, {Size = UDim2.new(0, max, 0, max), bgt = 1}, 0.4, Enum.EasingStyle.Quad)
    task.delay(0.4, function() rip:Destroy() end)
end
local function hover(obj, prop, mult)
    mult = mult or 1.25
    local orig = obj[prop]
    obj.enter:Connect(function()
        local h, s, v = orig:ToHSV()
        tween(obj, {[prop] = Color3.fromHSV(h, s, v * mult)}, 0.2)
    end)
    obj.leave:Connect(function()
        tween(obj, {[prop] = orig}, 0.2)
    end)
end
local function click(obj, prop, div)
    div = div or 1.25
    local orig = obj[prop]
    obj.down1:Connect(function()
        local h, s, v = orig:ToHSV()
        tween(obj, {[prop] = Color3.fromHSV(h, s, v / div)}, 0.2)
    end)
    obj.up1:Connect(function()
        tween(obj, {[prop] = orig}, 0.2)
    end)
end
local function drag(point, target)
    local dragging, dinput, mpos, fpos
    local tinfo = TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    point.began:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging, mpos, fpos = true, input.Position, target.Position
        end
    end)
    point.changed:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dinput = input
        end
    end)
    inp.changed:Connect(function(input)
        if input == dinput and dragging then
            local delta = input.Position - mpos
            local t = tw:Create(target, tinfo, {Position = UDim2.new(fpos.X.Scale, fpos.X.Offset + delta.X, fpos.Y.Scale, fpos.Y.Offset + delta.Y)})
            t:Play()
        end
    end)
    inp.ended:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end
local function resize(target, minsize, maxsize, cursor)
    local resizing = false
    local edge = nil
    local startpos, startsize, startmouse
    local bounds = {
        {name = "left", check = function(m, t) return m.X >= t.X and m.X <= t.X + 8 and m.Y >= t.Y and m.Y <= t.Y + t.Height end},
        {name = "right", check = function(m, t) return m.X >= t.X + t.Width - 8 and m.X <= t.X + t.Width and m.Y >= t.Y and m.Y <= t.Y + t.Height end},
        {name = "top", check = function(m, t) return m.X >= t.X and m.X <= t.X + t.Width and m.Y >= t.Y and m.Y <= t.Y + 8 end},
        {name = "bottom", check = function(m, t) return m.X >= t.X and m.X <= t.X + t.Width and m.Y >= t.Y + t.Height - 8 and m.Y <= t.Y + t.Height end},
        {name = "topleft", check = function(m, t) return m.X >= t.X and m.X <= t.X + 12 and m.Y >= t.Y and m.Y <= t.Y + 12 end},
        {name = "topright", check = function(m, t) return m.X >= t.X + t.Width - 12 and m.X <= t.X + t.Width and m.Y >= t.Y and m.Y <= t.Y + 12 end},
        {name = "bottomleft", check = function(m, t) return m.X >= t.X and m.X <= t.X + 12 and m.Y >= t.Y + t.Height - 12 and m.Y <= t.Y + t.Height end},
        {name = "bottomright", check = function(m, t) return m.X >= t.X + t.Width - 12 and m.X <= t.X + t.Width and m.Y >= t.Y + t.Height - 12 and m.Y <= t.Y + t.Height end}
    }
    local cursors = {
        left = "rbxasset://SystemCursors/SizeEW",
        right = "rbxasset://SystemCursors/SizeEW",
        top = "rbxasset://SystemCursors/SizeNS",
        bottom = "rbxasset://SystemCursors/SizeNS",
        topleft = "rbxasset://SystemCursors/SizeNWSE",
        bottomright = "rbxasset://SystemCursors/SizeNWSE",
        topright = "rbxasset://SystemCursors/SizeNESW",
        bottomleft = "rbxasset://SystemCursors/SizeNESW"
    }
    run.RenderStepped:Connect(function()
        if resizing then return end
        local m = Vector2.new(mouse.X, mouse.Y)
        local t = {X = target.AbsolutePosition.X, Y = target.AbsolutePosition.Y, Width = target.AbsoluteSize.X, Height = target.AbsoluteSize.Y}
        local found = false
        for _, b in ipairs(bounds) do
            if b.check(m, t) then
                if cursor then cursor.Image = cursors[b.name] end
                mouse.Icon = cursors[b.name]
                found = true
                break
            end
        end
        if not found and cursor then
            cursor.Image = ""
            mouse.Icon = ""
        end
    end)
    inp.began:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local m = Vector2.new(mouse.X, mouse.Y)
            local t = {X = target.AbsolutePosition.X, Y = target.AbsolutePosition.Y, Width = target.AbsoluteSize.X, Height = target.AbsoluteSize.Y}
            for _, b in ipairs(bounds) do
                if b.check(m, t) then
                    resizing = true
                    edge = b.name
                    startpos = target.Position
                    startsize = target.Size
                    startmouse = m
                    break
                end
            end
        end
    end)
    inp.changed:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and resizing then
            local m = Vector2.new(mouse.X, mouse.Y)
            local delta = m - startmouse
            local parent = target.Parent.AbsoluteSize
            local newpos = startpos
            local newsize = startsize
            if edge:find("left") then
                newpos = UDim2.new(startpos.X.Scale, startpos.X.Offset + delta.X, newpos.Y.Scale, newpos.Y.Offset)
                newsize = UDim2.new(startsize.X.Scale, startsize.X.Offset - delta.X, newsize.Y.Scale, newsize.Y.Offset)
            end
            if edge:find("right") then
                newsize = UDim2.new(startsize.X.Scale, startsize.X.Offset + delta.X, newsize.Y.Scale, newsize.Y.Offset)
            end
            if edge:find("top") then
                newpos = UDim2.new(newpos.X.Scale, newpos.X.Offset, startpos.Y.Scale, startpos.Y.Offset + delta.Y)
                newsize = UDim2.new(newsize.X.Scale, newsize.X.Offset, startsize.Y.Scale, startsize.Y.Offset - delta.Y)
            end
            if edge:find("bottom") then
                newsize = UDim2.new(newsize.X.Scale, newsize.X.Offset, startsize.Y.Scale, startsize.Y.Offset + delta.Y)
            end
            local calcw = newsize.X.Offset
            local calch = newsize.Y.Offset
            if minsize then
                calcw = math.max(calcw, minsize.X.Offset)
                calch = math.max(calch, minsize.Y.Offset)
            end
            if maxsize then
                calcw = math.min(calcw, maxsize.X.Offset)
                calch = math.min(calch, maxsize.Y.Offset)
            end
            target.Size = UDim2.new(0, calcw, 0, calch)
            if edge:find("left") or edge:find("top") then
                target.Position = newpos
            end
        end
    end)
    inp.ended:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = false
            edge = nil
            if cursor then cursor.Image = "" end
            mouse.Icon = ""
        end
    end)
end
lib.icons = iconMap
function lib:init(title, sub)
    local gui = create("ScreenGui", {
        Name = "lib_" .. tostring(math.random(1000, 9999)),
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset = true
    })
    if gethui then
        gui.Parent = gethui()
    else
        gui.Parent = game:GetService("CoreGui")
    end
    local blur = create("BlurEffect", {
        Parent = light,
        Name = "libBlur",
        Size = 0
    })
    local loader = create("Frame", {
        Parent = gui,
        bgc = Color3.fromRGB(10, 8, 18),
        bgt = 0,
        bsp = 0,
        Size = UDim2.new(1, 0, 1, 0),
        ZIndex = 1000
    })
    local loaderlogo = create("Frame", {
        Parent = loader,
        bgt = 1,
        Position = UDim2.new(0.5, 0, 0.5, -80),
        Size = UDim2.new(0, 120, 0, 120),
        anchor = Vector2.new(0.5, 0.5)
    })
    local logoicon = create("ImageLabel", {
        Parent = loaderlogo,
        bgt = 1,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        anchor = Vector2.new(0.5, 0.5),
        Size = UDim2.new(0, 80, 0, 80),
        Image = "rbxassetid://7733715400",
        ImageColor3 = theme.accent,
        Rotation = 0
    })
    local logoglow = create("ImageLabel", {
        Parent = logoicon,
        bgt = 1,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        anchor = Vector2.new(0.5, 0.5),
        Size = UDim2.new(1.5, 0, 1.5, 0),
        Image = "rbxassetid://5028857084",
        ImageColor3 = theme.accent,
        it = 0.4,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(24, 24, 276, 276),
        ZIndex = 0
    })
    task.spawn(function()
        while loader and loader.Parent do
            tween(logoicon, {Rotation = 360}, 2, Enum.EasingStyle.Linear)
            task.wait(2)
            if logoicon and logoicon.Parent then
                logoicon.Rotation = 0
            else
                break
            end
        end
    end)
    local loadertitle = create("TextLabel", {
        Parent = loader,
        bgt = 1,
        Position = UDim2.new(0.5, 0, 0.5, 60),
        Size = UDim2.new(0, 400, 0, 30),
        anchor = Vector2.new(0.5, 0.5),
        Font = Enum.Font.GothamBlack,
        Text = title or "Loading...",
        tc = theme.text,
        ts = 24
    })
    local loaderbar = create("Frame", {
        Parent = loader,
        bgc = Color3.fromRGB(20, 16, 32),
        bsp = 0,
        Position = UDim2.new(0.5, 0, 0.5, 100),
        Size = UDim2.new(0, 300, 0, 6),
        anchor = Vector2.new(0.5, 0.5)
    })
    corner(loaderbar, UDim.new(1, 0))
    local loaderfill = create("Frame", {
        Parent = loaderbar,
        bgc = theme.accent,
        bsp = 0,
        Size = UDim2.new(0, 0, 1, 0)
    })
    corner(loaderfill, UDim.new(1, 0))
    local fillgrad = create("UIGradient", {
        Parent = loaderfill,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 60, 180)),
            ColorSequenceKeypoint.new(0.5, theme.accent),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 120, 255))
        }),
        Offset = Vector2.new(-1, 0)
    })
    task.spawn(function()
        while loaderfill and loaderfill.Parent do
            tween(fillgrad, {Offset = Vector2.new(1, 0)}, 1.5, Enum.EasingStyle.Linear)
            task.wait(1.5)
            if fillgrad and fillgrad.Parent then
                fillgrad.Offset = Vector2.new(-1, 0)
            else
                break
            end
        end
    end)
    local loadertxt = create("TextLabel", {
        Parent = loader,
        bgt = 1,
        Position = UDim2.new(0.5, 0, 0.5, 120),
        Size = UDim2.new(0, 300, 0, 20),
        anchor = Vector2.new(0.5, 0.5),
        Font = Enum.Font.Gotham,
        Text = "Initializing...",
        tc = theme.textDim,
        ts = 12
    })
    task.spawn(function()
        local stages = {
            {txt = "Initializing...", pct = 0.15},
            {txt = "Loading assets...", pct = 0.35},
            {txt = "Building interface...", pct = 0.60},
            {txt = "Applying effects...", pct = 0.80},
            {txt = "Finalizing...", pct = 0.95},
            {txt = "Ready!", pct = 1}
        }
        for _, stage in ipairs(stages) do
            loadertxt.Text = stage.txt
            tween(loaderfill, {Size = UDim2.new(stage.pct, 0, 1, 0)}, 0.4, Enum.EasingStyle.Quad)
            task.wait(0.3 + math.random() * 0.2)
        end
        task.wait(0.4)
        tween(logoglow, {it = 1, Size = UDim2.new(2.5, 0, 2.5, 0)}, 0.5, Enum.EasingStyle.Quad)
        tween(logoicon, {it = 1}, 0.5, Enum.EasingStyle.Quad)
        tween(loadertitle, {tc = theme.accent}, 0.3, Enum.EasingStyle.Quad)
        task.wait(0.2)
        tween(loaderbar, {bgt = 1}, 0.4, Enum.EasingStyle.Quad)
        tween(loadertxt, {tc = Color3.fromRGB(0, 0, 0)}, 0.4, Enum.EasingStyle.Quad)
        tween(loadertitle, {Position = UDim2.new(0.5, 0, 0.5, -100)}, 0.5, Enum.EasingStyle.Quad)
        task.wait(0.3)
        tween(loader, {bgt = 1}, 0.6, Enum.EasingStyle.Quad)
        task.wait(0.6)
        loader:Destroy()
    end)
    tween(blur, {Size = 6}, 1.5)
    local snowholder = create("Frame", {
        Parent = gui,
        bgt = 1,
        Size = UDim2.new(1, 0, 1, 0),
        ZIndex = 0,
        Visible = true
    })
    local snowflakes = {}
    for i = 1, 120 do
        local s = math.random(3, 7)
        local startX = math.random()
        local startY = math.random()
        local snow = create("Frame", {
            Parent = snowholder,
            bgc = Color3.fromRGB(255, 255, 255),
            bsp = 0,
            Position = UDim2.new(startX, 0, startY, 0),
            Size = UDim2.new(0, s, 0, s),
            bgt = math.random(20, 50) / 100,
            ZIndex = 0
        })
        corner(snow, UDim.new(1, 0))
        table.insert(snowflakes, {frame = snow, speedY = 0.0003 + math.random() * 0.0004, speedX = (math.random() - 0.5) * 0.0002, x = startX, y = startY, rot = math.random(0, 360)})
    end
    task.spawn(function()
        while gui and gui.Parent and snowholder do
            if snowholder.Visible then
                for _, data in ipairs(snowflakes) do
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
            end
            task.wait(0.016)
        end
    end)
    local size = {w = 680, h = 450}
    local main = create("Frame", {
        Parent = gui,
        Name = "Main",
        bgc = Color3.fromRGB(10, 8, 18),
        bsp = 0,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, 0, 0, 0),
        anchor = Vector2.new(0.5, 0.5),
        clips = true
    })
    corner(main, UDim.new(0, 14))
    shadow(main, 0.5)
    local stroke = create("UIStroke", {
        Parent = main,
        Color = theme.accent,
        Thickness = 1.5,
        Transparency = 0.5
    })
    task.spawn(function()
        while main and main.Parent do
            tween(stroke, {Transparency = 0.3, Thickness = 2}, 1.5)
            task.wait(1.5)
            tween(stroke, {Transparency = 0.6, Thickness = 1.5}, 1.5)
            task.wait(1.5)
        end
    end)
    local stars = {}
    for i = 1, 100 do
        local s = math.random(2, 5)
        local startX = math.random() * 1.1 - 0.05
        local startY = math.random()
        local star = create("Frame", {
            Parent = main,
            bgc = Color3.fromRGB(220 + math.random(0, 35), 200 + math.random(0, 55), 255),
            bsp = 0,
            Position = UDim2.new(startX, 0, startY, 0),
            Size = UDim2.new(0, s, 0, s),
            bgt = math.random(5, 35) / 100,
            ZIndex = 1
        })
        corner(star, UDim.new(1, 0))
        local glow = create("ImageLabel", {
            Parent = star,
            bgt = 1,
            Position = UDim2.new(0.5, 0, 0.5, 0),
            anchor = Vector2.new(0.5, 0.5),
            Size = UDim2.new(3, 0, 3, 0),
            Image = "rbxassetid://5028857084",
            ImageColor3 = Color3.fromRGB(180, 140, 255),
            it = 0.7,
            ScaleType = Enum.ScaleType.Slice,
            SliceCenter = Rect.new(24, 24, 276, 276),
            ZIndex = 0
        })
        table.insert(stars, {frame = star, speed = 0.00015 + math.random() * 0.0004, x = startX})
    end
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
    for _, data in ipairs(stars) do
        task.spawn(function()
            task.wait(math.random() * 2)
            while data.frame and data.frame.Parent do
                tween(data.frame, {bgt = 0.6}, 0.5 + math.random() * 0.5)
                task.wait(0.6 + math.random() * 0.6)
                tween(data.frame, {bgt = math.random(5, 25) / 100}, 0.5 + math.random() * 0.5)
                task.wait(0.6 + math.random() * 0.6)
            end
        end)
    end
    tween(main, {Size = UDim2.new(0, size.w, 0, size.h)}, 0.4, Enum.EasingStyle.Back)
    local sidebar = create("Frame", {
        Parent = main,
        Name = "Sidebar",
        bgc = Color3.fromRGB(14, 11, 24),
        bgt = 0.15,
        bsp = 0,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(0, 145, 1, 0),
        clips = true,
        ZIndex = 2
    })
    corner(sidebar, UDim.new(0, 14))
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
        bgt = 1,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(1, 0, 0, 70)
    })
    local logoIcon = create("ImageLabel", {
        Parent = logo,
        bgt = 1,
        Position = UDim2.new(0, 15, 0.5, -12),
        Size = UDim2.new(0, 24, 0, 24),
        Image = "rbxassetid://7733715400",
        ImageColor3 = theme.accent
    })
    local titleLbl = create("TextLabel", {
        Parent = logo,
        bgt = 1,
        Position = UDim2.new(0, 45, 0, 14),
        Size = UDim2.new(1, -50, 0, 22),
        Font = Enum.Font.GothamBlack,
        Text = title or "BioHazard",
        tc = theme.text,
        ts = 16,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    local subLbl = create("TextLabel", {
        Parent = logo,
        bgt = 1,
        Position = UDim2.new(0, 45, 0, 36),
        Size = UDim2.new(1, -50, 0, 16),
        Font = Enum.Font.GothamMedium,
        Text = sub or "Sneak Peek",
        tc = theme.textDim,
        ts = 12,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    local divider = create("Frame", {
        Parent = sidebar,
        bgc = theme.border,
        bgt = 0.5,
        bsp = 0,
        Position = UDim2.new(0.1, 0, 0, 70),
        Size = UDim2.new(0.8, 0, 0, 1)
    })
    local tabscr = create("ScrollingFrame", {
        Parent = sidebar,
        Name = "Tabs",
        bgt = 1,
        bsp = 0,
        Position = UDim2.new(0, 0, 0, 80),
        Size = UDim2.new(1, 0, 1, -80),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 0,
        ScrollingDirection = Enum.ScrollingDirection.Y
    })
    padding(tabscr, 10, 10, 5, 5)
    local tablist = create("UIListLayout", {
        Parent = tabscr,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 4)
    })
    local content = create("Frame", {
        Parent = main,
        Name = "Content",
        bgc = Color3.fromRGB(14, 12, 24),
        bgt = 0.1,
        bsp = 0,
        Position = UDim2.new(0, 145, 0, 0),
        Size = UDim2.new(1, -145, 1, 0),
        clips = true,
        ZIndex = 2
    })
    corner(content, UDim.new(0, 14))
    local contentGrad = create("UIGradient", {
        Parent = content,
        Color = ColorSequence.new({
            csk.new(0, Color3.fromRGB(18, 14, 30)),
            csk.new(1, Color3.fromRGB(10, 8, 18))
        }),
        Rotation = 180
    })
    local topbar = create("Frame", {
        Parent = content,
        Name = "Topbar",
        bgt = 1,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(1, 0, 0, 55)
    })
    local search = create("Frame", {
        Parent = topbar,
        Name = "Search",
        bgc = theme.card,
        bsp = 0,
        Position = UDim2.new(0, 15, 0.5, -17),
        Size = UDim2.new(0.55, -30, 0, 34)
    })
    corner(search, UDim.new(0, 8))
    stroke(search, theme.border, 1, 0.7)
    local searchIcon = create("ImageLabel", {
        Parent = search,
        bgt = 1,
        Position = UDim2.new(0, 12, 0.5, -8),
        Size = UDim2.new(0, 16, 0, 16),
        Image = "rbxassetid://10734898355",
        ImageColor3 = theme.textDim,
        Visible = false
    })
    local searchinput = create("TextBox", {
        Parent = search,
        bgt = 1,
        Position = UDim2.new(0, 12, 0, 0),
        Size = UDim2.new(1, -24, 1, 0),
        Font = Enum.Font.Gotham,
        PlaceholderText = "Search...",
        PlaceholderColor3 = theme.textDark,
        Text = "",
        tc = theme.text,
        ts = 13,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    searchinput.Focused:Connect(function()
        tween(search:find("UIStroke"), {Color = theme.accent, Transparency = 0.3}, 0.2)
    end)
    searchinput.lost:Connect(function()
        tween(search:find("UIStroke"), {Color = theme.border, Transparency = 0.7}, 0.2)
    end)
    local elems = {}
    local windowtabs = {}
    local activetab = nil
    searchinput:changed("Text"):Connect(function()
        local q = searchinput.Text:lower()
        if q ~= "" then
            for _, t in pairs(windowtabs) do
                if t.page then t.page.Visible = true end
            end
            for _, el in pairs(elems) do
                local match = el.name:lower():find(q, 1, true)
                el.frame.Visible = match
            end
        else
            for _, t in pairs(windowtabs) do
                if t.page then t.page.Visible = (t == windowtabs[activetab]) end
            end
            for _, el in pairs(elems) do
                el.frame.Visible = true
            end
        end
    end)
    local btns = create("Frame", {
        Parent = topbar,
        bgt = 1,
        Position = UDim2.new(1, -80, 0.5, -15),
        Size = UDim2.new(0, 70, 0, 30)
    })
    local timelbl = create("TextLabel", {
        Parent = topbar,
        bgt = 1,
        Position = UDim2.new(0.5, -60, 0, 0),
        Size = UDim2.new(0, 120, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = os.date("%H:%M:%S"),
        tc = theme.text,
        ts = 16,
        Visible = false
    })
    task.spawn(function()
        while timelbl and timelbl.Parent do
            if timelbl.Visible then
                timelbl.Text = os.date("%H:%M:%S")
            end
            task.wait(1)
        end
    end)
    local minbtn = create("TextButton", {
        Parent = btns,
        bgc = Color3.fromRGB(35, 25, 55),
        bsp = 0,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(0, 30, 0, 30),
        Text = "",
        AutoButtonColor = false
    })
    corner(minbtn, UDim.new(0, 8))
    local minIcon = create("Frame", {
        Parent = minbtn,
        bgc = theme.accent,
        bsp = 0,
        Position = UDim2.new(0.5, -6, 0.5, -1),
        Size = UDim2.new(0, 12, 0, 2)
    })
    corner(minIcon, UDim.new(1, 0))
    hover(minbtn, "bgc", 1.2)
    minbtn.enter:Connect(function()
        tween(minIcon, {bgc = theme.text}, 0.15)
    end)
    minbtn.leave:Connect(function()
        tween(minIcon, {bgc = theme.accent}, 0.15)
    end)
    click(minbtn, "bgc", 1.3)
    local closebtn = create("TextButton", {
        Parent = btns,
        bgc = Color3.fromRGB(35, 25, 55),
        bsp = 0,
        Position = UDim2.new(0, 40, 0, 0),
        Size = UDim2.new(0, 30, 0, 30),
        Text = "",
        AutoButtonColor = false
    })
    corner(closebtn, UDim.new(0, 8))
    local closeIcon = create("TextLabel", {
        Parent = closebtn,
        bgt = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = "×",
        tc = theme.accent,
        ts = 20
    })
    hover(closebtn, "bgc", 1.2)
    closebtn.enter:Connect(function()
        tween(closeIcon, {tc = theme.text}, 0.15)
    end)
    closebtn.leave:Connect(function()
        tween(closeIcon, {tc = theme.accent}, 0.15)
    end)
    click(closebtn, "bgc", 1.3)
    local pages = create("Frame", {
        Parent = content,
        Name = "Pages",
        bgt = 1,
        Position = UDim2.new(0, 0, 0, 55),
        Size = UDim2.new(1, 0, 1, -55),
        clips = true
    })
    local resize = create("TextButton", {
        Parent = main,
        bgt = 1,
        Position = UDim2.new(1, -20, 1, -20),
        Size = UDim2.new(0, 20, 0, 20),
        Text = "",
        AutoButtonColor = false,
        ZIndex = 10
    })
    local resizdots = create("Frame", {
        Parent = resize,
        bgt = 1,
        Size = UDim2.new(1, 0, 1, 0)
    })
    for i = 1, 3 do
        for j = 1, 3 do
            if i + j >= 4 then
                create("Frame", {
                    Parent = resizdots,
                    bgc = theme.textDark,
                    bsp = 0,
                    Position = UDim2.new(0, (i-1)*6 + 2, 0, (j-1)*6 + 2),
                    Size = UDim2.new(0, 3, 0, 3)
                })
            end
        end
    end
    local resiz, resizstart, startsize = false, nil, nil
    resize.enter:Connect(function()
        if not minim then
            for _, dot in pairs(resizdots:children()) do
                tween(dot, {bgc = theme.accent}, 0.15)
            end
        end
    end)
    resize.leave:Connect(function()
        if not resiz then
            for _, dot in pairs(resizdots:children()) do
                tween(dot, {bgc = theme.textDark}, 0.15)
            end
        end
    end)
    resize.began:Connect(function(inp)
        if inp.itype == Enum.itype.mb1 and not minim then
            resiz = true
            resizstart = inp.Position
            startsize = main.Size
        end
    end)
    input.ended:Connect(function(inp)
        if inp.itype == Enum.itype.mb1 and resiz then
            resiz = false
            for _, dot in pairs(resizdots:children()) do
                tween(dot, {bgc = theme.textDark}, 0.15)
            end
        end
    end)
    input.InputChanged:Connect(function(inp)
        if resiz and inp.itype == Enum.itype.MouseMovement and not minim then
            local delta = inp.Position - resizstart
            local newW = math.clamp(startsize.X.Offset + delta.X, 500, 1000)
            local newH = math.clamp(startsize.Y.Offset + delta.Y, 300, 700)
            main.Size = UDim2.new(0, newW, 0, newH)
            size.w = newW
            size.h = newH
        end
    end)
    local drag, dragstart, startpos
    topbar.began:Connect(function(inp)
        if inp.itype == Enum.itype.mb1 then
            drag = true
            dragstart = inp.Position
            startpos = main.Position
        end
    end)
    topbar.ended:Connect(function(inp)
        if inp.itype == Enum.itype.mb1 then
            drag = false
        end
    end)
    logo.began:Connect(function(inp)
        if inp.itype == Enum.itype.mb1 then
            drag = true
            dragstart = inp.Position
            startpos = main.Position
        end
    end)
    logo.ended:Connect(function(inp)
        if inp.itype == Enum.itype.mb1 then
            drag = false
        end
    end)
    sidebar.began:Connect(function(inp)
        if inp.itype == Enum.itype.mb1 then
            drag = true
            dragstart = inp.Position
            startpos = main.Position
        end
    end)
    sidebar.ended:Connect(function(inp)
        if inp.itype == Enum.itype.mb1 then
            drag = false
        end
    end)
    input.InputChanged:Connect(function(inp)
        if drag and inp.itype == Enum.itype.MouseMovement then
            local delta = inp.Position - dragstart
            main.Position = UDim2.new(startpos.X.Scale, startpos.X.Offset + delta.X, startpos.Y.Scale, startpos.Y.Offset + delta.Y)
        end
    end)
    local minim = false
    local vis = true
    local key = Enum.KeyCode.Insert
    local cool = false
    minbtn.click:Connect(function()
        minim = not minim
        resize.Visible = not minim
        search.Visible = not minim
        timelbl.Visible = minim
        if minim then
            tween(sidebar, {Size = UDim2.new(0, 0, 1, 0)}, 0.3, Enum.EasingStyle.Quart)
            tween(content, {Position = UDim2.new(0, 0, 0, 0), Size = UDim2.new(1, 0, 0, 55), bgt = 0.5}, 0.3, Enum.EasingStyle.Quart)
            tween(main, {Size = UDim2.new(0, 400, 0, 55)}, 0.3, Enum.EasingStyle.Quart)
            tween(blur, {Size = 0}, 0.25)
        else
            tween(sidebar, {Size = UDim2.new(0, 145, 1, 0)}, 0.3, Enum.EasingStyle.Quart)
            tween(content, {Position = UDim2.new(0, 145, 0, 0), Size = UDim2.new(1, -145, 1, 0), bgt = 0.1}, 0.3, Enum.EasingStyle.Quart)
            tween(main, {Size = UDim2.new(0, size.w, 0, size.h)}, 0.3, Enum.EasingStyle.Quart)
            tween(blur, {Size = 6}, 0.25)
        end
    end)
    local openGui = create("ScreenGui", {
        Name = "lib_openbtn",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset = true,
        DisplayOrder = 100
    })
    if gethui then
        openGui.Parent = gethui()
    else
        openGui.Parent = game:GetService("CoreGui")
    end
    local openbtn = create("TextButton", {
        Parent = openGui,
        Name = "OpenButton",
        bgc = theme.accent,
        bgt = 0.15,
        bsp = 0,
        Position = UDim2.new(0.5, -35, 0, 10),
        Size = UDim2.new(0, 70, 0, 70),
        Text = "",
        AutoButtonColor = false,
        vis = false
    })
    corner(openbtn, UDim.new(0, 14))
    shadow(openbtn, 0.3)
    stroke(openbtn, theme.accent, 2, 0.3)
    local openbtngrad = create("UIGradient", {
        Parent = openbtn,
        Color = ColorSequence.new({
            csk.new(0, Color3.fromRGB(160, 100, 255)),
            csk.new(0.5, Color3.fromRGB(138, 90, 255)),
            csk.new(1, Color3.fromRGB(100, 60, 200))
        }),
        Rotation = 45
    })
    local openbtnicon = create("ImageLabel", {
        Parent = openbtn,
        bgt = 1,
        Position = UDim2.new(0.5, -14, 0.5, -14),
        Size = UDim2.new(0, 28, 0, 28),
        Image = "rbxassetid://7072719338",
        ImageColor3 = theme.text,
        Rotation = -45
    })
    icon(openbtnicon, "rocket", "rbxassetid://7072719338")
    local openbtnglow = create("ImageLabel", {
        Parent = openbtn,
        bgt = 1,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        anchor = Vector2.new(0.5, 0.5),
        Size = UDim2.new(1, 30, 1, 30),
        Image = "rbxassetid://5028857084",
        ImageColor3 = theme.accent,
        it = 0.6,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(24, 24, 276, 276),
        ZIndex = 0
    })
    openbtn.enter:Connect(function()
        tween(openbtn, {bgt = 0, Size = UDim2.new(0, 75, 0, 75)}, 0.2)
        tween(openbtnicon, {Rotation = 0}, 0.3)
        tween(openbtnglow, {it = 0.3, Size = UDim2.new(1, 40, 1, 40)}, 0.2)
    end)
    openbtn.leave:Connect(function()
        tween(openbtn, {bgt = 0.15, Size = UDim2.new(0, 70, 0, 70)}, 0.2)
        tween(openbtnicon, {Rotation = -45}, 0.3)
        tween(openbtnglow, {it = 0.6, Size = UDim2.new(1, 30, 1, 30)}, 0.2)
    end)
    task.spawn(function()
        while openGui and openGui.Parent do
            if openbtn.Visible then
                local stroke = openbtn:find("UIStroke")
                if stroke then
                    tween(stroke, {Transparency = 0}, 0.8)
                    task.wait(0.8)
                    tween(stroke, {Transparency = 0.6}, 0.8)
                    task.wait(0.8)
                end
            else
                task.wait(0.5)
            end
        end
    end)
    openbtn.click:Connect(function()
        vis = true
        minim = false
        resize.Visible = true
        search.Visible = true
        timelbl.Visible = false
        openbtn.Visible = false
        main.Visible = true
        snowholder.Visible = true
        main.Size = UDim2.new(0, 0, 0, 0)
        sidebar.Size = UDim2.new(0, 145, 1, 0)
        content.Position = UDim2.new(0, 145, 0, 0)
        content.Size = UDim2.new(1, -145, 1, 0)
        content.bgt = 0.1
        tween(main, {Size = UDim2.new(0, size.w, 0, size.h)}, 0.4, Enum.EasingStyle.Back)
        tween(blur, {Size = 6}, 0.4)
    end)
    closebtn.click:Connect(function()
        vis = false
        snowholder.Visible = false
        tween(blur, {Size = 0}, 0.3)
        tween(main, {Size = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        task.delay(0.35, function()
            main.Visible = false
            openbtn.Visible = true
        end)
    end)
    input.began:Connect(function(key, gpe)
        if gpe then return end
        if key.KeyCode == key and not cool then
            cool = true
            task.delay(0.5, function() cool = false end)
            vis = not vis
            if vis then
                minim = false
                resize.Visible = true
                search.Visible = true
                timelbl.Visible = false
                openbtn.Visible = false
                main.Visible = true
                snowholder.Visible = true
                main.Size = UDim2.new(0, 0, 0, 0)
                sidebar.Size = UDim2.new(0, 145, 1, 0)
                content.Position = UDim2.new(0, 145, 0, 0)
                content.Size = UDim2.new(1, -145, 1, 0)
                content.bgt = 0.1
                tween(main, {Size = UDim2.new(0, size.w, 0, size.h)}, 0.4, Enum.EasingStyle.Back)
                tween(blur, {Size = 6}, 0.4)
            else
                snowholder.Visible = false
                tween(blur, {Size = 0}, 0.3)
                tween(main, {Size = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
                task.delay(0.35, function()
                    main.Visible = false
                    openbtn.Visible = true
                end)
            end
        end
    end)
    local cfg = {}
    local elements = {}
    local asave = false
    local asavename = "def"
    local notifs = {}
    local window = {
        gui = gui, 
        openGui = openGui,
        main = main,
        openbtn = openbtn,
        openbtnicon = openbtnicon,
        tabs = windowtabs, 
        activeTab = nil,
        cfgdir = "configs",
        cfg = cfg,
        elements = elements,
        onConfigListUpdate = nil
    }
    function window:setopenicon(imageId)
        if openbtnicon and imageId then
            openbtnicon.Image = imageId
        end
    end
    local function saveelem(key, value)
        cfg[key] = value
        if asave and asavename then
            task.delay(0.5, function()
                pcall(function()
                    if not writefile or not makefolder or not isfolder then return end
                    if not isfolder(window.cfgdir) then
                        makefolder(window.cfgdir)
                    end
                    local path = window.cfgdir .. "/" .. asavename .. ".json"
                    local data = game:GetService("HttpService"):JSONEncode(cfg)
                    writefile(path, data)
                end)
            end)
        end
    end
    function window:tab(name, icon)
        local tabbtn = create("TextButton", {
            Parent = tabscr,
            Name = name,
            bgc = Color3.fromRGB(138, 90, 255),
            bgt = 1,
            bsp = 0,
            Size = UDim2.new(1, 0, 0, 40),
            Text = "",
            AutoButtonColor = false
        })
        corner(tabbtn, UDim.new(0, 10))
        local tabglow = create("ImageLabel", {
            Parent = tabbtn,
            Name = "Glow",
            bgt = 1,
            Position = UDim2.new(0.5, 0, 0.5, 0),
            anchor = Vector2.new(0.5, 0.5),
            Size = UDim2.new(1, 20, 1, 20),
            Image = "rbxassetid://5028857084",
            ImageColor3 = theme.accent,
            it = 1,
            ScaleType = Enum.ScaleType.Slice,
            SliceCenter = Rect.new(24, 24, 276, 276),
            ZIndex = 0
        })
        local ind = create("Frame", {
            Parent = tabbtn,
            Name = "ind",
            bgc = theme.accent,
            bsp = 0,
            Position = UDim2.new(0, 2, 0.2, 0),
            Size = UDim2.new(0, 3, 0.6, 0),
            bgt = 1
        })
        corner(ind, UDim.new(1, 0))
        local indGlow = create("ImageLabel", {
            Parent = ind,
            bgt = 1,
            Position = UDim2.new(0.5, 0, 0.5, 0),
            anchor = Vector2.new(0.5, 0.5),
            Size = UDim2.new(0, 8, 1, 8),
            Image = "rbxassetid://5028857084",
            ImageColor3 = theme.accent,
            it = 1,
            ScaleType = Enum.ScaleType.Slice,
            SliceCenter = Rect.new(24, 24, 276, 276),
            ZIndex = 0
        })
        local isize = 18
        local iname = iconMap[name] or iconMap[icon] or name:lower()
        local img, rect = geticon(iname)
        local hasicon = img ~= nil or icon ~= nil
        local tabicon
        if hasicon then
            tabicon = create("ImageLabel", {
                Parent = tabbtn,
                bgt = 1,
                Position = UDim2.new(0, 12, 0.5, -isize/2),
                Size = UDim2.new(0, isize, 0, isize),
                Image = "",
                ImageColor3 = theme.textDim
            })
            if icon then
                tabicon.Image = icon
            else
                icon(tabicon, iname)
            end
        end
        local tablbl = create("TextLabel", {
            Parent = tabbtn,
            bgt = 1,
            Position = UDim2.new(0, hasicon and 36 or 12, 0, 0),
            Size = UDim2.new(1, hasicon and -44 or -20, 1, 0),
            Font = Enum.Font.GothamBold,
            Text = name,
            tc = theme.textDim,
            ts = 13,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        local page = create("ScrollingFrame", {
            Parent = pages,
            Name = name,
            bgt = 1,
            bsp = 0,
            Position = UDim2.new(0, 0, 0, 0),
            Size = UDim2.new(1, 0, 1, 0),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollBarThickness = 0,
            ScrollBarImageColor3 = theme.accent,
            ScrollBarit = 0.5,
            Visible = false,
            clips = true
        })
        padding(page, 15, 15, 10, 10)
        local pagelist = create("UIListLayout", {
            Parent = page,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 12)
        })
        local function upcanvas()
            page.CanvasSize = UDim2.new(0, 0, 0, pagelist.csz.Y + 25)
        end
        pagelist:changed("csz"):Connect(upcanvas)
        local function act()
            if window.activeTab == name then return end
            for _, t in pairs(window.tabs) do
                tween(t.btn, {bgt = 1}, 0.25)
                local ind = t.btn:find("ind")
                if ind then 
                    tween(ind, {bgt = 1}, 0.25)
                    local indGlow = ind:find("ImageLabel")
                    if indGlow then tween(indGlow, {it = 1}, 0.25) end
                end
                local glow = t.btn:find("Glow")
                if glow then tween(glow, {it = 1}, 0.25) end
                local txt = t.btn:find("TextLabel")
                if txt then tween(txt, {tc = theme.textDim}, 0.25) end
                local ico = t.btn:find("ImageLabel")
                if ico and ico.Name ~= "Glow" then tween(ico, {ImageColor3 = theme.textDim}, 0.25) end
                if t.page ~= page and t.page.Visible then
                    t.page.Visible = false
                end
            end
            tween(tabbtn, {bgt = 0.85}, 0.25)
            tween(ind, {bgt = 0}, 0.25)
            tween(indGlow, {it = 0.5}, 0.25)
            tween(tabglow, {it = 0.7}, 0.25)
            tween(tablbl, {tc = theme.text}, 0.25)
            if tabicon then tween(tabicon, {ImageColor3 = theme.accent}, 0.25) end
            page.Visible = true
            window.activeTab = name
            activetab = name
        end
        tabbtn.enter:Connect(function()
            if window.activeTab ~= name then
                tween(tabbtn, {bgt = 0.92}, 0.15)
                tween(tabglow, {it = 0.85}, 0.15)
            end
        end)
        tabbtn.leave:Connect(function()
            if window.activeTab ~= name then
                tween(tabbtn, {bgt = 1}, 0.15)
                tween(tabglow, {it = 1}, 0.15)
            end
        end)
        tabbtn.click:Connect(function()
            act()
        end)
        window.tabs[name] = {btn = tabbtn, page = page}
        if not window.activeTab then
            tween(tabbtn, {bgt = 0.85}, 0.2)
            tween(ind, {bgt = 0}, 0.2)
            tween(indGlow, {it = 0.5}, 0.2)
            tween(tabglow, {it = 0.7}, 0.2)
            tween(tablbl, {tc = theme.text}, 0.2)
            if tabicon then tween(tabicon, {ImageColor3 = theme.accent}, 0.2) end
            page.Visible = true
            window.activeTab = name
            activetab = name
        end
        tablist:changed("csz"):Connect(function()
            tabscr.CanvasSize = UDim2.new(0, 0, 0, tablist.csz.Y + 15)
        end)
        local tab = {}
        tab.name = name
        function tab:section(name)
            local sec = create("Frame", {
                Parent = page,
                Name = name,
                bgc = Color3.fromRGB(18, 15, 30),
                bsp = 0,
                Size = UDim2.new(1, 0, 0, 45),
                clips = true
            })
            corner(sec, UDim.new(0, 12))
            local secgrad = create("UIGradient", {
                Parent = sec,
                Color = ColorSequence.new({
                    csk.new(0, Color3.fromRGB(22, 18, 38)),
                    csk.new(1, Color3.fromRGB(14, 12, 24))
                }),
                Rotation = 135
            })
            local hline = create("Frame", {
                Parent = sec,
                Name = "hline",
                bgc = theme.accent,
                bgt = 0.7,
                bsp = 0,
                Position = UDim2.new(0, 15, 0, 44),
                Size = UDim2.new(1, -30, 0, 1)
            })
            local header = create("Frame", {
                Parent = sec,
                Name = "Header",
                bgt = 1,
                Size = UDim2.new(1, 0, 0, 45)
            })
            local secicon = create("Frame", {
                Parent = header,
                Name = "secicon",
                bgc = theme.accent,
                bgt = 0.85,
                bsp = 0,
                Position = UDim2.new(0, 12, 0.5, -12),
                Size = UDim2.new(0, 24, 0, 24)
            })
            corner(secicon, UDim.new(0, 6))
            local iconlbl = create("ImageLabel", {
                Parent = secicon,
                bgt = 1,
                Size = UDim2.new(0, 16, 0, 16),
                Position = UDim2.new(0.5, -8, 0.5, -8),
                ImageColor3 = theme.accent,
                it = 0,
                ScaleType = Enum.ScaleType.Fit,
                Image = ""
            })
            icon(iconlbl, name)
            local sectitle = create("TextLabel", {
                Parent = header,
                bgt = 1,
                Position = UDim2.new(0, 44, 0, 0),
                Size = UDim2.new(0.7, -44, 1, 0),
                Font = Enum.Font.GothamBlack,
                Text = name,
                tc = theme.text,
                ts = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            local expbtn = create("TextButton", {
                Parent = header,
                bgc = theme.accent,
                bgt = 0.9,
                Position = UDim2.new(1, -40, 0.5, -14),
                Size = UDim2.new(0, 28, 0, 28),
                Text = "",
                AutoButtonColor = false
            })
            corner(expbtn, UDim.new(0, 8))
            local expicon = create("ImageLabel", {
                Parent = expbtn,
                bgt = 1,
                Position = UDim2.new(0.5, -6, 0.5, -6),
                Size = UDim2.new(0, 12, 0, 12),
                Image = "rbxassetid://6031091004",
                ImageColor3 = theme.accent,
                Rotation = 0
            })
            expbtn.enter:Connect(function()
                tween(expbtn, {bgt = 0.8}, 0.15)
            end)
            expbtn.leave:Connect(function()
                tween(expbtn, {bgt = 0.9}, 0.15)
            end)
            local holder = create("Frame", {
                Parent = sec,
                Name = "Holder",
                bgt = 1,
                Position = UDim2.new(0, 15, 0, 54),
                Size = UDim2.new(1, -30, 0, 0)
            })
            local hlist = create("UIListLayout", {
                Parent = holder,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 12)
            })
            local expand = true
            local function upsecsize()
                local h = expand and (hlist.csz.Y + 72) or 45
                tween(sec, {Size = UDim2.new(1, 0, 0, h)}, 0.25, Enum.EasingStyle.Quart)
                tween(expicon, {Rotation = expand and 180 or 0}, 0.25)
                tween(hline, {bgt = expand and 0.7 or 1}, 0.25)
                task.delay(0.25, upcanvas)
            end
            hlist:changed("csz"):Connect(function()
                if expand then upsecsize() end
            end)
            expbtn.click:Connect(function()
                expand = not expand
                upsecsize()
            end)
            upsecsize()
            local section = {}
            function section:button(name, cb)
                local btn = create("TextButton", {
                    Parent = holder,
                    Name = name,
                    bgc = Color3.fromRGB(25, 20, 45),
                    bsp = 0,
                    Size = UDim2.new(1, 0, 0, 42),
                    Text = "",
                    AutoButtonColor = false,
                    clips = true
                })
                corner(btn, UDim.new(0, 10))
                local btngrad = create("UIGradient", {
                    Parent = btn,
                    Color = ColorSequence.new({
                        csk.new(0, Color3.fromRGB(30, 25, 55)),
                        csk.new(1, Color3.fromRGB(20, 16, 36))
                    }),
                    Rotation = 90
                })
                local btnicon = create("Frame", {
                    Parent = btn,
                    bgc = theme.accent,
                    bgt = 0.8,
                    bsp = 0,
                    Position = UDim2.new(0, 12, 0.5, -10),
                    Size = UDim2.new(0, 20, 0, 20)
                })
                corner(btnicon, UDim.new(0, 6))
                local iname = iconMap[name] or name:lower()
                local img, rect = geticon(iname)
                local btnarrow = img and create("ImageLabel", {
                    Parent = btnicon,
                    bgt = 1,
                    Size = UDim2.new(0, 14, 0, 14),
                    Position = UDim2.new(0.5, -7, 0.5, -7),
                    Image = "",
                    ImageColor3 = theme.accent,
                    ScaleType = Enum.ScaleType.Fit
                }) or create("TextLabel", {
                    Parent = btnicon,
                    bgt = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    Font = Enum.Font.GothamBold,
                    Text = "→",
                    tc = theme.accent,
                    ts = 14
                })
                if img and btnarrow:IsA("ImageLabel") then
                    icon(btnarrow, iname)
                end
                local btnlbl = create("TextLabel", {
                    Parent = btn,
                    bgt = 1,
                    Position = UDim2.new(0, 40, 0, 0),
                    Size = UDim2.new(1, -50, 1, 0),
                    Font = Enum.Font.GothamBold,
                    Text = name,
                    tc = theme.text,
                    ts = 13,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                hover(btn, "bgc", 1.15)
                btn.enter:Connect(function()
                    tween(btn:find("UIStroke"), {Color = theme.accent, Transparency = 0.3}, 0.2)
                    tween(btnicon, {bgc = Color3.new(1, 1, 1), bgt = 0.7}, 0.2)
                    if btnarrow:IsA("ImageLabel") then
                        tween(btnarrow, {ImageColor3 = Color3.new(1, 1, 1)}, 0.2)
                    else
                        tween(btnarrow, {tc = Color3.new(1, 1, 1)}, 0.2)
                    end
                    btngrad.Enabled = false
                end)
                btn.leave:Connect(function()
                    tween(btn:find("UIStroke"), {Color = Color3.fromRGB(80, 60, 120), Transparency = 0.6}, 0.2)
                    tween(btnicon, {bgc = theme.accent, bgt = 0.8}, 0.2)
                    if btnarrow:IsA("ImageLabel") then
                        tween(btnarrow, {ImageColor3 = theme.accent}, 0.2)
                    else
                        tween(btnarrow, {tc = theme.accent}, 0.2)
                    end
                    btngrad.Enabled = true
                end)
                click(btn, "bgc", 1.2)
                btn.click:Connect(function()
                    ripple(btn, mouse.X, mouse.Y)
                    if cb then cb() end
                end)
                table.insert(elems, {name = name, frame = btn, tab = tab.name})
                upsecsize()
                return btn
            end
            function section:toggle(name, def, cb)
                local val = def or false
                local frame = create("Frame", {
                    Parent = holder,
                    Name = name,
                    bgc = Color3.fromRGB(25, 20, 38),
                    bgt = 0.5,
                    Size = UDim2.new(1, 0, 0, 40)
                })
                corner(frame, UDim.new(0, 10))
                local lbl = create("TextLabel", {
                    Parent = frame,
                    bgt = 1,
                    Position = UDim2.new(0, 14, 0, 0),
                    Size = UDim2.new(0.65, 0, 1, 0),
                    Font = Enum.Font.GothamBold,
                    Text = name,
                    tc = theme.text,
                    ts = 13,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                local box = create("Frame", {
                    Parent = frame,
                    bgc = val and theme.accent or Color3.fromRGB(30, 25, 50),
                    bsp = 0,
                    Position = UDim2.new(1, -60, 0.5, -13),
                    Size = UDim2.new(0, 52, 0, 26)
                })
                corner(box, UDim.new(1, 0))
                local boxgrad = create("UIGradient", {
                    Parent = box,
                    Color = ColorSequence.new({
                        csk.new(0, Color3.fromRGB(100, 60, 180)),
                        csk.new(0.3, theme.accent),
                        csk.new(0.7, Color3.fromRGB(180, 120, 255)),
                        csk.new(1, Color3.fromRGB(100, 60, 180))
                    }),
                    Offset = Vector2.new(-1, 0),
                    Enabled = val
                })
                if val then
                    task.spawn(function()
                        while box and box.Parent and boxgrad.Enabled do
                            tween(boxgrad, {Offset = Vector2.new(1, 0)}, 1.5, Enum.EasingStyle.Linear)
                            task.wait(1.5)
                            if boxgrad.Enabled then
                                boxgrad.Offset = Vector2.new(-1, 0)
                            end
                        end
                    end)
                end
                local dot = create("Frame", {
                    Parent = box,
                    bgc = Color3.new(1, 1, 1),
                    bsp = 0,
                    Position = val and UDim2.new(1, -24, 0.5, -10) or UDim2.new(0, 3, 0.5, -10),
                    Size = UDim2.new(0, 20, 0, 20)
                })
                corner(dot, UDim.new(1, 0))
                local dotshadow = create("ImageLabel", {
                    Parent = dot,
                    bgt = 1,
                    Position = UDim2.new(0.5, 0, 0.5, 2),
                    anchor = Vector2.new(0.5, 0.5),
                    Size = UDim2.new(1, 10, 1, 10),
                    Image = "rbxassetid://5028857084",
                    ImageColor3 = Color3.new(0, 0, 0),
                    it = 0.6,
                    ScaleType = Enum.ScaleType.Slice,
                    SliceCenter = Rect.new(24, 24, 276, 276),
                    ZIndex = 0
                })
                local btn = create("TextButton", {
                    Parent = frame,
                    bgt = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    Text = ""
                })
                local function update()
                    tween(box, {bgc = val and theme.accent or Color3.fromRGB(30, 25, 50)}, 0.25)
                    tween(box:find("UIStroke"), {Color = val and theme.accent or Color3.fromRGB(60, 50, 90), Transparency = val and 0.3 or 0.5}, 0.25)
                    tween(dot, {Position = val and UDim2.new(1, -24, 0.5, -10) or UDim2.new(0, 3, 0.5, -10)}, 0.25, Enum.EasingStyle.Back)
                    boxgrad.Enabled = val
                    if val then
                        task.spawn(function()
                            while box and box.Parent and boxgrad.Enabled do
                                tween(boxgrad, {Offset = Vector2.new(1, 0)}, 1.5, Enum.EasingStyle.Linear)
                                task.wait(1.5)
                                if boxgrad.Enabled then
                                    boxgrad.Offset = Vector2.new(-1, 0)
                                end
                            end
                        end)
                    end
                end
                btn.click:Connect(function()
                    val = not val
                    update()
                    saveelem(name, val)
                    if cb then cb(val) end
                end)
                table.insert(elems, {name = name, frame = frame, tab = tab.name})
                upsecsize()
                elements[name] = {
                    set = function(_, v) val = v update() end,
                    get = function() return val end,
                    def = def or false
                }
                return elements[name]
            end
            function section:slider(name, min, max, def, cb)
                local val = def or min
                local frame = create("Frame", {
                    Parent = holder,
                    Name = name,
                    bgc = Color3.fromRGB(25, 20, 38),
                    bgt = 0.5,
                    Size = UDim2.new(1, 0, 0, 68)
                })
                corner(frame, UDim.new(0, 10))
                local top = create("Frame", {
                    Parent = frame,
                    bgt = 1,
                    Position = UDim2.new(0, 14, 0, 0),
                    Size = UDim2.new(1, -28, 0, 28)
                })
                local lbl = create("TextLabel", {
                    Parent = top,
                    bgt = 1,
                    Size = UDim2.new(0.5, 0, 1, 0),
                    Font = Enum.Font.GothamBold,
                    Text = name,
                    tc = theme.text,
                    ts = 13,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                local valbox = create("Frame", {
                    Parent = top,
                    bgc = theme.accent,
                    bgt = 0.85,
                    Position = UDim2.new(1, -50, 0.5, -10),
                    Size = UDim2.new(0, 50, 0, 20)
                })
                corner(valbox, UDim.new(0, 6))
                local vallbl = create("TextLabel", {
                    Parent = valbox,
                    bgt = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    Font = Enum.Font.GothamBold,
                    Text = tostring(math.floor(val)),
                    tc = theme.accent,
                    ts = 13
                })
                local bar = create("Frame", {
                    Parent = frame,
                    bgc = Color3.fromRGB(30, 25, 50),
                    bsp = 0,
                    Position = UDim2.new(0, 14, 0, 35),
                    Size = UDim2.new(1, -28, 0, 12)
                })
                corner(bar, UDim.new(1, 0))
                local fill = create("Frame", {
                    Parent = bar,
                    bgc = theme.accent,
                    bsp = 0,
                    Size = UDim2.new((val - min) / (max - min), 0, 1, 0)
                })
                corner(fill, UDim.new(1, 0))
                local fillgrad = create("UIGradient", {
                    Parent = fill,
                    Color = ColorSequence.new({
                        csk.new(0, Color3.fromRGB(100, 60, 180)),
                        csk.new(0.3, theme.accent),
                        csk.new(0.7, Color3.fromRGB(180, 120, 255)),
                        csk.new(1, Color3.fromRGB(100, 60, 180))
                    }),
                    Offset = Vector2.new(-1, 0)
                })
                task.spawn(function()
                    while fill and fill.Parent do
                        tween(fillgrad, {Offset = Vector2.new(1, 0)}, 1.5, Enum.EasingStyle.Linear)
                        task.wait(1.5)
                        fillgrad.Offset = Vector2.new(-1, 0)
                    end
                end)
                local pct = (val - min) / (max - min)
                local knob = create("Frame", {
                    Parent = bar,
                    bgc = Color3.new(1, 1, 1),
                    bsp = 0,
                    Position = UDim2.new(pct, -10, 0.5, -10),
                    Size = UDim2.new(0, 20, 0, 20),
                    ZIndex = 3
                })
                corner(knob, UDim.new(1, 0))
                local knobglow = create("ImageLabel", {
                    Parent = knob,
                    bgt = 1,
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    anchor = Vector2.new(0.5, 0.5),
                    Size = UDim2.new(1, 16, 1, 16),
                    Image = "rbxassetid://5028857084",
                    ImageColor3 = theme.accent,
                    it = 0.5,
                    ScaleType = Enum.ScaleType.Slice,
                    SliceCenter = Rect.new(24, 24, 276, 276),
                    ZIndex = 2
                })
                local minlbl = create("TextLabel", {
                    Parent = frame,
                    bgt = 1,
                    Position = UDim2.new(0, 14, 0, 52),
                    Size = UDim2.new(0.3, 0, 0, 14),
                    Font = Enum.Font.Gotham,
                    Text = tostring(min),
                    tc = theme.textDark,
                    ts = 11,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                local maxlbl = create("TextLabel", {
                    Parent = frame,
                    bgt = 1,
                    Position = UDim2.new(0.7, -14, 0, 52),
                    Size = UDim2.new(0.3, 0, 0, 14),
                    Font = Enum.Font.Gotham,
                    Text = tostring(max),
                    tc = theme.textDark,
                    ts = 11,
                    TextXAlignment = Enum.TextXAlignment.Right
                })
                local slide = false
                bar.began:Connect(function(inp)
                    if inp.itype == Enum.itype.mb1 then
                        slide = true
                        local npct = math.clamp((inp.Position.X - bar.pos.X) / bar.sz.X, 0, 1)
                        val = math.floor(min + (max - min) * npct)
                        fill.Size = UDim2.new(npct, 0, 1, 0)
                        knob.Position = UDim2.new(npct, -12, 0.5, -12)
                        knob.Size = UDim2.new(0, 24, 0, 24)
                        vallbl.Text = tostring(val)
                        saveelem(name, val)
                        if cb then cb(val) end
                    end
                end)
                input.ended:Connect(function(inp)
                    if inp.itype == Enum.itype.mb1 and slide then
                        slide = false
                        local cpct = (val - min) / (max - min)
                        tween(knob, {Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(cpct, -10, 0.5, -10)}, 0.15)
                        tween(knobglow, {it = 0.5, Size = UDim2.new(1, 16, 1, 16)}, 0.15)
                    end
                end)
                input.InputChanged:Connect(function(inp)
                    if slide and inp.itype == Enum.itype.MouseMovement then
                        local npct = math.clamp((inp.Position.X - bar.pos.X) / bar.sz.X, 0, 1)
                        val = math.floor(min + (max - min) * npct)
                        fill.Size = UDim2.new(npct, 0, 1, 0)
                        knob.Position = UDim2.new(npct, -12, 0.5, -12)
                        vallbl.Text = tostring(val)
                        saveelem(name, val)
                        if cb then cb(val) end
                    end
                end)
                table.insert(elems, {name = name, frame = frame, tab = tab.name})
                upsecsize()
                elements[name] = {
                    set = function(_, v)
                        val = math.clamp(v, min, max)
                        local pct = (val - min) / (max - min)
                        fill.Size = UDim2.new(pct, 0, 1, 0)
                        knob.Position = UDim2.new(pct, -10, 0.5, -10)
                        vallbl.Text = tostring(math.floor(val))
                    end,
                    get = function() return val end,
                    def = def or min
                }
                return elements[name]
            end
            function section:input(name, def, cb)
                local frame = create("Frame", {
                    Parent = holder,
                    Name = name,
                    bgc = Color3.fromRGB(22, 18, 34),
                    bgt = 0.3,
                    Size = UDim2.new(1, 0, 0, 42)
                })
                corner(frame, UDim.new(0, 10))
                local framegrad = create("UIGradient", {
                    Parent = frame,
                    Color = ColorSequence.new({
                        csk.new(0, Color3.fromRGB(18, 15, 32)),
                        csk.new(1, Color3.fromRGB(14, 11, 24))
                    }),
                    Rotation = 90
                })
                local lbl = create("TextLabel", {
                    Parent = frame,
                    bgt = 1,
                    Position = UDim2.new(0, 14, 0, 0),
                    Size = UDim2.new(0.3, -14, 1, 0),
                    Font = Enum.Font.GothamBold,
                    Text = name,
                    tc = theme.text,
                    ts = 13,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                local box = create("Frame", {
                    Parent = frame,
                    bgc = Color3.fromRGB(22, 18, 38),
                    bsp = 0,
                    Position = UDim2.new(0.32, 0, 0.5, -15),
                    Size = UDim2.new(0.68, -14, 0, 30)
                })
                corner(box, UDim.new(0, 6))
                local inp = create("TextBox", {
                    Parent = box,
                    bgt = 1,
                    Position = UDim2.new(0, 12, 0, 0),
                    Size = UDim2.new(1, -24, 1, 0),
                    Font = Enum.Font.Gotham,
                    Text = "",
                    PlaceholderText = def or "",
                    PlaceholderColor3 = theme.textDark,
                    tc = theme.text,
                    ts = 12,
                    ClearTextOnFocus = false,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                inp.Focused:Connect(function()
                    tween(box:find("UIStroke"), {Color = theme.accent, Transparency = 0.3}, 0.2)
                end)
                inp.lost:Connect(function()
                    tween(box:find("UIStroke"), {Color = Color3.fromRGB(55, 45, 85), Transparency = 0.7}, 0.2)
                    if cb then cb(inp.Text) end
                end)
                table.insert(elems, {name = name, frame = frame, tab = tab.name})
                upsecsize()
                return {
                    set = function(_, v) inp.Text = v end,
                    get = function() return inp.Text end
                }
            end
            function section:dropdown(name, opts, def, cb, multi)
                local val = def
                local open = false
                local sel = multi and {} or nil
                local frame = create("Frame", {
                    Parent = holder,
                    Name = name,
                    bgc = Color3.fromRGB(22, 18, 34),
                    bsp = 0,
                    Size = UDim2.new(1, 0, 0, 44),
                    clips = true
                })
                corner(frame, UDim.new(0, 10))
                local framegrad = create("UIGradient", {
                    Parent = frame,
                    Color = ColorSequence.new({
                        csk.new(0, Color3.fromRGB(18, 15, 32)),
                        csk.new(1, Color3.fromRGB(14, 11, 24))
                    }),
                    Rotation = 90
                })
                local header = create("TextButton", {
                    Parent = frame,
                    bgt = 1,
                    Size = UDim2.new(1, 0, 0, 44),
                    Text = "",
                    AutoButtonColor = false
                })
                local lbl = create("TextLabel", {
                    Parent = header,
                    bgt = 1,
                    Position = UDim2.new(0, 14, 0, 0),
                    Size = UDim2.new(0.4, -14, 1, 0),
                    Font = Enum.Font.GothamBold,
                    Text = name,
                    tc = theme.text,
                    ts = 13,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                local valbox = create("Frame", {
                    Parent = header,
                    bgc = Color3.fromRGB(22, 18, 38),
                    bgt = 0,
                    Position = UDim2.new(0.4, 0, 0.5, -14),
                    Size = UDim2.new(0.6, -18, 0, 28)
                })
                corner(valbox, UDim.new(0, 6))
                local vallbl = create("TextLabel", {
                    Parent = valbox,
                    bgt = 1,
                    Position = UDim2.new(0, 10, 0, 0),
                    Size = UDim2.new(1, -36, 1, 0),
                    Font = Enum.Font.GothamMedium,
                    Text = val or "Select...",
                    tc = val and theme.accent or theme.textDim,
                    ts = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextTruncate = Enum.TextTruncate.AtEnd
                })
                local arrow = create("ImageLabel", {
                    Parent = valbox,
                    bgt = 1,
                    Position = UDim2.new(1, -22, 0.5, -6),
                    Size = UDim2.new(0, 12, 0, 12),
                    Image = "rbxassetid://6031091004",
                    ImageColor3 = theme.accent,
                    Rotation = 0
                })
                local opthold = create("Frame", {
                    Parent = frame,
                    bgc = Color3.fromRGB(12, 10, 22),
                    bgt = 0,
                    Position = UDim2.new(0, 8, 0, 48),
                    Size = UDim2.new(1, -16, 0, #opts * 32)
                })
                corner(opthold, UDim.new(0, 6))
                local optlist = create("UIListLayout", {
                    Parent = opthold,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Padding = UDim.new(0, 2)
                })
                padding(opthold, 4, 4, 4, 4)
                for i, opt in ipairs(opts) do
                    local issel = (multi and sel and sel[opt]) or (not multi and val == opt)
                    local obtn = create("TextButton", {
                        Parent = opthold,
                        bgc = issel and Color3.fromRGB(60, 40, 105) or Color3.fromRGB(18, 15, 32),
                        bgt = issel and 0.2 or 0.4,
                        bsp = 0,
                        Size = UDim2.new(1, 0, 0, 28),
                        Font = Enum.Font.Gotham,
                        Text = "",
                        AutoButtonColor = false
                    })
                    corner(obtn, UDim.new(0, 6))
                    local olbl = create("TextLabel", {
                        Parent = obtn,
                        bgt = 1,
                        Position = UDim2.new(0, 10, 0, 0),
                        Size = UDim2.new(1, -20, 1, 0),
                        Font = Enum.Font.GothamMedium,
                        Text = opt,
                        tc = issel and theme.accent or theme.textDim,
                        ts = 12,
                        TextXAlignment = Enum.TextXAlignment.Left
                    })
                    local function upoptcolor()
                        local issel = false
                        if multi then
                            issel = sel and sel[opt]
                        else
                            issel = val == opt
                        end
                        olbl.tc = issel and theme.accent or theme.textDim
                        obtn.bgt = issel and 0.2 or 0.3
                        obtn.bgc = issel and Color3.fromRGB(70, 45, 120) or Color3.fromRGB(22, 18, 40)
                    end
                    upoptcolor()
                    obtn.enter:Connect(function()
                        tween(obtn, {bgt = 0.1, bgc = Color3.fromRGB(80, 55, 140)}, 0.15)
                        tween(olbl, {tc = theme.text}, 0.15)
                    end)
                    obtn.leave:Connect(function()
                        local issel = multi and (sel and sel[opt]) or (val == opt)
                        local issel = multi and (sel and sel[opt]) or (val == opt)
                        tween(obtn, {bgt = issel and 0.2 or 0.3, bgc = issel and Color3.fromRGB(70, 45, 120) or Color3.fromRGB(22, 18, 40)}, 0.15)
                        tween(olbl, {tc = issel and theme.accent or theme.textDim}, 0.15)
                    end)
                    obtn.click:Connect(function()
                        if multi then
                            if not sel then sel = {} end
                            sel[opt] = not sel[opt]
                            local list = {}
                            for k, v in pairs(sel) do
                                if v then table.insert(list, k) end
                            end
                            vallbl.Text = #list > 0 and table.concat(list, ", ") or "Select..."
                            vallbl.tc = #list > 0 and theme.accent or theme.textDim
                            for _, child in pairs(opthold:children()) do
                                if child:IsA("TextButton") then
                                    local lbl = child:findOfClass("TextLabel")
                                    local issel = sel[lbl and lbl.Text or ""]
                                    if lbl then tween(lbl, {tc = issel and theme.accent or theme.textDim}, 0.15) end
                                    tween(child, {bgt = issel and 0.2 or 0.4, bgc = issel and Color3.fromRGB(60, 40, 105) or Color3.fromRGB(18, 15, 32)}, 0.15)
                                end
                            end
                            if cb then cb(list) end
                        else
                            val = opt
                            vallbl.Text = opt
                            vallbl.tc = theme.accent
                            for _, child in pairs(opthold:children()) do
                                if child:IsA("TextButton") then
                                    local lbl = child:findOfClass("TextLabel")
                                    local issel = lbl and lbl.Text == val
                                    if lbl then tween(lbl, {tc = issel and theme.accent or theme.textDim}, 0.15) end
                                    tween(child, {bgt = issel and 0.2 or 0.4, bgc = issel and Color3.fromRGB(60, 40, 105) or Color3.fromRGB(18, 15, 32)}, 0.15)
                                end
                            end
                            open = false
                            tween(frame, {Size = UDim2.new(1, 0, 0, 44)}, 0.2, Enum.EasingStyle.Quart)
                            tween(arrow, {Rotation = 0}, 0.2)
                            task.delay(0.2, upsecsize)
                            if cb then cb(val) end
                        end
                    end)
                end
                header.click:Connect(function()
                    open = not open
                    local h = open and (58 + #opts * 30 + 8) or 44
                    opthold.Size = UDim2.new(1, -16, 0, #opts * 30 + 8)
                    tween(frame, {Size = UDim2.new(1, 0, 0, h)}, 0.2, Enum.EasingStyle.Quart)
                    tween(arrow, {Rotation = open and 180 or 0}, 0.2)
                    task.delay(0.2, upsecsize)
                end)
                table.insert(elems, {name = name, frame = frame, tab = tab.name})
                upsecsize()
                return {
                    set = function(_, v) val = v vallbl.Text = v end,
                    get = function() return val end,
                    upopts = function(_, nopts)
                        opts = nopts
                        for _, child in pairs(opthold:children()) do
                            if child:IsA("TextButton") then
                                child:Destroy()
                            end
                        end
                        for i, opt in ipairs(opts) do
                            local issel = val == opt
                            local obtn = create("TextButton", {
                                Parent = opthold,
                                bgc = issel and Color3.fromRGB(60, 40, 105) or Color3.fromRGB(18, 15, 32),
                                bgt = issel and 0.2 or 0.4,
                                bsp = 0,
                                Size = UDim2.new(1, 0, 0, 28),
                                Font = Enum.Font.Gotham,
                                Text = "",
                                AutoButtonColor = false
                            })
                            corner(obtn, UDim.new(0, 6))
                            local olbl = create("TextLabel", {
                                Parent = obtn,
                                bgt = 1,
                                Position = UDim2.new(0, 10, 0, 0),
                                Size = UDim2.new(1, -20, 1, 0),
                                Font = Enum.Font.GothamMedium,
                                Text = opt,
                                tc = issel and theme.accent or theme.textDim,
                                ts = 12,
                                TextXAlignment = Enum.TextXAlignment.Left
                            })
                            obtn.enter:Connect(function()
                                tween(obtn, {bgt = 0.1, bgc = Color3.fromRGB(70, 50, 125)}, 0.15)
                                tween(olbl, {tc = theme.text}, 0.15)
                            end)
                            obtn.leave:Connect(function()
                                local issel = val == opt
                                tween(obtn, {bgt = issel and 0.2 or 0.4, bgc = issel and Color3.fromRGB(60, 40, 105) or Color3.fromRGB(18, 15, 32)}, 0.15)
                                tween(olbl, {tc = issel and theme.accent or theme.textDim}, 0.15)
                            end)
                            obtn.click:Connect(function()
                                val = opt
                                vallbl.Text = opt
                                vallbl.tc = theme.accent
                                for _, child in pairs(opthold:children()) do
                                    if child:IsA("TextButton") then
                                        local lbl = child:findOfClass("TextLabel")
                                        local issel = lbl and lbl.Text == val
                                        if lbl then tween(lbl, {tc = issel and theme.accent or theme.textDim}, 0.15) end
                                        tween(child, {bgt = issel and 0.2 or 0.4, bgc = issel and Color3.fromRGB(60, 40, 105) or Color3.fromRGB(18, 15, 32)}, 0.15)
                                    end
                                end
                                open = false
                                tween(frame, {Size = UDim2.new(1, 0, 0, 44)}, 0.2, Enum.EasingStyle.Quart)
                                tween(arrow, {Rotation = 0}, 0.2)
                                task.delay(0.2, upsecsize)
                                if cb then cb(val) end
                            end)
                        end
                        opthold.Size = UDim2.new(1, -16, 0, #opts * 30 + 8)
                    end
                }
            end
            function section:colorpicker(name, def, cb)
                local val = def or Color3.new(1, 1, 1)
                local open = false
                local h, s, v = val:ToHSV()
                local frame = create("Frame", {
                    Parent = holder,
                    Name = name,
                    bgc = Color3.fromRGB(22, 18, 34),
                    bsp = 0,
                    Size = UDim2.new(1, 0, 0, 44),
                    clips = true
                })
                corner(frame, UDim.new(0, 10))
                local framegrad = create("UIGradient", {
                    Parent = frame,
                    Color = ColorSequence.new({
                        csk.new(0, Color3.fromRGB(18, 15, 32)),
                        csk.new(1, Color3.fromRGB(14, 11, 24))
                    }),
                    Rotation = 90
                })
                local header = create("TextButton", {
                    Parent = frame,
                    bgt = 1,
                    Size = UDim2.new(1, 0, 0, 44),
                    Text = "",
                    AutoButtonColor = false
                })
                local lbl = create("TextLabel", {
                    Parent = header,
                    bgt = 1,
                    Position = UDim2.new(0, 14, 0, 0),
                    Size = UDim2.new(0.5, -14, 1, 0),
                    Font = Enum.Font.GothamBold,
                    Text = name,
                    tc = theme.text,
                    ts = 13,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                local prev = create("Frame", {
                    Parent = header,
                    bgc = val,
                    bsp = 0,
                    Position = UDim2.new(1, -80, 0.5, -12),
                    Size = UDim2.new(0, 65, 0, 24)
                })
                corner(prev, UDim.new(0, 6))
                stroke(prev, Color3.fromRGB(theme.accent.R * 255 * 0.7, theme.accent.G * 255 * 0.7, theme.accent.B * 255 * 0.7), 1.5, 0.6)
                local hexlbl = create("TextLabel", {
                    Parent = prev,
                    bgt = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    Font = Enum.Font.GothamBold,
                    Text = "#" .. val:ToHex():upper(),
                    tc = theme.text,
                    ts = 11
                })
                local pick = create("Frame", {
                    Parent = frame,
                    bgt = 1,
                    Position = UDim2.new(0, 14, 0, 50),
                    Size = UDim2.new(1, -28, 0, 130),
                    Visible = false
                })
                local sat = create("ImageLabel", {
                    Parent = pick,
                    bgc = Color3.fromHSV(h, 1, 1),
                    bsp = 0,
                    Position = UDim2.new(0, 0, 0, 0),
                    Size = UDim2.new(0, 130, 0, 100),
                    Image = "rbxassetid://4155801252"
                })
                corner(sat, UDim.new(0, 6))
                local satc = create("Frame", {
                    Parent = sat,
                    bgc = theme.text,
                    bsp = 0,
                    Position = UDim2.new(s, -7, 1 - v, -7),
                    Size = UDim2.new(0, 14, 0, 14),
                    Visible = false
                })
                corner(satc, UDim.new(1, 0))
                stroke(satc, theme.shadow, 2, 0)
                local hueBar = create("Frame", {
                    Parent = pick,
                    bgc = Color3.new(1, 1, 1),
                    bsp = 0,
                    Position = UDim2.new(0, 140, 0, 0),
                    Size = UDim2.new(0, 20, 0, 100)
                })
                corner(hueBar, UDim.new(0, 6))
                create("UIGradient", {
                    Parent = hueBar,
                    Color = ColorSequence.new({
                        csk.new(0, Color3.fromRGB(255, 0, 0)),
                        csk.new(0.167, Color3.fromRGB(255, 255, 0)),
                        csk.new(0.333, Color3.fromRGB(0, 255, 0)),
                        csk.new(0.5, Color3.fromRGB(0, 255, 255)),
                        csk.new(0.667, Color3.fromRGB(0, 0, 255)),
                        csk.new(0.833, Color3.fromRGB(255, 0, 255)),
                        csk.new(1, Color3.fromRGB(255, 0, 0))
                    }),
                    Rotation = 90
                })
                local huec = create("Frame", {
                    Parent = hueBar,
                    bgc = theme.text,
                    bsp = 0,
                    Position = UDim2.new(0, -3, h, -4),
                    Size = UDim2.new(1, 6, 0, 8)
                })
                corner(huec, UDim.new(0, 4))
                local hexbox = create("TextBox", {
                    Parent = pick,
                    bgc = theme.card,
                    bsp = 0,
                    Position = UDim2.new(0, 170, 0, 0),
                    Size = UDim2.new(1, -170, 0, 30),
                    Font = Enum.Font.GothamMedium,
                    Text = "#" .. val:ToHex():upper(),
                    tc = theme.text,
                    ts = 12,
                    ClearTextOnFocus = false
                })
                corner(hexbox, UDim.new(0, 6))
                local rgbhold = create("Frame", {
                    Parent = pick,
                    bgt = 1,
                    Position = UDim2.new(0, 170, 0, 38),
                    Size = UDim2.new(1, -170, 0, 60)
                })
                local r, g, b = math.floor(val.R * 255), math.floor(val.G * 255), math.floor(val.B * 255)
                local function rgbinp(name, value, yPos)
                    local row = create("Frame", {
                        Parent = rgbhold,
                        bgt = 1,
                        Position = UDim2.new(0, 0, 0, yPos),
                        Size = UDim2.new(1, 0, 0, 18)
                    })
                    create("TextLabel", {
                        Parent = row,
                        bgt = 1,
                        Size = UDim2.new(0, 25, 1, 0),
                        Font = Enum.Font.GothamBold,
                        Text = name,
                        tc = theme.textDim,
                        ts = 11,
                        TextXAlignment = Enum.TextXAlignment.Left
                    })
                    local rbox = create("TextBox", {
                        Parent = row,
                        bgc = theme.card,
                        bsp = 0,
                        Position = UDim2.new(0, 30, 0, 0),
                        Size = UDim2.new(1, -30, 1, 0),
                        Font = Enum.Font.Gotham,
                        Text = tostring(value),
                        tc = theme.text,
                        ts = 11,
                        ClearTextOnFocus = false
                    })
                    corner(rbox, UDim.new(0, 4))
                    return rbox
                end
                local rBox = rgbinp("R:", r, 0)
                local gBox = rgbinp("G:", g, 21)
                local bBox = rgbinp("B:", b, 42)
                local function upcolor()
                    val = Color3.fromHSV(h, s, v)
                    prev.bgc = val
                    sat.bgc = Color3.fromHSV(h, 1, 1)
                    satc.Position = UDim2.new(s, -7, 1 - v, -7)
                    huec.Position = UDim2.new(0, -3, h, -4)
                    hexlbl.Text = "#" .. val:ToHex():upper()
                    hexbox.Text = "#" .. val:ToHex():upper()
                    rBox.Text = tostring(math.floor(val.R * 255))
                    gBox.Text = tostring(math.floor(val.G * 255))
                    bBox.Text = tostring(math.floor(val.B * 255))
                    if cb then cb(val) end
                end
                rBox.lost:Connect(function()
                    local num = tonumber(rBox.Text)
                    if num then
                        val = Color3.fromRGB(math.clamp(num, 0, 255), val.G * 255, val.B * 255)
                        h, s, v = val:ToHSV()
                        upcolor()
                    end
                end)
                gBox.lost:Connect(function()
                    local num = tonumber(gBox.Text)
                    if num then
                        val = Color3.fromRGB(val.R * 255, math.clamp(num, 0, 255), val.B * 255)
                        h, s, v = val:ToHSV()
                        upcolor()
                    end
                end)
                bBox.lost:Connect(function()
                    local num = tonumber(bBox.Text)
                    if num then
                        val = Color3.fromRGB(val.R * 255, val.G * 255, math.clamp(num, 0, 255))
                        h, s, v = val:ToHSV()
                        upcolor()
                    end
                end)
                local dragsat, draghue = false, false
                sat.began:Connect(function(inp)
                    if inp.itype == Enum.itype.mb1 then
                        dragsat = true
                    end
                end)
                hueBar.began:Connect(function(inp)
                    if inp.itype == Enum.itype.mb1 then
                        draghue = true
                    end
                end)
                input.ended:Connect(function(inp)
                    if inp.itype == Enum.itype.mb1 then
                        dragsat = false
                        draghue = false
                    end
                end)
                input.InputChanged:Connect(function(inp)
                    if inp.itype == Enum.itype.MouseMovement then
                        if dragsat then
                            s = math.clamp((inp.Position.X - sat.pos.X) / sat.sz.X, 0, 1)
                            v = 1 - math.clamp((inp.Position.Y - sat.pos.Y) / sat.sz.Y, 0, 1)
                            upcolor()
                        elseif draghue then
                            h = math.clamp((inp.Position.Y - hueBar.pos.Y) / hueBar.sz.Y, 0, 1)
                            upcolor()
                        end
                    end
                end)
                hexbox.lost:Connect(function()
                    local hex = hexbox.Text:gsub("#", "")
                    if #hex == 6 then
                        local ok, col = pcall(function() return Color3.fromHex(hex) end)
                        if ok and col then
                            val = col
                            h, s, v = val:ToHSV()
                            upcolor()
                        end
                    end
                end)
                header.click:Connect(function()
                    open = not open
                    pick.Visible = open
                    satc.Visible = open
                    tween(frame, {Size = UDim2.new(1, 0, 0, open and 190 or 44)}, 0.25, Enum.EasingStyle.Quart)
                    task.delay(0.25, upsecsize)
                end)
                table.insert(elems, {name = name, frame = frame, tab = tab.name})
                upsecsize()
                return {
                    set = function(_, c) val = c h, s, v = c:ToHSV() upcolor() end,
                    get = function() return val end
                }
            end
            function section:keybind(name, def, cb)
                local key = def
                local listen = false
                local frame = create("Frame", {
                    Parent = holder,
                    Name = name,
                    bgc = Color3.fromRGB(22, 18, 34),
                    bgt = 0.4,
                    Size = UDim2.new(1, 0, 0, 40)
                })
                corner(frame, UDim.new(0, 10))
                local lbl = create("TextLabel", {
                    Parent = frame,
                    bgt = 1,
                    Position = UDim2.new(0, 14, 0, 0),
                    Size = UDim2.new(0.5, -14, 1, 0),
                    Font = Enum.Font.GothamBold,
                    Text = name,
                    tc = theme.text,
                    ts = 13,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                local btn = create("TextButton", {
                    Parent = frame,
                    bgc = Color3.fromRGB(30, 25, 55),
                    bsp = 0,
                    Position = UDim2.new(0.55, 0, 0.5, -14),
                    Size = UDim2.new(0.45, -14, 0, 28),
                    Font = Enum.Font.GothamBold,
                    Text = key and key.Name or "None",
                    tc = theme.accent,
                    ts = 12,
                    AutoButtonColor = false
                })
                corner(btn, UDim.new(0, 8))
                btn.enter:Connect(function()
                    tween(btn, {bgc = Color3.fromRGB(50, 40, 90)}, 0.15)
                end)
                btn.leave:Connect(function()
                    tween(btn, {bgc = Color3.fromRGB(30, 25, 55)}, 0.15)
                end)
                btn.click:Connect(function()
                    listen = true
                    btn.Text = "..."
                    tween(btn:find("UIStroke"), {Color = theme.accent}, 0.15)
                end)
                input.began:Connect(function(inp, gpe)
                    if listen and inp.itype == Enum.itype.Keyboard then
                        key = inp.KeyCode
                        btn.Text = key.Name
                        listen = false
                        tween(btn:find("UIStroke"), {Color = theme.border}, 0.15)
                    elseif key and inp.KeyCode == key and not gpe then
                        if cb then cb() end
                    end
                end)
                table.insert(elems, {name = name, frame = frame})
                upsecsize()
                return {
                    set = function(_, k) key = k btn.Text = k and k.Name or "None" end,
                    get = function() return key end
                }
            end
            function section:label(text)
                local lblframe = create("Frame", {
                    Parent = holder,
                    bgc = theme.accent,
                    bgt = 0.92,
                    Size = UDim2.new(1, 0, 0, 28)
                })
                corner(lblframe, UDim.new(0, 8))
                local lbl = create("TextLabel", {
                    Parent = lblframe,
                    bgt = 1,
                    Position = UDim2.new(0, 12, 0, 0),
                    Size = UDim2.new(1, -24, 1, 0),
                    Font = Enum.Font.GothamMedium,
                    Text = text,
                    tc = theme.textDim,
                    ts = 12,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                table.insert(elems, {name = text, frame = lblframe, tab = tab.name})
                upsecsize()
                return {set = function(_, t) lbl.Text = t end}
            end
            function section:divider()
                local div = create("Frame", {
                    Parent = holder,
                    bgc = theme.border,
                    bgt = 0.4,
                    bsp = 0,
                    Size = UDim2.new(1, -40, 0, 1)
                })
                local divpad = create("Frame", {
                    Parent = holder,
                    bgt = 1,
                    Size = UDim2.new(1, 0, 0, 8)
                })
                div.Parent = divpad
                div.Position = UDim2.new(0, 20, 0.5, 0)
                upsecsize()
            end
            return section
        end
        return tab
    end
    function window:notify(title, text, dur, type)
        local col = type == "error" and theme.red or type == "warning" and theme.orange or theme.accent
        dur = dur or 3
        local ypos = 0.85
        for i, n in ipairs(notifs) do
            if n and n.Parent then
                ypos = ypos - 0.11
            end
        end
        local notif = create("Frame", {
            Parent = gui,
            Name = "notification",
            bgc = Color3.fromRGB(18, 14, 30),
            bsp = 0,
            Position = UDim2.new(1, 20, ypos, 0),
            Size = UDim2.new(0, 320, 0, 80),
            anchor = Vector2.new(0, 0.5),
            ZIndex = 100
        })
        corner(notif, UDim.new(0, 14))
        shadow(notif, 0.4)
        stroke(notif, col, 2, 0.4)
        local notifIcon = create("Frame", {
            Parent = notif,
            bgc = col,
            bgt = 0.85,
            Position = UDim2.new(0, 14, 0.5, -18),
            Size = UDim2.new(0, 36, 0, 36)
        })
        corner(notifIcon, UDim.new(0, 10))
        local iconSymbol = create("TextLabel", {
            Parent = notifIcon,
            bgt = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Font = Enum.Font.GothamBlack,
            Text = type == "error" and "!" or type == "warning" and "⚠" or "✓",
            tc = col,
            ts = 18
        })
        create("TextLabel", {
            Parent = notif,
            bgt = 1,
            Position = UDim2.new(0, 60, 0, 14),
            Size = UDim2.new(1, -75, 0, 22),
            Font = Enum.Font.GothamBlack,
            Text = title,
            tc = col,
            ts = 14,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        create("TextLabel", {
            Parent = notif,
            bgt = 1,
            Position = UDim2.new(0, 60, 0, 38),
            Size = UDim2.new(1, -75, 0, 28),
            Font = Enum.Font.Gotham,
            Text = text,
            tc = theme.textDim,
            ts = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            wrap = true
        })
        local progress = create("Frame", {
            Parent = notif,
            bgc = col,
            bgt = 0.3,
            bsp = 0,
            Position = UDim2.new(0, 0, 1, -4),
            Size = UDim2.new(1, 0, 0, 4)
        })
        corner(progress, UDim.new(1, 0))
        table.insert(notifs, notif)
        tween(notif, {Position = UDim2.new(1, -330, ypos, 0)}, 0.4, Enum.EasingStyle.Back)
        tween(progress, {Size = UDim2.new(0, 0, 0, 4)}, dur, Enum.EasingStyle.Linear)
        task.delay(dur, function()
            tween(notif, {Position = UDim2.new(1, 20, ypos, 0)}, 0.3, Enum.EasingStyle.Quart)
            task.delay(0.35, function()
                for i, n in ipairs(notifs) do
                    if n == notif then
                        table.remove(notifs, i)
                        break
                    end
                end
                notif:Destroy()
                for i, n in ipairs(notifs) do
                    if n and n.Parent then
                        tween(n, {Position = UDim2.new(n.Position.X.Scale, n.Position.X.Offset, 0.85 - (i - 1) * 0.11, 0)}, 0.3, Enum.EasingStyle.Quart)
                    end
                end
            end)
        end)
    end
    function window:destroy()
        tween(blur, {Size = 0}, 0.3)
        tween(main, {Size = UDim2.new(0, 0, 0, 0), bgt = 1}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        task.delay(0.35, function()
            gui:Destroy()
            blur:Destroy()
            env.loaded = false
        end)
    end
    function window:setcfgdir(folder)
        self.cfgdir = folder
    end
    function window:enableautosave(name)
        asave = true
        asavename = name or "asave"
    end
    function window:disableautosave()
        asave = false
    end
    function window:saveConfig(name)
        local success, err = pcall(function()
            if not isfolder then return end
            if not isfolder(self.cfgdir) then
                makefolder(self.cfgdir)
            end
            local path = self.cfgdir .. "/" .. name .. ".json"
            local data = game:GetService("HttpService"):JSONEncode(self.cfg)
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
        asavename = name
        asave = true
        local success, err = pcall(function()
            if not isfile then return end
            local path = self.cfgdir .. "/" .. name .. ".json"
            if isfile(path) then
                local data = readfile(path)
                self.cfg = game:GetService("HttpService"):JSONDecode(data)
                cfg = self.cfg
                for k, v in pairs(self.cfg) do
                    if self.elements and self.elements[k] then
                        self.elements[k]:set(v)
                    end
                end
            end
        end)
        if success then
            self:notify("Config", "Loaded: " .. name .. " (asave ON)", 2)
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
            if el.def ~= nil then
                el:set(el.def)
            end
        end
        self.cfg = {}
        cfg = {}
        asavename = name
        asave = true
        self:saveConfig(name)
        self:notify("Config", "Created: " .. name, 2)
        if self.onConfigLoad then
            self.onConfigLoad(name)
        end
    end
    function window:deleteConfig(name)
        if not isfile or not delfile then return end
        local path = self.cfgdir .. "/" .. name .. ".json"
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
        if not isfolder(self.cfgdir) then
            makefolder(self.cfgdir)
        end
        local hasDefault = false
        for _, file in pairs(listfiles(self.cfgdir)) do
            local name = file:match("([^/\\]+)%.json$")
            if name then 
                table.insert(configs, name)
                if name == "def" then hasDefault = true end
            end
        end
        if not hasDefault then
            self:saveConfig("def")
            table.insert(configs, "def")
        end
        return configs
    end
    function window:exportConfig(name)
        local success, result = pcall(function()
            if not isfile then return "" end
            local path = self.cfgdir .. "/" .. name .. ".json"
            if isfile(path) then
                local data = readfile(path)
                local clipboard = setclipboard or toclipboard or writeclipboard
                if clipboard then
                    clipboard(data)
                    return "clipboard"
                end
                return data
            end
            return ""
        end)
        if success then
            if result == "clipboard" then
                self:notify("Export", "Copied to clipboard", 2)
            elseif result ~= "" then
                self:notify("Export", "Config data ready", 2)
            end
            return result
        else
            self:notify("Error", "Export failed", 2, "error")
            return false
        end
    end
    function window:importConfig(name, data)
        local success = pcall(function()
            if not writefile or not isfolder then return end
            if not isfolder(self.cfgdir) then
                makefolder(self.cfgdir)
            end
            local path = self.cfgdir .. "/" .. name .. ".json"
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
    function window:setkey(key)
        key = key
    end
    function window:showOpenButton(show)
        openbtn.Visible = show
    end
    return window
end
env.lib = lib
return lib
