-- https://www.roblox.com/games/12077443856/Cali-Shootout-PLAYSTATION-SUPPORT

local scriptLoadAt = tick()
warn('script started load')

local library = loadstring(game:HttpGet('https://raw.githubusercontent.com/Iratethisname10/Code/main/aztup-ui/ui-lib.lua'))()
local notif = loadstring(game:HttpGet('https://raw.githubusercontent.com/Iratethisname10/Code/main/aztup-ui/notifs.lua'))()

local Maid = loadstring(game:HttpGet('https://raw.githubusercontent.com/Iratethisname10/Code/main/aztup-ui/maid.lua'))()
local Util = loadstring(game:HttpGet('https://raw.githubusercontent.com/Iratethisname10/Code/main/aztup-ui/util.lua'))()

local cloneref = cloneref or function(instance) return instance end

local playersService = cloneref(game:GetService('Players'))
local runService = cloneref(game:GetService('RunService'))
local userInputService = cloneref(game:GetService('UserInputService'))
local teleportService = cloneref(game:GetService('TeleportService'))
local proximityPromptService = cloneref(game:GetService('ProximityPromptService'))
local replicatedStorageService = cloneref(game:GetService('ReplicatedStorage'))
local lightingService = cloneref(game:GetService('Lighting'))

if not playersService.LocalPlayer then playersService:GetPropertyChangedSignal('LocalPlayer'):Wait() end
local lplr = playersService.LocalPlayer

library.gameName = 'cali shootout'
library.title = string.format('vcs.xyz | %s', library.gameName)

local mouse = lplr:GetMouse()

local vector2New = Vector2.new
local vector3New = Vector3.new
local vector3Zero = Vector3.zero
local vector3One = Vector3.one
local cframeNew = CFrame.new
local cframeAngles = CFrame.Angles

local function copyTable(t) -- lua.org
    local k = typeof(t)
    local c = {}

    if k == 'table' then
        for i, v in next, t, nil do
            c[copyTable(i)] = copyTable(v)
        end

        setmetatable(c, copyTable(getmetatable(t)))
    else
        c = t
    end

    return c
end

local maid = Maid.new()

local locations = {
	['gun shop'] = vector3New(-1633, 7, -92),
	['bank'] = vector3New(-2369, 4, 115),
	['night club'] = vector3New(-1195, 3, -75),
	['car dealership'] = vector3New(-1415, 3, -128),
	['armour'] = vector3New(-1616, 3, -546),
	['casino'] = vector3New(-2417, 3, -660),
	['cash register'] = vector3New(-1793, 4, -71),
	['cali apartments'] = vector3New(-2442, 6, -292),
	['mc donald\'s'] = vector3New(-1919, 4, -654),
	['swipe'] = vector3New(-1539, 3, -322),
	['weed area'] = vector3New(-2000, 3, 187),
	['janitor job'] = vector3New(-1675, 4, 49),
	['crate job'] = vector3New(-1947, 3, -39),
	['bank dealer'] = vector3New(-1923, 3, 89)
}

local safeZones = workspace:WaitForChild('SafeZones', 100)
local jobSystem = workspace:WaitForChild('Job System', 100)

local gameRemotes = replicatedStorageService:WaitForChild('Remotes', 100)
local gameEvents = replicatedStorageService:WaitForChild('Events', 100)
local gameModules = replicatedStorageService:WaitForChild('Modules', 100)

local events = {
	killed = gameEvents.Killed,
	changeTeam = replicatedStorageService.TeamChangeRequestEvent,
	ragdollVariableServer = lplr.PlayerGui.ragdoll.events.variableserver,
	codeRedeem = replicatedStorageService.codeEvent
}

local modules = {
	blurModule = require(gameModules.CreateBlur),
	cameraShakeModule = require(gameModules.CameraShaker),
	carModule = require(gameModules.Cars),
	smokeTrailModule = require(gameModules.SmokeTrail)
}

local gunsList = {}
local unnecessaryTools = {'Phone', 'Mop', 'Laptop'}

local comb = library:AddTab('Combat')
local visu = library:AddTab('Visuals')
local tele = library:AddTab('Teleports')
local misc = library:AddTab('Miscellaneous')

local comb1 = comb:AddColumn()
local comb2 = comb:AddColumn()

local visu1 = visu:AddColumn()
local visu2 = visu:AddColumn()

local tele1 = tele:AddColumn()
local tele2 = tele:AddColumn()

local misc1 = misc:AddColumn()
local misc2 = misc:AddColumn()

local aimbotSection = comb1:AddSection('Aim Bot')
local antiAimSection = comb2:AddSection('Anti Aim')

local boxEspSection = visu1:AddSection('Player ESP')
local textEspSection = visu1:AddSection('Text ESP')
local worldSection = visu2:AddSection('World Effects')
local localPlayerSection = visu2:AddSection('Local Player')
local clientSideSection = visu2:AddSection('Client Side')

local mainTpSection = tele1:AddSection('Main')
local playerTpSection = tele1:AddSection('Players')
local locationsTpSection = tele1:AddSection('Locations')
local settingsTpSection = tele2:AddSection('Settings')
local utilityTpSection = tele2:AddSection('Utilities')

local characterSection = misc1:AddSection('Character')
local extrasSection = misc1:AddSection('Extras')
local autoFarmSection = misc2:AddSection('Auto Farms')
local gunModsSection = misc2:AddSection('Gun Modifications')
local rageSection = misc2:AddSection('Rage')

do -- combat
	do
		local aimbotFovCircle

		aimbotSection:AddToggle({
			text = 'Enabled',
			flag = 'Aim Bot',
			callback = function(t)
				if t then
					maid.aimbot = runService.RenderStepped:Connect(function()
						local character = Util:getClosestCharacter({
							useFOV = library.flags.aimBotTargetSelection == 'mouse',
							aimbotFOV = library.flags.aimBotFieldOfView,
							visibilityCheck = library.flags.aimBotVisibilityCheck,
							maxHealth = library.flags.aimBotIgnoreUnAttackable and 200 or math.huge
						})

						if aimbotFovCircle then
							aimbotFovCircle.Visible = library.flags.aimBotFOVCircle
						end
			
						character = character and character.Character
						if not character then return end
			
						local hit = character:FindFirstChild(library.flags.aimBotAimPart)
						local hitPos = hit and hit.CFrame.Position
				
						local camera = workspace.CurrentCamera
						if not camera then return end
			
						local hitPosition2D, visible = camera:WorldToViewportPoint(hitPos)
						if not visible then return end
				
						hitPosition2D = Vector2.new(hitPosition2D.X, hitPosition2D.Y)
				
						local mousePosition = userInputService:GetMouseLocation()
						local final = (hitPosition2D - mousePosition) / library.flags.aimBotSmoothing

						if library.flags.aimBotRequireMouseDown then
							if not userInputService:IsMouseButtonPressed(library.flags.aimBotMouseButton == 'Left' and 0 or 1) then return end
						end

						if library.flags.aimBotAimMethod == 'mouse emulation' then
							mousemoverel(final.X, final.Y)
						else
							camera.CFrame = camera.CFrame:lerp(cframeNew(camera.CFrame.Position, hitPos), 1 / library.flags.aimBotSmoothing)
						end
					end)
				else
					maid.aimbot = nil
					if aimbotFovCircle then
						aimbotFovCircle.Visible = false
					end 
				end
			end
		}):AddBind({
			flag = 'Aimbot Bind',
			callback = function()
				library.options.aimBot:SetState(not library.flags.aimBot)
			end
		})

		aimbotSection:AddDivider()

		aimbotSection:AddList({
			text = 'Aim Part',
			flag = 'Aim Bot Aim Part',
			values = {'Head', 'HumanoidRootPart'},
			value = 'Head'
		})
		aimbotSection:AddList({
			text = 'Target Selection',
			flag = 'Aim Bot Target Selection',
			values = {'mouse', 'character'},
			value = 'mouse',
			callback = function(val)
				if aimbotFovCircle then
					aimbotFovCircle.Visible = val == 'mouse' and library.flags.aimBot
				end
			end
		})
		aimbotSection:AddList({
			text = 'Aim Method',
			flag = 'Aim Bot Aim Method',
			values = {'game camera', 'mouse emulation'},
			value = 'game camera'
		})
		aimbotSection:AddSlider({
			text = 'Field Of View',
			flag = 'Aim Bot Field Of View',
			min = 10,
			max = 1000,
			callback = function(val)
				if aimbotFovCircle then
					aimbotFovCircle.Radius = val
				end
			end
		})
		aimbotSection:AddSlider({
			text = 'Smoothing',
			flag = 'Aim Bot Smoothing',
			tip = 'setting value under 2 when using mouse emulation aim method might break',
			min = 1,
			max = 20,
			value = 5
		})
		aimbotSection:AddToggle({
			text = 'FOV Circle',
			flag = 'Aim Bot F O V Circle',
			callback = function(t)
				if t then
					aimbotFovCircle = library:Create('Circle', {
						Transparency = 0.45,
						NumSides = 500,
						Filled = false,
						Thickness = 1,
						Visible = library.flags.aimBot and library.flags.aimBotTargetSelection == 'mouse',
						Radius = library.flags.aimBotFieldOfView,
						Position = workspace.CurrentCamera.ViewportSize / 2,
						Color = library.flags.aimBotCircleColor
					})
				else
					if aimbotFovCircle then
						aimbotFovCircle:Destroy()
						aimbotFovCircle = nil
					end
				end
			end
		}):AddColor({
			flag = 'Aim Bot Circle Color',
			tip = 'fov circle color'
		})
		aimbotSection:AddToggle({
			text = 'Visibility Check',
			flag = 'Aim Bot Visibility Check'
		})
		aimbotSection:AddToggle({
			text = 'Require Mouse Down',
			flag = 'Aim Bot Require Mouse Down'
		})
		aimbotSection:AddList({
			text = 'Mouse Button',
			values = {'Right', 'Left'},
			value = 'Right',
			flag = 'Aim Bot Mouse Button'
		})
		aimbotSection:AddToggle({
			text = 'Ignore Un Attackable',
			flag = 'Aim Bot Ignore Un Attackable'
		})
	end

	do
		local function toYRotation(cframe)
			local x, y, z = cframe:ToOrientation()
			return cframeNew(cframe.Position) * cframeAngles(0, y, 0)
		end

		local rotationAngle
		local antiAimFunctions = {
			shift = function()
				rotationAngle = -math.atan2(workspace.CurrentCamera.CFrame.LookVector.Z, workspace.CurrentCamera.CFrame.LookVector.X) + math.rad(library.flags.antiAimAngle)
			end,
			random = function()
				rotationAngle = -math.atan2(workspace.CurrentCamera.CFrame.LookVector.Z, workspace.CurrentCamera.CFrame.LookVector.X) + math.random(0, 360)
			end
		}

		antiAimSection:AddToggle({
			text = 'Enabled',
			flag = 'Anti Aim',
			callback = function(t)
				if t then
					maid.antiAim = runService.RenderStepped:Connect(function()
						if not lplr.Character then return end
						if not lplr.Character:FindFirstChild('Humanoid') then return end
						if not lplr.Character:FindFirstChild('HumanoidRootPart') then return end

						lplr.Character.Humanoid.AutoRotate = false

						antiAimFunctions[library.flags.antiAimMode]()

						if library.flags.antiAimMode == 'shift' then
							lplr.Character.HumanoidRootPart.CFrame = cframeNew(lplr.Character.HumanoidRootPart.CFrame.Position) * cframeAngles(0, math.rad(library.flags.antiAimAngle) + math.rad((math.random(1, 2) == 1 and library.flags.antiAimSpeed or -library.flags.antiAimSpeed)), 0)
						else
							local newAngle = cframeNew(lplr.Character.HumanoidRootPart.CFrame.Position) * cframeAngles(0, rotationAngle + library.flags.antiAimAngle, 0)
							lplr.Character.HumanoidRootPart.CFrame = toYRotation(newAngle)
						end
					end)
				else
					maid.antiAim = nil
					maid.antiAimAnimStop = nil

					if not lplr.Character then return end
					if not lplr.Character:FindFirstChild('Humanoid') then return end

					lplr.Character.Humanoid.AutoRotate = true
				end
			end
		}):AddBind({
			flag = 'Anti Aim Bind',
			callback = function()
				library.options.antiAim:SetState(not library.flags.antiAim)
			end
		})
		antiAimSection:AddSlider({
			text = 'Anti Aim Speed',
			min = 1,
			max = 1000,
			value = 130
		})
		antiAimSection:AddSlider({
			text = 'Anti Aim Angle',
			min = 0,
			max = 360
		})
		antiAimSection:AddList({
			text = 'Anti Aim Mode',
			values = {'shift', 'random'}
		})

		antiAimSection:AddDivider()

		local animation

		local animations = {
			['sleep'] = 4689362868,
			['Tilt'] = 3360692915,
			['Salute'] = 3360689775,
			['Applaud'] = 5915779043,
			['Hero Landing'] = 5104377791,
			['HIPMOTION - Amaarae'] = 16572756230,
			['Mae Stephens - Piano Hands'] = 16553249658,
			['Mini Kong'] = 17000058939,
			['ericdoa - dance'] = 15698510244,
			['Bored'] = 5230661597,
			['V Pose - Tommy Hilfiger'] = 10214418283,
			['Uprise - Tommy Hilfiger'] = 10275057230,
			['Elton John - Piano Jump'] = 11453096488,
			['Dolphin Dance'] = 5938365243,
			['Quiet Waves'] = 7466046574,
			['Frosty Flair - Tommy Hilfiger'] = 10214406616 -- spin
		}

		local anims = {}
		for animationName, animationID in next, animations do
			anims[#anims + 1] = animationName
		end

		local function addAnimation()
			repeat task.wait(); until lplr.Character and lplr.Character:FindFirstChild('Humanoid') or not library.flags.animationPlayer
			if animation then
				animation:Stop()
				animation.Animtion:Destroy()
				animation = nil
			end
			local anim = Instance.new('Animation')
			local suc, id = pcall(function() return string.match(game:GetObjects('rbxassetid://'.. (library.flags.customAnimation and library.flags.customAnimationId or animations[library.flags.animation]))[1].AnimationId, '%?id=(%d+)') end)
			if not suc then id = library.flags.customAnimation and library.flags.customAnimationId or animations[library.flags.animation] end
			anim.AnimationId = 'rbxassetid://'.. id
			local suc, res = pcall(function() animation = lplr.Character.Humanoid.Animator:LoadAnimation(anim) end)
			if suc then
				animation.Priority = Enum.AnimationPriority.Action4
				animation.Looped = true
				animation:AdjustSpeed(library.flags.animationSpeed)
				animation:Play()
				maid.antiAimAnimStop = animation.Stopped:Connect(function()
					if library.flags.animationPlayer then
						library.options.animationPlayer:SetState(not library.flags.animationPlayer)
						library.options.animationPlayer:SetState(not library.flags.animationPlayer)
					end
				end)
			end
		end

		antiAimSection:AddToggle({
			text = 'Animation Player',
			callback = function(t)
				if t then
					addAnimation()
					maid.antiAimAnimChar = lplr.CharacterAdded:Connect(addAnimation)
				else
					maid.antiAimAnimStop = nil
					maid.antiAimAnimChar = nil
					if animation then animation:Stop(); animation = nil end
				end
			end
		}):AddBind({
			flag = 'Animation Player Bind',
			callback = function()
				library.options.animationPlayer:SetState(not library.flags.animationPlayer)
			end
		})
		antiAimSection:AddList({
			text = 'Animation',
			values = anims,
			value = 'Sleep',
			callback = function()
				if library.flags.animationPlayer then
					library.options.animationPlayer:SetState(not library.flags.animationPlayer)
					library.options.animationPlayer:SetState(not library.flags.animationPlayer)
				end
			end
		})
		antiAimSection:AddToggle({text = 'Custom Animation'})
		antiAimSection:AddBox({text = 'Custom Animation Id'})
		antiAimSection:AddSlider({
			text = 'Animation Speed',
			min = 1,
			max = 100,
			value = 5
		})
	end
end

do -- visuals
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Iratethisname10/Code/main/espLibrary.lua"))()
	local espLibrary = getgenv().espLibrary
	espLibrary.Visuals.BoxSettings.Type = 2

	do
		boxEspSection:AddToggle({
			text = 'Enabled',
			flag = 'Player E S P',
			tip = 'this acts as a lock for all visual options on the left side',
			callback = function(t) espLibrary.Settings.Enabled = t end
		}):AddBind({
			flag = 'Player E S P Bind',
			callback = function()
				library.options.playerESP:SetState(not library.flags.playerESP)
			end
		})

		boxEspSection:AddDivider()

		boxEspSection:AddToggle({
			text = 'Boxes',
			callback = function(t) espLibrary.Visuals.BoxSettings.Enabled = t end
		}):AddColor({
			flag = 'Boxes Color',
			callback = function(col) espLibrary.Visuals.BoxSettings.Color = col end
		})
		boxEspSection:AddSlider({
			text = 'Visibility',
			value = 1,
			min = 0,
			max = 1,
			float = 0.01,
			callback = function(val) espLibrary.Visuals.BoxSettings.Transparency = val end
		})
		boxEspSection:AddSlider({
			text = 'Thickness',
			min = 1,
			max = 5,
			callback = function(val) espLibrary.Visuals.BoxSettings.Thickness = val end
		})
		boxEspSection:AddToggle({
			text = 'Filled',
			callback = function(t) espLibrary.Visuals.BoxSettings.Filled = t end
		})
		boxEspSection:AddToggle({
			text = 'Health Bar',
			callback = function(t) espLibrary.Visuals.HealthBarSettings.Enabled = t end
		})
	end

	do
		textEspSection:AddToggle({
			text = 'Text',
			callback = function(t) espLibrary.Visuals.ESPSettings.Enabled = t end
		}):AddColor({
			tip = 'text outline color',
			color = Color3.fromRGB(0, 0, 0),
			callback = function(col) espLibrary.Visuals.ESPSettings.OutlineColor = col end
		}):AddColor({
			tip = 'text color',
			callback = function(col) espLibrary.Visuals.ESPSettings.TextColor = col end
		})
		textEspSection:AddToggle({
			text = 'Text Outline',
			state = true,
			callback = function(t) espLibrary.Visuals.ESPSettings.Outline = t end
		})
		textEspSection:AddToggle({
			text = 'Show Distance',
			callback = function(t) espLibrary.Visuals.ESPSettings.DisplayDistance = t end
		})
		textEspSection:AddToggle({
			text = 'Show Name',
			state = true,
			callback = function(t) espLibrary.Visuals.ESPSettings.DisplayName = t end
		})
		textEspSection:AddToggle({
			text = 'Show Health',
			state = true,
			callback = function(t) espLibrary.Visuals.ESPSettings.DisplayHealth = t end
		})
		textEspSection:AddToggle({
			text = 'Show Tool',
			state = true,
			callback = function(t) espLibrary.Visuals.ESPSettings.DisplayTool = t end
		})
		textEspSection:AddSlider({
			text = 'Visibility',
			flag = 'text E S P Visibility',
			value = 1,
			min = 0,
			max = 1,
			float = 0.01,
			callback = function(val) espLibrary.Visuals.ESPSettings.TextTransparency = val end
		})
		textEspSection:AddSlider({
			text = 'Size',
			min = 10,
			max = 25,
			value = 17,
			callback = function(val) espLibrary.Visuals.ESPSettings.TextSize = val end
		})
	end

	do
		do
			local oldBritghtness, oldAmbient

			worldSection:AddToggle({
				text = 'Full Bright',
				callback = function(t)
					if t then
						oldBritghtness, oldAmbient = lightingService.Brightness, lightingService.Ambient

						maid.fullBright = lightingService:GetPropertyChangedSignal('Ambient'):Connect(function()
							lightingService.Ambient = Color3.fromRGB(255, 255, 255)
							lightingService.Brightness = 3.5
						end)
						lightingService.Ambient = Color3.fromRGB(255, 255, 255)
					else
						maid.fullBright = nil
						if oldAmbient and oldBritghtness then
							lightingService.Brightness, lightingService.Ambient = oldBritghtness, oldAmbient
						end
					end
				end
			})

			local oldTime

			worldSection:AddToggle({
				text = 'Cutom Time',
				callback = function(t)
					if t then
						oldTime = lightingService.ClockTime

						maid.customTime = runService.RenderStepped:Connect(function()
							lightingService.ClockTime = library.flags.customTimeValue
						end)
						lightingService.ClockTime = library.flags.customTimeValue
					else
						maid.customTime = nil
						if oldTime then lightingService.ClockTime = oldTime end
					end
				end
			})
			worldSection:AddSlider({
				text = 'Custom Time Value',
				textpos = 2,
				min = 0,
				max = 23.9,
				value = 12.0,
				float = 0.1
			})
		end
		worldSection:AddToggle({
			text = 'No Hurt Cam',
			callback = function(t)
				if t then
					maid.noHurtCam = runService.Stepped:Connect(function()
						for i, v in next, lplr.PlayerGui["Damage GUI"]:GetChildren() do
							if v:IsA('ImageLabel') then
								v.Visible = false
							end
						end
					end)
				else
					maid.noHurtCam = nil
				end
			end
		})
		worldSection:AddToggle({
			text = 'Better Hurt Cam',
			callback = function(t) lplr.PlayerGui["Damage GUI"].IgnoreGuiInset = t end
		})
	end

	do
		local materials = {}
		for i, v in next, Enum.Material:GetEnumItems() do
			table.insert(materials, v.Name)
		end

		local oldData = {}
		local processing = false

		local function changeCharacterMaterial()
			repeat task.wait() until not processing
			repeat task.wait() until lplr.Character or not library.flags.materialChams
			for i, v in next, lplr.Character:GetDescendants() do
				processing = true
				if v:IsA('BasePart') and v.Name ~= 'HumanoidRootPart' then
					processing = true
					oldData[v] = {material = v.Material, color = v.Color, trans = v.Transparency}
					v.Material = library.flags.materialChamsMaterial
					v.Color = library.flags.materialChamsColor
					v.Transparency = library.flags.materialChamsTransparency
				end
				processing = false
			end
		end

		localPlayerSection:AddToggle({
			text = 'Material Chams',
			callback = function(t)
				if t then
					changeCharacterMaterial()
					maid.materialChamsChar = lplr.CharacterAdded:Connect(function()
						task.wait(0.2)
						changeCharacterMaterial()
					end)
				else
					maid.materialChamsChar = nil
					if not lplr.Character then return end
					processing = true
					for i, v in next, lplr.Character:GetDescendants() do
						if oldData[v] then v.Transparency = oldData[v].trans end
						if oldData[v] then v.Color = oldData[v].color end
						if oldData[v] then v.Material = oldData[v].material end
					end
					processing = false
				end
			end
		}):AddColor({
			flag = 'Material Chams Color'
		})
		localPlayerSection:AddList({
			flag = 'Material Chams Material',
			values = materials,
			value = 'ForceField'
		})
		localPlayerSection:AddSlider({
			text = 'Transparency',
			flag = 'Material Chams Transparency',
			min = 0,
			max = 1,
			float = 0.01
		})
	end
end

do -- teleports
	local rayParams = RaycastParams.new()
	rayParams.RespectCanCollide = true
	rayParams.FilterType = Enum.RaycastFilterType.Exclude
	rayParams.FilterDescendantsInstances = {workspace.CurrentCamera, lplr.Character}

	local teleporting = false
	local function teleport(position)
		if teleporting then return end
		if not lplr.Character then return end
		if not lplr.Character:FindFirstChild('Humanoid') then return end
		if not lplr.Character:FindFirstChild('HumanoidRootPart') then return end

		teleporting = true

		task.delay(not library.flags.safeLoad and library.flags.timeout or 35, function()
			teleporting = false
			lplr.Character.HumanoidRootPart.Anchored = false
		end)

		if lplr.Character.Humanoid.SeatPart then
			if library.flags.holdWhenSitting then teleporting = false return end
			lplr.Character.Humanoid.Sit = false
			task.wait()
		end

		if library.flags.safeLoad then
			lplr.Character.HumanoidRootPart.Anchored = true
		end

		lplr.Character.HumanoidRootPart.CFrame = cframeNew(position)
		lplr.Character.HumanoidRootPart.AssemblyLinearVelocity = vector3Zero
		lplr.Character.HumanoidRootPart.AssemblyAngularVelocity = vector3Zero

		if library.flags.safeLoad then
			repeat
				local ray = workspace:Raycast(lplr.Character.HumanoidRootPart.CFrame.Position, Vector3.new(0, -150, 0), rayParams)
				task.wait()
			until ray and ray.Instance

			lplr.Character.HumanoidRootPart.Anchored = false
		end
		
		teleporting = false
	end

	do
		mainTpSection:AddToggle({
			text = 'Click Teleport',
			callback = function(t)
				if t then
					if not mouse then return end
					maid.clickTP = mouse.Button1Down:Connect(function()
						local hitPoint = mouse.Hit.Position + vector3New(0, 4, 0)
						teleport(hitPoint)
					end)
				else
					maid.clickTP = nil
				end
			end
		}):AddBind({
			flag = 'Click Teleport Bind',
			callback = function()
				library.options.clickTeleport:SetState(not library.flags.clickTeleport)
			end
		})
	end

	do
		playerTpSection:AddList({
			flag = 'Players',
			playerOnly = true,
			skipflag = true
		})

		playerTpSection:AddButton({
			text = 'Teleport to player',
			callback = function()
				local player = playersService[library.flags.players.Name].Character
				if not player:FindFirstChild('HumanoidRootPart') then return end

				teleport(player.HumanoidRootPart.CFrame.Position)
			end
		}):AddBind({
			flag = 'Player Tp Bind',
			callback = library.options.teleportToPlayer.callback
		})
	end

	do
		local list = {}
		for location, position in next, locations do
			list[#list + 1] = location
		end

		locationsTpSection:AddList({
			flag = 'Teleport Locations',
			values = list,
			skipflag = true,
			noload = true
		})

		locationsTpSection:AddButton({
			text = 'Teleport to location',
			callback = function() teleport(locations[library.flags.teleportLocations]) end
		}):AddBind({
			flag = 'Location Tp Bind',
			callback = library.options.teleportToLocation.callback
		})
	end

	do
		settingsTpSection:AddSlider({
			text = 'Timeout',
			tip = 'how long before the teleport times out and breaks out of loops',
			min = 5,
			max = 10,
			value = 5
		})
		settingsTpSection:AddToggle({
			text = 'Safe Load',
			tip = 'make sures the floor loads before leting you stand on it'
		})
		settingsTpSection:AddToggle({
			text = 'Hold When Sitting',
			tip = 'does not let you teleport if you are sitting'
		})
	end

	do
		local constants = {
			['Refill Ammo'] = vector3New(-1626, 4, -98),
			['Get Armour'] = vector3New(-1615, 3, -548),
			['Uzi'] = vector3New(-1642, 4, -84),
			['Draco'] = vector3New(-1638, 4, -87),
			['AR Pistol'] = vector3New(-1630, 4, -79),
			['M4A1'] = vector3New(-1633, 4, -76),
			['Micro AR Pistol'] = vector3New(-1637, 4, -74),
			['Glock 17'] = vector3New(-1641, 4, -93),
			['Ruger'] = vector3New(-1637, 4, -96)
		}

		local function getItem(itemName, actionText, cost)
			if lplr.stats.Money.Value < cost then
				local moreDollars = tonumber(cost - lplr.stats.Money.Value)
				return notif.new({text = `you need ${moreDollars} more to buy: {itemName}`, duration = 10})
			end

			local previousPosition = lplr.Character.HumanoidRootPart.CFrame.Position
			teleport(constants[itemName])
			task.wait(0.1)
			for i, v in next, workspace:GetDescendants() do
				if v:IsA('ProximityPrompt') and v.ActionText == actionText then
					fireproximityprompt(v)
				end
			end
			task.wait(0.1)
			teleport(previousPosition)
		end

		utilityTpSection:AddButton({
			text = 'Refill Ammo',
			callback = function()
				local previousPosition = lplr.Character.HumanoidRootPart.CFrame.Position
				teleport(constants['Refill Ammo'])
				task.wait(0.1)
				for i, v in next, workspace:GetDescendants() do
					if v:IsA('ProximityPrompt') and v.Parent.Parent.Name == 'AmmoBox (Unlimited Use)' then
						fireproximityprompt(v)
					end
				end
				task.wait(0.1)
				teleport(previousPosition)
			end
		})
		utilityTpSection:AddButton({
			text = 'Get Armour',
			callback = function()
				local previousPosition = lplr.Character.HumanoidRootPart.CFrame.Position
				teleport(constants['Get Armour'])
				task.wait(0.1)
				for i, v in next, workspace:GetDescendants() do
					if v:IsA('ProximityPrompt') and v.Parent.CFrame.Position == vector3New(-1614.6724853515625, 4.4449944496154785, -549.386962890625) then
						fireproximityprompt(v)
					end
				end
				task.wait(0.1)
				teleport(previousPosition)
			end
		})

		utilityTpSection:AddLabel('\nWeapons')

		-- // getItem Params: 1 = constant table index, 2 = proximity prompt Action Text, 3 = cost
		utilityTpSection:AddButton({
			text = 'Ruger - 900',
			callback = function() getItem('Ruger', 'Buy Ruger for $900', 900) end
		})
		utilityTpSection:AddButton({
			text = 'Glock 17 - 1000',
			callback = function() getItem('Glock 17', 'Buy Glock 17 for $1000', 1000) end
		})
		utilityTpSection:AddButton({
			text = 'Buy Uzi - 2000',
			callback = function() getItem('Uzi', 'Buy Uzi for $2000', 2000) end
		})
		utilityTpSection:AddButton({
			text = 'Buy Draco - 2500',
			callback = function() getItem('Draco', 'Buy Draco for $2500', 2500) end
		})
		utilityTpSection:AddButton({
			text = 'Buy M4A1 - 3000',
			callback = function() getItem('M4A1', 'Buy M4A1 for $3000', 3000) end
		})
		utilityTpSection:AddButton({
			text = 'Buy AR Pistol - 4000',
			callback = function() getItem('AR Pistol', 'Buy AR Pistol for $4000', 4000) end
		})
		utilityTpSection:AddButton({
			text = 'Buy Micro AR Pistol - 4000',
			callback = function() getItem('Micro AR Pistol', 'Buy Micro AR Pistol for $4000', 4000) end
		})
	end
end

do -- misc
	do
		do
			characterSection:AddToggle({
				text = 'Speed',
				callback = function(t)
					if t then
						maid.speedLoop = runService.Heartbeat:Connect(function(delta)
							if not lplr.Character then return end
							if not lplr.Character:FindFirstChild('Humanoid') then return end
							if not lplr.Character:FindFirstChild('HumanoidRootPart') then return end

							lplr.Character.HumanoidRootPart.AssemblyLinearVelocity *= vector3New(0, 1, 0)

							local vector = lplr.Character.Humanoid.MoveDirection
							lplr.Character.HumanoidRootPart.CFrame += vector3New(vector.X * library.flags.speedValue * delta, 0, vector.Z * library.flags.speedValue * delta)
						end)
					else
						lplr.Character.HumanoidRootPart.AssemblyLinearVelocity = vector3Zero
						maid.speedLoop = nil
					end
				end
			}):AddBind({
				flag = 'Speed Bind',
				callback = function()
					library.options.speed:SetState(not library.flags.speed)
				end
			})
			characterSection:AddSlider({
				text = 'Speed Value',
				textpos = 2,
				min = 1,
				max = 500
			})

			local flyVertical = 0
			local flyBV

			characterSection:AddToggle({
				text = 'Fly',
				callback = function(t)
					if t then
						maid.flyLoop = runService.Heartbeat:Connect(function(delta)
							if not lplr.Character then return end
							if not lplr.Character:FindFirstChild('Humanoid') then return end
							if not lplr.Character:FindFirstChild('HumanoidRootPart') then return end

							if userInputService:IsKeyDown(Enum.KeyCode.Space) then
								flyVertical = library.flags.flyVerticalValue
							elseif userInputService:IsKeyDown(Enum.KeyCode.LeftShift) or userInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
								flyVertical = -library.flags.flyVerticalValue
							else
								flyVertical = 0
							end

							if lplr.Character.Humanoid.SeatPart then lplr.Character.Humanoid.Sit = false end
							lplr.Character.HumanoidRootPart.AssemblyLinearVelocity = vector3Zero
							local vector = lplr.Character.Humanoid.MoveDirection

							flyBV = flyBV or Instance.new('BodyVelocity', lplr.Character.HumanoidRootPart)
							flyBV.MaxForce = vector3One * math.huge
							flyBV.Velocity = vector3New(vector.X * library.flags.flyHorizontalValue * delta, flyVertical * delta, vector.Z * library.flags.flyHorizontalValue * delta)
							
							lplr.Character.HumanoidRootPart.CFrame += vector3New(vector.X * library.flags.flyHorizontalValue * delta, flyVertical * delta, vector.Z * library.flags.flyHorizontalValue * delta)
						end)
					else
						maid.flyLoop = nil
						if flyBV then flyBV:Destroy(); flyBV = nil end
					end
				end
			}):AddBind({
				flag = 'Fly Bind',
				callback = function()
					library.options.fly:SetState(not library.flags.fly)
				end
			})
			characterSection:AddSlider({
				text = 'Fly Horizontal Value',
				textpos = 2,
				min = 1,
				max = 500,
				value = 100
			})
			characterSection:AddSlider({
				text = 'Fly Vertical Value',
				textpos = 2,
				min = 1,
				max = 500,
				value = 200
			})

			characterSection:AddToggle({
				text = 'High Jump',
				callback = function(t)
					if t then
						maid.highJumpLoop = runService.Heartbeat:Connect(function()
							if not lplr.Character then return end
							if not lplr.Character:FindFirstChild('Humanoid') then return end
							
							lplr.Character.Humanoid.UseJumpPower = true
							lplr.Character.Humanoid.JumpPower = library.flags.jumpPower
						end)
					else
						maid.highJumpLoop = nil

						if not lplr.Character then return end
						if not lplr.Character:FindFirstChild('Humanoid') then return end
						lplr.Character.Humanoid.JumpPower = 50.145
						lplr.Character.Humanoid.UseJumpPower = false
					end
				end
			}):AddBind({
				flag = 'High Jump Bind',
				callback = function()
					library.options.highJump:SetState(not library.flags.highJump)
				end
			})
			characterSection:AddSlider({
				text = 'Jump Power',
				textpos = 2,
				min = 50,
				max = 500,
				value = 100
			})
		end

		do
			characterSection:AddToggle({
				text = 'Inf Jump',
				callback = function(t)
					if t then
						maid.infJump = runService.Heartbeat:Connect(function()
							if not lplr.Character then return end
							if not lplr.Character:FindFirstChild('Humanoid') then return end
							if not lplr.Character:FindFirstChild('HumanoidRootPart') then return end

							if userInputService:IsKeyDown(Enum.KeyCode.Space) then
								local velocity = lplr.Character.HumanoidRootPart.AssemblyLinearVelocity
								lplr.Character.HumanoidRootPart.AssemblyLinearVelocity = vector3New(velocity.X, lplr.Character.Humanoid.JumpPower, velocity.Z)
							end
						end)
					else
						maid.infJump = nil
					end
				end
			}):AddBind({
				flag = 'Inf Jump Bind',
				callback = function()
					library.options.infJump:SetState(not library.flags.infJump)
				end
			})

			characterSection:AddToggle({
				text = 'No Clip',
				callback = function(t)
					if t then
						maid.noClip = runService.Stepped:Connect(function()
							if not lplr.Character then return end

							for _, v in next, lplr.Character:GetDescendants() do
								if v:IsA('BasePart') then
									v.CanCollide = false
								end
							end
						end)
					else
						maid.noClip = nil

						if not lplr.Character then return end
						if not lplr.Character:WaitForChild('Humanoid') then return end

						if lplr.Character.Humanoid.SeatPart then return end

						lplr.Character.Humanoid:ChangeState('Physics')
						task.wait()
						lplr.Character.Humanoid:ChangeState('RunningNoPhysics')
					end
				end
			}):AddBind({
				flag = 'No Clip Bind',
				callback = function()
					library.options.noClip:SetState(not library.flags.noClip)
				end
			})

			characterSection:AddToggle({
				text = 'Auto Sprint',
				callback = function(t)
					if t then
						maid.autoSprintLoop = runService.Heartbeat:Connect(function()
							if not lplr.Character then return end
							if not lplr.Character:FindFirstChild('Humanoid') then return end
							if not lplr.Character.Humanoid:FindFirstChild('Animator') then return end

							maid.autoSprintSpeedChanged = lplr.Character.Humanoid:GetPropertyChangedSignal('WalkSpeed'):Connect(function()
								lplr.Character.Humanoid.WalkSpeed = 20
							end)
							lplr.Character.Humanoid.WalkSpeed = 20
						end)
					else
						if var10 then var10:Stop(0.2) end
						maid.autoSprintSpeedChanged = nil
						maid.autoSprintLoop = nil
						lplr.Character.Humanoid.WalkSpeed = 10
					end
				end
			}):AddBind({
				flag = 'Auto Spring Bind',
				callback = function()
					library.options.autoSprint:SetState(not library.flags.autoSprint)
				end
			})
		end

		do
			local oldCframe
			local oldSize
			local part
			
			characterSection:AddToggle({
				text = 'GodMode',
				callback = function(t)
					if t then
						repeat
							for _, v in next, safeZones:GetChildren() do
								if v.Name == 'safeZoneArea' and v:IsA('BasePart') then
									part = v
									break
								end
							end
							task.wait()
						until part
						oldCframe = part.CFrame
						oldSize = part.Size
		
						maid.godmodeLoop = runService.RenderStepped:Connect(function()
							if not lplr.Character then return end
							if not lplr.Character:FindFirstChild('Humanoid') then return end
							if not lplr.Character:FindFirstChild('HumanoidRootPart') then return end
							if not part then return end
		
							part.Size = vector3One * 2040
							part.CFrame = lplr.Character.HumanoidRootPart.CFrame
						end)
					else
						maid.godmodeLoop = nil
						if part and oldCframe and oldSize then
							part.CFrame = oldCframe
							part.Size = oldSize
						end
					end
				end
			}):AddBind({
				flag = 'Godmode Bind',
				callback = function()
					library.options.godmode:SetState(not library.flags.godmode)
				end
			})
		end

		do
			local clonesuccess = false
			local disabledproper = true
			local oldcloneroot
			local cloned
			local clone
			local bodyvelo

			local overlap = OverlapParams.new()
			overlap.MaxParts = 9e9
			overlap.FilterDescendantsInstances = {}
			overlap.RespectCanCollide = true

			characterSection:AddToggle({ -- vape infinite fly LOL
				text = 'Invisibility',
				callback = function(t)
					if t then
						clonesuccess = false
						if lplr.Character and lplr.Character:FindFirstChild('Humanoid') and lplr.Character.Humanoid.Health > 0 then
							cloned = lplr.Character
							oldcloneroot = lplr.Character.HumanoidRootPart
							if not lplr.Character.Parent then library.flags.testInvisibility:SetState(false); return end
							lplr.Character.Parent = game
							clone = oldcloneroot:Clone()
							clone.Parent = lplr.Character
							oldcloneroot.Parent = workspace.CurrentCamera
							clone.CFrame = oldcloneroot.CFrame
							lplr.Character.PrimaryPart = clone
							lplr.Character.Parent = workspace
							for i,v in pairs(lplr.Character:GetDescendants()) do
								if v:IsA("Weld") or v:IsA("Motor6D") then
									if v.Part0 == oldcloneroot then v.Part0 = clone end
									if v.Part1 == oldcloneroot then v.Part1 = clone end
								end
								if v:IsA("BodyVelocity") then
									v:Destroy()
								end
							end
							for i,v in pairs(oldcloneroot:GetChildren()) do
								if v:IsA("BodyVelocity") then
									v:Destroy()
								end
							end
							if hip then
								lplr.Character.Humanoid.HipHeight = hip
							end
							hip = lplr.Character.Humanoid.HipHeight
							clonesuccess = true
						end
						if not clonesuccess then
							notif.new({text = 'invis: an error occurred', duration = 5})
							library.flags.testInvisibility:SetState(false)
							return
						end
						local goneup = false
						maid.invis = runService.Heartbeat:Connect(function(delta)
							local components = {oldcloneroot.CFrame:GetComponents()}
							components[1] = clone.CFrame.X
							if components[2] < 1000 or not goneup then
								components[2] = 100000
								goneup = true
							end
							components[3] = clone.CFrame.Z
							oldcloneroot.CFrame = CFrame.new(unpack(components))
							oldcloneroot.Velocity = Vector3.new(clone.Velocity.X, oldcloneroot.Velocity.Y, clone.Velocity.Z)
						end)
					else
						maid.invis = nil
						if clonesuccess and oldcloneroot and clone and lplr.Character.Parent == workspace and oldcloneroot.Parent ~= nil and disabledproper and cloned == lplr.Character then
							local rayparams = RaycastParams.new()
							rayparams.FilterDescendantsInstances = {lplr.Character, workspace.CurrentCamera}
							rayparams.RespectCanCollide = true
							local ray = workspace:Raycast(Vector3.new(oldcloneroot.Position.X, clone.CFrame.p.Y, oldcloneroot.Position.Z), Vector3.new(0, -1000, 0), rayparams)
							local origcf = {clone.CFrame:GetComponents()}
							origcf[1] = oldcloneroot.Position.X
							origcf[2] = ray and ray.Position.Y + (lplr.Character.Humanoid.HipHeight + (oldcloneroot.Size.Y / 2)) or clone.CFrame.p.Y
							origcf[3] = oldcloneroot.Position.Z
							oldcloneroot.CanCollide = true
							bodyvelo = Instance.new("BodyVelocity")
							bodyvelo.MaxForce = Vector3.new(0, 9e9, 0)
							bodyvelo.Velocity = Vector3.new(0, -1, 0)
							bodyvelo.Parent = oldcloneroot
							oldcloneroot.Velocity = Vector3.new(clone.Velocity.X, -1, clone.Velocity.Z)
							
							maid.disableInvis = runService.Heartbeat:Connect(function(delta)
								if oldcloneroot then
									oldcloneroot.Velocity = Vector3.new(clone.Velocity.X, -1, clone.Velocity.Z)
									local bruh = {clone.CFrame:GetComponents()}
									bruh[2] = oldcloneroot.CFrame.Y
									local newcf = CFrame.new(unpack(bruh))
									overlap.FilterDescendantsInstances = {lplr.Character, workspace.CurrentCamera}
									local allowed = true
									for i,v in pairs(workspace:GetPartBoundsInRadius(newcf.p, 2, overlap)) do
										if (v.Position.Y + (v.Size.Y / 2)) > (newcf.p.Y + 0.5) then
											allowed = false
											break
										end
									end
									if allowed then
										oldcloneroot.CFrame = newcf
									end
								end
							end)

							oldcloneroot.CFrame = CFrame.new(unpack(origcf))
							lplr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Landed)
							disabledproper = false
							
							if bodyvelo then bodyvelo:Destroy() end
							maid.disableInvis = nil
							disabledproper = true
							if not oldcloneroot or not oldcloneroot.Parent then return end
							lplr.Character.Parent = game
							oldcloneroot.Parent = lplr.Character
							lplr.Character.PrimaryPart = oldcloneroot
							lplr.Character.Parent = workspace
							oldcloneroot.CanCollide = true
							for i,v in pairs(lplr.Character:GetDescendants()) do
								if v:IsA("Weld") or v:IsA("Motor6D") then
									if v.Part0 == clone then v.Part0 = oldcloneroot end
									if v.Part1 == clone then v.Part1 = oldcloneroot end
								end
								if v:IsA("BodyVelocity") then
									v:Destroy()
								end
							end
							for i,v in pairs(oldcloneroot:GetChildren()) do
								if v:IsA("BodyVelocity") then
									v:Destroy()
								end
							end
							local oldclonepos = clone.Position.Y
							if clone then
								clone:Destroy()
								clone = nil
							end
							lplr.Character.Humanoid.HipHeight = hip or 2
							local origcf = {oldcloneroot.CFrame:GetComponents()}
							origcf[2] = oldclonepos
							oldcloneroot.CFrame = CFrame.new(unpack(origcf))
							oldcloneroot = nil
						end
					end
				end
			}):AddBind({
				flag = 'Invisibility Bind',
				callback = function()
					library.options.invisibility:SetState(not library.flags.invisibility)
				end
			})
		end
		
		do
			local function disableRagdoll()
				task.wait(0.2)
				if not lplr.Character then return end
				if not lplr.Character:FindFirstChild('RagdollConstraints') then return end

				for i, v in next, lplr.Character.RagdollConstraints:GetChildren() do
					if v:IsA('HingeConstraint') or v:IsA('BallSocketConstraint') then
						task.spawn(function() v.Enabled = false end)
					end
				end
			end

			characterSection:AddToggle({
				text = 'Anti Ragdoll',
				callback = function(t)
					repeat
						events.ragdollVariableServer:FireServer('ragdoll', false)
						task.wait()
					until not library.flags.antiRagdoll
				end
			}):AddBind({
				flag = 'Anti Ragdoll Bind',
				callback = function()
					library.options.antiRagdoll:SetState(not library.flags.antiRagdoll)
				end
			})
		end
	end

	do
		
		extrasSection:AddToggle({
			text = 'Equip All Tools',
			tip = 'un-toggling this will un-equip your tools',
			callback = function(t)
				if t then
					if not lplr.Character then return end
					if not lplr.Character:FindFirstChild('Humanoid') then return end
					
					lplr.Character.Humanoid:UnequipTools()
					task.wait()
					for i, v in next, lplr.Backpack:GetChildren() do
						if not v:IsA('Tool') then continue end
						if not table.find(gunsList, v.Name) then continue end

						task.spawn(function()
							v.Parent = lplr.Character
						end)
					end
				else
					if not lplr.Character then return end
					if not lplr.Character:FindFirstChild('Humanoid') then return end

					lplr.Character.Humanoid:UnequipTools()
				end
			end
		}):AddBind({
			flag = 'Equip All Tools Bind',
			callback = function()
				library.options.equipAllTools:SetState(not library.flags.equipAllTools)
			end
		})

		extrasSection:AddToggle({
			text = 'Instant Interact',
			callback = function(t)
				if t then
					maid.instantInteract = proximityPromptService.PromptButtonHoldBegan:Connect(function(prompt)
						fireproximityprompt(prompt)
					end)
				else
					maid.instantInteract = nil
				end
			end
		})

		do
			local function destroyTools()
				if not lplr.Character then return end

				for i, v in next, lplr.Backpack:GetChildren() do
					if not v:IsA('Tool') then continue end
					if not table.find(unnecessaryTools, v.Name) then continue end
					
					v:Destroy()
				end
				for i, v in next, lplr.Character:GetChildren() do
					if not v:IsA('Tool') then continue end
					if not table.find(unnecessaryTools, v.Name) then continue end

					v.Parent = workspace
				end
			end

			extrasSection:AddToggle({
				text = 'Drop Unnecessary Tools',
				callback = function(t)
					if t then
						task.spawn(function()
							repeat
								destroyTools()
								task.wait(2)
							until not library.flags.dropUnnecessaryTools
						end)
					end
				end
			})
		end

		do
			local oldBlurFunction = modules.blurModule.Create
			local oldSmokEmmitFunction = modules.smokeTrailModule.EmitSmokeTrail

			extrasSection:AddToggle({
				text = 'No Gun Blur',
				callback = function(t)
					modules.blurModule.Create = t and function() end or oldBlurFunction
				end
			})

			extrasSection:AddToggle({
				text = 'No Smoke Trail',
				callback = function(t)
					modules.smokeTrailModule.EmitSmokeTrail = t and function() end or oldSmokEmmitFunction
				end
			})
		end

		do
			local chatRemote = replicatedStorageService:WaitForChild('DefaultChatSystemChatEvents', 10):WaitForChild('SayMessageRequest', 10)

			local killSayList = {
				'<player> just died the same way as those requisition users',
				'<player>, maybe buy vcs?? /sRz4eEs9Qk',
				'<player> would not have died if he used vcs: /sRz4eEs9Qk',
				'<player> might be tempted to get scripts to spin back at me, but the truth is, he cannot',
				'vcs on top | sRz4eEs9Qk',
				'BUY VCS NOW: /sRz4eEs9Qk',
				'<player> should buy vcs now: /sRz4eEs9Qk'
			}

			extrasSection:AddToggle({
				text = 'Kill Say',
				callback = function(t)
					if t then
						maid.killSay = events.killed.OnClientEvent:Connect(function(playerName)
							local message = killSayList[math.random(1, #killSayList)]
							if message then message = message:gsub('<player>', playerName) end
							chatRemote:FireServer(message, 'All')
						end)
					else
						maid.killSay = nil
					end
				end
			})
		end

		do
			local otherFolder = workspace:WaitForChild('Buildings', 10):WaitForChild('Other', 10)
			extrasSection:AddToggle({
				text = 'No Fence Collisions',
				callback = function(t)
					for i, v in next, otherFolder:GetChildren() do
						if not v:IsA('MeshPart') then continue end
						if not v.Name == 'TallFence' then continue end

						v.CanCollide = not t
					end
				end
			})
		end

		do
			local redeemCodeButtons = {}
			local function redeemCode(code) events.codeRedeem:FireServer(code) end
			local function changeTeam(team) events.changeTeam:FireServer(team) end
			
			local function redeemAllCodes()
				for i, v in next, lplr.CodesFolder:GetChildren() do
					if not v:IsA('BoolValue') then continue end
					if v.Value then continue end

					redeemCode(v.Name)
					notif.new({text = 'redeemed: '.. v.Name, duration = 5})
					task.wait()
				end
			end

			extrasSection:AddButton({text = 'Redeem All Codes', callback = redeemAllCodes})

			extrasSection:AddDivider('teams')
			extrasSection:AddButton({text = 'Civilian', callback = function() changeTeam('Civilian') end})
			extrasSection:AddButton({text = 'Police', callback = function() changeTeam('Police') end})
			extrasSection:AddButton({text = 'Prisoner', callback = function() changeTeam('Prisoner') end})
		end
	end

	do
		autoFarmSection:AddLabel('please dont turn on more\nthan 1 farm at a time\n')

		local function isJobLoaded(jobName)
			for i, v in next, jobSystem:GetChildren() do
				if v.Name == jobName then
					local t = {}
					for i2, v2 in next, v:GetChildren() do
						table.insert(t, v2)
					end
					return #t > 1
				end
			end
		end

		local rayParams = RaycastParams.new()
		rayParams.RespectCanCollide = true
		rayParams.FilterType = Enum.RaycastFilterType.Exclude
		rayParams.FilterDescendantsInstances = {workspace.CurrentCamera, lplr.Character}

		local function loadJob(position, floorMaterial, weed)
			if not lplr.Character then return end
			if not lplr.Character:FindFirstChild('HumanoidRootPart') then return end
		
			lplr.Character.HumanoidRootPart.Anchored = true
			lplr.Character.HumanoidRootPart.CFrame = cframeNew(position)
		
			repeat
				local ray = workspace:Raycast(lplr.Character.HumanoidRootPart.CFrame.Position, Vector3.new(0, -10, 0), rayParams)
				task.wait()
			until not weed and (ray and ray.Instance.Material == floorMaterial and ray.Instance:IsA('BasePart')) or (ray and ray.Instance.Material == Enum.Material.SmoothPlastic and ray.Instance:FindFirstChildOfClass('Texture'))

			task.wait(0.5)
			lplr.Character.HumanoidRootPart.Anchored = false
		end

		do
			local constants = {
				['load point'] = vector3New(-1986, 7, 177),
				['nigger'] = vector3New(-2005, 3, 195),
				['nigger closer'] = vector3New(-2004, 3, 197),
			}

			local foundWeedPot = {}

			local function getData()
				for i, v in next, workspace:GetDescendants() do
					if v:IsA('ProximityPrompt') and v.Parent.Name == 'Grass' and v.Parent:IsA('MeshPart') then
						if v.Parent.Transparency == 0 then
							foundWeedPot.ProximityPrompt = v
							foundWeedPot.ParentPart = v.Parent
						end
					end
				end
			end

			local function equipRequiredTool(delay)
				if lplr.Backpack:FindFirstChild('Grass') then
					if not lplr.Backpack.Grass:IsA('Tool') then return end

					if not lplr.Character:FindFirstChild('Grass') then lplr.Character.Humanoid:UnequipTools() end
					if delay then task.wait(delay) end
					lplr.Backpack.Grass.Parent = lplr.Character
				end
			end

			local function check()
				if lplr.Backpack:FindFirstChild('Grass') and lplr.Backpack:FindFirstChild('Grass'):IsA('Tool') then
					if not lplr.Character:FindFirstChild('Grass') then lplr.Character.Humanoid:UnequipTools() end
					lplr.Backpack.Grass.Parent = lplr.Character
				end
			end

			autoFarmSection:AddToggle({
				text = 'Weed Farm',
				callback = function(t)
					if t then
						loadJob(constants['load point'], Enum.Material.SmoothPlastic, true)
						repeat
							if not library.flags.weedFarm then break end
							if not lplr.Character then return end
							if not lplr.Character:FindFirstChild('Humanoid') then return end
							if not lplr.Character:FindFirstChild('HumanoidRootPart') then return end

							lplr.Character.HumanoidRootPart.CFrame = cframeNew(constants['load point'] - Vector3.new(0, 4, 0))

							repeat
								if not library.flags.weedFarm then break end
								getData()
								task.wait()
							until foundWeedPot.ProximityPrompt and foundWeedPot.ParentPart

							lplr.Character.HumanoidRootPart.CFrame = foundWeedPot.ParentPart.CFrame

							fireproximityprompt(foundWeedPot.ProximityPrompt)
							equipRequiredTool(0.5)
							task.wait(0.2)
							repeat
								if not library.flags.weedFarm then break end
								equipRequiredTool()
								lplr.Character.HumanoidRootPart.CFrame = cframeNew(constants['load point'] - Vector3.new(0, 4, 0))
								task.wait(0.2)
								lplr.Character.HumanoidRootPart.CFrame = cframeNew(constants['nigger closer'])
								task.wait()
							until not lplr.Character:FindFirstChild('Grass')
							foundWeedPot = {}
						until not library.flags.weedFarm
						foundWeedPot = {}
					end
				end
			})
		end

		do
			local constants = {
				['load point'] = vector3New(-1936, 10, -37),
				['crates'] = vector3New(-1941, 3, -47),
				['crates safe'] = vector3New(-1937, 3, -43),
				['truck'] = vector3New(-1925, 3, -22),
				['truck closer'] = vector3New(-1922, 3, -22),
				['prompt text'] = '📦Deliver the crate to the truck'
			}

			local ProximityPrompt
			local function getProximityPrompt()
				for i, v in next, jobSystem:GetDescendants() do
					if v:IsA('ProximityPrompt') and v.ObjectText == constants['prompt text'] then
						ProximityPrompt = v
					end
				end
			end

			local function equipRequiredTool(delay)
				if lplr.Backpack:FindFirstChild('BOX') then
					if not lplr.Backpack.BOX:IsA('Tool') then return end

					if not lplr.Character:FindFirstChild('BOX') then lplr.Character.Humanoid:UnequipTools() end
					if delay then task.wait(delay) end
					lplr.Backpack.BOX.Parent = lplr.Character
				end
			end

			autoFarmSection:AddToggle({
				text = 'Crate Farm',
				callback = function(t)
					if t then
						if not isJobLoaded('BoxPickingJob') then loadJob(constants['load point'], Enum.Material.Concrete) end
						repeat
							if not library.flags.crateFarm then break end
							if not lplr.Character then return end
							if not lplr.Character:FindFirstChild('Humanoid') then return end
							if not lplr.Character:FindFirstChild('HumanoidRootPart') then return end

							lplr.Character.HumanoidRootPart.CFrame = cframeNew(constants['crates safe'])
							task.wait(1)
							lplr.Character.HumanoidRootPart.CFrame = cframeNew(constants['crates'])

							if not ProximityPrompt then getProximityPrompt() end
							fireproximityprompt(ProximityPrompt)
							equipRequiredTool(0.5)
							task.wait(0.3)
							repeat
								if not library.flags.crateFarm then break end
								equipRequiredTool()
								lplr.Character.HumanoidRootPart.CFrame = cframeNew(constants['truck'])
								task.wait(0.3)
								equipRequiredTool()
								lplr.Character.HumanoidRootPart.CFrame = cframeNew(constants['truck closer'])
								task.wait(0.2)
							until not lplr.Character:FindFirstChild('BOX')
							lplr.Character.HumanoidRootPart.CFrame = cframeNew(constants['load point'])
							task.wait(3.4)
						until not library.flags.crateFarm
					end
				end
			})
		end

		do
			local constants = {
				['load point'] = vector3New(-1399, 3, 24),
				['garbage'] = vector3New(-1386, 3, 27),
				['garbage safe'] = vector3New(-1391, 3, 25),
				['truck'] = vector3New(-1409, 3, 28),
				['truck closer'] = vector3New(-1409, 3, 31),
				['prompt text'] = '🗑️Deliver the trash to the truck'
			}

			local ProximityPrompt
			local function getProximityPrompt()
				for i, v in next, jobSystem:GetDescendants() do
					if v:IsA('ProximityPrompt') and v.ObjectText == constants['prompt text'] then
						ProximityPrompt = v
					end
				end
			end

			local function equipRequiredTool(delay)
				if lplr.Backpack:FindFirstChild('Garbage') then
					if not lplr.Backpack.Garbage:IsA('Tool') then return end

					if not lplr.Character:FindFirstChild('Garbage') then lplr.Character.Humanoid:UnequipTools() end
					if delay then task.wait(delay) end
					lplr.Backpack.Garbage.Parent = lplr.Character
				end
			end

			autoFarmSection:AddToggle({
				text = 'Garbage Farm',
				callback = function(t)
					if t then
						if not isJobLoaded('GarbageJob') then loadJob(constants['load point'], Enum.Material.Concrete) end
						repeat
							if not library.flags.garbageFarm then break end
							if not lplr.Character then return end
							if not lplr.Character:FindFirstChild('Humanoid') then return end
							if not lplr.Character:FindFirstChild('HumanoidRootPart') then return end

							lplr.Character.HumanoidRootPart.CFrame = cframeNew(constants['garbage safe'])
							task.wait(1)
							lplr.Character.HumanoidRootPart.CFrame = cframeNew(constants['garbage'])

							if not ProximityPrompt then getProximityPrompt() end
							fireproximityprompt(ProximityPrompt)
							equipRequiredTool(0.5)
							task.wait(0.3)
							repeat
								if not library.flags.garbageFarm then break end
								equipRequiredTool()
								lplr.Character.HumanoidRootPart.CFrame = cframeNew(constants['truck'])
								task.wait(0.3)
								equipRequiredTool()
								lplr.Character.HumanoidRootPart.CFrame = cframeNew(constants['truck closer'])
								task.wait(0.2)
							until not lplr.Character:FindFirstChild('Garbage')
							lplr.Character.HumanoidRootPart.CFrame = cframeNew(constants['load point'])
							task.wait(3.4)
						until not library.flags.garbageFarm
					end
				end
			})
		end
	end

	do
		local gunRestorationSave = {}
		local gunSettings = gameModules.WeaponSettings.Gun

		for i, v in next, gameModules.WeaponSettings.Gun:GetChildren() do
			if v:IsA('Folder') and #v:GetDescendants() == 2 then
				table.insert(gunsList, v.Name)
			end
		end

		local function clearRestorationSave(gunName)
			if not gunRestorationSave[gunName] then return end
			local temp = gunRestorationSave[gunName]
			table.clear(temp)
			temp = nil
		end

		local function restoreGun(gunName, property)
			if gunRestorationSave[gunName] then
				local savedData = gunRestorationSave[gunName]

				if property then
					require(gunSettings[gunName].Setting['1'])[property] = savedData[property]
				else
					local settings = require(gunSettings[gunName].Setting['1'])
					settings = savedData
				end
			end
		end

		local function modifyGun(gunName, property, value)
			if not gunSettings:FindFirstChild(gunName) then return end
			local localGunSettings = require(gunSettings[gunName].Setting['1'])
			clearRestorationSave(gunName)
			task.wait()
			gunRestorationSave[gunName] = copyTable(localGunSettings)
			task.wait()
			localGunSettings[property] = value
		end

		local function modifyFunc(gunName, property, value, toggle)
			if toggle then
				modifyGun(gunName, property, value)
			else
				restoreGun(gunName, property)
			end
		end

		gunModsSection:AddToggle({
			text = 'Instant Kill',
			callback = function(t)
				for i, v in next, gunsList do
					modifyFunc(v, 'BaseDamage', 9e9, t)
				end
			end
		})
		gunModsSection:AddToggle({
			text = 'Bullet Visualizer',
			callback = function(t)
				for i, v in next, gunsList do
					modifyFunc(v, 'LaserTrailEnabled', t, t)
				end
			end
		})
		gunModsSection:AddToggle({
			text = 'Sniper Scope',
			callback = function(t)
				for i, v in next, gunsList do
					modifyFunc(v, 'SniperEnabled', t, t)
				end
			end
		})
		gunModsSection:AddDivider()
		gunModsSection:AddToggle({
			text = 'Instant Reload',
			callback = function(t)
				for i, v in next, gunsList do
					modifyFunc(v, 'ReloadTime', 0, t)
				end
			end
		})
		gunModsSection:AddToggle({
			text = 'Infinite Ammo',
			callback = function(t)
				for i, v in next, gunsList do
					modifyFunc(v, 'AmmoCost', 0, t)
				end
			end
		})
		gunModsSection:AddToggle({
			text = 'No Spread',
			callback = function(t)
				for i, v in next, gunsList do
					modifyFunc(v, 'Spread', 0, t)
				end
			end
		})
		gunModsSection:AddToggle({
			text = 'High Fire Rate',
			callback = function(t)
				for i, v in next, gunsList do
					modifyFunc(v, 'FireRate', 0.001, t)
				end
			end
		})
		gunModsSection:AddToggle({
			text = 'No Camera Recoil',
			callback = function(t)
				for i, v in next, gunsList do
					modifyFunc(v, 'CameraRecoilingEnabled', t, t)
				end
			end
		})
		gunModsSection:AddToggle({
			text = 'No Gun Recoil',
			callback = function(t)
				for i, v in next, gunsList do
					modifyFunc(v, 'Recoil', 0, t)
				end
			end
		})
		gunModsSection:AddToggle({
			text = 'Shotgun Bullets',
			callback = function(t)
				for i, v in next, gunsList do
					modifyFunc(v, 'ShotgunEnabled', t, t)
				end
			end
		})
		gunModsSection:AddToggle({
			text = 'Explosive Bullets',
			callback = function(t)
				for i, v in next, gunsList do
					modifyFunc(v, 'ExplosiveEnabled', t, t)
				end
			end
		})
		gunModsSection:AddToggle({
			text = 'No Bullet Shells',
			callback = function(t)
				for i, v in next, gunsList do
					modifyFunc(v, 'BulletShellEnabled', not t, t)
				end
			end
		})
		gunModsSection:AddToggle({
			text = 'Always Automatic',
			callback = function(t)
				for i, v in next, gunsList do
					modifyFunc(v, 'Auto', t, t)
				end
			end
		})
		gunModsSection:AddToggle({
			text = 'Infinite Bullet Range',
			callback = function(t)
				for i, v in next, gunsList do
					modifyFunc(v, 'Range', 9e9, t)
					modifyFunc(v, 'ZeroDamageDistance', 9e9, t)
					modifyFunc(v, 'FullDamageDistance', 9e9, t)
				end
			end
		})
	end

	do
		rageSection:AddLabel('you need a gun for these\n')

		local function checkTool() -- what the fuck
			if not lplr.Character then return end
			if not lplr.Character:FindFirstChildOfClass('Tool') then
				for i, v in next, lplr.Backpack:GetChildren() do
					if v:IsA('Tool') and table.find(gunsList, v.Name) then
						v.Parent = lplr.Character
						return true
					else
						return false
					end
				end
			end
			return true
		end

		do
			rageSection:AddToggle({
				text = 'Kill All',
				callback = function(t)
					if t then
						if library.flags.explodeAllCars then
							library.options.killAll:SetState(false)
							notif.new({text = 'turn of Explode All Cars if you want to use this', duration = 10})
							return
						end
						if not library.flags.antiRagdoll then library.options.antiRagdoll:SetState(true) end
						maid.killAll = runService.Heartbeat:Connect(function()
							local character = Util:getClosestCharacter({maxHealth = 200})
							character = character and character.Character
							if not character then lplr.CameraMaxZoomDistance = 30 return end

							local hit = character:FindFirstChild('HumanoidRootPart')
							local hitPos = hit and hit.CFrame.Position

							local camera = workspace.CurrentCamera
							if not camera then return end
							if not checkTool() then lplr.CameraMaxZoomDistance = 30 return end

							camera.CFrame = camera.CFrame:lerp(cframeNew(camera.CFrame.Position, hitPos), 1 / 1)

							lplr.Character.HumanoidRootPart.AssemblyLinearVelocity = vector3Zero
							lplr.Character.HumanoidRootPart.AssemblyAngularVelocity = vector3Zero

							lplr.CameraMaxZoomDistance = 0
							lplr.Character.HumanoidRootPart.CFrame = cframeNew(hitPos) * cframeNew(0, library.flags.killAllHeight, library.flags.killAllSpace)
							mouse1click()
						end)
					else
						maid.killAll = nil
						lplr.CameraMaxZoomDistance = 30
					end
				end
			}):AddBind({
				flag = 'Kill All Bind',
				callback = function()
					library.options.killAll:SetState(not library.flags.killAll)
				end
			})

			rageSection:AddSlider({text = 'Snap Height', textpos = 2, flag = 'Kill All Height', min = 0, max = 10, float = 0.1})
			rageSection:AddSlider({text = 'Snap Space', textpos = 2, flag = 'Kill All Space', min = -10, max = 10, float = 0.1})
		end
		
		rageSection:AddDivider()

		--[[do
			local function getClosestCar()
				local lastDistance, lastCar = math.huge, nil

				local myHead = lplr.Character and lplr.Character:FindFirstChild('Head')
				if not myHead then return end

				for i, v in next, workspace.Cars:GetChildren() do
					if not v:IsA('Folder') then continue end
					if not v:FindFirstChild(v.Name.. 'Car') then continue end
					if not v[v.Name.. 'Car']:FindFirstChild('PrimaryPart') then continue end
					--if v[v.Name.. 'Car'].Smoke.Part.Fire.Enabled then continue end
					--if v[v.Name.. 'Car'].Smoke.Part.Smoke.Enabled then continue end

					local newDistance = (myHead.Position - v[v.Name.. 'Car'].PrimaryPart.CFrame.Position).Magnitude
					if newDistance > lastDistance then continue end

					lastCar = v[v.Name.. 'Car'].PrimaryPart
					lastDistance = newDistance
				end

				return lastCar, lastDistance
			end

			rageSection:AddToggle({
				text = 'Explode All Cars',
				callback = function(t)
					if t then
						if library.flags.killAll then
							library.options.explodeAllCars:SetState(false)
							notif.new({text = 'turn of Kill All if you want to use this', duration = 10})
							return
						end
						maid.explodeCars = runService.Heartbeat:Connect(function()
							local car = getClosestCar()
							
							local camera = workspace.CurrentCamera
							if not camera then return end
							if not checkTool() then lplr.CameraMaxZoomDistance = 30 return end

							local pos = car and car.CFrame.Position

							camera.CFrame = camera.CFrame:lerp(cframeNew(camera.CFrame.Position, pos), 1 / 1)

							lplr.Character.HumanoidRootPart.AssemblyLinearVelocity = vector3Zero
							lplr.Character.HumanoidRootPart.AssemblyAngularVelocity = vector3Zero

							lplr.CameraMaxZoomDistance = 0

							lplr.Character.HumanoidRootPart.CFrame = cframeNew(pos) * cframeNew(0, library.flags.killAllHeight + 7, library.flags.killAllSpace)
							mouse1click()
						end)
					else
						maid.explodeCars = nil
						lplr.CameraMaxZoomDistance = 30
					end
				end
			}):AddBind({
				flag = 'Explode All Cars Bind',
				callback = function()
					library.options.explodeAllCars:SetState(not library.flags.explodeAllCars)
				end
			})

			rageSection:AddSlider({text = 'Snap Height', textpos = 2, flag = 'Explode Cars Height', min = 0, max = 10, float = 0.1})
			rageSection:AddSlider({text = 'Snap Space', textpos = 2, flag = 'Explode Cars Space', min = -15, max = 15, float = 0.1})
		end]]
	end
end

task.spawn(function()
	(function()
		for i, v in next, workspace:GetChildren() do
			if v:IsA('BasePart') and v.Name == 'Particles' then
				v:Destroy()
			end
		end
	end)()
end)

library:Init(false)
local timeTookToLoad = tick() - scriptLoadAt
notif.new({text = string.format('%s script loaded in %.02f seconds', library.gameName, timeTookToLoad), duration = 20})
warn(string.format('%s script loaded in %.02f seconds', library.gameName, timeTookToLoad))
