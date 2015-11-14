/* ALL MONSTERS SHOULD BE 1 0 0 IN COLOR */

// name =[framenum,	nexttime, nextthink] {code}
// expands to:
// name ()
// {
//		self.frame=framenum;
//		self.nextthink = time + nexttime;
//		self.think = nextthink
//		<code>
// };

/*
================
monster_use

Using a monster makes it angry at the current activator
================
*/
void() monster_use =
{
	if (self.enemy)
		return;
	if (self.health < 1)
		return;
	if (activator.items & IT_INVISIBILITY)
		return;
	if (activator.flags & FL_NOTARGET)
		return;
	if (activator.classname != "player")
		return;
	
// delay reaction so if the monster is teleported, its sound is still heard
	self.nextthink = time + 0.1;
	self.enemy = activator;
	self.think = FoundTarget;
};

/*
================
monster_death_use

When a monster dies, it fires all of its targets with the current
enemy as activator.
================
*/
void() monster_death_use =
{
// fall to ground
	if (self.flags & FL_FLY)
		self.flags = self.flags - FL_FLY;
	if (self.flags & FL_SWIM)
		self.flags = self.flags - FL_SWIM;

	if (!self.target)
		return;

	activator = self.enemy;
	SUB_UseTargets ();
};

//============================================================================

void() walkmonster_start_go =
{
	self.flags = self.flags | FL_MONSTER;
	self.ideal_yaw = self.angles*'0 1 0';
	self.takedamage = DAMAGE_AIM;
	self.use = monster_use;

	self.origin_z = self.origin_z + 1;	// raise off floor a bit
	droptofloor(0,0);
	
	if (!walkmove(0,0))
	{
		dprint ("walkmonster ");
		dprint(self.classname);
		dprint(" in wall at: ");
		dprint (vtos(self.origin));
		dprint ("\n");
	}

	self.air_finished = time + 12;
	self.dmg = 2;   		// initial water damage

	if (self.health < 1)
		self.health = self.max_health;

	if (!self.yaw_speed)
		self.yaw_speed = 20;

	if (!self.pitch_speed)
		self.pitch_speed = 20;

	if (self.view_ofs == VEC_0)
		self.view_ofs = '0 0 25';
	
	if (self.target)
	{
		self.goalentity = self.movetarget = find(world, targetname, self.target);
		self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);

		if (!self.movetarget)
		{
			dprint ("Monster can't find target at ");
			dprint (vtos(self.origin));
			dprint ("\n");
		}
// this used to be an objerror
		if (self.movetarget.classname == "path_corner")
			self.th_walk ();
		else
		{
			self.pausetime = EXTRA_HIGH;
			self.th_stand ();
		}
	}
	else
	{
		self.pausetime = EXTRA_HIGH;
		self.th_stand ();
	}

// spread think times so they don't all happen at same time
	self.nextthink = time + 0.01 + random()*0.2;	//time + 0.1 + random()*0.1;

	force_retouch = 2; // mainly to detect teleports
};


void() walkmonster_start =
{
// delay drop to floor to make sure all doors have been spawned
// spread think times so they don't all happen at same time
	self.nextthink = time + 0.1 + random()*0.5;
	self.think = walkmonster_start_go;
//	total_monsters = total_monsters + 1;
};



void() flymonster_start_go =
{
	self.flags = self.flags | FL_MONSTER | FL_FLY;
	self.ideal_yaw = self.angles*'0 1 0';
	self.takedamage = DAMAGE_AIM;
	self.use = monster_use;

	if (!walkmove(0,0))
	{
		dprint ("flymonster ");
		dprint(self.classname);
		dprint(" in wall at: ");
		dprint (vtos(self.origin));
		dprint ("\n");
	}

	self.air_finished = time + 12;
	self.dmg = 2;   		// initial water damage

	if (self.health < 1)
		self.health = self.max_health;

	if (!self.yaw_speed)
		self.yaw_speed = 10;

	if (!self.pitch_speed)
		self.pitch_speed = 10;

	if (self.view_ofs == VEC_0)
		self.view_ofs = '0 0 25';

	if (self.target)
	{
		self.goalentity = self.movetarget = find(world, targetname, self.target);
		if (!self.movetarget)
		{
			dprint ("Monster can't find target at ");
			dprint (vtos(self.origin));
			dprint ("\n");
		}
// this used to be an objerror
		if (self.movetarget.classname == "path_corner")
			self.th_walk ();
		else
		{
			self.pausetime = EXTRA_HIGH;
			self.th_stand ();
		}
	}
	else
	{
		self.pausetime = EXTRA_HIGH;
		self.th_stand ();
	}

// spread think times so they don't all happen at same time
	self.nextthink = time + 0.01 + random()*0.2;

	force_retouch = 2; // mainly to detect teleports
};

void() flymonster_start =
{
// spread think times so they don't all happen at same time
	self.nextthink = time + 0.1 + random()*0.5;
	self.think = flymonster_start_go;
//	total_monsters = total_monsters + 1;
};


void() swimmonster_start_go =
{
	self.flags = self.flags | FL_MONSTER | FL_SWIM | FL_NOBREATH;
	self.ideal_yaw = self.angles*'0 1 0';
	self.takedamage = DAMAGE_AIM;
	self.use = monster_use;

	if (self.health < 1)
		self.health = self.max_health;

	if (!self.yaw_speed)
		self.yaw_speed = 10;

	if (!self.pitch_speed)
		self.pitch_speed = 10;

	if (self.view_ofs == VEC_0)
		self.view_ofs = '0 0 10';

	if (self.target)
	{
		self.goalentity = self.movetarget = find(world, targetname, self.target);
		if (!self.movetarget)
		{
			dprint ("Monster can't find target at ");
			dprint (vtos(self.origin));
			dprint ("\n");
		}
// this used to be an objerror
		self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
		self.th_walk ();
	}
	else
	{
		self.pausetime = EXTRA_HIGH;
		self.th_stand ();
	}

// spread think times so they don't all happen at same time
	self.nextthink = time + 0.01 + random()*0.2;

	force_retouch = 2; // mainly to detect teleports
};

void() swimmonster_start =
{
// spread think times so they don't all happen at same time
	self.nextthink = time + 0.1 + random()*0.5;
	self.think = swimmonster_start_go;
//	total_monsters = total_monsters + 1;
};

/*
void() SightSound =
{
	if (self.classname == "monster_vomit")
		sound (self, CHAN_VOICE, "vomitus/v_sight1.wav", 1, ATTN_NORM);
};
*/

/*
================
by: Philip Martin aka: Kryten
When on top of monsters or players you slide. This is a QuakeC problem.
The function below fixes that problem.
based on code given to Kryten by: Michael Turitzin (MaNiAc)
================
*//*
void() monster_touch =
{
	//can cause problems for monsters on top of a player,  so only players
	if (other.classname != "player")
		return;
	if (other.health <= 0)
		return;

	if ((!other.flags & FL_ONGROUND) && (other.absmin_z >= self.absmax_z - 2))
		other.flags = other.flags + FL_ONGROUND;

	//you can add other stuff like pushable players/monsters here
};*/
