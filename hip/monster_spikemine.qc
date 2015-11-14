/*
==============================================================================

spike mine

==============================================================================
*/
$modelname spikmine
$cd hipwork/models/spike
$origin 0 0 0
$base spikbase.asc
$skin spike
$frame spike1.asc spike2.asc spike3.asc spike4.asc spike5.asc spike6.asc
$frame spike7.asc spike8.asc spike9.asc

void() spikemine_home =
{
	local entity head;
	local entity selected;
	local float cur_dist;
	local float head_dist;
	local vector dir, vtemp;
	
//	print(ftos(self.health), "\n");

	self.frame = self.frame + 1;

	if (self.frame == 9)
		self.frame = 0;

	self.nextthink = time + 0.2;
	self.think = spikemine_home;
	
// look in our immediate vicinity
	if (self.search_time < time)
	{
		selected = world;
		cur_dist = 2000;
		head = findradius(self.origin, 2000);
		while(head)
		{
			if (!(head.flags & FL_NOTARGET))
			if (head.flags & FL_CLIENT)
			{
				if (visible(head))
				if (head.health > 0)
				{
					head_dist = vlen(head.origin - self.origin);
					if (head_dist < cur_dist)
					{
						selected = head;
						cur_dist = head_dist;
					}
				}
			}
			head = head.chain;
		}

//		if (selected != world && selected != self.enemy)
		if (selected != world)
			sound (self, CHAN_VOICE, "hipitems/spikmine.wav", 1, ATTN_NORM);

		self.enemy = selected;
		self.search_time = time + 1.3;
	}

	if (self.enemy == world || self.enemy.flags & FL_NOTARGET)
	{
		sound (self, CHAN_VOICE, "misc/null.wav", 1, ATTN_NORM);
		self.velocity = '0 0 0';
		return;
	}

	vtemp = self.enemy.origin + '0 0 10';
	dir = normalize(vtemp - self.origin);

	if (infront(self.enemy))
		self.velocity = dir*(skill*50 + 50);
	else
		self.velocity = dir*(skill*50 + 150);
};

/*
void() spikemine_trigger_touch =
{
	force_retouch = 3;

	if (other == self.aiment)
		return;

	if (!self.aiment.takedamage)
		return;

	print ("hit by ", other.classname, "\n");
	print (ftos(self.aiment.health), "\n");

	if (other.classname == self.aiment.classname)	// other spikemines
		return;
	if (other.solid <= SOLID_TRIGGER)	// non-solid objects	
		return;
	if (other.flags & FL_CORPSE)		// corpses
		return;
	if (other.classname == "gib")		// gibs
		return;
	if (other.classname == "wizspike")	// monster projectiles
		return;
	if (other.classname == "knightspike")
		return;
	if (other.classname == "laser")
		return;
	if (other.classname == "enfspike")
		return;
	if (other.classname == "vorespike")
		return;
	if (other.classname == "ogrenade")
		return;
	if (other.classname == "hiplaser")	// player projectiles
		return;
	if (other.classname == "missile")
		return;
	if (other.classname == "grenade")
		return;
	if (other.classname == "proximity_grenade")
		return;

//	self.aiment.lastv = other;
	T_Damage(self.aiment, self.aiment, self.aiment, self.aiment.health + 10, "");

	remove(self);
}

void() spikemine_spawntriggerfield =
{
	local entity trig;

	trig = spawn();
	trig.takedamage = DAMAGE_NO;
	trig.movetype = MOVETYPE_FOLLOW;
	trig.aiment = self;
	self.aiment = trig;

	trig.solid = SOLID_TRIGGER;
	setmodel (trig, "");
	setsize (trig, self.mins + '-4 -4 -4', self.maxs + '4 4 4');

	trig.touch = spikemine_trigger_touch;

//	trig.think = ScourgeTriggerThink;	
//	trig.nextthink = time + 0.5 + random();
//	self.lastvictim = trig;
//	trig.lastvictim = self;
};
*/

void(entity attacker, float damage) spikemine_pain =
{
//	print ("hit by ", attacker.classname, "\n");
//	print (self.deathtype, "\n");
//	print (ftos(self.health), "\n");

	if (self.deathtype == "nail" || self.deathtype == "supernail")
		T_Damage(self, self, self, self.health + 10, "");
};

void() spikemine_die =
{
	local float damg;
//	remove(self.aiment);

	sound (self, CHAN_VOICE, "misc/null.wav", 1, ATTN_NORM);
	
	damg = 110;

	if (self.lastvictim != world)
	if (self.lastvictim.takedamage)
	if (self.lastvictim.health > 0)
	{
		if (self.lastvictim.classname == "monster_shambler")
			damg = damg*0.5;	// mostly immune

		T_Damage (self.lastvictim, self, self, damg, "spikemine");

		SpawnBlood_Expl(self.lastvictim, self.velocity, damg);
	}

	T_RadiusDamage (self, self, 110, self.lastvictim, "spikemine");

	te_explosion(self.origin);		
/*
	sound (self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NORM);
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);
*/	
	self.velocity = '0 0 0';
	self.touch = SUB_Null;
	setmodel (self, "progs/s_explod.spr");
	self.solid = SOLID_NOT;
	s_explode1 ();
};

void() spikemine_sight =
{
	if (!(self.spawnflags & SPAWNFLAG_AMBUSH))
		sound (self, CHAN_VOICE, "hipitems/spikmine.wav", 1, ATTN_NORM);
};

void() spikemine_touch =
{
	if (!self.takedamage)
		return;

	if (other.classname == self.classname)	// other spikemines
		return;
	if (other.solid <= SOLID_TRIGGER)	// non-solid objects	
		return;
	if (other.flags & FL_CORPSE)		// corpses
		return;
	if (other.classname == "gib")		// gibs
		return;
	if (other.classname == "wizspike")	// monster projectiles
		return;
	if (other.classname == "knightspike")
		return;
	if (other.classname == "laser")
		return;
	if (other.classname == "enfspike")
		return;
	if (other.classname == "vorespike")
		return;
	if (other.classname == "ogrenade")
		return;
	if (other.classname == "hiplaser")	// player projectiles
		return;
	if (other.classname == "missile")
		return;
	if (other.classname == "grenade")
		return;
	if (other.classname == "proximity_grenade")
		return;

	self.lastvictim = other;
	T_Damage(self, self, self, self.health + 10, "");
};

void() spikemine_firstthink =
{
	self.think = spikemine_home;
	self.nextthink = time + 0.1;
	self.search_time = 0;
	self.takedamage = DAMAGE_AIM;
	self.use = monster_use;
};

void() precachemonster_spikemine =
{
	precache_model ("progs/spikmine.mdl");
	precache_sound ("weapons/r_exp3.wav");
	precache_sound ("hipitems/spikmine.wav");
	precache_sound ("misc/null.wav");
};

/*QUAKED trap_spike_mine (0 .5 .8) (-16 -16 0) (16 16 32)
*/
void() trap_spike_mine =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}

	precachemonster_spikemine();

	setmodel (self, "progs/spikmine.mdl");
//	setsize (self, self.mins, self.maxs);
//	setsize (self, '0 0 0', '0 0 0');
	setsize (self, '-20 -20 -20', '20 20 20');

	self.classname = "trap_spike_mine";
	self.solid = SOLID_BBOX;	//SOLID_TRIGGER;	//SOLID_BBOX;
	self.movetype = MOVETYPE_FLYMISSILE;

//	self.avelocity = '-100 100 -100';
	self.avelocity = '-50 100 150';

	if (cvar("skill") <= SKILL_NORMAL)
		self.max_health = 200;
	else
		self.max_health = 400;

	if (self.health <= 0)
		self.health = self.max_health;

	self.frame = 0;

	self.flags = self.flags | FL_MONSTER;

	self.touch = spikemine_touch;
	self.th_die = spikemine_die;		//spikemine_touch;
	self.th_pain = spikemine_pain;
	self.th_stand = spikemine_home;
	self.th_walk = spikemine_home;
	self.th_run = spikemine_home;
	self.th_melee = spikemine_home;
	self.th_missile = spikemine_home;
	self.th_gib = SUB_Null;
	self.th_sight = spikemine_sight;

	self.corpsehealth = EXTRA_HIGH;
	self.gib = GIB_NOGIB;
	self.headname = "";
	self.gibhealth = EXTRA_LOW;
	self.mass = 300;

	self.think = spikemine_firstthink;
	self.nextthink = time + 0.2;

	total_monsters = total_monsters + 1;
//	self.deathtype = "was blasted by a spike mine";

//	spikemine_spawntriggerfield();
};

void() monster_spikemine =
{
};