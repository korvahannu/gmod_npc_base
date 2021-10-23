-- Optional, but you can add custom killfeed icons with this

net.Receive( "DeathMessage_NPCname", function( len, ply )
	killicon.Add( "NPCname_killfeed", "somefolder/somefile.vtf", Color(255,255,255,255) )
	
	GAMEMODE:AddDeathNotice(net:ReadString(), 0, "NPCname_killfeed", "NPCname", 1001)
end )

--[[ Example of what the .vmt file of killfeed icon could contain

	"UnlitGeneric"
	{
		"$basetexture"		"somefolder/somefile.vtf"
		"$vertexalpha" 		1
	}

]]