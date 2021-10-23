--define the npc for Garry's Mod spawnmenu

local Category = "My NPC Category"

local NPC =
{
	Name = "NPCname",
	Class="npc_headcrab",	--Base NPC that you will modify e.g. npc_headcrab, npc_zombie . . .
	Material = "npc_NPCname",
	Category = Category
}

list.Set( "NPC", "NPCname", NPC )
