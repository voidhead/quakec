/*
=========================================================================

HEALTH BOX

=========================================================================
*/

float (entity e, float healamount, float ignore) T_Heal;

/*QUAKED item_health (.3 .3 1) (0 0 0) (32 32 32) rotten megahealth
Health box. Normally gives 25 points.
Rotten box heals 5-10 points,
megahealth will add 100 health, then 
rot you down to your maximum health limit, 
one point per second.
*/

void() health_touch;
void() item_megahealth_rot;

void() item_health =
{
	local string mdlname, sndname;

	self.touch = health_touch;

	if (self.spawnflags & HEALTH_ROTTEN)
	{
//		precache_model("progs/b_bh10.bsp");
//		precache_sound("items/r_item1.wav");
//		setmodel(self, "progs/b_bh10.bsp");
//		self.noise = "items/r_item1.wav";

//		if (world.worldtype == WORLDTYPE_MEDIEVAL)
//			mdlname = "progs/w_bh10.bsp";
//		else
			mdlname = "progs/b_bh10.bsp";
		
		sndname = "items/r_item1.wav";

		self.healamount = 15;
		self.healtype = 0;
	}
	else if (self.spawnflags & HEALTH_MEGA)
	{
//		precache_model("progs/b_bh100.bsp");
//		precache_sound("items/r_item2.wav");
//		setmodel(self, "progs/b_bh100.bsp");
//		self.noise = "items/r_item2.wav";

//		if (world.worldtype == WORLDTYPE_MEDIEVAL)
//			mdlname = "progs/w_bh100.bsp";
//		else
			mdlname = "progs/b_bh100.bsp";
		
		sndname = "items/r_item2.wav";

		self.healamount = 100;
		self.healtype = 2;
	}
	else
	{
//		precache_model("progs/b_bh25.bsp");
//		precache_sound("items/health1.wav");
//		setmodel(self, "progs/b_bh25.bsp");
//		self.noise = "items/health1.wav";

//		if (world.worldtype == WORLDTYPE_MEDIEVAL)
//			mdlname = "progs/w_bh25.bsp";
//		else
			mdlname = "progs/b_bh25.bsp";
		
		sndname = "items/health1.wav";

		self.healamount = 25;
		self.healtype = 1;
	}

//	setsize (self, '0 0 0', '32 32 56');

	precache_model(mdlname);
	precache_sound(sndname);

	setmodel(self, mdlname);
	self.noise = sndname;


//	if (world.worldtype == WORLDTYPE_MEDIEVAL)
//	{
//		self.effects = self.effects | EF_FULLBRIGHT;
//		self.pflags = self.pflags | PFLAGS_FULLDYNAMIC;
//		self.style = 4;
//		self.glowmod = '0.2 0.2 0.2';
//		lightstyle(self.style, "=0.5");
//		setsize (self, '0 0 0', '32 32 56');
//	}
//	else
//	{
		self.effects = self.effects | EF_DYNAMICMODELLIGHT;

//		self.colormod = '0.2 0.2 0.2';
//		self.glowmod = '1 1 1';
//		self.colormod = '2 2 2';
//		self.glowmod = '0.2 0.2 0.2';

		setsize (self, '-16 -16 0', '16 16 56');
		self.origin_x += 16;
		self.origin_y += 16;	
//	}

	StartItem ();
};

void(entity rotowner) MakeHealthRot =
{
	local entity rot;
	rot = spawn ();
	rot.classname = "health_rot";
	rot.nextthink = time + 5;
	rot.think = item_megahealth_rot;
	rot.owner = rotowner;
};

void() health_touch =
{
//	local	float amount;
	local	string	s;
	local	float	taken;
	
	if (other.classname != "player")
		return;
	
	taken = TRUE;

	if (self.healtype == 2) // Megahealth?  Ignore max_health...
	{
		if (other.health >= MAX_PL_HEALTH_MEGA)
			taken = FALSE;
		if (!T_Heal(other, self.healamount, 1))
			taken = FALSE;
	}
	else
	{
		if (!T_Heal(other, self.healamount, 0))
			taken = FALSE;
	}
	
	if (taken)
	{
		sprint(other, "You receive ");
		s = ftos(self.healamount);
		sprint(other, s);
		sprint(other, " health\n");
// health touch sound
		sound(other, CHAN_ITEM, self.noise, 1, ATTN_NORM);
		stuffcmd (other, "bf\n");
		
		self.model = "";
		self.solid = SOLID_NOT;
	
// Megahealth = rot down the player's super health
		if (self.healtype == 2)
		{
			local	entity	stemp;
	
		// search player's health rot entity
			stemp = find (world, classname, "health_rot");
			while (stemp != world && stemp.owner != other)
			{
				stemp = find(stemp, classname,"health_rot");
			}
	
			if (stemp)
			{
		// delay health rotting again
				stemp.nextthink = time + 5;
				stemp.think = item_megahealth_rot;
			}
			else
				MakeHealthRot(other);	// create rot entity
#ifdef ID1
			other.items = other.items | IT_SUPERHEALTH;	
#endif	
		}
		else
		{
			if (deathmatch != 2)		// deathmatch 2 is the silly old rules
			{
				if (deathmatch || qonquer)
					self.nextthink = time + 20;
	
				self.think = SUB_Regen;
			}			
		}
	}
	
	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
};	

void() item_megahealth_rot =
{
	other = self.owner;
	
	if (other.health > other.max_health)
	{
		other.health = other.health - 1;
		self.nextthink = time + 1;
		return;
	}

#ifdef ID1
	// it is possible for a player to die and respawn between rots, so don't
	// just blindly subtract the flag off
	other.items = other.items - (other.items & IT_SUPERHEALTH);
#endif
	
	if (deathmatch == 1 || qonquer)	// deathmatch 2 is silly old rules
	{
		self.nextthink = time + 20;
		self.think = SUB_Regen;
	}
};
