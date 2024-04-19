local Maid = loadstring(game:HttpGet('https://raw.githubusercontent.com/Iratethisname10/Code/main/aztup-ui/maid.lua'))()
local ToastNotif = loadstring(game:HttpGet('https://raw.githubusercontent.com/Iratethisname10/Code/main/aztup-ui/notifs.lua'))()
local Util = loadstring(game:HttpGet('https://raw.githubusercontent.com/Iratethisname10/Code/main/aztup-ui/util.lua'))()

local cloneref = cloneref or function(instance) return instance end

local playersService = cloneref(game:GetService('Players'))
local runService = cloneref(game:GetService('RunService'))
local lightingService = cloneref(game:GetService('Lighting'))
local userInputService = cloneref(game:GetService('UserInputService'))
local tweenService = cloneref(game:GetService('TweenService'))

if not playersService.LocalPlayer then playersService:GetPropertyChangedSignal('LocalPlayer'):Wait() end
local lplr = playersService.LocalPlayer

local mouse = lplr:GetMouse()

local vector2New = Vector2.new
local vector3New = Vector3.new
local vector3Zero = Vector3.zero
local vector3One = Vector3.one
local cframeNew = CFrame.new
local cframeAngles = CFrame.Angles
local instanceNew = Instance.new

local maid = Maid.new()

local function sendNotification(text, duration)
	return ToastNotif.new({
		text = tostring(text or 'you did not provide text for this notificatin'),
		duration = duration
	})
end

local function alive()
	return lplr and lplr.Character and lplr.Character.Parent ~= nil and lplr.Character:FindFirstChild('HumanoidRootPart') and lplr.Character:FindFirstChild('Head') and lplr.Character:FindFirstChild('Humanoid')
end

local basics = {}

local flyVertical = 0
local oldBritghtness, oldAmbient
local oldTime
local teleporting = false
local noPhysicsBV

local rayParams = RaycastParams.new()
rayParams.RespectCanCollide = true
rayParams.FilterType = Enum.RaycastFilterType.Exclude
rayParams.FilterDescendantsInstances = {workspace.CurrentCamera, lplr.Character}

function basics.fly(toggle, horizontalSpeed, verticalSpeed)
	if not toggle then
		flyVertical = 0
		maid.flyBV = nil
		maid.flyLoop = nil
		return
	end

	maid.flyLoop = runService.Heartbeat:Connect(function(delta)
		if not alive() then return end

		if userInputService:IsKeyDown(Enum.KeyCode.Space) then
			flyVertical = verticalSpeed
		elseif userInputService:IsKeyDown(Enum.KeyCode.LeftShift) or userInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
			flyVertical = -verticalSpeed
		else
			flyVertical = 0
		end

		if lplr.Character.Humanoid.SeatPart then lplr.Character.Humanoid.Sit = false end
		lplr.Character.HumanoidRootPart.AssemblyLinearVelocity = vector3Zero
		local vector = lplr.Character.Humanoid.MoveDirection

		local flyVector = vector3New(vector.X * horizontalSpeed * delta, flyVertical * delta, vector.Z * horizontalSpeed * delta)

		maid.flyBV = maid.flyBV or instanceNew('BodyVelocity', lplr.Character.HumanoidRootPart)
		maid.flyBV.MaxForce = vector3One * math.huge
		maid.flyBV.Velocity = flyVector
		
		lplr.Character.HumanoidRootPart.CFrame += flyVector
	end)
end

function basics.speed(toggle, speed)
	if not toggle then
		maid.speedLoop = nil
		return
	end

	maid.speedLoop = runService.Heartbeat:Connect(function(delta)
		if not alive() then return end

		lplr.Character.HumanoidRootPart.AssemblyLinearVelocity *= vector3New(0, 1, 0)

		local vector = lplr.Character.Humanoid.MoveDirection
		local speedVector = vector3New(vector.X * speed * delta, 0, vector.Z * speed * delta)
		
		lplr.Character.HumanoidRootPart.CFrame += speedVector
	end)
end

function basics.infiniteJump(toggle, height)
	if not toggle then
		maid.infJumpLoop = nil
		return
	end

	maid.infJumpLoop = runService.Heartbeat:Connect(function()
		if not alive() then return end

		if userInputService:IsKeyDown(Enum.KeyCode.Space) then
			local velocity = lplr.Character.HumanoidRootPart.AssemblyLinearVelocity
			lplr.Character.HumanoidRootPart.AssemblyLinearVelocity = vector3New(velocity.X, height or lplr.Character.Humanoid.JumpPower, velocity.Z)
		end
	end)
end

function basics.noclip(toggle, instantRevert)
	if not toggle then
		maid.noclipLoop = nil

		if not alive() then return end
		if not instantRevert then return end

		if lplr.Character.Humanoid.SeatPart then return end

		lplr.Character.Humanoid:ChangeState('Physics')
		task.wait()
		lplr.Character.Humanoid:ChangeState('RunningNoPhysics')
		return
	end

	maid.noclipLoop = runService.Stepped:Connect(function()
		if not alive() then return end

		for _, v in next, lplr.Character:GetDescendants() do
			if v:IsA('BasePart') then
				v.CanCollide = false
			end
		end
	end)
end

function basics.fullBright(toggle)
	if not toggle then
		maid.fullBrightLoop = nil

		if not oldAmbient then return end
		if not oldBritghtness then return end

		lightingService.Brightness = oldBritghtness
		lightingService.Ambient = oldAmbient
		return
	end
	
	oldBritghtness, oldAmbient = lightingService.Brightness, lightingService.Ambient
	
	maid.fullBrightLoop = lightingService:GetPropertyChangedSignal('Ambient'):Connect(function()
		lightingService.Ambient = Color3.fromRGB(255, 255, 255)
		lightingService.Brightness = 3.5
	end)
	lightingService.Ambient = Color3.fromRGB(255, 255, 255)
end

function basics.customTime(toggle, time)
	if not toggle then
		maid.customTimeLoop = nil

		if not oldTime then return end
		lightingService.ClockTime = oldTime
		return
	end

	oldTime = lightingService.ClockTime

	maid.customTimeLoop = runService.RenderStepped:Connect(function()
		lightingService.ClockTime = time
	end)
	lightingService.ClockTime = time
end

function basics.teleport(position, options)
	if not alive() then return end
	if teleporting then return end

	teleporting = true

	if typeof(position) == 'Vector3' then position = cframeNew(position) end

	options = options or {}
	options.offset = options.offset or CFrame.identity * position.Rotation
	options.tweenSpeed = options.tweenSpeed or 100

	task.delay(not options.safeLoad and options.timeout or 35, function()
		if teleporting then return end

		teleporting = false
		lplr.Character.HumanoidRootPart.Anchored = false
		lplr.Character.HumanoidRootPart.AssemblyLinearVelocity = vector3Zero
	end)

	if lplr.Character.Humanoid.SeatPart then
		if options.holdWhenSitting then teleporting = false return end
		lplr.Character.Humanoid.Sit = false
		task.wait()
	end

	if options.tween then
		local distance = (lplr.Character.HumanoidRootPart.CFrame.Position - position.Position).Magnitude
		local tweenInfo = TweenInfo.new(distance / options.tweenSpeed, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)

		lplr.Character.HumanoidRootPart.CFrame *= options.offset

		local tween = tweenService:Create(lplr.Character.HumanoidRootPart, tweenInfo, {
			CFrame = position * options.offset
		}):Play()
	else
		lplr.Character.HumanoidRootPart.CFrame = position
	end
	
	if options.safeLoad then
		lplr.Character.HumanoidRootPart.Anchored = true

		repeat
			local ray = workspace:Raycast(lplr.Character.HumanoidRootPart.CFrame.Position, vector3New(0, -150, 0), rayParams)
			task.wait()
		until ray and ray.Instance

		lplr.Character.HumanoidRootPart.Anchored = false
	end

	lplr.Character.HumanoidRootPart.AssemblyLinearVelocity = vector3Zero
	teleporting = false
end

return basics
