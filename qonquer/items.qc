
void() golden_backpack_touch =
{
	// Give the player the appropriate weapons
	
	if (self.spawnflags & BACKPACK_SUPER_SHOTGUN)
	{
		self.classname = "weapon_supershotgun";
		self.netname = "Double-barrelled Shotgun";
		self.weapon = IT_SUPER_SHOTGUN;
		weapon_touch();
	}
	if (self.spawnflags & BACKPACK_NAILGUN)
	{
		self.classname = "weapon_nailgun";
		self.netname = "Nailgun";
		self.weapon = IT_NAILGUN;
		weapon_touch();
	}
	if (self.spawnflags & BACKPACK_SUPER_NAILGUN)
	{
		self.classname = "weapon_supernailgun";
		self.netname = "Super Nailgun";
		self.weapon = IT_SUPER_NAILGUN;
		weapon_touch();
	}
	if (self.spawnflags & BACKPACK_GRENADE_LAUNCHER)
	{
		self.classname = "weapon_grenadelauncher";
		self.netname = "Grenade Launcher";
		self.weapon = IT_GRENADE_LAUNCHER;
		weapon_touch();
	}
	if (self.spawnflags & BACKPACK_ROCKET_LAUNCHER)
	{
		self.classname = "weapon_rocketlauncher";
		self.netname = "Rocket Launcher";
		self.weapon = IT_ROCKET_LAUNCHER;
		weapon_touch();
	}
	if (self.spawnflags & BACKPACK_LIGHTNING)
	{
		self.classname = "weapon_lightning";
		self.netname = "Thunderbolt";
		self.weapon = IT_LIGHTNING;
		weapon_touch();
	}
	
	SUB_UseTargets();
	
	remove (self);
};

/*QUAKED item_golden_backpack (1.0 0.75 0.10) (-16 -16 0) (16 16 56) Double-barrelled_Shotgun Nailgun Super_Nailgun Grenade_Launcher Rocket_Launcher Thunderbolt
*/
void() item_golden_backpack =
{
	StartItem();

	setmodel (self, "progs/backpack.mdl");
	setsize (self, '-16 -16 0', '16 16 56');
	self.effects = self.effects | EF_BRIGHTFIELD | EF_DIMLIGHT;
	
	self.touch = golden_backpack_touch;
};

