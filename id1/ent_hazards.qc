void() OgreGrenadeTouch;
void() OgreGrenadeThink;

/*QUAKED misc_fireball (0 .5 .8) (-8 -8 -8) (8 8 8)
Lava Balls
*/
void() fireball_fly;
void() fireball_touch;
void() misc_fireball =
{
	precache_model ("progs/lavaball.mdl");
	self.classname = "fireball";
	self.nextthink = time + 0.1 + 5*random();
	self.think = fireball_fly;

	if (!self.speed)
		self.speed = 1000;
};

void() fireball_fly =
{
	local 	entity	fireball;

	fireball = spawn();
	fireball.solid = SOLID_TRIGGER;
	fireball.movetype = MOVETYPE_TOSS;
	fireball.velocity = '0 0 1000';
	fireball.velocity_x = (random() * 100) - 50;
	fireball.velocity_y = (random() * 100) - 50;
	fireball.velocity_z = self.speed + (random() * 200);
	fireball.classname = "fireball";
	setmodel (fireball, "progs/lavaball.mdl");
	setsize (fireball, '0 0 0', '0 0 0');
	setorigin (fireball, self.origin);
	fireball.nextthink = time + 5;
	fireball.think = SUB_Remove;
	fireball.touch = fireball_touch;
	
	self.nextthink = time + 5*random() + 3;
	self.think = fireball_fly;
};

void() fireball_touch =
{
	T_Damage (other, self, self, 20, "");
	remove(self);
};

//============================================================================

void() barrelgib_touch =
{
//	te_gunshot(self.origin);
	pointparticles(particleeffectnum("EF_SPARKS"), self.origin, VEC_0, 16 + 16*random());
};

void(float ind, vector org) barrel_throwgib =
{
	local entity new;
	local string gibname;
	
	new = spawn();
//	new.origin = self.origin;

	gibname = strcat("progs/crt_gib", ftos(ind), ".mdl");

	setmodel (new, gibname);
	setsize (new, '-2 -2 -2', '2 2 2');
	setorigin(new, org);

//	new.velocity_x = 160*crandom();
//	new.velocity_y = 160*crandom();
//	new.velocity_z = 140 + 160*random();

//	new.velocity = 2*(300 + 50*crandom())*randomdirvec();
	new.velocity = 1500*randomdirvec();
	new.velocity_z = 500*random() + 100*crandom();
//	new.velocity_z = 400 + 200*random();

//	new.velocity_z = 140 + new.velocity_z;

	new.movetype = MOVETYPE_BOUNCE;
	new.solid = SOLID_TRIGGER;	//SOLID_BBOX;

	new.avelocity_x = random()*300;
	new.avelocity_y = random()*300;
	new.avelocity_z = random()*300;

	new.classname = "gib";
	new.touch = barrelgib_touch; 	//SUB_Null;

	new.fadetime = 5;
	new.think = SUB_Fadeaway;
	new.nextthink = time + 40 + random()*5;

	new.bouncefactor = 0.3;
	new.alpha = 1;
	new.effects = new.effects | EF_LOWPRECISION;
	new.flags = new.flags - (new.flags & FL_ONGROUND);
};

void(vector org) barrel_gibs =
{
	local float numgibs, r;

	if (self.model == "maps/b_explob.bsp")
		numgibs = floor(10 + 5*random());
	else
		numgibs = floor(5 + 5*random());

	while (numgibs > 0)
	{
		r = floor(1 + 8*random());
		barrel_throwgib(r, org);
		numgibs--;
	}
};

void() barrel_damage =
{
	self.origin = 0.5*(self.absmin + self.absmax);

//	print("explobox was killed by ", etos(self.enemy), "\n");
	T_RadiusDamage (self, self.enemy, 160, world, "barrel");
//	sound (self, CHAN_VOICE, "weapons/r_exp3.wav", 1, ATTN_NORM);
//	particle (self.origin, '0 0 0', 75, 255);

	self.origin_z = self.origin_z - 8;
	barrel_gibs(self.origin);
	te_explosion(self.origin);		
//	self.origin_z = self.origin_z + 32;
	BecomeExplosion ();
};

void(entity killer, float damage) barrel_explode =
{
/*	self.takedamage = DAMAGE_NO;
	self.classname = "explo_box";
	// did say self.owner
	//T_RadiusDamage (self, self, 160, world);
	T_RadiusDamage (self, self, 160, world, "");
	sound (self, CHAN_VOICE, "weapons/r_exp3.wav", 1, ATTN_NORM);
	particle (self.origin, '0 0 0', 75, 255);

	self.origin_z = self.origin_z + 32;
	BecomeExplosion ();
*/
	self.solid = SOLID_NOT;
	self.classname = "barrel";
	self.enemy = killer;		//keep track who exploded the barrel
	self.nextthink = time + 0.01;
	self.think = barrel_damage;
};

/*QUAKED misc_explobox (0 .5 .8) (0 0 0) (32 32 64)
TESTING THING
*/
void() misc_explobox =
{
	local	float	oldz;
	
	self.solid = SOLID_BBOX;
	self.movetype = MOVETYPE_NONE;

	precache_model ("maps/b_explob.bsp");
	setmodel (self, "maps/b_explob.bsp");
//	precache_model ("progs/b_explob.bsp");
//	setmodel (self, "progs/b_explob.bsp");

	precache_model ("progs/crt_gib1.mdl");
	precache_model ("progs/crt_gib2.mdl");
	precache_model ("progs/crt_gib3.mdl");
	precache_model ("progs/crt_gib4.mdl");
	precache_model ("progs/crt_gib5.mdl");
	precache_model ("progs/crt_gib6.mdl");
	precache_model ("progs/crt_gib7.mdl");
	precache_model ("progs/crt_gib8.mdl");

	self.health = 20;
	self.th_die = barrel_explode;
	self.takedamage = DAMAGE_AIM;
	self.flags = FL_NOBLOOD;
	self.effects = EF_DYNAMICMODELLIGHT;

//	self.origin_x += 16;
//	self.origin_y += 16;	
	self.origin_z = self.origin_z + 2;
	oldz = self.origin_z;
	droptofloor(0,0);

	if (oldz - self.origin_z > 250)
	{
		dprint ("item fell out of level at ");
		dprint (vtos(self.origin));
		dprint ("\n");
		remove(self);
	}
};


/*QUAKED misc_explobox2 (0 .5 .8) (0 0 0) (32 32 64)
Smaller exploding box, REGISTERED ONLY
*/
void() misc_explobox2 =
{
	local	float	oldz;
	
	self.solid = SOLID_BBOX;
	self.movetype = MOVETYPE_NONE;

	precache_model2 ("maps/b_exbox2.bsp");
	setmodel (self, "maps/b_exbox2.bsp");
//	precache_model2 ("progs/b_exbox2.bsp");
//	setmodel (self, "progs/b_exbox2.bsp");

	precache_model ("progs/crt_gib1.mdl");
	precache_model ("progs/crt_gib2.mdl");
	precache_model ("progs/crt_gib3.mdl");
	precache_model ("progs/crt_gib4.mdl");
	precache_model ("progs/crt_gib5.mdl");
	precache_model ("progs/crt_gib6.mdl");
	precache_model ("progs/crt_gib7.mdl");
	precache_model ("progs/crt_gib8.mdl");

	self.health = 20;
	self.th_die = barrel_explode;
	self.takedamage = DAMAGE_AIM;
	self.flags = FL_NOBLOOD;
	self.effects = EF_DYNAMICMODELLIGHT;

//	self.origin_x += 16;
//	self.origin_y += 16;	
	self.origin_z = self.origin_z + 2;
	oldz = self.origin_z;
	droptofloor(0,0);

	if (oldz - self.origin_z > 250)
	{
		dprint ("item fell out of level at ");
		dprint (vtos(self.origin));
		dprint ("\n");
		remove(self);
	}
};

//============================================================================

void(vector org, vector vec) LaunchLaser;

void(vector org, vector dir) LaunchGrenade =
{
	local entity missile;
	local vector rdir;

	missile = spawn();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;
	missile.classname = "shooter_grenade";
		
	// set missile speed	
	// give the grenades some slight variance in direction and speed so they aren't so predictable
	rdir = dir;
	rdir_y = rdir_y - 1 + 2*random();
	missile.velocity = rdir*(900 + 200*random());
	missile.angles = vectoangles(missile.velocity);

//	makevectors (self.angles);
	missile.avelocity = '300 300 300';
	missile.pitch_speed = 10;
	
	missile.touch = OgreGrenadeTouch;
	
	// set missile duration
	missile.nextthink = time + 0.01;	//2.5;
	missile.think = OgreGrenadeThink;	//OgreGrenadeExplode;
	missile.ltime = time;

	setmodel (missile, "progs/grenade.mdl");
	setsize (missile, '0 0 -4', '0 0 4');	
	setorigin (missile, org);	
};

void() spikeshooter_use =
{
	if (self.spawnflags & SPAWNFLAG_LASER)
	{
		LaunchLaser (self.origin, self.movedir);
	}
	else if (self.spawnflags & SPAWNFLAG_GRENADE)
	{
		sound (self, CHAN_VOICE, "weapons/grenade.wav", 1, ATTN_NORM);
		LaunchGrenade (self.origin, self.movedir);
	}
#ifdef HIPNOTIC
	else if (self.spawnflags & SPAWNFLAG_LAVABALL)
	{
		local entity lavaball;

		if (!(self.spawnflags & SPAWNFLAG_SHOOTSILENT))	
			sound (self, CHAN_VOICE, "misc/spike.wav", 1, ATTN_NORM);

		lavaball = spawn();
		lavaball.movetype = MOVETYPE_FLYMISSILE;
		lavaball.solid = SOLID_BBOX;
		lavaball.classname = "lavaball";
	// set lavaball speed
		lavaball.velocity = self.movedir * 300;
		lavaball.angles = vectoangles(lavaball.velocity);
		lavaball.owner = self;
		lavaball.touch = T_MissileTouch;
		setmodel (lavaball, "progs/lavarock.mdl");
		setsize (lavaball, '-4 -4 -4', '4 4 4');
		setorigin (lavaball, self.origin);
		lavaball.avelocity = '0 0 400';
		lavaball.nextthink = time + 5;
		lavaball.think = SUB_Remove;
	}
	else if (self.spawnflags & SPAWNFLAG_ROCKET)
	{
		if (!(self.spawnflags & SPAWNFLAG_SHOOTSILENT))	
			sound (self, CHAN_VOICE, "weapons/sgun1.wav", 1, ATTN_NORM);

		W_FireRocket();
		newmis.velocity = self.movedir*1000;
		newmis.angles = vectoangles(newmis.velocity);
		setorigin (newmis, self.origin + self.movedir*8);
	}
#endif
	else
	{
#ifdef HIPNOTIC
		if (!(self.spawnflags & SPAWNFLAG_SHOOTSILENT))	
#endif
		sound (self, CHAN_VOICE, "weapons/spike2.wav", 1, ATTN_NORM);
		
		launch_spike (self.origin, self.movedir);
		newmis.velocity = self.movedir * 500;

		if (self.spawnflags & SPAWNFLAG_SUPERSPIKE)
		{
			newmis.skin = 1;
			newmis.touch = superspike_touch;
		}
	}
};

void() shooter_think =
{
#ifdef HIPNOTIC
	if (self.state)
#endif
	spikeshooter_use ();

	self.nextthink = time + self.wait;
#ifdef ID1
	newmis.velocity = self.movedir*500;
#endif
};


/*QUAKED trap_spikeshooter (0 .5 .8) (-8 -8 -8) (8 8 8) superspike laser lavaball rocket silent
When triggered, fires a spike in the direction set in QuakeEd.
Laser is only for REGISTERED.
*/
void() trap_spikeshooter =
{
	SetMovedir ();
	self.use = spikeshooter_use;

	if (self.spawnflags & SPAWNFLAG_LASER)
	{
		precache_model2 ("progs/laser.mdl");
		precache_sound2 ("enforcer/enfire.wav");
		precache_sound2 ("enforcer/enfstop.wav");
	}
	else if (self.spawnflags & SPAWNFLAG_GRENADE)
	{
		precache_sound2 ("weapons/grenade.wav");
		precache_model ("progs/grenade.mdl");
	}
#ifdef HIPNOTIC
	else if (self.spawnflags & SPAWNFLAG_LAVABALL)
	{
		precache_model ("progs/lavarock.mdl");
		precache_sound2 ("misc/spike.wav");
	}
	else if (self.spawnflags & SPAWNFLAG_ROCKET)
	{
		precache_model ("progs/missile.mdl");
		precache_sound ("weapons/sgun1.wav");
	}
#endif
	else
		precache_sound ("weapons/spike2.wav");
};


/*QUAKED trap_shooter (0 .5 .8) (-8 -8 -8) (8 8 8) superspike laser lavaball rocket silent
Continuously fires spikes.
"wait" time between spike (1.0 default)
"nextthink" delay before firing first spike, so multiple shooters can be stagered.
*/
void() trap_shooter =
{
	trap_spikeshooter ();
	
	if (self.wait == 0)
		self.wait = 1;

#ifdef HIPNOTIC
	self.state = 1;
#endif

//	self.nextthink = self.nextthink + self.wait + self.ltime;
	self.nextthink = self.nextthink + time + self.wait + self.ltime;
	self.think = shooter_think;
};

#ifdef HIPNOTIC
void() trap_shooter_use =
{
	self.state = 1 - self.state;
};

/*QUAKED trap_switched_shooter (0 .5 .8) (-8 -8 -8) (8 8 8) superspike laser lavaball rocket silent
Continuously fires spikes.
"wait" time between spike (1.0 default)
"nextthink" delay before firing first spike, so multiple shooters can be stagered.
"state" 0 initially off, 1 initially on. (0 default)
*/
void() trap_switched_shooter =
{
	trap_spikeshooter ();
	
	if (self.wait == 0)
		self.wait = 1;

	self.nextthink = time + self.wait + self.ltime;
	self.think = shooter_think;
	self.use = trap_shooter_use;
};
#endif
