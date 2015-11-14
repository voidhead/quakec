/*
==============================================================================

SPIKES

==============================================================================
*/
//void() spike_touch;
//void() superspike_touch;
void(vector org, entity en, vector dir) WallSpike;

void() spike_think = 
{
	local float fltime;
	fltime = time - self.ltime;

	if (fltime > 6)
	{
		remove(self);
		return;
	}

	self.nextthink = time + 0.05;

	if (CheckQuad(self.owner))
	{
		self.glow_color = 244;
		self.glow_size = 50;
		self.glow_trail = FALSE;
	}
	else
		self.glow_size = 0;
		
};

void() spike_touch =
{
// don't explode on owner
	if (other == self.owner)
		return;

	if (other.solid == SOLID_TRIGGER)	// trigger field, do nothing
		return;

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}

	WallSpike(self.origin, other, self.velocity);

// hit something that bleeds
	if (other.takedamage)
	{
		// wizards and dks are mostly immune to their own attack
		if ((self.classname == "wizspike" || self.classname == "knightspike") && self.owner.classname == other.classname)
		{
			spawn_touchblood (3);
			T_Damage (other, self, self.owner, 1, self.classname);
		}
		else
		{
			spawn_touchblood (9);
			T_Damage (other, self, self.owner, 9, self.classname);
		}
	}
	else
	{
		if (self.classname == "wizspike")
				te_wizspike(self.origin);
		else if (self.classname == "knightspike")
				te_knightspike(self.origin);
		else if (CheckQuad(self.owner))
			te_spikequad(self.origin);
		else
			te_spike(self.origin);
	}

	remove(self);
};

void() FakeSpike_touch =
{
	if (other == self.owner)
		return;

	if (self.classname == other.classname)
		return;

	if (other.solid == SOLID_TRIGGER)	// trigger field, do nothing
		return;

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	
	WallSpike (self.origin, other, self.velocity);

// hit something that bleeds
	if (other.takedamage)
	{
		spawn_touchblood (9);
	}
	else
	{
		if (CheckQuad(self.owner))
			te_superspikequad(self.origin);
		else
			te_superspike(self.origin);		
	}

	remove(self);
};

void() superspike_touch =
{
	if (other == self.owner)
		return;

	if (self.classname == other.classname)
		return;

	if (other.solid == SOLID_TRIGGER)	// trigger field, do nothing
		return;

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	
	WallSpike (self.origin, other, self.velocity);

// hit something that bleeds
	if (other.takedamage)
	{
		spawn_touchblood (9);	//18
		T_Damage (other, self, self.owner, 18, "supernail");
	}
	else
	{
		if (CheckQuad(self.owner))
			te_superspikequad(self.origin);
		else
			te_superspike(self.origin);		
	}

	remove(self);
};

/*
===============
launch_spike

Used for both the player and the ogre
===============
*/
void(vector org, vector dir) launch_spike =
{
	newmis = spawn ();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLYMISSILE;
	newmis.solid = SOLID_BBOX;

	newmis.angles = vectoangles(dir);

	newmis.touch = spike_touch;

//	newmis.classname = "nail";
	newmis.classname = "spike";

	newmis.think = spike_think;
	newmis.nextthink = 1;
	newmis.ltime = time;
	setmodel (newmis, "progs/spike.mdl");
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);		
	setorigin (newmis, org);

	newmis.velocity = dir*1000;
};


void() Laser_Touch =
{
	local vector org;
	
	if (other == self.owner)
		return;		// don't explode on owner

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	
	sound (self, CHAN_WEAPON, "enforcer/enfstop.wav", 1, ATTN_STATIC);
	org = self.origin - 8*normalize(self.velocity);

	if (other.health > 0)
	{
		SpawnBlood(other, org, self.velocity*0.2, 15);
		T_Damage (other, self, self.owner, 15, self.classname);
	}
	else
	{
		te_gunshot(self.origin);
	}
	
	remove(self);	
};


void(vector org, vector vec) LaunchLaser =
{
#ifdef HIPNOTIC
	if (self.classname != "monster_enforcer")
	if (!(self.spawnflags & SPAWNFLAG_SHOOTSILENT))	
#endif		
	sound (self, CHAN_WEAPON, "enforcer/enfire.wav", 1, ATTN_NORM);

	vec = normalize(vec);
	
	newmis = spawn();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLY;
	newmis.solid = SOLID_BBOX;
//	newmis.effects = EF_DIMLIGHT;

	setmodel (newmis, "progs/laser.mdl");
	setsize (newmis, '0 0 0', '0 0 0');		
	setorigin (newmis, org);

	newmis.velocity = vec*600;
	newmis.angles = vectoangles(newmis.velocity);

	newmis.glow_color = 239;
	newmis.glow_size = 100;
	newmis.glow_trail = FALSE;

	if (self.classname == "monster_enforcer")
		newmis.classname = "enfspike";
	else
		newmis.classname = "laser";

	newmis.traileffectnum = particleeffectnum("TR_SPIKE");

	newmis.nextthink = time + 5;
	newmis.think = SUB_Remove;
	newmis.touch = Laser_Touch;
};


/*
==============================================================================

ROCKETS

==============================================================================
*/

void()	s_explode1  = [0,  s_explode2] {if (CheckQuad(self.owner)) self.glow_size *= 0.8;};
void()	s_explode2  = [1,  s_explode3] {if (CheckQuad(self.owner)) self.glow_size *= 0.8;};
void()	s_explode3  = [2,  s_explode4] {if (CheckQuad(self.owner)) self.glow_size *= 0.8;};
void()	s_explode4  = [3,  s_explode5] {if (CheckQuad(self.owner)) self.glow_size *= 0.7;};
void()	s_explode5  = [4,  s_explode6] {if (CheckQuad(self.owner)) self.glow_size *= 0.6;};
void()	s_explode6  = [5,  SUB_Remove] {if (CheckQuad(self.owner)) self.glow_size = 0;};

void() BecomeExplosion =
{
	self.alpha = 0.7;
	self.movetype = MOVETYPE_NONE;
	self.velocity = '0 0 0';
	self.touch = SUB_Null;
	setmodel (self, "progs/s_explod.spr");
	self.solid = SOLID_NOT;
	s_explode1 ();
//	remove(self);
};

void() T_MissileTouch =
{
	local	float	damg;
//	local	vector	vel;

	if (other == self.owner)
		return;		// don't explode on owner

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		self.touch = SUB_Null;
		self.nextthink = time + 0.01;
		self.think = SUB_Remove;
		return;
	}

	damg = 100 + random()*20;
	
	if (other.health > 0)
	{
		if (other.classname == "monster_shambler")
			damg = damg*0.5;	// mostly immune

		T_Damage (other, self, self.owner, damg, "rocket");

		SpawnBlood_Expl(other, self.velocity, damg);
	}

// don't do radius damage to the other, because all the damage
// was done in the impact
	T_RadiusDamage (self, self.owner, 120, other, "rocket");	//120

//	sound (self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NORM);
	self.origin = self.origin - 8*normalize(self.velocity);

	if (CheckQuad(self.owner))
		te_explosionquad(self.origin);
	else
		te_explosion(self.origin);		

	BecomeExplosion();
};

void() missile_fail =
{
	self.movetype = MOVETYPE_TOSS;
	self.effects = EF_NOMODELFLAGS;
};

void() missile_think = 
{
	local float fltime;
//	local float vel;
//	local vector ang, f, r, u;

	fltime = time - self.ltime;

	self.nextthink = time + 0.1;

/*	ang_x = 0 - anglemod(self.angles_x);
	ang_y = anglemod(self.angles_y);
	ang_z = anglemod(self.angles_z);

	makevectors(ang);
//	vel = vlen(self.velocity);

	f = v_forward*1000;
// spirals 32 units per second
	r = 64*v_right*sin(DEG2RAD*1440*fltime);
	u = 64*v_up*cos(DEG2RAD*1440*fltime);
	
	self.velocity = 1000*normalize(f + r + u);
	self.angles = vectoangles(self.velocity);
*/
	
//after 5s the rocket's motor fails	
	if (fltime > 5)
	{
		self.think = missile_fail;
		return;
	}

// after 2.5s of flight the rocket begins to decelerate,
// losing 20% of speed per second and descending slightly
	if (fltime > 2.5)
	{
		self.cnt++;
		self.velocity = 1000*normalize(self.velocity)*(1 - 0.02*self.cnt);
		self.velocity_z = self.velocity_z - 0.5*50*pow(self.cnt*0.1, 2);
	}

	if (CheckQuad(self.owner))
	{
		self.glow_color = 244;
		self.glow_size = 150;
		self.glow_trail = FALSE;
	}
	else
		self.glow_size = 0;
};


/*
===============================================================================

GRENADES

===============================================================================
*/

void() GrenadeExplode =
{
	T_RadiusDamage (self, self.owner, 120, world, "grenade");

	if (CheckQuad(self.owner))
		te_explosionquad(self.origin);
	else
		te_explosion(self.origin);		

	BecomeExplosion ();
};

void() GrenadeTouch =
{
//	print(etos(other), "\n");

	if (other == self.owner)
		return;		// don't explode on owner

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		self.touch = SUB_Null;
		self.nextthink = time + 0.01;
		self.think = SUB_Remove;
		return;
	}

	if (other.takedamage == DAMAGE_AIM)
	{
		GrenadeExplode();
		return;
	}

	sound (self, CHAN_WEAPON, "weapons/bounce.wav", 1, ATTN_NORM);	// bounce sound

/*
	if (other.solid == SOLID_BSP)
	{
		local float dst;
		local vector dif;

		dif = self.origin - self.owner.origin;
		dif_z = 0;
		dst = vlen(dif);
		print("dist=", ftos(dst), "\n");
	}	
*/

//	if (vlen(self.velocity) == 0)
//	{
//		self.avelocity = VEC_0;
//	}
};


void() grenade_think = 
{
	local float fltime;
	fltime = time - self.ltime;

	if (fltime > 2.5)
	{
		GrenadeExplode();
		return;
	}

	self.nextthink = time + 0.01;

	if (vlen(self.velocity) < 100)
	{
		self.avelocity_x = 0;
		self.idealpitch = anglemod_ground(self.angles_x);
		changepitch(self);
	}

	if (CheckQuad(self.owner))
	{
		self.glow_color = 244;
		self.glow_size = 100;
		self.glow_trail = FALSE;
	}
	else
		self.glow_size = 0;
};
