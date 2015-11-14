/*
===============================================================================

AMMO

===============================================================================
*/

void() ammo_touch =
{
	local	entity	stemp;
	local	float	taken;
//local float	best;

	if (other.classname != "player")
		return;
	if (other.health <= 0)
		return;

// if the player was using his best weapon, change up to the new one if better		
	//stemp = self;
	//self = other;
	//best = W_BestWeapon();
	//self = stemp;

// shotgun
	if (self.weapon == AMMO_SHELLS)
	{
		if (other.ammo_shells < MAX_AMMO_SHELLS)
		{
			other.ammo_shells = other.ammo_shells + self.aflag;
			taken = TRUE;
		}
	}

// spikes
	if (self.weapon == AMMO_NAILS)
	{
		if (other.ammo_nails < MAX_AMMO_NAILS)
		{
			other.ammo_nails = other.ammo_nails + self.aflag;
			taken = TRUE;
		}
	}

//	rockets
	if (self.weapon == AMMO_ROCKETS)
	{
		if (other.ammo_rockets < MAX_AMMO_ROCKETS)
		{
			other.ammo_rockets = other.ammo_rockets + self.aflag;
			taken = TRUE;
		}
	}

//	cells
	if (self.weapon == AMMO_CELLS)
	{
		if (other.ammo_cells < MAX_AMMO_CELLS)
		{
			other.ammo_cells = other.ammo_cells + self.aflag;
			taken = TRUE;
		}
	}

	if (taken)
	{
		bound_other_ammo ();
		sprint (other, "You got the ");
		sprint (other, self.netname);
		sprint (other, "\n");

// ammo touch sound
		sound (other, CHAN_ITEM, "weapons/lock4.wav", 1, ATTN_NORM);
		stuffcmd (other, "bf\n");
	
// if changed current ammo, update it
		stemp = self;
		self = other;
		W_SetCurrentAmmo();
		self = stemp;
	
// remove it in single player, or setup for respawning in deathmatch
		self.model = "";
		self.solid = SOLID_NOT;

		if (deathmatch == 1 || qonquer)
			self.nextthink = time + 30;

		self.think = SUB_Regen;
	}

	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
};


/*QUAKED item_shells (0 .5 .8) (0 0 0) (32 32 32) big
*/

void() item_shells =
{
	self.touch = ammo_touch;

	if (self.spawnflags & AMMO_BIG)
	{
		precache_model ("progs/b_shell1.bsp");
		setmodel (self, "progs/b_shell1.bsp");
		self.aflag = 40;
		self.netname = "big box of shells";
	}
	else
	{
		precache_model ("progs/b_shell0.bsp");
		setmodel (self, "progs/b_shell0.bsp");
		self.aflag = 20;
		self.netname = "shells";
	}
	self.weapon = 1;
//	setsize (self, '0 0 0', '32 32 56');

	self.effects = self.effects | EF_DYNAMICMODELLIGHT;

	setsize (self, '-16 -16 0', '16 16 56');
	self.origin_x += 16;
	self.origin_y += 16;	

	StartItem ();
};

/*QUAKED item_spikes (0 .5 .8) (0 0 0) (32 32 32) big
*/

void() item_spikes =
{
	self.touch = ammo_touch;

	if (self.spawnflags & AMMO_BIG)
	{
		precache_model ("progs/b_nail1.bsp");
		setmodel (self, "progs/b_nail1.bsp");
		self.aflag = 50;
		self.netname = "big box of nails";
	}
	else
	{
		precache_model ("progs/b_nail0.bsp");
		setmodel (self, "progs/b_nail0.bsp");
		self.aflag = 25;
		self.netname = "nails";
	}

//	self.effects = self.effects | EF_DYNAMICMODELLIGHT;

	self.weapon = 2;

//	setsize (self, '0 0 0', '32 32 56');

	self.effects = self.effects | EF_DYNAMICMODELLIGHT;

	setsize (self, '-16 -16 0', '16 16 56');
	self.origin_x += 16;
	self.origin_y += 16;	

	StartItem ();
};

/*QUAKED item_rockets (0 .5 .8) (0 0 0) (32 32 32) big
*/

void() item_rockets =
{
	self.touch = ammo_touch;

	if (self.spawnflags & AMMO_BIG)
	{
		precache_model ("progs/b_rock1.bsp");
		setmodel (self, "progs/b_rock1.bsp");
		self.aflag = 10;
		self.netname = "big box of rockets";
	}
	else
	{
		precache_model ("progs/b_rock0.bsp");
		setmodel (self, "progs/b_rock0.bsp");
		self.aflag = 5;
		self.netname = "rockets";
	}
	self.weapon = 3;

//	setsize (self, '0 0 0', '32 32 56');

	self.effects = self.effects | EF_DYNAMICMODELLIGHT;

	setsize (self, '-16 -16 0', '16 16 56');
	self.origin_x += 16;
	self.origin_y += 16;	

	StartItem ();
};


/*QUAKED item_cells (0 .5 .8) (0 0 0) (32 32 32) big
*/

void() item_cells =
{
	self.touch = ammo_touch;

	if (self.spawnflags & AMMO_BIG)
	{
		precache_model ("progs/b_batt1.bsp");
		setmodel (self, "progs/b_batt1.bsp");
		self.aflag = 12;
		self.netname = "big cells";
	}
	else
	{
		precache_model ("progs/b_batt0.bsp");
		setmodel (self, "progs/b_batt0.bsp");
		self.aflag = 6;
		self.netname = "cells";
	}

	self.weapon = 4;

//	setsize (self, '0 0 0', '32 32 56');

	self.effects = self.effects | EF_DYNAMICMODELLIGHT;

	setsize (self, '-16 -16 0', '16 16 56');
	self.origin_x += 16;
	self.origin_y += 16;	

	StartItem ();
};


/*QUAKED item_weapon (0 .5 .8) (0 0 0) (32 32 32) shotgun rocket spikes big
DO NOT USE THIS!!!! IT WILL BE REMOVED!
*/

void() item_weapon =
{
	self.touch = ammo_touch;

	if (self.spawnflags & WEAPON_SHOTGUN)
	{
		if (self.spawnflags & WEAPON_BIG)
		{
			precache_model ("maps/b_shell1.bsp");
			setmodel (self, "maps/b_shell1.bsp");
			self.aflag = 40;
		}
		else
		{
			precache_model ("maps/b_shell0.bsp");
			setmodel (self, "maps/b_shell0.bsp");
			self.aflag = 20;
		}
		self.weapon = 1;
		self.netname = "shells";
	}

	if (self.spawnflags & WEAPON_SPIKES)
	{
		if (self.spawnflags & WEAPON_BIG)
		{
			precache_model ("maps/b_nail1.bsp");
			setmodel (self, "maps/b_nail1.bsp");
			self.aflag = 40;
		}
		else
		{
			precache_model ("maps/b_nail0.bsp");
			setmodel (self, "maps/b_nail0.bsp");
			self.aflag = 20;
		}
		self.weapon = 2;
		self.netname = "spikes";
	}

	if (self.spawnflags & WEAPON_ROCKET)
	{
		if (self.spawnflags & WEAPON_BIG)
		{
			precache_model ("maps/b_rock1.bsp");
			setmodel (self, "maps/b_rock1.bsp");
			self.aflag = 10;
		}
		else
		{
			precache_model ("maps/b_rock0.bsp");
			setmodel (self, "maps/b_rock0.bsp");
			self.aflag = 5;
		}
		self.weapon = 3;
		self.netname = "rockets";
	}
	
	setsize (self, '0 0 0', '32 32 56');
	StartItem ();
};

/*
===============================================================================

PLAYER BACKPACKS

===============================================================================
*/

float() W_BestWeapon;
void(entity ent, float new) Deathmatch_Weapon;
void() bound_other_ammo;

void() BackpackTouch =
{
	local	string	s;
	local	float	best, new;	//old, 
	local	entity	stemp;
	local	float	acount;
	
	if (other.classname != "player")
		return;
	if (other.health <= 0)
		return;

	
	acount = 0;
	sprint (other, "You get ");

	if (self.items)
//	if ((other.items & self.items) == 0)
	{
			acount = 1;
			sprint (other, "the ");
			sprint (other, self.netname);
//			sprint (other, "\n");
	}

// if the player was using his best weapon, change up to the new one if better		
	stemp = self;
	self = other;
	best = W_BestWeapon();
	self = stemp;

// change weapons
	other.ammo_shells  = other.ammo_shells  + self.ammo_shells;
	other.ammo_nails   = other.ammo_nails   + self.ammo_nails;
	other.ammo_rockets = other.ammo_rockets + self.ammo_rockets;
	other.ammo_cells   = other.ammo_cells   + self.ammo_cells;

	new = self.items;
	if (!new)
		new = other.weapon;
	//old = other.items;
// ...always if new one
	if ((!other.items) & new)
		Deathmatch_Weapon (other, new);
	other.items = other.items | new;
	
	bound_other_ammo ();

	if (self.ammo_shells)
	{
		if (acount)
			sprint(other, ", ");
		acount = 1;
		s = ftos(self.ammo_shells);
		sprint (other, s);
		sprint (other, " shells");
	}
	if (self.ammo_nails)
	{
		if (acount)
			sprint(other, ", ");
		acount = 1;
		s = ftos(self.ammo_nails);
		sprint (other, s);
		sprint (other, " nails");
	}
	if (self.ammo_rockets)
	{
		if (acount)
			sprint(other, ", ");
		acount = 1;
		s = ftos(self.ammo_rockets);
		sprint (other, s);
		sprint (other, " rockets");
	}
	if (self.ammo_cells)
	{
		if (acount)
			sprint(other, ", ");
		acount = 1;
		s = ftos(self.ammo_cells);
		sprint (other, s);
		sprint (other, " cells");
	}
	
	sprint (other, "\n");
// backpack touch sound
	sound (other, CHAN_ITEM, "weapons/lock4.wav", 1, ATTN_NORM);
	stuffcmd (other, "bf\n");

// remove the backpack, change self to the player
	remove(self);
	self = other;

// change to the weapon
/*	if (!deathmatch)
		self.weapon = new;
	else */
		//Deathmatch_Weapon (old, new);
	if ( other.weapon == best )
		self.weapon = W_BestWeapon();
	W_SetCurrentAmmo ();
};

/*
===============
DropBackpack
===============
*/
void() DropBackpack =
{
	local	entity	item;

//	// don't drop a backpack if in a NODROP zone (such as lava)
//	traceline(self.origin, self.origin, MOVE_NORMAL, self);
//	if (trace_dpstartcontents & DPCONTENTS_NODROP)
//		return;

	if (!(self.ammo_shells + self.ammo_nails + self.ammo_rockets + self.ammo_cells))
		return;	// nothing in it

	item = spawn();
	item.origin = self.origin - '0 0 24';
	
	item.items = self.weapon;
	if (item.items == IT_AXE)
		item.netname = "Axe";
	else if (item.items == IT_SHOTGUN)
		item.netname = "Shotgun";
	else if (item.items == IT_SUPER_SHOTGUN)
		item.netname = "Double-barrelled Shotgun";
	else if (item.items == IT_NAILGUN)
		item.netname = "Nailgun";
	else if (item.items == IT_SUPER_NAILGUN)
		item.netname = "Super Nailgun";
	else if (item.items == IT_GRENADE_LAUNCHER)
		item.netname = "Grenade Launcher";
	else if (item.items == IT_ROCKET_LAUNCHER)
		item.netname = "Rocket Launcher";
	else if (item.items == IT_LIGHTNING)
		item.netname = "Thunderbolt";
#ifdef HIPNOTIC
	else if (item.items == IT_LASER_CANNON)
		item.netname = "Laser Cannon";
	else if (item.items == IT_PROXIMITY_GUN)
		item.netname = "Proximity Gun";
	else if (item.items == IT_MJOLNIR)
		item.netname = "Mjolnir";
#endif
	else
		item.netname = "";

	item.ammo_shells = self.ammo_shells;
	item.ammo_nails = self.ammo_nails;
	item.ammo_rockets = self.ammo_rockets;
	item.ammo_cells = self.ammo_cells;

	item.velocity_z = 300;
	item.velocity_x = -100 + (random() * 200);
	item.velocity_y = -100 + (random() * 200);
	
	item.flags = FL_ITEM;
	item.solid = SOLID_TRIGGER;
	item.movetype = MOVETYPE_TOSS;
	setmodel (item, "progs/backpack.mdl");
	setsize (item, '-16 -16 0', '16 16 56');
	item.touch = BackpackTouch;
	
	if (qonquer)
		item.nextthink = time + 20 + 20*(3 - skill);
	else
		item.nextthink = time + 120;	// remove after 2 minutes

	item.think = SUB_Remove;
};
