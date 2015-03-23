

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include('shared.lua')

function ENT:Spawn()
   print("spawn called")
   timer.Create(uuid(), 0.1, 0, scan);
   
end

function ENT:Initialize()
 
	self:SetModel( "models/props_interiors/BathTub01a.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
 
        local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end

function scan()
	for k, v in pairs( ents.GetAll() ) do
		local class = v:GetClass()
		//if class == "prop_door_rotating" then
		if self:GetPos():Distance(v:GetPos()) < 100 then
			print("Class name:" + class)
			bullet = {}
			bullet.Attacker = self
			bullet.Num = 1
			bullet.Force = 2
			bullet.Damage = 1
			bullet.Tracer = 1
			bullet.Src = self:GetPos()
			bullet.Spread = Vector(1, 1, 0)
			bullet.Dir = v:GetPos():Sub(self:GetPos())
			self:FireBullets(bullet)
		end
		//end
	end
end


local random = math.random
local function uuid()
    local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    return string.gsub(template, '[xy]', function (c)
        local v = (c == 'x') and random(0, 0xf) or random(8, 0xb)
        return string.format('%x', v)
    end)
end