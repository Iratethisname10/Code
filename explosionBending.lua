local cloneref = cloneref or function(instance) return instance; end;

local replicatedStorage = cloneref(game:GetService('ReplicatedStorage'));
local userInputService = cloneref(game:GetService('UserInputService'));
local playersService = cloneref(game:GetService('Players'));
local runService = cloneref(game:GetService('RunService'));

if (not playersService.LocalPlayer) then playersService:GetPropertyChangedSignal('LocalPlayer'):Wait(); end;
local lplr = playersService.LocalPlayer;

local gameCam = workspace.CurrentCamera;

local acsEngine = replicatedStorage.ACS_Engine;
local hitEffect = acsEngine.Events.HitEffect;
local shellDrop = acsEngine.Events.Shell;

local function doIslam(explosionPower, rayCast)
	local vec0 = Vector3.new(-59.41989517211914, 445.3965759277344, -584.8765869140625);
	
	local args = {
		[1] = rayCast.Position,
		[2] = rayCast.Instance,
		[3] = Vector3.zero,
		[4] = rayCast.Material,
		[5] = {
			['Ammo'] = 1,
			['DamageFallOf'] = 1,
			['ShootRate'] = 800,
			['IgnoreProtection'] = true,
			['EnableZeroing'] = true,
			['ExplosionRadius'] = typeof(explosionPower) == 'number' and explosionPower or 9e8,
			['IncludeChamberedBullet'] = false,
			['Zoom'] = 40,
			['HolsterCFrame'] = CFrame.new(0.800000011920929, 1, 0.8999999761581421, -0.9848077297210693, 0.1736481785774231, -8.742277657347586e-08, 7.850422178989902e-08, -5.822811743882994e-08, -1, -0.1736481785774231, -0.9848077297210693, 4.371138828673793e-08),
			['MaxRecoilPower'] = 0,
			['SightAtt'] = '',
			['BulletPenetration'] = 72,
			['CanCheckMag'] = false,
			['MuzzleVelocity'] = 300,
			['ExplosionType'] = 'Default',
			['CanBreachDoor'] = false,
			['AmmoInGun'] = 1,
			['camRecoil'] = {
				['camRecoilUp'] = {
					[1] = 70,
					[2] = 75
				},
				['camRecoilRight'] = {
					[1] = 40,
					[2] = 45
				},
				['camRecoilLeft'] = {
					[1] = 40,
					[2] = 45
				},
				['camRecoilTilt'] = {
					[1] = 90,
					[2] = 100
				}
			},
			['gunName'] = 'RPG-30',
			['HeadDamage'] = {
				[1] = 170,
				[2] = 170
			},
			['Zoom2'] = 40,
			['MagCount'] = true,
			['InfraRed'] = false,
			['AimInaccuracyStepAmount'] = 0.75,
			['CurrentZero'] = 0,
			['RainbowMode'] = false,
			['CrosshairOffset'] = 5,
			['AimSpreadReduction'] = 1,
			['ShootType'] = 1,
			['FlashChance'] = 10,
			['AimSensitivity'] = 0.2,
			['Bullets'] = 1,
			['EnableHUD'] = true,
			['SlideEx'] = CFrame.new(0, 0, -0.4000000059604645, 1, 0, 0, 0, 1, 0, 0, 0, 1),
			['Tracer'] = false,
			['LimbDamage'] = {
				[1] = 170,
				[2] = 170
			},
			['Holster'] = true,
			['UnderBarrelAtt'] = '',
			['Jammed'] = false,
			['TracerEveryXShots'] = 3,
			['CenterDot'] = true,
			['MinSpread'] = 0.75,
			['Type'] = 'Gun',
			['FireModes'] = {
				['Auto'] = true,
				['ChangeFiremode'] = false,
				['Burst'] = false,
				['Semi'] = true
			},
			['BarrelAtt'] = '',
			['OtherAtt'] = '',
			['AimRecoilReduction'] = 4,
			['TorsoDamage'] = {
				[1] = 170,
				[2] = 170
			},
			['ShellInsert'] = true,
			['MinDamage'] = 5,
			['gunRecoil'] = {
				['gunRecoilTilt'] = {
					[1] = 50,
					[2] = 75
				},
				['gunRecoilUp'] = {
					[1] = 150,
					[2] = 200
				},
				['gunRecoilLeft'] = {
					[1] = 100,
					[2] = 175
				},
				['gunRecoilRight'] = {
					[1] = 100,
					[2] = 175
				}
			},
			['BurstShot'] = 3,
			['CanBreak'] = false,
			['RecoilPowerStepAmount'] = 0.1,
			['canAim'] = true,
			['MaxSpread'] = 100,
			['MinRecoilPower'] = 0,
			['IsLauncher'] = true,
			['CrossHair'] = true,
			['MaxStoredAmmo'] = 0,
			['WalkMult'] = 0,
			['AimInaccuracyDecrease'] = 0.25,
			['SlideLock'] = false,
			['BulletType'] = 'PG-18',
			['ADSEnabled'] = {
				[1] = true,
				[2] = false
			},
			['BulletDrop'] = 0.25,
			['TracerColor'] = Color3.new(1, 1, 1),
			['MaxZero'] = 500,
			['RandomTracer'] = {
				['Enabled'] = false,
				['Chance'] = 25
			},
			['adsTime'] = 1,
			['BulletFlare'] = false,
			['StoredAmmo'] = 2,
			['AimZoomSpeed'] = 1,
			['ShellEjectionMod'] = false,
			['HolsterPoint'] = 'Torso',
			['ZeroIncrement'] = 50,
			['WeaponWeight'] = 8,
			['ExplosiveAmmo'] = true
		}
	};

	hitEffect:FireServer(unpack(args));
end;

local rayParams = RaycastParams.new();
rayParams.RespectCanCollide = true;
rayParams.FilterType = Enum.RaycastFilterType.Exclude;
rayParams.FilterDescendantsInstances = {gameCam, lplr.Character};

while (not _G.stop) do
	local mouse = lplr:GetMouse();
	if (not mouse) then return; end;

	local ray = workspace:Raycast(gameCam.CFrame.Position, mouse.UnitRay.Direction * 10000, rayParams)

	if (userInputService:IsKeyDown(Enum.KeyCode.E) and ray and ray.Instance) then
		doIslam(10, ray)
	end;

	task.wait(0.36);
end;
