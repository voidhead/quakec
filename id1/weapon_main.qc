// called by worldspawn
void() W_Precache =
{
	precache_sound ("weapons/r_exp3.wav");		// new rocket explosion
	precache_sound ("weapons/rocket1i.wav");	// spike gun
	precache_sound ("weapons/sgun1.wav");
	precache_sound ("weapons/guncock.wav");		// player shotgun
	precache_sound ("weapons/ric1.wav");		// ricochet (used in c code)
	precache_sound ("weapons/ric2.wav");		// ricochet (used in c code)
	precache_sound ("weapons/ric3.wav");		// ricochet (used in c code)
	precache_sound ("weapons/spike2.wav");		// super spikes
	precache_sound ("weapons/tink1.wav");		// spikes tink (used in c code)
	precache_sound ("weapons/grenade.wav");		// grenade launcher
	precache_sound ("weapons/bounce.wav");		// grenade bounce
	precache_sound ("weapons/shotgn2.wav");		// super shotgun
	precache_sound ("knight/sword1.wav");   	// ax
#ifdef HIPNOTIC
	precache_sound ("enforcer/enfstop.wav");   	// laser cannon
	precache_sound ("knight/sword1.wav");   	// laser cannon
	precache_sound ("hipweap/laserg.wav");   	// laser cannon
	precache_sound ("hipweap/laserric.wav");   	// laser cannon ricochet
	precache_sound ("hipweap/proxwarn.wav");   	// proximity bomb
	precache_sound ("hipweap/proxbomb.wav");   	// proximity bomb
	precache_sound ("hipweap/mjolhit.wav");   	// mjolnir
	precache_sound ("hipweap/mjolslap.wav");   	// mjolnir
	precache_sound ("hipweap/mjoltink.wav");   	// mjolnir
	precache_sound ("hipweap/mjolslam1.wav"); 	// mjolnir	
	precache_sound ("hipweap/mjolslam2.wav"); 	// mjolnir	
	precache_sound ("blob/hit1.wav"); 		// mjolnir	
#endif
};

float (entity ent) CheckQuad =
{
	if (ent.super_damage_finished > time)
		return TRUE;
	else return FALSE;
};

/*
========
SuperDamageSound

Plays sound if needed
========
*/
void() SuperDamageSound =
{
	if (CheckQuad(self))
	if (self.super_sound < time)
	{
		self.super_sound = time + 1;
		sound (self, CHAN_BODY, "items/damage3.wav", 1, ATTN_NORM);
	}
};

/*
void() W_SetupShot =
{
//	makevectors(self.v_angle + self.punchangle);
	makevectors (self.v_angle + (self.punchangle) ? self.punchangle : '-0.5 0 0');
	shotdir = aim (self, 1000);
//	shotdir = v_forward;
	shotorg = self.origin + self.view_ofs - v_up*6 + v_forward*15;
};
*/

void() seeker_findtargets;

/*
================
W_FireAxe
================
*/
void() W_FireAxe =
{
	local	vector	source;
	local	vector	org;
//	local	entity	otemp;
	local	float	r;

// test
	seeker_findtargets();

	makevectors (self.v_angle);
//	source = self.origin + '0 0 16';
	source = self.origin + self.view_ofs - 6*v_up;

//	traceline (source, source + v_forward*64, FALSE, self);
	weapontraceline (source, source + v_forward*64, FALSE, self);

	if (trace_fraction == 1.0)
	{
//		r = random();
//		if (r > 0.5)
//			sound (self, CHAN_WEAPON, "knight/sword2.wav", 1, ATTN_NORM);
//		else
			sound (self, CHAN_WEAPON, "knight/sword1.wav", 1, ATTN_NORM);
		return;
	}

	org = trace_endpos - v_forward*4;

	if (trace_ent.takedamage)
	{
		trace_ent.axhitme = TRUE;

		if (trace_ent.solid == SOLID_BSP || trace_ent.flags & FL_NOBLOOD)
			sound (self, CHAN_WEAPON, "player/axhit2.wav", 1, ATTN_NORM);
			
		else if (trace_ent.classname != "player")
		{
			r = random();
			if (r > 0.66)
				sound (self, CHAN_WEAPON, "player/axhit3.wav", 1, ATTN_NORM);
			else if (r > 0.33)
				sound (self, CHAN_WEAPON, "player/axhit4.wav", 1, ATTN_NORM);
			else
				sound (self, CHAN_WEAPON, "player/axhit4.wav", 1, ATTN_NORM);
		}

		SpawnBlood (trace_ent, org, '0 0 0', 20);

		if (trace_ent.solid == SOLID_BSP || trace_ent.solid == SOLID_BBOX)
		{
			if (CheckQuad(self))
				te_gunshotquad(org);
			else
				te_gunshot(org);		
		}

		if (trace_ent.classname == "monster_zombie" && !CheckQuad(self))
			T_Damage (trace_ent, self, self, 10, "");
		else
			T_Damage (trace_ent, self, self, 20, "");

	}
	else
	{	// hit wall
		sound (self, CHAN_WEAPON, "player/axhit2.wav", 1, ATTN_NORM);

		if (CheckQuad(self))
			te_gunshotquad(org);
		else
			te_gunshot(org);
	}
};

/*
================
W_FireShotgun
================
*/
void() W_FireShotgun =
{
	local vector dir;

	sound (self, CHAN_WEAPON, "weapons/guncock.wav", 1, ATTN_NORM);	

	self.punchangle_x = -2;
	
	self.currentammo = self.ammo_shells = self.ammo_shells - 1;
	dir = aim (self, 100000);

	//w_muzzleflash(self.origin + '0 16 16');
	//pointparticles(particleeffectnum("shotgun_muzzleflash"), self.origin + self.view_ofs + v_up * -8 + v_forward*20, self.velocity*15, 1);

	FireBullets (6, dir, '0.04 0.04 0');
};

/*
================
W_FireSuperShotgun
================
*/
void() W_FireSuperShotgun =
{
	local vector dir;

//	if (self.currentammo == 1)
//	{
//		W_FireShotgun ();
//		return;
//	}
		
	sound (self ,CHAN_WEAPON, "weapons/shotgn2.wav", 1, ATTN_NORM);	

	self.punchangle_x = -4;
	
	dir = aim (self, 100000);

	self.currentammo = self.ammo_shells = self.ammo_shells - 1;
	FireBullets (7, dir, '0.07 0.08 -0.07');

	if (self.currentammo == 0)
	{
		ApplyMultiDamage();
		return;
	}

	self.currentammo = self.ammo_shells = self.ammo_shells - 1;
	FireBullets (7, dir, '0.07 0.08 0.07');
	ApplyMultiDamage();
};

/*
================
W_FireSuperSpikes
================
*/
void() W_FireSuperSpikes_old =
{
	local vector	dir;
//	local entity	old;
	local vector 	offs;
	local vector 	org;
	local float	wframe;
	
	sound (self, CHAN_WEAPON, "weapons/spike2.wav", 1, ATTN_NORM);
//	self.attack_finished = time + 0.2;
	self.currentammo = self.ammo_nails = self.ammo_nails - 1;	//2
//	dir = aim (self, 1000);	//1000

	wframe = self.weaponframe;	
	switch (wframe)
	{
	  case 1:
	    offs = '0 1.1 1.1';
	    break;
	  case 2:
	    offs = '0 -1.5 0';
	    break;
	  case 3:
	    offs = '0 1.1 -1.1';
	    break;
	  case 4:
	    offs = '0 0 1.5';
	    break;
	  case 5:
	    offs = '0 -1.1 -1.1';
	    break;
	  case 6:
	    offs = '0 1.5 0';
	    break;
	  case 7:
	    offs = '0 -1.1 1.1';
	    break;
	  case 8:
	    offs = '0 0 -1.5';
	    break;
	 default:
	    offs = '0 0 0';
	    break;
	}

//	makevectors (self.v_angle + '-2 0 0');
//	dir = aim (self, 1000);	//1000
//	org = self.origin + self.view_ofs + v_forward*15 + v_right*offs_y + v_up*(offs_z - 6);

	makevectors (self.v_angle + (self.punchangle) ? self.punchangle : '-0.5 0 0');
	dir = aim (self, 1000);
	org = self.origin + self.view_ofs + v_forward*15 + v_right*offs_y + v_up*(offs_z -6);

	launch_spike (org, dir);

	newmis.touch = superspike_touch;
	newmis.classname = "supernail";		//"superspike";

	newmis.traileffectnum = particleeffectnum("TR_SPIKE");

//	setmodel (newmis, "progs/s_spike.mdl");
	newmis.skin = 1;
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);
	self.punchangle_x = -2;
};

void() W_FireSuperSpikes =
{
	local vector	dir;
	local vector 	offs;
	local vector 	org;
	local vector 	org2;
	local float	wframe;
	
	sound (self, CHAN_WEAPON, "weapons/spike2.wav", 1, ATTN_NORM);
	self.currentammo = self.ammo_nails = self.ammo_nails - 2;

	wframe = self.weaponframe;	
	switch (wframe)
	{
	     case 1:
		    offs = '0 1.2 1.2';
		    break;
	     case 2:
		    offs = '0 -1.7 0';
		    break;
	     case 3:
		    offs = '0 1.2 -1.2';
		    break;
	     case 4:
		    offs = '0 0 1.7';
		    break;
	     case 5:
		    offs = '0 -1.2 -1.2';
		    break;
	     case 6:
		    offs = '0 1.7 0';
		    break;
	     case 7:
		    offs = '0 -1.2 1.2';
		    break;
	     case 8:
		    offs = '0 0 -1.7';
		    break;

	     default:
		    offs = '0 0 0';
		    break;
	}

	makevectors (self.v_angle + (self.punchangle) ? self.punchangle : '-0.5 0 0');
	dir = aim (self, 1000);

	org = self.origin + self.view_ofs + v_forward*15 + v_right*offs_y + v_up*(offs_z - 6);
	org2 = self.origin + self.view_ofs + v_forward*15 -6*v_up;

	launch_spike (org2, dir);
	newmis.touch = FakeSpike_touch;
	newmis.classname = "supernail";
	newmis.traileffectnum = particleeffectnum("TR_SPIKE");
	newmis.skin = 1;
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);
	
	launch_spike (org, dir);
	newmis.touch = superspike_touch;
	newmis.classname = "supernail";
	newmis.traileffectnum = particleeffectnum("TR_SPIKE");
	newmis.skin = 1;
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);

	self.punchangle_x = -2;
};

/*
================
W_FireSpikes
================
*/
void(float ox) W_FireSpikes =
{
	local vector	dir;
	local vector 	org;
//	local entity	old;
	
//	makevectors (self.v_angle);
	
	if (self.ammo_nails >= 1 && self.weapon == IT_SUPER_NAILGUN)
	{
		W_FireSuperSpikes ();
//		self.attack_finished = time + 0.2;
		return;
	}

	if (self.ammo_nails < 1)
	{
		self.weapon = W_BestWeapon ();
		W_SetCurrentAmmo ();
		return;
	}

	sound (self, CHAN_WEAPON, "weapons/rocket1i.wav", 1, ATTN_NORM);

//	self.attack_finished = time + 0.2;

	self.currentammo = self.ammo_nails = self.ammo_nails - 1;

//	dir = aim (self, 1000);
//	makevectors (self.v_angle + self.punchangle);
//	dir = v_forward;
//	dprintvector(self.punchangle);
//	dprint("\n");

	makevectors (self.v_angle + (self.punchangle) ? self.punchangle : '-0.5 0 0');
//	dir = v_forward;
	dir = aim (self, 1000);
	org = self.origin + self.view_ofs - 6*v_up + v_forward*15 + v_right*ox;

	launch_spike(org, dir);

	newmis.traileffectnum = particleeffectnum("TR_SPIKE");
	newmis.classname = "nail";

//	launch_spike (self.origin + '0 0 16' + v_forward*15 + v_right*ox, dir);	//'0 0 16'

//	setmodel (newmis, "progs/s_spike.mdl");
	newmis.skin = 0;
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);		
	self.punchangle_x = -2;
};


/*
================
W_FireGrenade
================
*/
void() W_FireGrenade =
{
	local	entity missile;	//, mpuff;
	
	self.currentammo = self.ammo_rockets = self.ammo_rockets - 1;
	
	sound (self, CHAN_WEAPON, "weapons/grenade.wav", 1, ATTN_NORM);

	self.punchangle_x = -2;

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;
	missile.classname = "grenade";
		
// set missile speed	

	makevectors (self.v_angle);

	if (self.v_angle_x)
		missile.velocity = v_forward*600 + v_up*200 + crandom()*v_right*10 + crandom()*v_up*10;
	else
	{
		missile.velocity = aim(self, 10000);
		missile.velocity = missile.velocity * 600;
		missile.velocity_z = 200;
	}

	missile.angles = vectoangles(missile.velocity);
	missile.avelocity = '300 300 300';
	missile.pitch_speed = 10;
	missile.touch = GrenadeTouch;
	

// set missile duration
	missile.nextthink = time + 0.01;	//time + 2.5;
	missile.think = grenade_think;	//GrenadeExplode;
	missile.ltime = time;

	setmodel (missile, "progs/grenade.mdl");
	setsize (missile, '0 0 -4', '0 0 4');	
//	setsize (missile, '-6 -6 -6', '6 6 6');		//'0 0 0', '0 0 0'		
	setorigin (missile, self.origin);
};


/*
================
W_FireRocket
================
*/
void() W_FireRocket =
{
	local	entity	missile;	//, mpuff;
	
	self.currentammo = self.ammo_rockets = self.ammo_rockets - 1;
	
	sound (self, CHAN_WEAPON, "weapons/sgun1.wav", 1, ATTN_NORM);

	self.punchangle_x = -2;

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
	missile.classname = "missile";
		
// set missile speed	
	makevectors (self.v_angle);
	missile.velocity = aim(self, 1000);
	missile.velocity = missile.velocity*1000;
	missile.angles = vectoangles(missile.velocity);
	missile.avelocity_z = 720;
	
	missile.touch = T_MissileTouch;
	
// set missile duration
	missile.nextthink = time;
	missile.think = missile_think;
	missile.ltime = time;

//	missile.nextthink = time + 5;
//	missile.think = SUB_Remove;

	missile.dest = normalize(missile.velocity);

	setmodel (missile, "progs/missile.mdl");
	setsize (missile, '0 0 0', '0 0 0');		
	setorigin (missile, self.origin + v_forward*8 + v_up*16);

#ifdef HIPNOTIC
	newmis = missile;	
#endif
};

void() SpawnBeam =
{
	local vector org, org2, v;

	if ((time - self.ltime >= 0.08) || !(self.aiment.button0))
	{
		remove(self);
		return;
	}

	makevectors(self.aiment.v_angle + self.aiment.punchangle);

	v = normalize(self.aiment.velocity);
	v_z = 0;
//	printvector(self.aiment.velocity);

//	org = self.aiment.origin + self.aiment.view_ofs - v_up*8 + v_forward*15 - 3*v;
	org = self.aiment.origin + self.aiment.view_ofs - v_up*8 + v_forward*20 - 2*v;
	org2 = self.aiment.origin + self.aiment.view_ofs;

	traceline(org2, org2 + v_forward*600, TRUE, self.aiment);

	te_lightning2(self.aiment, org, trace_endpos);
	trailparticles(self, particleeffectnum("TR_SPIKE"), org, trace_endpos);

	self.nextthink = time + 0.01;
};

/*
================
W_FireLightning
================
*/
void() W_FireLightning =
{
	local 	vector	org, org2;
	local 	float	cells;
	local 	entity 	ent;

	if (self.ammo_cells < 1)
	{
		self.weapon = W_BestWeapon ();
		W_SetCurrentAmmo ();
		return;
	}

// explode if under water
	if (self.waterlevel > LEVEL_FEET)
	{
		cells = self.ammo_cells;
		self.ammo_cells = 0;
		W_SetCurrentAmmo ();
//		TestLightningDamage(self, self, world);
		T_RadiusDamage (self, self, 35*cells, world, "discharge");
		return;
	}

	if (self.t_width < time)
	{
		sound (self, CHAN_WEAPON, "weapons/lhit.wav", 1, ATTN_NORM);
		self.t_width = time + 0.6;
	}

//	self.punchangle_x = -2;
	self.punchangle_x = 0.7*crandom();
	self.punchangle_y = 0.7*crandom();
	self.punchangle_z = 0.7*crandom();

	self.currentammo = self.ammo_cells = self.ammo_cells - 1;

	makevectors (self.v_angle);
//	org = self.origin + '0 0 16';
	org = self.origin + self.view_ofs - v_up*6 + v_forward*15;
	org2 = self.origin + self.view_ofs;
	
	//traceline (org, org + v_forward*600, TRUE, self);
	weapontraceline (org2, org2 + v_forward*600, TRUE, self);

// create the te_lightning spawner
	ent = spawn();
	ent.movetype = MOVETYPE_FOLLOW;
	ent.aiment = self;
	ent.think = SpawnBeam;
	ent.nextthink = 1;
	ent.ltime = time;

//	te_lightning2(self, org, trace_endpos);

	LightningDamage (org, trace_endpos + v_forward*4, self, 30);	//self.origin
};

/*
============
W_Attack

An attack impulse can be triggered now
============
*/
void()	player_axe1;
void()	player_axeb1;
void()	player_axec1;
void()	player_axed1;
void()	player_shot1;
void()	player_nail1;
void()	player_light1;
void()	player_rocket1;
#ifdef HIPNOTIC
void()	player_laser1;
void()	player_hammer1;
void()	player_mjolnir1;
void() W_FireProximityGrenade;
#endif

void() W_Attack =
{
	local	float	r;

	if (!W_CheckNoAmmo ())
		return;

	makevectors(self.v_angle);	// calculate forward angle for velocity
	self.show_hostile = time + 1;	// wake monsters up

	if (self.weapon == IT_AXE)
	{
		sound (self, CHAN_WEAPON, "weapons/ax1.wav", 1, ATTN_NORM);

		r = random();
		if (r < 0.25)
			player_axe1 ();
		else if (r < 0.5)
			player_axeb1 ();
		else if (r < 0.75)
			player_axec1 ();
		else
			player_axed1 ();

		r = random();
		if (r < 0.33)
			self.weaponframe = 1;
		else if (r < 0.66)
			self.weaponframe = 5;
		else
			self.weaponframe = 9;

		self.attack_finished = time + 0.5;
	}
	else if (self.weapon == IT_SHOTGUN)
	{
		player_shot1 ();
		W_FireShotgun ();
		self.attack_finished = time + 0.5;
	}
	else if (self.weapon == IT_SUPER_SHOTGUN)
	{
		player_shot1 ();
		W_FireSuperShotgun ();
		self.attack_finished = time + 0.7;
	}
	else if (self.weapon == IT_NAILGUN)
	{
		player_nail1 ();
	}
	else if (self.weapon == IT_SUPER_NAILGUN)
	{
		player_nail1 ();
	}
	else if (self.weapon == IT_GRENADE_LAUNCHER)
	{
		player_rocket1();
		W_FireGrenade();
		self.attack_finished = time + 0.6;
	}
	else if (self.weapon == IT_ROCKET_LAUNCHER)
	{
		player_rocket1();
		W_FireRocket();
		self.attack_finished = time + 0.8;
	}
	else if (self.weapon == IT_LIGHTNING)
	{
		player_light1();
		self.attack_finished = time + 0.1;
		sound (self, CHAN_AUTO, "weapons/lstart.wav", 1, ATTN_NORM);
	}
#ifdef HIPNOTIC
	else if (self.weapon == IT_LASER_CANNON)
	{
		player_laser1();
	}
	else if (self.weapon == IT_MJOLNIR)
	{
		if (self.ammo_cells < 30)
	 		player_hammer1();
		else
	 		player_mjolnir1();
		self.attack_finished = time + 0.8;
	}
	else if (self.weapon == IT_PROXIMITY_GUN)
	{
		player_rocket1();
		W_FireProximityGrenade();
		self.attack_finished = time + 0.6;
	}
#endif
};

/*
============
W_WeaponFrame

Called every frame so impulse events can be handled as well as possible
============
*/
void() W_WeaponFrame =
{
	if (time < self.attack_finished)
		return;

	if (self.impulse)
		ImpulseCommands ();

// check for attack
	if (self.button0)
	{
		SuperDamageSound ();
		W_Attack ();
	}
};