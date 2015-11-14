/*
==============================================================================

CORPSES

==============================================================================
*/
void(vector bmins, vector bmaxs) body_solid =
{
	if (!(self.flags & FL_CORPSE))
		return;

	slope_angles(self);

	if (self.solid == SOLID_SLIDEBOX)
	if (bmins == self.mins)
	if (bmaxs == self.maxs)
		return;

	self.solid = SOLID_SLIDEBOX;
	setsize (self, bmins, bmaxs); // relink
};

void(vector bmins, vector bmaxs) body_nonsolid =
{
	if (!(self.flags & FL_CORPSE))
		return;

	slope_angles(self);

	if (self.solid == SOLID_CORPSE)
	if (bmins == self.mins)
	if (bmaxs == self.maxs)
		return;

	self.solid = SOLID_CORPSE;
	setsize (self, bmins, bmaxs); // relink
};

void(entity ent, void() framefunc) make_corpse =
{
 // Gibbable Corpses: Turn me into a damagable corpse

	ent.solid = SOLID_CORPSE;
	ent.movetype = MOVETYPE_TOSS;
	ent.takedamage = DAMAGE_YES;

 // If a custom HP is specified, use that
	if(ent.corpsehealth > 0)
		ent.max_health = ent.corpsehealth;
	else
		ent.max_health = 100;	// default

	ent.health = ent.health + ent.max_health;
	ent.corpsehealth = EXTRA_HIGH;
	ent.gibhealth = EXTRA_LOW;
 								// If it was a monster, it's not a monster anymore
	ent.flags = ent.flags - (ent.flags & FL_MONSTER); 	// (this is important to prevent crashes or corpses
	ent.flags = ent.flags | FL_CORPSE;			// getting up as invincible monsters)
	ent.flags = ent.flags | FL_NOBREATH;

	ent.deadflag = DEAD_DEAD;

	ent.think = framefunc;
	ent.nextthink = 1;

 // Gib when killed
	ent.th_die = corpse_die;

 // Clear other th_ functions
	ent.th_pain = SUB_Null; 	// Especially important: make sure it doesn't have 
	ent.th_walk = SUB_Null;		// pain frames that get it back up again! (invincible monsters bug)
	ent.th_run = SUB_Null;
	ent.th_stand = SUB_Null;
	ent.th_missile = SUB_Null;
	ent.th_melee = SUB_Null;
	ent.th_gib = SUB_Null;
	ent.th_sight = SUB_Null;

//	slope_angles();
};

// Convenience funtion just redirects to BecomeCorpse, assuming self as ent.
void(void() framefunc) monster_corpse =
{
	make_corpse(self, framefunc);
};

void(string headgib, float damage, float gibtype) monster_gib =
{
	local float r;	//, damg;
//	local vector org, dir, pos, vel;

	self.flags = self.flags - (self.flags & FL_MONSTER);
	self.flags = self.flags | FL_GIBBED;
	self.flags = self.flags | FL_NOBREATH;

/*	TODO
	if (vlen(self.dest))
	{
		org = self.origin;
		dir = normalize(self.dest);
		traceline(org, org + 256*dir, MOVE_NORMAL, self);

		if (trace_fraction != 1)
		{
			pos = trace_endpos - dir*4;	// + self.view_ofs;
			damg = min(0.5*damage, 128);
			vel = damg*dir;	//VEC_0;	//2*random()*dir;	//'64 64 64' + 
			pointparticles(particleeffectnum("EF_BLOODSMEAR"), pos, vel, damg);
		}
	}
*/

//	if(!self.th_gib)
	sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);

	// splat!
	CreateBloodshower(damage);

 	// Chuck a few generic pieces of meat
	switch (gibtype)
	{
		case GIB_SMALL:	
			//bprint("gib0\n");	//small monster (fish, dog)
			r = ceil(random()*2);
			while (r > 0)
			{
				r--;
				ThrowGib ("progs/gib1.mdl", damage, self.dest);
			}
			r = ceil(random()*2);
			while (r > 0)
			{
				r--;
				ThrowGib ("progs/gib3.mdl", damage, self.dest);
			}
			break;	
		case GIB_HUMANOID:	
			//bprint("gib1\n");	//human monster
			ThrowGib ("progs/gib2.mdl", damage, self.dest);	//only one torso
	
			r = ceil(random()*3);
			while (r > 0)
			{
				r--;
				ThrowGib ("progs/gib1.mdl", damage, self.dest);
			}
			r = ceil(random()*3);
			while (r > 0)
			{
				r--;
				ThrowGib ("progs/gib3.mdl", damage, self.dest);
			} 
			break;
		case GIB_LARGE: 
			//bprint("gib2\n");	//big monster (shambler, fiend) 
			r = ceil(random()*4);		
			while (r > 0)
			{
				r--;
				ThrowGib ("progs/gib1.mdl", damage, self.dest);
			}
			r = ceil(random()*4);
			while (r > 0)
			{
				r--;
				ThrowGib ("progs/gib2.mdl", damage, self.dest);
			}
			r = ceil(random()*4);
			while (r > 0)
			{
				r--;
				ThrowGib ("progs/gib3.mdl", damage, self.dest);
			}
			break;
		default:
			 return;
	}

 	// Use the head model we stored in BecomeCorpse
	if (headgib)
		ThrowHead(headgib, damage, self.dest);
	else
		ThrowHead("progs/gib3.mdl", damage, self.dest);
};

void() corpse_die =
{
	self.takedamage = DAMAGE_NO;
	self.th_die = SUB_Null;
	self.flags = self.flags | FL_GIBBED;

 // Pick a default head model (unidentifiable flesh chunk) if one wasn't set
	if (self.headname == "")
		self.headname = "progs/gib3.mdl";

	local float r;
	r = random();
	if (r > 0.33)
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
	else if (r > 0.22)
		sound (self, CHAN_VOICE, "zombie/z_miss.wav", 1, ATTN_NORM);
	else if (r > 0.11)
		sound (self, CHAN_VOICE, "player/gib.wav", 1, ATTN_NORM);
	else
		sound (self, CHAN_VOICE, "player/teledth1.wav", 1, ATTN_NORM);
/*
	traceline(self.origin, self.origin, MOVE_NORMAL, self);
	if (trace_dpstartcontents & DPCONTENTS_NODROP)
	{
		self.dest = VEC_0;
		self.health -= 50*random();
	}
*/
	monster_gib(self.headname, self.health, self.gib);
};

void() MonsterDead =
{
//	slope_angles(self);
//	print(ftos(self.flags), "\n");
	self.think = SUB_Null;
	self.nextthink = -1;

	if (qonquer)
	{
		self.minion = FALSE;
		self.effects = self.effects - (self.effects & EF_DIMLIGHT);
		entity_sink_setup();
	}
};

/*
==============================================================================

Player corpses & gibs

==============================================================================
*/

//creates a corpse and attaches the player's camera to it
void() CreateDeathCam =
{
	self.takedamage = DAMAGE_NO;

	CopyToBodyQue(self);

	setmodel(self, "");
	setsize(self, VEC_0, VEC_0);

	if (!self.ishuman)	//frikbot
		return;

//place the camera near corpse's head 
	if (self.aiment.model != "progs/player.mdl")
		self.view_ofs = '5.8 -3 17.5';
	else
	{
		if (self.aiment.frame == $deatha1)
			self.view_ofs = '22.2 0.7 -19.5';
		else if (self.aiment.frame == $deathb1)
			self.view_ofs = '7.2 -0.6 -11.5';
		else if (self.aiment.frame == $deathc1)
			self.view_ofs = '14.9 -5.1 -16.1';
		else if (self.aiment.frame == $deathd1)
			self.view_ofs = '18.7 1.7 -14.9';
		else if (self.aiment.frame == $deathe1)
			self.view_ofs = '17.5 5.4 -11.6';
		else if (self.aiment.frame == $axdeth1)
			self.view_ofs = '-32 -2 -15';
	}
};


void() GibPlayer =
{
	local float r;

	self.items = self.items - (self.items & IT_INVISIBILITY);
	self.items = self.items - (self.items & IT_INVULNERABILITY);
	self.items = self.items - (self.items & IT_QUAD);
	self.items = self.items - (self.items & IT_SUIT);

	self.invisible_finished = 0;	// don't die as eyes
	self.invincible_finished = 0;
	self.super_damage_finished = 0;
	self.radsuit_finished = 0;

	self.effects = self.effects - (self.effects & EF_DIMLIGHT);
	self.glow_size = 0;

	self.modelindex = modelindex_player;	// don't use eyes

	if (deathmatch || coop)
		DropBackpack();
	
	self.weaponmodel = "";
	self.view_ofs = '0 0 -8';
	self.deadflag = DEAD_DYING;
	self.flags = self.flags - (self.flags & FL_ONGROUND);
	self.flags = self.flags | FL_NOBREATH;
	self.flags = self.flags | FL_GIBBED;

	if (self.velocity_z < 10)
		self.velocity_z = self.velocity_z + random()*300;

	self.movetype = MOVETYPE_BOUNCE;
	self.solid = SOLID_TRIGGER;
	self.takedamage = DAMAGE_NO;

	if (damage_attacker.classname == "teledeath" ||
	    damage_attacker.classname == "teledeath2" ||
	    damage_attacker.classname == "teledeath3")
	{
		sound (self, CHAN_VOICE, "player/teledth1.wav", 1, ATTN_NONE);
	}
	else
	{
		r = random();
		if (r < 0.5)
			sound (self, CHAN_VOICE, "player/gib.wav", 1, ATTN_NONE);
		else
			sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NONE);
	}

	// splat!
	CreateBloodshower(self.health);
	
	r = ceil(random()*3);
	while (r > 0)
	{
		r--;
		ThrowGib ("progs/gib1.mdl", self.health, self.dest);
	}
	r = ceil(random()*3);
	while (r > 0)
	{
		r--;
		ThrowGib ("progs/gib3.mdl", self.health, self.dest);
	} 

	ThrowGib ("progs/gib2.mdl", self.health, self.dest);
	ThrowHead("progs/h_player.mdl", self.health, self.dest);

	CreateDeathCam();
};


void() player_corpse_die =
{
	local float r;

	self.movetype = MOVETYPE_BOUNCE;
	self.solid = SOLID_TRIGGER;
	self.takedamage = DAMAGE_NO;
	self.th_die = SUB_Null;
	self.flags = self.flags | FL_GIBBED;

	precache_sound ("zombie/z_miss.wav");
	precache_sound ("player/udeath.wav");	
	precache_sound ("player/gib.wav");	
	precache_sound ("player/teledth1.wav");	

	r = random();
	if (r > 0.33)
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
	else if (r > 0.22)
		sound (self, CHAN_VOICE, "zombie/z_miss.wav", 1, ATTN_NORM);
	else if (r > 0.11)
		sound (self, CHAN_VOICE, "player/gib.wav", 1, ATTN_NORM);
	else
		sound (self, CHAN_VOICE, "player/teledth1.wav", 1, ATTN_NORM);
/*
	traceline(self.origin, self.origin, MOVE_NORMAL, self);
	if (trace_dpstartcontents & DPCONTENTS_NODROP)
	{
		self.dest = VEC_0;
		self.health -= 50*random();
	}
*/
	// splat!
	CreateBloodshower(self.health);

	ThrowHead ("progs/h_player.mdl", self.health, self.dest);
	ThrowGib ("progs/gib2.mdl", self.health, self.dest);
	
	r = ceil(random()*3);
	while (r > 0)
	{
		r--;
		ThrowGib ("progs/gib1.mdl", self.health, self.dest);
	}
	r = ceil(random()*3);
	while (r > 0)
	{
		r--;
		ThrowGib ("progs/gib3.mdl", self.health, self.dest);
	}

//update deathcam
	if (!self.aiment.ishuman)	//frikbot
	if (self.aiment.flags & FL_CLIENT)
		self.aiment.view_ofs = '5.8 -3 17.5';
};


/*
==============================================================================

BODY QUE

==============================================================================
*/
void() bodyque =
{	// just here so spawn functions don't complain after the world
	// creates bodyques
};

void() InitBodyQue = 
{
	local entity e, prev;
	local float numBodies, num;

	if (coop || deathmatch)
		numBodies = BODYQUE_SIZE; // how many player corpses to allow in the world at once
	else
		numBodies = 1;

	num = 0;
	prev = world;
	bodyque_head = world;

 	while(num < numBodies) 
	{
	// Spawn another body
		e = spawn();
		e.classname = "bodyque";

	// If this is the first, set the bodyque_head pointer (start of the list)
		if(bodyque_head == world)
			bodyque_head = e;
	// Link up to previous item to form the linked list
		if(prev != world)
			e.owner = prev;
	// Point prev to the new item
		prev = e;
	
	// Track how many we've made so we don't have an infinite loop
		num = num + 1;
	}

	// Now that all corpse entities are created, turn the linked list into a linked loop
	bodyque_head.owner = prev;
};

// make a body que entry for the given ent so the ent can be
// respawned elsewhere
void(entity ent) CopyToBodyQue =
{
	bodyque_head.angles = ent.angles;
	bodyque_head.model = ent.model;
	bodyque_head.modelindex = ent.modelindex;
	bodyque_head.frame = ent.frame;
	bodyque_head.colormap = ent.colormap;
	bodyque_head.skin = ent.skin;
	bodyque_head.movetype = ent.movetype;
	bodyque_head.velocity = ent.velocity;
	bodyque_head.avelocity = ent.avelocity;
	bodyque_head.effects = bodyque_head.effects | EF_LOWPRECISION;
	bodyque_head.view_ofs = VEC_0;

	setsize(bodyque_head, ent.mins, ent.maxs);
	setorigin(bodyque_head, ent.origin);

//for deathcam only
	if (ent.deadflag >= DEAD_DYING)
	{
		bodyque_head.touch = ent.touch;
		bodyque_head.think = ent.think;
		bodyque_head.nextthink = ent.nextthink;

		if (ent.ishuman)	//frikbot
			ent.movetype = MOVETYPE_FOLLOW;

		bodyque_head.aiment = ent;
		ent.aiment = bodyque_head;
//		ent.mangle = ent.angles;

		ent.think = SUB_Null;
	}

// make a corpse
	if (ent.model != "progs/player.mdl")	//gibbed already
	{
		bodyque_head.solid = SOLID_TRIGGER;
		bodyque_head.movetype = MOVETYPE_BOUNCE;
		bodyque_head.takedamage = DAMAGE_NO;
		bodyque_head.th_die = SUB_Null;
	}
	else
	{
		bodyque_head.solid = SOLID_CORPSE;
		bodyque_head.movetype = MOVETYPE_TOSS;
		bodyque_head.takedamage = DAMAGE_NO;	//DAMAGE_YES;
		bodyque_head.th_die = player_corpse_die;
		bodyque_head.mass = ent.mass;

//		if (ent.corpsehealth > 0)
//			bodyque_head.health = ent.health + ent.corpsehealth;
//		else
//			bodyque_head.health = ent.health + 100;

		if (ent.corpsehealth > 0)
			bodyque_head.max_health = ent.corpsehealth;
		else
			bodyque_head.max_health = 100;
	
		bodyque_head.health = ent.health + bodyque_head.max_health;
	}

	bodyque_head.headname = ent.headname;
	bodyque_head.gib = ent.gib;
	bodyque_head.dmgtime = 0;	
	bodyque_head.dmg = 0;	

	bodyque_head.corpsehealth = EXTRA_HIGH;
	bodyque_head.gibhealth = EXTRA_LOW;

	bodyque_head.flags = bodyque_head.flags | FL_CORPSE | FL_NOBREATH;

	bodyque_head.deadflag = DEAD_DEAD;

	bodyque_head.th_pain = SUB_Null;
	bodyque_head.th_walk = SUB_Null;
	bodyque_head.th_run = SUB_Null;
	bodyque_head.th_stand = SUB_Null;
	bodyque_head.th_missile = SUB_Null;
	bodyque_head.th_melee = SUB_Null;

//	slope_angles(bodyque_head);

// relink
	bodyque_head = bodyque_head.owner;
};
