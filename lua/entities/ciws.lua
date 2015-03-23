

AddCSLuaFile()

include('shared.lua')

function ENT:SpawnFunction( ply, tr, ClassName )

	if ( !tr.Hit ) then return end

	local SpawnPos = tr.HitPos + tr.HitNormal * 16

	local ent = ents.Create( ClassName )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	ent:OnSpawn(ent)
	return ent

end

function ENT:OnSpawn(self)
   print("spawn called")
   timer.Create("scanner", 0.1, 0, function() scan(self) end);
   
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

function scan(self)
	print("scan")
	for k, v in pairs( ents.FindInSphere(self:GetPos(), 100) ) do
		local class = v:GetClass()
		if v.IsNPC() then
		//if class == "prop_door_rotating" then
		//if self:GetPos():Distance(v:GetPos()) < 100 then
			print("Class name:")
			print(class)
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
		//end
		end
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