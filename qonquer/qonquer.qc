void(vector org) spawn_tfog;
void(vector org, entity death_owner) spawn_tdeath;
void() monster_use;
void() weapon_touch;
void() StartItem;

void() qonquer_think;
void() qonquer_pause;

void(string s, ...) qonquer_bprint = #23;
void(entity client, string s, ...) qonquer_sprint = #24;
void(entity client, string s, ...) qonquer_centerprint = #73;

void() monster_spawnwanderpath;

void() qonquer_set_default_waves =
{
	if (self.spawnwavestart == 0)
		self.spawnwavestart = 1;
	if (self.spawnwaveend == 0)
		self.spawnwaveend = MAX_WAVE;
	if (self.spawnwaveend < self.spawnwavestart)
		self.spawnwaveend = self.spawnwavestart;
};

float(entity ent) qonquer_checkvalidminionfactory =
{
	if (ent.classname == "monster_minion")
	if (ent.arenaname == qonquer.arenaname)
	if (self.currentwave >= ent.spawnwavestart)
	if (self.currentwave <= ent.spawnwaveend)
		return TRUE;

	return FALSE;
};

// Spawns a minion for the player
void() qonquer_spawnminion =
{
	local entity ent, newmonster, oldself, head, player;
	local float num_factories, factoryid, clear, extent, minion_count;
	local vector org;

	// If the player already has a minion, they can't have another one
	head = nextent (world);
	minion_count = 0;
	
	while (head)
	{
		if (head.minion)
			minion_count = minion_count + 1;
		
		head = nextent (head);
	}
	
	if (minion_count >= self.num_minions_allowed_alive)
	{
		self.think = qonquer_think;
		self.nextthink = time + 0.1;
		return;
	}
	
	player = find (world, classname, "player");
	
	// Count up the minion factories that are valid for this arena
	ent = nextent (world);
	num_factories = 0;

	while (ent != world)
	{
		if (qonquer_checkvalidminionfactory(ent))
		{
			ent.available = TRUE;
			num_factories = num_factories + 1;
		}
		
		ent = nextent(ent);
	}
	
	// Loop until we find a factory that isn't encroached
	while (num_factories > 0)
	{
		// Pick a random factory
		factoryid = ceil(num_factories*random());

		// Find that factory now by looping through the list again
		ent = nextent (world);

		while (ent != world && factoryid >= 0)
		{
			if (ent.available == TRUE)
			if (qonquer_checkvalidminionfactory(ent))
			{
				factoryid = factoryid - 1;
				if (factoryid == 0)
					break;
			}
	
			ent = nextent (ent);
		}
	
		// Use the largest dimension of this monster factory to check the radius around it.
		extent = ent.size_x;
		if (ent.size_y > extent)
			extent = ent.size_y;
		if (ent.size_z > extent)
			extent = ent.size_z;
		
		// Make sure that there isn't anything in the way of a minion spawning here
		clear = TRUE;
		head = findradius (ent.origin, extent);

		while (head)
		{
			// If anything living is in the way of this minion factory, we can't use it
			if (head.health > 0)
			{
				clear = FALSE;
				break;
			}
			
			head = head.chain;
		}
	
		if (clear == TRUE)
		{
			// Spawn a minion
			newmonster = spawn();

			oldself = self;
			self = newmonster;

			self.spawnflags = ent.spawnflags;

			// Do monster specific spawn work
			ent.spawnfactory();
			self.nextthink = time + 0.01 + 0.08*random();	//1;

			monster_minion_setclassname(ent);
			self.minion = TRUE;
			self.effects = self.effects | EF_DIMLIGHT;

			// Set origin/angles
			org = ent.origin;
			org_z = ent.origin_z - self.mins_z;
			org_z = org_z + 0.5*(self.mins_z + self.maxs_z) + 1;
			setorigin (self, org);

			setsize (self, self.mins*MINION_SCALE, self.maxs*MINION_SCALE);
			self.scale = MINION_SCALE;

			self.angles = ent.angles;
			self.angles_y = vectoyaw(player.origin - self.origin);
			self.fixangle = TRUE;

			// Beef up the minion's health
			self.health = self.max_health*(3 - 0.5*skill);
			
			// Activate the minion so it starts seeking out the player immediately
			self.goalentity = player;
			movetogoal(vlen(player.origin - self.origin));

			qonquer_centerprint (player, "New minion has spawned!");	//activator

			self = oldself;

			// This will force the loop to exit.
			num_factories = 0;
		}
		else
		{
			// Mark this factory as having been tried
			ent.available = FALSE;
			num_factories = num_factories - 1;
		}
	}
	
	self.think = qonquer_think;
	self.nextthink = time + 0.1;
};

// Generates a spawn effect for a monster spawning into a qonquer match
void() qonquer_monsterspawneffect =
{
	spawn_tfog (self.origin);
	spawn_tdeath (self.origin, self);
};

void() qonquer_triggereventstart =
{
	local entity head, ent, oldself;	//, player;

//	other = find (world, classname, "player");
	
	head = nextent (world);
	
	while (head != world)
	{
		if (head.classname == "info_qonquer_wave")
		if (head.arenaname == self.arenaname)
		if (head.wave == self.currentwave)
		if (head.targetstart)
		{
			ent = world;

			do
			{
				ent = find (ent, targetname, head.targetstart);

				if (!ent)
					break;
			
				oldself = self;
				self = ent;

				if (self.use)
				if (self.use != SUB_Null)
					self.use();

				self = oldself;

			} while (TRUE);
		}

		head = nextent (head);
	}
};

void() qonquer_triggereventend =
{
	local entity head, ent, oldself;

//	other = find (world, classname, "player");
	
	head = nextent (world);
	
	while (head != world)
	{
		if (head.classname == "info_qonquer_wave")
		if (head.arenaname == self.arenaname)
		if (head.wave == self.currentwave)
		if (head.targetend)
		{
			ent = world;

			do
			{
				ent = find (ent, targetname, head.targetend);

				if (!ent)
					break;
			
				oldself = self;
				self = ent;

				if (self.use)
				if (self.use != SUB_Null)
						self.use();

				self = oldself;

			} while (TRUE);
		}
		
		head = nextent (head);
	}
};

// 10 bonus health points for gibbing a monster.
void(entity ent) qonquer_monster_gibbed =
{
	if (ent.flags & FL_CLIENT)
	if (ent.health > 0)
		T_Heal(ent, 15 - 2.5*skill, FALSE);
};

void(entity ent) qonquer_corpse_gibbed =
{
	if (ent.flags & FL_CLIENT)
	if (ent.health > 0)
		T_Heal(ent, 2 + fabs(random()), FALSE);
};

// Called whenever a monster dies
void() qonquer_monster_died =
{
	local entity player;
	float left;
	
	if (intermission_running)
		return;

	player = find(world, classname, "player");
	
	if (self.minion)
	{
		qonquer_centerprint (player, "Minion was killed!");
		qonquer.stat_minionskilled = qonquer.stat_minionskilled + 1;
	}
	else
	{
		qonquer.num_monsters_killed = qonquer.num_monsters_killed + 1;		
		qonquer.num_monsters_alive = qonquer.num_monsters_alive - 1;

		left = qonquer.num_monsters_in_wave - qonquer.num_monsters_killed;
		
		if (left > 1 && left < 6)
			qonquer_sprint (player, ftos(left), " monsters left\n");
		else if (left == 1)
			qonquer_sprint (player, ftos(left), " monster left\n");
		else if (left == 0)
//			qonquer_centerprint ("QONQUERED!\n");
			qonquer_sprint (player, chr2str(0xd1,0xcf,0xce,0xd1,0xd5,0xc5,0xd2,0xc5), chr2str(0xc4,0xa1));

		WriteByte (MSG_BROADCAST, SVC_UPDATESTAT);
		WriteByte (MSG_BROADCAST, STAT_TOTALMONSTERS);
		WriteLong (MSG_BROADCAST, left);
	}
};

void() qonquer_resetitems =
{
	local entity item;

	item = nextent(world);
	while (item != world)
	{
		if (item.arenaname == qonquer.arenaname)
		if (item.flags & FL_ITEM)
		if (!(item.spawnflags & SPAWNFLAG_ITEM_TARGETED))
		if (item.model != item.mdl)
		{
			item.nextthink = time + 30;
			item.think = SUB_Regen;
		}
		item = nextent(item);
	}
	
};

// Initializes the internals for the current wave
void() qonquer_initwave =
{
	qonquer.num_monsters_killed = 0;
	self.num_monsters_alive = 0;
	self.num_monsters_allowed_alive = floor (1.0 + self.currentwave*0.375 + skill*1.5);
	self.num_monsters_in_wave = floor (2.0 + self.currentwave*1.375 + skill);
	self.spawn_delay = 2.75 - (self.currentwave*0.125 + skill*0.25);
	self.num_minions_allowed_alive = floor (1.0 + self.currentwave*0.1);
	
	// Apply limits
	if (self.num_minions_allowed_alive > 3)
		self.num_minions_allowed_alive = 3;
	
	if (self.num_monsters_allowed_alive > 40)	//35
		self.num_monsters_allowed_alive = 40;
	
	if (self.spawn_delay < 0.25)
		self.spawn_delay = 0.25;
	
//	killed_monsters = 0;
//	WriteByte (MSG_BROADCAST, SVC_UPDATESTAT);
//	WriteByte (MSG_BROADCAST, STAT_MONSTERS);
//	WriteLong (MSG_BROADCAST, killed_monsters);

//	total_monsters = self.num_monsters_in_wave;
	WriteByte (MSG_BROADCAST, SVC_UPDATESTAT);
	WriteByte (MSG_BROADCAST, STAT_TOTALMONSTERS);
	WriteLong (MSG_BROADCAST, self.num_monsters_in_wave);
};

float(entity ent) qonquer_checkvalidfactory =
{
	if (ent.flags & FL_MONSTERFACTORY)
	if (ent.spawnflags & SPAWNFLAG_MONSTERFACTORY)
	if (ent.arenaname == qonquer.arenaname)
	if (self.currentwave >= ent.spawnwavestart)
	if (self.currentwave <= ent.spawnwaveend)
		return TRUE;
	
	return FALSE;
};

void() qonquer_spawnmonster =
{
	local entity ent, newmonster, oldself, head;
	local float num_factories, factoryid, clear, extent;
	
	// Count up the actor factories that are valid for the current wave number
	ent = nextent (world);
	
	num_factories = 0;

	while (ent != world)
	{
		if (qonquer_checkvalidfactory(ent))
		{
			ent.available = TRUE;
			num_factories = num_factories + 1;
		}
		
		ent = nextent (ent);
	}
	
	// Loop until we find a factory that isn't encroached
	while (num_factories > 0)
	{
		// Pick a random factory
		factoryid = ceil(num_factories*random());

		// Find that factory now by looping through the list again
		ent = nextent(world);

		while (ent != world && factoryid >= 0)
		{
			if (ent.available == TRUE)
			if (qonquer_checkvalidfactory(ent))
			{
				factoryid = factoryid - 1;

				if (factoryid == 0)
					break;
			}
	
			ent = nextent (ent);
		}
	
		// Use the largest dimension of this monster factory to check the radius around it.
		extent = ent.size_x;

		if (ent.size_y > extent)
			extent = ent.size_y;
		if (ent.size_z > extent)
			extent = ent.size_z;
		
		// Make sure that there isn't anything in the way of a monster spawning here
		head = findradius (ent.origin, extent);
		clear = TRUE;
	
		while (head)
		{
			// If anything living is in the way of this spawn factory, we can't use it
			if (head.health > 0)
			{
				clear = FALSE;
				break;
			}
			
			head = head.chain;
		}
	
		if (clear == TRUE)
		{
			// Spawn a new entity
			newmonster = spawn();
	
			oldself = self;
			self = newmonster;

			self.classname = ent.classname;
			self.spawnflags = ent.spawnflags;
		
			// Do monster specific spawn work
			ent.spawnfactory();
			self.nextthink = time + 0.01 + 0.08*random();	//1;

			// Set origin/angles
			setorigin (self, ent.origin);
			self.angles_y = random()*360;
			self.fixangle = TRUE;

			qonquer_monsterspawneffect();
			self.minion = FALSE;

			// Anger the monster so it starts hunting the player immediately
			activator = find (world, classname, "player");

			if (!(activator.flags & FL_NOTARGET))
				monster_use();
			else
			{
				if (self.movetarget.classname != "monster_wanderpath")
				if (!(self.spawnflags & SPAWNFLAG_WANDER))
					monster_spawnwanderpath();

				self.movetarget.enemy = activator;
				self.goalentity = self.movetarget;
				self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
				self.enemy_found = FALSE;
				self.th_run();	
			}

			self = oldself;
			
			self.num_monsters_alive = self.num_monsters_alive + 1;
			
			// This will force the loop to exit.
			num_factories = 0;
		}
		else
		{
			// Mark this factory as having been tried
			ent.available = FALSE;
			num_factories = num_factories - 1;
		}
	}
};

void() qonquer_countdown;

void() qonquer_new_round =
{
	if (intermission_running)
	{
		self.think = qonquer_pause;
		return;
	}
	
	self.currentwave = self.currentwave + 1;
	self.countdown = 3;
	
	qonquer_triggereventstart();
	
	activator = find (world, classname, "player");

	qonquer_centerprint( activator, "WAVE: ", ftos(self.currentwave));
//	qonquer_centerprint (activator, chr2str(0x10), "Wave: ", ftos(self.currentwave), chr2str(0x11));
	sound (activator, CHAN_VOICE, "misc/talk.wav", 1, ATTN_NORM);
	
	self.think = qonquer_countdown;
	self.nextthink = time + 2;
};

void() qonquer_pause =
{
	self.nextthink = time - 1;
};

// The main think function.
void() qonquer_think =
{
	local entity head, player, oldself;
	
	if (intermission_running)
	{
		self.think = qonquer_pause;
		return;
	}
	
	player = find (world, classname, "player");
	
	if (time > self.minion_time)
	{
		self.think = qonquer_spawnminion;
		self.nextthink = time + 0.1;
		self.minion_time = time + 10 + 10*skill;
	}
	
	// Look for minions that are bored (no enemy) and start them walking back towards the player
	head = nextent (world);
	
	while (head)
	{
		if (head.minion)
		if (head.health > 0)
		if (!head.enemy)
		{
			oldself = self;
			self = head;
			
			self.goalentity = player;
			self.attack_state = AS_MINION;
			self.th_walk();
			
			self = oldself;
		}
		
		head = nextent (head);
	}

	// Game logic
	if (qonquer.num_monsters_killed >= self.num_monsters_in_wave)
	{
		qonquer_centerprint (activator, "Wave Completed!");
		sound (activator, CHAN_VOICE, "qonquer/wavecomplete.wav", 1, ATTN_NORM);
		
		qonquer_triggereventend();
		
		self.nextthink = time + (8.0 - skill);
		self.think = qonquer_new_round;
	}
	else
	{
		if (self.num_monsters_alive < self.num_monsters_allowed_alive)
		if (qonquer.num_monsters_killed + self.num_monsters_alive < self.num_monsters_in_wave)
			qonquer_spawnmonster();
		
		self.nextthink = time + self.spawn_delay;
	}
};

// Runs through the "3", "2", "1", "FIGHT!" sequence at the start of the game
void() qonquer_countdown =
{
	local float msg;
	
	if (intermission_running)
	{
		self.think = qonquer_pause;
		return;
	}
	
	if (self.countdown > 0)
	{
		qonquer_centerprint (activator, "Starting in: ", ftos(self.countdown));
		sound (activator, CHAN_VOICE, "qonquer/click.wav", 1, ATTN_NORM);
		
		self.nextthink = time + 1.0;
	}
	else if (self.countdown == 0)
	{
		qonquer_centerprint (activator, " ");
		self.nextthink = time + 0.25;
	}
	else
	{
		// Set up the wave
		qonquer_initwave();
		
		if (self.currentwave == 1)
		{
//			qonquer_centerprint (activator, "QONQUER!");
			qonquer_centerprint (activator, chr2str(0xd1,0xcf,0xce,0xd1,0xd5,0xc5,0xd2,0xa1));
			qonquer_resetitems();
		}
		else
		{
			msg = random();

			if (msg > 0.75)
				qonquer_centerprint (activator, "FIGHT!");
			else if (msg > 0.5)
				qonquer_centerprint (activator, "DESTROY!");
			else if (msg > 0.25)
				qonquer_centerprint (activator, "KILL!");
			else
				qonquer_centerprint (activator, "MAIM!");
		}
		
		sound (activator, CHAN_VOICE, "qonquer/fight.wav", 1, ATTN_NORM);
		
		self.think = qonquer_think;
		self.nextthink = time + 1.0;
	}

	self.countdown = self.countdown - 1;
};

void() qonquer_use =
{
//	local entity oldself;

	// Make this info_qonquer the one in use
	qonquer = self;
	
//	qonquer_centerprint (activator, "[Qonquer] - Get ready!");
	qonquer_centerprint (activator, chr2str(0x90), chr2str(0xd1,0xcf,0xce,0xd1,0xd5,0xc5,0xd2,0xa1), chr2str(0x91), " - Get ready!");
	
	qonquer.minion_time = time + 10 + (5 * skill);
	
	qonquer.currentwave = 1;
	
	qonquer.stat_soldierkills = 0;
	qonquer.stat_dogkills = 0;
	qonquer.stat_demonkills = 0;
	qonquer.stat_enforcerkills = 0;
	qonquer.stat_fishkills = 0;
	qonquer.stat_hellknightkills = 0;
	qonquer.stat_knightkills = 0;
	qonquer.stat_shalrathkills = 0;
	qonquer.stat_shamblerkills = 0;
	qonquer.stat_tarbabykills = 0;
	qonquer.stat_wizardkills = 0;
	qonquer.stat_zombiekills = 0;
	qonquer.stat_ogrekills = 0;
	qonquer.stat_minionskilled = 0;

	qonquer.ltime = time;	
	qonquer.countdown = 3;
	qonquer.nextthink = time + 2.0;
	qonquer.think = qonquer_countdown;
	qonquer_triggereventstart();
};

/*QUAKED info_qonquer (0.25 0.5 0.75) (-16 -16 -8) (16 16 8)
Controls the qonquer game.
*/
void() info_qonquer =
{
	if (deathmatch || cvar("nomonsters"))
	{
		remove(self);
		return;
	}

	precache_sound ("qonquer/click.wav");
	precache_sound ("qonquer/wavecomplete.wav");
	precache_sound ("qonquer/fight.wav");
	
	self.use = qonquer_use;
};
