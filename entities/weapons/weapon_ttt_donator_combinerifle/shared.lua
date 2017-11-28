--Grappling weapons for Natrox

if SERVER then
	AddCSLuaFile( "shared.lua" )
end


if CLIENT then
   SWEP.PrintName = "Combine Rifle"
   SWEP.Slot = 1

   SWEP.Icon = ""
   
   SWEP.DrawCrosshair   = false
   SWEP.ViewModelFOV    = 78
   SWEP.ViewModelFlip   = false
   SWEP.CSMuzzleFlashes = true
end


SWEP.Base = "ep2snip_base"
SWEP.HoldType = "ar2"

SWEP.Primary.Sound			= Sound("jaanus/ep2sniper_fire.wav")
SWEP.Primary.Damage			= 40 -- This determines both the damage dealt and force applied by the bullet.
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 8
SWEP.Primary.DefaultClip	= 8
SWEP.Primary.Ammo			= "UnobtainableAmmo"
SWEP.Primary.ReloadSound	= "jaanus/ep2sniper_reload.wav"
SWEP.MuzzleVelocity			= 10000 -- How fast the bullet travels in meters per second. For reference, an AK47 shoots at about 750, an M4 shoots at about 900, and a Luger 9mm shoots at about 350 (source: Wikipedia)

SWEP.DeploySpeed = 0.25

SWEP.PlayerSpeedMod = 1


---------------------------------------
-- Recoil, Spread, and Spray --
---------------------------------------
SWEP.RecoverTime 	= 1.1 -- Time in seconds it takes the player to re-steady his aim after firing.

-- The following variables control the overall accuracy of the gun and typically increase with each shot
-- Recoil: how much the gun kicks back the player's view.
SWEP.MinRecoil		= 0.9
SWEP.MaxRecoil		= 1.1
SWEP.DeltaRecoil	= 0.15 -- The recoil to add each shot.  Same deal for spread and spray.

-- Spread: the width of the gun's firing cone.  More spread means less accuracy.
SWEP.MinSpread		= 0
SWEP.MaxSpread		= 0
SWEP.DeltaSpread	= 0.005

-- Spray: the gun's tendancy to point in random directions.  More spray means less control.
SWEP.MinSpray		= 0
SWEP.MaxSpray		= 1.4
SWEP.DeltaSpray		= 0.16

-- Ironsight/Scope --
---------------------------
-- IronSightsPos and IronSightsAng are model specific paramaters that tell the game where to move the weapon viewmodel in ironsight mode.
SWEP.IronSightsPos 			= Vector(-6, -12, 0.5) -- Comment out this line of you don't want ironsights.  This variable must be present if your SWEP is to use a scope.
SWEP.IronSightsAng 			= Vector(2.8, 0, 0)
SWEP.IronSightZoom			= 1.3 -- How much the player's FOV should zoom in ironsight mode. 
SWEP.UseScope				= true -- Use a scope instead of iron sights.
SWEP.ScopeScale 			= 0.4 -- The scale of the scope's reticle in relation to the player's screen size.
SWEP.ScopeZooms				= {8,16} -- The possible magnification levels of the weapon's scope.   If the scope is already activated, secondary fire will cycle through each zoom level in the table.
SWEP.DrawParabolicSights	= true -- Set to true to draw a cool parabolic sight (helps with aiming over long distances)

-------------------------
-- Effects/Visual --
-------------------------
SWEP.ViewModel				= "models/weapons/v_combinesniper_e2.mdl"
SWEP.WorldModel				= "models/weapons/w_combinesniper_e2.mdl"

SWEP.MuzzleEffect			= "rg_muzzle_cmb" -- This is an extra muzzleflash effect
-- Available muzzle effects: rg_muzzle_grenade, rg_muzzle_highcal, rg_muzzle_hmg, rg_muzzle_pistol, rg_muzzle_rifle, rg_muzzle_silenced, none

SWEP.ShellEffect			= "none" -- This is a shell ejection effect
-- Available shell eject effects: rg_shelleject, rg_shelleject_rifle, rg_shelleject_shotgun, none

SWEP.MuzzleAttachment		= "1" -- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.ShellEjectAttachment	= "1" -- Should be "2" for CSS models or "1" for hl2 models


-------------------
-- Modifiers --
-------------------
-- Modifiers scale the gun's recoil, spread, and spray based on the player's stance
SWEP.CrouchModifier		= 1 -- Applies if player is crouching.
SWEP.IronSightModifier 	= 0.6 -- Applies if player is in iron sight mode.
SWEP.RunModifier 		= 10 -- Applies if player is moving.
SWEP.JumpModifier 		= 15 -- Applies if player is in the air (jumping)

-- Note: the jumping and crouching modifiers cannot be applied simultaneously

--------------------
-- Fire Modes --
--------------------
-- You can choose from a list of firemodes, or add your own! \0/
SWEP.AvailableFireModes		= {"Semi"} -- What firemodes shall we use?
-- "Auto", "Burst", "Semi", and "Grenade" are firemodes that are available by default.

-- RPM is the rounds per minute the gun can fire for each mode (if applicable)
SWEP.AutoRPM				= 600
SWEP.SemiRPM				= 100
SWEP.BurstRPM				= 600 -- Burst RPM affects the space between the shots during the burst.  The space between bursts is determined by SemiRPM.
SWEP.DrawFireModes			= true -- Set to true to allow drawing of a visual indicator for the current firemode.

-- Additional parameters for the "Grenade" firemode
SWEP.GrenadeDamage			= 100
SWEP.GrenadeVelocity		= 1400
SWEP.GrenadeRPM				= 50

-- This was made by using Tetabonita's awesome example script, of course.

SWEP.LaserRespawnTime = 0.9
SWEP.LaserLastRespawn = 0



function SWEP:Think()
	
	if (self.LaserLastRespawn + self.LaserRespawnTime) < CurTime() and !self.Weapon:GetNetworkedBool("Scope") then
		local effectdata = EffectData()
		
		effectdata:SetOrigin( self:GetOwner():GetShootPos() )
		effectdata:SetEntity( self.Weapon )
		util.Effect( "sniperlaserbeam", effectdata ) 
		
		self.LaserLastRespawn = CurTime()
	end
end


function SWEP:Precache()
    	util.PrecacheSound("jaanus/ep2sniper_fire.wav")
	util.PrecacheSound("jaanus/ep2sniper_reload.wav")
	util.PrecacheSound("jaanus/ep2sniper_empty.wav")
end

if CLIENT then

   function SWEP:AdjustMouseSensitivity()
      return (self.Weapon:GetNetworkedBool("Ironsights",false) and 0.14) or nil
   end
end
