/*
===============================================================================

WEAPONS

===============================================================================
*/

void() W_SetCurrentAmmo;

void() bound_other_ammo =
{
	if (other.ammo_shells > MAX_AMMO_SHELLS)
		other.ammo_shells = MAX_AMMO_SHELLS;
	if (other.ammo_nails > MAX_AMMO_NAILS)
		other.ammo_nails = MAX_AMMO_NAILS;
	if (other.ammo_rockets > MAX_AMMO_ROCKETS)
		other.ammo_rockets = MAX_AMMO_ROCKETS;		
	if (other.ammo_cells > MAX_AMMO_CELLS)
		other.ammo_cells = MAX_AMMO_CELLS;		
};

#ifdef ID1
float(entity ent, float w) RankForWeapon =
{
	if (w == IT_LIGHTNING && ent.waterlevel <= LEVEL_FEET)
		return 1;
	if (w == IT_ROCKET_LAUNCHER)
		return 2;
	if (w == IT_SUPER_NAILGUN)
		return 3;
	if (w == IT_GRENADE_LAUNCHER)
		return 4;
	if (w == IT_SUPER_SHOTGUN)
		return 5;
	if (w == IT_NAILGUN)
		return 6;
	return 7;
};
#endif

#ifdef HIPNOTIC
float(entity ent, float w) RankForWeapon =
{
	if (w == IT_LIGHTNING && ent.waterlevel <= LEVEL_FEET)
		return 1;
	if (w == IT_ROCKET_LAUNCHER)
		return 2;
	if (w == IT_LASER_CANNON)
		return 3;
	if (w == IT_SUPER_NAILGUN)
		return 4;
	if (w == IT_GRENADE_LAUNCHER)
		return 5;
	if (w == IT_SUPER_SHOTGUN)
		return 6;
	if (w == IT_NAILGUN)
		return 7;
	if (w == IT_PROXIMITY_GUN)
		return 8;
	if (w == IT_MJOLNIR)
		return 9;
	return 10;
};
#endif

/*
=============
Deathmatch_Weapon

Deathmatch weapon change rules for picking up a weapon

.float		ammo_shells, ammo_nails, ammo_rockets, ammo_cells;
=============
*/
//void(float old, float new) Deathmatch_Weapon =
void(entity ent, float new) Deathmatch_Weapon =
{
	local float or, nr;

// change self.weapon if desired
//	or = RankForWeapon (self.weapon);
//	nr = RankForWeapon (new);
	or = RankForWeapon (ent, ent.weapon);
	nr = RankForWeapon (ent, new);
	if ( nr < or )
//		self.weapon = new;
		ent.weapon = new;
};

/*
=============
weapon_touch
=============
*/
float() W_BestWeapon;

void() weapon_touch =
{
	local	float	best, new;	//hadammo, old;
	local	entity	stemp;
	local	float	leave;
//	local 	float	donttake;

	if (!(other.flags & FL_CLIENT))
		return;

// if the player was using his best weapon, change up to the new one if better		
	stemp = self;
	self = other;
	best = W_BestWeapon();
	self = stemp;

	if (deathmatch == 2 || coop)
		leave = 1;
	else
		leave = 0;
	
	if (self.classname == "weapon_nailgun")
	{
		if (leave && (other.items & IT_NAILGUN))
			return;
		if (!deathmatch && (other.items & IT_NAILGUN) && (other.ammo_nails > MAX_AMMO_NAILS - 1))
		{
			activator = other;
			SUB_UseTargets();			// fire all targets / killtargets
			return;
		}
		new = IT_NAILGUN;
		other.ammo_nails = other.ammo_nails + 30;
	}
	else if (self.classname == "weapon_supernailgun")
	{
		if (leave && (other.items & IT_SUPER_NAILGUN))
			return;
		if (!deathmatch && other.items & IT_SUPER_NAILGUN && (other.ammo_nails > MAX_AMMO_NAILS - 1))
		{
			activator = other;
			SUB_UseTargets();			// fire all targets / killtargets
			return;
		}
		new = IT_SUPER_NAILGUN;
		other.ammo_nails = other.ammo_nails + 30;
	}
	else if (self.classname == "weapon_supershotgun")
	{
		if (leave && (other.items & IT_SUPER_SHOTGUN))
			return;
		if (!deathmatch && (other.items & IT_SUPER_SHOTGUN) && (other.ammo_shells > MAX_AMMO_SHELLS - 1))
		{
			activator = other;
			SUB_UseTargets();			// fire all targets / killtargets
			return;
		}
		new = IT_SUPER_SHOTGUN;
		other.ammo_shells = other.ammo_shells + 5;
	}
	else if (self.classname == "weapon_rocketlauncher")
	{
		if (leave && (other.items & IT_ROCKET_LAUNCHER))
			return;
		if (!deathmatch && (other.items & IT_ROCKET_LAUNCHER) && (other.ammo_rockets > MAX_AMMO_ROCKETS - 1))
		{
			activator = other;
			SUB_UseTargets();			// fire all targets / killtargets
			return;
		}
		new = IT_ROCKET_LAUNCHER;
		other.ammo_rockets = other.ammo_rockets + 5;
	}
	else if (self.classname == "weapon_grenadelauncher")
	{
		if (leave && (other.items & IT_GRENADE_LAUNCHER))
			return;
		if (!deathmatch && (other.items & IT_GRENADE_LAUNCHER) && (other.ammo_rockets > MAX_AMMO_ROCKETS - 1))
		{
			activator = other;
			SUB_UseTargets();			// fire all targets / killtargets
			return;
		}
		new = IT_GRENADE_LAUNCHER;
		other.ammo_rockets = other.ammo_rockets + 5;
	}
	else if (self.classname == "weapon_lightning")
	{
		if (leave && (other.items & IT_LIGHTNING))
			return;
		if (!deathmatch && (other.items & IT_LIGHTNING) && (other.ammo_cells > MAX_AMMO_CELLS - 1))
		{
			activator = other;
			SUB_UseTargets();			// fire all targets / killtargets
			return;
		}
		new = IT_LIGHTNING;
		other.ammo_cells = other.ammo_cells + 15;
	}

#ifdef HIPNOTIC
	else if (self.classname == "weapon_laser_gun")
	{
		if (leave && (other.items & IT_LASER_CANNON))
			return;
		if (!deathmatch && (other.items & IT_LASER_CANNON) && (other.ammo_cells > MAX_AMMO_CELLS - 1))
		{
			activator = other;
			SUB_UseTargets();			// fire all targets / killtargets
			return;
		}
		new = IT_LASER_CANNON;
		other.ammo_cells = other.ammo_cells + 30;
	}

	else if (self.classname == "weapon_mjolnir")
	{
		if (leave && (other.items & IT_MJOLNIR))
			return;
		if (!deathmatch && (other.items & IT_MJOLNIR) && (other.ammo_cells > MAX_AMMO_CELLS - 1))
		{
			activator = other;
			SUB_UseTargets();			// fire all targets / killtargets
			return;
		}
		new = IT_MJOLNIR;
		other.ammo_cells = other.ammo_cells + 30;
	}

	else if (self.classname == "weapon_proximity_gun")
	{
		if (leave && (other.items & IT_PROXIMITY_GUN) )
			return;
		if (!deathmatch && (other.items & IT_PROXIMITY_GUN) && (other.ammo_rockets > MAX_AMMO_ROCKETS - 1))
		{
			activator = other;
			SUB_UseTargets();			// fire all targets / killtargets
			return;
		}
		new = IT_PROXIMITY_GUN;
		other.ammo_rockets = other.ammo_rockets + 6;
	}
#endif

	else
		objerror ("weapon_touch: unknown classname");

	sprint (other, "You got the ");
	sprint (other, self.netname);
	sprint (other, "\n");
// weapon touch sound
	sound (other, CHAN_ITEM, "weapons/pkup.wav", 1, ATTN_NORM);
	stuffcmd (other, "bf\n");

	bound_other_ammo ();



// change to the weapon
// ...always if new one
	if (!(other.items & new))
		Deathmatch_Weapon (other, new);
	other.items = other.items | new;
	
	stemp = self;
	self = other;

	if ( other.weapon == best )
		self.weapon = W_BestWeapon();

	W_SetCurrentAmmo();

	self = stemp;

	if (leave)
		return;

// remove it in single player, or setup for respawning in deathmatch
	self.model = "";
	self.solid = SOLID_NOT;

	if (deathmatch == 1 || qonquer)
		self.nextthink = time + 30;

	self.think = SUB_Regen;
	
	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
};


/*QUAKED weapon_supershotgun (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() weapon_supershotgun =
{
	precache_model ("progs/g_shot.mdl");
	setmodel (self, "progs/g_shot.mdl");
	self.weapon = IT_SUPER_SHOTGUN;
	self.netname = "Double-barrelled Shotgun";
	self.touch = weapon_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};

/*QUAKED weapon_nailgun (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() weapon_nailgun =
{
	precache_model ("progs/g_nail.mdl");
	setmodel (self, "progs/g_nail.mdl");
	self.weapon = IT_NAILGUN;
	self.netname = "nailgun";
	self.touch = weapon_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};

/*QUAKED weapon_supernailgun (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() weapon_supernailgun =
{
	precache_model ("progs/g_nail2.mdl");
	setmodel (self, "progs/g_nail2.mdl");
	self.weapon = IT_SUPER_NAILGUN;
	self.netname = "Super Nailgun";
	self.touch = weapon_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};

/*QUAKED weapon_grenadelauncher (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() weapon_grenadelauncher =
{
	precache_model ("progs/g_rock.mdl");
	setmodel (self, "progs/g_rock.mdl");
	self.weapon = 3;
	self.netname = "Grenade Launcher";
	self.touch = weapon_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};

/*QUAKED weapon_rocketlauncher (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() weapon_rocketlauncher =
{
	precache_model ("progs/g_rock2.mdl");
	setmodel (self, "progs/g_rock2.mdl");
	self.weapon = 3;
	self.netname = "Rocket Launcher";
	self.touch = weapon_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};


/*QUAKED weapon_lightning (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() weapon_lightning =
{
	precache_model ("progs/g_light.mdl");
	setmodel (self, "progs/g_light.mdl");
	self.weapon = 3;
	self.netname = "Thunderbolt";
	self.touch = weapon_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};
