local code = game:HttpGet("https://raw.githubusercontent.com/Dev-main1/fe/refs/heads/main/hi.lua")
code = code:gsub("\\n", "\n")
local lib = loadstring(code)()

local win = lib:init("ToopsHub", "v1.0")

win:setToggleKey(Enum.KeyCode.RightShift)
win:setCfgFolder("ToopsHub/configs")

local main = win:tab("Main")
local combat = win:tab("Combat")
local configs = win:tab("Configs")

local showcase = main:section("Showcase")

showcase:colorpicker("Color Picker RGB", Color3.fromRGB(56, 156, 255), function(c) end)

showcase:colorpicker("Color Picker RGBA", Color3.fromRGB(255, 177, 40), function(c) end)

showcase:dropdown("Dropdown Solo", {"Option 1", "Option 2", "Option 3"}, nil, function(v) end)

showcase:dropdown("Dropdown Multi", {"Option A", "Option B", "Option C"}, nil, function(v) end, true)

showcase:input("Input", "HAHAHAHFGYUSV config 1", function(t) end)

showcase:slider("Slider", 0, 1000, 124, function(v) end)

showcase:toggle("Toggle", true, function(v) end)

showcase:button("Button", function()
    win:notify("Info", "Button clicked!", 2)
end)

local lorem = main:section("Lorem")

lorem:keybind("Keybind", Enum.KeyCode.F, function() end)

lorem:label("Some info text here")

local ipsum = main:section("Ipsum")

ipsum:toggle("Feature 1", false, function(v) end)

ipsum:slider("Speed", 0, 100, 50, function(v) end)

local aimbot = combat:section("Aimbot")

aimbot:toggle("Enabled", false, function(v) end)

aimbot:slider("FOV", 50, 500, 180, function(v) end)

aimbot:dropdown("Target Part", {"Head", "Torso", "Random"}, "Head", function(v) end)

aimbot:keybind("Aim Key", Enum.KeyCode.C, function() end)

local cfg_section = configs:section("Config System")

local cfg_name = "default"
local cfg_list = win:listConfigs() 
local loaded_cfg = nil

local cfg_dropdown = cfg_section:dropdown("Config List", cfg_list, "default", function(sel)
    cfg_name = sel
end)

win.onConfigListUpdate = function()
    cfg_list = win:listConfigs()
    cfg_dropdown:updateOptions(cfg_list)
end

win.onConfigLoad = function(name)
    loaded_cfg = name
end

cfg_section:input("New Config Name", "", function(t)
    cfg_name = t
end)

cfg_section:button("Create Config", function()
    if cfg_name ~= "" then
        win:createConfig(cfg_name)
    end
end)

cfg_section:button("Load Config", function()
    if cfg_name ~= "" then
        win:loadConfig(cfg_name)
    end
end)

cfg_section:button("Delete Config", function()
    if cfg_name ~= "" and cfg_name ~= "default" then
        win:deleteConfig(cfg_name)
        cfg_name = "default"
    end
end)

cfg_section:button("Export Config", function()
    if loaded_cfg and loaded_cfg ~= "" then
        win:exportConfig(loaded_cfg)
    end
end)

cfg_section:input("Import Config", "Paste JSON here", function(t)
    if t ~= "" then
        local import_name = cfg_name ~= "" and cfg_name or "imported_" .. os.time()
        win:importConfig(import_name, t)
    end
end)

cfg_section:label("AutoSave: ON after loading")
cfg_section:label("Toggle Menu: RightShift")
