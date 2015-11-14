/*
===============================================================================

HIPNOTIC HAZARDS

===============================================================================
*/

void() SpawnLightningThink =
{
	if (time > self.delay)
	{
		remove(self);
		return;
	}

	self.think = SpawnLightningThink;

	if (checkclient())
	{
		te_lightning2(self, self.origin, self.oldorigin);
		trailparticles(self, particleeffectnum("TR_SPIKE"), self.origin, self.oldorigin);
		te_plasmaburn(self.origin);
/*
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_LIGHTNING2);
		WriteEntity (MSG_BROADCAST, self);
		WriteCoord (MSG_BROADCAST, self.origin_x);
		WriteCoord (MSG_BROADCAST, self.origin_y);
		WriteCoord (MSG_BROADCAST, self.origin_z);
		WriteCoord (MSG_BROADCAST, self.oldorigin_x);
		WriteCoord (MSG_BROADCAST, self.oldorigin_y);
		WriteCoord (MSG_BROADCAST, self.oldorigin_z);
*/
	}

	LightningDamage(self.origin, self.oldorigin, self.lastvictim, self.dmg);
	self.nextthink = time + 0.1;
};

void() trap_lightning_use =
{
	local vector p1, p2;
//	local vector dir;
//	local float dst;
//	local float remainder;
	
	if (time >= self.pausetime)
	{
		if (self.spawnflags & LIGHTNING_BOOM)
			sound (self, CHAN_AUTO, "weapons/lstart.wav", 1, ATTN_NORM);
		else
			sound (self, CHAN_AUTO, "weapons/lhit.wav", 1, ATTN_NORM);
		if (self.classname == "trap_lightning_triggered")
			self.pausetime = time + 0.1;
	}

	if (self.target)
	{
		p1 = self.origin;
		p2 = self.enemy.origin;
	}
	else
	{
		makevectors (self.angles);
		self.movedir = v_forward;
		weapontraceline (self.origin, self.origin + self.movedir*600, TRUE, self);
		p1 = self.origin;
		p2 = trace_endpos;
//		weapontraceline (p2, -600*self.movedir, TRUE, self);
//		p1 = trace_endpos;
	}
/*
// fix up both ends of the lightning
// lightning bolts are 30 units long each
	dir = normalize(p2 - p1);
	dst = vlen(p2 - p1);
	dst = dst/30.0;
	remainder = dst - floor(dst);

	if (remainder > 0)
	{
		remainder = remainder - 1;
	// split half the remainder with the front and back
		remainder = remainder*15;
		p1 = p1 + remainder*dir;
		p2 = p2 - remainder*dir;
	}
*/

	if (self.duration > 0.1)
	{
		local entity temp;
		
		temp = self;
		self = spawn();
		self.origin = p1;
		self.oldorigin = p2;
		self.lastvictim = temp;
		self.dmg = temp.dmg;
		self.delay = time + temp.duration;
		SpawnLightningThink();
		self = temp;
	}
	else if (checkclient())
	{
		te_lightning2(self, p1, p2);
		trailparticles(self, particleeffectnum("TR_SPIKE"), p1, p2);
//		te_blood(p1, VEC_0, 4);
		te_plasmaburn(p1);

/*		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_LIGHTNING2);
		WriteEntity (MSG_BROADCAST, self);
		WriteCoord (MSG_BROADCAST, p1_x);
		WriteCoord (MSG_BROADCAST, p1_y);
		WriteCoord (MSG_BROADCAST, p1_z);
		WriteCoord (MSG_BROADCAST, p2_x);
		WriteCoord (MSG_BROADCAST, p2_y);
		WriteCoord (MSG_BROADCAST, p2_z);
*/
		LightningDamage(p1, p2, self, self.dmg);
	}
	else
		LightningDamage(p1, p2, self, self.dmg);
};

void() lightning_think =
{
	local float timedelay;

	if (self.state)
		trap_lightning_use();

	if (self.cnt == 0)
	{
			if (self.spawnflags & LIGHTNING_RANDOM)
				timedelay = self.wait*random();
			else
				timedelay = self.wait;
			self.cnt = 1;
			self.t_length = time + self.duration - 0.1;
			self.pausetime = time + self.duration - 0.1;
			if (self.pausetime  < time + 0.3)
				self.pausetime = time + 0.3;
			if (timedelay < self.duration)
				timedelay = self.duration;
			self.t_width = time + timedelay;
	}

	if (time >= self.t_length)
	{
		self.cnt = 0;
		self.nextthink = self.t_width;
	}
	else
		self.nextthink = time + 0.2;
};

void() lightning_firstthink =
{
	local entity targ;

	if (self.target)
	{
		targ = find(world,targetname,self.target);
		self.dest = targ.origin;
		self.enemy = targ;
	}

	self.think = SUB_Null;
	self.nextthink = 0;

	if (self.classname != "trap_lightning_triggered")
	{
		self.nextthink = self.huntingcharmer + self.wait + self.ltime;
		self.think = lightning_think;
	}
};

/*QUAKED trap_lightning_triggered (0 .5 .8) (-8 -8 -8) (8 8 8) random boom
When triggered, fires lightning in the direction set in QuakeEd.
"wait" how long to wait between blasts (1.0 default)
       if in random mode wait is multiplied by random
"dmg" how much damage lightning should inflict (30 default)
"duration" how long each lightning attack should last (0.1 default)
*/
void() trap_lightning_triggered =
{
	precache_sound ("weapons/lhit.wav");
	precache_sound ("weapons/lstart.wav");

	if (self.wait == 0)
		self.wait = 1.0;
	if (self.dmg == 0)
		self.dmg = 30;
	if (self.duration == 0)
		self.duration = 0.1;

	self.cnt = 0;
	self.use = trap_lightning_use;
	self.huntingcharmer = self.nextthink;

	self.think = lightning_firstthink;
	self.nextthink = time + 0.25;
//	self.deathtype = "is electrocuted";
};


/*QUAKED trap_lightning (0 .5 .8) (-8 -8 -8) (8 8 8) random boom
Continuously fire lightning.
"wait" how long to wait between blasts (1.0 default)
       if in random mode wait is multiplied by random
"nextthink" delay before firing first lightning, so multiple traps can be stagered.
"dmg" how much damage lightning should inflict (30 default)
"duration" how long each lightning attack should last (0.1 default)
*/
void() trap_lightning =
{
	trap_lightning_triggered ();
	self.state = 1;
};

void() trap_lightning_switched_use =
{
	self.state = 1 - self.state;
	if (self.state == 1)
		self.nextthink = self.huntingcharmer;
};

/*QUAKED trap_lightning_switched (0 .5 .8) (-8 -8 -8) (8 8 8) random boom
Continuously fires lightning.
"wait" how long to wait between blasts (1.0 default)
       if in random mode wait is multiplied by random
"nextthink" delay before firing first lightning, so multiple traps can be stagered.
"dmg" how much damage lightning should inflict (30 default)
"duration" how long each lightning attack should last (0.1 default)
"state" 0 (default) initially off, 1 initially on.
*/
void() trap_lightning_switched =
{
	trap_lightning_triggered ();
	self.use = trap_lightning_switched_use;
};


void() trap_tesla_scan =
{
	local entity head;
	local entity prev;
	
// look in our immediate vicinity
	tesla_numtargets = 0;

	head = findradius(self.origin, self.distance);
	while(head)
	{
		if(!(head.flags & FL_NOTARGET) && (head.flags & self.cnt))
		{
			if (visible(head) && (head.health > 0) && (head.struck_by_mjolnir == FALSE))
			{
				if (tesla_numtargets == 0)
					tesla_target = head;
				else
					prev.next_ent = head;

				tesla_numtargets = tesla_numtargets + 1;
				prev = head;

				if (tesla_numtargets == self.count)
					return;
			}
		}
		head = head.chain;
	}
};

void() TeslaLightningThink =
{
	self.owner.attack_state = 2;

	if (time > self.delay)
	{
		self.enemy.struck_by_mjolnir = FALSE;
		remove(self);
		return;
	}

	weapontraceline (self.origin, self.enemy.origin, TRUE, self);
	
	if (trace_fraction != 1.0 || self.enemy.health <= 0 || vlen(self.origin - self.enemy.origin) > (self.distance + 10))
	{
		self.enemy.struck_by_mjolnir = FALSE;
		remove(self);
		return;
	}

	te_lightning2(self, self.origin, trace_endpos);
	trailparticles(self, particleeffectnum("TR_SPIKE"), self.origin, trace_endpos);
/*	
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_LIGHTNING2);
	WriteEntity (MSG_BROADCAST, self);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);
	WriteCoord (MSG_BROADCAST, trace_endpos_x);
	WriteCoord (MSG_BROADCAST, trace_endpos_y);
	WriteCoord (MSG_BROADCAST, trace_endpos_z);
*/
	LightningDamage(self.origin, trace_endpos, self.lastvictim, self.dmg);
	self.nextthink = time + 0.1;
};

void(entity targ) SpawnTeslaLightning =
{
	local entity lgt;

// spawn actual lightning
	lgt = spawn();

	if (self.duration > 0)
		lgt.delay = time + self.duration;
	else
		lgt.delay = time + 9999;

	lgt.enemy = targ;
	targ.struck_by_mjolnir = TRUE;
	lgt.distance = self.distance;
	lgt.owner = self;
	lgt.lastvictim = self.lastvictim;
	lgt.dmg = self.dmg;
	lgt.origin = self.origin;
	lgt.think = TeslaLightningThink;
	lgt.nextthink = time;
	lgt.deathtype = self.deathtype;
};
	
void() trap_tesla_think =
{
	if (self.state == 0)
	{
		self.nextthink = time + 0.25;
		return;
	}

	if (self.attack_state == 0)
	{
		self.think = trap_tesla_think;
		trap_tesla_scan();

		if (tesla_numtargets > 0)
		{
			if (self.wait > 0)
			sound (self, CHAN_AUTO, "misc/tesla.wav", 1, ATTN_NORM);
			self.attack_state = 1;
			self.nextthink = time + self.wait;
			return;
		}

		self.nextthink = time + 0.25;

		if (self.delay > 0)
		{
			if (time > self.search_time)
				self.attack_state = 3;
		}
	}
	else if (self.attack_state == 1)
	{
		trap_tesla_scan();
		while (tesla_numtargets > 0)
		{
			sound (self, CHAN_AUTO, "hipweap/mjolhit.wav", 1, ATTN_NORM);
			SpawnTeslaLightning (tesla_target);
			tesla_target = tesla_target.next_ent;
			tesla_numtargets = tesla_numtargets - 1;
		}
		self.attack_state = 2;
		self.nextthink = time + 1;
	}
	else if (self.attack_state == 2)
	{
		self.attack_state = 3;
		self.nextthink = time + 0.2;
	}
	else if (self.attack_state == 3)
	{
		self.attack_state = 0;
		self.nextthink = time + 0.1;
		if (self.classname == "trap_gods_wrath")
			self.nextthink = -1;
	}
};

/*QUAKED trap_tesla_coil (0 .5 .8) (-8 -8 -8) (8 8 8) targetenemies
targets enemies in vicinity and fires at them
"wait" how long build up should be (2 second default)
"dmg" how much damage lightning should inflict (2 + 5*skill default)
"duration" how long each lightning attack should last (continuous default)
"distance" how far the tesla coil should reach (600 default)
"state" on/off for the coil (0 default is off)
"count" number of people to target (2 default)
*/
void() trap_tesla_coil =
{
	precache_sound ("misc/tesla.wav");
	precache_sound ("hipweap/mjolhit.wav");   // lightning sound

	if (self.wait == 0)
		self.wait = 2;

	if (self.dmg == 0)
		self.dmg = 2 + 5*cvar("skill");

	if (self.duration == 0)
		self.duration = -1;

	if (self.distance == 0)
		self.distance = 600;

	if (self.spawnflags & TESLA_TARGETMONSTERS)
		self.cnt = FL_CLIENT | FL_MONSTER | FL_CORPSE;
	else
		self.cnt = FL_CLIENT;

	self.use = trap_lightning_switched_use;

	if (self.delay == 0)
		self.delay = -1;

	self.nextthink = time + random();
	self.think = trap_tesla_think;
	self.lastvictim = world;
	tesla_numtargets = 0;
	self.attack_state = 0;
//	self.deathtype = "is electrocuted";
};

void() trap_gods_wrath_use =
{
	if (self.attack_state == 0)
	{
		self.search_time = time + self.delay;
		self.lastvictim = activator;
		trap_tesla_think();
	}
};

/*QUAKED trap_gods_wrath (0 .5 .8) (-8 -8 -8) (8 8 8) targetenemies
targets enemies in vicinity and fires at them
"dmg" how much damage lightning should inflict (5 default)
"duration" how long each lightning attack should last (continuous default)
"distance" how far god's wrath should reach (600 default)
"delay" how long to wait until god calms down
this is only needed if no one is targetted (5 seconds default)
"count" number of people to target (2 default)
*/
void() trap_gods_wrath =
{
	if (self.delay == 0)
		self.delay = 5;

	trap_tesla_coil();

	self.wait = 0;
	self.state = 1;
	self.nextthink = -1;

//	self.deathtype = "suffers the wrath of God";
//	self.attack_state = 1;

	self.use = trap_gods_wrath_use;
};

void() trap_gravity_touch =
{
	if (self.attack_finished > time)
	return;
	
	if (other.takedamage)
	{
		if (self.spawnflags & GRAVITYWELL_UNDERWATER)
			T_Damage (other, self, self, self.dmg, "diced");
		else
			T_Damage (other, self, self, self.dmg, "singularity");

		self.attack_finished = time + 0.2;
	}
};

void() trap_gravity_think =
{
	local vector vel;
	local vector dir;
	local vector delta;
	
	self.ltime = time;
	trap_tesla_scan();

	while (tesla_numtargets > 0)
	{
		delta = self.origin - tesla_target.origin;
		dir = normalize(delta);
		vel = dir * self.speed;

		if (tesla_target.wetsuit_finished > time)
		if (self.spawnflags & GRAVITYWELL_UNDERWATER)
			vel = vel*0.6;
		
		tesla_target.velocity = tesla_target.velocity + vel;
		tesla_target = tesla_target.next_ent;
		tesla_numtargets = tesla_numtargets - 1;
	}

	self.nextthink = time + 0.1;
};

/*QUAKED trap_gravity_well (.8 .5 0) (-8 -8 -8) (8 8 8) targetenemies UNDERWATER
targets enemies in vicinity and draws them near, gibbing them on contact.

UNDERWATER cuts the pull in half for players wearing the wetsuit

"distance" how far the gravity well should reach (600 default)
"count" number of people to target (2 default)
"speed" is how strong the pull is. (210 default)
"dmg" is how much damage to do each touch. (10000 default)
*/
void() trap_gravity_well =
{
	self.solid = SOLID_TRIGGER;
	self.movetype = MOVETYPE_NONE;
	setsize( self, '-16 -16 -16','16 16 16');

	if (self.dmg == 0)
		self.dmg = 10000;

	if (self.speed == 0)
		self.speed = 210;
	
	if (self.distance == 0)
		self.distance = 600;

	if (self.spawnflags & TESLA_TARGETMONSTERS)
		self.cnt = FL_CLIENT | FL_MONSTER | FL_CORPSE;
	else
		self.cnt = FL_CLIENT;
	
	self.attack_finished = 0;
	self.touch = trap_gravity_touch;
	self.lastvictim = world;
	tesla_numtargets = 0;

	self.think = trap_gravity_think;
	self.nextthink = time + 0.1;
	self.ltime = time;
};
