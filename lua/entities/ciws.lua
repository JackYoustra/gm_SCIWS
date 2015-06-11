

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

function ENT:Draw()
    -- self.BaseClass.Draw(self) -- Overrides Draw
    self:DrawModel() -- Draws Model Client Side
end

function ENT:OnSpawn(self)
   print("spawn called")
   timer.Create(uuid(), 0.03, 0, function() scan(self) end);
   
end

function ENT:Initialize()
    if CLIENT then return end
	self:SetModel( "models/props_interiors/BathTub01a.mdl" )
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)

    local physics = self:GetPhysicsObject()
    if ( IsValid(physics) ) then
        physics:Wake()
    end
end

function scan(self)
	local distance = 1001
	local currentTarget = nil
	for k, v in pairs( ents.FindInSphere(self:GetPos(), 1000) ) do
		local class = v:GetClass()
		if v.IsNPC() and v:Health() > 0  then
			local currentDistance = self:GetPos():Distance(v:GetPos())
			if (currentDistance < distance) then
			    distance = currentDistance
				currentTarget = v
			end
		end
	end
	if (currentTarget != nil) then
		CIWSShoot(self, currentTarget:GetPos())
	end
end

function CIWSShoot(self, targetPosition)
	sound.Play( "ciwsshort.mp3", self:GetPos(), 75, 100, 1)
	bullet = {}
	bullet.Attacker = self
	bullet.Num = 1
	bullet.Force = 2
	bullet.Damage = 1
	bullet.Tracer = 1
	bullet.TracerName = "Tracer" //https://maurits.tv/data/garrysmod/wiki/wiki.garrysmod.com/index7161.html
	bullet.Src = self:GetPos()
	bullet.Spread = Vector(16, 16, 0)
	
	local shotVector =  targetPosition
	shotVector:Sub(self:GetPos())
	bullet.Dir = shotVector
	self:FireBullets(bullet)
end


local random = math.random
local function uuid()
    local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    return string.gsub(template, '[xy]', function (c)
        local v = (c == 'x') and random(0, 0xf) or random(8, 0xb)
        return string.format('%x', v)
    end)
end