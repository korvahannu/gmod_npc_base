--The script file used to modify your NPC from the default NPC base you use


local health = 30
local healthReserve = 1000
local model = "models/mynpc/NPCname.mdl"
local name = "npc_NPCname"

local sndStaticDeath = "deathsound.wav"		--Define death sound

local sndRndDeath = {						--Define a random death sound (played along with the static one)
	Sound("NPCname/bodydrop1.wav"),
	Sound("NPCname/bodydrop2.wav"),
	Sound("NPCname/bodydrop3.wav"),
	Sound("NPCname/bodydrop4.wav")
}

--Used to send the death message (check the clientside script)
util.AddNetworkString( "NPCname_killfeed" )


-- Remove this hook if you want
-- What this does: If you load a custom map and an npc has the name NPCname_hammer, this script modifys the NPC to your custom npc
hook.Add("Initialize", "NPCname_hammer", function ()

	timer.Simple( 0.1, function()
	
		for k, hent in pairs( ents.FindByClass( "npc_*" ) ) do
			
			if hent:IsValid() and hent:GetName() == name then
				
				--Used when you add an npc directly to a map
				--Npc's with the corresponding names will be changed to match
				
				SetNPC(hent)
				
				
			end
		
		end
	
	end )

end)

--This function is used when the player spawns the npc from the spawn menu or console
hook.Add( "OnEntityCreated", "NPCname_created", function( ent )

	timer.Simple( 0.1, function()
		
		if ent:IsValid() and ent:GetMaterial() == name then
			
			SetNPC_crabhead(ent)
			
		end
		
	end )

end)

hook.Add( "EntityTakeDamage", "NPCName_takedamage", function( target,dmginfo )

	if target:IsValid() and target:GetName() == name and target:IsNPC() and target:Health() <= healthReserve then
			
			--This code runs when the npc dies
			
			--Play death sound(s)
			target:EmitSound(sndStaticDeath)
			target:EmitSound(table.Random(sndRndDeath))
			
			--Create ragdoll
			local rag = ents.Create("prop_ragdoll")
			rag:SetName("NPCname_ragdoll")
			rag:SetPos(target:GetPos())
			rag:SetAngles(target:GetAngles())
			rag:SetModel(target:GetModel())
			rag:Spawn()
			rag:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
			
			-- Create ragdoll, add some punch to it etc.
			local succ, err = pcall( function() rag:GetPhysicsObject():AddVelocity(dmginfo:GetAttacker():GetAimVector()*math.random(200, 400)*Vector(1, 1, -2)) end )

			--horrorween_ScaleBone(rag, 6)	Commented out, but you need to mess around with this if you set the model scale at spawn to custom value
				
			--Send the custom death message to clients
			net.Start("DeathMessage_NPCname")
			net.WriteString(dmginfo:GetAttacker():GetName())
			net.Broadcast()
			
			--Remove NPC, leave the ragdoll on ground
			target:Remove();
			
			-- This script simply fades the body out and removes it. You can comment this out if you want
			timer.Simple( 10, function()
				rag:SetColor(Color(255, 255, 255, 240))
				rag:SetRenderMode( RENDERMODE_TRANSALPHA )
			end)
			timer.Simple( 10.25, function()
				rag:SetColor(Color(255, 255, 255, 220))
				rag:SetRenderMode( RENDERMODE_TRANSALPHA )
			end)
			timer.Simple( 10.5, function()
				rag:SetColor(Color(255, 255, 255, 190))
				rag:SetRenderMode( RENDERMODE_TRANSALPHA )
			end)
			timer.Simple( 10.8, function()
				rag:SetColor(Color(255, 255, 255, 150))
				rag:SetRenderMode( RENDERMODE_TRANSALPHA )
			end)
			timer.Simple( 11, function()
				rag:SetColor(Color(255, 255, 255, 100))
				rag:SetRenderMode( RENDERMODE_TRANSALPHA )
			end)
			timer.Simple( 11.1, function()
				rag:SetColor(Color(255, 255, 255, 40))
				rag:SetRenderMode( RENDERMODE_TRANSALPHA )
			end)
			timer.Simple( 11.15, function()
				rag:Remove()
			end)
			
	end

end)

-- Set the NPC settings
function SetNPC(npcToSet)

	npcToSet:SetMaterial(name)
	npcToSet:SetModel(model)
	npcToSet:SetHealth(health + healthReserve)
	npcToSet:SetName(name)
	
	--npcToSet:SetModelScale( 1.2, 0 ) Commented this out, but you can change the NPC size with this
end

--[[ If you used SetModelScale at line above, you need to set the 

function horrorween_ScaleBone( ent, scale )
	
	for i = 0, ent:GetBoneCount() do
	
		-- Some bones are scaled only in certain directions (like legs don't scale on length)
		local v = Vector( scale, scale, scale )
		
		local TargetScale = ent:GetManipulateBoneScale( i ) + v * 0.1

		if ( TargetScale.x < 0 ) then TargetScale.x = 0 end
		if ( TargetScale.y < 0 ) then TargetScale.y = 0 end
		if ( TargetScale.z < 0 ) then TargetScale.z = 0 end

		ent:ManipulateBoneScale( i, TargetScale )
	end

end

]]