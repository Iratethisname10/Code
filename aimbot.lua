-- this is airhub with a better looking ui
-- original air hub: https://github.com/Exunys/AirHub

local scriptLoadAt = tick()
warn('airhub+ started load')

loadstring(game:HttpGet('https://raw.githubusercontent.com/Iratethisname10/Code/main/aimbotLibrary.lua'))()
loadstring(game:HttpGet('https://raw.githubusercontent.com/Iratethisname10/Code/main/espLibrary.lua'))()

local Parts, Fonts, TracersType = {"Head", "HumanoidRootPart", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg", "LeftHand", "RightHand", "LeftLowerArm", "RightLowerArm", "LeftUpperArm", "RightUpperArm", "LeftFoot", "LeftLowerLeg", "UpperTorso", "LeftUpperLeg", "RightFoot", "RightLowerLeg", "LowerTorso", "RightUpperLeg"}, {"UI", "System", "Plex", "Monospace"}, {"Bottom", "Center", "Mouse"}
local Aimbot, WallHack = getgenv().aimbotLibrary, getgenv().espLibrary
local tablefind = table.find

local library = loadstring(game:HttpGet('https://raw.githubusercontent.com/Iratethisname10/Code/main/aztup-ui/ui-lib.lua'))()
library.title = 'AirHub with better ui'
library.gameName = 'aim bot'

local aimbot = library:AddTab('Aimbot')
local visuals = library:AddTab('Visuals')
local crosshair = library:AddTab('Crosshair')

local aimbotLeft = aimbot:AddColumn()
local aimbotRight = aimbot:AddColumn()

local visualsLeft = visuals:AddColumn()
local visualsRight = visuals:AddColumn()

local crosshairLeft = crosshair:AddColumn()
local crosshairRight = crosshair:AddColumn()

local values = aimbotLeft:AddSection('Values')
local checks = aimbotLeft:AddSection('Checks')
local thirdPerson = aimbotLeft:AddSection('Third Person')
local fovValues = aimbotRight:AddSection('Field Of View')
local fovAppearance = aimbotRight:AddSection('FOV Circle Appearance')

local wallHackChecks = visualsLeft:AddSection('Checks')
local espSettings = visualsLeft:AddSection('ESP Settings')
local boxesSettings = visualsLeft:AddSection('Boxes Settings')
local chamsSettings = visualsLeft:AddSection('Chams Settings')
local tracersSettings = visualsRight:AddSection('Tracers Settings')
local headDotsSettings = visualsRight:AddSection('Head Dots Settings')
local healthBarSettings = visualsRight:AddSection('Health Bar Settings')

local crosshairSettings = crosshairLeft:AddSection('Settings')
local crosshairSettingsCenterDot = crosshairRight:AddSection('Center Dot Settings')

--// Aimbot Values
values:AddToggle({
	text = 'Enabled',
	flag = 'aim bot enabled',
	value = Aimbot.Settings.Enabled,
	callback = function(t)
		Aimbot.Settings.Enabled = t
	end
})
values:AddToggle({
	text = 'Toggle',
	flag = 'aimbot toggle mode',
	value = Aimbot.Settings.Toggle,
	callback = function(t)
		Aimbot.Settings.Toggle = t
	end
})
values:AddList({
	text = 'Lock Part',
	flag = 'aimbot lock part',
	value = Parts[1],
	callback = function(val)
		Aimbot.Settings.LockPart = val
	end,
	values = Parts
})
values:AddBox({
	text = 'Hotkey',
	flag = 'aimbot hotkey',
	value = Aimbot.Settings.TriggerKey,
	callback = function(val)
		Aimbot.Settings.TriggerKey = val
	end
})
values:AddSlider({
	text = 'Sensitivity',
	flag = 'aimbot sensitivity',
	value = Aimbot.Settings.Sensitivity,
	callback = function(val)
		Aimbot.Settings.Sensitivity = val
	end,
	min = 0,
	max = 1,
	float = 0.01
})

--// Aimbot Checks
checks:AddToggle({
	text = 'Team Check',
	flag = 'aimbot team check',
	value = Aimbot.Settings.TeamCheck,
	callback = function(t)
		Aimbot.Settings.TeamCheck = t
	end
})
checks:AddToggle({
	text = 'Wall Check',
	flag = 'aimbot wall check',
	value = Aimbot.Settings.WallCheck,
	callback = function(t)
		Aimbot.Settings.WallCheck = t
	end
})
checks:AddToggle({
	text = 'Alive Check',
	flag = 'aimbot alive check',
	value = Aimbot.Settings.AliveCheck,
	callback = function(t)
		Aimbot.Settings.AliveCheck = t
	end
})

--// Aimbot ThirdPerson
thirdPerson:AddToggle({
	text = 'Enable Third Person',
	value = Aimbot.Settings.ThirdPerson,
	callback = function(t)
		Aimbot.Settings.ThirdPerson = t
	end
})
thirdPerson:AddSlider({
	text = 'Sensitivity',
	flag = 'Third Person Sensitivity',
	value = Aimbot.Settings.ThirdPersonSensitivity,
	callback = function(val)
		Aimbot.Settings.ThirdPersonSensitivity = val
	end,
	min = 0.1,
	max = 5,
	float = 0.01
})

--// FOV Settings Values
fovValues:AddToggle({
	text = "Enabled",
	flag = 'aimbot fov circle',
	value = Aimbot.FOVSettings.Enabled,
	callback = function(t)
		Aimbot.FOVSettings.Enabled = t
	end
})
fovValues:AddToggle({
	text = 'Visible',
	flag = 'aimbot fov circle visible',
	value = Aimbot.FOVSettings.Visible,
	callback = function(t)
		Aimbot.FOVSettings.Visible = t
	end
})
fovValues:AddSlider({
	text = 'Amount',
	flag = 'aimbot fov circle radius',
	value = Aimbot.FOVSettings.Amount,
	callback = function(val)
		Aimbot.FOVSettings.Amount = val
	end,
	min = 10,
	max = 300
})

--// FOV Settings Appearance
fovAppearance:AddToggle({
	text = 'Filled',
	flag = 'aimbot filled circle',
	value = Aimbot.FOVSettings.Filled,
	callback = function(t)
		Aimbot.FOVSettings.Filled = t
	end
})
fovAppearance:AddSlider({
	text = 'Transparency',
	flag = 'aimbot circle trans',
	value = Aimbot.FOVSettings.Transparency,
	callback = function(val)
		Aimbot.FOVSettings.Transparency = val
	end,
	min = 0,
	max = 1,
	float = 0.1
})
fovAppearance:AddSlider({
	text = 'Sides',
	flag = 'aimbot ciecle sides',
	value = Aimbot.FOVSettings.Sides,
	callback = function(val)
		Aimbot.FOVSettings.Sides = val
	end,
	min = 3,
	max = 60
})
fovAppearance:AddSlider({
	text = 'Thickness',
	flag = 'aimbot circle thick',
	value = Aimbot.FOVSettings.Thickness,
	callback = function(val)
		Aimbot.FOVSettings.Thickness = val
	end,
	min = 1,
	max = 50
})
fovAppearance:AddColor({
	text = 'Color',
	flag = 'aimbot circle color',
	value = Aimbot.FOVSettings.Color,
	callback = function(val)
		Aimbot.FOVSettings.Color = val
	end
})
fovAppearance:AddColor({
	text = 'Locked Color',
	flag = 'aimbot circle locked color',
	value = Aimbot.FOVSettings.LockedColor,
	callback = function(val)
		Aimbot.FOVSettings.LockedColor = val
	end
})

--// Wall Hack Settings
wallHackChecks:AddToggle({
	text = 'Enabled',
	flag = 'wall hack enabled',
	value = WallHack.Settings.Enabled,
	callback = function(t)
		WallHack.Settings.Enabled = t
	end
})
wallHackChecks:AddToggle({
	text = 'Team Check',
	flag = 'wall hack team check',
	value = WallHack.Settings.TeamCheck,
	callback = function(t)
		WallHack.Settings.TeamCheck = t
	end
})
wallHackChecks:AddToggle({
	text = 'Alive Check',
	flag = 'wall hack alive check',
	value = WallHack.Settings.AliveCheck,
	callback = function(t)
		WallHack.Settings.AliveCheck = t
	end
})

--// Visuals Settings
espSettings:AddToggle({
	text = 'Enabled',
	flag = 'text esp enabled',
	value = WallHack.Visuals.ESPSettings.Enabled,
	callback = function(t)
		WallHack.Visuals.ESPSettings.Enabled = t
	end
})
espSettings:AddToggle({
	text = 'Outline',
	flag = 'text esp outline',
	value = WallHack.Visuals.ESPSettings.Outline,
	callback = function(t)
		WallHack.Visuals.ESPSettings.Outline = t
	end
})
espSettings:AddToggle({
	text = 'Display Distance',
	flag = 'text esp display distance',
	value = WallHack.Visuals.ESPSettings.DisplayDistance,
	callback = function(t)
		WallHack.Visuals.ESPSettings.DisplayDistance = t
	end
})
espSettings:AddToggle({
	text = 'Display Health',
	flag = 'text esp display health',
	value = WallHack.Visuals.ESPSettings.DisplayHealth,
	callback = function(t)
		WallHack.Visuals.ESPSettings.DisplayHealth = t
	end
})
espSettings:AddToggle({
	text = 'Display Name',
	flag = 'text esp display name',
	value = WallHack.Visuals.ESPSettings.DisplayName,
	callback = function(t)
		WallHack.Visuals.ESPSettings.DisplayName = t
	end
})
espSettings:AddToggle({
	text = 'Display Tool',
	flag = 'text esp display Tool',
	value = WallHack.Visuals.ESPSettings.DisplayTool,
	callback = function(t)
		WallHack.Visuals.ESPSettings.DisplayTool = t
	end
})
espSettings:AddSlider({
	text = 'Offset',
	flag = 'text esp offset',
	value = WallHack.Visuals.ESPSettings.Offset,
	callback = function(val)
		WallHack.Visuals.ESPSettings.Offset = val
	end,
	min = -30,
	max = 30
})
espSettings:AddColor({
	text = 'Text Color',
	flag = 'text esp text color',
	value = WallHack.Visuals.ESPSettings.TextColor,
	callback = function(val)
		WallHack.Visuals.ESPSettings.TextColor = val
	end
})
espSettings:AddColor({
	text = 'Outline Color',
	flag = 'text esp outline color',
	value = WallHack.Visuals.ESPSettings.OutlineColor,
	callback = function(val)
		WallHack.Visuals.ESPSettings.OutlineColor = val
	end
})
espSettings:AddSlider({
	text = 'Text Transparency',
	flag = 'text esp text trans',
	value = WallHack.Visuals.ESPSettings.TextTransparency,
	callback = function(val)
		WallHack.Visuals.ESPSettings.TextTransparency = val
	end,
	min = 0,
	max = 1,
	float = 0.01
})
espSettings:AddSlider({
	text = 'Text Size',
	flag = 'text esp text size',
	value = WallHack.Visuals.ESPSettings.TextSize,
	callback = function(val)
		WallHack.Visuals.ESPSettings.TextSize = val
	end,
	min = 8,
	max = 24
})
espSettings:AddList({
	text = 'Text Font',
	flag = 'text esp text font',
	value = Fonts[WallHack.Visuals.ESPSettings.TextFont + 1],
	callback = function(val)
		WallHack.Visuals.ESPSettings.TextFont = Drawing.Fonts[val]
	end,
	values = Fonts
})

boxesSettings:AddToggle({
	text = 'Enabled',
	flag = 'box esp enabled',
	value = WallHack.Visuals.BoxSettings.Enabled,
	callback = function(t)
		WallHack.Visuals.BoxSettings.Enabled = t
	end
})
boxesSettings:AddSlider({
	text = 'Transparency',
	flag = 'box esp trans',
	value = WallHack.Visuals.BoxSettings.Transparency,
	callback = function(val)
		WallHack.Visuals.BoxSettings.Transparency = val
	end,
	min = 0,
	max = 1,
	float = 0.01
})
boxesSettings:AddSlider({
	text = 'Thickness',
	flag = 'box esp thick',
	value = WallHack.Visuals.BoxSettings.Thickness,
	callback = function(val)
		WallHack.Visuals.BoxSettings.Thickness = val
	end,
	min = 1,
	max = 5
})
boxesSettings:AddSlider({
	text = 'Scale Increase (For 3D)',
	flag = 'box esp scale',
	value = WallHack.Visuals.BoxSettings.Increase,
	callback = function(val)
		WallHack.Visuals.BoxSettings.Increase = val
	end,
	min = 1,
	max = 5
})
boxesSettings:AddColor({
	text = 'Color',
	flag = 'box esp color',
	value = WallHack.Visuals.BoxSettings.Color,
	callback = function(val)
		WallHack.Visuals.BoxSettings.Color = val
	end
})
boxesSettings:AddList({
	text = 'Type',
	flag = 'box esp type',
	value = WallHack.Visuals.BoxSettings.Type == 1 and "3D" or "2D",
	callback = function(val)
		WallHack.Visuals.BoxSettings.Type = val == "3D" and 1 or 2
	end,
	values = {"3D", "2D"}
})
boxesSettings:AddToggle({
	text = 'Filled (For 2D)',
	flag = 'box esp filled',
	value = WallHack.Visuals.BoxSettings.Filled,
	callback = function(t)
		WallHack.Visuals.BoxSettings.Filled = t
	end
})

chamsSettings:AddToggle({
	text = 'Enabled',
	flag = 'chams enabled',
	value = WallHack.Visuals.ChamsSettings.Enabled,
	callback = function(t)
		WallHack.Visuals.ChamsSettings.Enabled = t
	end
})
chamsSettings:AddToggle({
	text = 'Filled',
	flag = 'chams filled',
	value = WallHack.Visuals.ChamsSettings.Filled,
	callback = function(t)
		WallHack.Visuals.ChamsSettings.Filled = t
	end
})
chamsSettings:AddToggle({
	text = 'Entire Body (For R15 Rigs)',
	flag = 'chams whole body',
	value = WallHack.Visuals.ChamsSettings.EntireBody,
	callback = function(t)
		WallHack.Visuals.ChamsSettings.EntireBody = t
	end
})
chamsSettings:AddSlider({
	text = 'Transparency',
	flag = 'chams trans',
	value = WallHack.Visuals.ChamsSettings.Transparency,
	callback = function(val)
		WallHack.Visuals.ChamsSettings.Transparency = val
	end,
	min = 0,
	max = 1,
	float = 0.01
})
chamsSettings:AddSlider({
	text = 'Thickness',
	flag = 'chams thick',
	value = WallHack.Visuals.ChamsSettings.Thickness,
	callback = function(val)
		WallHack.Visuals.ChamsSettings.Thickness = val
	end,
	min = 0,
	max = 3
})
chamsSettings:AddColor({
	text = 'Color',
	flag = 'chams color',
	value = WallHack.Visuals.ChamsSettings.Color,
	callback = function(val)
		WallHack.Visuals.ChamsSettings.Color = val
	end
})

tracersSettings:AddToggle({
	text = 'Enabled',
	flag = 'tracers enabled',
	value = WallHack.Visuals.TracersSettings.Enabled,
	callback = function(val)
		WallHack.Visuals.TracersSettings.Enabled = val
	end
})
tracersSettings:AddSlider({
	text = 'Transparency',
	flag = 'tracer trans',
	value = WallHack.Visuals.TracersSettings.Transparency,
	callback = function(val)
		WallHack.Visuals.TracersSettings.Transparency = val
	end,
	min = 0,
	max = 1,
	float = 0.01
})
tracersSettings:AddSlider({
	text = 'Thickness',
	flag = 'tracer thickness',
	value = WallHack.Visuals.TracersSettings.Thickness,
	callback = function(val)
		WallHack.Visuals.TracersSettings.Thickness = val
	end,
	min = 1,
	max = 5
})
tracersSettings:AddColor({
	text = 'Color',
	flag = 'tracer color',
	value = WallHack.Visuals.TracersSettings.Color,
	callback = function(val)
		WallHack.Visuals.TracersSettings.Color = val
	end
})
tracersSettings:AddList({
	text = 'Start From',
	value = TracersType[WallHack.Visuals.TracersSettings.Type],
	callback = function(val)
		WallHack.Visuals.TracersSettings.Type = tablefind(TracersType, val)
	end,
	values = TracersType
})

headDotsSettings:AddToggle({
	text = 'Enabled',
	flag = 'head dot enabled',
	value = false,
	callback = function(t)
		WallHack.Visuals.HeadDotSettings.Enabled = t
	end
})
headDotsSettings:AddToggle({
	text = "Filled",
	value = WallHack.Visuals.HeadDotSettings.Filled,
	callback = function(t)
		WallHack.Visuals.HeadDotSettings.Filled = t
	end
})
headDotsSettings:AddSlider({
	text = 'Transparency',
	flag = 'head dot trans',
	value = WallHack.Visuals.HeadDotSettings.Transparency,
	callback = function(val)
		WallHack.Visuals.HeadDotSettings.Transparency = val
	end,
	min = 0,
	max = 1,
	float = 0.01
})
headDotsSettings:AddSlider({
	text = 'Thickness',
	flag = 'head dot thick',
	value = WallHack.Visuals.HeadDotSettings.Thickness,
	callback = function(val)
		WallHack.Visuals.HeadDotSettings.Thickness = val
	end,
	min = 1,
	max = 5
})
headDotsSettings:AddSlider({
	text = 'Sides',
	flag = 'head dot num sides',
	value = WallHack.Visuals.HeadDotSettings.Sides,
	callback = function(val)
		WallHack.Visuals.HeadDotSettings.Sides = val
	end,
	min = 3,
	max = 60
})
headDotsSettings:AddColor({
	text = 'Color',
	flag = 'head dot color',
	value = WallHack.Visuals.HeadDotSettings.Color,
	callback = function(val)
		WallHack.Visuals.HeadDotSettings.Color = val
	end
})

healthBarSettings:AddToggle({
	text = 'Enabled',
	flag = 'hb enabled',
	value = WallHack.Visuals.HealthBarSettings.Enabled,
	callback = function(t)
		WallHack.Visuals.HealthBarSettings.Enabled = t
	end
})
healthBarSettings:AddList({
	text = 'Position',
	flag = 'hb pos',
	value = WallHack.Visuals.HealthBarSettings.Type == 1 and "Top" or WallHack.Visuals.HealthBarSettings.Type == 2 and "Bottom" or WallHack.Visuals.HealthBarSettings.Type == 3 and "Left" or "Right",
	callback = function(val)
		WallHack.Visuals.HealthBarSettings.Type = val == "Top" and 1 or val == "Bottom" and 2 or New == "Left" and 3 or 4
	end,
	values = {"Top", "Bottom", "Left", "Right"}
})
healthBarSettings:AddSlider({
	text = 'Transparency',
	flag = 'hb trans',
	value = WallHack.Visuals.HealthBarSettings.Transparency,
	callback = function(val)
		WallHack.Visuals.HealthBarSettings.Transparency = val
	end,
	min = 0,
	max = 1,
	float = 0.01
})
healthBarSettings:AddSlider({
	text = 'Size',
	flag = 'hb size',
	value = WallHack.Visuals.HealthBarSettings.Size,
	callback = function(val)
		WallHack.Visuals.HealthBarSettings.Size = New
	end,
	min = 2,
	max = 10
})
healthBarSettings:AddSlider({
	text = 'Blue',
	flag = 'hp blue',
	value = WallHack.Visuals.HealthBarSettings.Blue,
	callback = function(val)
		WallHack.Visuals.HealthBarSettings.Blue = val
	end,
	min = 0,
	max = 255
})
healthBarSettings:AddSlider({
	text = 'Offset',
	flag = 'hb offset',
	value = WallHack.Visuals.HealthBarSettings.Offset,
	callback = function(val)
		WallHack.Visuals.HealthBarSettings.Offset = val
	end,
	min = -30,
	max = 30
})
healthBarSettings:AddColor({
	text = 'Outline Color',
	flag = 'hb outline color',
	value = WallHack.Visuals.HealthBarSettings.OutlineColor,
	callback = function(val)
		WallHack.Visuals.HealthBarSettings.OutlineColor = val
	end
})

--// Crosshair Settings
crosshairSettings:AddToggle({
	text = 'Mouse Cursor',
	flag = 'cs mouse cursor',
	value = game:GetService("UserInputService").MouseIconEnabled,
	callback = function(t)
		game:GetService("UserInputService").MouseIconEnabled = t
	end
})
crosshairSettings:AddToggle({
	text = 'Enabled',
	flag = 'cs enabled',
	value = WallHack.Crosshair.Settings.Enabled,
	callback = function(t)
		WallHack.Crosshair.Settings.Enabled = t
	end
})
crosshairSettings:AddColor({
	text = 'Color',
	flag = 'cs color',
	value = WallHack.Crosshair.Settings.Color,
	callback = function(val)
		WallHack.Crosshair.Settings.Color = val
	end
})
crosshairSettings:AddSlider({
	text = 'Transparency',
	flag = 'cs trans',
	value = WallHack.Crosshair.Settings.Transparency,
	callback = function(val)
		WallHack.Crosshair.Settings.Transparency = val
	end,
	min = 0,
	max = 1,
	float = 0.01
})
crosshairSettings:AddSlider({
	text = 'Size',
	flag = 'cs size',
	value = WallHack.Crosshair.Settings.Size,
	callback = function(val)
		WallHack.Crosshair.Settings.Size = val
	end,
	min = 8,
	max = 24
})
crosshairSettings:AddSlider({
	text = 'Thickness',
	flag = 'cs thick',
	value = WallHack.Crosshair.Settings.Thickness,
	callback = function(val)
		WallHack.Crosshair.Settings.Thickness = val
	end,
	min = 1,
	max = 5
})
crosshairSettings:AddSlider({
	text = 'Gap Size',
	value = WallHack.Crosshair.Settings.GapSize,
	callback = function(val)
		WallHack.Crosshair.Settings.GapSize = val
	end,
	min = 0,
	max = 20
})
crosshairSettings:AddSlider({
	text = 'Rotation (Degrees)',
	flag = 'cs rotation',
	value = WallHack.Crosshair.Settings.Rotation,
	callback = function(val)
		WallHack.Crosshair.Settings.Rotation = val
	end,
	min = -180,
	max = 180
})
crosshairSettings:AddList({
	text = 'Position',
	flag = 'cs position',
	value = WallHack.Crosshair.Settings.Type == 1 and "Mouse" or "Center",
	callback = function(val)
		WallHack.Crosshair.Settings.Type = val == "Mouse" and 1 or 2
	end,
	values = {"Mouse", "Center"}
})

crosshairSettingsCenterDot:AddToggle({
	text = 'Center Dot',
	flag = 'chc Center Dot',
	value = WallHack.Crosshair.Settings.CenterDot,
	callback = function(t)
		WallHack.Crosshair.Settings.CenterDot = t
	end
})
crosshairSettingsCenterDot:AddColor({
	text = 'Center Dot Color',
	flag = 'chc Center Dot Color',
	value = WallHack.Crosshair.Settings.CenterDotColor,
	callback = function(val)
		WallHack.Crosshair.Settings.CenterDotColor = val
	end
})
crosshairSettingsCenterDot:AddSlider({
	text = 'Center Dot Size',
	flag = 'chc Center Dot Size',
	value = WallHack.Crosshair.Settings.CenterDotSize,
	callback = function(val)
		WallHack.Crosshair.Settings.CenterDotSize = val
	end,
	min = 1,
	max = 6
})
crosshairSettingsCenterDot:AddSlider({
	text = 'Center Dot Transparency',
	flag = 'chc Center Dot Transparency',
	value = WallHack.Crosshair.Settings.CenterDotTransparency,
	callback = function(val)
		WallHack.Crosshair.Settings.CenterDotTransparency = val
	end,
	min = 0,
	max = 1,
	float = 0.01
})
crosshairSettingsCenterDot:AddToggle({
	text = 'Center Dot Filled',
	flag = 'chc Center Dot Filled',
	value = WallHack.Crosshair.Settings.CenterDotFilled,
	callback = function(val)
		WallHack.Crosshair.Settings.CenterDotFilled = val
	end
})

library:Init(false)
warn(string.format('airhub+ loaded in %.02f seconds', tick() - scriptLoadAt))
