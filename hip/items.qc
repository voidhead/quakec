/* Items QuickC program
   By Jim Dose'  9/13/96
   Copyright (c)1996 Hipnotic Interactive, Inc.
   All rights reserved.
   Do not distribute.
*/

/*
===============================================================================

HIPNOTIC ITEMS

===============================================================================
*/
//
// hip_powerup_touch function
//
void() hip_powerup_touch =
{
//	local	entity	stemp;
//	local	float	best;
	local	float 	taken;

	if (other.classname != "player")
		return;
	if (other.health <= 0)
		return;

// do the apropriate action
	if ( self.classname == "item_artifact_wetsuit" )
	{
		other.wetsuit_time = 1;
		other.wetsuit_finished = time + 30;
		taken = TRUE;

	}
	if ( self.classname == "item_artifact_empathy_shields" )
	{
		other.empathy_time = 1;
		other.empathy_finished = time + 30;
		taken = TRUE;
	}

	if (taken)
	{
		sprint (other, "You got the ");
		sprint (other, self.netname);
		sprint (other,"\n");

		sound (other, CHAN_VOICE, self.noise, 1, ATTN_NORM);
		stuffcmd (other, "bf\n");

		self.solid = SOLID_NOT;
		other.items2 = other.items2 | self.items2;
		self.model = "";
	
		if (deathmatch)
		{
			self.mdl = self.model;
			self.nextthink = time + 60;
			self.think = SUB_Regen;
		}	
	}

	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
};


/*QUAKED item_artifact_wetsuit (0 .5 .8) (-16 -16 -24) (16 16 32)
Player takes no damage from electrical attacks and swims faster for 30 seconds
*/
void() item_artifact_wetsuit =
{
	self.touch = hip_powerup_touch;

	precache_model ("progs/wetsuit.mdl");
	precache_sound ("misc/wetsuit.wav");
	precache_sound ("misc/weton.wav");
	precache_sound ("items/suit2.wav");

	self.noise = "misc/weton.wav";
	self.netname = "Wetsuit";
	self.items2 = HIP_IT_WETSUIT;

	setmodel (self, "progs/wetsuit.mdl");
	setsize (self, '-16 -16 -24', '16 16 32');

	StartItem ();
};

/*
===============================================================================
//
// Horn of Conjuring
//
===============================================================================
*/
void() horn_touch =
{
//	local	float	amount;
//	local	float	value;

	if (other.classname != "player")
		return;
	if (other.health <= 0)
		return;

	if (deathmatch)
	{
		self.mdl = self.model;
		self.nextthink = time + 60;
		self.think = SUB_Regen;
	}

	self.solid = SOLID_NOT;
	self.model = "";

	sprint (other, "You got the Horn of Conjuring\n");
	sound (other, CHAN_VOICE, self.noise, 1, ATTN_NONE);
	stuffcmd (other, "bf\n");

	activator = other;
	horn_active = TRUE;
	horn_charmer = other;
	SUB_UseTargets();				// fire all targets / killtargets
	horn_active = FALSE;
};

/*QUAKED item_hornofconjuring (0 .5 .8) (-16 -16 0) (16 16 32)
Horn of Conjuring.
You must make func_spawn entities connected to this entity
to spawn the charmed creature.
*/
void() item_hornofconjuring =
{
	self.touch = horn_touch;

	precache_model("progs/horn.mdl");
	precache_sound("hipitems/horn.wav");

	self.noise = "hipitems/horn.wav";

	setmodel(self, "progs/horn.mdl");
	setsize (self, '-16 -16 0', '16 16 32');
	StartItem ();
};

/*QUAKED item_artifact_empathy_shields (0 .5 .8) (-16 -16 0) (16 16 32)
Empathy Shield.
*/
void() item_artifact_empathy_shields =
{
	self.touch = hip_powerup_touch;
	
	precache_model("progs/empathy.mdl");
	precache_sound("hipitems/empathy.wav");
	precache_sound("hipitems/empathy2.wav");
	precache_sound ("items/suit2.wav");

	self.noise = "hipitems/empathy.wav";
	self.netname = "Empathy Shields";
	self.items2 = HIP_IT_EMPATHY_SHIELDS;

	setmodel(self, "progs/empathy.mdl");
	setsize (self, '-16 -16 0', '16 16 32');
	StartItem ();
};
/*
===============================================================================

HIPNOTIC WEAPONS

===============================================================================
*/

/*QUAKED weapon_mjolnir (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() weapon_mjolnir =
{
	precache_model ("progs/g_hammer.mdl");

	self.weapon = 3;
	self.netname = "Mjolnir";
	self.items = IT_MJOLNIR;
	self.touch = weapon_touch;

	setmodel (self, "progs/g_hammer.mdl");
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};

/*QUAKED weapon_laser_gun (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() weapon_laser_gun =
{
	precache_model ("progs/g_laserg.mdl");

	self.weapon = 3;
	self.netname = "Laser Cannon";
	self.items = IT_LASER_CANNON;
	self.touch = weapon_touch;

	setmodel (self, "progs/g_laserg.mdl");
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};

/*QUAKED weapon_proximity_gun (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() weapon_proximity_gun =
{
	precache_model ("progs/g_prox.mdl");

	self.weapon = 3;
	self.netname = "Proximity Gun";
	self.items = IT_PROXIMITY_GUN;
	self.touch = weapon_touch;

	setmodel (self, "progs/g_prox.mdl");
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};